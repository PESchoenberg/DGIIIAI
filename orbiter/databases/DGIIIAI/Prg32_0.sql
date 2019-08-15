-- prg32.0
-- Planner manager. 
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan' AND Value = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item LIKE 'mode_make_plan%'

-- Prg32.0 definition. On mode make plan = 0, set all mode make plan* facts to zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan' AND Value = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item LIKE 'go_for_%'

-- Prg32.0 definition. On mode make plan = 0, set all go for* facts to zero.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg32' ) AS TEXT ) ) )

-- Prg32.0 definition. On mode make plan, delete prg32.
--------------------------------------------------------------------------------
-- Setting mode_make_plan* facts according to conditions.
--------------------------------------------------------------------------------
4 

SELECT D FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_stop' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 ) ) AS C JOIN ( SELECT COUNT(*) AS D FROM sde_facts WHERE Item LIKE 'mode_make_plan_%' AND Value = 1 ) AS D ) WHERE D = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_preflight'

-- Prg32.0 definition. If mode make plan = 1 and the ship is stopped (landed or docked) and no other mode_make_plan_% is 1, set mode make plan preflight = 1 in order to start the planning cycle with a preflight check.
--------------------------------------------------------------------------------
5

SELECT D FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_stop' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 0 ) ) AS C JOIN ( SELECT COUNT(*) AS D FROM sde_facts WHERE Item LIKE 'mode_make_plan_%' AND Value = 1 ) AS D ) WHERE D = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg32.0 definition. If mode make plan = 1 and the ship is not stopped (landed or docked), and no other mode_make_plan is 1, assume it is flying so no pre flight check will be performed. It is assumed correct and thus a go for preflight 1 is given.
--------------------------------------------------------------------------------
6

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_preflight' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_taxi'

-- Prg32.0 definition. On go for preflight = 1 mode make plan taxi = 1.
--------------------------------------------------------------------------------
7

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_taxi' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_to'

-- Prg32.0 definition. On go for taxi = 1 mode make plan to = 1.
--------------------------------------------------------------------------------
8

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_to' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_flight'

-- Prg32.0 definition. On go for to = 1 mode make plan flight = 1.
--------------------------------------------------------------------------------
9

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_flight' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_approach'

-- Prg32.0 definition. On go for flight = 1 mode make plan approach = 1.
--------------------------------------------------------------------------------
10

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_approach' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_td'

-- Prg32.0 definition. On go for approach = 1 mode make plan td = 1.
--------------------------------------------------------------------------------
11

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_td' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_taxi'

-- Prg32.0 definition. On go for td = 1 mode make plan taxi = 1.
--------------------------------------------------------------------------------
12

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_taxi' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_postflight'

-- Prg32.0 definition. On go for taxi = 1 mode make plan postflight = 1.
--------------------------------------------------------------------------------
13

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'go_for_postflight' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan'

-- Prg32.0 definition. On go for postflight = 1 mode make plan = 0. Change mode make plan to 0 once plan has been made.
--------------------------------------------------------------------------------
-- Refreshing modes that need to be active.
--------------------------------------------------------------------------------
14

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_make_plan' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 0 )

UPDATE sde_facts SET Value = 1 WHERE Value = 0 AND Status='applykbrules' AND Item = 'mode_prg'

-- Prg32.0 definition. Set mode prg to 1 on each iteration if mode make plan = 1.
--------------------------------------------------------------------------------
-- Loading programs according to active mode_make_plan* facts.
--------------------------------------------------------------------------------
15

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg33' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg33' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan preflight definition. Load prg33.0 on mode mode_make_plan_preflight = 1 and no copy of prg33 is already present on sde_facts.
--------------------------------------------------------------------------------
16

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg34' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg34' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan taxi definition. Load prg34.0 on mode mode_make_plan_taxi = 1 and no copy of prg34 is already present on sde_facts.
--------------------------------------------------------------------------------
17

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_to' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg35' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg35' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan to. Load prg35.0 on mode mode_make_plan_to = 1 and no copy of prg35 is already present on sde_facts.
--------------------------------------------------------------------------------
18

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_flight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg36' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg36' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan flight. Load prg36.0 on mode mode_make_plan_flight = 1 and no copy of prg36 is already present on sde_facts.
--------------------------------------------------------------------------------
19

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_approach' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg37' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg37' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan approach. Load prg37.0 on mode mode_make_plan_approach = 1 and no copy of prg37 is already present on sde_facts.
--------------------------------------------------------------------------------
20

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_td' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg38' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg38' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan td. Load prg38.0 on mode mode_make_plan_td = 1 and no copy of prg38 is already present on sde_facts.
--------------------------------------------------------------------------------
21

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_postflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg39' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg39' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg32.0 definition. Mode make plan postflight. Load prg39.0 on mode mode_make_plan_postflight = 1 and no copy of prg39 is already present on sde_facts.
--------------------------------------------------------------------------------
