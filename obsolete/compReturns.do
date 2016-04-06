// compute return
use wealth_clear, clear

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYear' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	// local y2 `: word `iyp1' of `yearName''
	xtile wealthTile`y'=wealth`y' if wealth2`y'>0 [pw=weight`y'],n(5)
	// xtile wealthheqTile`year'=wealthheq`year',n(5)
	// gen ret`y2' = kincWGains`y2' / (wealth`y'+wealth`y2')*2
	gen ret`y' = kinc`y'/wealth2`y' if wealth2`y'>0
	// gen retnet`year' = kinc`year' / wealth`year'
	// gen retbus`year' = businc`year' / bus`year'
}

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
	egen corrRet`y' = corr(ret`y' ret`y2') if abs(ret`y')<1 & abs(ret`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
	// egen corrRet`y' = corr(ret`y' ret`y3') if abs(ret`y')<1 & abs(ret`y3')<1 & sameHead`y'`y2'==1 & sameHead`y2'`y3'==1, by(wealthTile`y')
	// egen corrRetnet`y' = corr(retnet`y' retnet`y2') if abs(retnet`y')<1 & abs(retnet`y2')<1 & sameHead`y'`y2'==1, by(wealthTile`y')
}

keep id corrRet* wealthTile* weight*
reshape long corrRet wealthTile weight, i(id) j(year)
collapse corrRet [pw=weight], by(year wealthTile)
drop if year==. | wealthTile==.
twoway line corrRet year if year<=1999, by(wealthTile)
twoway line corrRet year if year>=2001, by(wealthTile)
