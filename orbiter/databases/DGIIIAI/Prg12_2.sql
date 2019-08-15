-- prg12.2
-- Main mode wpt management. This version does not delete anything from sde_wpt in
-- order to harmonize with the policies of prg43.2. Prior version, 12.1, had one
-- instruction to delete contents from sde_wpt if no enabled records were present.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_lat' ) WHERE Status='applykbrules' AND Item = 'tgt_rel_equ_lat'	

-- Prg12.2 definition. Mode wpt definition. Update tgt_rel_equ data.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_lon' ) WHERE Status='applykbrules' AND Item = 'tgt_rel_equ_lon'	

-- Prg12.2 definition. Mode wpt definition. Update tgt_rel_equ data.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_alt' ) WHERE Status='applykbrules' AND Item = 'tgt_rel_equ_alt'	

-- Prg12.2 definition. Mode wpt definition. Update tgt_rel_equ data.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'tgt_wpt_continue' AND Value = 1	

-- Prg12.2 definition. Mode wpt definition. If mode wpt is off, set the wpt load flag to zero.
--------------------------------------------------------------------------------
5	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg5' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg12.2 definition. Mode wpt definition. Load cur ver prg5 to load a batch of data for tgt wpt.
--------------------------------------------------------------------------------
6	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_continue' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'tgt_wpt_continue'	

-- Prg12.2 definition. Mode wpt definition. Change tgt wpt loaded flag once cur ver prg has been loaded.
--------------------------------------------------------------------------------
7 *contr 10.1

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_dist' AND Value <= ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_max_radius' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'tgt_wpt_continue' AND Value != 1	

-- Prg12.2 definition. Mode wpt definition. Set to 1 if dist <= tgt wpt max radius.
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'tgt_wpt_continue' AND Value != 0
	
-- Prg12.2 definition. Mode wpt definition. Set tgt wpt continue to zero when mode wpt is off.
--------------------------------------------------------------------------------
9	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_dist' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_max_radius' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'tgt_wpt_continue' AND Value != 0	

-- Prg12.2 definition. Mode wpt definition. Set tgt wpt continue to 0 if dist > tgt wpt max radius (does not need to load wpt data at this point).
--------------------------------------------------------------------------------
10	

SELECT C.Value FROM (SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'submode_pln_load' ) AS B ) WHERE A.Value = 1 AND B.Value != 0 ) AS C JOIN ( SELECT COUNT(*) AS E FROM sde_wpt WHERE Context = ( SELECT ( 'pln' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'submode_pln_load' ) AS TEXT ) ) ) ) AS D WHERE E = 0	

INSERT INTO sde_wpt ( Context, Status, Num, Lat, Lon, Alt, Dist, Time, Speed, Action, Brg, MaxRadius, Next, Item, Value ) SELECT Context, Status, Num, Lat, Lon, Alt, Dist, Time, Speed, Action, Brg, MaxRadius, Next, Item, Value FROM sde_prg_wpt WHERE sde_prg_wpt.Context = ( SELECT ( 'pln' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'submode_pln_load' ) AS TEXT ) ) )	

-- Prg12.2 definition. Submode pln definition. Load sql statements from sde prg wpt.
--------------------------------------------------------------------------------
11

SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' AND Value = 1

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_dist' ) WHERE Status='applykbrules' AND Item = 'tgt_dist'	

-- Prg12.2 definition. Update tgt_dist with leg_rel_equ_dist data when mode wpt is on.
--------------------------------------------------------------------------------