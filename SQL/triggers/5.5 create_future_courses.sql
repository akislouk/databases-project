-- FUNCTION: public.create_future_courses()

-- DROP FUNCTION IF EXISTS public.create_future_courses();

CREATE OR REPLACE FUNCTION public.create_future_courses()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
if new.semester_status = 'future' then 
    insert into "CourseRun"
    select course_code, new.semester_id / 2 + new.semester_id % 2,
           round(random() * 2 + 4), round(random() * 4 + 3), round(random() * 4 + 3) * 10,
        (select lab_code
         from "Lab"
         where sector_code =
                 (select sector_code
                  from "Lab"
                  where lab_code =
                          (select labuses
                           from "CourseRun"
                           where course_code = c.course_code
                               and serial_number =
                                   (select serial_number
                                    from "CourseRun"
                                    where course_code = c.course_code
                                    order by serial_number desc
                                    limit 1)))
         order by random()
         limit 1), new.semester_id
    from "Course" as c
    where typical_season = new.academic_season;

    update "CourseRun"
    set exam_min = 0, lab_min = 0, exam_percentage = 0
    where labuses is null and semesterrunsin = new.semester_id;

    insert into "Teaches"
    select distinct
        (select amka
         from "Teaches"
         where course_code = c.course_code
         order by random()
         limit 1), c.serial_number, c.course_code
    from "CourseRun" c
    where semesterrunsin = new.semester_id;

    insert into "Supports"
    select distinct
        (select amka
         from "Supports"
         where course_code = c.course_code
         order by random()
         limit 1), c.serial_number, c.course_code
    from "CourseRun" c
    where labuses is not null and semesterrunsin = new.semester_id;
end if;
return null;
end;
$BODY$;

ALTER FUNCTION public.create_future_courses()
    OWNER TO postgres;

COMMENT ON FUNCTION public.create_future_courses()
    IS '5.5: A trigger function that creates the courses of a future semester whenever one is added.';
