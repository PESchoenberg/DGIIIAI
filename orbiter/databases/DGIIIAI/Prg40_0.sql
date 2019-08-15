-- prg40.0
-- Manages mode_trs.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_trs_counter'	

-- Prg40.0 definition. Reset mode trs counter to zero on mode trs zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_rst'

-- Prg40.0 definition. Reset everything on trs 0.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg40' ) AS TEXT ) ) )

-- Prg40.0 definition. On mode_trs = 0, delete prg40.
--------------------------------------------------------------------------------
-- Setup values.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_trs_counter'	

-- Prg40.0 definition. Increases mode trs counter on mode trs 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' ) + ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' ) ) / 2 ) WHERE Status = 'applykbrules' AND Item = 'tgt_speed'

-- Prg40.0 definition. Set tgt speed = ( vt0 + vt1 ) / 2 on trs counter = [1,2].
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg40.0 definition. Set tgt altitude = altitudeoverground on trs counter = [1,2].
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) WHERE Status = 'applykbrules' AND Item = 'tgt_hdg'	

-- Prg40.0 definition. Set tgt hdg = hdg on trs counter = [1,2].
--------------------------------------------------------------------------------
8

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value = 3	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_rudder'	

-- Prg40.0 definition. Activate mode_rudder on trs counter = 3.
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_prg'	

-- Prg40.0 definition. Activate mode prg on counter = 4.
--------------------------------------------------------------------------------
10

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_dist' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_max_radius' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_wpt'	

-- Prg40.0 definition. Turn mode wpt on if dist to target wpt is higher than max tgt radius.
--------------------------------------------------------------------------------
11

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C > 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_navmode_control'

-- Prg40.0 definition. Mode trs def. Set mode navmode control 1 on count of prg31 records = 0 on sde_rules.
--------------------------------------------------------------------------------
-- Load required programs.
--------------------------------------------------------------------------------
12

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_taxi' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg41' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg41' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg40.0 definition. Load prg41 (Manages thgroups used on mode trs) if not already loaded.
--------------------------------------------------------------------------------
-- Wheel brakes management.
--------------------------------------------------------------------------------
13

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'wheelbrakelevel'

-- Prg41.0 definition. Release wheel brake level on crs counter = 4.
--------------------------------------------------------------------------------
14

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value > 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_yawleft' ) WHERE Status = 'applykbrules' AND Item = 'brakes_r'

-- Prg41.0 definition. Apply to brakes r a braking force proportional to thgroup_att_yawleft value level on crs counter > 4.
--------------------------------------------------------------------------------
15

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value > 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_yawright' ) WHERE Status = 'applykbrules' AND Item = 'brakes_l'

-- Prg41.0 definition. Apply to brakes r a braking force proportional to thgroup_att_yawright value level on crs counter > 4.
--------------------------------------------------------------------------------
-- Wpt management.
--------------------------------------------------------------------------------
