-- prg0.0
-- Start up contents of sde_rules. These rules are not contained in any other Prg*.sql file and should not be deleted or modified dynamically from sde_rules.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration'	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'is_first_iteration'	

-- Prg0.0. Ship level definition. Update iteration counter.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_hvel'	

-- Prg0.0. Ship level definition. Mode hvel definition. Activate mode_hvel on crs counter = [3,4] to control horiz velocity with main engine.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'mode_prg' AND Value = 1	

UPDATE sde_facts SET Value = 1  WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'submode_prg_counter'	

-- Prg0.0. Ship level definition. Mode prg definition. Start prg counter by setting its value to 1 on mode prg 1.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' AND Value > 0	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' ) + 1 )  WHERE Status = 'applykbrules' AND Item = 'submode_prg_counter'	

-- Prg0.0. Ship level definition. Submode prg definition. Increase counter value if already > 0.
--------------------------------------------------------------------------------
5	

SELECT Value FROM sde_facts WHERE Item LIKE 'submode_prg_rst' AND Value = 1	

UPDATE sde_facts SET Value = 0  WHERE Status = 'applykbrules' AND Item LIKE 'submode_prg_%'	

-- Prg0.0. Ship level definition. Submode prg definition. Reset submode prg.
--------------------------------------------------------------------------------
6

SELECT C.Value FROM (SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_prg' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' AND Value >= 2 ) AS B ) WHERE A.Value = 1 ) AS C JOIN ( SELECT COUNT(*) AS E FROM sde_rules WHERE context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_load' ) AS TEXT ) ) ) ) AS D WHERE E = 0	

INSERT INTO sde_rules (Context, Status, Condition, Action, Description, Prob) SELECT Context, Status, Condition, Action, Description, Prob FROM sde_prg_rules WHERE sde_prg_rules.context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_load' ) AS TEXT ) ) )	

-- Prg0.0. Ship level definition. Submode prg definition. Load sql statements from prg rules.
--------------------------------------------------------------------------------
7	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_prg' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' AND Value >= 2 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0  WHERE Status = 'applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Submode prg definition. Toggle load flag once sql statements have been inserted.
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_end' AND Value > 0.00	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_end' ) AS TEXT ) ) )	

-- Prg0.0. Ship level definition. Submode prg definition. Delete rules with Context matching with submode_prg_end.
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_end' AND Value > 0.00	

DELETE FROM sde_facts WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'submode_prg_end' ) AS TEXT ) ) )	

-- Prg0.0. Ship level definition. Submode prg definition. Delete facts with Context matching with submode_prg_end.
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_end' AND Value > 0.00	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'submode_prg_end'	

-- Prg0.0. Ship level definition. Submode prg definition. Once Context like prg records have been deleted, set submode_prg_end to zero.
--------------------------------------------------------------------------------
11	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value = 1 AND Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg0.0. Ship level definition. Mode rudder definition. Counter to zero on mode rudder zero.
--------------------------------------------------------------------------------
12	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer_counter' AND Value = 0 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg7' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode ailer definition. Set submode prg load to Load prg7.1 on mode ailer = 1 and mode ailer counter = 0.
--------------------------------------------------------------------------------
13	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' AND Value = 0 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg8' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode rudder definition. Set submode prg load to load prg8.0 on mode rudder = 1 and mode rudder counter = 0.
--------------------------------------------------------------------------------
14	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value = 0 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg9' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode hato definition. Set submode prg load to load prg9.0 on mode hato = 1 and mode hato counter = 0.
--------------------------------------------------------------------------------
15	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) AS B ) WHERE A.Value = 1 AND B.Value = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg10' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode crs definition. Set submode prg load to load prg10.1 on mode crs = 1 and mode crs counter = 0.
--------------------------------------------------------------------------------
16

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = 2	

UPDATE sde_facts SET Value = 1 WHERE Value = 0 AND Status='applykbrules' AND Item = 'mode_prg'	

-- Prg0.0. Ship level definition. Mode prg definition. Set to 1 on is first iteration = 2.
--------------------------------------------------------------------------------
17	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' ) AND Value > 2	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg24' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Prg24.2 definition. Load init programs. Set submode prg load to load cur ver prg24 on is_first_iteration = load_order_prg24 and > 2.
--------------------------------------------------------------------------------
18	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'log_evo_rules' ) AS A JOIN ( SELECT COUNT(*) AS Value FROM sde_facts WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg25' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND B.Value = 0 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'delete_order_prg24' ) ) AS D	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg25' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Prg25.0 definition. Log evo rules. Set submode prg load to load cur ver prg25 on log evo rules = 1 and count of prg25 records on sde_rules = 0, and once all setup programs have been loaded.
--------------------------------------------------------------------------------
19	

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0.00	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg29' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Prg29.0 definition. Load on prg to add != 0.
--------------------------------------------------------------------------------
20	

SELECT Value FROM sde_facts WHERE Item = 'mode_navmode_control' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode navmode control, definition. Load prg31.3 on mode navmode control = 1.
--------------------------------------------------------------------------------
21

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg32' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg32' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode make plan definition. Load prg32.0 on mode mode_make_plan = 1 and no copy of prg32 is already present on sde_rules.
--------------------------------------------------------------------------------
22

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg40' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg40' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg0.0. Ship level definition. Load prg40.0 on mode mode_trs = 1 and no copy of prg40 is already present on sde_rules.
--------------------------------------------------------------------------------
23

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg43' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value > 0 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg43' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg0.0. Ship level definition. Load prg43.0 on mode mode_pln_load > 0 and no copy of prg43 is already present on sde_rules.
--------------------------------------------------------------------------------
24

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_wpt WHERE Context = ( SELECT ( 'pln' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'mode_pln_load' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value > 0 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg43' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg0.0. Ship level definition. Load prg43 on mode mode_pln_load > 0 and no copy of plnx is already present on sde_wpt.
--------------------------------------------------------------------------------
25

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_wpt' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg12' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg12' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg0.0. Ship level definition. Load prg12 on mode mode_wpt = 1 and no copy of prg12 is already present on sde_rules.
--------------------------------------------------------------------------------
26

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'is_session_dev_test' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg42' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg42' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg0.0. Ship level definition. Load prg42 on mode mode_wpt =  and no copy of prg42 is already present on sde_rules.
--------------------------------------------------------------------------------
27 See prg44.0 1

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'crew_onb' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg44' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value >= 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg44' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg0.0. Ship level definition. Load prg44 on mode mode_wpt =  and no copy of prg44 is already present on sde_rules.
--------------------------------------------------------------------------------
28	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 50 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_quantum' AND Value = 1 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg46' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg0.0. Ship level definition. Mode quantum definition. Load prg46 if mode crs counter has reached certain level and mode uqantum is 1.

