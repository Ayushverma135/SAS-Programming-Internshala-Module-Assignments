/* Define the macro */
%macro myStat(make=, type=);

    /* Step 1: Create Frequency Distribution Table */
    proc freq data=mylib.all_cars_with_mpg noprint;
        tables &make.*type*Origin / out=freq_table (drop=percent rename=(count=Frequency));
    run;

    /* Create a macro variable to store the result */
    %let Total_Frequency = ;

    /* Calculate the Sum of All Frequencies */
    proc sql noprint;
        select sum(Frequency) into :Total_Frequency
        from freq_table;
    quit;

    /* Print the result */
    %put Total Frequency: &Total_Frequency.;

    /* Step 2: Calculate Percentages and Concatenate Frequency Count and Percentage */
    proc sql;
        create table freq_table as
        select *, 
               (Frequency / &Total_Frequency * 100) as Percent format=5.1
        from freq_table
        group by &make.;
    quit;

    data freq_table;
        set freq_table;
        Count_Percent = catx(' ', Frequency, '(' || put(Percent, 5.1) || '%)');
    run;

/*     Step 3: Transpose the Data */
    proc sort data=freq_table;
        by make;
    run;
/*  */
    proc transpose data=freq_table out=transposed_table(drop=_name_) prefix=Type_;
        by &make.;
        id type;
        var Count_Percent;
    run;
/*  */
/*     Step 4: Create the Final Report */
    proc print data=transposed_table noobs;
        title 'Report of Frequency Count and Percentage';
        var &make. Type_Sports Type_Sedan Type_Wagon Type_Truck Type_Hybrid;
    run;

%mend;

/* Call the macro with input parameters MAKE and TYPE */
%myStat(make=Make, type=Type);
