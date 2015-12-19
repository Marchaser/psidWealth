/************** Irregular cases *****************/
// stock trades are irregular, check the following example carefully
// bro ER15075 ER15076 ER15077 ER15078 ER15083 ER15088 ER15089
/************** End ************************/

local imputation -1

// Impute wealth with bracket value
#delimit ;

local varL
realest
vehi
bus
stocks
savings
bonds
debts;

local yearL 1994;

local whetherHaveLL 
10898

10903

10907

10912

10917
10922
10932
;

local bpLL `"
"25000	100000	1000"

"5000	25000	1000"

"25000	100000	1000"

"10000	100000	1000"

"10000	100000	1000"
"10000	100000	1000"

"5000	25000	1000"
"';

local nVars: word count `varL';


forval iv=1/`nVars' {;
	local var: word `iv' of `varL';
	local whetherHave: word `iv' of `whetherHaveLL';
	local value=`whetherHave'+1;
	
	local bpL: word `iv' of `bpLL';
	local nbp: word count `bpL';
	forval ib=1/`nbp' {;
		local bp`ib': word `ib' of `bpL';
		local bp`ib'Var = `value'+`ib';
		local bp`ib'Var="V`bp`ib'Var'";
	};
	
	
	
	local year 1984;
	local value = "V`value'";
	local whetherHave = "V`whetherHave'";
	
	
	replace `value'=. if inlist(`whetherHave',8,9);
	
	replace `value'=. if `value'<-999999;
	
	replace `value'=. if `value'>=9999997;
	
	if `imputation'==0 {;
	// [bp1, bp2)
	replace `value'=(`bp1'+`bp2')/2 if `bp1Var'==1 & `bp2Var'==5;
	// [bp2, inf)
	replace `value'=`bp2'*1.5 if `bp2Var'==1;
	// [bp3, bp1)
	replace `value'=(`bp3'+`bp1')/2 if `bp1Var'==5 & `bp3Var'==1;
	// [0, bp3)
	replace `value'=`bp3'/2 if `bp3Var'==5;
	// [bp1, inf)
	replace `value'=`bp1'*1.5 if `bp1Var'==1 & inlist(`bp2Var',8,9);
	// [0, bp1)
	replace `value'=`bp1'/2 if `bp1Var'==5 & inlist(`bp3Var',8,9);
	};
	
	gen `var'`year' = `value';
};

#delimit cr




