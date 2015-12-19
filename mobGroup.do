// mobility by group
use wealth_clear, clear

local weight 1
local ntile 3
local homeequity 1

// group of entrepreneurs
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011
local nYear: word count `yearName'
// rank persistence
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

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	quiet egen gGroup`y' = group(hasBus`y' hasBus`y2') if sameHead`y'`y2'==1
	label values gGroup`y' gGroupLab
	quiet gen wealthTileNext`y' = wealthTile`y2' if sameHead`y'`y2'==1
}

// transition of each group
quiet keep id gGroup* weight* wealthTile* wealthTileNext* 
quiet reshape long gGroup weight wealthTile wealthTileNext, i(id) j(year)

if `weight'==1 {
	quiet collapse (sum)wobs=weight (count)nobs=id, by(year gGroup wealthTile wealthTileNext)
}
else {
	quiet collapse (count)wobs=id (count)nobs=id, by(year gGroup wealthTile wealthTileNext)
}
quiet drop if year==. | wealthTile==. | wealthTileNext==. | gGroup==.
quiet bysort year gGroup wealthTile: egen wobsTile=total(wobs)
quiet gen trans = wobs/wobsTile

quiet egen wealthTileTrans=concat(wealthTile wealthTileNext)
quiet drop wealthTile wealthTileNext

// reshape trans to wide
quiet drop wobsTile*
quiet reshape wide wobs nobs trans, i(year gGroup) j(wealthTileTrans) string
quiet order year gGroup trans* wobs* nobs*

label define gGroupLab 1 "Staying Worker" /// 
2 "Switching Worker" ///
3 "Switching Entre" ///
4 "Staying Entre"
quiet label values gGroup gGroupLab

line trans33 year if gGroup==1
line trans33 year if gGroup==2
line trans33 year if gGroup==3
line trans33 year if gGroup==4
