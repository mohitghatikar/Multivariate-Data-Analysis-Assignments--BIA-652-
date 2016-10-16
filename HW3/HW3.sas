*------------------------------------------------------------------------;
* Project        : BIA652  Mulivariate Analysis                          ;
* Developer(s)   : Mohit Ravi Ghatikar, CWID - 10405877                  ;
* Comments       : Solution to Homework 3                                ;
*------------------------------------------------------------------------;

* Question 7.2;
*/ Fit the regression plane for the fathers using FFVC as the dependent variable
and age and height as the independent variables. */

* Establish a library name;
filename lung_txt "C:\Users\mohit\Documents\My SAS Files\9.4\Raw_data\Lung.txt" ; 


* Input the dataset to lung_data;
data lung_data;
 infile lung_txt  delimiter = ' '  missover;
 
input  ID                   $     
       AREA                 $ 
       Gender_father        $
       Age_father
       Height_father
       Weight_father
       FVC_father
       FEV1_father
       Gender_mother         $
       Age_mother
       Height_mother
       Weight_mother
       FVC_mother
       FEV1_mother
       Sex_oldest_child       $     
       Age_oldest_child
       Height_oldest_child
       Weight_oldest_child
       FVC_oldest_child
       FEV1_oldest_child
       Sex_middle_child       $
       Age_middle_child
       Height_middle_child
       Weight_middle_child
       FVC_middle_child
       FEV1_middle_child
       Sex_youngest_child    $ 
       Age_youngest_child     
       Height_youngest_child
       Weight_youngest_child
       FVC_youngest_child
       FEV1_youngest_child
 ;
 run;

ods pdf file ="output_7.2.pdf";

* Calculate the co-relation matrix for all the variables;
Title "Co-relation Matrix for Age_father Height_father FVC_father ";
proc corr data=lung_data pearson 
          plots=matrix(histogram);
   var Age_father Height_father FVC_father;
run;

* Regression Analysis of FVC_father on Age_father and Height_father;
 Title "Regression Analysis with FVC_father as dependent variable and Age_father, Height_father as independent variables ";
   ods graphics on;
   proc reg data=lung_data outest=lung_est;
model FVC_father = Age_father Height_father / dwprob VIF;
run;
quit;
ods graphics off;
ods pdf close;

* Question 7.5;
*/ From the depression data set described in Table 3.4, predict the reported
level of depression as given by CESD, using INCOME, SEX, and AGE as
independent variables. Analyze the residuals and decide whether or not it is
reasonable to assume that they follow a normal distribution;

 * Establish a library name;
filename sasdata "C:\Users\mohit\Documents\My SAS Files\9.4\Raw_data\Depress.txt" ; 

ods pdf file ="output_7.5.pdf";

* Input the variables age and income to depress_data;
data depress_data;
 infile sasdata  delimiter = ' '  missover;
  input  ID $ Sex $ age Marital Education $ Employment_status $ income Religion $ C1_C20 $ CESD ;
  drop Marital Education Employment_status C1_C20 Religion;
 run;

 * Creating a dummy variable called Male_or_female which contains the value of:
  1 - Male
  0 - Female ;

 data depress_data2;
 set depress_data;
 if sex=1 then Male_or_female=1;
 else Male_or_female=0;
 drop sex;
 run;

* Sort the New dataset according to the Male_or_Female variable;
proc sort data=depress_data2;
 by Male_or_female;
 run;

 * Calculate the co-relation matrix for all the variables;
Title "Co-relation Matrix for Sex age Income and CESD ";
proc corr data=depress_data2 pearson
          plots=matrix(histogram);
		  by male_or_female;
	var  Age Income CESD;
    
run;

* Regression Analysis of CESD on Age,income and sex;
 Title "Regression Analysis with CESC as dependent variable and Age,income and Sex as independent variables ";
 ods graphics on;
 proc reg data=depress_data2 ;
 model cesd = age  income Male_or_Female / dwprob VIF;
* Store the residuals in a separate dataset called Error_data;
output out= Error_data( keep cesd age income Male_or_female R_depress P_depress) Residual=R_depress Predicted=P_Depress;
run;
ods graphics off;
quit;

* Test For Normality;
proc kde data=error_data out=density;
var r_depress;
run;

proc sort data=density;
by r_depress;
run;

* Normal Plot ;
Title " Normal plot for Residuals";
proc gplot data=density;
plot density*r_depress=1;
run;
quit;

ods pdf close;


* Question 8.11;
*/ Using the methods described in this chapter and the family lung function
data described in Appendix A, and choosing from among the variables
OCAGE, OCWEIGHT, MHEIGHT, MWEIGHT, FHEIGHT, and
FWEIGHT, select the variables that best predict height in the oldest child.
Show your analysis.;

ods pdf file ="output_8.11.pdf";

* Selecting the variable that most predicts the height of the oldest child
We use Stepwise selection to find out the best variable;
title " Stepwise Selection";
proc reg data=lung_data outest=est_lung;
model Height_oldest_child = Age_oldest_child Weight_oldest_child Height_mother Weight_mother Height_father Weight_father/ dwprob selection=stepwise;
run;
quit;

* Regression Analysis of Height_oldest_child vs Age_oldest_child;
title " Regression Analysis of age of oldest child";
proc reg data=lung_data ;
ods graphics on;
model Height_oldest_child =  Age_oldest_child;
run;
ods graphics off;
quit;

ods pdf close;

* Question 8.15;
* From among the candidate variables given in Problem 8.11, find the subset
of three variables that best predicts height in the oldest child, separately for
boys and girls. Are the two sets the same? Find the best subset of three
variables for the group as a whole. Does adding OCSEX into the regression
equation improve the fit? ;

* Selecting the variable that most predicts the height of the oldest child by gender.
We use Stepwise selection to find out the best variable and select a subset of
three best variables;
* Sort the data by sex of the oldest child;

ods pdf file ="output_8.15.pdf";
proc sort data=lung_data;
by Sex_oldest_child;
run;

* Forward Selection;
title " forward ";
proc reg data=lung_data ;
by Sex_oldest_child;
model Height_oldest_child = Age_oldest_child Weight_oldest_child Height_mother Weight_mother Height_father Weight_father/  selection=forward;
run;
quit;

* We selected the three variables Age_oldest_child Weight_oldest_child Height_father to be the best predictors;
title " Multiple linear Regression for predicting Height_oldest_child by taking Age_oldest_child Weight_oldest_child Height_father ";
proc reg data=lung_data;
by Sex_oldest_child;
model Height_oldest_child = Age_oldest_child Weight_oldest_child Height_father / dwprob vif ;
run;
quit;

 * Creating a dummy variable called Male_or_female which contains the value of:
  1 - Male
  0 - Female ;

 data lung_data2;
 set lung_data;
 if Sex_oldest_child=1 then Male_or_female=1;
 else Male_or_female=0;
 drop Sex_oldest_child;
 run;

* We selected the three variables Age_oldest_child Weight_oldest_child Height_father to be the best predictors;
title " Adding Sex of oldest child ";
proc reg data=lung_data2;
model Height_oldest_child = Male_or_female Age_oldest_child Weight_oldest_child Height_father / dwprob vif ;
run;
quit;

ods pdf close;






