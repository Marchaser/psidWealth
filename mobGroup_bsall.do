// mobGroup bs results
clear
forval i=1/200 {
	append using bootstrap/mobGroup131_`i'
}

foreach var of varlist trans* {
	gen sd_`var' = `var'
	gen p95_`var' = `var'
	gen p05_`var' = `var'
}

collapse (p95)p95_trans* (p05)p05_trans* (sd)sd_trans* (mean)trans*, by(year gGroup)

foreach var of varlist trans* {
	gen sd1high_`var'=`var'+sd_`var'
	gen sd1low_`var'=`var'-sd_`var'
}

/*
twoway(scatter trans11 year if gGroup==1, connect(l))(rcap p95_trans11 p05_trans11 year if gGroup==1)
twoway(scatter trans11 year if gGroup==2, connect(l))(rcap p95_trans11 p05_trans11 year if gGroup==2)
*/

twoway(scatter trans11 year if gGroup==1, connect(l))(rcap sd1high_trans11 sd1low_trans11 year if gGroup==1)
twoway(scatter trans11 year if gGroup==2, connect(l))(rcap sd1high_trans11 sd1low_trans11 year if gGroup==2)
twoway(scatter trans33 year if gGroup==4, connect(l))(rcap sd1high_trans33 sd1low_trans33 year if gGroup==4)

