-- Table: public.DiplomaTitles

-- DROP TABLE IF EXISTS public."DiplomaTitles";

CREATE TABLE IF NOT EXISTS public."DiplomaTitles"
(
    title character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."DiplomaTitles"
    OWNER to postgres;