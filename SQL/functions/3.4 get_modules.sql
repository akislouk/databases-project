-- FUNCTION: public.get_modules(character)

-- DROP FUNCTION IF EXISTS public.get_modules(character);

CREATE OR REPLACE FUNCTION public.get_modules(
	am_in character,
	OUT "Εργασία" integer,
	OUT "Συμμετέχει?" character)
    RETURNS SETOF record 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select module_no,
       case
           when module_no in
                    (select work_group_module_no
                     from "Joins"
                     where student_amka =
                             (select amka
                              from "Student"
                              where am = am_in)) then 'ΝΑΙ'
           else 'ΌΧΙ'
       end
from "LabModule"
where (has_course_code, course_run_serial_number) in
        (select course_code, serial_number
         from "CourseRun"
         where semesterrunsin =
                 (select semester_id
                  from "Semester"
                  where semester_status = 'present'))
order by module_no asc;
$BODY$;

ALTER FUNCTION public.get_modules(character)
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_modules(character)
    IS '3.4: A function that returns all the lab modules of the current semester along with an indication about whether a given student is part of a work group for those modules.';
