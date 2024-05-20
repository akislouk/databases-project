-- Table: public.LabModule

-- DROP TABLE IF EXISTS public."LabModule";

CREATE TABLE IF NOT EXISTS public."LabModule"
(
    module_no integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    course_run_serial_number integer NOT NULL,
    type lab_module_type,
    "Title" character varying COLLATE pg_catalog."default",
    max_members smallint,
    percentage numeric,
    has_course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "LabModule_pkey" PRIMARY KEY (has_course_code, course_run_serial_number, module_no),
    CONSTRAINT "LabModule_CourseRun_fkey" FOREIGN KEY (has_course_code, course_run_serial_number)
        REFERENCES public."CourseRun" (course_code, serial_number) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."LabModule"
    OWNER to postgres;