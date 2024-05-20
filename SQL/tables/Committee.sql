-- Table: public.Committee

-- DROP TABLE IF EXISTS public."Committee";

CREATE TABLE IF NOT EXISTS public."Committee"
(
    diploma_num integer NOT NULL,
    grad_student_amka character varying COLLATE pg_catalog."default" NOT NULL,
    professor_amka character varying COLLATE pg_catalog."default" NOT NULL,
    supervisor boolean NOT NULL,
    CONSTRAINT "Commitee_pkey" PRIMARY KEY (diploma_num, grad_student_amka, professor_amka),
    CONSTRAINT "Commitee_diploma_fkey" FOREIGN KEY (diploma_num, grad_student_amka)
        REFERENCES public."Diploma" (diploma_num, grad_student_amka) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Commitee_professor_fkey" FOREIGN KEY (professor_amka)
        REFERENCES public."Professor" (amka) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Committee"
    OWNER to postgres;

-- Trigger: verify_max_members

-- DROP TRIGGER IF EXISTS verify_max_members ON public."Committee";

CREATE TRIGGER verify_max_members
    BEFORE INSERT OR UPDATE OF diploma_num
    ON public."Committee"
    FOR EACH ROW
    EXECUTE FUNCTION public.check_members_com();