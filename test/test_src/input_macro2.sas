%macro abc;
%global supervar;
%if &some_other_Var. eq 1 %then
    %let STH = %paramszit(&sth..gdsgds.dgs, defau=%macrob(foo, bar=%macrocall));
%else
    %let sth = 1 = 1;
%put NOTE: &=gdgdag;
%mend;
%abc;