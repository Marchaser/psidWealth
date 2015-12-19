// use raw, clear

/************** Irregular cases *****************/
// stock trades are irregular, check the following example carefully
// bro ER15075 ER15076 ER15077 ER15078 ER15083 ER15088 ER15089
/************** End ************************/

local imputation -1

// Impute wealth with bracket value
#delimit ;

local varL
realest realestBought realestSold
vehi
bus busBought busSold
stocks stocksBought stocksSold
savings
bonds
debts;

local yearL 1994;

local whetherHaveLL 
17317
17345
17348

17320

17322
17354
17357

17325
17365
17368

17328
17331
17334
;

local valueLL 
17318
17346
17349

17321

17323
17355
17358

17326
17365
17368

17329
17332
17335
;

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
	local nbp: word count `bpL';
	local bpVar = `value'+1;
	local bpVar="V`bpVar'";
	forval ib=1/`nbp' {;
		local bp`ib': word `ib' of `bpL';
	};
	
	local year 1989;
	local value = "V`value'";
	local whetherHave = "V`whetherHave'";
		
	replace `value'=. if inlist(`whetherHave',8,9);
	
	replace `value'=. if `value'<-999999;
	
	replace `value'=. if `value'>9999999;
	
	
	if `imputation'==0 {;
	if `nbp'==3 {;
		// (0, bp3]
		replace `value'=`bp3'/2 if `bpVar'==1;
		// (bp3, bp1]
		replace `value'=(`bp3'+`bp1')/2 if `bpVar'==2;
		// (bp1, bp2]
		replace `value'=(`bp1'+`bp2')/2 if `bpVar'==3;
		// (bp2, inf]
		replace `value'=`bp2'*1.5 if `bpVar'==4;
		// (0, bp1]
		replace `value'=`bp1'/2 if `bpVar'==5;
		// (bp1, inf)
		replace `value'=`bp1'*1.5 if `bpVar'==6;
		// DK and Refused
		replace `value'=. if inlist(`bpVar',7,8,9);
	};
	
	if `nbp'==4 {;
		// (0, bp3]
		replace `value'=`bp3'/2 if `bpVar'==1;
		// (bp3, bp1]
		replace `value'=(`bp3'+`bp1')/2 if `bpVar'==2;
		// (bp1, bp2]
		replace `value'=(`bp1'+`bp2')/2 if `bpVar'==3;
		// (bp2, bp4]
		replace `value'=(`bp2'+`bp4')/2 if `bpVar'==4;
		// (bp4, inf]
		replace `value'=`bp2'*1.5 if `bpVar'==5;
		// (0, bp1]
		replace `value'=`bp1'/2 if `bpVar'==6;
		// (bp1, inf)
		replace `value'=`bp1'*1.5 if `bpVar'==7;
		// (bp2, inf)
		replace `value'=`bp2'*1.5 if `bpVar'==8;
		// DK and Refused
		replace `value'=. if inlist(`bpVar',97,98,99);
	};
	};
	
	gen `var'`year' = `value';
};

#delimit cr




