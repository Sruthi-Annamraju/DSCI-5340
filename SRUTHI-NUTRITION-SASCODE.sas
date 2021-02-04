
/*Clear the library and log*/
proc datasets lib=work kill nolist;
         dm 'log' clear;
quit;

/*Call the Raw Data Set*/

proc import datafile="C:\Users\sa1082\nutrition.xlsx" out=nutri
	dbms=xlsx replace;
run;


/*Convert the Raw Data to program readable data set*/
/*Remove the unit after the values*/
data nutri1;
	set nutri;
	array par (*) serving_size total_fat--lutein_zeaxanthin vitamin_b12--water;
	do i=1 to dim (par);
		par(i)=compress(par(i),"g mg mcg IU");
	end;
	output;
run;


/*Create the character vector into the Numerical Data Vector*/
%let excludevars=s_n_;

proc sql noprint;
	select name into :charvars separated by ' '
	from dictionary.columns
	where strip(lowcase(libname))="work" and strip(lowcase(memname))="nutri1" and type="char"
	 and not indexw(upcase("&excludevars"),upcase(name));
quit; 

%let ncharvars=%sysfunc(countw(&charvars)); 
%put charvars=&charvars;
%put ncharvars=&ncharvars;

data _null_;
	set nutri1 end=lastobs;
	array charvars{*} &charvars;
	array charvals{&ncharvars};
	do i=1 to &ncharvars;
	 if input(charvars{i},?? best12.)=. and charvars{i} ne ' ' then charvals{i}+1;
	end;
	if lastobs then do;
	 length varlist $ 32767;
	 do j=1 to &ncharvars;
	 if charvals{j}=. then varlist=catx(' ',varlist,vname(charvars{j}));
	 end;
	 call symputx('varlist',varlist);
	end;
run; 

%let nvars=%sysfunc(countw(&varlist));
data nutri2;
	set nutri1;
	array charx{&nvars} &varlist;
	array x{&nvars} ;
	do i=1 to &nvars;
	 x{i}=input(charx{i},best12.);
	end;
	keep S_N_ calories lucopene x1--x73;
run;

/*Note: Data having lots of missing values so as suggesting the basic method impute it by
its mean or median value by checking the basic statistical shape of the data*/

ods trace on;
ods output Moments=moments;
proc univariate data = nutri2 plots;
	var lucopene x1--x73;
run;
ods trace off;

/*Here We have seen that most of the variable are positivily skewed so I just 
the Impute the Median Value for the missing value*/


/*Now Imputing the values at the place of Missing values*/

/* Median imputation: Use PROC STDIZE to replace missing values with mean */
proc stdize data=nutri2 out=nutri3 
      oprefix=without_         
      reponly              
      method=median;          
   var lucopene x1--x73;         
run;


/*Proceeding with the regression assumption checking*/

/*Normality Assumption*/

ods graphics on;
proc univariate data=nutri3 normal plot;
	var calories;
	qqplot calories;
run;
ods graphics off;

data nutri4;
	set nutri3;
	pp=log(log(calories));
	pp1=calories**(1/2);
	drop lucopene x4 x24 without_lucopene--without_x73; 
run;

proc univariate data=nutri4;
	qqplot pp1/normal;
run;
/*Explanation: We have seen the Quintiles-Quintiles plot it looks like the distant
from the normality so using the log transformation again check then it shows some how 
normal but if we transform the data with square root transformation then the Q-Q plot looks
normal*/

	
/*Multicolinearty Check*/

/*Checking the Correlation matrix for the association between the independent variables*/

/*H0: There is No association*/
/*H1: There is Association between the variables*/
ods trace on;
ods output PearsonCorr=corr;
proc corr data=nutri4;
	var x2--x73;
	title "Correlation Matrix";
run;
ods trace off;

/*Explanation: if the p- value less than 0.05 then we can say that the correlation exist
	between the variables*/

/*Checking the VIF (Variance inflation factor to detect the variable which are correlated*/
ods trace on;
ods output ParameterEstimates=vif;
proc reg data=nutri4;
	model pp1= x2--x73/vif tol collin;
run;
ods trace off;

data vif1;
	set vif;
	if VarianceInflation > 10 then flag="Cause of Multicolinearty";
run;

/*Explanation: Here we see that if Variance inflation factor greater than 10 then shows the 
cause of multicolinearty*/
/*Note: Now fit the model by removing those variable*/

proc reg data=nutri4;
	model pp1= x2--x73;
run;
/*Note: If we use all the variable in the model then R-Square value is approx: 97 %*/

proc reg data=nutri4;
	model pp1= x5--x34 x43 x56--x63 x66--x69 x71 x72;
run;
 
/*Note: If we use the only  variable for which VIF less than 10 then we get the R-Square: 65%*/
/*SO it seems that this model will not accurate as of able to more significant level prediction*/


/*Note: Using the Different variable selection criteria to find the most accurate model*/
/*Note: Using the mallow's CP criteria of model selection*/
proc reg data=nutri4;
	model pp1= x2--x73/selection=cp;
run;

proc reg data=nutri4;
	model pp1=x3 x7 x10 x11 x12 x14 x15 x16 x18 x21 x22 x23 x27 x28 x29 x30 x31 x32 
			x34 x35 x36 x37 x38 x39 x42 x46 x47 x49 x50 x53 x55 x56 x58 x62 x64 x65 
			x66 x67 x68 x69 x72 x73;
run;
/*Note: Using this Mallow's Cp technique we find a model which shows the 97 % accuracy with
less variable. Also note that the variable comes from the VIF method almost cover in this model*/

/*Now use the forward regression technique of the variable selection*/
proc reg data=nutri4;
 model pp1= x2--x73/selection=forward
	slentry=0.05;
run;

/*Now choose the model variable and fit the model using those variable*/

proc reg data=nutri4;
	model pp1=x64 x46 x70 x56 x55 x29 x69 x35 x37 x18 x62 x68 x7 x21 x23 x3 x65 x58 
	x67 x12 x50 x40 x66 x28 x47 x49 x34 x72 x39 x42 x15 x22 x16 x38
;
run;

/*Note: Forward selection method gives the most accurate result with 97 % accuracy*/
/*It also uses the less number of variable*/

/*Note: One more important inference from the forward regression model is , it gives the 
parameter estimates with the significant p- Value*/

/*Now Applying the Backward regression*/

proc reg data=nutri4;
 model pp1= x2--x73/selection=backward
	slentry=0.05;
run;

/*Here we see that we need to remove the variable that are not significantly contribute in the model
	so if we remove the variable which having insignificant effect our final model is:*/

proc reg data=nutri4;
	model pp1=x64 x46 x70 x56 x55 x29 x69 x35 x37 x18 x62 x68 x7 x21 x23 x3 x65 x58 
	x67 x12 x50 x40 x66 x28 x47 x49 x34 x72 x39 x42 x15 x22 x16 x38
;
run;


/*Now the final Model is:*/


/*sqrt(Calories)=5.99481  +  0.28154*fat          +  0.17154*lysine  +  0.00383*ash  
-0.03564*fiber          +  	0.14748*carbohydrate  -0.00272*magnesium 
+  	0.31759*alcohol     +  	0.19382*protein       - 0.43567*arginine  
-0.00013339*lucopene    +  	0.16832*maltose        +  	0.00083062*fatty_acids_total_trans    	
-0.00083616*folic_acid  +  	-0.00067491*vitamin_c  +  	0.01786*vitamin_e  	
-0.54111*cholesterol    +  	0.51249*saturated_fatty_acids  + 0.05334*fructose    	
-0.03754*polyunsaturated_fatty_acids                +  	0.1148*vitamin_a -1.07405*serine  +  
0.02369*glutamic_acid   -  	0.01763*monounsaturated_fatty_acids  -0.01221*iron  
+  	0.92567*methionine  +  	0.23787*proline      +  	0.01493*zink  	
-0.00061001*theobromine +  	0.61509*cystine      +  	0.40608*histidine 	
-0.00020576*carotene_beta- 0.00021432*vitamin_d  +  	
0.00003574*cryptoxanthin_beta +  	0.09053*aspartic_acid  
*/

/*Explanation: Put the independent values in the model and you will find the sqaure root calories
so for the actual calories square the obtain value from the model*/
