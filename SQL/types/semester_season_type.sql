-- Type: semester_season_type

-- DROP TYPE IF EXISTS public.semester_season_type;

CREATE TYPE public.semester_season_type AS ENUM
    ('winter', 'spring');

ALTER TYPE public.semester_season_type
    OWNER TO postgres;
