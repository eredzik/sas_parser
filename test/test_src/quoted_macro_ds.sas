data x;
set zzz yy;
merge abc dez;
a = "%somemacro(foo, foobar=bar);";
b = %macrox(foo, kwarg=kval);
run;