-- Table: public.Register

-- DROP TABLE IF EXISTS public."Register";

CREATE TABLE IF NOT EXISTS public."Register"
(
    amka character varying COLLATE pg_catalog."default" NOT NULL,
    serial_number integer NOT NULL,
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    exam_grade numeric,
    final_grade numeric,
    lab_grade numeric,
    register_status register_status_type,
    CONSTRAINT "Register_pkey" PRIMARY KEY (course_code, serial_number, amka),
    CONSTRAINT "Register_course_run_fkey" FOREIGN KEY (course_code, serial_number)
        REFERENCES public."CourseRun" (course_code, serial_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "Register_student_fkey" FOREIGN KEY (amka)
        REFERENCES public."Student" (amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Register"
    OWNER to postgres;

-- Trigger: calculate_final_grade

-- DROP TRIGGER IF EXISTS calculate_final_grade ON public."Register";

CREATE TRIGGER calculate_final_grade
    BEFORE INSERT OR UPDATE OF exam_grade, final_grade, lab_grade, register_status
    ON public."Register"
    FOR EACH ROW
    WHEN (new.exam_grade IS NOT NULL OR new.final_grade IS NOT NULL OR new.lab_grade IS NOT NULL OR new.register_status IS NULL OR new.register_status = 'pass'::register_status_type OR new.register_status = 'fail'::register_status_type)
    EXECUTE FUNCTION public.calculate_final_grade();

-- Trigger: check_requests

-- DROP TRIGGER IF EXISTS check_requests ON public."Register";

CREATE TRIGGER check_requests
    BEFORE INSERT OR UPDATE OF register_status
    ON public."Register"
    FOR EACH ROW
    WHEN (new.register_status IS NOT NULL AND new.register_status <> 'proposed'::register_status_type AND new.register_status <> 'pass'::register_status_type AND new.register_status <> 'fail'::register_status_type)
    EXECUTE FUNCTION public.check_requests();