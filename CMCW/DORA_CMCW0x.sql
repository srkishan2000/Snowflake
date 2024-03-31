-- set your worksheet drop lists or write and run USE commands
-- YOU WILL NEED TO USE ACCOUNTADMIN ROLE on this test.

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
( 
 SELECT 'CMCW01' as step
 , ( select count(*)
    from snowflake.account_usage.databases
    where database_name = 'INTL_DB'
        and deleted is null) as actual
 , 1 as expected
 , 'Created INTL_DB' as description
 );


select count(*) as OBJECTS_FOUND
from INTL_DB.INFORMATION_SCHEMA.TABLES
where table_schema='PUBLIC'
    and table_name= 'INT_STDS_ORG_3166';


select row_count
from INTL_DB.INFORMATION_SCHEMA.TABLES
where table_schema='PUBLIC'
    and table_name= 'INT_STDS_ORG_3166';


-- set your worksheet drop lists to the location of your GRADER function
-- role can be set to either SYSADMIN or ACCOUNTADMIN for this check

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT 'CMCW02' as step
 , ( select count(*)
    from INTL_DB.INFORMATION_SCHEMA.TABLES
    where table_schema = 'PUBLIC'
        and table_name = 'INT_STDS_ORG_3166') as actual
 , 1 as expected
 , 'ISO table created' as description
);


-- set your worksheet drop lists to the location of your GRADER function 
-- either role can be used

-- DO NOT EDIT BELOW THIS LINE 
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
( 
SELECT 'CMCW03' as step 
 , (select row_count
    from INTL_DB.INFORMATION_SCHEMA.TABLES
    where table_name = 'INT_STDS_ORG_3166') as actual 
 , 249 as expected 
 , 'ISO Table Loaded' as description 
);


-- SET YOUR DROPLISTS PRIOR TO RUNNING THE CODE BELOW 

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT 'CMCW04' as step
 , ( select count(*)
    from INTL_DB.PUBLIC.NATIONS_SAMPLE_PLUS_ISO) as actual
 , 249 as expected
 , 'Nations Sample Plus Iso' as description
);


-- set your worksheet drop lists

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT 'CMCW05' as step
 , (select row_count
    from INTL_DB.INFORMATION_SCHEMA.TABLES
    where table_schema = 'PUBLIC'
        and table_name = 'COUNTRY_CODE_TO_CURRENCY_CODE') as actual
 , 265 as expected
 , 'CCTCC Table Loaded' as description
);


-- set your worksheet context menus

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT 'CMCW06' as step
 , (select row_count
    from INTL_DB.INFORMATION_SCHEMA.TABLES
    where table_schema = 'PUBLIC'
        and table_name = 'CURRENCIES') as actual
 , 151 as expected
 , 'Currencies table loaded' as description
);


-- don't forget your droplists

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'CMCW07' as step 
, ( select count(*)
    from INTL_DB.PUBLIC.SIMPLE_CURRENCY ) as actual
, 265 as expected
, 'Simple Currency Looks Good' as description
);


-- set your worksheet drop lists to the location of your GRADER function
--DO NOT EDIT ANYTHING BELOW THIS LINE

--This DORA Check Requires that you RUN two Statements, one right after the other
show shares in account;

--the above command puts information into memory that can be accessed using result_scan(last_query_id())
-- If you have to run this check more than once, always run the SHOW command immediately prior
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'CMCW08' as step
 , ( select IFF(count(*)>0,1,0)
    from table(result_scan(last_query_id()))
    where "kind" = 'OUTBOUND'
        and "database_name" = 'INTL_DB') as actual
 , 1 as expected
 , 'Outbound Share Created From INTL_DB' as description
);


-- set your worksheet drop lists to the location of your GRADER function
--DO NOT EDIT ANYTHING BELOW THIS LINE

--This DORA Check Requires that you RUN two Statements, one right after the other
show resource monitors in account;

--the above command puts information into memory that can be accessed using result_scan(last_query_id())
-- If you have to run this check more than once, always run the SHOW command immediately prior
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'CMCW09' as step
 , ( select IFF(count(*)>0,1,0)
    from table(result_scan(last_query_id()))
    where "name" = 'DAILY_3_CREDIT_LIMIT'
        and "credit_quota" = 3
        and "frequency" = 'DAILY') as actual
 , 1 as expected
 , 'Resource Monitors Exist' as description
);






-- set the worksheet drop lists to match the location of your GRADER function
--DO NOT MAKE ANY CHANGES BELOW THIS LINE

--RUN THIS DORA CHECK IN YOUR ORIGINAL TRIAL ACCOUNT
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
( SELECT 'CMCW12' as step , ( select count(*)
    from SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS
    where account_name = 'ACME'
        and region like 'AZURE_%' and deleted_on is null) as actual , 1 as expected , 'ACME Account Added on Azure Platform' as description );



-- set the worksheet drop lists to match the location of your GRADER function
--DO NOT MAKE ANY CHANGES BELOW THIS LINE

--RUN THIS DORA CHECK IN YOUR ORIGINAL TRIAL ACCOUNT

select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT
    'CMCW13' as step
 , ( select count(*)
    from SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS
    where account_name = 'AUTO_DATA_UNLIMITED'
        and region like 'GCP_%'
        and deleted_on is null) as actual
 , 1 as expected
 , 'ADU Account Added on GCP' as description
);



-- set the worksheet drop lists to match the location of your GRADER function
--DO NOT MAKE ANY CHANGES BELOW THIS LINE

--RUN THIS DORA CHECK IN YOUR ACME ACCOUNT

select grader(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT
    'CMCW14' as step
 , ( select count(*)
    from STOCK.UNSOLD.LOTSTOCK
    where engine like '%.5 L%'
        or plant_name like '%z, Sty%'
        or desc2 like '%xDr%') as actual
 , 145 as expected
 , 'Intentionally cryptic test' as description
);


select count(*)
from SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS
where account_name = 'ACME'
    and region like 'AZURE_%' and deleted_on is null

select *
from snowflake.organization_usage.accounts

















 