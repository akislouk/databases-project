-- Type: course_dependency_mode_type

-- DROP TYPE IF EXISTS public.course_dependency_mode_type;

CREATE TYPE public.course_dependency_mode_type AS ENUM
    ('required', 'recommended');

ALTER TYPE public.course_dependency_mode_type
    OWNER TO postgres;
