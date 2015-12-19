// use raw, clear

/************** Irregular cases *****************/
// stock trades are irregular, check the following example carefully
// bro ER15075 ER15076 ER15077 ER15078 ER15083 ER15088 ER15089
/************** End ************************/

local imputation -1

// Impute wealth with bracket value
#delimit ;

local varL
realestWorth realestDebt
vehi
busWorth busDebt
stocks
ira
savings
bonds
;

local yearL 2013;

local whetherHaveLL `" 
"ER54610"
"ER54610"

"ER54620"

"ER54624"
"ER54624"

"ER54633"

"ER54653"
"ER54660"
"ER54681"
"';

local valueLL `"
"ER54612"
"ER54616"

"ER54620"

"ER54625"
"ER54629"

"ER54634"

"ER54655"
"ER54661"
"ER54682"
"';

local bp1VarLL `"
"ER54613"
"ER54617"

"ER54621"

"ER54626"
"ER54630"

"ER54635"

"ER54656"
"ER54662"
"ER54683"
"';

local bp2VarLL `"
"ER54614"
"ER54618"

"ER54622"

"ER54627"
"ER54631"

"ER54637"

"ER54657"
"ER54663"
"ER54684"
"';

local bp3VarLL `"
"ER54615"
"ER54619"

"ER54623"

"ER54628"
"ER54632"

"ER54636"

"ER54658"
"ER54680"
"ER54685"
"';

local bp4VarLL `"
""
""

""

""
""

""

"ER54659"
"ER54664"
""
"';

local bpLL `"
"50000	175000	20000"
"50000	175000	20000"

"10000	25000	2000"

"50000	200000	10000"
"50000	200000	10000"

"50000	150000	15000"

"50000 	100000	15000	250000"
"5000 	10000	1000	50000"
"10000	25000	2000"
"';

local nVars: word count `varL';


forval iv=1/`nVars' {;
	local var: word `iv' of `varL';
	local valueL: word `iv' of `valueLL';
	local nYears: word count `valueL';
	
	local whetherHaveL: word `iv' of `whetherHaveLL';
	
	local bpL: word `iv' of `bpLL';
	local nbp: word count `bpL';
	forval ib=1/`nbp' {;
		local bp`ib': word `ib' of `bpL';
		local bp`ib'VarL: word `iv' of `bp`ib'VarLL';
	};
	
	forval iy=1/`nYears' {;
		local whetherHave: word `iy' of `whetherHaveL';
		
		forval ib=1/`nbp' {;
			local bp`ib'Var: word `iy' of `bp`ib'VarL';
		};	
		
		local value: word `iy' of `valueL';
		local year: word `iy' of `yearL';
		
		replace `value'=. if `value'<=-99999999;
		replace `value'=. if `value'>=999999997;
		replace `value'=. if inlist(`whetherHave',8,9);
		
		local v = "`var'`year'";
			
		gen `v' = `value';
		
		if `imputation'==0 {;
		/*
		// population average if report DK and NA
		/*
		sum `value', d;
		replace `v'=`r(mean)' if inlist(`whetherHave',8,9);
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year';
		predict temp;
		replace `v'=temp if inlist(`whetherHave',8,9);
		drop temp;
		*/
		
		// [bp1, bp2)
		/*
		sum `value' if inrange(`value',`bp1',`bp2');
		replace `v'=`r(mean)' if `bp1Var'==1 & `bp2Var'==5;
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if inrange(`value',`bp1',`bp2');
		predict temp;
		replace `v'=temp if `bp1Var'==1 & `bp2Var'==5;
		drop temp;
		// [bp2, inf)
		/*
		sum `value' if `value'>=`bp2';
		replace `v'=`r(mean)' if `bp2Var'==1;
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if `value'>=`bp2';
		predict temp;
		replace `v'=temp if `bp2Var'==1;
		drop temp;		
		// [bp3, bp1)
		/*
		sum `value' if inrange(`value',`bp3',`bp1');
		replace `v'=`r(mean)' if `bp1Var'==5 & `bp3Var'==1;
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if inrange(`value',`bp3',`bp1');
		predict temp;
		replace `v'=temp if `bp1Var'==5 & `bp3Var'==1;
		drop temp;		
		// [0, bp3)
		/*
		sum `value' if inrange(`value',0,`bp3');
		replace `v'=`r(mean)' if `bp3Var'==5;
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if inrange(`value',0,`bp3');
		predict temp;
		replace `v'=temp if `bp3Var'==5;
		drop temp;		
		// [bp1, inf)
		/*
		sum `value' if `value'>=`bp1';
		replace `v'=`r(mean)' if `bp1Var'==1 & inlist(`bp2Var',8,9);
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if `value'>=`bp1';
		predict temp;
		replace `v'=temp if `bp1Var'==1 & inlist(`bp2Var',8,9);
		drop temp;		
		// [0, bp1)
		/*
		sum `value' if inrange(`value',0,`bp1');
		replace `v'=`r(mean)' if `bp1Var'==5 & inlist(`bp3Var',8,9);
		*/
		reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if inrange(`value',0,`bp1');
		predict temp;
		replace `v'=temp if `bp1Var'==5 & inlist(`bp3Var',8,9);
		drop temp;	
		
		if `nbp'==4 {;
			// stock case
			// [bp2, bp4)
			/*
			sum `value' if inrange(`value',`bp2',`bp4');
			replace `v'=`r(mean)' if `bp2Var'==1 & `bp4Var'==5;
			*/
			reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if inrange(`value',`bp2',`bp4');
			predict temp;
			replace `v'=temp if `bp2Var'==1 & `bp4Var'==5;
			drop temp;	
			// [bp4, inf)
			/*
			sum `value' if `value'>=`bp4';
			replace `v'=`r(mean)' if `bp4Var'==1;
			*/
			reg `value' faminc`year' ageH`year' i.race`year' i.eduH`year' i.ownrent`year' i.mortgage`year' if `value'>=`bp4';
			predict temp;
			replace `v'=temp if `bp4Var'==1;
			drop temp;	
		};
		}; // (if imputation==0)
	};
};

#delimit cr




