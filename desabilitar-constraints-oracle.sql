BEGIN
   FOR c IN (SELECT c.owner, c.table_name, c.constraint_name
   FROM user_constraints c, user_tables t
   WHERE c.table_name = t.table_name
   AND c.status ='DISABLED'
   AND c.owner = 'TP45'
   ORDER BY c.constraint_type DESC)
   LOOP

     begin 
         dbms_utility.exec_ddl_statement('alter table "'|| c.owner ||'"."'|| c.table_name ||'" ENABLE constraint '|| c.constraint_name);
     exception when others then dbms_output.put_line(c.table_name);
     end;
   END LOOP;
 END;
