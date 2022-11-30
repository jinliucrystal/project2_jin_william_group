{{ config(materialized='table') }}
Select t.id, t.text from `graph.tweets` as t
Where LOWER(t.text) LIKE '%trump%'
And LOWER(t.text) LIKE '%maga%'