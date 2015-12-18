use wealth_clear, clear

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009
foreach y of local yearName {
	xtile wealthTile`y'=wealth`y',n(10)
	xtile wealthheqTile`y'=wealthheq`y',n(10)
}

local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
cap drop wRankPers
gen wRankPers=.
// rank persistence
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	display `y2'
	corr wealthTile`y' wealthTile`y2' if wealthTile`y'>=5
	// corr wealthheqTile`y' wealthheqTile`y2' if wealthheqTile`y'>=5
	// convert to one year
	replace wRankPers=r(rho) if _n==`iy'
}



line wRankPers id if _n<=3, ytitle("5-year Correlation") /// 
xlabel(1 "84-89" 2 "89-94" 3 "94-99", angle(45)) ///
xtitle("Waves") title("Wealth deciles correlation")
graph export wealthDecileCorr1.pdf, replace

line wRankPers id if _n>3 & wRankPers~=., ytitle("2-year Correlation") ///
xlabel(4 "99-01" 5 "01-03" 6 "03-05" 7 "05-07" 8 "07-09", angle(45)) /// 
xtitle("Waves") title("Wealth deciles correlation")
graph export wealthDecileCorr2.pdf, replace
