-- prg20.0
-- Manages energy,
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'energy_lvl' AND Value = 0.00	

UPDATE sde_facts SET Value = 0.00 WHERE Value > 0.00 AND Status = 'applykbrules' AND Item = 'energy_bus'	

-- Prg20.0 definition. Energy system. Disconnect the energy bus if the level of an energy source reaches zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'energy_bus' AND Value = 0.00	

UPDATE sde_facts SET Value = 0.00 WHERE Value > 0.00 AND Status = 'applykbrules' AND ( Item = 'l_bcn' OR Item = 'l_stro' OR Item = 'l_nav' OR Item = 'life_sup' OR Item = 'mode_taxi' OR Item = 'mode_fly' )	

-- Prg20.0 definition. Energy system. Things turned off if energy_bus = 0 .
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'energy_bus' AND Value > 0.00	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND ( Item = 'l_bcn' OR Item = 'life_sup' )	

-- Prg20.0 definition. Energy system. Things turned on if energy_bus > 0 .
--------------------------------------------------------------------------------
