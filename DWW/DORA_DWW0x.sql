--You can run this code, or you can use the drop lists in your worksheet to get the context settings right.
use database UTIL_DB;
use schema PUBLIC;
use role
ACCOUNTADMIN;

--Do NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT
    'DWW01' as step
 , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
    where schema_name in ('FLOWERS','VEGGIES','FRUITS')) as actual
  , 3 as expected
  , 'Created 3 Garden Plant schemas' as description
);




--Remember that every time you run a DORA check, the context needs to be set to the below settings. 
use database UTIL_DB;
use schema PUBLIC;
use role
ACCOUNTADMIN;

--Do NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW02' as step 
 , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
    where schema_name = 'PUBLIC') as actual 
 , 0 as expected 
 , 'Deleted PUBLIC schema.' as description
);





-- Do NOT EDIT ANYTHING BELOW THIS LINE 
-- Remember to set your WORKSHEET context (do not add context to the grader call)
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW03' as step 
 , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'ROOT_DEPTH') as actual 
 , 1 as expected 
 , 'ROOT_DEPTH Table Exists' as description
);





--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW04' as step
 , ( select count(*) as SCHEMAS_FOUND
    from UTIL_DB.INFORMATION_SCHEMA.SCHEMATA) as actual
 , 2 as expected
 , 'UTIL_DB Schemas' as description
);





--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW05' as step
 , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'VEGETABLE_DETAILS') as actual
 , 1 as expected
 , 'VEGETABLE_DETAILS Table' as description
);





--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
( 
 SELECT 'DWW06' as step 
, ( select row_count
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'ROOT_DEPTH') as actual 
, 3 as expected 
, 'ROOT_DEPTH row count' as description
);





--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW07' as step
 , ( select row_count
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'VEGETABLE_DETAILS') as actual
 , 41 as expected
 , 'VEG_DETAILS row count' as description
);






--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
( 
   SELECT 'DWW08' as step 
   , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS
    where FIELD_DELIMITER =','
        and FIELD_OPTIONALLY_ENCLOSED_BY ='"') as actual 
   , 1 as expected 
   , 'File Format 1 Exists' as description 
);






--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW09' as step
 , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS
    where FIELD_DELIMITER ='|' 
   ) as actual
 , 1 as expected
 , 'File Format 2 Exists' as description
);




-- List Stage 
list @like_a_window_into_an_s3_bucket;

-- example
-- list @util_db.public.like_a_window_into_an_s3_bucket;

list @like_a_window_into_an_s3_bucket/this_;

list @like_a_window_into_an_s3_bucket/THIS_;





--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DWW10' as step
  , ( select count(*)
    from UTIL_DB.INFORMATION_SCHEMA.stages
    where stage_url='s3://uni-lab-files'
        and stage_type='External Named') as actual
  , 1 as expected
  , 'External stage created' as description
 );




-- Just for reference table has been created
create or replace table vegetable_details_soil_type
( plant_name varchar
(25)
 ,soil_type number
(1,0)
);


copy into vegetable_details_soil_type
from @util_db.public.like_a_window_into_an_s3_bucket
files =
( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format =
( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW );




--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DWW11' as step
  , ( select row_count
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'VEGETABLE_DETAILS_SOIL_TYPE') as actual
  , 42 as expected
  , 'Veg Det Soil Type Count' as description
 );



--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.like_a_window_into_an_s3_bucket/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  
select $1, $2, $3
from @util_db.public.like_a_window_into_an_s3_bucket/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.like_a_window_into_an_s3_bucket/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );




-- Create a fie format for tab space
create file format garden_plants.veggies.L8_CHALLENGE_FF 
    TYPE = 'CSV' --csv is used for any flat file (tsv, pipe-separated, etc)
    FIELD_DELIMITER = '\t' --pipes as column separators
    SKIP_HEADER = 1 --one header row to skip
    ;


select $1, $2, $3
from @util_db.public.like_a_window_into_an_s3_bucket/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.L8_CHALLENGE_FF );



create or replace table garden_plants.veggies.LU_SOIL_TYPE
(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar
(15),
SOIL_DESCRIPTION varchar
(75)
 );



copy into garden_plants.veggies.LU_SOIL_TYPE
from @util_db.public.like_a_window_into_an_s3_bucket
files =
( 'LU_SOIL_TYPE.tsv')
file_format =
( format_name=GARDEN_PLANTS.VEGGIES.L8_CHALLENGE_FF );



create or replace table GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT
(
    plant_name text
(18),	
    UOM	text
(1),
    Low_End_of_Range number
(2),
    High_End_of_Range number
(2)
);


copy into garden_plants.veggies.VEGETABLE_DETAILS_PLANT_HEIGHT
from @util_db.public.like_a_window_into_an_s3_bucket
files =
( 'veg_plant_height.csv')
file_format =
( format_name=garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW );




--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(  
      SELECT 'DWW12' as step 
      , ( select row_count
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT') as actual 
      , 41 as expected 
      , 'Veg Detail Plant Height Count' as description   
);



--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(  
     SELECT 'DWW13' as step 
     , ( select row_count
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'LU_SOIL_TYPE') as actual 
     , 8 as expected 
     , 'Soil Type Look Up Table' as description   
);



-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE 
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
( 
     SELECT 'DWW14' as step 
     , ( select count(*)
    from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS
    where FILE_FORMAT_NAME='L8_CHALLENGE_FF'
        and FIELD_DELIMITER = '\t') as actual 
     , 1 as expected 
     , 'Challenge File Format Created' as description  
);



-- There is no need to edit this code, but db and schema are flexible and will not affect whether your badge is issued
create or replace external function util_db.public.greeting
(
      email varchar
    , firstname varchar
    , middlename varchar
    , lastname varchar)
returns variant
api_integration = dora_api_integration
context_headers =
(current_timestamp,current_account, current_statement) 
as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/greeting'
;


select util_db.public.greeting('srikishan2000@gmail.com', 'Shanmuga Sundaram', '', 'Ganesan');





-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE 
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(  
     SELECT 'DWW15' as step 
     , ( select count(*)
    from LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba
        join LIBRARY_CARD_CATALOG.PUBLIC.author a
        on ba.author_uid = a.author_uid
        join LIBRARY_CARD_CATALOG.PUBLIC.book b
        on b.book_uid=ba.book_uid) as actual 
     , 6 as expected 
     , '3NF DB was Created.' as description  
);



-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DWW16' as step
  , ( select row_count
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES
    where table_name = 'AUTHOR_INGEST_JSON') as actual
  , 6 as expected
  , 'Check number of rows' as description
 );




-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(   
     SELECT 'DWW17' as step 
      , ( select row_count
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES
    where table_name = 'NESTED_INGEST_JSON') as actual 
      , 5 as expected 
      , 'Check number of rows' as description  
);



-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
   SELECT 'DWW18' as step
  , ( select row_count
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES
    where table_name = 'TWEET_INGEST') as actual
  , 9 as expected
  , 'Check number of rows' as description  
 );




-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.

select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DWW19' as step
  , ( select count(*)
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS
    where table_name = 'HASHTAGS_NORMALIZED') as actual
  , 1 as expected
  , 'Check number of rows' as description
 ); 
 
