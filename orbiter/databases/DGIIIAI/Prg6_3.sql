-- prg6.3
-- If mode wpt and mode crs are on, updated tgt parameters used by mode crs as provided by an active flight plan. Operations valid for modes crs, trs and hato.
--------------------------------------------------------------------------------
1

SELECT C.Value FROM ( ( SELECT A FROM ( SELECT COUNT(*) AS A FROM sde_wpt WHERE Status = 'enabled' ) ) AS B JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' OR Item = 'mode_trs' ) AS C ) WHERE A = 0 AND C.Value = 1

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'mode_wpt'	

-- Prg6.3 definition. Inhibit mode wpt if mode wpt is on but no enabled records are found at sde_wpt.
--------------------------------------------------------------------------------
2

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' OR Item = 'mode_trs' OR Item = 'mode_hato' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_alt' ) WHERE Status='applykbrules' AND Item = 'tgt_alt'	

-- Prg6.3 definition. Update tgt alt with tgt wpt alt data.
--------------------------------------------------------------------------------
3

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' OR Item = 'mode_trs' OR Item = 'mode_hato' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_speed' ) WHERE Status='applykbrules' AND Item = 'tgt_speed'	

-- Prg6.3 definition. Update tgt speed with tgt wpt speed data.
--------------------------------------------------------------------------------
4	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' OR Item = 'mode_trs' OR Item = 'mode_hato' ) AS B ) WHERE A.Value = 1 AND B.Value = 1	

UPDATE sde_facts SET Value = round( ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_brg' ), 0 ) WHERE Status='applykbrules' AND Item = 'tgt_hdg'	

-- Prg6.3 definition. Update tgt hdg with leg_rel_equ_brg data.
--------------------------------------------------------------------------------
