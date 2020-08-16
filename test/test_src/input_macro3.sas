%macro do_something_to_table(input_table, output_table);
%do i=1 %to 50 %by 2;
    %if &i = 5 %then %let input_table = foo;
    %else %if &i=10 %then %let input_table = bar;
    %else %let input_table = baz;

    %put &=input_table;
    

%end;

%mend;