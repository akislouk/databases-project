-- Table: public.Surname

-- DROP TABLE IF EXISTS public."Surname";

CREATE TABLE IF NOT EXISTS public."Surname"
(
    surname character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Surnames_pkey" PRIMARY KEY (surname)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Surname"
    OWNER to postgres;