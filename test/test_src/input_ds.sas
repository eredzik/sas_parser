data x;
length order 8 charvar $5 otherchar $20 &macrovar. &macrovar $5 &macrovar 3 from 8 %build(&other);
assignment_const_num = 25432.55353;
assignment_const_char = 'CHARSTH';
assignment_const_char2 = "GAGA";
assignment_var2 =  assign1;
do i=1 to 12;
    a=2;
    g=12;
end;
if a=b then a=z;
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

if a gt 5 then do;
    if abc eq &a then b=1;
    if abc lt %macrocall(foo, foo=bar) then abc=1;
    x = abc ge 5;
    x = abc >= 6;
    x = abc le 7;
    x = abc ne 8;
    x = abc ^= 9;
end;
run;