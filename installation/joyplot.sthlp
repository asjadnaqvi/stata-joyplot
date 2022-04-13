{smcl}
{* 14April2022}{...}
{hi:help joyplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-joyplot":joyplot v1.2 (GitHub)}}

{hline}

{title:joyplot}: A Stata package for ridgeline plots. 

{p 4 4 2}
The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d":Ridgeline plots (Joy plots)}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:joyplot} {it:y x} {ifin}, {cmd:over}({it:variable}) {cmd:[} {cmd:overlap}({it:num}) {cmdab:bwid:th}({it:num}) {cmd:color}({it:str}) {cmd:alpha}({it:num}) {cmdab:off:set}({it:num}) {cmdab:normg:lobal} {cmd:lines} 
					{cmdab:lw:idth}({it:num}) {cmdab:lc:olor}({it:str}) {cmdab:xangle({it:str}) {cmdab:xlabs:ize}({it:num}) {cmdab:ylabs:ize}({it:num}) 
					{cmdab:xlabc:olor}({it:str}) {cmdab:ylabc:olor}({it:str}) {cmd:xticks}({it:str}) 
					{cmd:xtitle}({it:str}) {cmd:ytitle}({it:str}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt joyplot y x}}The command requires a numeric {it:y} variable and a numeric {it:x} variable. The x variable is usually a time variable.{p_end}

{p2coldent : {opt over(group variable)}}This is the group variable that defines the joyplot layers.{p_end}

{p2coldent : {opt overlap(value)}}A higher value increases the overlap, and the height of the joyplots. The default value is 6.{p_end}

{p2coldent : {opt color(string)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette viridis:{it:viridis}}. Here one can also pass one single colors, for example, {it:color(black)}.{p_end}

{p2coldent : {opt alpha(value)}}Alpha is used to change the transparency of the drawn layers. Default is {it:80} for 80%.{p_end}

{p2coldent : {opt normg:lobal}}Normalize by the global value. This ensures that the heights are referenced to the overall maximum of the {it:y} variable which makes groups comparable. 
This might require the heights to be adjusted using the {cmd:overlap} option especially if some groups are very dominant. See examples below.{p_end}

{p2coldent : {opt lines}}Draw colored lines instead of area fills. This is a faster drawing option since area fills are computationally intensive. The option {cmdab:lc:olor()} does not work here. 
Instead define the line color using the {cmd:color()} option. The option {cmdab:lw:idth()} can be used here.{p_end}

{p 4 4 2}
{ul:{it:Fine tuning:}}

{p2coldent : {opt lc:olor(string)}}The outline color of the area fills. Default is {it:white}.{p_end}

{p2coldent : {opt lw:idth(value)}}The outline width of the area fills. Default is {it:0.1}.{p_end}

{p2coldent : {opt offset(value)}}This option is used for offseting the labels on the y-axis. Default is {it:0}. A higher offsetting can be achieved by providing a negative number, e.g. -20.{p_end}

{p2coldent : {opt xlabs:ize(value)}, {opt ylabsize(value)}}The size of the x and y-axis labels. Defaults are {it:1.7}.{p_end}

{p2coldent : {opt xlabc:olor(string)}, {opt ylabcolor(string)}}This option can be used to customize the x and y-axis label colors especially if non-standard graph schemes are used. Default is {it:black}.{p_end}

{p2coldent : {opt xangle(string)}}The angle of the x-axis values. Default is vertical. Here one can also specify the angle in degrees for example {it:xangle(45)}.{p_end}

{p2coldent : {opt xticks(string)}}This option can be used to customize the x-axis ticks. See example below.{p_end}

{p2coldent : {opt xtitle, ytitle, title, subtitle, note}}These are standard twoway graph options.{p_end}

{p2coldent : {opt scheme(string)}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018) is required for {cmd:joyplot}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}


{title:Examples}

- Load the data and clean it up:

use "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/OWID_data.dta?raw=true", clear

{stata keep if group10==1}
{stata keep country date new_cases}

{stata joyplot new_cases date, over(country)}

{stata joyplot new_cases date if date > 22267, over(country)}

{stata joyplot new_cases date if date > 22267, over(country) lc(black) color(white) alpha(100)}

{stata joyplot new_cases date if date > 22267, over(country) lc(white) color(black) alpha(50) lw(0.05)}

{stata joyplot new_cases date if date > 22267, over(country) lines lw(0.2)}

{stata joyplot new_cases date if date > 22267, over(country) lines lw(0.2) color(black)}


- {it:With normalization}

{stata joyplot new_cases date if date > 22267, over(country) normg}

{stata joyplot new_cases date if date > 22267, over(country) normg overlap(15) xangle(45)}

{stata joyplot new_cases date if date > 22267, over(country) normg overlap(15) xangle(45) lines}

{stata joyplot new_cases date if date > 22267, over(country) bwid(0.1) off(-20) overlap(10) lw(none)}

- {it:With custom dates}

qui summ date if date > 22267

local xmin = r(min)
local xmax = r(max)


joyplot new_cases date if date > 22267, over(country) overlap(8) color(CET C1) alpha(100) ///
	lc(white) lw(0.2) xticks(`xmin'(30)`xmax') off(-30) ///
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("Some more text here")  ///
	note("Some text here", size(vsmall)) 

- {it:With custom graph scheme}

The example below uses the {stata ssc install schemepack, replace:schemepack} suite and loads the {stata set scheme neon:neon} which has a black background. Here we need to fix some colors:

qui summ date if date > 22267

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22267, over(country) overlap(8) color(CET C1) alpha(90) ///
	lc(black) lw(0.1) xticks(`xmin'(60)`xmax') off(-30) ///
	ylabc(white) xlabc(white) /// 
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("a subtitle here", color(white)) ///
	note("Some text here", size(vsmall)) scheme(neon)



{title:Version history}

- {bf:1.2}: x-axis angle option added. Global normalization option added. Draw lines only option added.
- {bf:1.1}: Code cleanup. Various options added.
- {bf:1.0}: First version.

{hline}

{title:Package details}

Version      : {bf:joyplot} v1.2
This release : 14 Apr 2022
First release: 13 Dec 2021
Repository   : {browse "https://github.com/asjadnaqvi/joyplot":GitHub}
Keywords     : Stata, graph, joyplot, ridgeline plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-joyplot/issues":GitHub} by opening a new issue.

{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


