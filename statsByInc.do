// wealth income ratio by income decile
use wealth_clear, clear

// keep only income and wealth information
keep id totinc* wealth* weight* hasBus*

// reshape to long
reshape long totinc wealth wealthheq wealthnh wealthImp weight hasBus,i(id) j(year)

// only 1984 1989 1994 year
keep if inlist(year,1984,1989,1994)

drop if totinc<1000
xtile inctile=totinc [pw=weight], n(10)

sum wealthheq
local mean_wealth=r(mean)

// collapse by inctile and hasBus
collapse (mean)wealthheq [pw=weight], by(hasBus inctile)
drop if hasBus==. | inctile==.
gen wealth_share=wealthheq/`mean_wealth'
reshape wide wealthheq wealth_share, i(inctile) j(hasBus)
save wealthByType, replace

graph bar wealth_share0 wealth_share1, over(inctile) ///
legend(label(1 "Workers") label(2 "Entreprenerus"))
graph export wealthByType.pdf, replace

/*
collapse (mean)wealth, by(inctile)
drop if inctile==.
merge 1:1 inctile using wealthByType
replace wealth0 = wealth0/wealth
replace wealth1 = wealth1/wealth
*/




/*
// drop negative income
drop if totinc<10000

// income ratio
gen wealthIncRatio = wealthheq/totinc

// by income decile tabulate wealthIncRatio


//
collapse (mean)totinc wealthheq, by(hasBus inctile)
gen wealthIncRatio = wealthheq/totinc
*/
