/*Call the Raw Data Set*/

proc import datafile="C:\Users\sa1082\Turmeric.xlsx" out=turmeric
	dbms=xlsx replace;
run;
title 'correlation procedure of the variables';
proc corr data=turmeric;
 var obs ODISHA ANDHRAPRADESH KARNATAK MAHARASHTRA TAMILNADU TELENGANA;
 run;
 title 'Means for the states related to turmeric';
proc means data=turmeric;
var obs ODISHA ANDHRAPRADESH KARNATAK MAHARASHTRA TAMILNADU TELENGANA;
run;
/*Plotting the data*/
title 'Plotting the data';
proc gplot data=turmeric;
plot ODISHA*obs;
plot ANDHRAPRADESH*obs;
plot KARNATAK*obs;
plot MAHARASHTRA*obs;
plot TAMILNADU*obs;
plot TELENGANA*obs;
run;
/*Identification of Arima*/
title 'Identification of Arima';
proc arima data=turmeric;
identify var=ODISHA stationarity=(adf);
identify var=ANDHRAPRADESH stationarity=(adf);
identify var=KARNATAK stationarity=(adf);
identify var=MAHARASHTRA stationarity=(adf);
identify var=TAMILNADU stationarity=(adf);
identify var=TELANGANA stationarity=(adf);
run;

/*Dickey-Fuller test*/
proc reg data=turmeric;
model obs = ODISHA ANDHRAPRADESH KARNATAK MAHARASHTRA TAMILNADU TELENGANA;
run; 
/*Estimating without seasonality*/
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=(6) q=(6) ;
OUTLIER;
title "Estimating without sesonality";
run;
/*Estimating with sesonality*/
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=(1,12) q=(1,12) ;
title "Estimating with sesonality";
run;

/*ARIMA(1,0,0) or AR(1)*/
title 'ARIMA(1,0,0)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1 method=ml; 
run;

/*ARIMA(2,0,0) or AR(2)*/
title 'ARIMA(2,0,0)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=2;
run;

/*ARIMA(0,0,1) or MA(1)*/
title 'ARIMA(0,0,1)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=2;
estimate q=1;
run;

/*ARIMA(1,0,1) or ARIMA(1,1)*/
title 'ARIMA(1,0,1)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1 q=1;
run;

/*ARIMA(1,1,0)*/
title 'ARIMA(1,1,0)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1;
run;

/*ARIMA(0,1,1)*/
title 'ARIMA(0,1,1)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate q=1;
run;

/*ARIMA(1,1,1)*/
title 'ARIMA(1,1,1)';
proc arima data=turmeric;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=KARNATAK;
identify var=MAHARASHTRA;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1 q=1;
run;

/*Forecasting arima for ODISHA*/
proc arima data=turmeric;
identify var=ODISHA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Odisha";
run;

/*Forecasting arima for ANDHRAPRADESH*/
proc arima data=turmeric;
identify var=ANDHRAPRADESH;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Andhra pradesh";
run;
/*Forecasting arima for KARNATAK*/
proc arima data=turmeric;
identify var=KARNATAK;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Karnataka";
run;
/*Forecasting arima for MAHARASHTRA*/
proc arima data=turmeric;
identify var=MAHARASHTRA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Maharashtra";
run;
/*Forecasting arima for TAMILNADU*/
proc arima data=turmeric;
identify var=TAMILNADU;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Tamilnadu";
run;

/*Forecasting arima for TELENGANA*/
proc arima data=turmeric;
identify var=TELENGANA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Telengana";
run;



 
