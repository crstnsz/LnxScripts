SELECT 
    s.sid,
    s.serial#,
    s.status,
    s.username,
    s.osuser,
    s.program,
    'ALTER SYSTEM KILL SESSION ''' || s.sid || ',' || s.serial# || ''' IMMEDIATE;' AS kill_command
FROM 
    v$session s
WHERE 
    s.type != 'BACKGROUND' 
    AND s.username IS NOT NULL
ORDER BY 
    s.username;