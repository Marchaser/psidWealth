// macro
freduse CPIAUCSL, clear
rename CPIAUCSL cpi
gen year=year(daten)
collapse (mean) cpi, by(year)
gen cpi2014 = cpi[_N-1]
gen deflator = cpi/cpi2014
save cpi_annual, replace
