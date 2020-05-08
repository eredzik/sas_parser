data x;
/* assignment_const_num = 25432.55353; */
/* assignment_const_char = 'CHARSTH'; */
/* assignment_const_char2 = "GAGA"; */
/* assignment_var2 =  assign1;
do i=1 to 12;
    a=2;
    g=12;
end;
if a=b then a=z; */
if a=b then do;
    dasdsadb=ddadada;
end;
do i=1 to 5;
    a=i*2;

end;

if a=b then do;
    a=b;
end;
%call_some_macro;
macro_result1 = %call_some_macro(a, b);
macro_result2 = %call_some_macro(a, b=2);
macro_result3 = %call_some_macro(a, dupa.b, b=2, c=dupa.x);
macro_result4 = %call_some_macro(a, dupa.b, b=%macro243);
call_some_func = call_some_func(b);

run;