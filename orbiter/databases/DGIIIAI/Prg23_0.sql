-- prg23.0
-- Resets most modes.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'all_rst' AND Value = 1	

UPDATE sde_facts SET Value = abs(  ( SELECT Value FROM sde_facts WHERE Item LIKE '%_rst' ) - 1 ) WHERE Status = 'applykbrules' AND Item LIKE '%_rst' AND Item NOT LIKE 'submode_%' AND Item NOT LIKE  'mode hato%' AND Item NOT LIKE 'mode_crs%' AND Item NOT LIKE 'mode_make_plan%'	

-- Prg23.0 definition. Reset. Toggles the Value field between 0 <=> 1 of all %_rst facts, except submodes. 
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'all_rst' AND Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Value = 1 AND Status = 'applykbrules' AND Item = 'all_rst'	

-- Prg23.0 definition. Reset. After toggling all _rst facts, reset to zero all_facts fact.
--------------------------------------------------------------------------------