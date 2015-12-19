// compRetCorr
clear
forval i=1/100 {
	append using bootstrap/corrRet_`i'
}

foreach var of varlist corrRet* {
	gen sd_`var' = `var'
	gen p95_`var' = `var'
	gen p05_`var' = `var'
}

collapse (p95)p95_corrRet (p05)p05_corrRet (sd)sd_corrRet (mean)corrRet, by(year)

foreach var of varlist corrRet {
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
(rarea sd1high_corrRet sd1low_corrRet year if year<=1994, color(gs14))
(scatter corrRet year if year<=1994, connect(l) lstyle(p1) xlabel(1984 1989 1994, valuelabel angle(45)) xtitle(""))
(rarea sd1high_corrRet sd1low_corrRet year if year>=1999, color(gs14))
(scatter corrRet year if year>=1999, connect(l) xlabel(1984 1989 1994 1999 2003 2007 2011, valuelabel angle(45)) xtitle(""))
, legend(rows(1) order(2 4 1) label(2 "5-Year Correlation") label(4 "2-Year Correlation") label(1 "2SE bands"))
;
#delimit cr
