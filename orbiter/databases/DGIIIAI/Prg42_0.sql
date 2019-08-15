-- prg42.0
-- Manages dev opt sessions.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'is_session_dev_test' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg42' ) AS TEXT ) ) )

-- Prg42.0 definition. Delete prg42 if is_session_dev_test = 0.
--------------------------------------------------------------------------------
-- Setup on init.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )

UPDATE sde_wpt SET Status = 'enabled' WHERE ( Status != 'disabled' AND Status != 'enabled' )
	
-- Prg42.0 definition. Enable all pln records loaded on sde_wpt when prg24 is loaded.
--------------------------------------------------------------------------------
3

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg2' ) AS TEXT ) ) ) ) AS B ) WHERE ( A.Value > ( SELECT Value FROM sde_facts WHERE Item = 'delete_order_prg24' ) AND C = 0 )

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg2' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg42.0 definition. Load prg2 if not already loaded, once prg24 has been unloaded.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 10

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_wpt'

-- Prg42.0 definition. Mode wpt = 1 on mode crs counter = 10.
--------------------------------------------------------------------------------
