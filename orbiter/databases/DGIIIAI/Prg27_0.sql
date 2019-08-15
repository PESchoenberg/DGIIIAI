-- prg27.0
-- Creates the sde_*_facts records required by a new program (not new version) being registered.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0

INSERT INTO sde_facts (Context, Status, Item, Value, Prob, Asoc) VALUES ('ship', ( SELECT Status FROM sde_facts WHERE Item = 'prg_to_add' ), ( SELECT ( 'load_order' || CAST ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) AS INT ) ) ), 0, 1, 0)

-- Prg27.0 definition. Register load order 0 new record on sde_facts.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0

INSERT INTO sde_facts (Context, Status, Item, Value, Prob, Asoc) VALUES ('ship', ( SELECT Status FROM sde_facts WHERE Item = 'prg_to_add' ), ( SELECT ( 'cur_ver_prg' || CAST ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) AS INT ) ) ), ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ), 1, 0)

-- Prg27.0 definition. Register prg to add as current version on sde_facts.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0

INSERT INTO sde_mem_facts (Context, Status, Item, Value, Prob, Asoc) VALUES ('ship', ( SELECT Status FROM sde_mem_facts WHERE Item = 'prg_to_add' ), ( SELECT ( 'load_order' || CAST ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) AS INT ) ) ), 0, 1, 0)

-- Prg27.0 definition. Register load order 0 on sde_mem_facts.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0

INSERT INTO sde_mem_facts (Context, Status, Item, Value, Prob, Asoc) VALUES ('ship', ( SELECT Status FROM sde_mem_facts WHERE Item = 'prg_to_add' ), ( SELECT ( 'cur_ver_prg' || CAST ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ) AS TEXT ) AS INT ) ) ), ( SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' ), 1, 0)

-- Prg27.0 definition. Register prg to add as current version on sde_mem_facts.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add' AND Value != 0

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'prg_to_add'

-- Prg27.0 definition. Set prg to add to to 0 once the program completed its task.
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'prg_to_add'

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg27' ) AS TEXT ) ) )

-- Prg27.0 definition. Delete prg27.
--------------------------------------------------------------------------------

