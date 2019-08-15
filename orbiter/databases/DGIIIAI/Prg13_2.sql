-- prg13.2
-- Manages mode rst.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_rst' AND Value = 1	

--UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item LIKE 'mode_%' AND Item NOT LIKE 'mode_make_plan%' )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item LIKE 'mode_%' AND Item NOT LIKE 'mode_make_plan%' AND Item NOT LIKE 'mode_setup%' )

-- Prg13.2 definition. Resets all mode_ facts except mode_make_plan* and mode_setup*.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'tgt_rst' AND Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'tgt_%'	

-- Prg13.2 definition. Resets all tgt_ facts.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'aerosurf_rst' AND Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item = 'elev' OR Item = 'elev_t' OR Item = 'rudder' OR Item = 'rudder_t' OR Item = 'ailer' OR Item = 'aerosurf_rst'  OR Item = 'max_pitch' OR Item = 'min_pitch' )	

-- Prg13.2 definition. Resets all limit angles and aerodynamic surfaces except brakes.
--------------------------------------------------------------------------------
4 

SELECT Value FROM sde_facts WHERE Item = 'mode_rst' AND Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_pln_rst'

-- Prg13.2 definition. Mode pln rst requires special conditions and independent activation. See prg43.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_rst' AND Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item LIKE 'delta%'

-- Prg13.2 definition. Reset deltas.
--------------------------------------------------------------------------------
