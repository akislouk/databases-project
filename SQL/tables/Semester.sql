-- Table: public.Semester

-- DROP TABLE IF EXISTS public."Semester";

CREATE TABLE IF NOT EXISTS public."Semester"
(
    semester_id integer NOT NULL,
    academic_year integer,
    academic_season semester_season_type,
    start_date date,
    end_date date,
    semester_status semester_status_type NOT NULL,
    CONSTRAINT "Semester_pkey" PRIMARY KEY (semester_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Semester"
    OWNER to postgres;

-- Trigger: calculate_year_season

-- DROP TRIGGER IF EXISTS calculate_year_season ON public."Semester";

CREATE TRIGGER calculate_year_season
    BEFORE INSERT OR UPDATE OF start_date, end_date
    ON public."Semester"
    FOR EACH ROW
    EXECUTE FUNCTION public.calculate_year_season();

-- Trigger: create_future_courses

-- DROP TRIGGER IF EXISTS create_future_courses ON public."Semester";

CREATE TRIGGER create_future_courses
    AFTER INSERT
    ON public."Semester"
    FOR EACH ROW
    EXECUTE FUNCTION public.create_future_courses();