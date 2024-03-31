-- LESSON 1

COPY INTO "SMOOTHIES"."PUBLIC"."FRUIT_OPTIONS"
FROM '@SMOOTHIES.PUBLIC.my_internal_stage'
FILES = ('fruits_available_for_smoothies.txt')
FILE_FORMAT = ( format_name = 'SMOOTHIES.PUBLIC.TWO_HEADERROW_PCT_DELIM' )
ON_ERROR=ABORT_STATEMENT
VALIDATION_MODE=RETURN_ERRORS 
PURGE=TRUE;

CREATE FILE FORMAT SMOOTHIES.PUBLIC.TWO_HEADERROW_PCT_DELIM
    TYPE=CSV,
    SKIP_HEADER=2,
    FIELD_DELIMITER='%',
    TRIM_SPACE=FALSE,
    FIELD_OPTIONALLY_ENCLOSED_BY=NONE,
    REPLACE_INVALID_CHARACTERS=TRUE,
    DATE_FORMAT=AUTO,
    TIME_FORMAT=AUTO,
    TIMESTAMP_FORMAT=AUTO
;


SELECT $1, $2 
FROM '@SMOOTHIES.PUBLIC.my_internal_stage/fruits_available_for_smoothies.txt'
(FILE_FORMAT => 'SMOOTHIES.PUBLIC.TWO_HEADERROW_PCT_DELIM');



COPY INTO "SMOOTHIES"."PUBLIC"."FRUIT_OPTIONS"
FROM (SELECT $2 as FRUIT_ID, $1 as FRUIT_NAME 
FROM '@SMOOTHIES.PUBLIC.my_internal_stage/fruits_available_for_smoothies.txt')
FILE_FORMAT = ( format_name = 'SMOOTHIES.PUBLIC.TWO_HEADERROW_PCT_DELIM' )
ON_ERROR=ABORT_STATEMENT  
PURGE=TRUE;


create table smoothies.public.ORDERS (
    INGREDIENTS varchar(200)
);


select * from smoothies.public.ORDERS;

alter table smoothies.public.ORDERS add column NAME_ON_ORDER varchar(100);

alter table smoothies.public.ORDERS add column ORDER_FILLED BOOLEAN DEFAULT FALSE;


update smoothies.public.orders
       set order_filled = true
       where name_on_order is null;



truncate table SMOOTHIES.PUBLIC.ORDERS;

alter table SMOOTHIES.PUBLIC.ORDERS 
add column order_uid integer --adds the column
default smoothies.public.order_seq.nextval  --sets the value of the column to sequence
constraint order_uid unique enforced; --makes sure there is always a unique value in the column;



create or replace table smoothies.public.orders (
       order_uid number(38,0) default smoothies.public.order_seq.nextval,
       order_filled boolean default false,
       name_on_order varchar(100),
       ingredients varchar(200),
       order_ts timestamp_ltz(9) default current_timestamp(),
       constraint order_uid unique (order_uid)
);


create function util_db.public.sum_mystery_bag_vars(var1 number, var2 number, var3 number)
    returns number as 'select var1 + var2 + var3';

select util_db.public.sum_mystery_bag_vars(12, 36, 204);


create function util_db.public.NEUTRALIZE_WHINING(var text)
    returns text as 'select INITCAP(var)';

select util_db.public.NEUTRALIZE_WHINING('shanmuga sundaram');


alter table smoothies.public.fruit_options 
add SEARCH_ON varchar(25);


update smoothies.public.fruit_options set search_on = fruit_name; 


update smoothies.public.fruit_options set search_on = 'Blueberry' where fruit_name = 'Blueberries';


select hash(Fruit_name) as hash_ing from smoothies.public.fruit_options;

select * from smoothies.public.orders where name_on_order = 'Kevin';

update smoothies.public.orders set INGREDIENTS = 'Apples Lime Ximenia' where NAME_ON_ORDER = 'Kevin';


update smoothies.public.orders set INGREDIENTS = 'Dragon Fruit Guava Figs Jackfruit Blueberries' where NAME_ON_ORDER = 'Divya';


update smoothies.public.orders set INGREDIENTS = 'Vanilla Fruit Nectarine' where NAME_ON_ORDER = 'Xi';


select hash(INGREDIENTS) as hash_ing from smoothies.public.orders;SMOOTHIES.PUBLIC.ORDERS