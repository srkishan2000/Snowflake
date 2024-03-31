-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description
) as graded_results from
( SELECT
    'DORA_IS_WORKING' as step
 , (select 223) as actual
 , 223 as expected
 , 'Dora is working!' as description
);


-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DABW001' as step
 , ( select count(*)
    from SMOOTHIES.PUBLIC.FRUIT_OPTIONS) as actual
 , 25 as expected
 , 'Fruit Options table looks good' as description
);


-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE

select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
SELECT 'DABW002' as step
 , (select IFF(count(*)>=5,5,0)
    from (select ingredients
        from smoothies.public.orders
        group by ingredients)
 ) as actual
 , 5 as expected
 , 'At least 5 different orders entered' as description
);


-- Set your worksheet drop lists

-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DABW003' as step
 , (select ascii(fruit_name)
    from smoothies.public.fruit_options
    where fruit_name ilike
'z%') as actual
 , 90 as expected
 ,'A mystery check for the inquisitive' as description
);


-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DABW004' as step
 , ( select count(*)
    from smoothies.information_schema.columns
    where table_schema = 'PUBLIC'
        and table_name = 'ORDERS'
        and column_name = 'ORDER_FILLED'
        and column_default = 'FALSE'
        and data_type = 'BOOLEAN') as actual
 , 1 as expected
 , 'Order Filled is Boolean' as description
);


-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DABW005' as step
 , (select count(*)
    from SMOOTHIES.INFORMATION_SCHEMA.STAGES
    where stage_name like '%(Stage)') as actual
 , 2 as expected
 , 'There seem to be 2 SiS Apps' as description
);




-- Set your worksheet drop lists

-- Set these local variables according to the instructions
set this
= -10.5;
set that
= 2;
set the_other
= 1000;

-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
  SELECT 'DABW006' as step
 , ( select util_db.public.sum_mystery_bag_vars($this,$that,$the_other)) as actual
 , 991.5 as expected
 , 'Mystery Bag Function Output' as description
);


-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
 SELECT 'DABW007' as step
 , ( select hash(neutralize_whining('bUt mOm i wAsHeD tHe dIsHes yEsTeRdAy'))) as actual
 , -4759027801154767056 as expected
 , 'WHINGE UDF Works' as description
);


-- Set your worksheet drop lists
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description
) as graded_results from
(
   SELECT 'DABW008' as step 
   , ( select sum(hash_ing)
    from
        (select hash(ingredients) as hash_ing
        from smoothies.public.orders
        where order_ts is not null
            and name_on_order is not null
            and (name_on_order = 'Kevin' and order_filled = FALSE and hash_ing = 7976616299844859825)
            or (name_on_order ='Divya' and order_filled = TRUE and hash_ing = -6112358379204300652)
            or (name_on_order ='Xi' and order_filled = TRUE and hash_ing = 1016924841131818535))
     ) as actual 
   , 2881182761772377708 as expected 
   , 'Followed challenge lab directions' as description
); 


