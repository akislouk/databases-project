insert into "LabModule" values('ΠΛΗ 101', 12, 49, 'lab_exercise', 'ΠΛΗ 101 12 LabModule Title 49', max_mem, perc);
insert into "Workgroup" values('ΠΛΗ 101', 12, 49, 1, 5);

select coalesce(max(module_no), 0) + 1 from "LabModule" where course_code = 'ΠΛΗ 101' and serial_number = 12;
select coalesce(max("wgID"), 0) + 1 from "Workgroup" where course_code = 'ΠΛΗ 101' and serial_number = 12;
