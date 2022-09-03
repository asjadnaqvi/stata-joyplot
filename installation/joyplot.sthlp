{smcl}
{* 03September2022}{...}
{hi:help joyplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-joyplot":joyplot v1.5 (GitHub)}}

{hline}

{title:joyplot}: A Stata package for ridgeline plots. 

The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d":Ridgeline plots (Joy plots)}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:joyplot} {it:y} {it:[x]} {ifin}, {cmd:over}({it:variable}) {cmd:[} {cmd:overlap}({it:num}) {cmdab:bwid:th}({it:num}) {cmd:color}({it:str}) {cmd:alpha}({it:num}) {cmdab:off:set}({it:num}) {cmdab:normg:lobal} {cmd:lines} 
					{cmdab:lw:idth}({it:num}) {cmdab:lc:olor}({it:str}) {cmdab:ylabs:ize}({it:num}) {cmdab:ylabc:olor}({it:str}) {cmdab:ylabpos:ition}({it:str})
					{cmdab:yl:ine} {cmdab:ylc:olor}({it:str}) {cmdab:ylw:idth}({it:str}) {cmdab:ylp:attern}({it:str}) {cmdab:xrev:erse} {cmdab:yrev:erse} 
					{cmd:xtitle}({it:str}) {cmd:ytitle}({it:str})  {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:xlabel}({it:str})
					{cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str})   {cmd:]}


{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt joyplot y [x]}}The command requires a numeric {it:y} variable and an optional numeric {it:x} variable. If {it:x} is not specified, then overlapping densities for {it:y} are drawn. 
If x is specified, a lowess fit between {it:y} and {it:x} is performed. Usually {it:x} represents a time variable.{p_end}

{p2coldent : {opt over(variable)}}This is the group variable that defines the joyplot layers.{p_end}

{p2coldent : {opt bwid:th(value)}}A higher bandwidth value will result in higher smoothing. The default value is {it:0.5}.
This value might need adjustment depending on the data. Note that if you use {cmd:joyplot} and the ridge lines do not appear, then the bandwidth certainly needs adjustment.
 In this case, increase the bandwidth.{p_end}

{p2coldent : {opt overlap(value)}}A higher value increases the overlap, and the height of the joyplots. The default value is {it:6}, and the minimum allowed value is 1.{p_end}

{p2coldent : {opt color(string)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette CET C1:{it:CET C1}}. 
Here, one can also pass single colors, for example, {it:color(black)}.{p_end}

{p2coldent : {opt alpha(value)}}Alpha is used to change the transparency of the area fills. Default value is {it:80} for 80% transparency.{p_end}

{p2coldent : {opt normg:lobal}}Normalize by the global maximum of the {it:y} variable.{p_end}

{p2coldent : {opt lines}}Draw colored lines instead of area fills. This option is much faster since area fills are computationally intensive. The option {cmdab:lc:olor()} does not work here. 
Instead define the line colors using the {cmd:color()} option. The option {cmdab:lw:idth()} is allowed.{p_end}

{p2coldent : {opt xrev:erse}, {opt yrev:erse}}Reverse the x and y axes. While reversing the y-axis might be desireable, for example, to change the alphabetical order of the categories, xreverse should be used with caution.{p_end}

{p 4 4 2}
{it:{ul:Fine tuning}}

{p2coldent : {opt lc:olor(string)}}The outline color of the area fills. Default is {it:white}.{p_end}

{p2coldent : {opt lw:idth(value)}}The outline width of the area fills. Default is {it:0.15}.{p_end}

{p2coldent : {opt yl:ine}}Enable showing the reference y-axis grids lines.{p_end}

{p2coldent : {opt ylc:olor(string)}}The color of the y-axis grids lines. Default is {it:black}.{p_end}

{p2coldent : {opt ylw:idth(value)}}The width of the y-axis grids lines. Default is {it:0.04}.{p_end}

{p2coldent : {opt ylp:attern(string)}}The pattern of the y-axis grids lines. Default is {it:solid}.{p_end}

{p2coldent : {opt ylabpos:ition(string)}}The position of the y-axis labels takes on the values {it:left} or {it:right}. The default orientation is {it:left}.{p_end}

{p2coldent : {opt offset(value)}}This option is used for offseting the labels on the y-axis. Default is {it:0}. A higher offsetting can be achieved by providing a value, for example,
 {it:offset(-20)} will move the labels more left if the label has a {it:left} orientation.
 Since the labels are oriented to the left of a marker, they might extend into the margin.{p_end}


{p2coldent : {opt xtitle()}, {opt ytitle()}, {opt xlabel()}}These are standard twoway graph options.{p_end}

{p2coldent : {opt title()}, {opt subtitle()}, {opt note()}}These are standard twoway graph options.{p_end}

{p2coldent : {opt xsize()}, {opt ysize()}, {opt name()}}These are standard twoway graph options for changing the dimensions of the graphs.{p_end}

{p2coldent : {opt scheme()}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}


{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018) is required for {cmd:joyplot}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

- Load the data and clean it up:

use "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/OWID_data.dta?raw=true", clear

{stata keep if group10==1}
{stata keep country date new_cases}

{stata joyplot new_cases date, over(country)}

{stata joyplot new_cases date if date > 22460, over(country)}

{stata joyplot new_cases date if date > 22460, over(country) yline} (v1.3)

{stata joyplot new_cases date if date > 22460, over(country) lc(black) color(white) alpha(100)}

{stata joyplot new_cases date if date > 22460, over(country) lc(white) color(black) alpha(50) lw(0.05)}

{stata joyplot new_cases date if date > 22460, over(country) lines lw(0.2)}

{stata joyplot new_cases date if date > 22460, over(country) lines lw(0.2) color(black)}


- {it:With normalization (v1.2)}

{stata joyplot new_cases date if date > 22460, over(country) normg}

{stata joyplot new_cases date if date > 22460, over(country) normg overlap(15) xangle(45)}

{stata joyplot new_cases date if date > 22460, over(country) normg overlap(15) xangle(45) lines}

{stata joyplot new_cases date if date > 22460, over(country) bwid(0.1) off(-20) overlap(10) lw(none)}


- {it:y label orientiation and graph sizes (v1.21)}

{stata joyplot new_cases date if date > 22460, over(country) lines lw(0.2) ylabpos(right)}

{stata joyplot new_cases date if date > 22460, over(country)  lw(0.2) ylabpos(right) xsize(5) ysize(7)}


- {it:With custom dates}

qui summ date if date > 22460

local xmin = r(min)
local xmax = r(max)


joyplot new_cases date if date > 22460, over(country) overlap(8) color(CET C1) alpha(100) ///
	lc(white) lw(0.2) xticks(`xmin'(30)`xmax') off(-30) ///
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("Some more text here")  ///
	note("Some text here", size(vsmall)) 


- {it:With a custom graph scheme}

The example below uses the {stata ssc install schemepack, replace:schemepack} suite and loads the {stata set scheme neon:neon} which has a black background. Here we need to fix some colors:

qui summ date if date > 22460

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22460, over(country) overlap(8) color(CET C1) alpha(90) ///
	lc(black) lw(0.1) xticks(`xmin'(60)`xmax') off(-30) ///
	ylabc(white) xlabc(white) /// 
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("a subtitle here", color(white)) ///
	note("Some text here", size(vsmall)) scheme(neon)


- {it:The Joy Division look:}

qui summ date if date > 22425

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22425, over(country) overlap(8) color(black) alpha(100) bwid(0.1) ///
	lc(white) lw(0.2) xticks(`xmin' `xmax') off(+20) ///
	ylabc(none) xlabc(none) xangle(0) /// 
	xtitle("") ytitle("") ///
	title("{fontface Arial Bold:The Joy Division look}") scheme(neon)


- {it:With stacked densities (v1.3)}

use "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/us_meantemp.dta?raw=true", clear

{stata joyplot meantemp, over(month)}

{stata joyplot meantemp, over(month)  yline ylw(0.2) ylc(blue) ylp(dot)}


- {it:With axis reversal (v1.4)}

{stata joyplot meantemp, over(month) yline yrev }

{stata joyplot meantemp, over(month) yline xrev }

joyplot meantemp, over(month) bwid(1.5) xlabs(3) ylabs(3) overlap(3) yline normg yrev ///
	ytitle("Month") xtitle("degrees Centigrade") ///
	title("Mean average temperature in the USA") subtitle("2009-2020 average") ///
	note("Source: World Bank Climate Change Knowledge Portal (CCKP).", size(vsmall)) ///
		xsize(3) ysize(5)


qui summ meantemp 

	local xmin = r(min)
	local xmax = r(max)

	joyplot meantemp, over(month) bwid(1.5) xlabs(3) ylabs(3) overlap(3) yline normg color(cividis) alpha(100) ///
		ytitle("Month") xtitle("degrees Centigrade") xticks(`xmin'(10)`xmax') ///
		title("Mean average temperature in the USA") subtitle("2009-2020 average") ///
		note("Source: World Bank Climate Change Knowledge Portal (CCKP).", size(vsmall)) ///
			xsize(3) ysize(5)


{hline}

{title:Version history}

- {bf:1.5} : Major code clean-up. Default values optimized. Redundant options removed.
- {bf:1.42}: Fix a bug in the y-axis
- {bf:1.41}: Fixed the dependency package installations. Joyplot can now take numeric {it:over} values.
- {bf:1.4} : The options to reverse x and y axes added. Graph saving option added. Several bug fixes and optimizations.
- {bf:1.3} : Density stacking added. y-axis grid lines added. Placement of labels optimized.
- {bf:1.21}: xsize and ysize options added. Labels on left-side options added.
- {bf:1.2} : x-axis angle option added. Global normalization option added. Draw lines only option added.
- {bf:1.1} : Code cleanup. Various options added.
- {bf:1.0} : First version.



{title:Package details}

Version      : {bf:joyplot} v1.5
This release : 03 Sep 2022
First release: 13 Dec 2021
Repository   : {browse "https://github.com/asjadnaqvi/joyplot":GitHub}
Keywords     : Stata, graph, joyplot, ridgeline plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Acknowledgements}

GitHub users {it:johnchin14} and {it:van-alfen} suggested several enhancements to the code. {it:van-alfen} also reported package errors. Ka Lok Wong uncovered an issue with bandwidths.


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-joyplot/issues":GitHub} by opening a new issue.

{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


