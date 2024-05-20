-- Table: public.Covers

-- DROP TABLE IF EXISTS public."Covers";

CREATE TABLE IF NOT EXISTS public."Covers"
(
    lab_code integer NOT NULL,
    field_code character(3) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Lab_fields_pkey" PRIMARY KEY (field_code, lab_code),
    CONSTRAINT "Lab_fields_field_code_fkey" FOREIGN KEY (field_code)
        REFERENCES public."Field" (code) MATCH FULL
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Lab_fields_lab_code_fkey" FOREIGN KEY (lab_code)
        REFERENCES public."Lab" (lab_code) MATCH FULL
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Covers"
    OWNER to postgres;
-- Index: fk_lab_field_lab_code

-- DROP INDEX IF EXISTS public.fk_lab_field_lab_code;

CREATE INDEX IF NOT EXISTS fk_lab_field_lab_code
    ON public."Covers" USING btree
    (lab_code ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_lab_fields_field_code

-- DROP INDEX IF EXISTS public.fk_lab_fields_field_code;

CREATE INDEX IF NOT EXISTS fk_lab_fields_field_code
    ON public."Covers" USING btree
    (field_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;