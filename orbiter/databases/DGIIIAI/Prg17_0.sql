-- prg17.0
-- Manages extensible surfaces and peripherals.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_extensions_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'retro_doors'	

-- Prg17.0 definition. Mode extensions close definition. Close retro doors.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_extensions_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'ncone'	

-- Prg17.0 definition. Mode extensions close definition. Close nose cone.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'mode_extensions_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'ladder'	

-- Prg17.0 definition. Mode extensions close definition. Retract ladder.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'mode_extensions_close' AND Value = 1 	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'radiator'	

-- Prg17.0 definition. Mode extensions close definition. Retract radiator.
--------------------------------------------------------------------------------
