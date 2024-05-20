-- Table: public.Course

-- DROP TABLE IF EXISTS public."Course";

CREATE TABLE IF NOT EXISTS public."Course"
(
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    course_title character(100) COLLATE pg_catalog."default" NOT NULL,
    units smallint NOT NULL,
    lecture_hours smallint NOT NULL,
    tutorial_hours smallint NOT NULL,
    lab_hours smallint NOT NULL,
    typical_year smallint NOT NULL,
    typical_season semester_season_type NOT NULL,
    obligatory boolean NOT NULL,
    course_description character varying COLLATE pg_catalog."default",
    CONSTRAINT "Course_pkey" PRIMARY KEY (course_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Course"
    OWNER to postgres;