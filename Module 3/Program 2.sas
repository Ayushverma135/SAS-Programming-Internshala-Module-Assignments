libname mylib '/home/u63867400';
data mylib.cars_usa;
    set mylib.cars_usa;
    length Make $ 20 Model :$ 40. Type $ 20 Origin $ 20 MSRP 8.;
run;
filename reffile '/home/u63867400/assignment_2-carsmpg.xlsx';
proc import datafile=reffile
	dbms=xlsx
    out=mylib.cars_mpg;
    getnames=yes;
run;
data mylib.all_cars;
    set mylib.cars_asia mylib.cars_europe mylib.cars_usa;
run;
proc sql;
    create table mylib.all_cars_with_mpg as
    select a.*, b.MPG_HIGHWAY
    from mylib.all_cars as a
    left join mylib.cars_mpg as b
    on a.Make = b.Make and a.Model = b.Model;
quit;
proc sql;
    create table mylib.cheapest_european_suv_high_mpg as
    select Make, Model, Type, Origin,  MSRP, MPG_HIGHWAY
    from mylib.all_cars_with_mpg
    where Type = 'SUV' and Origin = 'Europe'
    order by MPG_HIGHWAY desc, MSRP asc;
quit;

proc print data=mylib.cheapest_european_suv_high_mpg (obs=1);
    title 'Cheapest European SUV with Highest Mileage';
run;