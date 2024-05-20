-- PROCEDURE: public.fill_rules()

-- DROP PROCEDURE IF EXISTS public.fill_rules();

CREATE OR REPLACE PROCEDURE public.fill_rules(
	)
LANGUAGE 'sql'
AS $BODY$
insert into "School Rules" ("year", committee_members_no, min_courses)
select sem.academic_year, round(random() * 3 + 2), round(random() * 15 + 45)
from (select distinct academic_year
      from "Semester") as sem
where sem.academic_year not in (select "year"
                                from "School Rules")
order by sem.academic_year asc;
$BODY$;

ALTER PROCEDURE public.fill_rules()
    OWNER TO postgres;

COMMENT ON PROCEDURE public.fill_rules()
    IS 'A procedure that fills the School Rules table with academic years from the Semester table and random values for committee_members_no and min_courses.';
