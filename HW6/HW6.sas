*-------------------------------------------------------------------------;
* Project        :  BIA652  Mulivariate Analysis                          ;
* Developer(s)   :  Mohit Ravi Ghatikar                                    ;
* Comments       :  HW6                                                   ;

*-------------------------------------------------------------------------;

libname sasdata "C:\Users\mohit\Documents\My SAS Files\9.4\SAS_data" access=read;

* initalize the data ;
proc copy in=sasdata  out=work;
   select depression ;
run;

* Qn 14.1;
*/ For the depression data set described in Appendix A, perform a principal
components analysis on the last seven variables DRINK–CHRONILL (Table
3.3). Interpret the results. */;

ods pdf file="Qn14.1.pdf";

title "Principal Component Analysis"; 
title2 " Univariate Analysis"; 
proc univariate data= depression ;
   var  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
run;

title " "; 
title2 " "; 
Title3 " Co-relation matrix ";
proc corr data=depression;
  var  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
run;

** Normalize the data ***;
PROC STANDARD DATA=depression
             MEAN=0 STD=1 
             OUT=depression_z;
  VAR  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
RUN;

Title " Running PCA on the 7 variables ";
proc princomp   data=depression_z  out=depression_pca;
 VAR  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
run;

ods pdf close;

* Qn 14.6
*/ Using the family lung function data described in Appendix A define a new
variable RATIO = FEV1/FVC for the fathers. What is the correlation between
RATIO and FEV1? Between RATIO and FVC? Perform a principal
components analysis on FEV1 and FVC, plotting the results. Perform a principal
components analysis on FEV1, FVC, and RATIO. Discuss the results. */


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

 * Set Ratio = FEV1_father / FVC_father ;
 data lung;
 set lung_data;
 Ratio = FEV1_father / FVC_father;
 run;

 ods pdf file="Qn14.6.pdf";

Title " Co-relation matrix between FEV1 AND RATIO ";
proc corr data=lung;
  var  FEV1_father Ratio;
run;

Title " Co-relation matrix between FVC AND RATIO ";
proc corr data=lung;
  var  FVC_father Ratio;
run;

** Normalize the data ***;
PROC STANDARD DATA=lung
             MEAN=0 STD=1 
             OUT=lung_z;
  VAR FEV1_father FVC_father Ratio;
RUN;

Title " Running PCA on FVC_Father and FEV1_father ";
proc princomp   data=lung_z  out=lung_pca;
 VAR  FEV1_father FVC_Father;
run;

* Sanity Check;
Title " Running PCA on Prin1 and Prin2 ";
proc princomp   data=lung_pca  ;
 VAR  Prin1 Prin2;
run;

Title " Running PCA on Ratio , FVC_father and FEV1_father ";
proc princomp   data=lung_z  out=lung_pca_total;
 VAR  FEV1_father FVC_Father Ratio;
run;

ods pdf close;

* Qn 14.7
* Using the family lung function data, perform a principal components analysis
on age, height, and weight for the oldest child.;

ods pdf file="14.7.pdf";

Title " Co-relation matrix between age, height, and weight for the oldest child ";
proc corr data=lung;
  var Age_oldest_child Height_oldest_child Weight_oldest_child ;
run;

** Normalize the data ***;
PROC STANDARD DATA=lung
             MEAN=0 STD=1 
             OUT=lung_oldest_child;
  VAR Age_oldest_child Height_oldest_child Weight_oldest_child;
RUN;

Title " Running PCA on  age, height, and weight for the oldest child ";
proc princomp   data=lung_oldest_child out=lung_oldest_child_output  ;
 VAR  Age_oldest_child Height_oldest_child Weight_oldest_child;
run;

ods pdf close;
