*------------------------------------------------------------------------;
* Project        : BIA652  Mulivariate Analysis                          ;
* Developer(s)   : Mohit Ravi Ghatikar, CWID - 10405877                  ;
* Comments       : Solution to Homework 2                                ;
*------------------------------------------------------------------------;
*/ From the family lung function data set in Appendix A, perform a regression
analysis of weight on height for fathers. Repeat for mothers. Determine the
correlation coefficient and the regression equation for fathers and mothers.
Test that the coefficients are significantly different from zero for both sexes.
Also, find the standardized regression equation and report it. Would you
suggest removing the woman who weighs 267 pounds from the data set?
Discuss why the correlation for fathers appears higher than that for mothers.

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

ods pdf file ="output_6.2.pdf";
* Regression Analysis of weight on height for fathers;
 Title "Regression Analysis of weight on height for fathers";
   ods graphics on;
      proc reg;
      model Weight_father = Height_father / STB;
   run;
ods graphics off;


* Regression Analysis of weight on height for mothers;
Title "Regression Analysis of weight on height for mother";
   ods graphics on;
      proc reg;
      model Weight_mother = Height_mother / STB;
   run;
      ods graphics off;


* Calculate the co-relation coefficient for father;
Title "Co-relation Coefficient for father";
proc corr data=lung_data pearson 
          plots=matrix(histogram);
   var Weight_father Height_father;
run;


* Calculate the co-relation coefficeint for mother;
Title "Co-relation Coefficient for mother";
proc corr data=lung_data pearson 
          plots=matrix(histogram);
   var Weight_mother Height_mother;
run;

* Create a boxplot for weight of mother; 
Title" boxplot for weight of mother";
  proc sgplot data=lung_data;
  hbox weight_mother;
  run;

* Create a new dataset with a dataelement removed;
  data lung_data_delete;
  set lung_data;
  if weight_mother=267 then delete;
  run;

  * Runs a Regression model for the new dataset ;
  Title "Runs a Regression model for the new dataset with the deleted value";
  proc reg data=lung_data_delete;
  model Weight_mother = Height_mother ;
   run;

ods pdf close;

*/
From the depression data set described in Table 3.4 create a data set containing
only the variables AGE and INCOME.
(a) Find the regression of income on age.
(b) Successively add and then delete each of the following points:
AGE INCOME
42 120
80 150
180 15
and repeat the regression each time with the single extra point. How does the
regression equation change? Which of the new points are outliers? Which
are influential?
/*

 Establish a library name;
filename sasdata "C:\Users\mohit\Documents\My SAS Files\9.4\Raw_data\Depress.txt" ; 

* Input the variables age and income to depress_data;
data depress_data;
 infile sasdata  delimiter = ' '  missover;
  input  blank1 blank2 age blank3 blank4 blank5 income ;
  drop blank1 blank2 blank3 blank4 blank5;
 run;

 ods pdf file="output_6.9.pdf";

*Run Regression on depress dataset for income on age;
 ods graphics on;
 Title" Regression for income on age";
proc reg data=depress_data;
model income=age;

run;
ods graphics off;

* Create a new dataset with new datapoint for age and income;
data add_1;
infile datalines missover;
input age income;
datalines;
42 120
;
run;

* Copy the new dataset with additional datapoints to depress_data;
data depress_data_add_1;
set depress_data add_1;
run;

* Run the same procedure as before for creating and appending new datapoints;
data add_2;
infile datalines missover;
input age income;
datalines;
80 150
;
run;

data depress_data_add_2;
set depress_data add_2;
run;

data add_3;
infile datalines missover;
input age income;
datalines;
180 15
;
run;

data depress_data_add_3;
set depress_data add_3;
run;

* Regression analysis for additional datapoints;
title " Regression for additional data point 42 120";
ods graphics on;
proc reg data=depress_data_add_1;
model income=age;
run;
ods graphics off;

* Regression analysis for additional datapoints;
title " Regression for additional data point 80 150";
ods graphics on;
proc reg data=depress_data_add_2;
model income=age;
run;
ods graphics off;

* Regression analysis for additional datapoints;
title " Regression for additional data point 180 15";
ods graphics on;
proc reg data=depress_data_add_3;
model income=age;
run;
ods graphics off;

ods pdf close;
