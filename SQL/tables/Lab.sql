-- Table: public.Lab

-- DROP TABLE IF EXISTS public."Lab";

CREATE TABLE IF NOT EXISTS public."Lab"
(
    lab_code integer NOT NULL,
    sector_code integer NOT NULL,
    lab_title character(100) COLLATE pg_catalog."default" NOT NULL,
    lab_description character varying COLLATE pg_catalog."default",
    profdirects character varying COLLATE pg_catalog."default",
    CONSTRAINT "Lab_pkey" PRIMARY KEY (lab_code),
    CONSTRAINT "Lab_professor_fkey" FOREIGN KEY (profdirects)
        REFERENCES public."Professor" (amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL
        NOT VALID,
    CONSTRAINT "Lab_sector_code_fkey" FOREIGN KEY (sector_code)
        REFERENCES public."Sector" (sector_code) MATCH FULL
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Lab"
    OWNER to postgres;
-- Index: fk_lab_sector_code

-- DROP INDEX IF EXISTS public.fk_lab_sector_code;

CREATE INDEX IF NOT EXISTS fk_lab_sector_code
    ON public."Lab" USING btree
    (sector_code ASC NULLS LAST)
    TABLESPACE pg_default;