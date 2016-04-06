// compRetCorr
clear
forval i=1/100 {
	append using bootstrap/meanRet_`i'
}
drop retWGains
foreach var of varlist ret* {
	replace `var' = `var'*100
	gen sd_`var' = `var'
	gen p95_`var' = `var'
	gen p05_`var' = `var'
}

collapse (p95)p95_ret (p05)p05_ret (sd)sd_ret (mean)ret, by(year wealthTile)

foreach var of varlist ret {
	gen sd1high_`var'=`var'+sd_`var'
	gen sd1low_`var'=`var'-sd_`var'
}

set scheme s1mono
graph set window fontface "Times New Roman"

label define tileLab 1 "Bottom 20%" /// 
2 "[20%,40%)" ///
3 "[40%,60%)" /// 
4 "[60%,80%)" /// 
5 "Top 20%" 
label values wealthTile tileLab

#delimit ;
twoway
(rarea sd1high_ret sd1low_ret year, color(gs14))
(scatter ret year, msymbol(D) connect(l) lstyle(p1))
, by(wealthTile, note(""))
legend(order(2 1) label(1 "2SE Bands") label(2 "Average Annual Return"))
ylabel(0(2)4)
ytitle("Percent")
xtitle("Year")
;
#delimit cr

graph export graph/meanRet.pdf, replace
