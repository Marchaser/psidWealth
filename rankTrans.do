use wealth_clear, clear

local weight 1
local ntile 3
local homeequity 1
local dropOutlier 1

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
foreach y of local yearName {
	if `homeequity'==1 {
		rename wealthheq`y' wealth0`y'
	}
	else {
		rename wealth`y' wealth0`y'
	}
	
	if `dropOutlier'==1 {
		sum wealth0`y', d
		replace wealth0`y'=. if wealth0`y'>`r(p99)' | wealth0`y'<`r(p1)'
	}
	
	if `weight'==1 {
		// display "weight"
		xtile wealthTile`y'=wealth0`y' if wealth0`y'~=. [pw=weight`y'],n(`ntile')
	}
	else {
		// display "noweight"
		xtile wealthTile`y'=wealth0`y' if wealth0`y'~=., n(`ntile')
	}
}

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	gen wealthTileNext`y' = wealthTile`y2' if sameHead`y'`y2'==1
}

keep id weight* wealthTile* wealthTileNext*
reshape long weight wealthTile wealthTileNext, i(id) j(year)
xtset id year

if `weight'==1 {
	collapse (sum)nobs=weight, by(year wealthTile wealthTileNext)
}
else {	
	collapse (count)nobs=id, by(year wealthTile wealthTileNext)
}
drop if year==. | wealthTile==. | wealthTileNext==.
bysort year wealthTile: egen nobsTile=total(nobs)
gen trans = nobs/nobsTile

egen wealthTileGroup=group(wealthTile wealthTileNext)
drop wealthTile wealthTileNext

// reshape trans to wide
drop nobsTile*
reshape wide nobs trans, i(year) j(wealthTileGroup)
order year trans* nobs*
