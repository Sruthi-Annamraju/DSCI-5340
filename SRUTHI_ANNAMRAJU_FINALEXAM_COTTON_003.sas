/*Call the Raw Data Set*/

proc import datafile="C:\Users\sa1082\Cotton.xlsx" out=cotton
	dbms=xlsx replace;
run;
title 'correlation procedure of the variables';
proc corr data=cotton;
 var obs ODISHA ANDHRAPRADESH GUJRAT HARYANA KARNATAKA LAGODISHA MADHYAPRADESH MAHARASHTRA PUNJAB RAJASTHAN TAMILNADU TELENGANA;
 run;
title 'Means for the states related to turmeric';
proc means data=cotton;
var obs ODISHA ANDHRAPRADESH GUJRAT HARYANA KARNATAKA LAGODISHA MADHYAPRADESH MAHARASHTRA PUNJAB RAJASTHAN TAMILNADU TELENGANA;
run;
/*Plotting the data*/
title 'Plotting the data';
proc gplot data=cotton;
plot ODISHA*obs;
plot ANDHRAPRADESH*obs;
plot GUJRAT*obs;
plot HARYANA*obs;
plot KARNATAKA*obs;
plot LAGODISHA*obs;
plot MADHYAPRADESH*obs;
plot PUNJAB*obs;
plot RAJASTHAN*obs;
plot TAMILNADU*obs;
plot TELENGANA*obs;
run;
/*Identification of Arima*/
title 'Identification of Arima';
proc arima data=cotton;
identify var=ODISHA stationarity=(adf);
identify var=ANDHRAPRADESH stationarity=(adf);
identify var=GUJRAT stationarity=(adf);
identify var=HARYANA stationarity=(adf);
identify var=KARNATAKA stationarity=(adf);
identify var=LAGODISHA stationarity=(adf);
identify var=MADHYAPRADESH stationarity=(adf);
identify var=PUNJAB stationarity=(adf);
identify var=RAJASTHAN stationarity=(adf);
identify var=TAMILNADU stationarity=(adf);
identify var=TELENGANA stationarity=(adf);
run;

/*Dickey-Fuller test*/
proc reg data=cotton;
model obs = ODISHA ANDHRAPRADESH GUJRAT HARYANA KARNATAKA LAGODISHA MADHYAPRADESH MAHARASHTRA PUNJAB RAJASTHAN TAMILNADU TELENGANA;
run; 
/*Estimating without seasonality*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=(6) q=(6) ;
OUTLIER;
title "Estimating without sesonality";
run;
/*Estimating with sesonality*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=(1,12) q=(1,12) ;
title "Estimating with sesonality";
run;

/*ARIMA(1,0,0) or AR(1)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1 method=ml; 
run;

/*ARIMA(2,0,0) or AR(2)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=2;
run;

/*ARIMA(0,0,1) or MA(1)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=2;
estimate q=1;
run;

/*ARIMA(1,0,1) or ARIMA(1,1)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1 q=1;
run;

/*ARIMA(1,1,0)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1;
run;

/*ARIMA(0,1,1)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate q=1;
run;

/*ARIMA(1,1,1)*/
proc arima data=cotton;
identify var=ODISHA;
identify var=ANDHRAPRADESH;
identify var=GUJRAT;
identify var=HARYANA;
identify var=KARNATAKA;
identify var=LAGODISHA;
identify var=MADHYAPRADESH;
identify var=PUNJAB;
identify var=RAJASTHAN;
identify var=TAMILNADU;
identify var=TELENGANA;
estimate p=1 q=1;
run;

/*Forecasting arima for ODISHA*/
proc arima data=cotton;
identify var=ODISHA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Odisha";
run;

/*Forecasting arima for ANDHRAPRADESH*/
proc arima data=cotton;
identify var=ANDHRAPRADESH;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Andhra pradesh";
run;
/*Forecasting arima for GUJRAT*/
proc arima data=cotton;
identify var=GUJRAT;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Gujrat";
run;
/*Forecasting arima for HARYANA*/
proc arima data=cotton;
identify var=HARYANA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Haryana";
run;
/*Forecasting arima for KARNATAKA*/
proc arima data=cotton;
identify var=KARNATAKA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Karnataka";
run;
/*Forecasting arima for LAGODISHA*/
proc arima data=cotton;
identify var=LAGODISHA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Lagodisha";
run;
/*Forecasting arima for MADHYAPRADESH*/
proc arima data=cotton;
identify var=MADHYAPRADESH;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for MadhyaPradesh";
run;
/*Forecasting arima for PUNJAB*/
proc arima data=cotton;
identify var=PUNJAB;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Punjab";
run;
/*Forecasting arima for RAJASTHAN*/
proc arima data=cotton;
identify var=RAJASTHAN;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Rajasthan";
run;

/*Forecasting arima for TAMILNADU*/
proc arima data=cotton;
identify var=TAMILNADU;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Tamilnadu";
run;

/*Forecasting arima for TELENGANA*/
proc arima data=cotton;
identify var=TELENGANA;
estimate p=(6) q=(6) plot;
forecast lead=12 PRINTALL;
title "Forecasts for Telengana";
run;



 
