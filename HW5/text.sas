PROC IMPORT OUT= WORK.text 
            DATAFILE= "C:\Users\mohit\Desktop\652 project\data.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
