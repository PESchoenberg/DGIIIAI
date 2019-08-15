-- prg5.0
-- Wpt mode. Load data of a new waypoint on tgt_wpt_continue = 1.
--------------------------------------------------------------------------------
1	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Num FROM sde_wpt WHERE Status = 'enabled' LIMIT 1 ) WHERE Item = 'tgt_wpt_num' 	

-- Prg5.0 definition. Copy data of field Num from first record to sde facts.
--------------------------------------------------------------------------------
2	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Lat FROM sde_wpt WHERE Status = 'enabled' LIMIT 1 ) WHERE Item = 'tgt_wpt_lat'	

-- Prg5.0 definition. Copy data of field Lat from first record to sde facts.
--------------------------------------------------------------------------------
3	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Lon FROM sde_wpt WHERE Status = 'enabled' LIMIT 1 ) WHERE Item = 'tgt_wpt_lon'	

-- Prg5.0 definition. Copy data of field Lon from first record to sde facts.
--------------------------------------------------------------------------------
4	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Alt FROM sde_wpt WHERE Status = 'enabled' LIMIT 1  ) WHERE Item = 'tgt_wpt_alt'	

-- Prg5.0 definition. Copy data of field Alt from first record to sde facts.
--------------------------------------------------------------------------------
5	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Dist FROM sde_wpt WHERE Status = 'enabled' LIMIT 1  ) WHERE Item = 'tgt_wpt_dist' 	

-- Prg5.0 definition. Copy data of field Dist from first record to sde facts.
--------------------------------------------------------------------------------
6	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Time FROM sde_wpt WHERE Status = 'enabled' LIMIT 1  ) WHERE Item = 'tgt_wpt_time'	

-- Prg5.0 definition. Copy data of field Time from first record to sde facts.
--------------------------------------------------------------------------------
7	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Speed FROM sde_wpt WHERE Status = 'enabled' LIMIT 1  ) WHERE Item = 'tgt_wpt_speed'	

-- Prg5.0 definition. Copy data of field Speed from first record to sde facts.
--------------------------------------------------------------------------------
8	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Brg FROM sde_wpt WHERE Status = 'enabled' LIMIT 1  ) WHERE Item = 'tgt_wpt_brg'	

-- Prg5.0 definition. Copy data of field Brg from first record to sde facts.
--------------------------------------------------------------------------------
9

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT MaxRadius FROM sde_wpt WHERE Status = 'enabled' LIMIT 1  ) WHERE Item = 'tgt_wpt_max_radius'	

-- Prg5.0 definition. Copy data of field MaxRadius from first record to sde facts.
--------------------------------------------------------------------------------
10	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_wpt SET Status = 'sentodb' WHERE Num = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_num' )	

-- Prg5.0 definition. Update the status of the wpt record that has just been passed to sde facts.
--------------------------------------------------------------------------------
11

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'tgt_wpt_continue'	

-- Prg5.0 definition. Change the continue flag once wpt data has been loaded.
--------------------------------------------------------------------------------
12	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1		

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg6' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg5.0 definition. Load cur ver prg6.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
13	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg5' ) AS TEXT ) ) )

-- Prg5.0 definition. Delete from sde facts records belonging to cur ver prg5.
--------------------------------------------------------------------------------
