-- Table: public.Course_depends

-- DROP TABLE IF EXISTS public."Course_depends";

CREATE TABLE IF NOT EXISTS public."Course_depends"
(
    dependent character(7) COLLATE pg_catalog."default" NOT NULL,
    main character(7) COLLATE pg_catalog."default" NOT NULL,
    mode course_dependency_mode_type,
    CONSTRAINT "Course_depends_pkey" PRIMARY KEY (dependent, main),
    CONSTRAINT dependent FOREIGN KEY (dependent)
        REFERENCES public."Course" (course_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT main FOREIGN KEY (main)
        REFERENCES public."Course" (course_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Course_depends"
    OWNER to postgres;
-- Index: fk_course_depends_dependent

-- DROP INDEX IF EXISTS public.fk_course_depends_dependent;

CREATE INDEX IF NOT EXISTS fk_course_depends_dependent
    ON public."Course_depends" USING btree
    (dependent COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_course_depends_main

-- DROP INDEX IF EXISTS public.fk_course_depends_main;

CREATE INDEX IF NOT EXISTS fk_course_depends_main
    ON public."Course_depends" USING btree
    (main COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;