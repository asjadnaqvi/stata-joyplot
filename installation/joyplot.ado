*! Joyplot v1.2 Naqvi 13.Apr.2022: 
*! xlabel angle, local normalization, lines only option added
* v1.1 07.Apr.2022: options added
* v1.0 13.Dec.2021: first release

**********************************
* Step-by-step guide on Medium   *
**********************************

// if you want to go for even more customization, you can read this guide:

* COVID-19 visualizations with Stata Part 8: Ridgeline plots (Joy plots) (30 Oct, 2020)
* https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d


cap program drop joyplot


program joyplot, sortpreserve

version 15
 
	syntax varlist(min=2 max=2 numeric) [if] [in], over(varname) [overlap(real 6) BWIDth(real 0.05) color(string) alpha(real 80)] ///
		[ LColor(string) LWidth(string) XLABSize(real 1.7) YLABSize(real 1.7) OFFset(real 0) NORMGlobal lines	]  ///
		[ xticks(string) xtitle(string) ytitle(string) xangle(string) XLABColor(string) YLABColor(string)		]  ///
		[ title(string) subtitle(string) note(string)  scheme(string)											]  ///
		[  allopt graphopts(string asis) * 																		] 
		
		
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}	
	
	marksample touse, strok
	gettoken yvar xvar : varlist 
	
qui {	
cap restore	
preserve	
	keep if `touse'
	
	sort `over' `xvar' 
	cap drop _fillin
	fillin `over' `xvar' // complete the series for the labels
	
	

	tempvar myvar 
	gen `myvar' = `yvar' 
	cap drop if _fillin==1
	cap drop _fillin

	replace `myvar' = . if `myvar' < 0   // TODO: see how to deal with negative values 
	
	
	cap confirm numeric var `over'
		if _rc!=0 {
			tempvar over2
			encode `over', gen(`over2')
			local over `over2' 
		}
	
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
		local gap = round((`r(max)' - `r(min)') / 10)
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


	

	tempvar tag xpoint ypoint y0
	
	 gen `y0' = 0
	
	egen `tag' = tag(`over')
	qui summ `xvar'
	 gen `xpoint' = r(min) - 20 + `offset' if `tag'==1
	 gen `ypoint' = .


	local mygraph
	
	
	levelsof `over', local(lvls)
	local items = `r(r)'

	foreach x of local lvls {


	summ `over'
	local newx = `r(max)' + 1 - `x'   

	tempvar y`newx'
	
    lowess `norm' `xvar' if `over'==`newx', bwid(`bwidth') gen(`y`newx'') nograph
    
    tempvar ybot`newx' ytop`newx'
	
	 gen `ybot`newx'' =  `newx'/ `overlap'  
	 gen `ytop`newx'' = `y`newx'' + `ybot`newx''
	
	
	if "`lines'" != "" {
		colorpalette `mycolor', n(`items') nograph
		local mygraph `mygraph' line `ytop`newx'' `xvar', lc("`r(p`newx')'") lw(`linew') ||
	}
	else {
	colorpalette `mycolor', n(`items') nograph
        local mygraph `mygraph' rarea  `ytop`newx'' `ybot`newx'' `xvar', fc("`r(p`newx')'%`alpha'") fi(100) lw(none) ||  line `ytop`newx'' `xvar', lc(`linec') lw(`linew') || 
		
	}	
		
	qui replace `ypoint' = (`ybot`newx'' + 0.01) if `xpoint'!=. & `over'==`newx'	
}
	
	
	summ `xvar' 
	local x1 = r(min) - 20 + `offset'
	local x2 = r(max)
	
	twoway  ///
		`mygraph'  ///
		(scatter `ypoint' `xpoint', mlabcolor(`ycolor') msize(zero) msymbol(point) mlabel(`over') mlabsize(`ylabsize') mcolor(none)) ///
	, ///
	xlabel(`xti', labcolor(`xcolor') nogrid labsize(`xlabsize') angle(`xang')) ///
	ylabel(, nolabels noticks nogrid) yscale(noline)   ///
	legend(off) title(`title') subtitle(`subtitle') note(`note') xtitle(`xtitle') ytitle(`ytitle') scheme(`scheme')

restore			
	}

	
end



*********************************
******** END OF PROGRAM *********
*********************************
