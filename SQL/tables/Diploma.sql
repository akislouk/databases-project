-- Table: public.Diploma

-- DROP TABLE IF EXISTS public."Diploma";

CREATE TABLE IF NOT EXISTS public."Diploma"
(
    diploma_num integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    grad_student_amka character varying COLLATE pg_catalog."default" NOT NULL,
    thesis_title character varying COLLATE pg_catalog."default",
    diploma_grade numeric,
    graduation_date date,
    thesis_grade numeric,
    CONSTRAINT "Diploma_pkey" PRIMARY KEY (grad_student_amka, diploma_num),
    CONSTRAINT grad_student_amka_unique UNIQUE (grad_student_amka),
    CONSTRAINT "Diploma_graduateStudent_amka_fkey" FOREIGN KEY (grad_student_amka)
        REFERENCES public."Student" (amka) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Diploma"
    OWNER to postgres;