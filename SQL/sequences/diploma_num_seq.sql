-- SEQUENCE: public.Diploma_diploma_num_seq

-- DROP SEQUENCE IF EXISTS public."Diploma_diploma_num_seq";

CREATE SEQUENCE IF NOT EXISTS public."Diploma_diploma_num_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."Diploma_diploma_num_seq"
    OWNER TO postgres;

COMMENT ON SEQUENCE public."Diploma_diploma_num_seq"
    IS 'A sequence that increments diploma_num by 1 when new rows are added.';