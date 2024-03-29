*! joyplot v1.71 (03 Oct 2023)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.71 (03 Oct 2023): Fixed a bug in single density joyplots for incorrect locals. Fixed a bugs in lines. Added n() option.
* v1.7  (14 Jul 2023): xline(), saving(), peaks, peaksize() options added. ridgeline duplicates joyplot.
* v1.62 (28 May 2023): change over() to by() to align it with other packages. added offset() and laboffset()
* v1.61 (01 Mar 2023): ylabel in densities fixed. normalize in densities fixed.
* v1.6  (05 Nov 2022): bug fixes
* v1.5  (03 Sep 2022): bandwidth fixed. xlabel is now passthru. defaults updated.
* v1.42 (22 Jun 2022): y-axis was bugged in the over plot
* v1.41 (20 Jun 2022): installations fix, numerical over fix.
* v1.4  (26 Apr 2022): axes reverse options added. various optimizations
* v1.3  (24 Apr 2022): stacked densities added. label placement optimized. 
* v1.21 (15 Apr 2022): xsize/ysize added. ylabels on right option added.
* v1.2  (13 Apr 2022): xlabel angle, local normalization, lines only option added
* v1.1  (07 Apr 2022): several options added
* v1.0  (13 Dec 2021): first release

**********************************
* Step-by-step guide on Medium   *
**********************************

// if you want to go for even more customization, you can read this guide:

* COVID-19 visualizations with Stata Part 8: Ridgeline plots (Joy plots) (30 Oct, 2020)
* https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d


cap program drop joyplot


program joyplot, sortpreserve rclass

version 15
 
	syntax varlist(min=1 max=2 numeric) [if] [in], by(varname) [overlap(real 6) BWIDth(real 0.5) palette(string) alpha(real 80)  lines		] ///
		[ LColor(string) LWidth(string) YLABColor(string) YLABSize(real 1.7) YLABPOSition(string) 									] ///
		[ YLine YLColor(string) YLPattern(string) YLWidth(real 0.04) YREVerse XREVerse 												] ///
		[ xtitle(passthru) ytitle(passthru) xlabel(passthru) title(passthru) subtitle(passthru) note(passthru)	     				] ///
		[ scheme(passthru) name(passthru) aspect(passthru) xsize(passthru) ysize(passthru)											] ///
		[ NORMalize(str) rescale droplow  ] ///  // v1.6 options
		[ LABOFFset(real 0) OFFset(real 0) ]  ///  // v1.62 options
		[ xline(passthru) saving(passthru) PEAKs peaksize(real 0.2) ] ///    // v1.7 options
		[ n(real 50) ]  // v1.71 options
		
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}
	
	
	capture findfile labmask.ado
	if _rc != 0 {
		qui ssc install labutil, replace
		exit
	}
	
	if `overlap' < 1 {
		display as error "overlap() should be >= 1"
		exit
	}

	// local options

	if "`lcolor'" 	 == "" local lcolor 	white
	if "`lwidth'" 	 == "" local lwidth 	0.15
	if "`ylabcolor'" == "" local ylabcolor 	black	
	if "`ylcolor'"	 == "" local ylcolor  	black	
	if "`ylpattern'" == "" local ylpattern  solid
	if "`xreverse'"  != "" local xreverse 	xscale(reverse)		
	if "`palette'" == "" {
		local palette CET C1	
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}	
	

	marksample touse, strok
	
	local length : word count `varlist'

	
////////////////////
// two variables  //
////////////////////	

if `length' == 2 {

	gettoken yvar xvar : varlist 
		
	
qui {	
	preserve	
	
	keep if `touse'
	
	gen ones = 1
	bysort `by': egen counts = sum(ones)
	egen tag = tag(`by')
	summ counts, meanonly
	 
	if r(min) < 10 {
		if "`droplow'" == "" {	
			count if counts < 10 & tag==1
			di as error "Groups with errors:"
			noi list `by' if counts < 10 & tag==1
			di as error "`r(N)' over group(s) (`by') have fewer than 10 observations. Either clean them manually or use the {it:droplow} option to automatically filter them out."
			exit
		}	
		else {
			count
			local obstot = r(N)
			
			count if counts < 10
			local obsdrop = r(N)
			
			drop if counts < 10
			
			local obsdiff = `obstot' - `obsdrop'
			di in yellow "Out of `obstot' observations, `obsdrop' dropped. `obsdiff' observations remaining."
			
		}
	}
	
	
	count
	if r(N) == 0 {
		di as error "All observations dropped. No groups fulfill the criteria for {stata help joyplot:joyplot}."
		exit
	}
	

	drop ones tag counts
	
	sort `by' `xvar' 
	cap drop _fillin
	fillin `by' `xvar' 

	cap drop _fillin
	
	
	tempvar myvar // duplicate 
	gen `myvar' = `yvar' 	
	replace `myvar' = . if `myvar' < 0   // TODO: see how to deal with negative values. v1.6: Suggest rescale option
	
	
	cap confirm numeric var `by'
		if _rc!=0 {
			tempvar over2
			encode `by', gen(`over2')
			local by `over2' 
		}
		else {
			tempvar tempov over2
			egen   `over2' = group(`by')
			
			if "`: value label `by''" != "" {
				decode `by', gen(`tempov')		
				labmask `over2', val(`tempov')
			}
			local by `over2' 
		}
	
		
	if "`yreverse'" != "" {
					
		clonevar over2 = `by'
		
		summ `by', meanonly
		replace `by' = r(max) - `by' + 1
		
		if "`: value label over2'" != "" {
			tempvar group2
			decode over2, gen(`group2')			
			replace `group2' = string(over2) if `group2'==""
			labmask `by', val(`group2')
		}
		else {
			labmask `by', val(over2)
		}
	}	
	
	
	// rescale v1.6 added
	
	if "`rescale'" != "" {
		summ `myvar', meanonly
		local gmin = r(min)
		local gmax = r(max)
		
		return local jmin `"`gmin'"'
		return local jmax `"`gmax'"'
	
		tempvar myvar2
		gen double `myvar2' = `myvar' - `gmin'
		local myvar `myvar2'
		
		noi di in yellow "Ridgelines have been rescaled to start from the minimum value. Values range from `gmin' to `gmax' (see {stata return list})."
	}
	
	
	// normalization v1.6 fix
	
	tempvar norm
	gen double `norm' = .	
	
	if "`normalize'" == "global" |  "`normalize'" == ""  {
	
		levelsof `by', local(lvls)
		
		foreach x of local lvls {
			 summ `myvar', meanonly
			 replace `norm' = `myvar' / r(max) if `by'==`x'
		}
	}	
		
	else  {
	
		levelsof `by', local(lvls)
		
		foreach x of local lvls {
			 summ `myvar' if `by'==`x', meanonly
			 replace `norm' = `myvar' / r(max) if `by'==`x'
		}
	}

	

	// y labels 

	tempvar tag xpoint ypoint y0
	
	gen `xpoint' = .
	gen `y0' = 0
	
	egen `tag' = tag(`by')
	
	
	if ("`ylabposition'" == "") | ("`ylabposition'" == "left")  {
		qui summ `xvar', meanonly
		replace `xpoint' = r(min) - ((r(max) - r(min)) * 0.10) + `laboffset' if `tag'==1
	}
	if ("`ylabposition'" == "right")  {	
		qui summ `xvar', meanonly
		replace `xpoint' = r(max) + ((r(max) - r(min)) * 0.01) + `laboffset' if `tag'==1
	}
	
	
	gen `ypoint' = .

	local mygraph
	local yli
	
	
	levelsof `by', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {


	summ `by', meanonly
	local newx = r(max) + 1 - `x'   

	tempvar y`newx'
	
    lowess `norm' `xvar' if `by'==`newx', bwid(`bwidth') gen(`y`newx'') nograph
    
    tempvar ybot`newx' ytop`newx'
	
	 gen double `ybot`newx'' =  `newx'/ `overlap'  
	 gen double `ytop`newx'' = `y`newx'' + `ybot`newx''
	 
	 if "`peaks'" != "" {
	 	summ `ytop`newx'', meanonly
		gen peak`newx' = 1 if `ytop`newx''==r(max)
	 }
	
	}
	
	summ `ybot1', meanonly
	local shift = r(mean)
	
	levelsof `by', local(lvls)
	
	foreach x of local lvls {
		replace `ybot`x'' = `ybot`x'' - `shift'
		replace `ytop`x'' = `ytop`x'' - `shift'	
		
		
		
		
	}	
	
	
	levelsof `by', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {


		summ `by', meanonly
		local newx = r(max) + 1 - `x'   
	
		if "`lines'" != "" {
			colorpalette `palette', n(`items') nograph `poptions'
			local mygraph `mygraph' line `ytop`newx'' `xvar', lc("`r(p`newx')'") lw(`lwidth') ||
		}
		else {
			colorpalette `palette', n(`items') nograph `poptions'
			local mygraph `mygraph' rarea  `ytop`newx'' `ybot`newx'' `xvar', fc("`r(p`newx')'%`alpha'") fi(100) lw(none) ||  line `ytop`newx'' `xvar', lc(`lcolor') lw(`lwidth') || 
			
		}	
		
		replace `ypoint' = (`ybot`newx'' + 0.02) if `tag'==1 & `by'==`newx'	
		
		if "`yline'" != "" {
			local yli `yli' (line `ybot`newx'' `xvar' if `by'==`newx', lp(`ylpattern') lc(`ylcolor') lw(`ylwidth')) ||
			
		}
		
		
		if "`peaks'"!= "" {
			local mypeaks `mypeaks' (scatter `ytop`newx'' `xvar' if peak`newx'==1 , msym(circle) msize(`peaksize') mcolor(black)) ||
		
		}		
	
	}
	
	
	if "`ylabposition'" == "" | "`ylabposition'" == "left" {
		summ `xvar', meanonly
		local x1 = r(min) - ((r(max) - r(min)) * (`offset' / 100)) + `laboffset'
		local x2 = r(max)
	}
	
	if "`ylabposition'" == "right"  {
		summ `xvar', meanonly
		local x1 = r(min) 
		local x2 = r(max) + ((r(max) - r(min)) * (`offset' / 100))  + `laboffset'
	
	}
	
	twoway  		///
		`yli'		///
		`mygraph'  	///
		`mypeaks'     ///
		(scatter `ypoint' `xpoint', mcolor(none) mlabcolor(`ylabcolor') mlabel(`by') mlabsize(`ylabsize') ) ///
		, ///
			`xlabel' xscale(range(`x1' `x2')) `xreverse' ///
			ylabel(, nolabels noticks nogrid) yscale(noline) ///
				legend(off) ///
				`title' `subtitle' `xtitle' `ytitle' `note' `xline' ///
				`aspect' `xsize' `ysize' `scheme' `name' `saving'
				
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
	keep `varlist' `by'
	
	gen ones = 1
	bysort `by': egen counts = sum(ones)
	egen tag = tag(`by')
	summ counts, meanonly
	 
	if r(min) < 10 {
		if "`droplow'" == "" {	
			count if counts < 10 & tag==1
			di as error "Groups with errors:"
			noi list `by' if counts < 10 & tag==1
			di as error "`r(N)' over group(s) (`by') have fewer than 10 observations. Either clean them manually or use the {it:droplow} option to automatically filter them out."
			exit
		}	
		else {
			count
			local obstot = r(N)
			
			count if counts < 10
			local obsdrop = r(N)
			
			drop if counts < 10
			
			local obsdiff = `obstot' - `obsdrop'
			noi di in yellow "Out of `obstot' observations, `obsdrop' dropped. `obsdiff' observations remaining."
			
		}
	}
	
	count
	if r(N) == 0 {
		di as error "All observations dropped. No groups fulfill the criteria for {stata help joyplot:joyplot}."
		exit
	}
	
	drop ones tag counts	
	

	// finetune the over variable
	
	cap confirm numeric var `by'

	if _rc!=0 {  // if string
		tempvar over2
		encode `by', gen(`over2')
		local by `over2' 
	}
	else {
			
		tempvar tempov over2
		egen   `over2' = group(`by')   // group the categories
		
		
		if "`: value label `by''" != "" {
			decode `by', gen(`tempov')		
			labmask `over2', val(`tempov')
		}
		else {
			tempvar bynames
			gen `bynames' = string(`by')
			labmask `over2', val(`bynames')
		}
		
		local by `over2' 
	}
	
			
	if "`yreverse'" != "" {
					
		clonevar over2 = `by'
		
		summ `by', meanonly
		replace `by' = r(max) - `by' + 1
		
		if "`: value label over2'" != "" {
			tempvar group2
			decode over2, gen(`group2')			
			replace `group2' = string(over2) if `group2'==""
			labmask `by', val(`group2')
		}
		else {
			labmask `by', val(over2)
		}
	}		
		


	
	// counters
	local dmax  = 0
	
	summ `varlist', meanonly
	
	local xrmin = r(min)
	local xrmax = r(max)
	
	
	levelsof `by', local(lvls) 
	local items = `r(r)'
	
	foreach x of local lvls {
		

		summ `by', meanonly
		local newx = r(max) + 1 - `x'   // reverse the sorting

		kdensity `varlist' if `by'==`x', generate(x`newx' y`newx') bwid(`bwidth') n(`n') nograph
		
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
	if "`normalize'" == "" | "`normalize'" == "global"  {
	
		levelsof `by', local(lvls)
		
		foreach x of local lvls {
			 replace y`x' = y`x' / `dmax' 
		}
	}	
		
	if "`normalize'" == "local"  {
	
		levelsof `by', local(lvls)
		
		foreach x of local lvls {
			 summ y`x', meanonly
			 replace y`x' = y`x' / r(max) 
		}
	}

	// y labels 

	tempvar tag xpoint ypoint y0
	
	gen `xpoint' = .
	gen `y0' = 0
	
	egen `tag' = tag(`by')
	
	
	if ("`ylabposition'" == "") | ("`ylabposition'" == "left") {
		replace `xpoint' = `xrmin' - ((`xrmax' - `xrmin') * 0.10) + `offset' if `tag'==1
	}
	if ("`ylabposition'" == "right")  {	
		replace `xpoint' = `xrmax' + ((`xrmax' - `xrmin') * 0.01) + `offset' if `tag'==1
	}
	
	
	gen `ypoint' = .

	local mygraph
	local yli
	
	
	levelsof `by', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {

		summ `by', meanonly
		local newx = r(max) + 1 - `x'   

		
		tempvar ybot`newx' ytop`newx'
		
		 gen double `ybot`newx'' =  `newx' / `overlap'     // if  y`newx'!=.
		 gen double `ytop`newx'' = y`newx' + `ybot`newx''  // if  y`newx'!=.
	
		if "`peaks'"!="" {
			summ `ytop`newx'', meanonly
			gen peak`newx' = 1 if `ytop`newx''== r(max)
		}
	}
	
	
	summ `ybot1', meanonly
	local shift = r(mean)
	
	levelsof `by', local(lvls)
	
	foreach x of local lvls {
		replace `ybot`x'' = `ybot`x'' - `shift'
		replace `ytop`x'' = `ytop`x'' - `shift'	
	}
	
	
	
	
	levelsof `by', local(lvls)
	local items = `r(r)'

	
	foreach x of local lvls {


		summ `by', meanonly
		local newx = r(max) + 1 - `x'   	
		
		if "`lines'" != "" {
			colorpalette `palette', n(`items') nograph `poptions'
			local mygraph `mygraph' line `ytop`newx'' x`newx', lc("`r(p`newx')'") lw(`lwidth') ||
		}
		else {
			colorpalette `palette', n(`items') nograph `poptions'
			local mygraph `mygraph' rarea  `ytop`newx'' `ybot`newx'' x`newx', fc("`r(p`newx')'%`alpha'") fi(100) lw(none) ||  line `ytop`newx'' x`newx', lc(`lcolor') lw(`lwidth') || 
			
		}	
			
		qui replace `ypoint' = (`ybot`newx'' + 0.02) if `tag'==1 & `by'==`x'	
		
		if "`yline'" != "" {
			
			summ `ybot`newx'', meanonly
			local yvalue = r(mean)
			
			local yli `yli' (pci `yvalue' `xrmin' `yvalue' `xrmax', lp(`ylpattern') lc(`ylcolor') lw(`ylwidth')) ||
		
		}
		
		if "`peaks'"!= "" {
		
			local mypeaks `mypeaks' (scatter `ytop`newx'' x`newx' if peak`newx'==1 , msym(circle) msize(`peaksize') mcolor(black)) ||
		
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
		`yli'	    ///
		`mygraph'   ///
		`mypeaks'		///
		(scatter `ypoint' `xpoint', mcolor(none) mlabcolor(`ylabcolor') mlabel(`by') mlabsize(`ylabsize') ) ///
		, ///
			`xlabel' xscale(range(`x1' `x2'))  ///  
			ylabel(, nolabels noticks nogrid) yscale(noline) ///
			legend(off) ///
			`title' `subtitle'  `xtitle' `ytitle' `xrev' `note' `xline'  ///
			`aspect' `xsize' `ysize' `scheme' `name' `saving'
		
		
	restore			
	}

	
}


end



*********************************
******** END OF PROGRAM *********
*********************************








