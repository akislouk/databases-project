-- View: public.committee_view

-- DROP VIEW public.committee_view;

CREATE OR REPLACE VIEW public.committee_view
 AS
 SELECT com.professor_amka AS "ΑΜΚΑ",
    ( SELECT ("Person".surname::text || ' '::text) || "Person".name::text
           FROM "Person"
          WHERE "Person".amka::text = com.professor_amka::text) AS "Επιτροπή"
   FROM "Committee" com
  WHERE (EXISTS ( SELECT dip.grad_student_amka
           FROM "Diploma" dip
          WHERE com.grad_student_amka::text = dip.grad_student_amka::text AND (dip.graduation_date IS NULL OR dip.graduation_date > CURRENT_DATE)))
  ORDER BY com.diploma_num, com.supervisor DESC;

ALTER TABLE public.committee_view
    OWNER TO postgres;
COMMENT ON VIEW public.committee_view
    IS '6.1: A view of the committee members of committees whose student hasn''t graduated yet.';

