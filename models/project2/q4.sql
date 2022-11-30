{{ config(materialized='table') }}

-- write your query here
with tb1 as (select src, count(distinct dst) as outdegree
from graph.q3
group by src
order by outdegree desc
limit 1
),
tb2 as (select dst, count(src) as indegree
from graph.q3
group by dst
order by indegree desc
limit 1
)
select outdegree, indegree
from tb1, tb2

