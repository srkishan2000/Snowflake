alter user KISHOREK set default_role = 'SYSADMIN';
alter user KISHOREK set default_warehouse = 'COMPUTE_WH';
alter user KISHOREK set default_namespace = 'UTIL_DB.PUBLIC';



CREATE DATABASE AGS_GAME_AUDIENCE;

DROP SCHEMA AGS_GAME_AUDIENCE.PUBLIC;

CREATE SCHEMA AGS_GAME_AUDIENCE.RAW;

CREATE TABLE AGS_GAME_AUDIENCE.RAW.GAME_LOGS(
    RAW_LOG VARIANT
);

list @uni_kishore/kickoff;

list @uni_kishore/updated_feed;

select $1 from @uni_kishore/kickoff
(file_format => FF_JSON_LOGS)

/*
{
  "agent": "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/534.18 (KHTML, like Gecko) Chrome/11.0.660.0 Safari/534.18",
  "datetime_iso8601": "2022-10-13T01:24:53Z",
  "user_event": "login",
  "user_login": "atamlett0"
}
*/

select $1 from @uni_kishore/updated_feed/
(file_format => FF_JSON_LOGS)
/*
{
  "datetime_iso8601": "2022-10-14 22:28:58.000",
  "ip_address": "184.105.65.130",
  "user_event": "login",
  "user_login": "Woźniak31"
} */

COPY INTO AGS_GAME_AUDIENCE.RAW.GAME_LOGS 
from @uni_kishore/kickoff
file_format = (format_name = FF_JSON_LOGS) 


select 
RAW_LOG:agent::text as AGENT,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:user_login::text as USER_LOGIN,
RAW_LOG:datetime_iso8601::TIMESTAMP_NTZ as datetime_iso8601,
* 
from GAME_LOGS; 

select 
* 
from GAME_LOGS; 


CREATE VIEW my_view as 
select 
RAW_LOG:agent::text as AGENT,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:user_login::text as USER_LOGIN,
RAW_LOG:datetime_iso8601::TIMESTAMP_NTZ as datetime_iso8601,
* 
from GAME_LOGS;


select * from my_view;


SELECT current_timestamp(); 


-- Change the Time Zone for Your Current Worksheet
--what time zone is your account(and/or session) currently set to? Is it -0700?
select current_timestamp();   -- 2024-03-28 11:40:56.423 -0700

--worksheets are sometimes called sessions -- we'll be changing the worksheet time zone
alter session set timezone = 'UTC';
select current_timestamp();   -- 2024-03-28 18:41:16.139 +0000

--how did the time differ after changing the time zone for the worksheet?
alter session set timezone = 'Africa/Nairobi';
select current_timestamp();   -- 2024-03-28 21:41:42.609 +0300

alter session set timezone = 'Pacific/Funafuti';
select current_timestamp();   -- 2024-03-29 06:42:03.223 +1200

alter session set timezone = 'Asia/Shanghai';
select current_timestamp();   -- 2024-03-29 02:42:19.165 +0800

--show the account parameter called timezone
show parameters like 'timezone';  -- Session Timezone details




COPY INTO AGS_GAME_AUDIENCE.RAW.GAME_LOGS 
from @uni_kishore/updated_feed
file_format = (format_name = FF_JSON_LOGS) 


select 
$1:agent::text as agent,
$1:ip_address::text as ip_address
from GAME_LOGS;



--looking for empty AGENT column
select * 
from ags_game_audience.raw.LOGS
where agent is null;

--looking for non-empty IP_ADDRESS column
select 
RAW_LOG:ip_address::text as IP_ADDRESS
,*
from ags_game_audience.raw.LOGS
where RAW_LOG:ip_address::text is not null;


CREATE OR REPLACE VIEW ags_game_audience.raw.LOGS as 
select 
--RAW_LOG:agent::text as AGENT,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:user_login::text as USER_LOGIN,
RAW_LOG:datetime_iso8601::TIMESTAMP_NTZ as datetime_iso8601,
RAW_LOG:ip_address::text as IP_ADDRESS,
* 
from GAME_LOGS
where RAW_LOG:ip_address::text is not null;


select * from ags_game_audience.raw.LOGS;



CREATE or REPLACE SCHEMA  AGS_GAME_AUDIENCE.ENHANCED;



--Look up Kishore and Prajina's Time Zone in the IPInfo share using his headset's IP Address with the PARSE_IP function.
select start_ip, end_ip, start_ip_int, end_ip_int, city, region, country, timezone
from IPINFO_GEOLOC.demo.location
where parse_ip('100.41.16.160', 'inet'):ipv4 --Kishore's Headset's IP Address
BETWEEN start_ip_int AND end_ip_int;


-- Look Up Everyone's Time Zone


--Join the log and location tables to add time zone to each row using the PARSE_IP function.
select logs.*
       , loc.city
       , loc.region
       , loc.country
       , loc.timezone
from AGS_GAME_AUDIENCE.RAW.LOGS logs
join IPINFO_GEOLOC.demo.location loc
where parse_ip(logs.ip_address, 'inet'):ipv4 
BETWEEN start_ip_int AND end_ip_int;



--Use two functions supplied by IPShare to help with an efficient IP Lookup Process!
SELECT logs.ip_address
, logs.user_login
, logs.user_event
, logs.datetime_iso8601
, city
, region
, country
, timezone 
from AGS_GAME_AUDIENCE.RAW.LOGS logs
JOIN IPINFO_GEOLOC.demo.location loc 
ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address) 
BETWEEN start_ip_int AND end_ip_int;



-- Your role should be SYSADMIN
-- Your database menu should be set to AGS_GAME_AUDIENCE
-- The schema should be set to RAW

--a Look Up table to convert from hour number to "time of day name"
create table ags_game_audience.raw.time_of_day_lu
(  hour number
   ,tod_name varchar(25)
);

--insert statement to add all 24 rows to the table
insert into ags_game_audience.raw.time_of_day_lu
values
(6,'Early morning'),
(7,'Early morning'),
(8,'Early morning'),
(9,'Mid-morning'),
(10,'Mid-morning'),
(11,'Late morning'),
(12,'Late morning'),
(13,'Early afternoon'),
(14,'Early afternoon'),
(15,'Mid-afternoon'),
(16,'Mid-afternoon'),
(17,'Late afternoon'),
(18,'Late afternoon'),
(19,'Early evening'),
(20,'Early evening'),
(21,'Late evening'),
(22,'Late evening'),
(23,'Late evening'),
(0,'Late at night'),
(1,'Late at night'),
(2,'Late at night'),
(3,'Toward morning'),
(4,'Toward morning'),
(5,'Toward morning');



--Check your table to see if you loaded it properly
select tod_name, listagg(hour,',') 
from ags_game_audience.raw.time_of_day_lu
group by tod_name;




select 
  logs.ip_address,
  logs.user_login as gamer_name,
  logs.user_event as GAME_EVENT_NAME,
  logs.datetime_iso8601 as GAME_EVENT_UTC,
  city,
  region,
  country,
  timezone as GAMER_LTZ_NAME,
  convert_timezone('UTC', GAMER_LTZ_NAME, GAME_EVENT_UTC) as game_event_ltz,
  dayname(game_event_ltz) as dow_name,  --  GAMER_LTZ_NAME --logs.datetime_iso8601
  tod_lu.tod_name
from AGS_GAME_AUDIENCE.RAW.LOGS logs
join IPINFO_GEOLOC.demo.location loc
  on ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
  and ipinfo_geoloc.public.to_int(logs.ip_address)
between start_ip_int and end_ip_int
join ags_game_audience.raw.time_of_day_lu tod_lu
  on tod_lu.hour = hour(game_event_ltz)   --;  -- game_event_ltz, GAME_EVENT_UTC
where dow_name = 'Sat'
      and tod_name = 'Early evening'   
      and gamer_name like '%prajina' 


/*
IP_ADDRESS	GAMER_NAME	GAME_EVENT_NAME	GAME_EVENT_UTC	CITY	REGION	COUNTRY	GAMER_LTZ_NAME	GAME_EVENT_LTZ	DOW_NAME	TOD_NAME
100.41.16.160	princess_prajina	login	2022-10-16 01:22:15.000	Denver	Colorado	US	America/Denver	2022-10-15 19:22:15.000	Sun	Late at night
100.41.16.160	princess_prajina	logout	2022-10-16 01:39:15.000	Denver	Colorado	US	America/Denver	2022-10-15 19:39:15.000	Sun	Late at night
*/


-- select * from IPINFO_GEOLOC.demo.location loc;


TRUNCATE table ags_game_audience.enhanced.logs_enhanced;

--Wrap any Select in a CTAS statement
CREATE or REPLACE table ags_game_audience.enhanced.logs_enhanced as(
select 
  logs.ip_address,
  logs.user_login as GAMER_NAME,
  logs.user_event as GAME_EVENT_NAME,
  logs.datetime_iso8601 as GAME_EVENT_UTC,
  city,
  region,
  country,
  timezone as GAMER_LTZ_NAME,
  convert_timezone('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
  dayname(game_event_ltz) as dow_name,
  tod_lu.tod_name
from AGS_GAME_AUDIENCE.RAW.LOGS logs
join IPINFO_GEOLOC.demo.location loc
  on ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
  and ipinfo_geoloc.public.to_int(logs.ip_address)
between start_ip_int and end_ip_int
join ags_game_audience.raw.time_of_day_lu tod_lu
  on tod_lu.hour = hour(game_event_ltz)
);


select * from ags_game_audience.enhanced.logs_enhanced limit 2;


select count(*) 
      from ags_game_audience.enhanced.logs_enhanced
      where dow_name = 'Sat'
      and tod_name = 'Early evening'   
      and gamer_name like '%prajina'


select * from AGS_GAME_AUDIENCE.RAW.LOGS log where user_login like '%prajina'; 
/*

USER_EVENT	USER_LOGIN	DATETIME_ISO8601	IP_ADDRESS	RAW_LOG
login	princess_prajina	2022-10-16 01:22:15.000	100.41.16.160	{   "datetime_iso8601": "2022-10-16 01:22:15.000",   "ip_address": "100.41.16.160",   "user_event": "login",   "user_login": "princess_prajina" }
logout	princess_prajina	2022-10-16 01:39:15.000	100.41.16.160	{   "datetime_iso8601": "2022-10-16 01:39:15.000",   "ip_address": "100.41.16.160",   "user_event": "logout",   "user_login": "princess_prajina" }


IP_ADDRESS	GAMER_NAME	GAME_EVENT_NAME	GAME_EVENT_UTC	CITY	REGION	COUNTRY	GAMER_LTZ_NAME	GAME_EVENT_LTZ	DOW_NAME	TOD_NAME
50.3.180.145	Sadowski26	logout	2022-10-15 19:39:42.000	Warsaw	Mazovia	PL	Europe/Warsaw	2022-10-15 21:39:42.000	Sat	Early evening
50.3.180.153	Bąk12	logout	2022-10-15 19:00:12.000	Warsaw	Mazovia	PL	Europe/Warsaw	2022-10-15 21:00:12.000	Sat	Early evening
24.158.11.164	Kalla33	login	2022-10-15 19:35:40.000	Sheboygan	Wisconsin	US	America/Chicago	2022-10-15 14:35:40.000	Sat	Early evening
24.158.11.164	Kalla33	logout	2022-10-15 19:41:40.000	Sheboygan	Wisconsin	US	America/Chicago	2022-10-15 14:41:40.000	Sat	Early evening

*/


--You have to run this grant or you won't be able to test your tasks while in SYSADMIN role
--this is true even if SYSADMIN owns the task!!
grant execute task on account to role SYSADMIN;

--Now you should be able to run the task, even if your role is set to SYSADMIN
execute task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

--the SHOW command might come in handy to look at the task 
show tasks in account;

--you can also look at any task more in depth using DESCRIBE
describe task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;


select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;



-- CREATE TASK
create or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
	warehouse=COMPUTE_WH
	schedule='5 minute'
	as
select
  logs.ip_address,
  logs.user_login as GAMER_NAME,
  logs.user_event as GAME_EVENT_NAME,
  logs.datetime_iso8601 as GAME_EVENT_UTC,
  city,
  region,
  country,
  timezone as GAMER_LTZ_NAME,
  convert_timezone('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
  dayname(game_event_ltz) as dow_name,
  tod_lu.tod_name
from AGS_GAME_AUDIENCE.RAW.LOGS logs
  join IPINFO_GEOLOC.demo.location loc
  on ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
    and ipinfo_geoloc.public.to_int(logs.ip_address)
between start_ip_int and end_ip_int
  join ags_game_audience.raw.time_of_day_lu tod_lu
  on tod_lu.hour = hour(game_event_ltz);

  


-- UPDATE TASK
create or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
	warehouse=COMPUTE_WH
	schedule='5 minute'
	as 
    INSERT INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED 
    select 
      logs.ip_address,
      logs.user_login as GAMER_NAME,
      logs.user_event as GAME_EVENT_NAME,
      logs.datetime_iso8601 as GAME_EVENT_UTC,
      city,
      region,
      country,
      timezone as GAMER_LTZ_NAME,
      convert_timezone('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
      dayname(game_event_ltz) as dow_name,
      tod_lu.tod_name
    from AGS_GAME_AUDIENCE.RAW.LOGS logs
    join IPINFO_GEOLOC.demo.location loc
      on ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
      and ipinfo_geoloc.public.to_int(logs.ip_address)
    between start_ip_int and end_ip_int
    join ags_game_audience.raw.time_of_day_lu tod_lu
      on tod_lu.hour = hour(game_event_ltz);


--make a note of how many rows you have in the table
select count(*)
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--Run the task to load more rows
execute task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

--check to see how many rows were added
select count(*)
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;  -- 158


--first we dump all the rows out of the table
truncate table ags_game_audience.enhanced.LOGS_ENHANCED;

--then we put them all back in
INSERT INTO ags_game_audience.enhanced.LOGS_ENHANCED (
SELECT logs.ip_address 
, logs.user_login as GAMER_NAME
, logs.user_event as GAME_EVENT_NAME
, logs.datetime_iso8601 as GAME_EVENT_UTC
, city
, region
, country
, timezone as GAMER_LTZ_NAME
, CONVERT_TIMEZONE( 'UTC',timezone,logs.datetime_iso8601) as game_event_ltz
, DAYNAME(game_event_ltz) as DOW_NAME
, TOD_NAME
from ags_game_audience.raw.LOGS logs
JOIN ipinfo_geoloc.demo.location loc 
ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
AND ipinfo_geoloc.public.TO_INT(logs.ip_address) 
BETWEEN start_ip_int AND end_ip_int
JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod
ON HOUR(game_event_ltz) = tod.hour);

--we should do this every 5 minutes from now until the next millenium - Y3K!!!


--clone the table to save this version as a backup
--since it holds the records from the UPDATED FEED file, we'll name it _UF
create table ags_game_audience.enhanced.LOGS_ENHANCED_UF 
clone ags_game_audience.enhanced.LOGS_ENHANCED;


MERGE INTO ENHANCED.LOGS_ENHANCED e
USING RAW.LOGS r
ON r.user_login = e.GAMER_NAME
and r.datetime_iso8601 = e.game_event_utc 
and r.user_event = e.game_event_name
WHEN MATCHED THEN
UPDATE SET IP_ADDRESS = 'Hey I updated matching rows!';


/*
on r.user_login = e.gamer_name 
and r.datetime_iso8601 = e.game_event_utc 
and r.user_event = e.game_event_name
when matched then
Update set ip_address = 'Hey, I updated matching rows!'
*/


--let's truncate so we can start the load over again
-- remember we have that cloned back up so it's fine
truncate table AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;



-- SAMPLE
MERGE INTO ENHANCED.LOGS_ENHANCED e
USING -- RAW.LOGS r
ON r.user_login = e.GAMER_NAME
and r.datetime_iso8601 = e.game_event_utc 
and r.user_event = e.game_event_name;
--WHEN MATCHED THEN
--UPDATE SET IP_ADDRESS = 'Hey I updated matching rows!';




create or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
	warehouse=COMPUTE_WH
	schedule='5 minute'
	as 
    MERGE INTO ENHANCED.LOGS_ENHANCED e
    USING (
        SELECT logs.ip_address 
        , logs.user_login as GAMER_NAME
        , logs.user_event as GAME_EVENT_NAME
        , logs.datetime_iso8601 as GAME_EVENT_UTC
        , city
        , region
        , country
        , timezone as GAMER_LTZ_NAME
        , CONVERT_TIMEZONE( 'UTC',timezone,logs.datetime_iso8601) as game_event_ltz
        , DAYNAME(game_event_ltz) as DOW_NAME
        , TOD_NAME
        from ags_game_audience.raw.LOGS logs
        JOIN ipinfo_geoloc.demo.location loc 
        ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
        AND ipinfo_geoloc.public.TO_INT(logs.ip_address) 
        BETWEEN start_ip_int AND end_ip_int
        JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod
        ON HOUR(game_event_ltz) = tod.hour
    ) r
    ON r.user_login = e.GAMER_NAME
    and r.datetime_iso8601 = e.game_event_utc 
    and r.user_event = e.game_event_name
    WHEN NOT MATCHED THEN 
    INSERT (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME)
    VALUES
        (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME);



select count(*) from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;




--Testing cycle for MERGE. Use these commands to make sure the Merge works as expected

--Write down the number of records in your table 
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--Run the Merge a few times. No new rows should be added at this time 
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

--Check to see if your row count changed 
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--Insert a test record into your Raw Table 
--You can change the user_event field each time to create "new" records 
--editing the ip_address or datetime_iso8601 can complicate things more than they need to 
--editing the user_login will make it harder to remove the fake records after you finish testing 
INSERT INTO ags_game_audience.raw.game_logs 
select PARSE_JSON('{"datetime_iso8601":"2025-01-01 00:00:00.000", "ip_address":"196.197.196.255", "user_event":"fake event", "user_login":"fake user"}');

--After inserting a new row, run the Merge again 
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

--Check to see if any rows were added 
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--When you are confident your merge is working, you can delete the raw records 
delete from ags_game_audience.raw.game_logs where raw_log like '%fake user%';

--You should also delete the fake rows from the enhanced table
delete from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
where gamer_name = 'fake user';

--Row count should be back to what it was in the beginning
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED; 



list @AGS_GAME_AUDIENCE.RAW.uni_kishore_pipeline;


create or replace TABLE AGS_GAME_AUDIENCE.RAW.PIPELINE_LOGS (
	RAW_LOG VARIANT
);



COPY INTO AGS_GAME_AUDIENCE.RAW.PIPELINE_LOGS 
from FROM @ags_game_audience.raw.uni_kishore_pipeline
file_format = (format_name = FF_JSON_LOGS) 




create or replace view AGS_GAME_AUDIENCE.RAW.PL_LOGS(
	USER_EVENT,
	USER_LOGIN,
	DATETIME_ISO8601,
	IP_ADDRESS,
	RAW_LOG
) as 
select 
--RAW_LOG:agent::text as AGENT,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:user_login::text as USER_LOGIN,
RAW_LOG:datetime_iso8601::TIMESTAMP_NTZ as datetime_iso8601,
RAW_LOG:ip_address::text as IP_ADDRESS,
* 
from AGS_GAME_AUDIENCE.RAW.PIPELINE_LOGS
where RAW_LOG:ip_address::text is not null;


TRUNCATE TABLE  AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED; 

--Turning on a task is done with a RESUME command
alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES resume;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED resume;


--Keep this code handy for shutting down the tasks each day
alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES suspend;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED suspend;


select * from AGS_GAME_AUDIENCE.RAW.PIPELINE_LOGS;

select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;



-- Checking Tallies Along the Way
--Step 1 - how many files in the bucket?
list @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE;

--Step 2 - number of rows in raw table (should be file count x 10)
select count(*) from AGS_GAME_AUDIENCE.RAW.PIPELINE_LOGS;

--Step 3 - number of rows in raw table (should be file count x 10)
select count(*) from AGS_GAME_AUDIENCE.RAW.PL_LOGS;

--Step 4 - number of rows in enhanced table (should be file count x 10 but fewer rows is okay)
select count(*) from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;



-- Grant Serverless Task Management to SYSADMIN
use role accountadmin;
grant EXECUTE MANAGED TASK on account to SYSADMIN;

--switch back to sysadmin
use role sysadmin;

-- Replace the WAREHOUSE Property in Your Tasks
USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'

-- Replace or Update the SCHEDULE Property
--Change the SCHEDULE for GET_NEW_FILES so it runs more often
schedule='5 Minutes'

--Remove the SCHEDULE property and have LOAD_LOGS_ENHANCED run  
--each time GET_NEW_FILES completes
after AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES




 --A New Select with Metadata and Pre-Load JSON Parsing 
  SELECT 
    METADATA$FILENAME as log_file_name --new metadata column
  , METADATA$FILE_ROW_NUMBER as log_file_row_id --new metadata column
  , current_timestamp(0) as load_ltz --new local time of load
  , get($1,'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601
  , get($1,'user_event')::text as USER_EVENT
  , get($1,'user_login')::text as USER_LOGIN
  , get($1,'ip_address')::text as IP_ADDRESS    
  FROM @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
  (file_format => 'ff_json_logs');



CREATE TABLE AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS AS
SELECT 
    METADATA$FILENAME as log_file_name --new metadata column
  , METADATA$FILE_ROW_NUMBER as log_file_row_id --new metadata column
  , current_timestamp(0) as load_ltz --new local time of load
  , get($1,'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601
  , get($1,'user_event')::text as USER_EVENT
  , get($1,'user_login')::text as USER_LOGIN
  , get($1,'ip_address')::text as IP_ADDRESS    
  FROM @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
  (file_format => 'ff_json_logs');


  Select * from AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;



--truncate the table rows that were input during the CTAS
truncate table ED_PIPELINE_LOGS;

--reload the table using your COPY INTO
COPY INTO ED_PIPELINE_LOGS
FROM (
    SELECT 
    METADATA$FILENAME as log_file_name 
  , METADATA$FILE_ROW_NUMBER as log_file_row_id 
  , current_timestamp(0) as load_ltz 
  , get($1,'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601
  , get($1,'user_event')::text as USER_EVENT
  , get($1,'user_login')::text as USER_LOGIN
  , get($1,'ip_address')::text as IP_ADDRESS    
  FROM @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
)
file_format = (format_name = ff_json_logs);




--- EVENT DRIVEN PIPE LINE ---

CREATE OR REPLACE PIPE PIPE_GET_NEW_FILES
auto_ingest=true
aws_sns_topic='arn:aws:sns:us-west-2:321463406630:dngw_topic'
AS 
COPY INTO ED_PIPELINE_LOGS
FROM (
    SELECT 
    METADATA$FILENAME as log_file_name 
  , METADATA$FILE_ROW_NUMBER as log_file_row_id 
  , current_timestamp(0) as load_ltz 
  , get($1,'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601
  , get($1,'user_event')::text as USER_EVENT
  , get($1,'user_login')::text as USER_LOGIN
  , get($1,'ip_address')::text as IP_ADDRESS    
  FROM @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
)
file_format = (format_name = ff_json_logs);



-- Create a Stream
--create a stream that will keep track of changes to the table
create or replace stream ags_game_audience.raw.ed_cdc_stream 
on table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;

--look at the stream you created
show streams;

--check to see if any changes are pending
select system$stream_has_data('ed_cdc_stream');



--query the stream
select * 
from ags_game_audience.raw.ed_cdc_stream; 

--check to see if any changes are pending
select system$stream_has_data('ed_cdc_stream');

--if your stream remains empty for more than 10 minutes, make sure your PIPE is running
select SYSTEM$PIPE_STATUS('PIPE_GET_NEW_FILES');

--if you need to pause or unpause your pipe
--alter pipe PIPE_GET_NEW_FILES set pipe_execution_paused = true;
--alter pipe PIPE_GET_NEW_FILES set pipe_execution_paused = false;



-- Process the Rows from the Stream
--make a note of how many rows are in the stream
select * 
from ags_game_audience.raw.ed_cdc_stream;   --  0 rows

 
--process the stream by using the rows in a merge 
MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
USING (
        SELECT cdc.ip_address 
        , cdc.user_login as GAMER_NAME
        , cdc.user_event as GAME_EVENT_NAME
        , cdc.datetime_iso8601 as GAME_EVENT_UTC
        , city
        , region
        , country
        , timezone as GAMER_LTZ_NAME
        , CONVERT_TIMEZONE( 'UTC',timezone,cdc.datetime_iso8601) as game_event_ltz
        , DAYNAME(game_event_ltz) as DOW_NAME
        , TOD_NAME
        from ags_game_audience.raw.ed_cdc_stream cdc
        JOIN ipinfo_geoloc.demo.location loc 
        ON ipinfo_geoloc.public.TO_JOIN_KEY(cdc.ip_address) = loc.join_key
        AND ipinfo_geoloc.public.TO_INT(cdc.ip_address) 
        BETWEEN start_ip_int AND end_ip_int
        JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod
        ON HOUR(game_event_ltz) = tod.hour
      ) r
ON r.GAMER_NAME = e.GAMER_NAME
AND r.GAME_EVENT_UTC = e.GAME_EVENT_UTC
AND r.GAME_EVENT_NAME = e.GAME_EVENT_NAME 
WHEN NOT MATCHED THEN 
INSERT (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME)
        VALUES
        (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME);
 
--Did all the rows from the stream disappear? 
select * 
from ags_game_audience.raw.ed_cdc_stream; 



--- Create a CDC-Fueled, Time-Driven Task

--turn off the other task (we won't need it anymore)
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED suspend;


-- Needed Account Admin to create the task and assign ownership to sysadmin

--Create a new task that uses the MERGE you just tested
create or replace task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED
    USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE='XSMALL'
	SCHEDULE = '5 minutes'
WHEN
	system$stream_has_data('ed_cdc_stream')
	as 
MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
USING (
        SELECT cdc.ip_address 
        , cdc.user_login as GAMER_NAME
        , cdc.user_event as GAME_EVENT_NAME
        , cdc.datetime_iso8601 as GAME_EVENT_UTC
        , city
        , region
        , country
        , timezone as GAMER_LTZ_NAME
        , CONVERT_TIMEZONE( 'UTC',timezone,cdc.datetime_iso8601) as game_event_ltz
        , DAYNAME(game_event_ltz) as DOW_NAME
        , TOD_NAME
        from ags_game_audience.raw.ed_cdc_stream cdc
        JOIN ipinfo_geoloc.demo.location loc 
        ON ipinfo_geoloc.public.TO_JOIN_KEY(cdc.ip_address) = loc.join_key
        AND ipinfo_geoloc.public.TO_INT(cdc.ip_address) 
        BETWEEN start_ip_int AND end_ip_int
        JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod
        ON HOUR(game_event_ltz) = tod.hour
      ) r
ON r.GAMER_NAME = e.GAMER_NAME
AND r.GAME_EVENT_UTC = e.GAME_EVENT_UTC
AND r.GAME_EVENT_NAME = e.GAME_EVENT_NAME 
WHEN NOT MATCHED THEN 
INSERT (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME)
        VALUES
        (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME);
        

use role accountadmin;
grant EXECUTE MANAGED TASK on account to SYSADMIN;        
        
        
--Resume the task so it is running
alter task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED resume;
alter task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED suspend;

--alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED suspend;


select count(*) from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;


select count(*) from ags_game_audience.raw.ed_pipeline_logs;



-- Turn Things Off
-- If you have any tasks running, turn them off. 
-- If your pipe is running, you should pause it. Using something like:
alter pipe PIPE_GET_NEW_FILES set pipe_execution_paused = true;



CREATE SCHEMA AGS_GAME_AUDIENCE.CURATED;









