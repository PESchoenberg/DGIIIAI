-- prg19.0
-- Manages elev and elev_t.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_elev' AND Value = 1	

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) - ( SELECT Value FROM sde_facts WHERE Item = 'pitch' ) ) / ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) )  WHERE Status = 'applykbrules' AND Item = 'elev'	

-- Prg19.0 defintion. Mode elev definition.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_elev' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_elev' ) WHERE Status = 'applykbrules' AND Item = 'elev'	

-- Prg19.0 defintion. Mode elev actuator signal.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value < -1	

UPDATE sde_facts SET Value = -1 WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg19.0 defintion. Truncate elev_t to -1 value if < -1.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 1	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'

-- Prg19.0 defintion. Truncate elev_t to 1 value if > 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item='elev' AND Value < -1	

UPDATE sde_facts SET Value = -1 WHERE Status = 'applykbrules' AND Item = 'elev'	

-- Prg19.0 defintion. Truncate elev to -1 value if < -1.
--------------------------------------------------------------------------------
6
SELECT Value FROM sde_facts WHERE Item='elev' AND Value > 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'elev'	

-- Prg19.0 defintion. Truncate elev to 1 value if > 1.
--------------------------------------------------------------------------------
