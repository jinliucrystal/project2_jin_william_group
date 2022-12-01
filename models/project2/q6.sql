{{ config(materialized='table') }}

SELECT src
FROM graph.q3 AS g1
JOIN g1
  ON g1.dst = g2.src
JOIN g2
  ON g2.dst = g3.src;
-- select src
-- from graph.q3
-- where src in (select dst
-- from graph.q3 g1
-- where g1.src = 'Aqy')
-- join graph.q3 g2
-- on g1.dst = g2.src
-- join graph.q3 g3
-- on g2.dst = g3.src
-- write your query here