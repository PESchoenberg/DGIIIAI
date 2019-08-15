-- prg15.0
-- Calculates dynamically standard speeds.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'vs' AND Value >= 0.00	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) / 20 ) WHERE Value >= 0.00 AND Status = 'applykbrules' AND Item = 'vtx0'	

-- Prg15.0 definition. Speed and velocities. Update lower taxi speed based on current stall speed (vs).
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'vs' AND Value >= 0.00	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='vs' ) / 5 ) WHERE Value >= 0.00 AND Status = 'applykbrules' AND Item = 'vtx1'	

-- Prg15.0 definition. Speed and velocities. Update higher taxi speed based on current stall speed (vs).
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'vs' AND Value >= 0.00	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * 0.95 ) WHERE Value >= 0.00 AND Status = 'applykbrules' AND Item = 'vr'	

-- Prg15.0 definition. Speed and velocities. Update vr based on current stall speed(vs).
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'vs' AND Value >= 0.00	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * 1.05 ) WHERE Value >= 0.00 AND Status = 'applykbrules' AND Item = 'vat'	

-- Prg15.0 definition. Speed and velocities. Update vat based on current stall speed(vs).
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'vs' AND Value >= 0.00	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * 1.5 ) WHERE Value >= 0.00 AND Status = 'applykbrules' AND Item = 'vlo'	

-- Prg15.0 definition. Speed and velocities. Update vlo based on current stall speed(vs).
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'vs' AND Value >= 0.00	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * 1.025 ) WHERE Value >= 0.00 AND Status = 'applykbrules' AND Item = 'vsw'	

-- Prg15.0 definition. Speed and velocities. Update vsw based on current stall speed(vs).
--------------------------------------------------------------------------------
