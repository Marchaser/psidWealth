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
ira
savings
bonds
debts;

local yearL 1999 2001 2003 2005 2007 2009 2011 2013;

local whetherHaveLL `" 
"ER14991	ER19187	ER22552	ER26533	ER37551	ER43542	ER48867"
"ER15051	ER19247	ER22642	ER26623	ER37641	ER43632	ER48977"
"ER15056	ER19252	ER22647	ER26628	ER37646	ER43637	ER48982"

"ER14997	ER19193	ER22558	ER26539	ER37557	ER43548	ER48873"

"ER15001	ER19197	ER22562	ER26543	ER37561	ER43552	ER48877"
"ER15065	ER19261	ER22656	ER26637	ER37655	ER43646	ER48991"
"ER15070	ER19266	ER22661	ER26642	ER37660	ER43651	ER48996"

"ER15006	ER19202	ER22567	ER26548	ER37566	ER43557	ER48882"
"ER15083	ER19279	ER22674	ER26655	ER37673	ER43664	ER49009"
"ER15089	ER19285	ER22680	ER26661	ER37679	ER43670	ER49015"

"ER15012	ER19208	ER22588	ER26569	ER37587	ER43578	ER48903"
"ER15019	ER19215	ER22595	ER26576	ER37594	ER43585	ER48910"
"ER15025	ER19221	ER22616	ER26597	ER37615	ER43606	ER48931"

"ER15030	ER19226	ER22621	ER26602	ER37620	ER43611"
"';

local valueLL `"
"ER14993	ER19189	ER22554	ER26535	ER37553	ER43544	ER48869"
"ER15052	ER19248	ER22643	ER26624	ER37642	ER43633	ER48978"
"ER15057	ER19253	ER22648	ER26629	ER37647	ER43638	ER48983"

"ER14997	ER19193	ER22558	ER26539	ER37557	ER43548	ER48873"

"ER15002	ER19198	ER22563	ER26544	ER37562	ER43553	ER48878"
"ER15066	ER19262	ER22657	ER26638	ER37656	ER43647	ER48992"
"ER15071	ER19267	ER22662	ER26643	ER37661	ER43652	ER48997"

"ER15007	ER19203	ER22568	ER26549	ER37567	ER43558	ER48883"
"ER15083	ER19279	ER22674	ER26655	ER37673	ER43664	ER49009"
"ER15089	ER19285	ER22680	ER26661	ER37679	ER43670	ER49015"

"ER15014	ER19210	ER22590	ER26571	ER37589	ER43580	ER48905"
"ER15020	ER19216	ER22596	ER26577	ER37595	ER43586	ER48911"
"ER15026	ER19222	ER22617	ER26598	ER37616	ER43607	ER48932"

"ER15031	ER19227	ER22622	ER26603	ER37621	ER43612"
"';

local bp1VarLL `"
"ER14994	ER19190	ER22555	ER26536	ER37554	ER43545	ER48870"
"ER15053	ER19249	ER22644	ER26625	ER37643	ER43634	ER48979"
"ER15058	ER19254	ER22649	ER26630	ER37648	ER43639	ER48984"

"ER14998	ER19194	ER22559	ER26540	ER37558	ER43549	ER48874"

"ER15003	ER19199	ER22564	ER26545	ER37563	ER43554	ER48879"
"ER15067	ER19263	ER22658	ER26639	ER37657	ER43648	ER48993"
"ER15072	ER19268	ER22663	ER26644	ER37662	ER43653	ER48998"

"ER15008	ER19204	ER22569	ER26550	ER37568	ER43559	ER48884"
"ER15084	ER19280	ER22675	ER26656	ER37674	ER43665	ER49010"
"ER15090	ER19286	ER22681	ER26662	ER37680	ER43671	ER49016"

"ER15015	ER19211	ER22591	ER26572	ER37590	ER43581	ER48906"
"ER15021	ER19217	ER22597	ER26578	ER37596	ER43587	ER48912"
"ER15027	ER19223	ER22618	ER26599	ER37617	ER43608	ER48933"

"ER15032	ER19228	ER22623	ER26604	ER37622	ER43613"
"';

local bp2VarLL `"
"ER14995	ER19191	ER22556	ER26537	ER37555	ER43546	ER48871"
"ER15054	ER19250	ER22645	ER26626	ER37644	ER43635	ER48980"
"ER15059	ER19255	ER22650	ER26631	ER37649	ER43640	ER48985"

"ER14999	ER19195	ER22560	ER26541	ER37559	ER43550	ER48875"

"ER15004	ER19200	ER22565	ER26546	ER37564	ER43555	ER48880"
"ER15068	ER19264	ER22659	ER26640	ER37658	ER43649	ER48994"
"ER15073	ER19269	ER22664	ER26645	ER37663	ER43654	ER48999"

"ER15009	ER19205	ER22570	ER26551	ER37569	ER43560	ER48885"
"ER15085	ER19281	ER22676	ER26657	ER37675	ER43666	ER49011"
"ER15091	ER19287	ER22682	ER26663	ER37681	ER43672	ER49017"

"ER15016	ER19212	ER22592	ER26573	ER37591	ER43582	ER48907"
"ER15022	ER19218	ER22598	ER26579	ER37597	ER43588	ER48913"
"ER15028	ER19224	ER22619	ER26600	ER37618	ER43609	ER48934"

"ER15033	ER19229	ER22624	ER26605	ER37623	ER43614"
"';

local bp3VarLL `"
"ER14996	ER19192	ER22557	ER26538	ER37556	ER43547	ER48872"
"ER15055	ER19251	ER22646	ER26627	ER37645	ER43636	ER48981"
"ER15060	ER19256	ER22651	ER26632	ER37650	ER43641	ER48986"

"ER15000	ER19196	ER22561	ER26542	ER37560	ER43551	ER48876"

"ER15005	ER19201	ER22566	ER26547	ER37565	ER43556	ER48881"
"ER15069	ER19265	ER22660	ER26641	ER37659	ER43650	ER48995"
"ER15074	ER19270	ER22665	ER26646	ER37664	ER43655	ER49000"

"ER15011	ER19207	ER22571	ER26552	ER37570	ER43561	ER48886"
"ER15087	ER19283	ER22678	ER26659	ER37677	ER43668	ER49013"
"ER15093	ER19289	ER22684	ER26665	ER37683	ER43674	ER49019"

"ER15018	ER19214	ER22593	ER26574	ER37592	ER43583	ER48908"
"ER15024	ER19220	ER22600	ER26581	ER37599	ER43590	ER48915"
"ER15029	ER19225	ER22620	ER26601	ER37619	ER43610	ER48935"

"ER15034	ER19230	ER22625	ER26606	ER37624	ER43615"
"';

local bp4VarLL `"
""
""
""

""

""
""
""

"ER15010	ER19206	ER22572	ER26553	ER37571	ER43562	ER48887"
"ER15086	ER19282	ER22677	ER26658	ER37676	ER43667	ER49012"
"ER15092	ER19288	ER22683	ER26664	ER37682	ER43673	ER49018"

"ER15017	ER19213	ER22594	ER26575	ER37593	ER43584	ER48909"
"ER15023	ER19219	ER22599	ER26580	ER37598	ER43589	ER48914"
""

""
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

"25000	50000	5000	100000"
"5000 	10000	1000	50000"
"10000	25000	2000"

"2000	5000	1000"
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




