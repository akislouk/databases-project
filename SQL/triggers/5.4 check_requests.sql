-- FUNCTION: public.check_requests()

-- DROP FUNCTION IF EXISTS public.check_requests();

CREATE OR REPLACE FUNCTION public.check_requests()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 
    am character varying; -- amka
    course character(7); -- course_code
    semester integer; -- semesterrunsin
    dep_flag boolean; -- a flag that indicates whether a student has passed all the required courses or not (true if he did)
    total_units smallint;
    total_courses integer;
begin
if new.register_status = 'requested' and coalesce(old.register_status = 'proposed', true) then
    -- saving some info into variables because they are used many times. The old values are used if the new ones are null
    am = coalesce(new.amka, old.amka);
    course = coalesce(new.course_code, old.course_code);

    -- saving the semester id that the course/serial number relate to 
    select semesterrunsin into semester
    from "CourseRun" cr
    where cr.course_code = course
        and cr.serial_number = coalesce(new.serial_number, old.serial_number);

    -- checking whether a student has passed all required courses or not and saving that result into a variable
    select (count(register_status = 'pass') = (select count(*)
                                               from "Course_depends"
                                               where dependent = course
                                                   and mode = 'required')) into dep_flag
    from "Register" r
    where r.amka = am and r.course_code in (select main
                                            from "Course_depends"
                                            where dependent = course
                                                and mode = 'required');

    -- calculating the total units of the courses the student has already signed up for plus the units of the new course
    -- using coalesce because sum returns null if it tries to get the sum of an empty query (eg. when the student hasn't signed up in any courses)
    select coalesce(sum(units), 0) +
        (select units
         from "Course" cr
         where cr.course_code = course) into total_units
    from "Course" cr
    where cr.course_code in
            (select course_code
             from "Register" r
             where r.amka = am
                 and r.register_status in ('pass', 'fail', 'approved')
                 and (r.course_code, r.serial_number) in
                     (select course_code, serial_number
                      from "CourseRun"
                      where semesterrunsin = semester));

    -- counting the total courses the student has already signed up for and saving them into a variable
    select count(*) into total_courses
    from "Register" r
    where r.amka = am and r.register_status in ('pass', 'fail', 'approved')
        and (r.course_code, r.serial_number) in (select course_code, serial_number
                                                 from "CourseRun"
                                                 where semesterrunsin = semester);

    -- raise notice '% total courses, % total units', total_courses, total_units;

    if dep_flag and total_units <= 20 and total_courses < 6 then
        new.register_status = 'approved';
        raise notice 'Η αίτηση εγγραφής στο μάθημα % εγκρίθηκε.', course;
    else
        new.register_status = 'rejected';
        raise notice 'Η αίτηση εγγραφής στο μάθημα % απορρίφθηκε.', course;
    end if;
    return new;
else -- when new register status = approved/rejected (we have already checked for the other cases in the trigger's when clause)
    raise exception 'Δεν επιτρέπεται η χειροκίνητη αλλαγή της κατάστασης εγγραφής από/σε approved/rejected.';
end if;
end;
$BODY$;

ALTER FUNCTION public.check_requests()
    OWNER TO postgres;

COMMENT ON FUNCTION public.check_requests()
    IS '5.4: A trigger function that checks if a student can add the requested course and approves or rejects the request accordingly.';
