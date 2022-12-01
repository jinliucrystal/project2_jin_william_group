{{ config(materialized='table') }}

-- all users in graph
with graph_users as
(
    select distinct dst from graph.q3
    union all
    select distinct src from graph.q3
),

never_mentioned as
(
    select * from graph_users
    except distinct
    select distinct dst from graph.q3

),
-- indegree for each user
id AS
(
select dst, count(src) as indegree
from graph.q3
group by dst
order by indegree desc
),

-- avg likes for each user
al as
(
select twitter_username, avg(t.like_num) as avg_likes
from graph.tweets as t
group by twitter_username
),

-- avg likes for all tweets in tweets table
tb1 as
(
select avg(like_num) as avg_all_likes
from graph.tweets
),

-- avg indegree for all users in graph
tb2 as
(
select avg(indegree) as avg_indegree
from id
),

-- popular users
p as
(
select distinct t.twitter_username as popular, id.indegree, al.avg_likes
from graph.tweets as t
join graph.q3 as g
on g.dst=t.twitter_username
join id
on g.dst=id.dst
join al
on g.dst=al.twitter_username
where al.avg_likes > (select avg_all_likes from tb1)
and id.indegree > (select avg_indegree from tb2)
),

-- all unpopular users in graph
up as
(
    select * from graph_users
    except distinct
    select popular from p
),

-- count of tweets from unpopular users which mention popular users
pup as
(
    select count(*) as pup_count
    from graph.q3 as g
    where g.dst in (select popular from p)
    and g.src in (select * from up)
)

select * from p
-- select cast((select pup_count from pup)/count(*) as FLOAT64) as unpopular_popular
-- from graph.tweets
-- where twitter_username in (select * from up)

-- select *
-- from graph.q3 as g
-- where g.src in (select * from up)
-- and g.dst in (select popular from p)


-- count of tweets from unpopular users which mention popular users
-- select distinct * from graph_users
-- select uup_count from uup

-- create or replace temp table uup as
-- (
--     select count(t.id) as uup_count
--     from graph.tweets as t, graph.q3 as g
--     where t. in (select popular from p)
--     and t.twitter_username in (select * from up)
-- );



-- -- popular users
-- create or replace temp table p as
-- (
-- select distinct t.twitter_username as popular, id.indegree, al.avg_likes
-- from tb1, tb2, graph.tweets as t
-- join graph.q3 as g
-- on g.src=t.twitter_username or g.dst=t.twitter_username
-- join id
-- on g.src=id.src or g.dst=id.src
-- join al
-- on g.src=al.twitter_username or g.dst=al.twitter_username
-- where al.avg_likes > tb1.avg_all_likes
-- and id.indegree > tb2.avg_indegree
-- );

-- indegree
-- select src, count(*) as indegree
-- from graph.q3
-- group by src
-- order by indegree desc

-- avg_likes for each twitter user
-- select twitter_username, avg(t.like_num) as avg_likes
-- from graph.tweets as t
-- group by twitter_username
-- order by avg_likes desc
-- limit 5

-- average indegree of all users in graph
-- select avg(indegree) as avg_indegree
-- from 
-- (
-- select src, count(*) as indegree
-- from graph.q3
-- group by src
-- order by indegree desc
-- )

-- average likes for all tweets from tweets table
-- select avg(like_num) as avg_all_likes
-- from graph.tweets

-- scraps
-- select twitter_username, avg(t.like_num) as avg_likes
-- from graph.tweets as t
-- join graph.q3 as g
-- on g.src=t.twitter_username or g.dst=t.twitter_username 
-- group by twitter_username
-- order by avg_likes desc
-- limit 5

