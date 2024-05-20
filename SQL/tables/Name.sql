-- Table: public.Name

-- DROP TABLE IF EXISTS public."Name";

CREATE TABLE IF NOT EXISTS public."Name"
(
    name character varying COLLATE pg_catalog."default" NOT NULL,
    sex character(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Names_pkey" PRIMARY KEY (name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Name"
    OWNER to postgres;