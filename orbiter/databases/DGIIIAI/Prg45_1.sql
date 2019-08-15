-- prg45.1
-- Manages mode_learn_tgt_speed.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' AND Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg45' ) AS TEXT ) ) )	

-- Prg45.1 definition. Delete prg45.0 if mode_learn_tgt_speed is off.
--------------------------------------------------------------------------------
-- Main.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status='applykbrules' AND Item =  'mode_learn_tgt_speed_counter'

-- Prg45.1 definition. Reset counter when mode is on; this counter should increase when mode is off.
--------------------------------------------------------------------------------
3 

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) AS B ) WHERE A.Value = 1.00 AND B.Value < ( (  SELECT Value FROM sde_facts WHERE Item = 'delta_alt_limit' ) * (-1) )
 
UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) + ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_speed_err_avg' ) ) WHERE Status='applykbrules' AND Item =  'tgt_speed'

-- Prg45.1 definition. If mode_learn_tgt_speed = 1 and delta alt lower than delta al limit * -1, increase tgt speed.
--------------------------------------------------------------------------------
4

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) AS B ) WHERE A.Value = 1.00  AND B.Value > ( (  SELECT Value FROM sde_facts WHERE Item = 'delta_alt_limit' ) * (1) )
 
UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) - ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_speed_err_avg' ) ) WHERE Status='applykbrules' AND Item =  'tgt_speed'

-- Prg45.1 definition. If mode_learn_tgt_speed = 1 and delta alt higher than delta al limit * 1, decrease tgt speed.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' AND Value = 1

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) - ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) WHERE Status='applykbrules' AND Item =  'delta_abs_alt'

-- Prg45.1 definition. Calculate the difference in meters between tgt alt and altitude over ground.
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status='applykbrules' AND Item = 'mode_learn_tgt_speed'

-- Prg45.1 definition. Turn mode_learn_tgt_speed off after updates.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' AND Value >= 0

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) WHERE Status='applykbrules' AND Item =  'tgt_wpt_speed'

-- Prg45.1 definition. Update tgt_wpt_speed with the new tgt_speed value.
--------------------------------------------------------------------------------
