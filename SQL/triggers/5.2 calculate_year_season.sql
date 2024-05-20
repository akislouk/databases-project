-- FUNCTION: public.calculate_year_season()

-- DROP FUNCTION IF EXISTS public.calculate_year_season();

CREATE OR REPLACE FUNCTION public.calculate_year_season()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
if new.end_date is not null then
    new.academic_year = date_part('year', new.end_date);
    new.academic_season = 
        case 
            when date_part('month', new.end_date) between 1 and 3 then 'winter'
            when date_part('month', new.end_date) between 5 and 7 then 'spring'
            else null
        end;
else
    if date_part('month', new.start_date) between 8 and 11 then
        new.academic_season = 'winter';
        new.academic_year = date_part('year', new.start_date) + 1;
    elsif date_part('month', new.start_date) between 1 and 4 then
        new.academic_season = 'spring';
        new.academic_year = date_part('year', new.start_date);
    else
        new.academic_season = null;
        new.academic_year = null;
    end if;
end if;
return new;
end;
$BODY$;

ALTER FUNCTION public.calculate_year_season()
    OWNER TO postgres;

COMMENT ON FUNCTION public.calculate_year_season()
    IS '5.2: A trigger function that automatically calculates a semester''s academic year and season.';
