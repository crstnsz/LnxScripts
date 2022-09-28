set serveroutput on;

declare
  raw_guid raw(16);
  guid varchar2(64);
begin
  
  raw_guid := guid_to_raw ('88c6a267-65d2-48d6-8da2-6f45e2c22726');
  guid := raw_to_guid('67A2C688D265D6488DA26F45E2C22726');
  
  dbms_output.put_line('RAW');
  dbms_output.put_line(raw_guid);
  dbms_output.put_line('GUID');
  dbms_output.put_line(guid);
  
  /*

  Expected output:

  RAW
  67A2C688D265D6488DA26F45E2C22726
  GUID
  88C6A267-65D2-48D6-8DA2-6F45E2C22726
  
  */
  
end;
/

create or replace function raw_to_guid( raw_guid in raw ) return varchar2
is
  hex varchar2(32);
begin

  hex := rawtohex(raw_guid);

  return substr(hex, 7, 2) 
      || substr(hex, 5, 2) 
      || substr(hex, 3, 2) 
      || substr(hex, 1, 2) 
      || '-'
      || substr(hex, 11, 2) 
      || substr(hex, 9, 2) 
      || '-'
      || substr(hex, 15, 2) 
      || substr(hex, 13, 2) 
      || '-'
      || substr(hex, 17, 4) 
      || '-'
      || substr(hex, 21, 12);

end;
/

create or replace function guid_to_raw ( guid in varchar2 ) return raw
is
    hex varchar2(32);
begin

    hex := substr(guid, 7, 2)
    ||     substr(guid, 5, 2)
    ||     substr(guid, 3, 2)
    ||     substr(guid, 1, 2)
    --
    ||     substr(guid, 12, 2)
    ||     substr(guid, 10, 2)
    --
    ||     substr(guid, 17, 2)
    ||     substr(guid, 15, 2)
    -- 
    ||     substr(guid, 20, 2)
    ||     substr(guid, 22, 2)
    -- 
    ||     substr(guid, 25, 12);
    
    return hextoraw(hex);

end;
/
