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
order by macrowhere
;quit;