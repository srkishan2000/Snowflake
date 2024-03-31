list @ZENAS_ATHLEISURE_DB
.products.UNI_KLAUS_clothing;

list @ZENAS_ATHLEISURE_DB.products.UNI_KLAUS_SNEAKERS;

list @ZENAS_ATHLEISURE_DB.products.UNI_KLAUS_ZMD;

select $1
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd;

select $1
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/product_coordination_suggestions.txt;

create file format ZENAS_ATHLEISURE_DB.products.zmd_file_format_1
RECORD_DELIMITER = '^';


select $1
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/product_coordination_suggestions.txt
(file_format => zmd_file_format_1);



create file format ZENAS_ATHLEISURE_DB.products.zmd_file_format_2
FIELD_DELIMITER = '^';

select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
-- 11 and 12 are null
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/product_coordination_suggestions.txt
(file_format => zmd_file_format_2);


create file format ZENAS_ATHLEISURE_DB.products.zmd_file_format_3
FIELD_DELIMITER = '=' --'?'
RECORD_DELIMITER = '^'
--'?';


select $1, $2
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/product_coordination_suggestions.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_3);



CREATE or REPLACE file format ZENAS_ATHLEISURE_DB.products.zmd_file_format_1
RECORD_DELIMITER = ';';


select $1 as sizes_available
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/sweatsuit_sizes.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_1 );


CREATE or REPLACE file format ZENAS_ATHLEISURE_DB.products.zmd_file_format_2
FIELD_DELIMITER = '|', 
RECORD_DELIMITER = ';',
TRIM_SPACE = true;


select $1, $2, $3
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/swt_product_line.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_2);


select REPLACE($1,chr(13)||chr(10)) as sizes_available
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/sweatsuit_sizes.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_1 ) 
where sizes_available <> '';


create or replace view zenas_athleisure_db.products.sweatsuit_sizes as
select REPLACE($1,chr(13)||chr(10)) as sizes_available
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/sweatsuit_sizes.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_1 );


select *
from zenas_athleisure_db.products.sweatsuit_sizes;


create or replace view zenas_athleisure_db.products.SWEATBAND_PRODUCT_LINE as
select REPLACE($1,chr(13)||chr(10)) as PRODUCT_CODE, $2 as HEADBAND_DESCRIPTION, $3 as WRISTBAND_DESCRIPTION
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/swt_product_line.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_2 );


select *
from zenas_athleisure_db.products.SWEATBAND_PRODUCT_LINE;


CREATE or REPLACE VIEW zenas_athleisure_db.products.SWEATBAND_COORDINATION as
select REPLACE($1,chr(13)||chr(11)) as PRODUCT_CODE, $2 as HAS_MATCHING_SWEATSUIT
from @ZENAS_ATHLEISURE_DB.products.uni_klaus_zmd/product_coordination_suggestions.txt
(file_format => ZENAS_ATHLEISURE_DB.products.zmd_file_format_3);


select *
from zenas_athleisure_db.products.SWEATBAND_COORDINATION


select $1
from @uni_klaus_clothing
/90s_tracksuit.png;

select metadata$filename, metadata$file_row_number
from @uni_klaus_clothing
/90s_tracksuit.png;

select metadata$filename, count(metadata$file_row_number) as "Numbber_Of_Rows"
from @uni_klaus_clothing
/90s_tracksuit.png
group by metadata$filename;




--Directory Tables
select *
from directory(@uni_klaus_clothing);

-- Oh Yeah! We have to turn them on, first
alter stage uni_klaus_clothing
set directory
=
(enable = true);

--Now?
select *
from directory(@uni_klaus_clothing);

--Oh Yeah! Then we have to refresh the directory table!
alter stage uni_klaus_clothing refresh;

--Now?
select *
from directory(@uni_klaus_clothing);


--testing UPPER and REPLACE functions on directory table
select UPPER(RELATIVE_PATH) as uppercase_filename
, REPLACE(uppercase_filename,'/') as no_slash_filename
, REPLACE(no_slash_filename,'_',' ') as no_underscores_filename
, REPLACE(no_underscores_filename,'.PNG') as just_words_filename
from directory(@uni_klaus_clothing);




--testing UPPER and REPLACE functions on directory table
select UPPER(RELATIVE_PATH) as uppercase_filename
, REPLACE(uppercase_filename,'/') as no_slash_filename
, REPLACE(no_slash_filename,'_',' ') as no_underscores_filename
, REPLACE(no_underscores_filename,'.PNG') as just_words_filename
from directory(@uni_klaus_clothing);


-- nesting functions
select REPLACE(REPLACE(REPLACE(UPPER(RELATIVE_PATH),'/'),'_',' '),'.PNG') as PRODUCT_NAME
from directory(@uni_klaus_clothing);



--create an internal table for some sweat suit info
create or replace TABLE ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS
(
	COLOR_OR_STYLE VARCHAR
(25),
	DIRECT_URL VARCHAR
(200),
	PRICE NUMBER
(5,2)
);

--fill the new table with some data
insert into  ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS
    (COLOR_OR_STYLE, DIRECT_URL, PRICE)
values
    ('90s', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/90s_tracksuit.png', 500)
,
    ('Burgundy', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/burgundy_sweatsuit.png', 65)
,
    ('Charcoal Grey', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/charcoal_grey_sweatsuit.png', 65)
,
    ('Forest Green', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/forest_green_sweatsuit.png', 65)
,
    ('Navy Blue', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/navy_blue_sweatsuit.png', 65)
,
    ('Orange', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/orange_sweatsuit.png', 65)
,
    ('Pink', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/pink_sweatsuit.png', 65)
,
    ('Purple', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/purple_sweatsuit.png', 65)
,
    ('Red', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/red_sweatsuit.png', 65)
,
    ('Royal Blue', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/royal_blue_sweatsuit.png', 65)
,
    ('Yellow', 'https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/yellow_sweatsuit.png', 65);




select *
from directory(@uni_klaus_clothing);

-- RELATIVE_PATH	SIZE	LAST_MODIFIED	MD5	ETAG	FILE_URL

-- /yellow_sweatsuit.png	337801	2022-05-25 17:25:46.000 -0700	b605e2e5a1d22492df6381d9d95b3b7c	b605e2e5a1d22492df6381d9d95b3b7c	https://pv27820.ca-central-1.aws.snowflakecomputing.com/api/files/ZENAS_ATHLEISURE_DB/PRODUCTS/UNI_KLAUS_CLOTHING/%2fyellow_sweatsuit%2epng

select *
from ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS;

-- COLOR_OR_STYLE	DIRECT_URL	PRICE

-- Yellow	https://uni-klaus.s3.us-west-2.amazonaws.com/clothing/yellow_sweatsuit.png	65.00



-- Add the cross join
-- 3 way join - internal table, directory table, and view based on external data
select color_or_style
, direct_url
, price
, size as image_size
, last_modified as image_last_modified
, sizes_available
from sweatsuits
    join directory(@uni_klaus_clothing)
    on relative_path = SUBSTR(direct_url,54,50)
cross join sweatsuit_sizes;



CREATE or REPLACE VIEW ZENAS_ATHLEISURE_DB.PRODUCTS.CATALOG as
select color_or_style
, direct_url
, price
, size as image_size
, last_modified as image_last_modified
, sizes_available
from sweatsuits
    join directory(@uni_klaus_clothing)
    on relative_path = SUBSTR(direct_url,54,50)
cross join sweatsuit_sizes
where SIZES_AVAILABLE <> '';




-- Add a table to map the sweat suits to the sweat band sets
create table ZENAS_ATHLEISURE_DB.PRODUCTS.UPSELL_MAPPING
(
    SWEATSUIT_COLOR_OR_STYLE varchar(25)
,
    UPSELL_PRODUCT_CODE varchar(10)
);

--populate the upsell table
insert into ZENAS_ATHLEISURE_DB.PRODUCTS.UPSELL_MAPPING
    (
    SWEATSUIT_COLOR_OR_STYLE
    ,UPSELL_PRODUCT_CODE
    )
VALUES
    ('Charcoal Grey', 'SWT_GRY')
,
    ('Forest Green', 'SWT_FGN')
,
    ('Orange', 'SWT_ORG')
,
    ('Pink', 'SWT_PNK')
,
    ('Red', 'SWT_RED')
,
    ('Yellow', 'SWT_YLW');




-- Zena needs a single view she can query for her website prototype
create view ZENAS_ATHLEISURE_DB.PRODUCTS.catalog_for_website
as
    select color_or_style
, price
, direct_url
, size_list
, coalesce('BONUS: ' ||  headband_description || ' & ' || wristband_description, 'Consider White, Black or Grey Sweat Accessories')  as upsell_product_desc
    from
        (   select color_or_style, price, direct_url, image_last_modified, image_size
    , listagg(sizes_available, ' | ') within group (order by sizes_available) as size_list
        from catalog
        group by color_or_style, price, direct_url, image_last_modified, image_size
) c
        left join upsell_mapping u
        on u.sweatsuit_color_or_style = c.color_or_style
        left join sweatband_coordination sc
        on sc.product_code = u.upsell_product_code
        left join sweatband_product_line spl
        on spl.product_code = sc.product_code
    where price < 200 -- high priced items like vintage sweatsuits aren't a good fit for this website
        and image_size < 1000000
-- large images need to be processed to a smaller size
;


select *
from ZENAS_ATHLEISURE_DB.PRODUCTS.catalog_for_website;




CREATE DATABASE 
MELS_SMOOTHIE_CHALLENGE_DB;

DROP SCHEMA MELS_SMOOTHIE_CHALLENGE_DB
.PUBLIC;

CREATE SCHEMA MELS_SMOOTHIE_CHALLENGE_DB
.TRAILS;

list @trails_geojson;

list @TRAILS_PARQUET;


select $1
from @TRAILS_PARQUET
(file_format => ff_parquet);


{
  "elevation": 1.579900000000000e+03,
  "latitude": -1.050083600000000e+02,
  "longitude": 3.975430990000000e+01,
  "sequence_1": 1,
  "sequence_2": 3526,
  "trail_name": "Cherry Creek Trail"
}


select
    $1
:sequence_1 as sequence_1,
    $1:trail_name::varchar as trail_name,
    $1:latitude as latitude,
    $1:longitude as longitude,
    $1:sequence_2 as sequence_2,
    $1:elevation as elevation
from @TRAILS_PARQUET
(file_format => ff_parquet)
order by sequence_1;


select
    $1
:sequence_1 as point_id,
    $1:trail_name::varchar as trail_name,
    $1:latitude::number
(11,8) as lng,
    $1:longitude::number
(11,8) as lat
from @TRAILS_PARQUET
(file_format => ff_parquet)
order by point_id;



CREATE VIEW MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.CHERRY_CREEK_TRAIL
as
    select
        $1
:sequence_1 as point_id,
    $1:trail_name::varchar as trail_name,
    $1:latitude::number
(11,8) as lng,
    $1:longitude::number
(11,8) as lat
from @TRAILS_PARQUET
(file_format => ff_parquet)
order by point_id;


select *
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.CHERRY_CREEK_TRAIL;


--Using concatenate to prepare the data for plotting on a map
select top 100
    lng||' '||lat as coord_pair
, 'POINT('||coord_pair||')' as trail_point
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.cherry_creek_trail;


--To add a column, we have to replace the entire view
--changes to the original are shown in red
create or replace view MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.cherry_creek_trail as
select
    $1
:sequence_1 as point_id,
 $1:trail_name::varchar as trail_name,
 $1:latitude::number
(11,8) as lng,
 $1:longitude::number
(11,8) as lat,
 lng||' '||lat as coord_pair
from @trails_parquet
(file_format => ff_parquet)
order by point_id;


select
    'LINESTRING('||
listagg(coord_pair, ',') 
within group (order by point_id)
||')' as my_linestring
from cherry_creek_trail
where point_id <= 10
group by trail_name;


-- Normalize the data
select
    $1
:features[0]:
properties:
Name::string as feature_name
,$1:features[0]:
geometry:
coordinates::string as feature_coordinates
,$1:features[0]:geometry::string as geometry
,$1:features[0]:properties::string as feature_properties
,$1:
crs:
properties:
name::string as specs
,$1 as whole_object
from @trails_geojson
(file_format => ff_json);


CREATE VIEW DENVER_AREA_TRAILS
as
    select
        $1
:features[0]:
properties:
Name::string as feature_name
,$1:features[0]:
geometry:
coordinates::string as feature_coordinates
,$1:features[0]:geometry::string as geometry
,$1:features[0]:properties::string as feature_properties
,$1:
crs:
properties:
name::string as specs
,$1 as whole_object
from @trails_geojson
(file_format => ff_json);


--Remember this code? 
select
    TO_GEOGRAPHY('LINESTRING('||
listagg(coord_pair, ',') 
within group (order by point_id)
||')') as my_linestring
, st_length(my_linestring) as length_of_trail
--this line is new! but it won't work!
from cherry_creek_trail
group by trail_name;



select get_ddl('view', 'DENVER_AREA_TRAILS');



-- Needs attention on trail_length ????
create or replace view DENVER_AREA_TRAILS
( 
    FEATURE_NAME, 
    FEATURE_COORDINATES, 
    GEOMETRY, 
    TRAIL_LENGTH,
    FEATURE_PROPERTIES, 
    SPECS, 
    WHOLE_OBJECT ) as
select
    $1
:features[0]:
properties:
Name::string as feature_name ,
    $1:features[0]:
geometry:
coordinates::string as feature_coordinates ,
    $1:features[0]:geometry::string as geometry ,
    st_length
(to_geography
(geometry)) as trial_length , 
    $1:features[0]:properties::string as feature_properties ,
    $1:
crs:
properties:
name::string as specs ,
    $1 as whole_object 
from @trails_geojson
(file_format => ff_json);




--Create a view that will have similar columns to DENVER_AREA_TRAILS 
--Even though this data started out as Parquet, and we're joining it with geoJSON data
--So let's make it look like geoJSON instead.
CREATE or REPLACE view DENVER_AREA_TRAILS_2 as
select
    trail_name as feature_name
, '{"coordinates":['||listagg('['||lng||','||lat||']',',')||'],"type":"LineString"}' as geometry
, st_length(to_geography(geometry)) as trail_length
from cherry_creek_trail
group by trail_name;




--Create a view that will have similar columns to DENVER_AREA_TRAILS 
    select feature_name, geometry, trail_length
    from DENVER_AREA_TRAILS
union all
    select feature_name, geometry, trail_length
    from DENVER_AREA_TRAILS_2;


select *
from DENVER_AREA_TRAILS



--Create a view that will have similar columns to DENVER_AREA_TRAILS 
--Even though this data started out as Parquet, and we're joining it with geoJSON data
--So let's make it look like geoJSON instead.
create or REPLACE view DENVER_AREA_TRAILS_2 as
select
    trail_name as feature_name
, '{"coordinates":['||listagg('['||lng||','||lat||']',',')||'],"type":"LineString"}' as geometry
, st_length(to_geography(geometry)) as trail_length
from cherry_creek_trail
group by trail_name;



--Create a view that will have similar columns to DENVER_AREA_TRAILS 
    select feature_name, geometry, trail_length
    from DENVER_AREA_TRAILS
union all
    select feature_name, geometry, trail_length
    from DENVER_AREA_TRAILS_2;



--Add more GeoSpatial Calculations to get more GeoSpecial Information! 
    select feature_name
, to_geography(geometry) as my_linestring
, st_xmin(my_linestring) as min_eastwest
, st_xmax(my_linestring) as max_eastwest
, st_ymin(my_linestring) as min_northsouth
, st_ymax(my_linestring) as max_northsouth
, trail_length
    from DENVER_AREA_TRAILS
union all
    select feature_name
, to_geography(geometry) as my_linestring
, st_xmin(my_linestring) as min_eastwest
, st_xmax(my_linestring) as max_eastwest
, st_ymin(my_linestring) as min_northsouth
, st_ymax(my_linestring) as max_northsouth
, trail_length
    from DENVER_AREA_TRAILS_2;



CREATE or REPLACE VIEW TRAILS_AND_BOUNDARIES AS
--Add more GeoSpatial Calculations to get more GeoSpecial Information! 
    select feature_name
, to_geography(geometry) as my_linestring
, st_xmin(my_linestring) as min_eastwest
, st_xmax(my_linestring) as max_eastwest
, st_ymin(my_linestring) as min_northsouth
, st_ymax(my_linestring) as max_northsouth
, trail_length
    from DENVER_AREA_TRAILS
union all
    select feature_name
, to_geography(geometry) as my_linestring
, st_xmin(my_linestring) as min_eastwest
, st_xmax(my_linestring) as max_eastwest
, st_ymin(my_linestring) as min_northsouth
, st_ymax(my_linestring) as max_northsouth
, trail_length
    from DENVER_AREA_TRAILS_2;



select *
from TRAILS_AND_BOUNDARIES;



select
    min(min_eastwest) as WESTERN_EDGE,
    min(min_northsouth) as SOUTHERN_EDGE,
    max(max_eastwest) as EASTERN_EDGE,
    max(max_northsouth) as NORTHERN_EDGE
from TRAILS_AND_BOUNDARIES;



select 'POLYGON(('||
    min(min_eastwest)||' '||max(max_northsouth)||','||
    max(max_eastwest)||' '||max(max_northsouth)||','||
    max(max_eastwest)||' '||min(min_northsouth)||','||
    min(min_eastwest)||' '||max(max_northsouth)||'))' as my_polygon
from TRAILS_AND_BOUNDARIES;



-- make sure to change the schema to MELS Location and follow the SQL

Using Variables in Snowflake Worksheets
-- Melanie's Location into a 2 Variables (mc for melanies cafe)
set mc_lat
='-104.97300245114094';
set mc_lng
='39.76471253574085';

--Confluence Park into a Variable (loc for location)
set loc_lat
='-105.00840763333615';
set loc_lng
='39.754141917497826';

--Test your variables to see if they work with the Makepoint function
select st_makepoint($mc_lat,$mc_lng) as melanies_cafe_point;
select st_makepoint($loc_lat,$loc_lng) as confluent_park_point;

--use the variables to calculate the distance from 
--Melanie's Cafe to Confluent Park
select st_distance(
        st_makepoint($mc_lat,$mc_lng)
        ,st_makepoint($loc_lat,$loc_lng)
        ) as mc_to_cp;


CREATE FUNCTION distance_to_mc(loc_lat number(38,32), loc_lng number
(38,32))
  RETURNS FLOAT
  AS
  $$
   st_distance
(
        st_makepoint
('-104.97300245114094','39.76471253574085')
        ,st_makepoint
(loc_lat,loc_lng)
        )
  $$
  ;


--Tivoli Center into the variables 
set tc_lat
='-105.00532059763648';
set tc_lng
='39.74548137398218';

select distance_to_mc($tc_lat,$tc_lng);



CREATE OR REPLACE VIEW COMPETITION AS
select *
from SONRA_DENVER_CO_USA_FREE.DENVER.V_OSM_DEN_AMENITY_SUSTENANCE
where 
    ((amenity in ('fast_food','cafe','restaurant','juice_bar'))
    and
    (name
ilike '%jamba%' or name ilike '%juice%'
     or name ilike '%superfruit%'))
 or
(cuisine like '%smoothie%' or cuisine like '%juice%');




SELECT
    name
 , cuisine
 , ST_DISTANCE(
    st_makepoint('-104.97300245114094','39.76471253574085')
    , coordinates
  ) AS distance_from_melanies
 , *
FROM competition
ORDER by distance_from_melanies;



CREATE OR REPLACE FUNCTION distance_to_mc
(lat_and_lng GEOGRAPHY)
  RETURNS FLOAT
  AS
  $$
   st_distance
(
        st_makepoint
('-104.97300245114094','39.76471253574085')
        ,lat_and_lng
        )
  $$
  ;



SELECT
    name
 , cuisine
 , distance_to_mc(coordinates) AS distance_from_melanies
 , *
FROM competition
ORDER by distance_from_melanies;


-- Different Options, Same Outcome!
-- Tattered Cover Bookstore McGregor Square
set tcb_lat
='-104.9956203';
set tcb_lng
='39.754874';

--this will run the first version of the UDF
select distance_to_mc($tcb_lat,$tcb_lng);

--this will run the second version of the UDF, bc it converts the coords 
--to a geography object before passing them into the function
select distance_to_mc(st_makepoint($tcb_lat,$tcb_lng));

--this will run the second version bc the Sonra Coordinates column
-- contains geography objects already
select name
, distance_to_mc(coordinates) as distance_to_melanies 
, ST_ASWKT(coordinates)
from SONRA_DENVER_CO_USA_FREE.DENVER.V_OSM_DEN_SHOP
where shop='books'
    and name like '%Tattered Cover%'
    and addr_street like '%Wazee%';



-- chage to 'SONRA_DENVER_CO_USA_FREE.DENVER' and SYSADMIN 

select *
from V_OSM_DEN_SHOP_OUTDOORS_AND_SPORT_VEHICLES
where shop = 'bicycle';

select *
from SONRA_DENVER_CO_USA_FREE.DENVER.V_OSM_DEN_SHOP
where shop = 'bicycle' and ADDR_CITY in ('Denver');

select id, name,
    distance_to_mc(coordinates) as distance_to_melanies
from SONRA_DENVER_CO_USA_FREE.DENVER.V_OSM_DEN_SHOP
where shop = 'bicycle' and ADDR_CITY in ('Denver') and distance_to_melanies like '2490%';


CREATE or REPLACE VIEW mels_smoothie_challenge_db.locations.DENVER_BIKE_SHOPS AS
select id, name,
    distance_to_mc(coordinates) as distance_to_melanies
from SONRA_DENVER_CO_USA_FREE.DENVER.V_OSM_DEN_SHOP
where shop = 'bicycle';


-- rename a view example
-- ALTER VIEW greater10k_sal_emps rename to Above10K_Sal_Emps;

ALTER VIEW mels_smoothie_challenge_db.trails.CHERRY_CREEK_TRAIL rename to mels_smoothie_challenge_db.trails.V_CHERRY_CREEK_TRAIL;



create or replace external table mels_smoothie_challenge_db.trails.T_CHERRY_CREEK_TRAIL
(
	my_filename varchar
(50) as
(metadata$filename::varchar
(50))
) 
location= @mels_smoothie_challenge_db.trails.trails_parquet
auto_refresh = true
file_format =
(type = parquet);


select get_ddl('view','mels_smoothie_challenge_db.trails.v_cherry_creek_trail');


create or replace view V_CHERRY_CREEK_TRAIL
(
	POINT_ID,
	TRAIL_NAME,
	LNG,
	LAT,
	COORD_PAIR
) as
select
    $1
:sequence_1 as point_id,
 $1:trail_name::varchar as trail_name,
 $1:latitude::number
(11,8) as lng,
 $1:longitude::number
(11,8) as lat,
 lng||' '||lat as coord_pair
from @trails_parquet
(file_format => ff_parquet)
order by point_id;



create or replace external table mels_smoothie_challenge_db.trails.T_CHERRY_CREEK_TRAIL
(
	POINT_ID number as
($1:sequence_1::number),
	TRAIL_NAME varchar
(50) as
($1:trail_name::varchar),
	LNG number
(11,8) as
($1:latitude::number
(11,8)),
	LAT number
(11,8) as
($1:longitude::number
(11,8)),
	COORD_PAIR varchar
(50) as
(lng::varchar||' '||lat::varchar)
) 
location= @mels_smoothie_challenge_db.trails.trails_parquet
auto_refresh = true
file_format = mels_smoothie_challenge_db.trails.ff_parquet;


select count(*)
from mels_smoothie_challenge_db.trails.T_CHERRY_CREEK_TRAIL;
