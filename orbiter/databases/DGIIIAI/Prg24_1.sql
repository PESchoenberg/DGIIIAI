-- prg24.1
-- Loads initial batch of programs.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg11' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 11.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode thgroup definition. Set submode prg load to load prg11.0 on is_first_iteration = load_order_prg11.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg12' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 12.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode wpt definition. Set submode prg load to load prg12.0 on is_first_iteration = load_order_prg12.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg13' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 13.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode rst definition. Set submode prg load to load prg13.0 on is_first_iteration = load_order_prg13.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg14' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 14.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode lights definition. Set submode prg load to load prg14.0 on is_first_iteration = load_order_prg14.
--------------------------------------------------------------------------------
5	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg15' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 15.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode lights definition. Set submode prg load to load prg15.0 on is_first_iteration = load_order_prg15.
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg16' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 16.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode lgear definition. Set submode prg load to load prg16.0 on is_first_iteration = load_order_prg16.
--------------------------------------------------------------------------------
7	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg17' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 17.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode extensions definition. Set submode prg load to load prg17.0 on is_first_iteration = load_order_prg17.
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg18' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 18.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode doors definition. Set submode prg load to load prg18.0 on is_first_iteration = load_order_prg18.
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg19' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 19.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode elev definition. Set submode prg load to load prg19.0 on is_first_iteration = load_order_prg19.
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg20' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 20.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Energy system. Set submode prg load to load prg20.0 on is_first_iteration = load_order_prg20.
--------------------------------------------------------------------------------
11	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg21' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 21.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Airbrakes. Set submode prg load to load prg21.0 on is_first_iteration = load_order_prg21.
--------------------------------------------------------------------------------
12	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg22' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 22.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode taxi. Set submode prg load to load prg22.0 on is_first_iteration = load_order_prg22.
--------------------------------------------------------------------------------
13	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg23' ) AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' )	

UPDATE sde_facts SET Value = 23.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Prg24.0 definition. Mode all rst. Set submode prg load to load prg23.0 on is_first_iteration = load_order_prg23.
--------------------------------------------------------------------------------
14

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'delete_order_prg24' ) AND Value > 0

DELETE FROM sde_rules WHERE Context = 'prg24.0'

Prg24.0 definition. Delete prg24.0 on is_first_iteration = delete_order_prg24.
===============================================================================

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'load_order_prg24' ) AND Value > 2	

UPDATE sde_facts SET Value = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg24' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

Ship level definition. Prg24.1 definition. Load init programs. Set submode prg load to load cur ver prg24 on is_first_iteration = load_order_prg24 and > 2.


