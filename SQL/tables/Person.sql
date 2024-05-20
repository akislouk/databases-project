-- Table: public.Person

-- DROP TABLE IF EXISTS public."Person";

CREATE TABLE IF NOT EXISTS public."Person"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    father_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    surname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    email character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT "Person_pkey" PRIMARY KEY (amka)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Person"
    OWNER to postgres;