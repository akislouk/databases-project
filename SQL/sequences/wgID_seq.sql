-- SEQUENCE: public.WorkGroup_wgID_seq

-- DROP SEQUENCE IF EXISTS public."WorkGroup_wgID_seq";

CREATE SEQUENCE IF NOT EXISTS public."WorkGroup_wgID_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."WorkGroup_wgID_seq"
    OWNER TO postgres;

COMMENT ON SEQUENCE public."WorkGroup_wgID_seq"
    IS 'A sequence that increments wgID by 1 when new rows are added.';