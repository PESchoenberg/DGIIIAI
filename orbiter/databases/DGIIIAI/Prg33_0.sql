-- prg33.0
-- Manages mode make plan preflight.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg33' ) AS TEXT ) ) )

-- Prg33.0 definition. On mode mode_make_plan_taxi = 0, delete prg33.
--------------------------------------------------------------------------------
-- Load programs required at this stage.
--------------------------------------------------------------------------------
2

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg13' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg13' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg13 (reset) if not already loaded.
--------------------------------------------------------------------------------
3

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg23' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg23' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg23 (resets most modes) if not already loaded.
--------------------------------------------------------------------------------
4

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' AND Value = 1 ) AS B WHERE ( A = 0 AND B.Value = 1 ) 

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_rst'

-- Prg33.0 definition. Set mode rst = 1 to reset ship if mode make pal preflight = 1 and prg14 has not been loaded yet; this is done in order to have too many resets during execution of prg33.
--------------------------------------------------------------------------------
5

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg14 (external lights) if not already loaded.
--------------------------------------------------------------------------------
6

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg15' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg15' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg15 (standard speeds) if not already loaded.
--------------------------------------------------------------------------------
7

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg16' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg16' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg16 (landing gear) if not already loaded.
--------------------------------------------------------------------------------
8

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg17' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg17' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg17 (mode_extensions_close) if not already loaded.
--------------------------------------------------------------------------------
9

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg18' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg18' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg18 (mode_doors_close) if not already loaded.
--------------------------------------------------------------------------------
10

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg19' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg19' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg19 (manages elev and elev_t) if not already loaded.
--------------------------------------------------------------------------------
11

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg20' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg20' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg20 (manages energy) if not already loaded.
--------------------------------------------------------------------------------
12

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg21' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg21' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg33.0 definition. Load prg21 (manages airspeed) if not already loaded.
--------------------------------------------------------------------------------
-- Wheel brakes management.
--------------------------------------------------------------------------------
13

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' AND Value = 1

UPDATE sde_facts SET Value = 1.00 WHERE Status = 'applykbrules' AND Item = 'wheelbrakelevel'

-- Prg33.0 definition. Set wheelbrakelevel to 1.
--------------------------------------------------------------------------------
-- Create closing conditions and finish up.
--------------------------------------------------------------------------------
14

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_preflight' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Set go_for_preflight = 1 on each cycle to test for all programs loaded.
--------------------------------------------------------------------------------
15

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg13' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg13 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
16

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg23' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg23 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
17

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg14 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
18

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg15' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg15 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
19

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg16' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg16 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
20

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg17' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg17 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
21

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg18' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg18 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
22

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg19' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg19 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
23

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg20' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg20 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
24

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg21' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_preflight'

-- Prg33.0 definition. Test if prg21 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
25

SELECT Value FROM sde_facts WHERE Item = 'go_for_preflight' AND Value = 1

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_preflight'

-- Prg33.0 definition. If go has been given, therefore the plan stage is finished.
--------------------------------------------------------------------------------
