-- Table: public.LabTeacher

-- DROP TABLE IF EXISTS public."LabTeacher";

CREATE TABLE IF NOT EXISTS public."LabTeacher"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    labworks integer,
    level level_type NOT NULL,
    CONSTRAINT "LabStaff_pkey" PRIMARY KEY (amka),
    CONSTRAINT "LabStaff_labworks_fkey" FOREIGN KEY (labworks)
        REFERENCES public."Lab" (lab_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "labStaff_person_fkey" FOREIGN KEY (amka)
        REFERENCES public."Person" (amka) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."LabTeacher"
    OWNER to postgres;