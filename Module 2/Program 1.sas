libname mylib '/home/u63867400';
data mylib.cars_asia;
    infile '/home/u63867400/carsasiapipedelimited.txt' dlm='|' dsd firstobs=2;
    input Make $ Model :$40. Type $ Origin $ MSRP : dollar10.;
    format MSRP dollar8.;
run;

filename reffile '/home/u63867400/carseu.xlsx';
proc import datafile=reffile
	dbms=xlsx
    out=mylib.cars_europe;
    getnames=yes;
run;
proc sql;
    create table mylib.expensive_european_cars as
    select Make, Model, MSRP
    from mylib.cars_europe
    where MSRP > 150000
    order by MSRP desc;
quit;

proc print data=mylib.expensive_european_cars;
    title 'Most Expensive European Cars with MSRP Greater Than $150,000';
run;