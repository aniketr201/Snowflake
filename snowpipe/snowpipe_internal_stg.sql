CREATE DATABASE bronze;
USE DATABASE bronze;

CREATE SCHEMA ott_data;
USE SCHEMA ott_data;

CREATE TABLE netflix_titles (
    show_id STRING,
    type STRING,
    title STRING,
    director STRING,
    cast STRING,
    country STRING,
    date_added STRING,
    release_year INT,
    rating STRING,
    duration STRING,
    listed_in STRING,
    description STRING
);

CREATE FILE FORMAT csv_format
TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY  = '"'
SKIP_HEADER = 1;

CREATE STAGE ott_data;

CREATE OR REPLACE PIPE netflix_pipe
AUTO_INGEST = TRUE
AS
COPY INTO netflix_titles
FROM @ott_data
PATTERN = 'netflix_titles.*\.csv\.gz'
FILE_FORMAT = (FORMAT_NAME = csv_format);

ALTER PIPE netflix_pipe REFRESH;