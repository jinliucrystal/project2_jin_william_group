{{ config(materialized='table') }}
-- CREATE OR REPLACE TABLE q3 AS q3
SELECT t.twitter_username as src, SUBSTRING(REGEXP_EXTRACT(t.text, '@\\w+'), 2, length(REGEXP_EXTRACT(t.text, '@\\w+'))) as dst
from graph.tweets as t
