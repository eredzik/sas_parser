proc sql;
select sum(a), count(*), coalesce(51,gogo ) as daga, bghgg
from abc
;quit;

proc sql noprint;
select
sth, sth2 into :macrovariabletobemade, :foobar
from abc
;quit;

proc sql;
select *
from (abc)
where %macrowhre and macro2 =2 or abc >1
group by 1, 2
having sum(abc) = 1
order by macrowhere, %col2, &macrovar, col3, %col5(abc)
;quit;


proc sql;
create table
%gen_table_name(&abc) as 
select * from 
%gen_other(&abc, foo=bar)
where
1 or 2 and 
%abc
%def(%length(&macroabc.) gt 0, and (abc in (%gl_sth(&abcmacvar.))))
%def(%length(&macroabc.) gt 0, and (abc not in (%gl_sth(&abcmacvar.))))

order by 1,2,3;
quit;