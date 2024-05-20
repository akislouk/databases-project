-- Table: public.Sector

-- DROP TABLE IF EXISTS public."Sector";

CREATE TABLE IF NOT EXISTS public."Sector"
(
    sector_code integer NOT NULL,
    sector_title character(100) COLLATE pg_catalog."default" NOT NULL,
    sector_description character varying COLLATE pg_catalog."default",
    CONSTRAINT "Sector_pkey" PRIMARY KEY (sector_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Sector"
    OWNER to postgres;