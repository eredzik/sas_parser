%macro abc(gda, gdag=gdga, ggdag=);
%do i=1 %to &gdgda.;
%let wartosc = %scan(&gdag, &i);

data x;
set zzz;
run;

%end;

%mend abc;

%abc(gdga gda gdagda);