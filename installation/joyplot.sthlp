{smcl}
{* 08April2022}{...}
{hi:help joyplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-joyplot":joyplot v1.1 (GitHub)}}

{hline}

{title:joyplot}: A Stata package for ridgeline plots. 

{p 4 4 2}
The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d":Ridgeline plots (Joy plots)}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:joyplot} {it:y x} {ifin}, {cmd:over}({it:variable}) {cmd:[} {cmd:overlap}({it:num}) {cmdab:bwid:th}({it:num}) {cmd:color}({it:str}) {cmd:alpha}({it:num}) {cmdab:off:set}({it:num}) {cmdab:lw:idth}({it:num}) {cmdab:lc:olor}({it:str}) 
					{cmdab:xlabs:ize}({it:num}) {cmdab:ylabs:ize}({it:num}) {cmdab:xlabc:olor}({it:str}) {cmdab:ylabc:olor}({it:str}) {cmd:xticks}({it:str}) 
					{cmd:xtitle}({it:str}) {cmd:ytitle}({it:str}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt joyplot y x}}The command requires a numeric {it:y} variable and a numeric {it:x} variable. The x variable is usually a time variable.{p_end}

{p2coldent : {opt over(group variable)}}This is the group variable that defines the joyplot layers.{p_end}

{p2coldent : {opt overlap(value)}}A higher value increases the overlap, and the height of the joyplots. The default value is 6.{p_end}

{p2coldent : {opt color(string)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette viridis:{it:viridis}}.{p_end}

{p2coldent : {opt alpha(value)}}Alpha is used to change the transparency of the drawn layers. Default is {it:80} for 80%.{p_end}

{p2coldent : {opt offset(value)}}This option is used for offseting the labels on the y-axis. Default is {it:0}. A higher offsetting can be achieved by providing a negative number, e.g. -20.{p_end}

{p2coldent : {opt lw:idth(value)}}The line width of the area stroke. Default is {it:thin}. This can also be replaced with a number.{p_end}

{p2coldent : {opt lc:olor(string)}}The line color of the area stroke. Default is {it:white}.{p_end}

{p2coldent : {opt xlabs:ize(value)}, {opt ylabsize(value)}}The size of the x and y-axis labels. Defaults are {it:1.7}.{p_end}

{p2coldent : {opt xlabc:olor(string)}, {opt ylabcolor(string)}}This option can be used to customize the x and y-axis label colors especially if non-standard graph schemes are used. Default is {it:black}.{p_end}

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

keep if group10==1
keep country date new_cases


- Basic use:

joyplot new_cases date, over(country)

joyplot new_cases date if date > 22267, over(country)

- With some options:

joyplot new_cases date if date > 22267, over(country) bwid(0.1) xoff(-20) overlap(10) lw(0.02)

- With additional options:

qui summ date if date > 22267

local xmin = r(min)
local xmax = r(max)

joyplot new_cases date if date > 22267, over(country) overlap(8) color(CET C1) alpha(100) ///
	lc(white) lw(0.2) xticks(`xmin'(30)`xmax') offset(-10) ///
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("a subtitle here") ///
	note("Some text here", size(vsmall)) 

- Custom graph scheme

The example below uses the {stata ssc install schemepack, replace:schemepack} suite and loads the {stata set scheme neon:neon} which has a black background. Here we need to fix some colors:

qui summ date if date > 22267

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22267, over(country) overlap(8) color(CET C1) alpha(100) ///
	lc(white) lw(0.2) xticks(`xmin'(30)`xmax') off(-30) ///
	ylabc(white) xlabc(white) /// 
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("a subtitle here", color(white)) ///
	note("Some text here", size(vsmall)) scheme(neon)


{title:Version history}

- {bf:1.10}: Code cleanup. Various options added.
- {bf:1.00}: First version.

{hline}

{title:Package details}

Version      : {bf:joyplot} v1.1
This release : 08 Apr 2022
First release: 13 Dec 2021
Repository   : {browse "https://github.com/asjadnaqvi/joyplot":GitHub}
Keywords     : Stata, graph, joyplot, ridgeline plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}



{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


