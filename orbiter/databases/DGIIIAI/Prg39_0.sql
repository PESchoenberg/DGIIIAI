-- prg39.0
-- Manages mode_make_plan_postflight.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_postflight' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg39' ) AS TEXT ) ) )

-- Prg39.0 definition. On mode_make_plan_postflight = 0, delete prg39.
--------------------------------------------------------------------------------

