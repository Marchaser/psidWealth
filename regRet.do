// Regression returns on covaraites
use ret_clear, clear

// Keep relavent years
rename hasBus2* hasBusAlt*
keep id *1984 *1989 *1994 *1999 *2001 *2003 *2005 *2007 *2009 *2011 *2013
keep id ageH* ownrent* mortgage* hasBus* hasBusAlt* race* weight* eduH* ret* retWGains*
order id ageH* ownrent* mortgage* hasBus* hasBusAlt* race* weight* eduH* ret* retWGains*

reshape long ageH ownrent mortgage hasBus hasBusAlt race weight eduH ret retWGains, i(id) j(year)

// Set pannel
xtset id year
reg ret i.ageH i.ownrent i.mortgage i.hasBusAlt i.race i.eduH i.year [pw=weight]
outreg2 

// Fixed effect
areg ret i.ageH i.ownrent i.mortgage i.hasBusAlt i.race i.eduH i.year [pw=weight], absorb(id)
