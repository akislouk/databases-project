-- FUNCTION: public.get_max_grades(integer, character)

-- DROP FUNCTION IF EXISTS public.get_max_grades(integer, character);

CREATE OR REPLACE FUNCTION public.get_max_grades(
	semester integer,
	grade_type character,
	OUT course character,
	OUT grade integer)
    RETURNS SETOF record 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select course_code,
       case grade_type
           when 'exam_grade' then max(exam_grade)
           when 'final_grade' then max(final_grade)
           when 'lab_grade' then max(lab_grade)
           else null
       end grade
from "Register" r
where exists (select cr.course_code, cr.serial_number
              from "CourseRun" cr
              where cr.course_code = r.course_code
                  and cr.serial_number = r.serial_number
                  and semesterrunsin = semester)
group by course_code
order by grade desc, course_code asc;
$BODY$;

ALTER FUNCTION public.get_max_grades(integer, character)
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_max_grades(integer, character)
    IS '3.5: A function that returns the max grades for a given semester and grade type.';
