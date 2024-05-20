-- Type: rank_type

-- DROP TYPE IF EXISTS public.rank_type;

CREATE TYPE public.rank_type AS ENUM
    ('full', 'associate', 'assistant', 'lecturer');

ALTER TYPE public.rank_type
    OWNER TO postgres;
