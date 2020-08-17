%let somevar = %macro1 ( %macro2( arg1, arg=arg2));
%let somevar = %macro1 ( arg1, arg2=%macro2( arg1, arg=arg2 eq 5));
%let somevar = %macro1 ( arg1, arg2=%macro2( arg1, arg=arg2 eq %macro3(abc)));
%let somevar = %macro1 ( argum, kwarg = %macro2(&var1 eq 2));
%let somevar = %macro1 ( argum, kwarg = %macro2(&var1 eq %macro3(sth.sthelse), %macro4(abcd), %macro5(defg)));
%let somevar = %macro1 ( argum, kwarg = %macro2(&var1 eq %macro3(abc(1))));
