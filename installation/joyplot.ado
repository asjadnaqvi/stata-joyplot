*! Joyplot v1.42 22 Jun 2022: y-axis was bugged in the over plot
*! Asjad Naqvi 
* v1.41 20 Jun 2022: installations fix, numerical over fix.
* v1.4  26 Apr 2022: axes reverse options added. various optimizations
* v1.3  24 Apr 2022: stacked densities added. label placement optimized. 
* v1.21 15 Apr 2022: xsize/ysize added. ylabels on right option added.
* v1.2  13 Apr 2022: xlabel angle, local normalization, lines only option added
* v1.1  07 Apr 2022: several options added
* v1.0  13 Dec 2021: first release

**********************************
* Step-by-step guide on Medium   *
**********************************

// if you want to go for even more customization, you can read this guide:

* COVID-19 visualizations with Stata Part 8: Ridgeline plots (Joy plots) (30 Oct, 2020)
* https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d


cap program drop joyplot


program joyplot, sortpreserve

version 15
 
	syntax varlist(min=1 max=2 numeric) [if] [in], over(varname) [overlap(real 6) BWIDth(string) color(string) alpha(real 80)	] ///
		[ LColor(string) LWidth(string) XLABSize(real 1.7) YLABSize(real 1.7) YLABPOSition(string) OFFset(real 0) NORMGlobal lines	] ///
		[ xticks(string) xtitle(passthru) ytitle(passthru) xangle(string) XLABColor(string) YLABColor(string) 		]  ///
		[ YLine YLColor(string) YLPattern(string) YLWidth(real 0.025) 											]  ///
		[ YREVerse XREVerse 																					] 		///
		[ title(passthru) subtitle(passthru) note(passthru) scheme(passthru) name(passthru) xsize(passthru) ysize(passthru)	]  ///
		[ allopt graphopts(string asis) * 																		] 
		
		
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}
	
	
	capture findfile labmask.ado
	if _rc != 0 {
		display as error "The {it:labmask} package is missing. Click {stata ssc install labutil, replace} to install."
		exit
	}		
	
	marksample touse, strok
	
	local length : word count `varlist'
	
	

	
////////////////////
// two variables  //
////////////////////	

if `length' == 2 {

	gettoken yvar xvar : varlist 
		
	
qui {	
cap restore	
preserve	
	keep if `touse'
	
	sort `over' `xvar' 
	cap drop _fillin
	fillin `over' `xvar' 
		
	cap drop if _fillin==1
	cap drop _fillin
	
	
	tempvar myvar // duplicate 
	gen `myvar' = `yvar' 	
	*replace `myvar' = . if `myvar' < 0   // TODO: see how to deal with negative values 
	
	
	cap confirm numeric var `over'
		if _rc!=0 {
			tempvar over2
			encode `over', gen(`over2')
			local over `over2' 
		}
		else {
			tempvar tempov over2
			egen   `over2' = group(`over')
			
			if "`: value label `over''" != "" {
				decode `over', gen(`tempov')		
				labmask `over2', val(`tempov')
			}
			local over `over2' 
		}
	
		
	if "`yreverse'" != "" {
					
		clonevar over2 = `over'
		
		summ `over'
		replace `over' = r(max) - `over' + 1
		
		if "`: value label over2'" != "" {
			tempvar group2
			decode over2, gen(`group2')			
			replace `group2' = string(over2) if `group2'==""
			labmask `over', val(`group2')
		}
		else {
			labmask `over', val(over2)
		}
	}	
	
	
	
	// normalization 
	tempvar norm
	gen double `norm' = .	
	
	if "`normglobal'" != ""   {
	
		levelsof `over', local(lvls)
		
		foreach x of local lvls {
			 summ `myvar' 
			 replace `norm' = `myvar' / r(max) if `over'==`x'
		}
	}	
		
	else  {
	
		levelsof `over', local(lvls)
		
		foreach x of local lvls {
			 summ `myvar' if `over'==`x'
			 replace `norm' = `myvar' / r(max) if `over'==`x'
		}
	}

	
	// local options
	
	if "`color'" == "" {
		local mycolor viridis
	}
	else {
		local mycolor `color'
	}
	
	if "`lcolor'" == "" {
		local linec white
	}
	else {
		local linec `lcolor'
	}
	
	if "`lwidth'" == "" {
		local linew  0.15
	}
	else {
		local linew `lwidth'
	}
	
	if "`xticks'" == "" {
		summ `xvar'
		local gap = (`r(max)' - `r(min)') / 6
		local xti  `r(min)'(`gap')`r(max)'
	}
	else {
		local xti `xticks'
	}	
	
	if "`xlabcolor'" == "" {
		local xcolor  black
	}
	else {
		local xcolor `xlabcolor'
	}	
	
	if "`ylabcolor'" == "" {
		local ycolor  black
	}
	else {
		local ycolor `ylabcolor'
	}	
	
	if "`xangle'" == "" {
		local xang  vertical
	}
	else {
		local xang `xangle'
	}	
	
	if "`ylcolor'" == "" {
		local ylc  black
	}
	else {
		local ylc  `ylcolor'
	}
	
	if "`ylpattern'" == "" {
		local ylp  solid
	}
	else {
		local ylp  `ylpattern'
	}		

	if "`bwidth'" == "" {
		local bw  0.05
	}
	else {
		local bw  `bwidth'
	}	
	
	if "`xreverse'" != "" local xrev xscale(reverse)

	// y labels 

	tempvar tag xpoint ypoint y0
	
	gen `xpoint' = .
	gen `y0' = 0
	
	egen `tag' = tag(`over')
	
	
	if ("`ylabposition'" == "") | ("`ylabposition'" == "left")  {
		qui summ `xvar'
		replace `xpoint' = r(min) - ((r(max) - r(min)) * 0.10) + `offset' if `tag'==1
	}
	if ("`ylabposition'" == "right")  {	
		qui summ `xvar'
		replace `xpoint' = r(max) + ((r(max) - r(min)) * 0.01) + `offset' if `tag'==1
	}
	
	
	gen `ypoint' = .

	local mygraph
	local yli
	
	
	levelsof `over', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {


	summ `over'
	local newx = `r(max)' + 1 - `x'   

	tempvar y`newx'
	
    lowess `norm' `xvar' if `over'==`newx', bwid(`bw') gen(`y`newx'') nograph
    
    tempvar ybot`newx' ytop`newx'
	
	 gen double `ybot`newx'' =  `newx'/ `overlap'  
	 gen double `ytop`newx'' = `y`newx'' + `ybot`newx''
	
	}
	
	summ `ybot1', meanonly
	local shift = r(mean)
	
	levelsof `over', local(lvls)
	
	foreach x of local lvls {
		replace `ybot`x'' = `ybot`x'' - `shift'
		replace `ytop`x'' = `ytop`x'' - `shift'	
		
	}	
	
	
	levelsof `over', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {


	summ `over'
	local newx = `r(max)' + 1 - `x'   
	
	if "`lines'" != "" {
		colorpalette `mycolor', n(`items') nograph
		local mygraph `mygraph' line `ytop`newx'' `xvar', lc("`r(p`newx')'") lw(`linew') ||
	}
	else {
	colorpalette `mycolor', n(`items') nograph
        local mygraph `mygraph' rarea  `ytop`newx'' `ybot`newx'' `xvar', fc("`r(p`newx')'%`alpha'") fi(100) lw(none) ||  line `ytop`newx'' `xvar', lc(`linec') lw(`linew') || 
		
	}	
		
	qui replace `ypoint' = (`ybot`newx'' + 0.02) if `tag'==1 & `over'==`newx'	
	
	
	if "`yline'" != "" {
		local yli `yli' (line `ybot`newx'' `xvar' if `over'==`newx', lp(`ylp') lc(`ylc') lw(`ylwidth')) ||
		
	}
	
}
	
	
	if "`ylabposition'" == "" | "`ylabposition'" == "left" {
		summ `xvar'
		local x1 = r(min) - ((r(max) - r(min)) * 0.12) + `offset'
		local x2 = r(max)
	}
	
	if "`ylabposition'" == "right"  {
		summ `xvar'
		local x1 = r(min) 
		local x2 = r(max) + ((r(max) - r(min)) * 0.12)  + `offset'
	
	}
	
	twoway  		///
		`yli'		///
		`mygraph'  	///
		(scatter `ypoint' `xpoint', mlabcolor(`ycolor') msize(zero) msymbol(point) mlabel(`over') mlabsize(`ylabsize') mcolor(none)) ///
		, ///
		xlabel(`xti', labcolor(`xcolor') nogrid labsize(`xlabsize') angle(`xang')) xscale(range(`x1' `x2')) `xrev' ///
		ylabel(, nolabels noticks nogrid) yscale(noline) ///
			legend(off) `title' `subtitle' `note' `xtitle' `ytitle'  ///
			`xsize' `ysize' `scheme' `name' 

restore			
	}
}



///////////////////
// one variable  //
///////////////////

if `length' == 1 {

	
qui {	
preserve	
	keep if `touse'
	
	
	// finetune the over variable
	
	cap confirm numeric var `over'

	if _rc!=0 {  // if string
		tempvar over2
		encode `over', gen(`over2')
		local over `over2' 
	}
	else {
		tempvar tempov over2
		egen   `over2' = group(`over')
		
		if "`: value label `over''" != "" {
			decode `over', gen(`tempov')		
			labmask `over2', val(`tempov')
		}
		local over `over2' 
	}
	
			
	if "`yreverse'" != "" {
					
		clonevar over2 = `over'
		
		summ `over'
		replace `over' = r(max) - `over' + 1
		
		if "`: value label over2'" != "" {
			tempvar group2
			decode over2, gen(`group2')			
			replace `group2' = string(over2) if `group2'==""
			labmask `over', val(`group2')
		}
		else {
			labmask `over', val(over2)
		}
	}		
		
		
		
	if "`bwidth'" == "" {
		local bw  2
	}
	else {
		local bw  `bwidth'
	}		
			
	
	// counters
	local dmax  = 0
	
	summ `varlist'
	
	local xrmin = r(min)
	local xrmax = r(max)
	
	
	levelsof `over', local(lvls) 
	local items = `r(r)'
	
	foreach x of local lvls {
		

		summ `over'
		local newx = `r(max)' + 1 - `x'   // reverse the sorting

		kdensity `varlist' if `over'==`x', generate(x`newx' y`newx') bwid(`bw') nograph
		
		summ y`newx', meanonly
		if r(max) > `dmax' local dmax = r(max)   // global max
	
		summ x`newx', meanonly	
			if r(min) < `xrmin' local xrmin = r(min)
			if r(max) > `xrmax' local xrmax = r(max)
	}

	// pad the minmax to avoid tight axes
	
	local pad = (`xrmax' -`xrmin') * 0.02
	
	local xrmin = `xrmin' - `pad'
	local xrmax = `xrmax' + `pad'
	
	
	
	
	// normalization 

	if "`normglobal'" != ""   {
	
		levelsof `over', local(lvls)
		
		foreach x of local lvls {
			 replace y`x' = y`x' / `dmax' 
		}
	}	
		
	else  {
	
		levelsof `over', local(lvls)
		
		foreach x of local lvls {
			 summ y`x', meanonly
			 replace y`x' = y`x' / r(max) 
		}
	}

	
	
	// local options
	
	if "`color'" == "" {
		local mycolor viridis
	}
	else {
		local mycolor `color'
	}
	
	if "`lcolor'" == "" {
		local linec white
	}
	else {
		local linec `lcolor'
	}
	
	if "`lwidth'" == "" {
		local linew  0.15
	}
	else {
		local linew `lwidth'
	}
	
	if "`xticks'" == "" {
		
		local gap = (`xrmax' - `xrmin') / 5
		local xti  `xrmin'(`gap')`xrmax'
	}
	else {
		local xti `xticks'
	}	
	
	if "`xlabcolor'" == "" {
		local xcolor  black
	}
	else {
		local xcolor `xlabcolor'
	}	
	
	if "`ylabcolor'" == "" {
		local ycolor  black
	}
	else {
		local ycolor `ylabcolor'
	}	
	
	if "`xangle'" == "" {
		local xang  vertical
	}
	else {
		local xang `xangle'
	}	

	if "`ylcolor'" == "" {
		local ylc  black
	}
	else {
		local ylc  `ylcolor'
	}
	
	if "`ylpattern'" == "" {
		local ylp  solid
	}
	else {
		local ylp  `ylpattern'
	}
	
	if "`xreverse'" != "" local xrev xscale(reverse)

	// y labels 

	tempvar tag xpoint ypoint y0
	
	gen `xpoint' = .
	gen `y0' = 0
	
	egen `tag' = tag(`over')
	
	
	if ("`ylabposition'" == "") | ("`ylabposition'" == "left") {
		replace `xpoint' = `xrmin' - ((`xrmax' - `xrmin') * 0.10) + `offset' if `tag'==1
	}
	if ("`ylabposition'" == "right")  {	
		replace `xpoint' = `xrmax' + ((`xrmax' - `xrmin') * 0.01) + `offset' if `tag'==1
	}
	
	
	
	gen `ypoint' = .

	local mygraph
	local yli
	
	
	levelsof `over', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {


		summ `over'
		local newx = r(max) + 1 - `x'   

		
		tempvar ybot`newx' ytop`newx'
		
		 gen double `ybot`newx'' =  `newx' / `overlap'     // if  y`newx'!=.
		 gen double `ytop`newx'' = y`newx' + `ybot`newx''  // if  y`newx'!=.
	
	}
	
	
	
	
	summ `ybot1', meanonly
	local shift = r(mean)
	
	levelsof `over', local(lvls)
	
	foreach x of local lvls {
		replace `ybot`x'' = `ybot`x'' - `shift'
		replace `ytop`x'' = `ytop`x'' - `shift'	
	}
	
	
	levelsof `over', local(lvls)
	local items = `r(r)'
	
	foreach x of local lvls {


		summ `over'
		local newx = r(max) + 1 - `x'   	
		
		if "`lines'" != "" {
			colorpalette `mycolor', n(`items') nograph
			local mygraph `mygraph' line `ytop`newx'' `x`newx'', lc("`r(p`newx')'") lw(`linew') ||
		}
		else {
			colorpalette `mycolor', n(`items') nograph
			local mygraph `mygraph' rarea  `ytop`newx'' `ybot`newx'' x`newx', fc("`r(p`newx')'%`alpha'") fi(100) lw(none) ||  line `ytop`newx'' x`newx', lc(`linec') lw(`linew') || 
			
		}	
			
		qui replace `ypoint' = (`ybot`newx'' + 0.02) if `tag'==1 & `over'==`newx'	
		
		if "`yline'" != "" {
			
			summ `ybot`newx'', meanonly
			local yvalue = r(mean)
			
			
			local yli `yli' (pci `yvalue' `xrmin' `yvalue' `xrmax' , lp(`ylp') lc(`ylc') lw(`ylwidth')) ||
		
		}		

	}
	
	
	if "`ylabposition'" == "" | "`ylabposition'" == "left" {
		local x1 = `xrmin' - ((`xrmax' - `xrmin') * 0.12) + `offset'
		local x2 = `xrmax'
	}
	
	if "`ylabposition'" == "right"  {
		local x1 = `xrmin' 
		local x2 = `xrmax' + ((`xrmax' - `xrmin') * 0.12) + `offset'
	
	}
	
	
	twoway  ///
		`yli'	   ///
		`mygraph'  ///
		(scatter `ypoint' `xpoint', mlabcolor(`ycolor') msize(zero) msymbol(point) mlabel(`over') mlabsize(`ylabsize') mcolor(none)) ///
		, ///
			xlabel(`xti', labcolor(`xcolor') nogrid labsize(`xlabsize') angle(`xang')) xscale(range(`x1' `x2'))  ///  
			ylabel(, nolabels noticks nogrid) yscale(noline) ///
			legend(off) `title' `subtitle' `note' `xtitle' `ytitle' `xrev'  ///
			`xsize' `ysize' `scheme' `name' 
		
		
	restore			
	}
}



end



*********************************
******** END OF PROGRAM *********
*********************************


