// compute return
use wealth_clear, clear

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYear' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	// local y2 `: word `iyp1' of `yearName''
	xtile wealthTile`y'=wealthheq`y' [pw=weight`y'],n(5)
	// xtile wealthheqTile`year'=wealthheq`year',n(5)
	cap gen retWGains`y' = kincWGains`y' / wealth2`y'
	gen ret`y' = kinc`y'/wealth2`y' if wealth2`y'>0
	gen busret`y' = businc`y'/bus`y' if bus`y'>0
	
	quiet sum busret`y', d
	replace busret`y'=. if busret`y'>`r(p99)' | busret`y'<`r(p1)'
	// gen retnet`year' = kinc`year' / wealth`year'
	// gen retbus`year' = businc`year' / bus`year'
}

/*
// return
keep ret* wealthTile* weight* id
reshape long ret retWGains wealthTile weight, i(id) j(year)
keep if abs(ret)<1 & abs(retWGains)<1
collapse ret retWGains [pw=weight], by(year wealthTile)
drop if year==. | wealthTile==.

twoway line ret year, by(wealthTile, note("Group 1 = bottom 20%, Group 5 = top 20%". ///
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
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local iyp2 = `iy'+2
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	local y3 `: word `iyp2' of `yearName''
	sort wealthTile`y'
	// egen corrRetBus`y' = corr(retbus`y' retbus`y2') if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
	// egen corrRet`y' = corr(ret`y' ret`y2') if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
	quiet sum ret`y', d
	local ret1low=`r(p1)'
	local ret1high=`r(p99)'
	quiet sum ret`y2',d
	local ret2low=`r(p1)'
	local ret2high=`r(p99)'
	egen corrRet`y' = corr(ret`y' ret`y2') if ret`y'>-1 & ret`y2'>-1 & sameHead`y'`y2'==1
	
	quiet sum busret`y' if busret`y'~=0, d
	local ret1low=`r(p1)'
	local ret1high=`r(p99)'
	quiet sum busret`y2' if busret`y'~=0,d
	local ret2low=`r(p1)'
	local ret2high=`r(p99)'	
	egen corrBusret`y' = corr(busret`y' busret`y2') if busret`y'>=`ret1low' & busret`y'<=`ret1high' &  ///
		busret`y2'>=`ret2low' & busret`y2'<=`ret2high' & sameHead`y'`y2'==1
	// egen corrRetWGains`y' = corr(retWGains`y' retWGains`y2') if abs(retWGains`y')<1 & abs(retWGains`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
	// egen corrRet`y' = corr(ret`y' ret`y3') if abs(ret`y')<1 & abs(ret`y3')<1 & sameHead`y'`y2'==1 & sameHead`y2'`y3'==1, by(wealthTile`y')
	// egen corrRetnet`y' = corr(retnet`y' retnet`y2') if abs(retnet`y')<1 & abs(retnet`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
}

keep id corrRet* corrBusret* wealthTile* weight*
reshape long corrRet corrBusret wealthTile weight, i(id) j(year)
collapse corrRet corrBusret	, by(year)
drop if year==.
// drop if wealthTile==.
/*
twoway line corrRetWGains year if year<=1999, by(wealthTile)
twoway line corrRetWGains year if year>=2001, by(wealthTile)
*/

twoway (scatter corrRet year if year<=1994, connect(l))(scatter corrRet year if year>=1999, connect(l))

/*
twoway (line corrRet year if year<=1999)(line corrRet year if year>=2001), by(wealthTile)
twoway line corrRet year if year>=2001, by(wealthTile)
*/
