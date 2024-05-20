-- Type: semester_status_type

-- DROP TYPE IF EXISTS public.semester_status_type;

CREATE TYPE public.semester_status_type AS ENUM
    ('past', 'present', 'future');

ALTER TYPE public.semester_status_type
    OWNER TO postgres;
