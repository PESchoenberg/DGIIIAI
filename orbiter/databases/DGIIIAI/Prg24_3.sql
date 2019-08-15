-- prg24.3
-- Loads initial batch of programs.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg11' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg11' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode thgroup definition. Set submode prg load to load cur ver prg11 on is_first_iteration = load_order_prg11.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg12' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg12' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode wpt definition. Set submode prg load to load cur ver prg12 on is_first_iteration = load_order_prg12.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg13' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg13' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode rst definition. Set submode prg load to load cur ver prg13 on is_first_iteration = load_order_prg13.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg14' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg14' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode lights definition. Set submode prg load to load cur ver prg14 on is_first_iteration = load_order_prg14.
--------------------------------------------------------------------------------
5	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg15' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg15' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode lights definition. Set submode prg load to load cur ver prg15 on is_first_iteration = load_order_prg15.
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg16' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg16' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode lgear definition. Set submode prg load to load cur ver prg16 on is_first_iteration = load_order_prg16.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg17' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg17' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode extensions definition. Set submode prg load to load cur ver prg17 on is_first_iteration = load_order_prg17.
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg18' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg18' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode doors definition. Set submode prg load to load cur ver prg18 on is_first_iteration = load_order_prg18.
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg19' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg19' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode elev definition. Set submode prg load to load cur ver prg19 on is_first_iteration = load_order_prg19.
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg20' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg20' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Energy system. Set submode prg load to load cur ver prg20 on is_first_iteration = load_order_prg20.
--------------------------------------------------------------------------------
11	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg21' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg21' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Airbrakes. Set submode prg load to load cur ver prg21 on is_first_iteration = load_order_prg21.
--------------------------------------------------------------------------------
12

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg22' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg22' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode taxi. Set submode prg load to load cur ver prg22 on is_first_iteration = load_order_prg22.
--------------------------------------------------------------------------------
13

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg23' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg23' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Mode all rst. Set submode prg load to load cur ver prg23 on is_first_iteration = load_order_prg23.
--------------------------------------------------------------------------------
14

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg31' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg24.3 definition. Navmode management. Set submode prg load to load cur ver prg31 on is_first_iteration = load_order_prg31.
--------------------------------------------------------------------------------
15

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'delete_order_prg24' ) AND Value > 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg24' ) AS TEXT ) ) )

-- Prg24.3 definition. Delete cur ver prg24 on is_first_iteration = delete_order_prg24.
--------------------------------------------------------------------------------
