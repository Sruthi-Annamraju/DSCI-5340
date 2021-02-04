/*Call the Raw Data Set*/

proc import datafile="C:\Users\sa1082\Green gram.xlsx" out=greengram
	dbms=xlsx replace;
run;
title 'correlation procedure of the variables';
proc corr data=greengram;
 var obs ODISHA GUJRAT KARNATAKA KERALA MAHARASHTRA MP RAJASTHAN TAMILNADU TELENGANA UP;
 run;
title 'Means for the states related to turmeric';
proc means data=greengram;
var obs ODISHA GUJRAT KARNATAKA KERALA MAHARASHTRA MP RAJASTHAN TAMILNADU TELENGANA UP;
run;
/*Plotting the data*/
title 'Plotting the data';
proc gplot data=greengram;
plot ODISHA*obs;
plot GUJRAT*obs;
plot KARNATAKA*obs;
plot KERALA*obs;
plot MAHARASTHRA*obs;
plot MP*obs;
plot RAJASTHAN*obs;
plot TAMILNADU*obs;
plot TELENGANA*obs;
plot UP*obs;

run;
/*Identification of Arima*/
title 'Identification of Arima';
proc arima data=greengram;
identify var=ODISHA stationarity=(adf);
identify var=GUJRAT stationarity=(adf);
identify var=KARNATAKA stationarity=(adf);
identify var=KERALA stationarity=(adf);
identify var=MAHARASTHRA stationarity=(adf);
identify var=MP stationarity=(adf);
identify var=RAJASTHAN stationarity=(adf);
identify var=TAMILNADU stationarity=(adf);
identify var=TELENGANA stationarity=(adf);
identify var=UP stationarity=(adf);
run;

/*Dickey-Fuller test*/
proc reg data=greengram;
model obs = ODISHA GUJRAT KARNATAKA KERALA MAHARASHTRA MP RAJASTHAN TAMILNADU TELENGANA UP;
run; 
/*Estimating without seasonality*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=(6) q=(6) ;
OUTLIER;
title "Estimating without sesonality";
run;
/*Estimating with sesonality*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=(1,12) q=(1,12) ;
title "Estimating with sesonality";
run;

/*ARIMA(1,0,0) or AR(1)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=1 method=ml; 
run;

/*ARIMA(2,0,0) or AR(2)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=2;
run;

/*ARIMA(0,0,1) or MA(1)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=2;
estimate q=1;
run;

/*ARIMA(1,0,1) or ARIMA(1,1)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=1 q=1;
run;

/*ARIMA(1,1,0)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=1;
run;

/*ARIMA(0,1,1)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate q=1;
run;

/*ARIMA(1,1,1)*/
proc arima data=greengram;
identify var=ODISHA;
identify var=GUJRAT;
identify var=KARNATAKA;
identify var=KERALA;
identify var=MAHARASHTRA;
identify var=MP;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
identify var=UP;
estimate p=1 q=1;
run;

/*Forecasting arima for ODISHA*/
proc arima data=greengram;
identify var=ODISHA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Odisha";
run;
/*Forecasting arima for GUJRAT*/
proc arima data=greengram;
identify var=GUJRAT;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Gujrat";
run;
/*Forecasting arima for KARNATAKA*/
proc arima data=greengram;
identify var=KARNATAKA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Karnataka";
run;
/*Forecasting arima for KERALA*/
proc arima data=greengram;
identify var=KERALA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Kerala";
run;
/*Forecasting arima for MAHARASHTRA*/
proc arima data=greengram;
identify var=MAHARASHTRA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Maharashtra";
run;
/*Forecasting arima for MP*/
proc arima data=greengram;
identify var=MP;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for MP";
run;
/*Forecasting arima for RAJASTHAN*/
proc arima data=greengram;
identify var=RAJASTHAN;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Rajasthan";
run;

/*Forecasting arima for TAMILNADU*/
proc arima data=greengram;
identify var=TAMILNADU;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Tamilnadu";
run;

/*Forecasting arima for TELENGANA*/
proc arima data=greengram;
identify var=TELENGANA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Telengana";
run;
/*Forecasting arima for UP*/
proc arima data=greengram;
identify var=UP;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for UP";
run;



 
