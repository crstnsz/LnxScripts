select  sql_text
   from v$sqltext_with_newlines
  where address in (
        select sql_address from v$session where sid = &SID
        and hash_value in (
        select sql_hash_value from v$session where sid =&SID ))
  order by piece
