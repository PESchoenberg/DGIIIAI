-- prg4.0
-- Test program. Load tgt rel equ data.
--------------------------------------------------------------------------------
13	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value > 4	

UPDATE sde_facts SET Value = 45.00 WHERE Status='applykbrules' AND Item = 'tgt_rel_equ_lat'	

-- Prg 4.0 definition. Load test tgt_rel_equ data.
--------------------------------------------------------------------------------
14	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value > 4	

UPDATE sde_facts SET Value = 45.00 WHERE Status='applykbrules' AND Item = 'tgt_rel_equ_lon'	

-- Prg 4.0 definition. Load test tgt_rel_equ data.
--------------------------------------------------------------------------------
15	

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value > 4	

UPDATE sde_facts SET Value = 10000 WHERE Status='applykbrules' AND Item = 'tgt_rel_equ_alt'	

-- Prg 4.0 definition. Load test tgt_rel_equ data.
--------------------------------------------------------------------------------
16

SELECT Value FROM sde_facts WHERE Item = 'is_first_iteration' AND Value > 10000	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg4' ) AS TEXT ) ) )

-- Prg 4.0 definition. Delete cur ver prg4.
--------------------------------------------------------------------------------
