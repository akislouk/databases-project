-- Table: public.Student

-- DROP TABLE IF EXISTS public."Student";

CREATE TABLE IF NOT EXISTS public."Student"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    am character(10) COLLATE pg_catalog."default",
    entry_date date,
    CONSTRAINT "Student_pkey" PRIMARY KEY (amka),
    CONSTRAINT "Student_am_key" UNIQUE (am),
    CONSTRAINT student_fkey1 FOREIGN KEY (amka)
        REFERENCES public."Person" (amka) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Student"
    OWNER to postgres;