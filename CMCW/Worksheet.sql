-- Granting privileges
grant imported privileges
on database SNOWFLAKE_SAMPLE_DATA
to role SYSADMIN;


--Check the range of values in the Market Segment Column
SELECT DISTINCT c_mktsegment
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

--Find out which Market Segments have the most customers
SELECT c_mktsegment, COUNT(*)
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
GROUP BY c_mktsegment
ORDER BY COUNT(*);


--  Join and aggregate shared data
-- Nations Table
SELECT N_NATIONKEY, N_NAME, N_REGIONKEY
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;

-- Regions Table
SELECT R_REGIONKEY, R_NAME
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION;

-- Join the Tables and Sort
SELECT R_NAME as Region, N_NAME as Nation
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION
    JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION
    ON N_REGIONKEY = R_REGIONKEY
ORDER BY R_NAME, N_NAME ASC;

--Group and Count Rows Per Region
SELECT R_NAME as Region, count(N_NAME) as NUM_COUNTRIES
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION
    JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION
    ON N_REGIONKEY = R_REGIONKEY
GROUP BY R_NAME;


--- *** ---

-- where did you put the function?
show user functions in account;

-- did you put it here?
select *
from util_db.information_schema.functions
where function_name = 'GRADER'
    and function_catalog = 'UTIL_DB'
    and function_owner = 'ACCOUNTADMIN';



-- Validate Grader
select GRADER(step,(actual = expected), actual, expected, description
) as graded_results from
(
SELECT 'DORA_IS_WORKING' as step
 , (select 223 ) as actual
 , 223 as expected
 , 'Dora is working!' as description
);



-- DB Creation using SYSADMIN

use role
SYSADMIN;

create database INTL_DB;

use schema INTL_DB.PUBLIC;




-- Warehouse creation

create warehouse INTL_WH
with 
warehouse_size = 'XSMALL' 
warehouse_type = 'STANDARD' 
auto_suspend = 600 --600 seconds/10 mins
auto_resume = TRUE;

use warehouse
INTL_WH;



create or replace table intl_db.public.INT_STDS_ORG_3166
(iso_country_name varchar
(100), 
 country_name_official varchar
(200), 
 sovreignty varchar
(40), 
 alpha_code_2digit varchar
(2), 
 alpha_code_3digit varchar
(3), 
 numeric_country_code integer,
 iso_subdivision varchar
(15), 
 internet_domain_code varchar
(10)
);




create or replace file format util_db.public.PIPE_DBLQUOTE_HEADER_CR 
  type = 'CSV' --use CSV for any flat file
  compression = 'AUTO' 
  field_delimiter = '|' --pipe or vertical bar
  record_delimiter = '\r' --carriage return
  skip_header = 1  --1 header row
  field_optionally_enclosed_by = '\042'  --double quotes
  trim_space = FALSE;



show stages in account;


create stage util_db.public.aws_s3_bucket url = 's3://uni-cmcw';

list @util_db.public.aws_s3_bucket;


copy into intl_db.public.INT_STDS_ORG_3166 
from @util_db.public.aws_s3_bucket 
files =
( 'ISO_Countries_UTF8_pipe.csv') 
file_format =
( format_name='util_db.public.PIPE_DBLQUOTE_HEADER_CR' );


select count(*) as found, '249' as expected
from INTL_DB.PUBLIC.INT_STDS_ORG_3166;

ALTER DATABASE INTRL_DB
RENAME TO INTL_DB;




--- Normalized VIEW ---

--Create a View of the Tweet Data Looking "Normalized"
create or replace view SOCIAL_MEDIA_FLOODGATES.PUBLIC.HASHTAGS_NORMALIZED as
(SELECT
RAW_STATUS:
user:
id AS USER_ID
,
RAW_STATUS:
id AS TWEET_ID
,
value:
text::VARCHAR AS HASHTAG_TEXT
FROM TWEET_INGEST
,LATERAL FLATTEN
(input =>
RAW_STATUS:
entities:
hashtags)
);



-- Join Local Data with Shared Data

select
    iso_country_name
    , country_name_official, alpha_code_2digit
    , r_name as region
from INTL_DB.PUBLIC.INT_STDS_ORG_3166 i
    left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION n
    on upper(i.iso_country_name)= n.n_name
    left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION r
    on n_regionkey = r_regionkey;


-- Convert the Select Statement into a View

create view intl_db.public.NATIONS_SAMPLE_PLUS_ISO
(
    iso_country_name
  ,
    country_name_official
  ,
    alpha_code_2digit
  ,
    region
)
AS
    select
        iso_country_name
    , country_name_official, alpha_code_2digit
    , r_name as region
    from INTL_DB.PUBLIC.INT_STDS_ORG_3166 i
        left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION n
        on upper(i.iso_country_name)= n.n_name
        left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION r
        on n_regionkey = r_regionkey
;


select *
from intl_db.public.NATIONS_SAMPLE_PLUS_ISO;


create table intl_db.public.CURRENCIES
(
    currency_ID integer,
    currency_char_code varchar(3),
    currency_symbol varchar(4),
    currency_digital_code varchar(3),
    currency_digital_name varchar(30)
)
comment = 'Information about currencies including character codes, symbols, digital codes, etc.';


create table intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE
(
    country_char_code varchar(3),
    country_numeric_code integer,
    country_name varchar(100),
    currency_name varchar(100),
    currency_char_code varchar(3),
    currency_numeric_code integer
)
comment = 'Mapping table currencies to countries';


create file format util_db.public.CSV_COMMA_LF_HEADER
  type = 'CSV' 
  field_delimiter = ',' 
  record_delimiter = '\n' -- the n represents a Line Feed character
  skip_header = 1 
;



-- CurrencyID,Currency,Symbol,Digital code,Name
-- 1,AED,ÿØ.ÿ•,784,UAE Dirham

-- s3://uni-cmcw/currencies.csv  151 rows

copy into intl_db.public.CURRENCIES 
from @util_db.public.aws_s3_bucket 
files =
( 'currencies.csv') 
file_format =
( format_name='util_db.public.CSV_COMMA_LF_HEADER' );


-- util_db.public.PIPE_DBLQUOTE_HEADER_CR

-- country_Code,Country_number,Country,Currency Name,Currency_Code,Currency_Number
-- AFG,4,AFGHANISTAN,Afghani,AFN,971

-- s3://uni-cmcw/country_code_to_currency_code.csv  265 rows

copy into intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE 
from @util_db.public.aws_s3_bucket 
files =
( 'country_code_to_currency_code.csv') 
file_format =
( format_name='util_db.public.CSV_COMMA_LF_HEADER' );



create view intl_db.public.SIMPLE_CURRENCY
(
    CTY_CODE
  ,
    CURR_CODE
)
AS
    select
        COUNTRY_CHAR_CODE, CURRENCY_CHAR_CODE
    from COUNTRY_CODE_TO_CURRENCY_CODE
;


select *
from SIMPLE_CURRENCY;




-- Convert "Regular" Views to Secure Views

alter view intl_db.public.NATIONS_SAMPLE_PLUS_ISO
set secure;

alter view intl_db.public.SIMPLE_CURRENCY
set secure; 

 
