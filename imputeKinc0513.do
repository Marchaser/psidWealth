/*
Persistent risk and wealth distribution
Author: Dan Cao and Wenlan Luo
Read capital income 2005-2013. This is obsolete.
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
