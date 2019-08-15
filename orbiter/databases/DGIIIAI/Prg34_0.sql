-- prg34.0
-- Manages mode make plan taxi.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 0

UPDATE sde_wpt SET Status = 'enabled' WHERE Status = 'standby'

-- Prg34.0 definition. Re enable records put on standby on sde_wpt.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 0

UPDATE sde_wpt SET Status = 'standby' WHERE ( Status = 'enabled' AND Altitude = 0.00 )

-- Prg34.0 definition. Put on standby records on sde_wpt that correspond to taxi navigation and were enabled.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg34' ) AS TEXT ) ) )

-- Prg34.0 definition. On mode_make_plan_taxi = 0, delete prg34.
--------------------------------------------------------------------------------
-- Setup on init.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 1

UPDATE sde_wpt SET Status = 'standby' WHERE ( Status = 'enabled' AND Altitude > 0.00 )

-- Prg34.0 definition. Put on standby records on sde_wpt that do not correspond to taxi navigation and were enabled. This assumes that the ship first will do land navigation to the initial TO point.
--------------------------------------------------------------------------------
5

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 1 ) AS B WHERE ( A = 0 AND B.Value = 1 ) 

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_rst'

-- Prg34.0 definition. Set mode rst = 1 to reset ship if mode make plan taxi = 1 and prg14 has not been loaded yet; this is done in order to have too many resets during execution of prg34.
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_trs'

-- Prg34.0 definition. set mode trs on when mode mode plan taxi is on.
--------------------------------------------------------------------------------
-- Load programs required at this stage.
--------------------------------------------------------------------------------
7

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg34.0 definition. Load prg14 (external lights) if not already loaded.
--------------------------------------------------------------------------------
8

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg22' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg22' ) AS TEXT ) ) ) WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_load'

-- Prg34.0 definition. Load prg22 (manages mode taxi) if not already loaded.
--------------------------------------------------------------------------------
-- Create closing conditions and finish up.
--------------------------------------------------------------------------------
9

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'go_for_taxi'

-- Prg34.0 definition. Set go_for_preflight = 1 on each cycle to test for all programs loaded.
--------------------------------------------------------------------------------
10

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_taxi'

-- Prg34.0 definition. Test if prg14 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
11

SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg22' ) AS TEXT ) ) ) ) WHERE A = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'go_for_taxi'

-- Prg34.0 definition. Test if prg22 has been loaded. If not, change go_for_preflight to zero.
--------------------------------------------------------------------------------
12

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS B ) WHERE A.Value = B.Value ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) AS D

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'go_for_taxi'

-- Prg34.0 definition. Requires reaching the wpt where to will initiate.
--------------------------------------------------------------------------------
13

SELECT Value FROM sde_facts WHERE Item = 'go_for_taxi' AND Value = 1

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_make_plan_taxi'

-- Prg34.0 definition. If go has been given, therefore the plan stage is finished.
--------------------------------------------------------------------------------
14

SELECT Value FROM sde_facts WHERE Item = 'go_for_taxi' AND Value = 1

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_trs'

-- Prg34.0 definition. If go has been given, mode trs = 0.
--------------------------------------------------------------------------------
