-- FUNCTION: public.get_load()

-- DROP FUNCTION IF EXISTS public.get_load();

CREATE OR REPLACE FUNCTION public.get_load(
	OUT amka character varying,
	OUT surname character varying,
	OUT name character varying,
	OUT work_load integer)
    RETURNS SETOF record 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select distinct s.amka,
    (select surname
     from "Person"
     where amka = s.amka ),
    (select name
     from "Person"
     where amka = s.amka),
    (select sum(course_hours) as total_hours
     from (select s.amka, s.course_code,
                 ((select lab_hours
                   from "Course"
                   where course_code = s.course_code) +
                  (select count(*)
                   from "WorkGroup"
                   where implements_course_code = s.course_code)) as course_hours
           from "Supports" s
           inner join
              (select course_code
               from "CourseRun"
               where semesterrunsin =
                       (select semester_id
                        from "Semester"
                        where semester_status = 'present')) as sa on s.course_code = sa.course_code
           order by amka) as ch
     where amka = s.amka)
from "Supports" s
inner join
    (select course_code
     from "CourseRun"
     where semesterrunsin =
             (select semester_id
              from "Semester"
              where semester_status = 'present')) as sa on s.course_code = sa.course_code
$BODY$;

ALTER FUNCTION public.get_load()
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_load()
    IS '3.7: A function that calculates and returns the work load of all the faculty members.';
