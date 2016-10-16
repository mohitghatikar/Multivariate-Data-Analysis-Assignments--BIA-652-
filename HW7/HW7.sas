*-------------------------------------------------------------------------;
* Project        :  BIA652  Mulivariate Analysis                          ;
* Developer(s)   :  Mohit Ravi Ghatikar                                    ;
* Comments       :  HW7                                                 ;

*-------------------------------------------------------------------------;

* Qn 16.4;
*/ For the accompanying small, hypothetical data set, plot the data by using
methods given in this chapter, and perform both hierarchical and K-means
clustering with K = 2.
Cases X1 X2
1 11 10
2 8 10
3 9 11
4 5 4
5 3 4
6 8 5
7 11 11
8 10 12 ;

* Creating a dataset with the points mentioned;
data points;
*length point $8;
*infile datalines;
input ID $ 1-2 x1 x2;

datalines;
 1 11 10
 2 8 10
 3 9 11
 4 5 4
 5 3 4
 6 8 5
 7 11 11
 8 10 12
;
run;

ods pdf file="C:\Users\mohit\Desktop\BIA COURSES\MULTIVARIATE DATA ANALYTICS\HW7\Qn16.4.pdf";

* --- Hierarchical clustering procedure ---- ;

* Scatter plot of the points;
Title "Scatter plot of the points";
proc sgplot data = points;
scatter x=x1 y=x2 / id;
run;

* Hierarchical clustering;
proc cluster data = points outtree=Mytree_points method=ward ;
var x1 x2;
id ID;
run;
 
* Cluster procedure for Hierarchical clustering;
proc tree data = mytree_points out=points_cluster nclusters=2 ;
id ID;
copy x1 x2;
run;

proc sort; by cluster;

* Clusters solution;
proc print; by cluster;
var id x1 x2;
title2 'cluster solution';
run;

* Scatter plot of the clusters;
Title" Scatter plot of the clusters";
proc sgplot data = points_cluster;
scatter x=x1 y=x2 / group=CLUSTER ;
run;

* --- K-means clustering procedure ---- ;

* Standerdize the data before running k-means;
proc stdize data=points out=Stand_points method=std;
   var x1 x2;
run;

*k-means clustering with k=2;
proc fastclus data=stand_points out=k_means maxiter=100 maxclusters=2 ;
id ID;
var x1 x2;
run;

* Scatter plot of the clusters;
Title" Scatter plot of the clusters";
proc sgplot data=k_means;
   scatter y=x2 x=x1 / group=Cluster;
run;

ods pdf close;

* Qn 16.9;
* Create a data set from the family lung function data described in Appendix
A as follows. It will have three times the number of observations that the
original data set has — the first third of the observations will be the mothers’
measurements, the second third those of the fathers, and the final third
those of the oldest children. Perform a cluster analysis, first producing three
groups and then two groups, using the variables AGE, HEIGHT,WEIGHT,
FEV1, and FVC. Do the mothers, fathers, and oldest children cluster on the
basis of any of these variables? ;

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

 * Creating a new dataset;
 * Data Preparation;

 data new_lung_father;
 set lung_data;
 category=1;
 keep category Gender_father  Age_father Height_father Weight_father FVC_father FEV1_father;
 rename Gender_father = gender Age_father = age Height_father = height Weight_father = weight FVC_father = FVC FEV1_father=FEV1 ;
 run;

 data new_lung_mother;
 set lung_data;
 category=2;
 keep category Gender_mother  Age_mother Height_mother Weight_mother FVC_mother FEV1_mother;
 rename Gender_mother = gender Age_mother = age Height_mother = height Weight_mother = weight FVC_mother = FVC FEV1_mother=FEV1 ;
 run;


 data new_lung_oldest_child;
 set lung_data;
 category=3;
 keep category sex_oldest_child  Age_oldest_child Height_oldest_child Weight_oldest_child FVC_oldest_child FEV1_oldest_child;
 rename sex_oldest_child = gender Age_oldest_child = age Height_oldest_child = height Weight_oldest_child = weight FVC_oldest_child = FVC FEV1_oldest_child=FEV1 ;
 run;

 * New dataset created which has thrice the observaions;
 data lung_new;
 merge new_lung_father new_lung_mother new_lung_oldest_child;
 by category;
 run;

* Standardize the data;
proc stdize data=lung_new out=Stand_lung method=std;
var age height weight fvc fev1;
run;

* ---- k-means with k=3 ------- ;

ods pdf file="Qn16.9.pdf"

* K-means clustering with k=3;
Title " K-means clustering wih k=3";
proc fastclus data=Stand_lung out=lung_cluster maxiter=100 maxclusters=3 ;
id category;
var age height weight fvc fev1;
run;


*proc candisc data=lung_cluster out=Can noprint;
  * class Cluster;
  * var age height weight fvc fev1;
*run;

* Scatter plots of variables grouped by cluster ;
Title " Scatter plots of age grouped by cluster ";
proc sgplot data=lung_cluster;
scatter x= age y=category / group=cluster;
run;

Title " Scatter plots of height grouped by cluster ";
proc sgplot data=lung_cluster;
scatter x= height y=category / group=cluster;
run;

Title " Scatter plots of weight grouped by cluster ";
proc sgplot data=lung_cluster;
scatter x= weight y=category / group=cluster;
run;

Title " Scatter plots of fvc grouped by cluster ";
proc sgplot data=lung_cluster;
scatter x= fvc y=category / group=cluster;
run;

Title " Scatter plots of fev1 grouped by cluster ";
proc sgplot data=lung_cluster;
scatter x= fev1 y=category / group=cluster;
run;



* k-means clustering with k=2;


* K-means clustering with k=2;
Title " K-means clustering with k=2";
proc fastclus data=Stand_lung out=lung_cluster_2 maxiter=100 maxclusters=2 ;
id category;
var age height weight fvc fev1;
run;


* Scatter plots of variables grouped by cluster ;
Title " Scatter plots of age grouped by cluster ";
proc sgplot data=lung_cluster_2;
scatter x= age y=category / group=cluster;
run;

Title " Scatter plots of height grouped by cluster ";
proc sgplot data=lung_cluster_2;
scatter x= height y=category / group=cluster;
run;

Title " Scatter plots of weight grouped by cluster ";
proc sgplot data=lung_cluster_2;
scatter x= weight y=category / group=cluster;
run;

Title " Scatter plots of fvc grouped by cluster ";
proc sgplot data=lung_cluster_2;
scatter x= fvc y=category / group=cluster;
run;

Title " Scatter plots of fev1 grouped by cluster ";
proc sgplot data=lung_cluster_2;
scatter x= fev1 y=category / group=cluster;
run;
