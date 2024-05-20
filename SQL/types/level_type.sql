-- Type: level_type

-- DROP TYPE IF EXISTS public.level_type;

CREATE TYPE public.level_type AS ENUM
    ('A', 'B', 'C', 'D');

ALTER TYPE public.level_type
    OWNER TO postgres;
