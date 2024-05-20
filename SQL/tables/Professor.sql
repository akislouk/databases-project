-- Table: public.Professor

-- DROP TABLE IF EXISTS public."Professor";

CREATE TABLE IF NOT EXISTS public."Professor"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    labjoins integer,
    rank rank_type NOT NULL,
    CONSTRAINT "Professor_pkey" PRIMARY KEY (amka),
    CONSTRAINT "Professor_labJoins_fkey" FOREIGN KEY (labjoins)
        REFERENCES public."Lab" (lab_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Professor_person_fkey" FOREIGN KEY (amka)
        REFERENCES public."Person" (amka) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Professor"
    OWNER to postgres;