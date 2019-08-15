-- prg46.0
-- Manages quantum computations.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_quantum' AND Value = 0

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'factor_quantum1'

-- Prg46.1 definition. Set factor_quantum = 1 when mode quantum is off. This ensures that only once the quantum factor is used.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_quantum' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg46' ) AS TEXT ) ) )	

-- Prg46.1 definition. Delete prg46.0 if mode_quantum is off.
--------------------------------------------------------------------------------
-- Main.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_quantum' AND Value = 1

UPDATE sde_facts SET Prob = ( SELECT Value FROM sde_facts WHERE Item = 'factor_quantum1' ) WHERE Status='applykbrules' AND ( Prob < 1.00  AND Prob > 0.00 )

-- Prg46.1 definition. Update prob value for items that have no certainty true or false - not 1 or 0 as a probability.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_quantum' AND Value = 1

UPDATE sde_facts SET Value = 0 WHERE Status='applykbrules' AND Item = 'mode_quantum'

-- Prg46.1 definition. Set mode quantum to 0.
--------------------------------------------------------------------------------

