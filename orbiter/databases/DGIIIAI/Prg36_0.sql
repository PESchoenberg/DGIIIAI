-- prg36.0
-- Manages mode make plan flight.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_flight' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg36' ) AS TEXT ) ) )

-- Prg36.0 definition. On mode_make_plan_flight = 0, delete prg36.
--------------------------------------------------------------------------------

