DROP TABLE IF EXISTS climate_tweets_raw;

-- creating a table in order to import the dataset into it.
CREATE TABLE climate_tweets_raw (
    created_at TEXT,
    id TEXT,
    lng TEXT,
    lat TEXT,
    topic TEXT,
    sentiment TEXT,
    stance TEXT,
    gender TEXT,
    temperature_avg TEXT,
    aggressiveness TEXT
);

-- checking if the data got imported accuately
SELECT COUNT(*) 
FROM climate_tweets_raw;

-- inspecting the data picking the first 50
SELECT * FROM climate_tweets_raw LIMIT 50;

-- Check missing coordinates
SELECT COUNT(*) AS missing_coords
FROM climate_tweets_raw
WHERE lat IS NULL OR lng IS NULL OR lat = '' OR lng = '';

--Out of ~15.7M rows, ~10.4M have no location data, only ~5.3M have valid coordinates
-- Further checks show that both lat and lng columns have missing values in the same rows;
SELECT COUNT(*) AS missing_coords
FROM climate_tweets_raw
WHERE lng IS NULL OR lng = '';

SELECT COUNT(*) AS missing_both_coordinates
FROM climate_tweets_raw
WHERE (lat IS NULL OR lat = '')
  AND (lng IS NULL OR lng = '');

-- the rows to be used for location_based analysis (rows with known lat and lng)
SELECT COUNT(*) AS usable_location_rows
FROM climate_tweets_raw
WHERE lat IS NOT NULL AND lat <> ''
  AND lng IS NOT NULL AND lng <> '';

-- check for undefined gender
SELECT COUNT(*) as undefined_gender
FROM climate_tweets_raw
where gender is null or gender = 'undefined';
-- or a gene+ral check
SELECT gender, COUNT(*) 
FROM climate_tweets_raw
GROUP BY gender;
-- Male_dominated, more than 500,000 entries with an undefined gender

-- checking for duplicates
SELECT id, COUNT(*) AS duplicate_count
FROM climate_tweets_raw
GROUP BY id
HAVING COUNT(*) > 1
LIMIT 20;
-- no duplicates found

-- checking for out-of-range sentiment scores
SELECT *
FROM climate_tweets_raw
WHERE sentiment::FLOAT < -1 
   OR sentiment::FLOAT > 1
LIMIT 20;
-- None found

-- Exploration of key variables
-- Check stance distribution
SELECT stance, COUNT(*)
FROM climate_tweets_raw
GROUP BY stance;
-- a very large percentage of the users are believers

-- Check aggressiveness values
SELECT aggressiveness, COUNT(*)
FROM climate_tweets_raw
GROUP BY aggressiveness;
-- Most people are not aggressive

-- Check sentiment issues
SELECT *
FROM climate_tweets_raw
WHERE sentiment = '' OR sentiment IS NULL
LIMIT 20;
-- No missing values

-- creating a cleaned dataset using a view
CREATE OR REPLACE VIEW vw_cleaned_tweets AS
SELECT
    created_at::timestamp AS created_at,
    id,
    lng::FLOAT AS lng,
    lat::FLOAT AS lat,
    topic,
    sentiment::FLOAT AS sentiment,
    stance,
    CASE 
        WHEN gender IS NULL OR gender = '' OR gender = 'undefined' THEN 'Unknown'
        ELSE gender
    END AS gender,
    temperature_avg::FLOAT AS temperature_avg,
    aggressiveness,
    EXTRACT(YEAR FROM created_at::timestamp) AS tweet_year
FROM climate_tweets_raw;

-- checking the view
SELECT * FROM vw_cleaned_tweets LIMIT 20;

-- trend across tweet years
CREATE OR REPLACE VIEW vw_sentiment_trend AS
SELECT 
    tweet_year,
    AVG(sentiment) AS avg_sentiment,
    COUNT(*) AS total_tweets
FROM vw_cleaned_tweets
GROUP BY tweet_year
ORDER BY tweet_year;

SELECT * FROM vw_sentiment_trend LIMIT 20;
-- 2018 recorded the highest number of tweets, suggesting a peak in public engagement 
-- and possibly increased global attention to climate-related issues during that period.

SELECT MIN(tweet_year), MAX(tweet_year)
FROM vw_cleaned_tweets;
-- The task says that the dataset ranges from 2008-2022 but analysis showed that it ranges from 2006-2019

-- stance variation analysis
CREATE OR REPLACE VIEW vw_stance_trend AS
SELECT 
    tweet_year,
    stance,
    COUNT(*) AS tweet_count
FROM vw_cleaned_tweets
GROUP BY tweet_year, stance
ORDER BY tweet_year;

SELECT * FROM vw_stance_trend;
-- This query shows how climate change stance varies over time. Believers dominate the conversation, 
-- deniers are fewer, and a significant number of tweets are neutral.
-- Overall tweet volume increases over the years, indicating growing public engagement.

-- creating indexes beacause because the query takes a lot of time
CREATE INDEX idx_climate_created_at
ON climate_tweets_raw (created_at);

CREATE INDEX idx_climate_stance
ON climate_tweets_raw (stance);

CREATE INDEX idx_climate_topic
ON climate_tweets_raw (topic);

CREATE INDEX idx_climate_aggressiveness
ON climate_tweets_raw (aggressiveness);
--Although analysis was performed using views, indexes were created on the underlying raw table 
--to improve query performance, as views are executed based on the source table.

-- Topic + aggressiveness analysis
CREATE OR REPLACE VIEW vw_topic_aggression AS
SELECT 
    topic,
    aggressiveness,
    COUNT(*) AS tweet_count,
    AVG(sentiment) AS avg_sentiment
FROM vw_cleaned_tweets
GROUP BY topic, aggressiveness
ORDER BY tweet_count DESC;

-- Preview top results from the topic-aggression view
SELECT * 
FROM vw_topic_aggression; 
-- The results show that topics such as global stance, weather extremes, and human intervention 
-- dominate climate discussions. While most tweets are not aggressive, a substantial number of 
-- aggressive tweets exist across key topics

-- Topic + stance analysis
CREATE OR REPLACE VIEW vw_topic_stance AS
SELECT
    topic,                      
    stance,                     
    COUNT(*) AS tweet_count,    
    AVG(sentiment) AS avg_sentiment
FROM vw_cleaned_tweets
GROUP BY topic, stance
ORDER BY tweet_count DESC;

SELECT *
FROM vw_topic_stance;
-- The analysis shows that belief in climate change dominates across most topics.


-- Location-based sentiment analysis
CREATE OR REPLACE VIEW vw_location_sentiment AS
SELECT
    ROUND(lat, 1) AS lat,
    ROUND(lng, 1) AS lng,
    COUNT(*) AS tweet_count,
    AVG(sentiment) AS avg_sentiment
FROM vw_cleaned_tweets
WHERE lat IS NOT NULL 
  AND lng IS NOT NULL
GROUP BY ROUND(lat, 1), ROUND(lng, 1)
ORDER BY tweet_count DESC;
-- this threw an error regarding the lat and lng datatype...

-- Location-based sentiment analysis
CREATE OR REPLACE VIEW vw_location_sentiment AS
SELECT
    ROUND(lat::numeric, 1) AS lat,      -- convert before rounding
    ROUND(lng::numeric, 1) AS lng,
    COUNT(*) AS tweet_count,
    AVG(sentiment) AS avg_sentiment
FROM vw_cleaned_tweets
WHERE lat IS NOT NULL 
  AND lng IS NOT NULL
GROUP BY ROUND(lat::numeric, 1), ROUND(lng::numeric, 1)
ORDER BY tweet_count DESC;

SELECT * 
FROM vw_location_sentiment;

CREATE TABLE disasters_raw (
    disaster_type TEXT,
    disaster_subtype TEXT,
    disaster_group TEXT,
    disaster_subgroup TEXT,
    event_name TEXT,
    origin TEXT,
    country TEXT,
    location TEXT,
    latitude TEXT,
    longitude TEXT,
    start_date TEXT,
    end_date TEXT,
    total_deaths TEXT,
    no_affected TEXT,
    reconstruction_costs TEXT,
    total_damages TEXT,
    cpi TEXT
);


-- Topic, stance, and year analysis
CREATE OR REPLACE VIEW vw_topic_stance_year AS
SELECT
    tweet_year,
    topic,
    stance,
    COUNT(*) AS tweet_count
FROM vw_cleaned_tweets
GROUP BY
    tweet_year,
    topic,
    stance;

SELECT *
FROM vw_topic_stance_year
LIMIT 10;