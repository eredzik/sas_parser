proc sql noprint;
insert into tabname
(col1, col2, col3, col4)
values
("string", "%macrostring(a, foo=bar);", 1.234, &abadfa)
;quit;