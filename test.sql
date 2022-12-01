{{ config(materialized='table') }}

-- all users in graph
with graph_users as
(
    select distinct dst from graph.q3
    union all
    select distinct src from graph.q3
)


-- indegree for each user
-- select g.dst, count(g.src) as indegree
-- from graph_users as gu
-- full outer join graph.q3 as g on gu.dst=g.dst
-- where g.src is not null
-- group by g.dst
-- order by indegree desc

-- select *
-- from graph_users as gu
-- left join graph.q3 as g on gu.dst=g.dst

-- select * from graph_users
-- except distinct
-- select distinct dst from graph.q3

select * from graph.q3