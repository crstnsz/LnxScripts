SELECT 
    blocking_session AS "ID Sessão Bloqueadora",
    sid AS "ID Sessão Bloqueada",
    serial# AS "Serial Sessão Bloqueada",
    username AS "Usuário Bloqueado",
    osuser AS "Usuário SO",
    machine AS "Máquina",
    program AS "Programa",
    seconds_in_wait AS "Tempo Travado (Segundos)",
    sql_text AS "Comando SQL Travado"
FROM 
    v$session s
LEFT JOIN 
    v$sql q ON s.sql_id = q.sql_id
WHERE 
    blocking_session IS NOT NULL
ORDER BY 
    seconds_in_wait DESC;