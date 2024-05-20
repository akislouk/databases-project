select course_code, title, grade
from "Joins"
natural join "Workgroup"
natural join "LabModule" sub
where amka = '01010104188'
    and exists
        (select course_code, serial_number
         from "CourseRun" cr
         where sub.course_code = cr.course_code
             and sub.serial_number = cr.serial_number
             and semesterrunsin =
                 (select semester_id
                  from "Semester"
                  where academic_year = 2022
                      and academic_season = 'spring'))
order by course_code asc;
