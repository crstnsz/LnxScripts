insert into "Sample" 
(
    "Name",
)
select
    'Data ' || i || ' ' || left(md5(i::text), 10),
from generate_series(1, 1000) s(i)