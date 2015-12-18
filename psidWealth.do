cd D:\data\psidWealth
set more off
global path D:\data\psidWealth

/*
do J203274
save raw, replace
*/
use raw, clear

// drop latino famlies
drop if V17702>=10001 & V17702<=12043
drop if ER4120==9999999

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

// whether business
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10872 V17299 ER3096 ER14349 ER18489 ER21857 ER25838 ER36856	ER42847	ER48169	ER53863
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	// replace `v'=cond(`v'==1,1,cond(`v'==5,0,.))
	replace `v'=cond(`v'==1,1,cond(`v'==5,0,.))
	rename `v' hasBus`y'
}


// 1984 to 2007
// year index
local yearName 1984 1989 1994 1999 2001 2003 2005 2007
local varList 03 05 09 11 13 15 07 20 16 17
local varName bus saving realest stocks vehi others debt hequity wealth wealthheq
local yearList 1 2 3 4 5 6 7 8
local nVar: word count `varList'
local nYear: word count `yearList'
forval iv=1/`nVar' {
	local v `: word `iv' of `varList''
	local vname `: word `iv' of `varName''
	forval iy=1/`nYear' {
		local y `: word `iy' of `yearList''
		local yname `: word `iy' of `yearName''
		// display S`y'`v'
		gen `vname'`yname' = S`y'`v' 
	}
}
// manually rename for 2009 2011 2013
rename ER46938 bus2009
rename ER46942 saving2009
rename ER46946 debt2009
rename ER46950 realest2009
rename ER46954 stocks2009
rename ER46956 vehi2009
rename ER46960 others2009
rename ER46966 hequity2009
rename ER46968 wealth2009
rename ER46970 wealthheq2009

rename ER52346 bus2011
rename ER52350 saving2011
rename ER52354 realest2011
rename ER52358 stocks2011
rename ER52360 vehi2011
rename ER52364 others2011
rename ER52390 hequity2011
rename ER52392 wealth2011
rename ER52394 wealthheq2011
gen debt2011=ER52372+ER52376+ER52380+ER52384+ER52388

gen realest2013=ER58165-ER58167
gen bus2013=ER58155-ER58157
rename ER58161 saving2013
rename ER58171 stocks2013
rename ER58173 vehi2013
rename ER58177 others2013
rename ER58207 hequity2013
rename ER58209 wealth2013
rename ER58211 wealthheq2013
gen debt2013=ER58185+ER58189+ER58193+ER58197+ER58201+ER58205

/*
// no debt information for 2011 data  
ER52346 IMP VALUE FARM/BUS (W11) 11
ER52350 IMP VAL CHECKING/SAVING (W28) 11
ER52354 IMP VAL OTH REAL ESTATE (W2) 11
ER52358 IMP VALUE STOCKS (W16) 11
ER52360 IMP VALUE VEHICLES (W6) 11
ER52364 IMP VALUE OTH ASSETS (W34) 11
ER52390 IMP VALUE HOME EQUITY 11
*/

// return 1984
rename V11407 businc1984
rename V11412 rent1984
rename V11414 intdiv1984
rename V11417 wifeothers1984

// return 1989
rename V17839 businc1989
rename V17844 rent1989
rename V17846 intdiv1989
rename V17849 wifeothers1989

/************ return 1994 **************************/
// head rent
local varNum 6203
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen rentHead1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))

// head dividends
local varNum 6218
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsHead1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))

// head interest
local varNum 6233
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestHead1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))

// head trust
local varNum 6248
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustHead1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))

// wife dividends
local varNum 6525
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsWife1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))

// wife interest
local varNum 6540
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestWife1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))

// wife trust
local varNum 6555
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustWife1994=cond(ER`varNumP1'==1,ER`varNum'*12, ///
cond(ER`varNumP1'==2,ER`varNum'*4, ///
cond(ER`varNumP1'==3,ER`varNum'*2, ///
cond(ER`varNumP1'==4,ER`varNum'*1,0))))


// replace ER4120=. if ER4120==9999999
// replace ER4142=. if ER4142==9999999
gen busincHead1994=ER6960
gen busincWife1994=ER6982

/***************** 1999 ************************/
// head rent
local varNum 14479
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen rentHead1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head dividends
local varNum 14494
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsHead1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head interest
local varNum 14509
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestHead1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head trust
local varNum 14524
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustHead1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife dividends
local varNum 14790
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsWife1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife interest
local varNum 14805
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestWife1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife trust
local varNum 14820
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustWife1999=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

gen busincHead1999=ER16491
gen busincWife1999=ER16512

/***************** 2001 ************************/
// head rent
local varNum 18634
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen rentHead2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head dividends
local varNum 18650
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsHead2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head interest
local varNum 18666
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestHead2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head trust
local varNum 18682
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustHead2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife dividends
local varNum 18966
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsWife2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife interest
local varNum 18982
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestWife2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife trust
local varNum 18998
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustWife2001=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

gen busincHead2001=ER20423
gen busincWife2001=ER20445

/***************** 2003 ************************/
// head rent
local varNum 22003
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen rentHead2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head dividends
local varNum 22020
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsHead2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head interest
local varNum 22037
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestHead2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// head trust
local varNum 22054
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustHead2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife dividends
local varNum 22353
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsWife2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife interest
local varNum 22370
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestWife2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

// wife trust
local varNum 22387
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustWife2003=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))

gen busincHead2003=ER20423
gen busincWife2003=ER20445

/******** uncomment this to inspect the manual aggregation and Michigan-PSID aggregation **********
/***************** 2005 ************************/
// head rent
local varNum 25984
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen rentHead2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen rentHeadImp2005=ER27932

// head dividends
local varNum 26001
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsHead2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen dividendsHeadImp2005=ER27934

// head interest
local varNum 26018
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestHead2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen interestHeadImp2005=ER27936

// head trust
local varNum 26035
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustHead2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen trustHeadImp2005=ER27938

// wife rent
local varNum 26317
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen rentWife2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen rentWifeImp2005=ER27945

// wife dividends
local varNum 26334
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen dividendsWife2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen dividendsWifeImp2005=ER27947

// wife interest
local varNum 26351
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen interestWife2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen interestWifeImp2005=ER27949

// wife trust
local varNum 26368
local varNumP1 = `varNum'+1
replace ER`varNum'=. if ER`varNum'>=9999998 | ER`varNum'<=-99999
gen trustWife2005=cond(ER`varNumP1'==3,ER`varNum'*52, ///
cond(ER`varNumP1'==4,ER`varNum'*26, ///
cond(ER`varNumP1'==5,ER`varNum'*12, ///
cond(ER`varNumP1'==6,ER`varNum'*1,0))))
gen trustWifeImp2005=ER27951

// business
replace ER27911=. if ER27911==9999999
replace ER27941=. if ER27941==9999999
gen busincHead2005=ER27911
gen busincWife2005=ER27941
*/

/********* 2005-2013 *********/
local varName busincHead rentHead dividendsHead interestHead trustHead busincWife rentWife dividendsWife interestWife trustWife
local yearName 2005 2007 2009 2011 2013
local varList2005 "27911 27932 27934 27936 27938 27941 27945 27947 27949 27951"
local varList2007 "40901 40922 40924 40926 40928 40931 40935 40937 40939 40941"
local varList2009 "46809 46830 46832 46834 46836 46839 46843 46845 46847 46849"
local varList2011 "52217 52238 52240 52242 52244 52247 52251 52253 52255 52257"
local varList2013 "58018 58039 58041 58043 58045 58048 58052 58054 58056 58058"
local nVar: word count `varName'
local nYear: word count `yearName'
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	// local varList: `varList`y''
	forval iv=1/`nVar' {
		local vid `: word `iv' of `varList`y'''
		local vname `: word `iv' of `varName''
		rename ER`vid' `vname'`y'
	}
}

/*****************/

/** compute capital gains **/
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	gen stocksGainsRaw`y2' = (stocks`y2' - stocks`y' - (stocksBought`y2'-stocksSold`y2'))
	// exclude top 1% and bottom 1%
	quiet sum stocksGainsRaw`y2' if stocksGainsRaw`y2'~=.,detail
	replace stocksGainsRaw`y2'=. if stocksGainsRaw`y2'<=`r(p1)' | stocksGainsRaw`y2'>=`r(p99)'
	// replace stocksGainsRaw`y2'=. if stocks`y2'==0
	
	gen realestGainsRaw`y2' = (realest`y2' - realest`y' - (realestBought`y2'-realestSold`y2'))
	quiet sum realestGainsRaw`y2' if realestGainsRaw`y2'~=.,detail
	replace realestGainsRaw`y2'=. if realestGainsRaw`y2'<=`r(p1)' | realestGainsRaw`y2'>=`r(p99)'
	// replace realestGainsRaw`y2'=. if realest`y2'==0
	
	gen busGainsRaw`y2' = (bus`y2' - bus`y' - (busBought`y2'-busSold`y2'))
	quiet sum busGainsRaw`y2' if busGainsRaw`y2'~=.,detail
	replace busGainsRaw`y2'=. if busGainsRaw`y2'<=`r(p1)' | busGainsRaw`y2'>=`r(p99)'
	// replace busGainsRaw`y2'=. if bus`y2'==0
}

// compute capital returns at annual level
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	
	// gen dividends`y2'=dividendsHead`y2'+dividendsWife`y2'
	// gen stocksReturn`y2' = (1+stocksGainsRaw`y2'/(stocks`y'+stocks`y2')*2)^(1/(`y2'-`y'))-1
	// gen stocksReturn`y2' = (stocks`y2' / (stocks`y' + stocksBought`y2'-stocksSold`y2'))^(1/(`y2'-`y'))-1
	// gen stocksReturn`y2' = stocksGainsRaw`y2'/(stocks`y'+stocks`y2')*2/(`y2'-`y')
	// gen stocksGains`y2' = stocksReturn`y2'*stocks`y2'
	// gen stocksGains`y2' = stocksGainsRaw`y2' if stocks`y2'>0 & stocks`y2'~=.
	// replace stocksGains`y2'=0 if stocksGainsRaw`y2'==0
	gen stocksGains`y2'=stocksGainsRaw`y2'/(`y2'-`y')
	
	// gen realestReturn`y2' = (1+realestGainsRaw`y2'/(realest`y'+realest`y2')*2)^(1/(`y2'-`y'))-1
	// gen realestReturn`y2' = realestGainsRaw`y2'/(realest`y'+realest`y2')*2/(`y2'-`y')
	// gen realestReturn`y2' = (realest`y2' / (realest`y' + realestBought`y2'-realestSold`y2'))^(1/(`y2'-`y'))-1
	// gen realestGains`y2' = realestReturn`y2'*realest`y2'
	// replace realestGains`y2'=0 if realestGainsRaw`y2'==0
	gen realestGains`y2'=realestGainsRaw`y2'/(`y2'-`y')
	
	// gen busReturn`y2' = (1+busGainsRaw`y2'/(bus`y'+bus`y2')*2)^(1/(`y2'-`y'))-1
	// gen busReturn`y2' = busGainsRaw`y2'/(bus`y'+bus`y2')*2/(`y2'-`y')
	// gen busReturn`y2' = (bus`y2' / (bus`y' + busBought`y2'-busSold`y2'))^(1/(`y2'-`y'))-1
	// gen busGains`y2' = busReturn`y2'*bus`y2'
	// replace busGains`y2'=0 if busGainsRaw`y2'==0
	gen busGains`y2'=busGainsRaw`y2'/(`y2'-`y')
}

/*
bro stocks1999 stocks2001 stocksBought2001 stocksSold2001 stocksGainsRaw2001 stocksReturn2001
bro realest1984 realest1989 S209 V17345 V17346 V17348 V17349 realestBought1989 realestSold1989 realestGainsRaw1989 realestReturn1989 if sameHead19841989==1
bro bus1984 bus1989 busBought1989 busSold1989 busGainsRaw1989 busGains1989 busReturn1989 if sameHead19841989==1
bro bus2001 bus2003 busBought2003 busSold2003 busGainsRaw2003 busGains2003 busReturn2003 if sameHead20012003==1
bro stocks2001 stocks2003 stocksBought2003 stocksSold2003 stocksGainsRaw2003 stocksGains2003 if sameHead20012003==1

bro stocks1984 stocks1989 stocksBought1989 stocksSold1989 stocksGainsRaw1989 stocksGains1989 stocksReturn1989 if sameHead19841989==1
*/

/* aggregate */
foreach year in 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013 {
	gen wealth2`year' = wealthheq`year' - hequity`year' - vehi`year' + debt`year'
}

foreach year in 1984 1989 1994 1999 2001 {
	gen wealthnh`year' = wealth`year' - realest`year'
}

foreach year in 1984 1989 {
	gen kinc`year' = businc`year'+intdiv`year' + rent`year' + wifeothers`year'
	// gen kincheq`year' = kinc`year'+rent`year'
}
gen kincWGains1989 = kinc1989 + stocksGains1989 + realestGains1989 + busGains1989

foreach year in 1994 1999 2001 2003 2005 2007 2009 2011 2013 {
	gen businc`year' = busincHead`year' + busincWife`year'
	gen kinc`year' = rentHead`year' + trustHead`year' + busincHead`year' + busincWife`year' + dividendsHead`year' + dividendsWife`year' ///
		+ interestHead`year' + interestWife`year'
	gen kincWGains`year' = kinc`year' + stocksGains`year' + realestGains`year' + busGains`year'
	// gen kincheq`year' = kinc`year' + rentHead`year'
}

// drop V* ER*

gen id = _n
save wealth_clear, replace
