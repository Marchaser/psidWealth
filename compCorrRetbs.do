local nboot 100
local bootstart 0

set seed 0823
set more off

forval ib=1/`nboot' {
use wealth_clear, clear
bsample
drop id
gen id=_n

run compCorrRet

local ibshift = `ib'+`bootstart'
gen ibootstrap=`ibshift'
save bootstrap/corrRet_`ibshift', replace
}
