
/*************************************************************************
**          
**  Developed by:  
**  Assignment  : BIA 652 - Homework 5 
**  Developed by: Mohit ravi Ghatikar, CWID - 10405877  
**            
**************************************************************************/

/*  5.1 Using Churn dataset, create a categorical variable CustServ as:

       CustServ_Calls < 2 then V_CSC=0;
       else if CustServ_Calls < 4 then V_CSC=1;
       else V_CSC=2

Perform logistic regression analysis for churn on V_csc */

** establish the course library  with read only access ;
libname sasdata "C:\Users\mohit\Documents\My SAS Files\9.4\SAS_data" access=read;

** copy the datsets to the work library **;

proc copy in=sasdata out=work;
select churn;
run;

* Create a new dataset churn_2 with the if condiditons given;
data churn_2;
set churn;

 if churn="False." then V_churn=0;
    else V_churn=1;
    if Voice_Mail_Plan='yes' then V_voiceplan=0;
    else V_voiceplan=1;

  if service_Calls < 2 then V_CSC=0;
     else if service_Calls < 4 then V_CSC=1;
     else V_CSC=2;

  if  international_plan='no' then int_plan_ind=0;
    else  int_plan_ind=1;  

  if service_Calls < 4 then V_CSC2=0;
    else   V_CSC2=1;

  account2=input(account,8.);
  *acc_length=length(account); 
  run;

ods pdf file="logistic_5.1.pdf";

Title " Frequency of churn vs V_CSC";
 Proc freq data=churn_2; 
  tables V_churn * V_CSC;
run;

* Run Logistic regression for churn on V_CSC;
Title" Logistic regression for churn on V_CSC ";
proc logistic data=churn_2  descending;
  class  V_CSC(ref='0')/ param=ref ;
  model  V_churn = V_CSC ;
quit;

ods pdf close;

/* 5.2 Divide the Churn dataset into two separate datasets (Churn1 and Churn2) by selecting the odd records (1,3,5…etc.) 
for Churn1 and the even records (2,4,6…etc.) for Churn2.

Perform logistic regression analysis for both Churn datasets on ‘day minutes’ and compare the results */

ods pdf file="logistic_5.2.pdf";

* Create a new dataset called churn_even_2 that stores all even observations;
data churn_even_2;
set churn_2;
if mod(_N_,2)=0;
run;


* Run Logistic regression for even dataset: churn on day_minutes;
Title" Logistic regression for even dataset: churn on day_minutes";
proc logistic data=churn_even_2  descending;
    model  V_churn = day_minutes ;
quit;

* Create a new dataset called churn_odd_1 that stores all odd observations;
data churn_odd_1;
set churn_2;
if mod(_N_,2)=1;
run;

* Run Logistic regression for odd dataset: churn on day_minutes;
Title" Logistic regression for odd dataset: churn on day_minutes";
proc logistic data=churn_odd_1  descending;
    model  V_churn = day_minutes ;
quit;

ods pdf close;

/*5.3 Perform logistic regression analysis for Churn on :

International Plan indicator
Voice Plan indicator
V_CSC2
Account Length
Day Minutes
Evening Minutes
Night Minutes
International Minutes */

ods pdf file="logistic_5.3.pdf";

Title " Frequency of churn on International Plan indicator";
Proc freq data=churn_2; 
  tables V_churn * int_plan_ind;
run;

* Run Logistic regression for churn on International Plan indicator;
Title" Logistic regression for churn on International Plan indicator";
proc logistic data=churn_2  descending;
  class  int_plan_ind(ref='0')/ param=ref ;
  model  V_churn = int_plan_ind ;
quit;

Title " Frequency of churn on Voice Plan indicator";
Proc freq data=churn_2; 
  tables V_churn * V_voiceplan;
run;

* Run Logistic regression for churn on Voice Plan indicator;
Title" Logistic regression for churn on Voice Plan indicator";
proc logistic data=churn_2  descending;
  class  V_voiceplan(ref='0')/ param=ref ;
  model  V_churn = V_voiceplan ;
quit;

Title " Frequency of churn on V_CSC2";
Proc freq data=churn_2; 
  tables V_churn * V_CSC2;
run;

* Run Logistic regression for churn on V_CSC2;
Title" Logistic regression for churn on V_CSC2";
proc logistic data=churn_2  descending;
  class  V_CSC2(ref='0')/ param=ref ;
  model  V_churn = V_CSC2 ;
quit;

* Run Logistic regression for churn on account length;
Title" Logistic regression for churn on account length";
proc logistic data=churn_2  descending;
    model  V_churn = acc_length ;
quit;

* Run Logistic regression for churn on day minutes;
Title" Logistic regression for churn on day minutes";
proc logistic data=churn_2  descending;
    model  V_churn = day_minutes ;
quit;

* Run Logistic regression for churn on evening minutes;
Title" Logistic regression for churn on evening minutes";
proc logistic data=churn_2  descending;
    model  V_churn = eve_minutes ;
quit;

* Run Logistic regression for churn on night minutes;
Title" Logistic regression for churn on night minutes";
proc logistic data=churn_2  descending;
   model  V_churn = night_minutes ;
quit;

* Run Logistic regression for churn on international minutes;
Title" Logistic regression for churn on international minutes";
proc logistic data=churn_2  descending;
    model  V_churn = intl_minutes ;
quit;

ods pdf close;

**** classwork ***;

