-- prg7.1
-- Manages mode ailer.
--------------------------------------------------------------------------------
1	

SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' AND Value = 0	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'mode_ailer_counter'	

-- Prg7.1 definition. Reset mode ailer counter to zero on mode ailer zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg7' ) AS TEXT ) ) )

-- Prg7.1 definition. Delete cur ver Prg7 when mode ailer is 0.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_ailer_counter'	

-- Prg7.1 definition. Increases mode ailer counter on mode ailer 1.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_ratio_rudder_to_ailer' ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'	

-- Prg7.1 definition. Set tgt ailer value based on rudder value and factor.
--------------------------------------------------------------------------------
5

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND Value < ( ( SELECT Value FROM sde_facts WHERE Item = 'max_allowed_bank' ) * ( -1 ) ) ) AS B ) WHERE A.Value = 1 AND B.Value < 0	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'	

-- Prg7.1 definition. tgt ailer to zero if max bank limit is surpassed by positive roll.
--------------------------------------------------------------------------------
6

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND Value > ( ( SELECT Value FROM sde_facts WHERE Item = 'max_allowed_bank' ) * ( 1 ) ) ) AS B ) WHERE A.Value = 1 AND B.Value > 0	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'	

-- Prg7.1 definition. tgt ailer to zero if max bank limit is surpassed by negative roll.
--------------------------------------------------------------------------------
7

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer') AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND Value > 0 ) AS B ) WHERE A.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder') AS D ) WHERE D.Value > 0	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'	

-- Prg7.1 definition. Avoid port side ailer lock.
--------------------------------------------------------------------------------
8

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer') AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND Value < 0 ) AS B ) WHERE A.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'rudder') AS D ) WHERE D.Value < 0	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'rudder' ) WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'	

-- Prg7.1 definition. Avoid starboard side ailer lock.
--------------------------------------------------------------------------------
9

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'hdg' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'bank' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_revert_bank' ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'

-- Prg7.1 definition. Ailer damper.
--------------------------------------------------------------------------------
10

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_ailer' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'max_allowed_ailer' ) ) AS B ) WHERE A.Value = 1 AND B.Value > 0

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_allowed_ailer' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'

-- Prg7.1 definition. Apply max ailer limit to ailer > 0.
--------------------------------------------------------------------------------
11

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_ailer' AND Value < ( ( SELECT Value FROM sde_facts WHERE Item = 'max_allowed_ailer' ) * ( -1 ) ) ) AS B ) WHERE A.Value = 1 AND B.Value < 0

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_allowed_ailer' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'

-- Prg7.1 definition. Apply max ailer limit to ailer < 0.
--------------------------------------------------------------------------------
12	

SELECT Value FROM sde_facts WHERE Item = 'mode_ailer' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_ailer' ) WHERE Status = 'applykbrules' AND Item = 'ailer'	

-- Prg7.1 definition. Ailer actuator signal.
--------------------------------------------------------------------------------
