-- Type: lab_module_type

-- DROP TYPE IF EXISTS public.lab_module_type;

CREATE TYPE public.lab_module_type AS ENUM
    ('project', 'lab_exercise');

ALTER TYPE public.lab_module_type
    OWNER TO postgres;
