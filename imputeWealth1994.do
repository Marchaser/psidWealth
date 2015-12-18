use raw, clear

/************** Irregular cases *****************/
// stock trades are irregular, check the following example carefully
// bro ER15075 ER15076 ER15077 ER15078 ER15083 ER15088 ER15089
/************** End ************************/

// Impute wealth with bracket value
#delimit ;

local varL
realest realestBought realestSold
vehi
bus busBought busSold
stocks stocksBought stocksSold
ira
savings
bonds
debts;

local yearL 1994;

local whetherHaveLL 
3721
3773
3778

3726

3730
3787
3792

3735
3805
3811

3757
3741
3747
3752
;

local valueLL 
3722
3774
3779

3726

3731
3788
3793

3736
3805
3811

3738
3742
3748
3753
;

local bpVarLL `"
"3723 3724 3725"
"3775 3776 3777"
"3780 3781 3782"

"3727 3728 3729"

"3732 3733 3734"
"3789 3790 3791"
"3794 3795 3796"

"3737 3738 3740 3739"
"3806 3807 3809 3808"
"3812 3813 3815 3814"

"3759 3760 3761"
"3743 3744 3746 3745"
"3749 3750 3751"
"3754 3755 3756"
"';

local bpLL `"
"50000	150000	5000"
"60000	120000	30000"
"60000	120000	30000"

"10000	25000	2000"

"50000	200000	10000"
"25000	100000	10000"
"25000	100000	10000"

"25000	50000	5000	100000"
"20000	50000	5000	100000"
"20000	50000	5000	100000"

"10000	50000	5000"

"5000 	10000	1000	50000"
"10000	25000	2000"

"2000	5000	1000"
"';

local nVars: word count `varL';


forval iv=1/`nVars' {;
	local var: word `iv' of `varL';
	local value: word `iv' of `valueLL';
	local whetherHave: word `iv' of `whetherHaveLL';
	
	local bpL: word `iv' of `bpLL';
	local bpVarL: word `iv' of `bpVarLL';
	local nbp: word count `bpL';
	forval ib=1/`nbp' {;
		local bp`ib': word `ib' of `bpL';
		local bp`ib'Var: word `ib' of `bpVarL';
	};
	
	local year 1994;
	local value = "ER`value'";
	local whetherHave = "ER`whetherHave'";
		
	replace `value'=. if inlist(`whetherHave',8,9);
	
	replace `value'=. if `value'<-999999;
	
	replace `value'=. if `value'>=9999998;
	
	
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
	
	if `nbp'==4 {;
		// stock case
		// [bp2, bp4)
		replace `value'=(`bp2'+`bp4')/2 if `bp2Var'==1 & `bp4Var'==5;
		// [bp4, inf)
		replace `value'=`bp4'*1.5 if `bp4Var'==1;
	};
	
	gen `var'`year' = `value';
};

#delimit cr




