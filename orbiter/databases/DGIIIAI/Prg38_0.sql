-- prg38.0
-- Manages mode_make_plan_td.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_td' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg36' ) AS TEXT ) ) )

-- Prg38.0 definition. On mode_make_plan_td = 0, delete prg38.
--------------------------------------------------------------------------------

