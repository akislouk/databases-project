-- FUNCTION: public.add_grades(integer)

-- DROP FUNCTION IF EXISTS public.add_grades(integer);

CREATE OR REPLACE FUNCTION public.add_grades(
	semester integer)
    RETURNS void
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
update "Register" r
set exam_grade =
    case exam_grade is null
        when true then round(random() * 9 + 1)
        else exam_grade
    end, lab_grade =
         case lab_grade is null
             when true then (select lab_grade_gen(amka, course_code))
             else lab_grade
         end
where register_status in ('pass', 'fail', 'approved')
    and exists (select cr.course_code, cr.serial_number
                from "CourseRun" cr
                where cr.course_code = r.course_code
                    and cr.serial_number = r.serial_number
                    and semesterrunsin = semester)
    and (exam_grade is null or lab_grade is null);
$BODY$;

ALTER FUNCTION public.add_grades(integer)
    OWNER TO postgres;

COMMENT ON FUNCTION public.add_grades(integer)
    IS '2.3: A function that grades students.';
