-- prg18.0
-- Closes all doors and hatches.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_doors_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'olock'	

-- Prg18.0 definition. Mode doors close. Close olock.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_doors_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'ilock'	

-- Prg18.0 definition. Mode doors close. Close ilock.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'mode_doors_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'hatch'	

-- Prg18.0 definition. Mode doors close. Close hatch.
--------------------------------------------------------------------------------
