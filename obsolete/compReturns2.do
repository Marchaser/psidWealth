// compute return
// use wealth_clear, clear

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYear' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	// local y2 `: word `iyp1' of `yearName''
	xtile wealthTile`y'=wealthM`y' [pw=weight`y'],n(3)
	// xtile wealthheqTile`year'=wealthheq`year',n(5)
	cap gen retWGains`y' = kincWGains`y' / wealth2`y' if wealth2`y'>0
	
	gen ret`y' = kinc`y'/wealth2`y' if wealth2`y'>0
	gen busret`y' = businc`y'/bus`y'
	
	gen sret`y' = sinc`y'/(stocks`y'+savings`y')
}

/*
// return
keep ret* wealthTile* weight* id
reshape long ret retWGains wealthTile weight, i(id) j(year)
// keep if abs(ret)<1
_pctile retWGains, p(5 95)
replace retWGains=. if abs(retWGains)>1
replace ret=. if abs(ret)>1
collapse ret retWGains [pw=weight], by(year wealthTile)
drop if year==. | wealthTile==.

twoway line ret year, by(wealthTile, note("Group 1 = bottom 20%, Group 5 = top 20%". ///
"Wealth: business+saving+home_equity+real_estate+stocks+vehicles+others" ///
"Asset income: PREVIOUS YEAR asset_part_business_income+interest+dividend+rent" ///
"Exclude abs(return)>1")) ///
ytitle("Return on total asset")
graph export mean_return.pdf, replace

twoway line retWGains year, by(wealthTile, note("Group 1 = bottom 20%, Group 5 = top 20%". ///
"Wealth: business+saving+home_equity+real_estate+stocks+vehicles+others" ///
"Asset income: PREVIOUS YEAR asset_part_business_income+interest+dividend+rent" ///
"Exclude abs(return)>1")) ///
ytitle("Return on total asset")
graph export mean_return.pdf, replace
*/

// return correlation
cap drop corrRet*
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
local nYearM2 = `nYear'-2
cap drop g*
gen corrRet=.
gen corrRetWGains=.
gen corrBusret=.
gen corrSret=.
gen year=.
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local iyp2 = `iy'+2
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	local y3 `: word `iyp2' of `yearName''
	// sort wealthTile`y'
	// egen corrRetBus`y' = corr(retbus`y' retbus`y2') if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
	// egen corrRet`y' = corr(ret`y' ret`y2') if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
	quiet sum ret`y', d
	local ret1low=`r(p1)'
	local ret1high=`r(p95)'
	quiet sum ret`y2',d
	local ret2low=`r(p1)'
	local ret2high=`r(p95)'
	// egen corrRet`y' = corr(ret`y' ret`y2') if inrange(ret`y',`ret1low',`ret1high') & inrange(ret`y2',`ret2low',`ret2high') & sameHead`y'`y2'==1
	
	_pctile ret`y', p(1 95)
	local ret1low=`r(r1)'
	local ret1high=`r(r2)'
	_pctile ret`y2', p(1 95)
	local ret2low=`r(r1)'
	local ret2high=`r(r2)'
	preserve
		keep if sameHead`y'`y2'==1
		keep if inrange(ret`y',`ret1low',`ret1high') & inrange(ret`y2',`ret2low',`ret2high')
		// keep if inrange(ret`y',`ret1low',`ret1high') & inrange(ret`y2',`ret2low',`ret2high') & sameHead`y'`y2'==1
		// keep if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1
		gen XY=ret`y'*ret`y2'
		gen XX=ret`y'*ret`y'
		gen YY=ret`y2'*ret`y2'
		collapse XY XX YY ret`y' ret`y2' [pw=weight`y']
		gen COV=XY-ret`y'*ret`y2'
		gen VX=XX-ret`y'*ret`y'
		gen VY=YY-ret`y2'*ret`y2'
		gen COR=COV/(VX^0.5*VY^0.5)
		local cor0 = COR
	restore
	replace year=`y' if _n==`iy'
	replace corrRet=`cor0' if _n==`iy'
	
	/*
	quiet cap sum retWGains`y', d
	if _rc==0 {
	quiet cap sum retWGains`y2',d
	if _rc==0 {
		local ret2low=`r(p1)'
		local ret2high=`r(p95)'
	preserve
		keep if sameHead`y'`y2'==1
		keep if inrange(retWGains`y',`ret1low',`ret1high') & inrange(retWGains`y2',`ret2low',`ret2high')
		// keep if inrange(ret`y',`ret1low',`ret1high') & inrange(ret`y2',`ret2low',`ret2high') & sameHead`y'`y2'==1
		// keep if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1
		gen XY=retWGains`y'*retWGains`y2'
		gen XX=retWGains`y'*retWGains`y'
		gen YY=retWGains`y2'*retWGains`y2'
		collapse XY XX YY retWGains`y' retWGains`y2' [pw=weight`y']
		gen COV=XY-retWGains`y'*retWGains`y2'
		gen VX=XX-retWGains`y'*retWGains`y'
		gen VY=YY-retWGains`y2'*retWGains`y2'
		gen COR=COV/(VX^0.5*VY^0.5)
		local cor0 = COR
	restore
	}
	}
	replace corrRetWGains=`cor0' if _n==`iy'
	
	_pctile busret`y', p(1 95)
	local ret1low=`r(r1)'
	local ret1high=`r(r2)'
	_pctile busret`y2', p(1 95)
	local ret2low=`r(r1)'
	local ret2high=`r(r2)'
	preserve
		keep if sameHead`y'`y2'==1
		keep if inrange(busret`y',`ret1low',`ret1high') & inrange(busret`y2',`ret2low',`ret2high')
		keep if busret`y'~=0 & busret`y2'~=0
		// keep if inrange(ret`y',`ret1low',`ret1high') & inrange(ret`y2',`ret2low',`ret2high') & sameHead`y'`y2'==1
		// keep if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1
		gen XY=busret`y'*busret`y2'
		gen XX=busret`y'*busret`y'
		gen YY=busret`y2'*busret`y2'
		collapse XY XX YY busret`y' busret`y2' [pw=weight`y']
		gen COV=XY-busret`y'*busret`y2'
		gen VX=XX-busret`y'*busret`y'
		gen VY=YY-busret`y2'*busret`y2'
		gen COR=COV/(VX^0.5*VY^0.5)
		local cor0 = COR
	restore
	replace year=`y' if _n==`iy'
	replace corrBusret=`cor0' if _n==`iy'
	
	_pctile sret`y', p(1 95)
	local ret1low=`r(r1)'
	local ret1high=`r(r2)'
	_pctile sret`y2', p(1 95)
	local ret2low=`r(r1)'
	local ret2high=`r(r2)'
	preserve
		keep if sameHead`y'`y2'==1
		keep if inrange(sret`y',`ret1low',`ret1high') & inrange(sret`y2',`ret2low',`ret2high')
		keep if sret`y'~=0 & sret`y2'~=0
		// keep if inrange(ret`y',`ret1low',`ret1high') & inrange(ret`y2',`ret2low',`ret2high') & sameHead`y'`y2'==1
		// keep if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1
		gen XY=sret`y'*sret`y2'
		gen XX=sret`y'*sret`y'
		gen YY=sret`y2'*sret`y2'
		collapse XY XX YY sret`y' sret`y2' [pw=weight`y']
		gen COV=XY-sret`y'*sret`y2'
		gen VX=XX-sret`y'*sret`y'
		gen VY=YY-sret`y2'*sret`y2'
		gen COR=COV/(VX^0.5*VY^0.5)
		local cor0 = COR
	restore
	replace year=`y' if _n==`iy'
	replace corrSret=`cor0' if _n==`iy'
	*/
}

/*
keep id corrRet* corrBusret* corrRetWGains* wealthTile* weight*
reshape long corrRet corrBusret corrRetWGains wealthTile weight, i(id) j(year)
collapse corrRet corrBusret	corrRetWGains, by(year)
drop if year==.
// drop if wealthTile==.
*/

/*
twoway line corrRetWGains year if year<=1999, by(wealthTile)
twoway line corrRetWGains year if year>=2001, by(wealthTile)
*/

keep corrRet year
// keep corrBusret corrRet corrRetWGains corrSret year
sort year
// twoway (scatter corrRet year if year<=1994, connect(l))(scatter corrRet year if year>=1999, connect(l))

// twoway (scatter corrBusret year if year<=1994, connect(l))(scatter corrBusret year if year>=1999, connect(l))

/*
twoway (line corrRet year if year<=1999)(line corrRet year if year>=2001), by(wealthTile)
twoway line corrRet year if year>=2001, by(wealthTile)
*/
