![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-joyplot) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-joyplot) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-joyplot) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-joyplot) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-joyplot)


# joyplot v1.6



This package provides the ability to draw joyplot or ridgeline plots in Stata. It is based on the [Joyplot Guide](https://medium.com/the-stata-guide/covid-19-visualizations-with-stata-part-8-joy-plots-ridge-line-plots-dbe022e7264d) that I released in October 2020.


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The package (**v1.5**) is available on SSC and can be installed as follows:
```
ssc install joyplot, replace
```

Or it can be installed from GitHub (**v1.6**):

```
net install joyplot, from("https://raw.githubusercontent.com/asjadnaqvi/stata-joyplot/main/installation/") replace
```


The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have the package installed, make sure that it is updated `ado update, update`.

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

The syntax for v1.6 is as follows:

```
joyplot y [x] [if] [in], over(variable) 
		[ overlap(num) bwidth(num) palette(str) alpha(num) norm(local|global) lines lwidth(num) lcolor(str)
		rescale droplow ylabsize(num) ylabcolor(str) ylabposition(str) offset(num) 
		yline(str) ylinecolor(str) ylinewith(str) ylinepattern(str)
		xtitle(str) ytitle(str) yreverse xreverse
		title(str) subtitle(str) note(str) xsize(num) ysize(num) scheme(str) name(str) ]
```

See the help file `help joyplot` for details.

The most basic use is as follows:

```
joyplot y x, over(variable)
```

or

```
joyplot y, over(variable)
```


where `y` is the variable we want to plot, and `x` is usually the time dimension. The `over` variable splits the data into different groupings that also determines the colors. The color schemes can be modified using the `color()` option. Here any scheme from the `colorpalettes` package can be used.



## Examples

Set up the data:

```
clear
set scheme white_tableau
graph set window fontface "Arial Narrow"

use "https://github.com/asjadnaqvi/stata-joyplot/blob/main/data/OWID_data.dta?raw=true", clear

keep if group10==1

keep country date new_cases
```


## Two variables

We can generate basic graphs as follows:

```
joyplot new_cases date if date > 22460, over(country) 
```

<img src="/figures/joyplot1.png" height="600">


```
joyplot new_cases date if date > 22460, over(country) norm(local)
```

<img src="/figures/joyplot1_0.png" height="600">



```
joyplot new_cases date if date > 22460, over(country) yline bwid(0.1) norm(local)
```

<img src="/figures/joyplot1_1.png" height="600">


```
joyplot new_cases date if date > 22460, over(country) alpha(100) bwid(0.1) norm(local)
```

<img src="/figures/joyplot1_2.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) lc(black) palette(white) alpha(100) norm(local)
```

<img src="/figures/joyplot1_3.png" height="600">


```
joyplot new_cases date if date > 22460, over(country) lc(white) palette(black) alpha(50) lw(0.05) bwid(0.1) norm(local)
```

<img src="/figures/joyplot1_4.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) lines lw(0.2) bwid(0.1) norm(local)
```

<img src="/figures/joyplot1_5.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) lines lw(0.2) palette(black) bwid(0.1) norm(local)
```

<img src="/figures/joyplot1_6.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) lines lw(0.2) bwid(0.1) color(black)
```

<img src="/figures/joyplot1_6.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) lines lw(0.2) bwid(0.1) ylabpos(right) norm(local)
```

<img src="/figures/joyplot1_7.png" height="600">


```
joyplot new_cases date if date > 22460, over(country) lw(0.2) bwid(0.1) ylabpos(right) xsize(5) ysize(7) norm(local)
```

<img src="/figures/joyplot1_8.png" height="600">


```
joyplot new_cases date if date > 22460, over(country) bwid(0.1) yrev norm(local)
```

<img src="/figures/joyplot1_9.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) bwid(0.1) yrev xrev offset(20) norm(local)
```

<img src="/figures/joyplot1_10.png" height="600">


### Normalization

```
joyplot new_cases date if date > 22460, over(country) bwid(0.1) norm(local)
```

<img src="/figures/joyplot2.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) bwid(0.1) overlap(15) norm(local)
```

<img src="/figures/joyplot2_1.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) bwid(0.1) overlap(15) lines norm(local)
```

<img src="/figures/joyplot2_2.png" height="600">

```
joyplot new_cases date if date > 22460, over(country) bwid(0.1) off(-20) overlap(10) lw(none) norm(local)
```

<img src="/figures/joyplot3.png" height="600">


We can also customize dates, increase the overlap of the layers, change the palette, and change the color intensity:

```
qui summ date if date > 22460

local xmin = r(min)
local xmax = r(max)


joyplot new_cases date if date > 22460, over(country) overlap(8) bwid(0.1) palette(CET C1) alpha(100) ///
	lc(white) lw(0.2) xlabel(`xmin'(60)`xmax') off(-30)  norm(local) ///
	xtitle("Date") ytitle("Countries") ///
	title("{fontface Arial Bold:My joyplot}") subtitle("Some more text here")  ///
	note("Some text here", size(vsmall)) 
```

<img src="/figures/joyplot4.png" height="600">


Next we modify the scheme and make sure the colors are passed correctly. We use `neon` from [schemepack](https://github.com/asjadnaqvi/Stata-schemes) which has a black background:

```
qui summ date if date > 22460

local xmin = r(min)
local xmax = r(max)
	
joyplot new_cases date if date > 22460, over(country) overlap(8) bwid(0.1) palette(CET C1) alpha(90) ///
	lc(black) lw(0.1) xlabel(`xmin'(60)`xmax') off(-30)  norm(local) ///
	ylabc(white) /// 
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
	
joyplot new_cases date if date > 22425, over(country) overlap(8) bwid(0.1) palette(black) alpha(100) norm(local)  ///
	lc(white) lw(0.2) xlabel(none) off(+20) ///
	ylabc(none)   /// 
	xtitle("") ytitle("") ///
	title("{fontface Arial Bold:The Joy Division look}") scheme(neon)
```

<img src="/figures/joyplot6.png" height="600">


## Single variable

Load the data that contains average USA state-level monthly temperatures for the period 1991-2020:

```
use "https://github.com/asjadnaqvi/stata-joyplot/blob/main/data/us_meantemp.dta?raw=true", clear

lab de month 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", replace
lab val month month
```

```
joyplot meantemp, over(month)  
```

<img src="/figures/joyplot7_0.png" height="600">


```
joyplot meantemp, over(month) yline bwid(1.2)
```

<img src="/figures/joyplot7_1.png" height="600">

```
joyplot meantemp, over(month) yline yrev  bwid(1.2)
```

<img src="/figures/joyplot7_2.png" height="600">

```
joyplot meantemp, over(month) yline ylw(0.2) ylc(blue) ylp(dot) ylabpos(right) bwid(1.2)
```

<img src="/figures/joyplot7_3.png" height="600">

```
joyplot meantemp, over(month) bwid(1.5) ylabs(3) overlap(3) yline yrev palette(CET C6) ///
	xlabel(-20(10)30) ///
	ytitle("Month") xtitle("degrees Centigrade") ///
	title("Mean average temperature in the USA") subtitle("2009-2020 average") ///
	note("Source: World Bank Climate Change Knowledge Portal (CCKP).", size(vsmall)) ///
		xsize(4) ysize(5)
```

<img src="/figures/joyplot7_4.png" height="600">

```
qui summ meantemp 

local xmin = r(min)
local xmax = r(max)

joyplot meantemp, over(month) bwid(1.5) ylabs(3) overlap(3) yline palette(scico corkO) alpha(100) ///
	ytitle("Month") xtitle("degrees Centigrade") xlabel(`xmin'(5)`xmax') ///
	title("Mean average temperature in the USA") subtitle("2009-2020 average") ///
	note("Source: World Bank Climate Change Knowledge Portal (CCKP).", size(vsmall)) ///
		xsize(3) ysize(5)
```

<img src="/figures/joyplot7_5.png" height="600">


### Rescale and error checks (v1.6)

Load a dummy data set

```
use "https://github.com/asjadnaqvi/stata-joyplot/blob/main/data/rescale_test.dta?raw=true", clear
use rescale_test, clear
drop if inlist(country, "Cambodia", "Myanmar", "Lao PDR")
tab country
```

Do a vanilla joyplot:

```
joyplot socMob year, over(country)  ///
	lc(white) lw(0.2) xlabel(1990(5)2020) 
```

Get rid of the overlaps. Here `overlap(1)` gives each country it's own box:

<img src="/figures/joyplot8_0.png" height="600">

```
joyplot socMob year, over(country) overlap(1) rescale  ///
	lc(white) lw(0.2) xlabel(1990(5)2020) 
```

<img src="/figures/joyplot8_1.png" height="600">

Let's make a country unusable:

```
drop if year < 2015 & country=="Vietnam"	

joyplot socMob year, over(country) overlap(1)     ///
	lc(white) lw(0.2)  off(-2) xlabel(1990(5)2020) 
```

The above code will produce an error message, highlighting where the errors exist. Let's throw these out using the `droplow` option:

```
joyplot socMob year, over(country) overlap(1) droplow   ///
	lc(white) lw(0.2)  off(-2) xlabel(1990(5)2020) 
```

<img src="/figures/joyplot8_3.png" height="600">

And we rescale the data further to the minimum and maximum values:

```
joyplot socMob year, over(country) overlap(1) droplow rescale   ///
	lc(white) lw(0.2)  off(-2) xlabel(1990(5)2020) 
```

<img src="/figures/joyplot8_4.png" height="600">




## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-joyplot/issues) to report errors, feature enhancements, and/or other requests. 


## Versions

**v1.6 (05 Nov 2022)**
- `color` renamed to `palette` to align it with the other packages
- Errors checks now halt the program if `over` groups have fewer than 10 observations. This is to prevent density functions from crashing with low data points.
- New option `norm(global)` or `norm(local)` allows users to draw lines normalized to global or local group-wise maximum values.
- New option `droplow` drops the groups that do not need the above observation criteria.
- New option `rescale` rescales the data to start from 0. This allows users to rebase values that start at very high or negative values.

**v1.5 (03 Sep 2022)**
- Code clean up.
- Default values updated.
- Error checks added.

**v1.42 (22 Jun 2022)**
- Values were wrongly assigned on the y-axis if the over variable was numeric (reported by Barry Burden).
- Fixes to "over" variable. It can now take on numeric, string, and labeled numeric values.

**v1.41 (20 Jun 2022)**
- Fix to labmask installation
- over now takes numerical values

**v1.4 (26 Apr 2022)**
- option to reverse x and y axes added
- option save graph names added
- optimization to x-axis scales
- various bug fixes

**v1.3 (24 Apr 2022)**
- option to add y-axis lines.
- the syntax is now allows for variable level densities.
- label placement optimized.

**v1.21 (15 Apr 2022)**
- y label position option added. It can now be position on the left or right.
- xsize and ysize options added to change the graph dimensions.

**v1.2 (14 Apr 2022)**
- x-axis angle option added.
- Global normalization option added.
- Draw lines only option added.
- Major fixes to syntax, defaults values, and how lines and areas are drawn.

**v1.1 (08 Apr 2022)**
- Public release. Several options and features added.

**v1.0 (13 Dec 2021)**
- Beta version.





