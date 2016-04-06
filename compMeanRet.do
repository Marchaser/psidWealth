// compute mean returns
// compute return
// use wealth_clear, clear

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYear' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	// local y2 `: word `iyp1' of `yearName''
	xtile wealthTile`y'=wealthM`y' [pw=weight`y'],n(5)
	// xtile wealthheqTile`year'=wealthheq`year',n(5)
	cap gen retWGains`y' = kincWGains`y' / wealth2`y' if wealth2`y'>0
	
	gen ret`y' = kinc`y'/wealth2`y' if wealth2`y'>0
	gen busret`y' = businc`y'/bus`y'
	
	gen sret`y' = sinc`y'/(stocks`y'+savings`y')
}

keep ret* wealthTile* weight* id
reshape long ret retWGains wealthTile weight, i(id) j(year)
_pctile ret, p(1 95)
replace ret=. if ret<`r(r1)' | ret>`r(r2)'
replace ret=. if abs(ret)>1
collapse ret retWGains [pw=weight], by(year wealthTile)
drop if year==. | wealthTile==.

/*
twoway scatter ret year, connect(l) by(wealthTile, note("Group 1 = bottom 20%, Group 5 = top 20%". ///
"Wealth: business+saving+home_equity+real_estate+stocks+vehicles+others" ///
"Asset income: asset_part_business_income+interest+dividend+rent" ///
"Exclude abs(return)>1")) ///
ytitle("Return on total asset")
graph export mean_return.pdf, replace
*/
