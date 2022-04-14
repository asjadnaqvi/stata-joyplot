# joyplot v1.2

This package provides the ability to draw joyplot or ridgeline plots in Stata. It is based on the [Joyplot Guide](https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d) that I released in October 2020.


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The package (**v1.1**) is available on SSC and can be installed as follows:
```
ssc install joyplot, replace
```

Or it can be installed from GitHub (**v1.2**):

```
net install joyplot, from("https://raw.githubusercontent.com/asjadnaqvi/stata-joyplot/main/installation/") replace
```


The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```



## Syntax

The syntax for v1.2 is as follows:

```
joyplot y x [if] [in], over(variable) [ overlap(num) bwidth(num) color(str) alpha(num) offset(num) normglobal lines 
                                        lwidth(num) lcolor(str) {cmdab:xangle(str) xlabsize(num) ylabsize(num) xlabcolor(str) ylabcolor(str) xticks({it
                                        xtitle(str) ytitle(str) title(str) subtitle(str) note(str) scheme(str) ]

```

See the help file `help joyplot` for details.

The most basic use is as follows:

```
joyplot y x, over(variable)
```

where `y` is the variable we want to plot, and `x` is usually the time dimension. The `over` variable splits the data into different groupings that also determines the colors. The color schemes can be modified using the `palettes(name)` option. Here any scheme from the `colorpalettes` package can be used.



## Examples

Set up the data:

```
clear
set scheme white_tableau
graph set window fontface "Arial Narrow"

use "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/OWID_data.dta?raw=true", clear

keep if group10==1

keep country date new_cases
```


### Basic use

We can generate basic graphs as follows:

```
joyplot new_cases date if date > 22267, over(country)
```

<img src="/figures/joyplot1.png" height="600">


```
joyplot new_cases date if date > 22267, over(country) lc(black) color(white) alpha(100)
```

<img src="/figures/joyplot1_1.png" height="600">

```
joyplot new_cases date if date > 22267, over(country) lc(white) color(black) alpha(50) lw(0.05)
```

<img src="/figures/joyplot1_2.png" height="600">

```
joyplot new_cases date if date > 22267, over(country) lines lw(0.2)
```

<img src="/figures/joyplot1_3.png" height="600">

```
joyplot new_cases date if date > 22267, over(country) lines lw(0.2) color(black)
```

<img src="/figures/joyplot1_4.png" height="600">



### Global normalization

```
joyplot new_cases date if date > 22267, over(country) normg
```

<img src="/figures/joyplot2.png" height="600">

```
joyplot new_cases date if date > 22267, over(country) normg overlap(15) xangle(45)
```

<img src="/figures/joyplot2_1.png" height="600">

```
joyplot new_cases date if date > 22267, over(country) normg overlap(15) xangle(45) lines
```

<img src="/figures/joyplot2_2.png" height="600">


### Additional options


```
joyplot new_cases date if date > 22267, over(country) bwid(0.1) off(-20) overlap(10) lw(none) 
```

<img src="/figures/joyplot3.png" height="600">


We can also customize dates, increase the overlap of the layers, change the palette, and change the color intensity:

```
qui summ date if date > 22267

local xmin = r(min)
local xmax = r(max)


joyplot new_cases date if date > 22267, over(country) overlap(8) color(CET C1) alpha(100) ///
	lc(white) lw(0.2) xticks(`xmin'(30)`xmax') off(-30) ///
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("Some more text here")  ///
	note("Some text here", size(vsmall)) 
```

<img src="/figures/joyplot4.png" height="600">


Next we modify the scheme and make sure the colors are passed correctly. We use `neon` from [schemepack](https://github.com/asjadnaqvi/Stata-schemes) which has a black background:

```
qui summ date if date > 22267

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22267, over(country) overlap(8) color(CET C1) alpha(90) ///
	lc(black) lw(0.1) xticks(`xmin'(60)`xmax') off(-30) ///
	ylabc(white) xlabc(white) /// 
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("a subtitle here", color(white)) ///
	note("Some text here", size(vsmall)) scheme(neon)
```

<img src="/figures/joyplot5.png" height="600">


### The Joy Division look, since this plots get their name from the band:

```
qui summ date if date > 22425

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22425, over(country) overlap(8) color(black) alpha(100) bwid(0.1) ///
	lc(white) lw(0.2) xticks(`xmin' `xmax') off(+20) ///
	ylabc(none) xlabc(none) xangle(0) /// 
	xtitle("") ytitle("") ///
	title("{fontface Arial Bold:The Joy Division look}") scheme(neon)
```

<img src="/figures/joyplot6.png" height="600">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-joyplot/issues) to report errors, feature enhancements, and/or other requests. 


## Versions

**v1.2 (14 Apr 2022)**
- X-axis angle option added.
- Global normalization option added.
- Draw lines only option added.
- Major fixes to syntax, defaults values, and how lines and areas are drawn.

**v1.1 (08 Apr 2022)**
- Public release. Several options and features added.

**v1.0 (13 Dec 2021)**
- Beta version.





