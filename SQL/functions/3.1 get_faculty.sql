-- FUNCTION: public.get_faculty(integer)

-- DROP FUNCTION IF EXISTS public.get_faculty(integer);

CREATE OR REPLACE FUNCTION public.get_faculty(
	sector integer,
	OUT name character varying,
	OUT surname character varying,
	OUT amka character varying)
    RETURNS SETOF record 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select name, surname, amka
from "Person"
where amka in ((select amka
                from "Professor"
                where labjoins in (select lab_code
                                   from "Lab"
                                   where sector_code = sector))
                union
               (select amka
                from "LabTeacher"
                where labworks in (select lab_code
                                   from "Lab"
                                   where sector_code = sector)));
$BODY$;

ALTER FUNCTION public.get_faculty(integer)
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_faculty(integer)
    IS '3.1: A function that returns the faculty members'' AMKA and names for the given sector.';
