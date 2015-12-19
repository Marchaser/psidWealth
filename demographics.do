// demographics
// weight
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V11079					V17612						ER4160				ER16518	ER20394	ER24179	ER28078	ER41069	ER47012	ER52436	ER58257
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	rename `v' weight`y'
}

// head change
local yearName 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10010	V11112	V12510	V13710	V14810	V16310	V17710	V19010	V20310	V21608		ER2005A	ER5004A	ER7004A	ER10004A	ER13008A	ER17007	ER21007	ER25007	ER36007	ER42007	ER47307	ER53007
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	replace `v'=cond(inlist(`v',0,1,2),1,.)
	rename `v' comp`y'
}
egen sameHead19841989=rowmin(comp1985 comp1986 comp1987 comp1988 comp1989)
egen sameHead19891994=rowmin(comp1990 comp1991 comp1992 comp1993 comp1994)
egen sameHead19941999=rowmin(comp1995 comp1996 comp1997 comp1999)
gen sameHead19992001=comp2001
gen sameHead20012003=comp2003
gen sameHead20032005=comp2005
gen sameHead20052007=comp2007
gen sameHead20072009=comp2009
gen sameHead20092011=comp2011
gen sameHead20112013=comp2013

// faminc
local yearName 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V11022	V12371	V13623	V14670	V16144	V17533	V18875	V20175	V21481	V23322		ER4153	ER6993	ER9244	ER12079	ER16462	ER20456	ER24099	ER28037	ER41027	ER46935	ER52343	ER58152
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	rename `v' faminc`y'
}

// age of head
local yearName 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10419	V11606	V13011	V14114	V15130	V16631	V18049	V19349	V20651	V22406		ER2007	ER5006	ER7006	ER10009	ER13010	ER17013	ER21017	ER25017	ER36017	ER42017	ER47317	ER53017
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	rename `v' ageH`y'
}

//race
local yearName 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V11055	V11938	V13565	V14612	V16086	V17483	V18814	V20114	V21420	V23276		ER3944	ER6814	ER9060	ER11848	ER15928	ER19989	ER23426	ER27393	ER40565	ER46543	ER51904	ER57659
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	rename `v' race`y'
}

// education head
local yearName 1984 1989 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10996					V10996		V20198	V21504	V23333		ER4158	ER6998	ER9249	ER12222	ER16516	ER20457	ER24148	ER28047	ER41037	ER46981	ER52405	ER58223
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	gen eduH`y' = `v' 
}

// own rent?
local yearName 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10437	V11618	V13023	V14126	V15140	V16641	V18072	V19372	V20672	V22427		ER2032	ER5031	ER7031	ER10035	ER13040	ER17043	ER21042	ER25028	ER36028	ER42029	ER47329	ER53029
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	rename `v' ownrent`y'
}

// mortgage?
local yearName 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10438	V11619	V13024	V14127	V15141	V16642	V18073	V19373	V20673	V22428		ER2036	ER5035	ER7035	ER10039	ER13044	ER17049	ER21048	ER25039	ER36039	ER42040	ER47345	ER53045
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	rename `v' mortgage`y'
}
