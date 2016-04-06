// saving income ratio
use wealth_clear, clear

label define gGroupLab 1 "Staying Worker" /// 
2 "Switching Worker" ///
3 "Switching Entre" ///
4 "Staying Entre"

// group of entrepreneurs
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
cap drop g*
// rank persistence
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	// gen gStayingEntre`y' = (hasBus`y'==1 & hasBus`y2'==1)
	// gen gSwitchingEntre`y' = (hasBus`y'==1 & hasBus`y2'==0)
	// gen gStayingWorker`y' = (hasBus`y'==0 & hasBus`y2'==0)
	// gen gSwitchingWorker`y' = (hasBus`y'==0 & hasBus`y2'==1)
	egen gGroup`y' = group(hasBus`y' hasBus`y2')
	// xtile wealthTile`y'=wealthheq`y' [pw=weight`y'], n(3)
	// cap xtile incTile`y'=totinc`y' [pw=weight`y'], n(10)
	gen deltaWealth`y' = (wealthheq`y2' - wealthheq`y') / (`y2'-`y')
	gen isNextSameHead`y' = sameHead`y'`y2'
	// xtile wealthTile`y'=wealthheq`y', n(3)
	// xtile wealthTile`y'=wealthheq`y' [pw=weight`y'] if sameHead`y'`y2'==1,n(3)
	// xtile wealthTile`y'=wealthImp`y', n(3)
	// xtile wealthTile`y'=wealthheq`y' if gGroup`y'~=.,n(3)
	// keep if gGroup`y'==4
	label values gGroup`y' gGroupLab
}


keep id gGroup* isNextSameHead* deltaWealth* faminc* weight*

reshape long gGroup isNextSameHead deltaWealth faminc weight, i(id) j(year)
save savingIncRatio, replace

use savingIncRatio, clear
gen savingIncRatio = deltaWealth / faminc if faminc>0
gen yearGroup=cond(year<=1999,1,cond(year<=2005,2,cond(year<=2009,3,4)))
collapse (median)savingIncRatio (median)deltaWealth (median)faminc (count)id [pw=weight] if isNextSameHead==1,by(yearGroup gGroup)
drop if gGroup==.

// collapse savingIncRatio deltaWealth faminc, by(gGroup)

label define gGroupLab 1 "Staying Worker" /// 
2 "Switching Worker" ///
3 "Switching Entre" ///
4 "Staying Entre"
label values gGroup gGroupLab

label define yearGroupLab 1 "1984-1999" ///
2 "2001-2005" ///
3 "2007-2009" ///
4 "2011-2013"
label values yearGroup yearGroupLab
// export excel savingByType.xlsx
