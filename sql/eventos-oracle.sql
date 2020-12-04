select  v$session.STATUS, v$session.sid, v$session_event.time_waited,v$session_event.event, v$session.username,v$session.osuser, v$session.username, v$session.program, v$sql.sql_text, v$session_event.* 
from v$session
inner join v$session_event
on v$session.sid = v$session_event.sid
left outer join v$sql
on v$sql.sql_id = v$session.sql_id
where osuser != 'oracle' AND  v$session.username in ('[usuario]')
order by v$session_event.time_waited DESC, v$session.username, v$session.sid, v$session.serial#
