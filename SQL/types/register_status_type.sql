-- Type: register_status_type

-- DROP TYPE IF EXISTS public.register_status_type;

CREATE TYPE public.register_status_type AS ENUM
    ('proposed', 'requested', 'approved', 'rejected', 'pass', 'fail');

ALTER TYPE public.register_status_type
    OWNER TO postgres;
