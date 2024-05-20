-- Table: public.Supports

-- DROP TABLE IF EXISTS public."Supports";

CREATE TABLE IF NOT EXISTS public."Supports"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    serial_number integer NOT NULL,
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Supports_pkey" PRIMARY KEY (amka, serial_number, course_code),
    CONSTRAINT "Supports_course_code_fkey" FOREIGN KEY (serial_number, course_code)
        REFERENCES public."CourseRun" (serial_number, course_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Supports_labteacher_fkey" FOREIGN KEY (amka)
        REFERENCES public."LabTeacher" (amka) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Supports"
    OWNER to postgres;