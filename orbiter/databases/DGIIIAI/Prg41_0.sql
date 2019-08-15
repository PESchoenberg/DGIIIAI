-- prg41.0
-- Manages thgroups used on mode trs.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_rst' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_%'	

-- Prg41.0 definition. Resets all thgroup_ facts if thgroup rst = 1.
--------------------------------------------------------------------------------
2 

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_rst' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 1 )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'thgroup_rst'

-- Prg41.0 definition. Set thgroup rst = 0 if thgroup rst = 1.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg41' ) AS TEXT ) ) )

-- Prg41.0 definition. On mode_trs = 0, delete prg41.
--------------------------------------------------------------------------------
-- Setup values.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_thgroup_main'

-- Prg41.0 definition. Main thrusters on, on trs 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_thgroup_retro'

-- Prg41.0 definition. Retro thrusters on, on trs 1.
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'mode_trs' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_thgroup_yaw%'

-- Prg41.0 definition. Yaw thrusters on, on trs 1.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_trs_counter' AND Value > 4	

UPDATE sde_facts SET Value = ( 1 - ( ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' ) * 0.75 / ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) ) ) WHERE Status = 'applykbrules' AND Item = 'factor_thgroup_main'	

-- Prg41.0 definition. Mode hvel definition. Set factor_mode_thgroup_main on crs counter > 4.
--------------------------------------------------------------------------------
8

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_main' ) AS B ) WHERE ( A.Value = 1 AND B.Value > 0.00 )	

UPDATE sde_facts SET Value = 0.00 WHERE Value > 0.00 AND Status = 'applykbrules' AND Item = 'thgroup_retro'	

-- Prg41.0 definition. Sets retro to zero power if main engine is on.
--------------------------------------------------------------------------------
9	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_retro' ) AS B ) WHERE ( A.Value = 1 AND B.Value > 0.00 )

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'retro_doors'	

-- Prg41.0 definition. Open retro doors when retro engines are fired.
--------------------------------------------------------------------------------
10

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_retro' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 0.00 )	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'retro_doors'	

-- Prg41.0 definition. Close retro doors when retro engines are idle.
--------------------------------------------------------------------------------
-- thgroup_att_yaw% management.
--------------------------------------------------------------------------------
11

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) AS B ) WHERE ( A.Value = 1 AND B.Value > 0.00 )

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_att_yawright'

-- Prg41.0 definition. Yaw right if rudder is positive.
--------------------------------------------------------------------------------
12

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) AS B ) WHERE ( A.Value = 1 AND B.Value > 0.00 )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_att_yawleft'

-- Prg41.0 definition. Yaw left zero if rudder is positive.
--------------------------------------------------------------------------------
13

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) AS B ) WHERE ( A.Value = 1 AND B.Value < 0.00 )

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_att_yawleft'

-- Prg41.0 definition. Yaw left if rudder is positive.
--------------------------------------------------------------------------------
14

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) AS B ) WHERE ( A.Value = 1 AND B.Value < 0.00 )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_att_yawright'

-- Prg41.0 definition. Yaw right zero if rudder is positive.
--------------------------------------------------------------------------------
15

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) AS B ) WHERE ( A.Value = 1 AND B.Value = 0.00 )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_att_yaw%'

-- Prg41.0 definition. Yaw left and right to zero if rudder is zero.
--------------------------------------------------------------------------------
-- Ground speed management.
--------------------------------------------------------------------------------
16

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) AS B ) WHERE A.Value < B.Value ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS D ) WHERE D.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_main' ) + ( SELECT Value FROM sde_facts WHERE Item = 'factor_thgroup_main' ) ) WHERE Status = 'applykbrules' AND Item = 'thgroup_main'	

-- Prg41.0 definition. Mode thgroup main definition. Add factor thgroup main to thgroup main.
--------------------------------------------------------------------------------
17

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'vtx1'  ) AS B ) WHERE A.Value > B.Value ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS D ) WHERE D.Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'thgroup_main'

-- Prg41.0 definition. Thgroup main to zero if vtx1 speed is exceeded.
--------------------------------------------------------------------------------
18

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'vtx1'  ) AS B ) WHERE A.Value > B.Value ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS D ) WHERE D.Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'thgroup_retro'

-- Prg41.0 definition. Thgroup retro to zero if vtx1 speed is exceeded.
--------------------------------------------------------------------------------
-- Check min and max values not exceeded.
--------------------------------------------------------------------------------
19

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item LIKE 'thgroup_%' ) AS B ) WHERE ( A.Value = 1 AND B.Value > 1.00 )	

UPDATE sde_facts SET Value = 1.00 WHERE Value > 1.00 Status = 'applykbrules' AND Item LIKE 'thgroup_%'	

-- Prg41.0 definition. Limit thgroup values to max value 1.
--------------------------------------------------------------------------------
20

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item LIKE 'thgroup_%' ) AS B ) WHERE ( A.Value = 1 AND B.Value < 0.00 )	

UPDATE sde_facts SET Value = 0.00 WHERE Value < 0.00 Status = 'applykbrules' AND Item LIKE 'thgroup_%'	

-- Prg41.0 definition. Limit thgroup values to min value 0.
--------------------------------------------------------------------------------
