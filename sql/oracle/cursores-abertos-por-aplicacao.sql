select s.username, s.program, count(a.sid), sum(a.value) "Open Cursors"
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current'
and s.program not like 'ORACLE%'
and s.program not like 'OMS'
group by s.username, s.program
order by s.program;
