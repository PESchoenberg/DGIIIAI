-- prg37.0
-- Manages mode make plan approach.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_approach' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg37' ) AS TEXT ) ) )

-- Prg37.0 definition. On mode_make_plan_approach = 0, delete prg37.
--------------------------------------------------------------------------------

