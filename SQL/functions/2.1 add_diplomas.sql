-- FUNCTION: public.add_diplomas()

-- DROP FUNCTION IF EXISTS public.add_diplomas();

CREATE OR REPLACE FUNCTION public.add_diplomas(
	)
    RETURNS void
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
insert into "Diploma" (grad_student_amka)
select subquery.amka
from ((select amka
       from "Student"
       where ((select academic_year
               from "Semester"
               where semester_status = 'present') - date_part('year', entry_date) >= 4))
       intersect
      (select r.amka
       from "Register" r
       where r.register_status in ('approved', 'pass', 'fail')
           and exists (select cr.course_code, cr.serial_number
                       from "CourseRun" cr
                       where cr.course_code = r.course_code
                           and cr.serial_number = r.serial_number
                           and semesterrunsin = (select semester_id
                                                 from "Semester"
                                                 where semester_status = 'present')))) as subquery
where subquery.amka not in (select grad_student_amka from "Diploma");

update "Diploma"
set thesis_title = dt.title
from (select ddt.title, -- giving a uid to the titles
            row_number() over (order by random()) + (select count(*)
                                                     from "Diploma"
                                                     where thesis_title is not null) tid
      from (select distinct title -- getting rid of duplicates
            from "DiplomaTitles") as ddt
      where coalesce(ddt.title not in (select thesis_title
                                       from "Diploma"), true)) as dt
where diploma_num = dt.tid and thesis_title is null;
$BODY$;

ALTER FUNCTION public.add_diplomas()
    OWNER TO postgres;

COMMENT ON FUNCTION public.add_diplomas()
    IS '2.1: A function that assigns random diplomas to eligible students.';
