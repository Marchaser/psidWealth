// Inspect data
use ret_clear, clear
keep ret*
gen id = _n
reshape long ret retWGains, i(id) j(year)
