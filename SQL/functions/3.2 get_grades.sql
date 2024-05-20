-- FUNCTION: public.get_grades(character, character varying)

-- DROP FUNCTION IF EXISTS public.get_grades(character, character varying);

CREATE OR REPLACE FUNCTION public.get_grades(
	grade_type character,
	student character varying,
	OUT course character,
	OUT grade numeric)
    RETURNS SETOF record 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select course_code,
       case grade_type
           when 'exam_grade' then exam_grade
           when 'final_grade' then final_grade
           when 'lab_grade' then lab_grade
           else null
       end
from "Register" r
where exists (select cr.course_code, cr.serial_number
              from "CourseRun" cr
              where cr.course_code = r.course_code
                  and cr.serial_number = r.serial_number
                  and semesterrunsin =
                      (select semester_id
                       from "Semester"
                       where semester_status = 'present'))
    and amka = student
order by course_code asc;
$BODY$;

ALTER FUNCTION public.get_grades(character, character varying)
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_grades(character, character varying)
    IS '3.2: A function that returns a student''s chosen grades for the current semester.';
