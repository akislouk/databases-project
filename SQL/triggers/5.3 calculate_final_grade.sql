-- FUNCTION: public.calculate_final_grade()

-- DROP FUNCTION IF EXISTS public.calculate_final_grade();

CREATE OR REPLACE FUNCTION public.calculate_final_grade()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare
    emin numeric; -- exam_min
    lmin numeric; -- lab_min
    per numeric; -- percentage
    nolab boolean; -- a flag that indicates whether a course has a lab or not (true if no lab)
    examg numeric; -- exam_grade
    labg numeric; -- lab_grade
begin
-- checking to see if the user is trying to change value manually
if new.register_status is distinct from old.register_status then
    raise exception 'Δεν επιτρέπεται να αλλάξετε χειροκίνητα την κατάσταση του φοιτητή όταν εισάγετε βαθμολογίες.'
    using hint = 'Παρακαλώ εισάγετε μόνο τους βαθμούς και θα ενημερωθεί αυτόματα η κατάσταση του φοιτητή.';
else
    -- saving the course info into variables
    select cr.exam_min, cr.lab_min, cr.exam_percentage, (cr.labuses is null)
    into emin, lmin, per, nolab
    from "CourseRun" cr
    where cr.course_code = coalesce(new.course_code, old.course_code)
        and cr.serial_number = coalesce(new.serial_number, old.serial_number);
    
    -- saving the grades into variables. The old values are used if the new ones are null
    examg = coalesce(new.exam_grade, old.exam_grade);
    labg = coalesce(new.lab_grade, old.lab_grade);
    
    -- if at least one grade is given, we try to determine the final grade
    if new.exam_grade is not null or new.lab_grade is not null then
        new.final_grade =
            case
                when nolab then examg
                when labg < lmin then 0
                when examg < emin then examg
                else round(((examg * per + labg * (100 - per)) / 100), 1)
            end;
    else -- both new grades are null
        new.final_grade = null;
    end if;

    new.register_status =
        case new.final_grade < 5
            when true then 'fail'
            when false then 'pass'
            else 'approved' -- when final grade is null
        end;

    return new;
end if;
end;
$BODY$;

ALTER FUNCTION public.calculate_final_grade()
    OWNER TO postgres;

COMMENT ON FUNCTION public.calculate_final_grade()
    IS '5.3: A trigger function that automatically calculates the final grade and determines whether the student has passed or not.';
