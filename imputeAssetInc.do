// use raw, clear

#delimit ;
// impute asset income
local varL
rentH divH intH trustH
rentW divW intW trustW othsW
;

local debug=0;

local yearL 1994	1995	1996	1997	1999	2001	2003	2005	2007	2009	2011 2013;

local whetherHaveLL `"
"	3202	6202	8319	11212	14478	18633	22002	25983	37001	42992	48314	53991"
"	3217	6217	8334	11227	14493	18649	22019	26000	37018	43009	48331	54008"
"	3232	6232	8349	11242	14508	18665	22036	26017	37035	43026	48348	54025"
"	3247	6247	8364	11257	14523	18681	22053	26034	37052	43043	48365	54042"
"							22335	26316	37334	43325	48650	54344"
"	3523	6524	8641	11523	14789	18965	22352	26333	37351	43342	48667	54361"
"	3538	6539	8656	11538	14804	18981	22369	26350	37368	43359	48684	54378"
"	3553	6554	8671	11553	14819	18997	22386	26367	37385	43376	48701	54395"
"	3568	6569	8686	11568	14834	19013						"
"';


local startYearL 
0 0 0 0
6 0 0 0 0
;

local nVars: word count `varL';

forval iv=1/`nVars' {;
	local whetherHaveL: word `iv' of `whetherHaveLL';
	local v: word `iv' of `varL';
	
	local nYears: word count `whetherHaveL';
	local startYear: word `iv' of `startYearL';
	
	if `debug'==1 {;
		display "`whetherHaveL'";
		display "`v'";
		display `nYears';
		display `startYear';
	};
	
	forval iy=1/`nYears' {;
		local whetherHave: word `iy' of `whetherHaveL';
		local amount = `whetherHave'+1;
		local per = `amount'+1;
		local yearIdx = `iy'+`startYear';
		local year: word `yearIdx' of `yearL';
		
		local whetherHave = "ER`whetherHave'";
		local amount = "ER`amount'";
		local per = "ER`per'";
		
		if `debug'==1 {;
			display "`year'";
			display "`v'";
			display "`whetherHave'";
			display "`amount'";
			display "`per'";
		};
		
		if `year'<=1995	{;
			gen `v'`year'=cond(
				`per'==1,`amount'*12,cond(
				`per'==2,`amount'*4,cond(
				`per'==3,`amount'*2,cond(
				`per'==4,`amount'*1,.))));
				
			replace `v'`year'=0 if `whetherHave'==5;
			replace `v'`year'=. if inlist(`whetherHave',8,9);
			replace `v'`year'=. if `amount'>=999998;
			replace `v'`year'=. if `amount'<=-99999;
		};
		else {;
			gen `v'`year'=cond(
				`per'==3,`amount'*52,cond(
				`per'==4,`amount'*26,cond(
				`per'==5,`amount'*12,cond(
				`per'==6,`amount'*1,.))));
				
			replace `v'`year'=0 if `whetherHave'==5;
			replace `v'`year'=. if inlist(`whetherHave',8,9);
			replace `v'`year'=. if `amount'>=999998;
			replace `v'`year'=. if `amount'<=-99999;	
		};
	};
};
