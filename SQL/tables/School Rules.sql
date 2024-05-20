-- Table: public.School Rules

-- DROP TABLE IF EXISTS public."School Rules";

CREATE TABLE IF NOT EXISTS public."School Rules"
(
    year numeric(4,0) NOT NULL,
    committee_members_no smallint NOT NULL DEFAULT 3,
    min_units integer NOT NULL DEFAULT 180,
    min_courses integer NOT NULL DEFAULT 50,
    CONSTRAINT "School Rules_pkey" PRIMARY KEY (year)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."School Rules"
    OWNER to postgres;