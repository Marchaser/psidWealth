// Process Data
use wealth_clear, clear

// Gen returns and some uniform sample treatment
local yearName 1984 1989 1994 1999 2001 2003 2005 2007 2009 2011 2013
local nYear: word count `yearName'
local nYearM1 = `nYear'-1
forval iy = 1/`nYear' {
	local iyp1 = `iy'+1
	local y `: word `iy' of `yearName''
	cap gen retWGains`y' = kincWGains`y' / wealth2`y' if wealth2`y'>0
	gen ret`y' = kinc`y'/wealth2`y'
	
	// Drop outliers year by year
	sum ret`y', d
	// Drop extremely low wealth
	replace ret`y'=. if wealth2`y'<=0
	// Drop 99% and 1%
	replace ret`y'=. if ret`y'>`r(p99)' | ret`y'<`r(p1)'

	gen busret`y' = businc`y'/bus`y'
	gen sret`y' = sinc`y'/(stocks`y'+savings`y')
}

save ret_clear, replace
