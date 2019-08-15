-- prg44.1
-- Manages crew. This version just performs some checks on the number of crew members onboard and adds up a crew resource counter. This counter could be used later to calculate overall life support resources' consumption.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1 See prg0.0 27

SELECT Value FROM sde_facts WHERE Item = 'crew_onb' AND Value <= 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg44' ) AS TEXT ) ) )	

-- Prg44.1 definition. If there are no crew members onboard delete prg44 from sde_rules.
--------------------------------------------------------------------------------
-- Check data integrity.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'crew_max' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'crew_min' )

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'crew_min' ) WHERE Status = 'applykbrules' AND Item = 'crew_max'

-- Prg44.1 definition. If value of crew max < crew min, set crew max to value of crew min.
--------------------------------------------------------------------------------
-- Calculate resource consumption.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'crew_onb' AND Value > 0

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'crew_onb' ) + ( SELECT Value FROM sde_facts WHERE Item = 'crew_resource_counter' ) ) WHERE Status = 'applykbrules' AND Item = 'crew_resource_counter'

-- Prg44.1 definition. If there are crew onboard, update resource counter.
--------------------------------------------------------------------------------
