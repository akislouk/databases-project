-- FUNCTION: public.get_sector()

-- DROP FUNCTION IF EXISTS public.get_sector();

CREATE OR REPLACE FUNCTION public.get_sector(
	OUT "Sector" integer)
    RETURNS SETOF integer 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
drop table if exists sec_diploma;

-- creating a temp table with the number of diplomas for each sector
create temp table sec_diploma as
select distinct sector, count(prof.sector) diploma_sum
from (select professor_amka,
        (select sector_code
         from "Lab"
         where lab_code = (select labjoins
                           from "Professor"
                           where amka = professor_amka)) sector
      from "Committee"
      where supervisor) as prof
group by sector;

-- returning the sectors that have max number of diplomas
return query
    (select sector
     from sec_diploma
     where diploma_sum = (select max(diploma_sum)
                          from sec_diploma));
                     
drop table sec_diploma;
end;
$BODY$;

ALTER FUNCTION public.get_sector()
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_sector()
    IS '3.6: A function that returns the sector(s) with the most diplomas.';
