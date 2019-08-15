-- prg43.1
-- Manages and loads or deletes flightplans from sde_prg_wpt into sde_wpt. Deletes inactive flightplans. Reset and end flags are toggled via prg13. Deletion is achieved via a rst fact flag. This should be used as the unique mechanism for deleting plans from sde_wpt. This is a test version; stable, but with plan loading not functional is 43.0.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT C FROM ( SELECT COUNT(*) AS C FROM sde_wpt WHERE Status != 'enabled' ) WHERE C > 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_pln_rst'

-- Prg43.1 definition. If no enabled records exist on sde_wpt, set mode plan rst flag to 1.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_pln_rst' AND Value = 1

DELETE FROM sde_wpt WHERE Status != 'enabled'

-- Prg43.1 definition. Delete contents of sde_wpt if pln is reset.
--------------------------------------------------------------------------------
3

SELECT C FROM ( SELECT COUNT(*) AS C FROM sde_wpt WHERE Status != 'enabled' ) WHERE C = 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item LIKE 'mode_pln_rst'

-- Prg43.1 definition. Set mode pln% 0 if no enabled records exist on sde_wpt.
--------------------------------------------------------------------------------
4

SELECT 1 FROM ( ( SELECT 1 FROM ( SELECT COUNT(*) AS C FROM sde_wpt WHERE Status = 'enabled' ) WHERE C = 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS B ) WHERE B.Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg43' ) AS TEXT ) ) )

-- Prg43.1 definition. Delete prg43 if no enabled records exist on sde_wpt and no  pln is required to be loaded at the moment.
--------------------------------------------------------------------------------
-- Load pln if not present on sde wpt.
--------------------------------------------------------------------------------
5

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_wpt WHERE Context = ( SELECT ( 'pln' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value > 0 AND C = 0

INSERT INTO sde_wpt ( Context, Status, Num, Lat, Lon, Alt, Dist, Time, Speed, Action, Brg, MaxRadius, Next, Item, Value ) SELECT Context, Status, Num, Lat, Lon, Alt, Dist, Time, Speed, Action, Brg, MaxRadius, Next, Item, Value FROM sde_prg_wpt WHERE sde_prg_wpt.Context = ( SELECT ( 'pln' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS TEXT ) ) )

-- Prg43.1 definition. Load a pln into sde_wpt from sde_prg wpt if mode plan load > 0 and the pln in question has not been loaded yet. 
--------------------------------------------------------------------------------
6

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_wpt WHERE Context = ( SELECT ( 'pln' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value > 0 AND C > 0

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_pln_load'

-- Prg43.1 definition. If pln requested has already been loaded into sde wpt, change the mode pln load fact to 0.
--------------------------------------------------------------------------------
