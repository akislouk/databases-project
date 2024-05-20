-- FUNCTION: public.lab_grade_gen(character varying, character)

-- DROP FUNCTION IF EXISTS public.lab_grade_gen(character varying, character);

CREATE OR REPLACE FUNCTION public.lab_grade_gen(
	am character varying,
	code character)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare grade numeric;
begin
-- stores the student's last viable lab_grade into a variable
select lab_grade into grade
from "Register"
where lab_grade is not null and amka = am and course_code = code
order by serial_number desc
limit 1;

return case
           when grade >= 5 then grade
           else round(random() * 9 + 1)
       end;
end;
$BODY$;

ALTER FUNCTION public.lab_grade_gen(character varying, character)
    OWNER TO postgres;

COMMENT ON FUNCTION public.lab_grade_gen(character varying, character)
    IS 'A function that checks the last lab_grade of a specific student and returns it if it''s higher than 5, otherwise it returns a random grade.';
