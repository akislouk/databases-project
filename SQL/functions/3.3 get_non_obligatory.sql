-- FUNCTION: public.get_non_obligatory()

-- DROP FUNCTION IF EXISTS public.get_non_obligatory();

CREATE OR REPLACE FUNCTION public.get_non_obligatory(
	OUT course_code character,
	OUT course_title character)
    RETURNS SETOF record
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select course_code, course_title
from "Course" co
where obligatory = false
    and typical_season = (select academic_season
                          from "Semester"
                          where semester_status = 'present')
    and not exists (select course_code
                    from "CourseRun" cr
                    where cr.course_code = co.course_code
                        and semesterrunsin =
                            (select semester_id
                             from "Semester"
                             where semester_status = 'present'));
$BODY$;

ALTER FUNCTION public.get_non_obligatory()
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_non_obligatory()
    IS '3.3: A function that shows the code and title of the current semester''s non-obligatory courses.';
