-- FUNCTION: public.check_members_com()

-- DROP FUNCTION IF EXISTS public.check_members_com();

CREATE OR REPLACE FUNCTION public.check_members_com()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
if (select count(*)
    from "Committee" c
    where c.diploma_num = new.diploma_num) <
   (select committee_members_no
    from "School Rules"
    where "year" = (select academic_year
                    from "Semester"
                    where semester_status = 'present')) then return new;
else
    raise exception 'Η επιτροπή για τη διπλωματική εργασία % έχει ήδη το μέγιστο αριθμό ατόμων', new.diploma_num
    using hint = 'Παρακαλώ εισάγεται σε άλλη επιτροπή';
end if;
end;
$BODY$;

ALTER FUNCTION public.check_members_com()
    OWNER TO postgres;

COMMENT ON FUNCTION public.check_members_com()
    IS '5.1: A trigger function that checks if a committee has the maximum amount of members before inserting a new one.';
