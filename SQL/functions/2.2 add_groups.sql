-- FUNCTION: public.add_groups(integer, integer)

-- DROP FUNCTION IF EXISTS public.add_groups(integer, integer);

CREATE OR REPLACE FUNCTION public.add_groups(
	mod_num integer,
	group_num integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
    i record;
    max_mem smallint;
begin
-- saving the module's max members number into a variable
select max_members into max_mem
from "LabModule"
where module_no = mod_num;

-- the outer for loop is used to create the work groups
for i in 1..group_num loop
    insert into "WorkGroup" (implements_module_no, implements_serial_number,
                             implements_course_code)
    select distinct module_no, course_run_serial_number, has_course_code
    from "LabModule"
    where module_no = mod_num;

    -- the inner for loop is used to add members to each group
    for i in 1..max_mem loop
        insert into "Joins"
        select (select amka
                from "Register"
                where register_status = 'approved'
                    and (course_code, serial_number) in 
                        (select implements_course_code, implements_serial_number
                         from "WorkGroup"
                         where implements_module_no = mod_num)
                    and amka not in (select student_amka
                                     from "Joins"
                                     where work_group_module_no = mod_num)
                order by random()
                limit 1), "wgID", implements_module_no,
                          implements_serial_number, implements_course_code
        from "WorkGroup"
        where implements_module_no = mod_num
        order by "wgID" desc
        limit 1;
    end loop;
end loop;
end;
$BODY$;

ALTER FUNCTION public.add_groups(integer, integer)
    OWNER TO postgres;

COMMENT ON FUNCTION public.add_groups(integer, integer)
    IS '2.2: A function that creates work groups for specific modules chosen by the user.';
