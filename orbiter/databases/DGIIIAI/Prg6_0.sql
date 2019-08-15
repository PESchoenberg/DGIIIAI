-- prg6.0
-- If mode wpt and mode crs are on, updated tgt parameters used by mode crs as provided by an active flight plan.
--------------------------------------------------------------------------------
1

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_alt' ) WHERE Status='applykbrules' AND Item = 'tgt_alt'	

-- Prg6.0 definition. Update tgt alt with tgt wpt alt data.
--------------------------------------------------------------------------------
2

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_speed' ) WHERE Status='applykbrules' AND Item = 'tgt_speed'	

-- Prg6.0 definition. Update tgt speed with tgt wpt speed data.
--------------------------------------------------------------------------------
3	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = round( ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_brg' ), 0 ) WHERE Status='applykbrules' AND Item = 'tgt_hdg'	

-- Prg6.0 definition. Update tgt hdg with leg_rel_equ_brg data.
--------------------------------------------------------------------------------
