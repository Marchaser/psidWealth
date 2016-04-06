/*
Persistent risk and wealth distribution
Author: Dan Cao and Wenlan Luo
Analyze wealth class transition using the bootstraped results
*/

clear
forval i=1/100 {
	append using bootstrap/rankTrans_`i'
}

foreach var of varlist trans* {
	gen sd_`var' = `var'
	gen p95_`var' = `var'
	gen p05_`var' = `var'
}

collapse (p95)p95_trans* (p05)p05_trans* (sd)sd_trans* (mean)trans*, by(year)

foreach var of varlist trans* {
	gen sd1high_`var'=`var'+sd_`var'
	gen sd1low_`var'=`var'-sd_`var'
}

set scheme s1mono
graph set window fontface "Times New Roman"

label define yearLab 1984 "1984-1989" /// 
1989 "1989-1994" ///
1994 "1994-1999" ///
1999 "1999-2001" ///
2001 "2001-2003" ///
2003 "2003-2005" ///
2005 "2005-2007" ///
2007 "2007-2009" ///
2009 "2009-2011" ///
2011 "2011-2013"
label values year yearLab

#delimit ;
twoway
(rarea sd1high_trans1 sd1low_trans1 year if year<=1994, color(gs14))
(scatter trans1 year if year<=1994, connect(l) lstyle(p1) xlabel(1984 1989 1994, valuelabel angle(45)) xtitle(""))
(rarea sd1high_trans1 sd1low_trans1 year if year>=1999, color(gs14))
(scatter trans1 year if year>=1999, connect(l) xlabel(1984 1989 1994 1999 2003 2007 2011, valuelabel angle(30) labsize(medsmall)) xtitle(""))
, legend(rows(1) order(2 4 1) label(2 "5-Year Transition") label(4 "2-Year Transition") label(1 "2SE bands") size(small))
saving(trans11, replace)
title("From Bottom Class to Bottom Class")
;
#delimit cr

#delimit ;
twoway
(rarea sd1high_trans9 sd1low_trans9 year if year<=1994, color(gs14))
(scatter trans9 year if year<=1994, connect(l) lstyle(p1) xlabel(1984 1989 1994, valuelabel angle(45)) xtitle(""))
(rarea sd1high_trans9 sd1low_trans9 year if year>=1999, color(gs14))
(scatter trans9 year if year>=1999, connect(l) xlabel(1984 1989 1994 1999 2003 2007 2011, valuelabel angle(30) labsize(medsmall)) xtitle(""))
, legend(rows(1) order(2 4 1) label(2 "5-Year Transition") label(4 "2-Year Transition") label(1 "2SE bands") size(small))
saving(trans33, replace)
title("From Top Class to Top Class")
;
#delimit cr

grc1leg trans11.gph trans33.gph, ///
legendfrom(trans33.gph)

graph export graph/trans.pdf, replace
