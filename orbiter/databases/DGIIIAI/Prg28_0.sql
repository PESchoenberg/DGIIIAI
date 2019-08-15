-- prg28.0
-- Updates the sde_*_facts records required by a new version of an existing program.
--------------------------------------------------------------------------------
1

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value != 0 AND C > 0

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) WHERE Status != 'applykbrules' AND Item = ( SELECT SUBSTR( ( SELECT ( 'cur_ver_prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) ) ), 1, ( ( SELECT INSTR( ( SELECT ( 'cur_ver_prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) ) ), '.' ) ) - 1 ) ) )

-- Prg28.0 definition. Check if updated version of program described in prg to  add exists in sde_prg_rules. If it does exist, change corresponding cur ver fact to reflect newer version.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'prg_to_add'

-- Prg28.0 definition. Set prg to add to to 0 once the program completed its task.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add'

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg28' ) AS TEXT ) ) )

-- Prg28.0 definition. Delete prg28.
--------------------------------------------------------------------------------
