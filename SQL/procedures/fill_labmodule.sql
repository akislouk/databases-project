-- PROCEDURE: public.fill_labmodule()

-- DROP PROCEDURE IF EXISTS public.fill_labmodule();

CREATE OR REPLACE PROCEDURE public.fill_labmodule(
	)
LANGUAGE 'sql'
AS $BODY$
insert into "LabModule" ("course_run_serial_number", "has_course_code")
select distinct serial_number, course_code
from "Register"
where register_status='approved';

update "LabModule"
set max_members = (round(random() * 2 + 1));
$BODY$;

ALTER PROCEDURE public.fill_labmodule()
    OWNER TO postgres;

COMMENT ON PROCEDURE public.fill_labmodule()
    IS 'A procedure that fills the LabModule table with modules.';
