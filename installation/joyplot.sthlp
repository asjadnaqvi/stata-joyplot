{smcl}
{* 03Oct2023}{...}
{hi:help joyplot/ridgeline}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-joyplot":joyplot/ridgeline v1.71 (GitHub)}}

{hline}

{title:joyplot/ridgeline}: A Stata package for joyplots or ridgeline plots. 

Please note that {cmd:joyplot} can be substituted with {cmd:ridgeline}.

The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d":Ridgeline plots (Joy plots)}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:joyplot} {it:y} {it:[x]} {ifin}, {cmd:by}({it:variable}) 
                {cmd:[} {cmd:overlap}({it:num}) {cmdab:bwid:th}({it:num}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmdab:off:set}({it:num}) {cmd:lines} {cmd:droplow} {cmdab:norm:alize}({it:local}|{it:global}) 
                   {cmd:rescale} {cmdab:off:set}({it:num}) {cmdab:laboff:set}({it:num}) {cmdab:lw:idth}({it:num}) {cmdab:lc:olor}({it:str}) {cmdab:ylabs:ize}({it:num}) {cmdab:ylabc:olor}({it:str}) {cmdab:ylabpos:ition}({it:str})
                   {cmdab:yl:ine} {cmdab:ylc:olor}({it:str}) {cmdab:ylw:idth}({it:str}) {cmdab:ylp:attern}({it:str}) {cmdab:xrev:erse} {cmdab:yrev:erse} {cmdab:peak:s} {cmd:peaksize}({it:num}) {cmd:n}({it:num})
                   {cmd:xtitle}({it:str}) {cmd:ytitle}({it:str}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:xlabel}({it:str}){cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) {cmd:saving}({it:str}) 
                {cmd:]}
{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt joyplot y [x]}}The command requires a numeric {it:y} variable and an optional numeric {it:x} variable. If {it:x} is not specified, then overlapping densities for {it:y} are drawn. 
If x is specified, a lowess fit between {it:y} and {it:x} is performed. Usually {it:x} represents a time variable.{p_end}

{p2coldent : {opt by(variable)}}This is the group variable that defines the joyplot layers. If there are fewer than 10 observations per {opt over} group, the program will 
throw a warning message and exit. This is important to flag since densities are likely to create errors with few observations.
Either clean these groups manually or use the {opt droplow} option to automatically drop them.{p_end}

{p2coldent : {opt droplow}}Automatically drop the {opt over} groups with fewer than 10 observations.{p_end}

{p2coldent : {opt bwid:th(num)}}A higher bandwidth value will result in higher smoothing. The default value is {opt bwid(0.1)}.
This value might need adjustment depending on the data. Note that if you use {cmd:joyplot} and the ridge lines do not appear, then the bandwidth certainly needs adjustment.
 In this case, increase the bandwidth.{p_end}

{p2coldent : {opt overlap(num)}}A higher value increases the overlap, and the height of the joyplots. The default value is {opt overlap(6)} and the minimum allowed value is 1.{p_end}

{p2coldent : {opt palette(str)}}{opt palette} uses any named scheme defined in the {stata help colorpalette:colorpalette} package.
Default is {stata colorpalette CET C1:{it:CET C1}}. Here, one can also pass single colors, for example, {it:palette(black)}.{p_end}

{p2coldent : {opt alpha(num)}}Alpha is used to change the transparency of the area fills. Default value is {opt alpha(80)} for 80% transparency.{p_end}

{p2coldent : {opt lines}}Draw colored lines instead of area fills. This option is much faster since area fills are computationally intensive.
The option {opt lcolor()} does not work here. Instead define the line colors using the {cmd:palette()} option. The option {opt lwidth()} is allowed.{p_end}

{p2coldent : {opt norm:alize(local|global)}}Normalize by the local or global maximum of the {it:y} variable. The default is set to {it:global}, but in certain circumstances,
the user might want to just look at the distribution of a variable within a group. In this case the option {opt norm(local)} can be specified.{p_end}

{p2coldent : {opt rescale}}This option is used to rescale the data such that the global minimum value is set to 0. This is helpful in two instances.
First, the data contains high values that create a large gap from the horizontal zero axis. This might make it look like that the labels are displaced.
In this case, {opt rescale} can be used to recenter the horizontal lines to the global minimum value. The minimum and maximum values are stored in locals. 
See {it:return list}. Second, use this option if the data contains negative values. Since densities do not deal with negative numbers, 
{opt rescale} helps recentering the data allowing the users to plot the all the values.{p_end}

{p2coldent : {opt xrev:erse}, {opt yrev:erse}}Reverse the x and y axes. While reversing the y-axis might be desireable, for example, to change the alphabetical
order of the categories, xreverse should be used with caution.{p_end}

{p2coldent : {opt peak:s}}Mark the highest point of each ridgeline with a dot. This option is currently beta.{p_end}

{p2coldent : {opt peaksize(num)}}Size of peak dots. Default is {opt peaksize(0.2)}.{p_end}

{p 4 4 2}
{it:{ul:Fine tuning}}

{p2coldent : {opt lc:olor(str)}}The outline color of the area fills. Default is {opt lc(white)}.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the area fills. Default is {opt lw(0.15)}.{p_end}

{p2coldent : {opt yl:ine}}Shows base reference lines for each {opt by()} category.{p_end}

{p2coldent : {opt xline(numlist)}}Passthru option for {opt xline()}. This option can be used to add vertical lines to graphs.{p_end}

{p2coldent : {opt ylc:olor(str)}}The color of the y-axis grids lines. Default is {opt ylc(black)}.{p_end}

{p2coldent : {opt ylw:idth(num)}}The width of the y-axis grids lines. Default is {opt ylw(0.04)}.{p_end}

{p2coldent : {opt ylp:attern(str)}}The pattern of the y-axis grids lines. Default is {opt ylp(solid)}.{p_end}

{p2coldent : {opt ylabpos:ition(str)}}The position of the y-axis labels takes on the values {it:left} or {it:right}.
The default orientation is {opt ylabpos(left)}.{p_end}

{p2coldent : {opt laboff:set(num)}}This option is used for offseting the labels on the y-axis. 
For example, {opt offset(-20)} will move the labels left by 20 pixels. Default is {opt laboffset(0)} for no displacement.{p_end}

{p2coldent : {opt off:set(num)}}This option is used for extending the range of the x-axis. Default is {opt offset(0)} or 0% of the total width.{p_end}

{p2coldent : {opt n(num)}}Advanced option for increasing the number of observations for generating single density joyplots. Default is {opt n(50)}.{p_end}

{p2coldent : {opt xtitle()}, {opt ytitle()}, {opt xlabel()}}These are standard twoway graph options.{p_end}

{p2coldent : {opt title()}, {opt subtitle()}, {opt note()}}These are standard twoway graph options.{p_end}

{p2coldent : {opt xsize()}, {opt ysize()}, {opt name()}, {opt saving()}}These are standard twoway graph options for changing the dimensions of the graphs.{p_end}

{p2coldent : {opt scheme()}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}


{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018, 2022) is required for {cmd:joyplot}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-joyplot":GitHub} for examples.

{hline}

{title:Version history}

- {bf:1.71}: Fixed a bug where locals were passing incorrectly. Fixed a bug in "lines". Added n() option for single density graphs.
- {bf:1.7} : Options xline(), saving(), peaks, peaksize() added. The command {cmd:ridgeline} added as mirror for {cmd:joyplot}.
- {bf:1.62}: Changed over() to by(). Added offset() and laboffset().
- {bf:1.61}: ylabel in densities fixed. normalize in densities fixed. 
- {bf:1.6} : {it:color} renamed to {it:palette}. Global normalization is now default. Rescale option added. Less than 10 observations per group are flagged.
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

Version      : {bf:joyplot} v1.71
This release : 03 Oct 2023
First release: 13 Dec 2021
Repository   : {browse "https://github.com/asjadnaqvi/joyplot":GitHub}
Keywords     : Stata, graph, joyplot, ridgeline plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback and issues}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-joyplot/issues":GitHub} by opening a new issue.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}
