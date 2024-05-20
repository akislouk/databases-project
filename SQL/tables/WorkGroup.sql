-- Table: public.WorkGroup

-- DROP TABLE IF EXISTS public."WorkGroup";

CREATE TABLE IF NOT EXISTS public."WorkGroup"
(
    "wgID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    grade numeric,
    implements_module_no integer NOT NULL,
    implements_serial_number integer NOT NULL,
    implements_course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "WorkGroup_pkey" PRIMARY KEY ("wgID", implements_module_no, implements_serial_number, implements_course_code),
    CONSTRAINT "WorkGroup_LabModule_fkey" FOREIGN KEY (implements_module_no, implements_course_code, implements_serial_number)
        REFERENCES public."LabModule" (module_no, has_course_code, course_run_serial_number) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."WorkGroup"
    OWNER to postgres;