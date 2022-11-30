{{ config(materialized='table') }}

-- write your query here
CREATE OR REPLACE TABLE graph.q3 as
SELECT t.twitter_username as src, SUBSTRING(REGEXP_EXTRACT(t.text, '@\\w+'), 2, LENGTH(REGEXP_EXTRACT(t.text, '@\\w+'))) as dst
from graph.tweets as t
