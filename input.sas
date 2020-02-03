%let abc = %incudesectparm(abd, default=%stgg(gdaga));
proc sql noprint;
select *, 1*2 as bb from sth, abc b
where a.b = c.d
;quit;


data x;
set lala.abc;
run;

proc sql;
select *
from abc.x, bda.y, zgod.z
;quit;

data &intable;
set %dbmssel(table) &abacas..bdabd(where = (abc = 2 ) rename = (ABC = DEF) in=abc);
run;

%macro dbmssel(tab1);
    data &tab1;
    set &tab1;
    run; 
    
%mend dbmssel; 