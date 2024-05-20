-- Table: public.Joins

-- DROP TABLE IF EXISTS public."Joins";

CREATE TABLE IF NOT EXISTS public."Joins"
(
    student_amka character varying COLLATE pg_catalog."default" NOT NULL,
    "wgID" integer NOT NULL,
    work_group_module_no integer NOT NULL,
    work_group_serial_number integer NOT NULL,
    work_group_course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Joins_pkey" PRIMARY KEY (student_amka, "wgID", work_group_module_no, work_group_serial_number, work_group_course_code),
    CONSTRAINT "Joins_student_fkey" FOREIGN KEY (student_amka)
        REFERENCES public."Student" (amka) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Joins_workgroup_fkey" FOREIGN KEY (work_group_serial_number, "wgID", work_group_course_code, work_group_module_no)
        REFERENCES public."WorkGroup" (implements_serial_number, "wgID", implements_course_code, implements_module_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Joins"
    OWNER to postgres;

-- Trigger: verify_max_members

-- DROP TRIGGER IF EXISTS verify_max_members ON public."Joins";

CREATE TRIGGER verify_max_members
    BEFORE INSERT OR UPDATE OF "wgID", work_group_module_no
    ON public."Joins"
    FOR EACH ROW
    EXECUTE FUNCTION public.check_members_wg();