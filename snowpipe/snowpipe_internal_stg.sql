CREATE DATABASE IF NOT EXISTS bronze;
USE DATABASE bronze;

CREATE SCHEMA IF NOT EXISTS ott_data;
USE SCHEMA ott_data;

CREATE OR REPLACE TABLE netflix_titles (
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

CREATE OR REPLACE FILE FORMAT csv_format
TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY  = '"'
SKIP_HEADER = 1;

CREATE OR REPLACE STAGE ott_data;

-- Pushed a file to ott_data stage using snowsql put command
-- put file://netflix_titles01.csv @ott_data;

CREATE OR REPLACE PIPE netflix_pipe
AS
COPY INTO netflix_titles
FROM @ott_data
PATTERN = 'netflix_titles.*\.csv\.gz'
FILE_FORMAT = (FORMAT_NAME = csv_format);

-- Pipes with internal stages cannot be refreshed automatically
-- Following code runs the pipe
ALTER PIPE netflix_pipe REFRESH;

-- Output : Data is loaded to "netflix_titles" table
