-- prg35.0
-- Manages mode make plan to.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_make_plan_to' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg35' ) AS TEXT ) ) )

-- Prg35.0 definition. On mode mode_make_plan_to = 0, delete prg35.
--------------------------------------------------------------------------------

