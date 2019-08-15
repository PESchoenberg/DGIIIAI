-- prg1.0
-- Test program. Concept development. Not used in actual flight operations.
--------------------------------------------------------------------------------
1	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' AND Value >= 2	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'test_fact_1' ) + 1 )  WHERE Status = 'applykbrules' AND Item = 'test_fact_1'	

-- Prg1.0 definition. Test program that increases the value of test fact 1.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' AND Value >= 100	

UPDATE sde_facts SET Value = 1  WHERE Status = 'applykbrules' AND Item = 'submode_prg_rst'	

-- Prg1.0 definition. Resets submode prg when submode prg counter reaches 100.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'submode_prg_counter' AND Value >= 100	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg1' ) AS TEXT ) ) )	

-- Prg1.0 definition. Delete from sde facts records belonging to cur ver prg1.
--------------------------------------------------------------------------------

