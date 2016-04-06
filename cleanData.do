cd D:\data\psidWealth
set more off
global path D:\data\psidWealth

/*
do J203301
save raw, replace
*/
use raw, clear

// drop latino famlies
drop if V17702>=10001 & V17702<=12043
drop if ER4120==9999999

// demographics
run demographics

// impute wealth
run imputeWealth1984
run imputeWealth1989
run imputeWealth1994
run imputeWealth
run imputeWealth2013

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

// whether business -- 2
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList V10907 V17322 ER3730 ER15001	ER19197	ER22562	ER26543	ER37561	ER43552	ER48877 ER54624
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	// replace `v'=cond(`v'==1,1,cond(`v'==5,0,.))
	replace `v'=cond(`v'==1,1,cond(`v'==5,0,.))
	rename `v' hasBus2`y'
}


// impute asset income
run imputeAssetInc

// business income
local yearName 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList ER4120	ER6960	ER9211	ER12194	ER16491	ER20423	ER24110	ER27911	ER40901	ER46809	ER52217	ER58018
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	replace `v'=. if `v'<=-999999
	replace `v'=. if `v'>=9999999
	rename `v' busincH`y'
}
local yearName 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local varList ER4142	ER6982	ER9233	ER12215	ER16512	ER20445	ER24112	ER27941	ER40931	ER46839	ER52247	ER58048
forval iy=1/`nYear' {
	local y `: word `iy' of `yearName''
	local v `: word `iy' of `varList''
	replace `v'=. if `v'<=-999999
	replace `v'=. if `v'>=9999999
	rename `v' busincW`y'
}

// 1984 to 2007 home equity
// year index
local yearName 1984 1989 1994 1999 2001 2003 2005 2007
local varList 20 16 17
local varName hequity wealth wealthheq
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
rename ER46966 hequity2009
rename ER46968 wealth2009
rename ER46970 wealthheq2009

rename ER52390 hequity2011
rename ER52392 wealth2011
rename ER52394 wealthheq2011
gen debts2011=ER52372+ER52376+ER52380+ER52384+ER52388

gen realest2013=realestWorth2013-realestDebt2013
gen bus2013=busWorth2013-busDebt2013
gen debts2013=ER58185+ER58189+ER58193+ER58197+ER58201+ER58205
rename ER58207 hequity2013
rename ER58209 wealth2013
rename ER58211 wealthheq2013

// return 1984
rename V11407 businc1984
replace businc1984=. if businc1984<=-99999 | businc1984>=999999
rename V11412 rent1984
rename V11414 intdiv1984
rename V11417 wifeothers1984

/*
rename V10266 businc1984
rename V11412 rent1984
rename V11414 intdiv1984
rename V11417 wifeothers1984
*/

// return 1989
rename V17839 businc1989
replace businc1989=. if businc1989<=-99999 | businc1989>=999999
rename V17844 rent1989
rename V17846 intdiv1989
rename V17849 wifeothers1989

/*
rename V16423 businc1989
rename V16428 rent1989
rename V16430 intdiv1989
rename V16433 wifeothers1989
*/

// 

/** compute capital gains **/
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYearM1' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	local y2 `: word `iyp1' of `yearName''
	gen stocksGainsRaw`y2' = (stocks`y2' - stocks`y' - (stocksBought`y2'-stocksSold`y2'))
	_pctile stocksGainsRaw`y2', p(1 99)
	replace stocksGainsRaw`y2'=. if stocksGainsRaw`y2'<`r(r1)' | stocksGainsRaw`y2'>`r(r2)' 

	gen realestGainsRaw`y2' = (realest`y2' - realest`y' - (realestBought`y2'-realestSold`y2'))
	_pctile realestGainsRaw`y2', p(1 99)
	replace realestGainsRaw`y2'=. if realestGainsRaw`y2'<`r(r1)' | realestGainsRaw`y2'>`r(r2)' 

	gen busGainsRaw`y2' = (bus`y2' - bus`y' - (busBought`y2'-busSold`y2'))
	_pctile busGainsRaw`y2', p(1 99)
	replace busGainsRaw`y2'=. if busGainsRaw`y2'<`r(r1)' | busGainsRaw`y2'>`r(r2)' 
}

// compute capital returns at annual level
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011
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

// correct for some obvious bugs
replace bus2005=0 if bus2005==1
replace bus2003=0 if bus2003==1

/*********** Wealth Aggregate *******************/
foreach y in 1984 1989 {
	gen wealthM`y' = realest`y' + bus`y' + vehi`y' + stocks`y' + savings`y'+ bonds`y' - debts`y' + hequity`y'
	gen wealth2`y' = realest`y' + bus`y' + stocks`y' + savings`y'+ bonds`y'
}

foreach y in 1994 1999 2001 2003 2005 2007 2009 2011 2013 {
	gen wealthM`y' = realest`y' + bus`y' + vehi`y' + stocks`y' + savings`y'+ bonds`y' - debts`y' + hequity`y' + ira`y'
	gen wealth2`y' = realest`y' + bus`y' + stocks`y' + savings`y'+ bonds`y' + ira`y'
}

/************ Kinc Aggregate ***********************/
foreach y in 1984 1989 {
	gen kinc`y'= businc`y'+rent`y'+intdiv`y'+wifeothers`y'
	gen sinc`y'= intdiv`y'
}

foreach y in 1994 1999 2001 2003 2005 2007 2009 2011 2013 {
	gen businc`y' = busincH`y'+busincW`y'
	gen sinc`y' = divH`y'+intH`y'+divW`y'+intW`y'
}
foreach y in 1994 1999 2001 {
	// rent of wife is included in other asset income for wife
	gen kinc`y' = rentH`y'+divH`y'+intH`y'+trustH`y'+divW`y'+intW`y'+trustW`y'+othsW`y'+businc`y'
}
foreach y in 2003 2005 2007 2009 2011 2013 {
	// rent of wife is separate. no other asset income for wife
	gen kinc`y' = rentH`y'+divH`y'+intH`y'+trustH`y'+rentW`y'+divW`y'+intW`y'+trustW`y'+businc`y'
}

foreach y in 1989 1994 1999 2001 2003 2005 2007 2009 2011 {
	gen kGains`y' = stocksGains`y' + realestGains`y' + busGains`y'
	gen kincWGains`y' = kinc`y' + stocksGains`y' + realestGains`y' + busGains`y'
}

drop V* ER* S* 

gen id = _n
save wealth_clear, replace
