proc sql;
select sum(a), count(*), coalesce(51,gogo ) as daga, bghgg
from abc
;quit;

proc sql noprint;
select
sth, sth2 into :macrovariabletobemade, :foobar
from abc
;quit;