-- Table: public.Teaches

-- DROP TABLE IF EXISTS public."Teaches";

CREATE TABLE IF NOT EXISTS public."Teaches"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    serial_number integer NOT NULL,
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Teaches_pkey" PRIMARY KEY (amka, serial_number, course_code),
    CONSTRAINT "Teaches_course_code_fkey" FOREIGN KEY (course_code, serial_number)
        REFERENCES public."CourseRun" (course_code, serial_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "Teaches_professor_fkey" FOREIGN KEY (amka)
        REFERENCES public."Professor" (amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Teaches"
    OWNER to postgres;