-- prg29.0
-- Program version updater. If the update corresponds to a brand new program, it calls prg27, and if the update corresponds to a new version of an existing  program, it calls prg28.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add'

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'debug1' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'debug1'

-- Prg29.0 definition. Update debug marker 1.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND ( ( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) - ( SELECT  CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS INTEGER ) ) = 0 ) )

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg27' ) AS TEXT ) ) ) WHERE Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg29.0 definition. Load prg27 if program update refers to new program.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND ( ( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) - ( SELECT  CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS INTEGER ) ) != 0 ) )

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg28' ) AS TEXT ) ) ) WHERE Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg29.0 definition. Load prg28 if program update refers to new version of existing program.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add'

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg29' ) AS TEXT ) ) )

-- Prg29.0 definition. Delete prg29.
--------------------------------------------------------------------------------
