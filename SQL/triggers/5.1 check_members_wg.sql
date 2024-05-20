-- FUNCTION: public.check_members_wg()

-- DROP FUNCTION IF EXISTS public.check_members_wg();

CREATE OR REPLACE FUNCTION public.check_members_wg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
if (select count(*)
    from "Joins" j
    where j."wgID" = new."wgID") < 
   (select max_members
    from "LabModule"
    where module_no = new."work_group_module_no") then return new;
else
    raise exception 'Η ομάδα % έχει ήδη το μέγιστο αριθμό ατόμων', new."wgID"
    using hint = 'Παρακαλώ εισάγεται σε άλλη ομάδα';
end if;
end;
$BODY$;

ALTER FUNCTION public.check_members_wg()
    OWNER TO postgres;

COMMENT ON FUNCTION public.check_members_wg()
    IS '5.1: A trigger function that checks if a group has the maximum amount of members before inserting a new one.';
