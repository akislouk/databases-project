-- Table: public.Field

-- DROP TABLE IF EXISTS public."Field";

CREATE TABLE IF NOT EXISTS public."Field"
(
    code character(3) COLLATE pg_catalog."default" NOT NULL,
    title character(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Fields_pkey" PRIMARY KEY (code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Field"
    OWNER to postgres;