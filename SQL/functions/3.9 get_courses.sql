-- FUNCTION: public.get_courses(character)

-- DROP FUNCTION IF EXISTS public.get_courses(character);

CREATE OR REPLACE FUNCTION public.get_courses(
	dep character)
    RETURNS TABLE(code character, title character) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare dep_code character(7);
begin
return query select main,
                 (select course_title
                  from "Course"
                  where course_code = main)
             from "Course_depends"
             where dependent = dep;

-- the recursive calls end when a course has no prerequisites
if dep is not null then
    for dep_code in (select main
                     from "Course_depends"
                     where dependent = dep) loop
        return query select * from get_courses(dep_code);
    end loop;
end if;
end;
$BODY$;

ALTER FUNCTION public.get_courses(character)
    OWNER TO postgres;

COMMENT ON FUNCTION public.get_courses(character)
    IS '3.9: A recursive function that returns all the recommended and prerequisite courses of the given course.';
