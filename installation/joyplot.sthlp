{smcl}
{* 01Mar2023}{...}
{hi:help joyplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-joyplot":joyplot v1.61 (GitHub)}}

{hline}

{title:joyplot}: A Stata package for ridgeline plots. 

The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d":Ridgeline plots (Joy plots)}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:joyplot} {it:y} {it:[x]} {ifin}, {cmd:over}({it:variable}) {cmd:[} {cmd:overlap}({it:num}) {cmdab:bwid:th}({it:num}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmdab:off:set}({it:num}) {cmd:lines} 
					  {cmd:droplow} {cmdab:norm:alize}({it:local} | {it:global}) {cmd:rescale}
					  {cmdab:lw:idth}({it:num}) {cmdab:lc:olor}({it:str}) {cmdab:ylabs:ize}({it:num}) {cmdab:ylabc:olor}({it:str}) {cmdab:ylabpos:ition}({it:str})
					  {cmdab:yl:ine} {cmdab:ylc:olor}({it:str}) {cmdab:ylw:idth}({it:str}) {cmdab:ylp:attern}({it:str}) {cmdab:xrev:erse} {cmdab:yrev:erse} 
					  {cmd:xtitle}({it:str}) {cmd:ytitle}({it:str})  {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:xlabel}({it:str})
					  {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) {cmd:]}


{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt joyplot y [x]}}The command requires a numeric {it:y} variable and an optional numeric {it:x} variable. If {it:x} is not specified, then overlapping densities for {it:y} are drawn. 
If x is specified, a lowess fit between {it:y} and {it:x} is performed. Usually {it:x} represents a time variable.{p_end}

{p2coldent : {opt over(variable)}}This is the group variable that defines the joyplot layers.
If there are fewer than 10 observations per {opt over} group, the program will throw a warning message and exit. This is important to flag since densities are likely to create errors with few observations.
Either clean these groups manually or use the {opt droplow} option to automatically drop them.{p_end}

{p2coldent : {opt droplow}}Automatically drop the {opt over} groups with fewer than 10 observations.{p_end}

{p2coldent : {opt bwid:th(value)}}A higher bandwidth value will result in higher smoothing. The default value is {it:0.1}.
This value might need adjustment depending on the data. Note that if you use {cmd:joyplot} and the ridge lines do not appear, then the bandwidth certainly needs adjustment.
 In this case, increase the bandwidth.{p_end}

{p2coldent : {opt overlap(value)}}A higher value increases the overlap, and the height of the joyplots. The default value is {it:6}, and the minimum allowed value is 1.{p_end}

{p2coldent : {opt palette(string)}}{opt palette} uses any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette CET C1:{it:CET C1}}. 
Here, one can also pass single colors, for example, {it:palette(black)}.{p_end}

{p2coldent : {opt alpha(value)}}Alpha is used to change the transparency of the area fills. Default value is {it:80} for 80% transparency.{p_end}

{p2coldent : {opt lines}}Draw colored lines instead of area fills. This option is much faster since area fills are computationally intensive. The option {cmdab:lc:olor()} does not work here. 
Instead define the line colors using the {cmd:palette()} option. The option {cmdab:lw:idth()} is allowed.{p_end}

{p2coldent : {opt norm:alize(local | global)}}Normalize by the local or global maximum of the {it:y} variable. The default is set to {it:global}, but in certain circumstances,
the user might want to just look at the distribution of a variable within a group. In this case the option {opt norm(local)} can be specified.{p_end}

{p2coldent : {opt rescale}}This option is used to rescale the data such that the global minimum value is set to 0. This is helpful in two instances.
First, the data contains high values that create a large gap from the horizontal zero axis. This might make it look like that the labels are displaced.
In this case, {opt rescale} can be used to recenter the horizontal lines to the global minimum value. The minimum and maximum values are stored in locals. 
See {it:return list}. Second, use this option if the data contains negative values. Since densities do not deal with negative numbers, 
{opt rescale} helps recentering the data allowing the users to plot the all the values.{p_end}

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

See {browse "https://github.com/asjadnaqvi/joyplot":GitHub} for detailed examples. A minimum example is given below:

use "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/OWID_data.dta?raw=true", clear

{stata keep if group10==1}
{stata keep country date new_cases}

{stata joyplot new_cases date if date > 22460, over(country) }

{stata joyplot new_cases date if date > 22460, over(country) norm(local)}

{stata joyplot new_cases date if date > 22460, over(country) yline bwid(0.1) norm(local)}

{stata joyplot new_cases date if date > 22460, over(country) lc(black) palette(white) alpha(100) norm(local)}

{stata joyplot new_cases date if date > 22460, over(country) lines lw(0.2) palette(black) bwid(0.1) norm(local)}

{stata joyplot new_cases date if date > 22460, over(country) lines lw(0.2) norm(local)}


{hline}

{title:Version history}

- {bf:1.6} : {it:color} renamed to {it:palette}. Global normalization is now default. Rescale option added. Data checks added. Less than 10 observations per group are flagged.
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

Version      : {bf:joyplot} v1.61
This release : 01 Mar 2022
First release: 13 Dec 2021
Repository   : {browse "https://github.com/asjadnaqvi/joyplot":GitHub}
Keywords     : Stata, graph, joyplot, ridgeline plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Acknowledgements}

John Chin and {it:van-alfen}(GitHub) suggested several enhancements to the code. Ka Lok Wong uncovered an issue with bandwidths.


{title:Feedback and issues}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-joyplot/issues":GitHub} by opening a new issue.

{title:Other data visualization packages}

{psee}
    {helpb alluvial}, {helpb circlebar}, {helpb spider}, {helpb treemap}, {helpb circlepack}, {helpb arcplot}, {helpb treecluster}, {helpb sunburst}
	{helpb marimekko}, {helpb bimap}, {helpb joyplot}, {helpb streamplot}, {helpb delaunay}, {helpb clipgeo}, {helpb schemepack}, {helpb sankey}


