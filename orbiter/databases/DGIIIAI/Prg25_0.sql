-- prg25.0
-- Log data from sde_facts for analysis.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'log_evo_rules' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg25' ) AS TEXT ) ) )

-- Prg25.0 definition. Log evo rules definition. Delete cur ver Prg25.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'log_evo_rules' AND Value = 1

INSERT INTO sde_asoc_facts ( Context, Status, Item, Value, Prob, Session, Iter ) SELECT Context, Status, Item, Value, Prob, ( SELECT Value FROM sde_facts WHERE Item = 'session_id' ), ( SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' )  FROM sde_facts WHERE Asoc = 1 AND Status = 'applykbrules'

-- Prg25.0 definition. Log evo rules definition. Copy data on each iteration.
--------------------------------------------------------------------------------

