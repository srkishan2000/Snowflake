-- use role sysadmin;

//
Create a new database and
set the context
to
use the
new database
CREATE DATABASE LIBRARY_CARD_CATALOG
COMMENT = 'DWW Lesson 9 ';
USE DATABASE LIBRARY_CARD_CATALOG;

//
Create Author table
CREATE OR REPLACE TABLE AUTHOR
(
   AUTHOR_UID NUMBER 
  ,FIRST_NAME VARCHAR
(50)
  ,MIDDLE_NAME VARCHAR
(50)
  ,LAST_NAME VARCHAR
(50)
);

//
Insert the
first two authors into the
Author
table
INSERT INTO AUTHOR
    (AUTHOR_UID,FIRST_NAME,MIDDLE_NAME, LAST_NAME)
Values
    (1, 'Fiona', '', 'Macdonald')
,
    (2, 'Gian', 'Paulo', 'Faleschini');

// Look at your table
with it's new rows
SELECT * 
FROM AUTHOR;





create sequence SEQ_AUTHOR_UID
    start = 1
    increment = 1
    comment = '
Use this
to fill in Author_UID';


-- use role sysadmin;

//See how the nextval function works
SELECT SEQ_AUTHOR_UID.nextval;

SELECT SEQ_AUTHOR_UID.nextval, SEQ_AUTHOR_UID.nextval;


SHOW sequences;




-- use role sysadmin;

//Drop and recreate the counter (sequence) so that it starts at 3 
// then we'll
add the other author records to our author table
CREATE OR REPLACE SEQUENCE "LIBRARY_CARD_CATALOG"."PUBLIC"."SEQ_AUTHOR_UID" 
START 3 
INCREMENT 1 
COMMENT = 'Use this to fill in the AUTHOR_UID every time you add a row';

//
Add the remaining author records and
use the
nextval function instead 
//of putting in the numbers
INSERT INTO AUTHOR
    (AUTHOR_UID,FIRST_NAME,MIDDLE_NAME, LAST_NAME)
Values
    (SEQ_AUTHOR_UID.nextval, 'Laura', 'K', 'Egendorf')
    ,
    (SEQ_AUTHOR_UID.nextval, 'Jan', '', 'Grover')
    ,
    (SEQ_AUTHOR_UID.nextval, 'Jennifer', '', 'Clapp')
    ,
    (SEQ_AUTHOR_UID.nextval, 'Kathleen', '', 'Petelinsek');





----------------

USE DATABASE LIBRARY_CARD_CATALOG;

//
Create a new sequence, this one will be a counter for the book table
CREATE OR REPLACE SEQUENCE "LIBRARY_CARD_CATALOG"."PUBLIC"."SEQ_BOOK_UID" 
START 1 
INCREMENT 1 
COMMENT = 'Use this to fill in the BOOK_UID everytime you add a row';

//
Create the book table and
use the
NEXTVAL as the 
// default value each time a row is added to the table
CREATE OR REPLACE TABLE BOOK
( BOOK_UID NUMBER DEFAULT SEQ_BOOK_UID.nextval
 ,TITLE VARCHAR
(50)
 ,YEAR_PUBLISHED NUMBER
(4,0)
);

//
Insert records
into the book table
// You don't have to list anything for the
// BOOK_UID field because the default setting
// will take care of it for you
INSERT INTO BOOK(TITLE,YEAR_PUBLISHED)
VALUES
 ('Food',2001)
,('Food',2006)
,('Food',2008)
,('Food',2016)
,('Food',2015);

// Create the relationships table
// this is sometimes called a "Many-to-Many table"
CREATE TABLE BOOK_TO_AUTHOR
(  BOOK_UID NUMBER
  ,AUTHOR_UID NUMBER
);

//Insert rows of the known relationships
INSERT INTO BOOK_TO_AUTHOR(BOOK_UID,AUTHOR_UID)
VALUES
 (1,1)  // This row links the 2001 book to Fiona Macdonald
,(1,2)  // This row links the 2001 book to Gian Paulo Faleschini
,(2,3)  // Links 2006 book to Laura K Egendorf
,(3,4)  // Links 2008 book to Jan Grover
,(4,5)  // Links 2016 book to Jennifer Clapp
,(5,6); // Links 2015 book to Kathleen Petelinsek


//Check your work by joining the 3 tables together
//You should get 1 row for every author
select * 
from book_to_author ba 
join author a 
on ba.author_uid = a.author_uid 
join book b 
on b.book_uid=ba.book_uid; 


--- JSON ----

// JSON DDL Scripts
USE LIBRARY_CARD_CATALOG;

// Create an Ingestion Table for JSON Data
CREATE TABLE LIBRARY_CARD_CATALOG.PUBLIC.AUTHOR_INGEST_JSON 
(
  RAW_AUTHOR VARIANT
);



//Create File Format for JSON Data
CREATE FILE FORMAT LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT 
TYPE = 'JSON' 
COMPRESSION = 'AUTO' 
ENABLE_OCTAL = FALSE
ALLOW_DUPLICATE = FALSE 
STRIP_OUTER_ARRAY = TRUE
STRIP_NULL_VALUES = FALSE 
IGNORE_UTF8_ERRORS = FALSE;



copy into LIBRARY_CARD_CATALOG.PUBLIC.AUTHOR_INGEST_JSON
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'author_with_header.json' )
file_format = ( format_name=LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT );


SELECT * FROM AUTHOR_INGEST_JSON;


//returns AUTHOR_UID value from top-level object's attribute
select
raw_author:
AUTHOR_UID
from author_ingest_json;

//returns the data in a way that makes it look like a normalized table
SELECT
raw_author:
AUTHOR_UID
,
raw_author:
FIRST_NAME::STRING as FIRST_NAME
,
raw_author:
MIDDLE_NAME::STRING as MIDDLE_NAME
,
raw_author:
LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;



--- ****** ---

//
Create an Ingestion Table for the NESTED JSON Data
CREATE OR REPLACE TABLE LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
(
  "RAW_NESTED_BOOK" VARIANT
);






copy into LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
from @util_db.public.like_a_window_into_an_s3_bucket
files =
( 'json_book_author_nested.json' )
file_format =
( format_name=LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT );





//a few simple queries
SELECT RAW_NESTED_BOOK
FROM NESTED_INGEST_JSON;

SELECT
RAW_NESTED_BOOK:
year_published
FROM NESTED_INGEST_JSON;

SELECT
RAW_NESTED_BOOK:
authors
FROM NESTED_INGEST_JSON;

//
Use these
example flatten commands to explore flattening the nested book and author data
SELECT
value:
first_name
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN
(input =>
RAW_NESTED_BOOK:
authors);

SELECT
value:
first_name
FROM NESTED_INGEST_JSON
,table
(flatten
(
RAW_NESTED_BOOK:
authors));

//
Add a CAST command to the fields returned
SELECT
value:
first_name::VARCHAR,
value:
last_name::VARCHAR
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN
(input =>
RAW_NESTED_BOOK:
authors);

//Assign new column  names to the columns using "AS"
SELECT
value:
first_name::VARCHAR AS FIRST_NM
,
value:
last_name::VARCHAR AS LAST_NM
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN
(input =>
RAW_NESTED_BOOK:
authors);



--- ***** ---


//
Create a new database to hold the Twitter file
CREATE DATABASE SOCIAL_MEDIA_FLOODGATES
COMMENT = 'There\'s so much data from social media - flood warning';

USE DATABASE SOCIAL_MEDIA_FLOODGATES;

//Create a table in the new database
CREATE TABLE SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST 
("RAW_STATUS" VARIANT) 
COMMENT = 'Bring in tweets, one row per tweet or status entity';

//Create a JSON file format in the new database
CREATE FILE FORMAT SOCIAL_MEDIA_FLOODGATES.PUBLIC.JSON_FILE_FORMAT 
TYPE = 'JSON' 
COMPRESSION = 'AUTO' 
ENABLE_OCTAL = FALSE 
ALLOW_DUPLICATE = FALSE 
STRIP_OUTER_ARRAY = TRUE 
STRIP_NULL_VALUES = FALSE 
IGNORE_UTF8_ERRORS = FALSE;



-- LOAD nutrition_tweets.json
copy into SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'nutrition_tweets.json' )
file_format = ( format_name=LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT );




//select statements as seen in the video
SELECT RAW_STATUS
FROM TWEET_INGEST;

SELECT RAW_STATUS:entities
FROM TWEET_INGEST;

SELECT RAW_STATUS:entities:hashtags
FROM TWEET_INGEST;

//Explore looking at specific hashtags by adding bracketed numbers
//This query returns just the first hashtag in each tweet
SELECT RAW_STATUS:entities:hashtags[0].text
FROM TWEET_INGEST;

//This version adds a WHERE clause to get rid of any tweet that 
//doesn't include any hashtags
SELECT
RAW_STATUS:
entities:
hashtags[0].text
FROM TWEET_INGEST
WHERE
RAW_STATUS:
entities:
hashtags[0].text is not null;

//Perform a simple CAST on the created_at key
//
Add an ORDER BY clause to sort by the tweet's creation date
SELECT RAW_STATUS:created_at::DATE
FROM TWEET_INGEST
ORDER BY RAW_STATUS:created_at::DATE;

//Flatten statements that return the whole hashtag entity
SELECT value
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);

SELECT value
FROM TWEET_INGEST
,TABLE(FLATTEN(RAW_STATUS:entities:hashtags));

//Flatten statement that restricts the value to just the TEXT of the hashtag
SELECT value:text
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);


//Flatten and return just the hashtag text, CAST the text as VARCHAR
SELECT value:text::VARCHAR
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);

//Flatten and return just the hashtag text, CAST the text as VARCHAR
// Use the AS command to name the column
SELECT value:text::VARCHAR AS THE_HASHTAG
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);

//Add the Tweet ID and User ID to the returned table
SELECT RAW_STATUS:user:id AS USER_ID
,RAW_STATUS:id AS TWEET_ID
,value:text::VARCHAR AS HASHTAG_TEXT
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);














