-- FUNCTION: public.get_titles()

-- DROP FUNCTION IF EXISTS public.get_titles();

CREATE OR REPLACE FUNCTION public.get_titles(
	OUT "Τίτλος Διπλωματικής" character varying)
    RETURNS SETOF character varying 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
-- using cte to get a list of diplomas and the professors' labs
-- then removing duplicate diplomas from that query because that means
-- that the professors are in different labs
select thesis_title
from "Diploma" dip
where exists
    (with s1 as
         (select diploma_num, labjoins
          from "Committee"
          inner join "Professor" on professor_amka = amka
          group by diploma_num, labjoins), s2 as
         (select diploma_num, labjoins
          from "Committee"
          inner join "Professor" on professor_amka = amka
          group by diploma_num, labjoins)
     select diploma_num
     from s1
     where dip.diploma_num = s1.diploma_num and
         (select count(*)
          from s2
          where s1.diploma_num = s2.diploma_num) = 1);
$BODY$;

ALTER FUNCTION public.get_titles()
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_titles()
    IS '3.8: A function that returns all the thesis titles whose committee members are part of the same lab.';
