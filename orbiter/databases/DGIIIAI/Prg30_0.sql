-- prg30.0
-- Purges sde_asoc_facts of records belonging to session older than current iteration or session minus sessions_asoc_facts_to_keep.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'sessions_asoc_facts_to_keep' AND Value > 0

DELETE FROM sde_asoc_facts WHERE Session <= ( ( SELECT Value FROM sde_facts WHERE Item = 'session_id' ) - ( SELECT Value FROM sde_facts WHERE Item = 'sessions_asoc_facts_to_keep' ) )

-- Prg30.0 definition. If sessions_asoc_facts_to_keep, then delete records.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'sessions_asoc_facts_to_keep'

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg30' ) AS TEXT ) ) )

-- Prg30.0 definition. Delete prg30.
--------------------------------------------------------------------------------
