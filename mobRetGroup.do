// mobility by group
use ret_clear, clear

local weight 1
local ntile 3
local homeequity 1

// Generate return percentile
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYear' {
	local y `: word `iy' of `yearName''
	xtile retTile`y'=ret`y' [pw=weight`y'],n(2)
	xtile retNot0Tile`y'=ret`y' if ret`y'~=0 [pw=weight`y'],n(2)
}

// Wealth trintile in the current and next survey year
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011
local nYear: word count `yearName'
forval iy = 1/`nYear' {
	local y `: word `iy' of `yearName''
	
	if `homeequity'==1{
		quiet rename wealthM`y' wealth0`y'
	}
	else {
		quiet rename wealth`y' wealth0`y'
	}
	
	if `weight'==1 {
		quiet xtile wealthTile`y'=wealth0`y' [pw=weight`y'], n(`ntile')
	}
	else {
		quiet xtile wealthTile`y'=wealth0`y', n(`ntile')
	}
}

// By return tile
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	quiet gen wealthTileNext`y' = wealthTile`y2' if sameHead`y'`y2'==1
}

// transition of each group
quiet keep id retTile* weight* wealthTile* wealthTileNext* 
quiet reshape long retTile weight wealthTile wealthTileNext, i(id) j(year)

gen yearGroup = cond(inlist(year,1984,1989,1994),1,2)
if `weight'==1 {
	quiet collapse (sum)wobs=weight (count)nobs=id, by(yearGroup retTile wealthTile wealthTileNext)
}
else {
	quiet collapse (count)wobs=id (count)nobs=id, by(yearGroup retTile wealthTile wealthTileNext)
}
quiet drop if year==. | wealthTile==. | wealthTileNext==. | retTile==.
quiet bysort yearGroup retTile wealthTile: egen wobsTile=total(wobs)
quiet gen trans = wobs/wobsTile

quiet egen wealthTileTrans=concat(wealthTileNext wealthTile)
quiet drop wealthTile wealthTileNext

// reshape trans to wide
quiet drop wobsTile*
quiet reshape wide wobs nobs trans, i(yearGroup retTile) j(wealthTileTrans) string
quiet order yearGroup retTile trans* wobs* nobs*

reshape long trans1 trans2 trans3 wobs1 wobs2 wobs3 nobs1 nobs2 nobs3, i(yearGroup retTile) j(From)
reshape wide trans1 trans2 trans3 wobs1 wobs2 wobs3 nobs1 nobs2 nobs3, i(yearGroup From) j(retTile)

order yearGroup From trans* wobs* nobs*
label define wealthGroupLab 1 "Bottom" /// 
2 "Middle" ///
3 "Top"
quiet label values From wealthGroupLab

// Output to sheet
foreach var of varlist trans* {
	format `var' %9.2f
}
outsheet using mobByRet.csv, comma replace
