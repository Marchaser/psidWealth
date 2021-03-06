/*
Persistent risk and wealth distribution
Author: Dan Cao and Wenlan Luo
Portal to wealth class transition bootstrap procedure
*/

// portal to bootstrap
local nboot 100
local bootstart 0

set seed 0823
set more off

forval ib=1/`nboot' {
use wealth_clear, clear
bsample
drop id
gen id=_n

run rankTrans

local ibshift = `ib'+`bootstart'
gen ibootstrap=`ibshift'
save bootstrap/rankTrans_`ibshift', replace
}
