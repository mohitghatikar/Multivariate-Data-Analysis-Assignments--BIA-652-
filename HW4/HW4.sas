*------------------------------------------------------------------------;
* Project        : BIA652  Mulivariate Analysis                          ;
* Developer(s)   : Mohit Ravi Ghatikar, CWID - 10405877                  ;
* Comments       : Solution to Homework 4                                ;
*------------------------------------------------------------------------;

* Question 7.2;
*/ Using the Iris dataset in the Sashelp library, develop a regression model for predicting 
 the “Sepal Length in mm” (SepalLength)  using the other variables in the dataset ;

* Create a new dataset iris_data and create dummy variables for species;
data iris_data;
set sashelp.iris;
if Species='Setosa' then iris_spec1=1;
else iris_spec1=0;
if Species='Versicolor' then iris_spec2=1;
else iris_spec2=0;
if Species='Virginica' then iris_spec3=1;
else iris_spec3=0;

* Interaction variables;
iris_mul1 = iris_spec1 * sepalwidth;
iris_mul2 = iris_spec1 * Petallength;
iris_mul3 = iris_spec2 * sepalwidth;
iris_mul4 = iris_spec2 * Petallength;
run;


ods pdf file ="HW4.pdf";

* Run a Regression model on all 5 variables;
Title " Regression on all variables";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength PetalWidth iris_spec1 iris_spec2 / vif ;
quit;
run;

* Remove Petalwidth due to high VIF;
Title" Regression after Petalwidth removed";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength iris_spec1 iris_spec2 / vif ;
quit;
run;

*Remove Iris_spec1 due to high VIF;
Title" Regression after Iris_spec1 removed";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength iris_spec2 / vif ;
quit;
run;

* Remove Iris_spec2 due to insignificant p value;
* The significant variables are sepallength and petallength;
Title" Regression after Iris_spec2 removed";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength / vif ;
quit;
run;



*Does “Iris Species” (Species) play a significant factor in predicting Sepal Length? ;

* Run a Regression with a variation variable of Iris_spec1*Sepalwidth;
Title" Regression with Interaction variable of Iris_spec1*Sepalwidth";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength iris_mul1 iris_spec1  / vif ;
quit;
run;

* Run a Regression with a variation variable of Iris_spec1*Petallength;
Title" Regression with Interaction variable of Iris_spec1*Petallength";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength iris_mul2 iris_spec1  / vif ;
quit;
run;

* Run a Regression with a variation variable of Iris_spec2*Sepalwidth;
Title" Regression with Interaction variable of Iris_spec2*Sepalwidth";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength iris_mul3 iris_spec2  / vif ;
quit;
run;

* Run a Regression with a variation variable of Iris_spec2*Petallength;
Title" Regression with Interaction variable of Iris_spec2*Petallength";
proc reg data=iris_data;
model SepalLength = SepalWidth PetalLength iris_mul4 iris_spec2  / vif ;
quit;
run;

ods pdf close;




* Classwork;


data iris_data;
set sashelp.iris;
run;
 title " principle component analysis";
 title" univairate analysis";
 proc univaraite data=iris_data;
 var petalwidth petallength;
 run;

 proc sglpot data=iris_data;
