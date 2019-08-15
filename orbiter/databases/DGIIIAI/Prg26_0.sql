-- prg26.0
-- Set default values for sde_mem_facts based on the whole sde_facts table. Requires mode_upd_sde_mem_facts to be set to 1 before loading. This is a maintenance program not called during normal execution that turns current sde_facts values into default values.
--------------------------------------------------------------------------------
1 

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

UPDATE sde_facts SET Asoc = 0.00

-- Prg26.0 definition. Mode upd mem facts definition. Reset Asoc on sde facts.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

UPDATE sde_facts SET Value = 0.00

-- Prg26.0 definition. Mode upd mem facts definition. Reset Value on sde facts.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

DELETE FROM sde_rules WHERE Context LIKE 'prg%'

-- Prg26.0 definition. Mode upd mem facts definition. Delete all programs currently on sde_rules.

--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

UPDATE sde_facts SET Value = COALESCE( ( SELECT sde_mem_facts.Value FROM sde_mem_facts WHERE ( sde_facts.Item = sde_mem_facts.Item AND sde_mem_facts.Status = 'enabled' AND sde_mem_facts.Context = 'ship' ) ), 0)

-- Prg26.0 definition. Mode upd mem facts definition. Load Value memorized configuration from sde_mem_facts into sde_facts.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

UPDATE sde_facts SET Asoc = COALESCE( ( SELECT sde_mem_facts.Asoc FROM sde_mem_facts WHERE ( sde_facts.Item = sde_mem_facts.Item AND sde_mem_facts.Status = 'enabled' AND sde_mem_facts.Context = 'ship' ) ), 0)		

-- Prg26.0 definition. Mode upd mem facts definition. Load Asoc memorized configuration from sde_mem_facts into sde_facts.
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

DELETE FROM sde_mem_facts

-- Prg26.0 definition. Mode upd mem facts definition. Delete the contents of sde_mem_facts.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

INSERT INTO sde_mem_facts ( Context, Status, Item, Value, Prob, Asoc ) SELECT Context, Status, Item, Value, Prob, Asoc FROM sde_facts

-- Prg26.0 definition. Mode upd mem facts definition. Copy the just-updated sde_facts data into sde_mem_fact table.
--------------------------------------------------------------------------------
8

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

UPDATE sde_mem_facts SET Status = 'enabled'

-- Prg26.0 definition. Mode upd mem facts definition. Enable all renewed records.
--------------------------------------------------------------------------------
9

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 1

UPDATE sde_facts SET Value = 0 WHERE Value = 1 AND Item = 'mode_upd_mem_facts'

-- Prg26.0 definition. Mode upd mem facts definition. Change the mode update mem facts status.
--------------------------------------------------------------------------------
10

SELECT Value FROM sde_facts WHERE Item = 'mode_upd_mem_facts' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg26' ) AS TEXT ) ) )

-- Prg26.0 definition. Mode upd mem facts definition. Delete cur ver prg26.
--------------------------------------------------------------------------------
