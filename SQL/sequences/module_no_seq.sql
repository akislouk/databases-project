-- SEQUENCE: public.LabModule_module_no_seq

-- DROP SEQUENCE IF EXISTS public."LabModule_module_no_seq";

CREATE SEQUENCE IF NOT EXISTS public."LabModule_module_no_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."LabModule_module_no_seq"
    OWNER TO postgres;

COMMENT ON SEQUENCE public."LabModule_module_no_seq"
    IS 'A sequence that increments module_no by 1 when new rows are added.';