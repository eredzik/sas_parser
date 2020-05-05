%let abc = %incudesectparm(abd, default=%stgg(gdaga.baga));
proc sql noprint;
select *, 1*2 as bb from sth, abc b
where a.b = c.d
;quit;
data x / view=x;
set lala.abc;
run;

proc sql;
create table tabledot as 
select abc.g, zgod.bds
from abc.x, bda.y, zgod.z bn
left join abc.sdff
on t1.adg = t2.bdgf
;quit;

data &intable;
set %macr(table1) &abacas..bdabd(where = (abc = 2 ) rename = (ABC = DEF) in=abc);
run;

%macro dbmssel(tab1);
    data &tab1;
    set &tab1;
    run; 
    
%mend dbmssel; 


%macro abc(ab=1);
proc sql;
update table &zccs
set x=1, b=2
where abd=6
;quit;

%mend;
%abc(def=22);

proc append data=gda.abcdgda base=zz;
run;

%let a=b;;
data x;
x=1;
do i=1 to 12;
    a=2;
    g=12;
end;
run;