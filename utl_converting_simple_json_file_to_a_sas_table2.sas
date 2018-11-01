Converting_simple_json_file_to_a_sas_table2                                                                     
                                                                                                                
You need SAS/IML/R for this                                                                                     
                                                                                                                
see github                                                                                                      
https://tinyurl.com/ybz5jltk                                                                                    
https://github.com/rogerjdeangelis/utl_converting_simple_json_file_to_a_sas_table2                              
                                                                                                                
https://communities.sas.com/t5/New-SAS-User/proc-JSON-export/m-p/509420                                         
                                                                                                                
You do need to post process a little see example output.                                                        
                                                                                                                
Because R lists are so general this seems to work for most json files(even complex ones).                       
Note there are many other json methods on my github.                                                            
However other methods seem to be more specific in the types of jason files .                                    
                                                                                                                
see for other json examples                                                                                     
https://tinyurl.com/yck67hm7                                                                                    
https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=json+in%3Aname&type=&language=             
                                                                                                                
for macros                                                                                                      
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                      
                                                                                                                
                                                                                                                
                                                                                                                
INPUT                                                                                                           
=====                                                                                                           
                                                                                                                
filename ft15f001 "d:/json/utl_converting_simple_json_file_to_a_sas_table2.json";                               
parmcards4;                                                                                                     
{                                                                                                               
"ID":"1",                                                                                                       
"Status":"2",                                                                                                   
"Rechtsform_ID":"3",                                                                                            
  "Mitarbeiter": [                                                                                              
    {                                                                                                           
      "WERT": "0",                                                                                              
      "QS": "X.99.9"                                                                                            
    },                                                                                                          
    {                                                                                                           
      "WERT": "1",                                                                                              
      "QS": "X.99.9"                                                                                            
    }                                                                                                           
  ],                                                                                                            
  "EFE": [                                                                                                      
    {                                                                                                           
      "FUNKTIONSART": "2",                                                                                      
      "PROXY": "0",                                                                                             
      "PERSKEYS": "AAA1BB2CCC",                                                                                 
      "GEBDAT": "1970-08-12",                                                                                   
      "EINTRITT": "2011-08-12"                                                                                  
    },                                                                                                          
    {                                                                                                           
      "FUNKTIONSART": "2",                                                                                      
      "PROXY": "0",                                                                                             
      "PERSKEYS": "xxxxxx",                                                                                     
      "GEBDAT": "1970-08-12",                                                                                   
      "EINTRITT": "2011-08-12"                                                                                  
    }                                                                                                           
  ]                                                                                                             
}                                                                                                               
;;;;                                                                                                            
run;quit;                                                                                                       
                                                                                                                
                                                                                                                
EXAMPLE OUTPUT                                                                                                  
==============                                                                                                  
                                                                                                                
 WORK.WANT total obs=17                                                                                         
                                                                                                                
   V1                    V2                                                                                     
                                                                                                                
   ID                    1                                                                                      
   Status                2                                                                                      
   Rechtsform_ID         3                                                                                      
                                                                                                                
   Mitarbeiter.WERT      0                                                                                      
   Mitarbeiter.QS        X.99.9                                                                                 
   Mitarbeiter.WERT.1    1                                                                                      
   Mitarbeiter.QS.1      X.99.9                                                                                 
                                                                                                                
   EFE.FUNKTIONSART      2                                                                                      
   EFE.PROXY             0                                                                                      
   EFE.PERSKEYS          AAA1BB2CCC                                                                             
   EFE.GEBDAT            1970-08-12                                                                             
   EFE.EINTRITT          2011-08-12                                                                             
                                                                                                                
   EFE.FUNKTIONSART.1    2                                                                                      
   EFE.PROXY.1           0                                                                                      
   EFE.PERSKEYS.1        xxxxxx                                                                                 
   EFE.GEBDAT.1          1970-08-12                                                                             
   EFE.EINTRITT.1        2011-08-12                                                                             
                                                                                                                
                                                                                                                
PROCESS                                                                                                         
=======                                                                                                         
                                                                                                                
%utl_submit_r64('                                                                                               
  library("rjson");                                                                                             
  library(SASxport);                                                                                            
  jsn <- as.data.frame(fromJSON(paste(readLines("d:/json/utl_converting_simple_json_file_to_a_sas_table2.json") 
  ,collapse="")));                                                                                              
  want<-as.data.frame(cbind(names(jsn),t(jsn)));                                                                
  want[] <- lapply(want, as.character);                                                                         
  str(want);                                                                                                    
  write.xport(want,file="d:/xpt/jsnxpo.xpt");                                                                   
');                                                                                                             
                                                                                                                
libname xpt xport "d:/xpt/jsnxpo.xpt";                                                                          
                                                                                                                
proc contents data=xpt._all_;                                                                                   
run;quit;                                                                                                       
                                                                                                                
data want;                                                                                                      
  set xpt.want;                                                                                                 
run;quit;                                                                                                       
                                                                                                                
proc print data=want;                                                                                           
run;quit;                                                                                                       
                                                                                                                
* R log;                                                                                                        
                                                                                                                
>                                                                                                               
'data.frame':	17 obs. of  2 variables:                                                                          
 $ V1: chr  "ID" "Status" "Rechtsform_ID" "Mitarbeiter.WERT" ...                                                
 $ V2: chr  "1" "2" "3" "0" ...                                                                                 
>                                                                                                               
                                                                                                                
EXACT OUTPUT                                                                                                    
============                                                                                                    
                                                                                                                
 WORK.WANT total obs=17                                                                                         
                                                                                                                
   V1                    V2                                                                                     
                                                                                                                
   ID                    1                                                                                      
   Status                2                                                                                      
   Rechtsform_ID         3                                                                                      
   Mitarbeiter.WERT      0                                                                                      
   Mitarbeiter.QS        X.99.9                                                                                 
   Mitarbeiter.WERT.1    1                                                                                      
   Mitarbeiter.QS.1      X.99.9                                                                                 
   EFE.FUNKTIONSART      2                                                                                      
   EFE.PROXY             0                                                                                      
   EFE.PERSKEYS          AAA1BB2CCC                                                                             
   EFE.GEBDAT            1970-08-12                                                                             
   EFE.EINTRITT          2011-08-12                                                                             
   EFE.FUNKTIONSART.1    2                                                                                      
   EFE.PROXY.1           0                                                                                      
   EFE.PERSKEYS.1        xxxxxx                                                                                 
   EFE.GEBDAT.1          1970-08-12                                                                             
   EFE.EINTRITT.1        2011-08-12                                                                             
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                                
