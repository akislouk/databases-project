-- Table: public.CourseRun

-- DROP TABLE IF EXISTS public."CourseRun";

CREATE TABLE IF NOT EXISTS public."CourseRun"
(
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    serial_number integer NOT NULL,
    exam_min numeric,
    lab_min numeric,
    exam_percentage numeric,
    labuses integer,
    semesterrunsin integer NOT NULL,
    CONSTRAINT "CourseRun_pkey" PRIMARY KEY (course_code, serial_number),
    CONSTRAINT "CourseRun_course_code_fkey" FOREIGN KEY (course_code)
        REFERENCES public."Course" (course_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CourseRun_labuses_fkey" FOREIGN KEY (labuses)
        REFERENCES public."Lab" (lab_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CourseRun_semesterrunsin_fkey" FOREIGN KEY (semesterrunsin)
        REFERENCES public."Semester" (semester_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."CourseRun"
    OWNER to postgres;