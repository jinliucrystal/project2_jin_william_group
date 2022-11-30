{{ config(materialized='table') }}
Select EXTRACT(ISOYEAR FROM PARSE_TIMESTAMP("%a %b %C %T %z %Y", t.create_time)) as year, EXTRACT(MONTH FROM PARSE_TIMESTAMP("%a %b %C %T %z %Y", t.create_time)) as month, count(*) as count
from `graph.tweets` as t
where LOWER(t.text) LIKE '%maga%'
group by year, month
order by count DESC
limit 5