-- View: public.stud_wo_thesis

-- DROP VIEW public.stud_wo_thesis;

CREATE OR REPLACE VIEW public.stud_wo_thesis
 AS
 SELECT DISTINCT "Semester".academic_year AS "έτος",
    ( SELECT count(*) AS count
           FROM "Student" s
          WHERE date_part('year'::text, s.entry_date) = "Semester".academic_year::double precision AND (( SELECT count(*) AS count
                   FROM "Register" r
                  WHERE s.amka::text = r.amka::text AND r.register_status = 'pass'::register_status_type)) >= (( SELECT "School Rules".min_courses
                   FROM "School Rules"
                  WHERE "School Rules".year::double precision = date_part('year'::text, s.entry_date))) AND (( SELECT sum(crs.units) AS sum
                   FROM "Course" crs
                  WHERE (EXISTS ( SELECT r.course_code
                           FROM "Register" r
                          WHERE s.amka::text = r.amka::text AND r.register_status = 'pass'::register_status_type AND crs.course_code = r.course_code)))) >= (( SELECT "School Rules".min_units
                   FROM "School Rules"
                  WHERE "School Rules".year::double precision = date_part('year'::text, s.entry_date))) AND NOT (EXISTS ( SELECT "Diploma".diploma_num,
                    "Diploma".grad_student_amka,
                    "Diploma".thesis_title,
                    "Diploma".diploma_grade,
                    "Diploma".graduation_date,
                    "Diploma".thesis_grade
                   FROM "Diploma"
                  WHERE s.amka::text = "Diploma".grad_student_amka::text AND "Diploma".thesis_grade IS NOT NULL))) AS "πλήθος"
   FROM "Semester"
  WHERE (date_part('year'::text, CURRENT_DATE) - "Semester".academic_year::double precision) < 10::double precision
  ORDER BY "Semester".academic_year DESC;

ALTER TABLE public.stud_wo_thesis
    OWNER TO postgres;
COMMENT ON VIEW public.stud_wo_thesis
    IS '6.2: A view of the students who entered in the last 10 years and who are eligible to graduate but have not completed their thesis yet.';

