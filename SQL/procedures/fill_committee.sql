-- PROCEDURE: public.fill_committee()

-- DROP PROCEDURE IF EXISTS public.fill_committee();

CREATE OR REPLACE PROCEDURE public.fill_committee(
	)
LANGUAGE 'plpgsql'
AS $BODY$
declare
    i record;
    j record;
    current_year integer;
    min_diploma integer;
    max_diploma integer;
begin
select academic_year into current_year
from "Semester"
where semester_status = 'present';

select min(diploma_num), max(diploma_num)
into min_diploma, max_diploma
from "Diploma"
where diploma_num not in (select diploma_num
                          from "Committee");

if min_diploma is not null then
    for i in min_diploma..max_diploma loop
        for j in 1..(select committee_members_no
                     from "School Rules"
                     where "year" = current_year) loop
            insert into "Committee" (diploma_num,
                                     grad_student_amka,
                                     professor_amka,
                                     supervisor)
            select i, (select grad_student_amka
                       from "Diploma"
                       where diploma_num = i), amka,
                                               case j
                                                   when 1 then true
                                                   else false
                                               end
            from "Professor"
            where amka not in (select professor_amka
                               from "Committee"
                               where diploma_num = i)
            order by random()
            limit 1;
        end loop;
    end loop;
end if;
end;
$BODY$;

ALTER PROCEDURE public.fill_committee()
    OWNER TO postgres;

COMMENT ON PROCEDURE public.fill_committee()
    IS 'A procedure that fills the Committee table.';
