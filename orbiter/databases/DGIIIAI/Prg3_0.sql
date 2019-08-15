-- prg3.0
-- Test program. Not used in flight.
--------------------------------------------------------------------------------
6

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value < ( SELECT Value FROM sde_facts WHERE  Item = 'evo_crs_counter_max_limit' ) ) AS F	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_evo_crs_counter'	

-- Prg3.0 definition. If mode crs, prg and evo are on, and evo counter still has not reached its max lim, then increment counter value.
--------------------------------------------------------------------------------
7	

SELECT F.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( ( SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'mode_prg' AND ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'evo_crs_counter_max_limit' ) ) AS F	

UPDATE sde_facts SET Value = ( SELECT ( ( RANDOM() * 0.99 ) / RANDOM() ) ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_hdg_err_avg'	

-- Prg3.0 definition. If mode crs, prg and evo are on, and evo counter 1, then create a new random value for factor_tgt_hdg_err_avg.
--------------------------------------------------------------------------------
8	

SELECT F.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value = 1 ) AS F	

UPDATE sde_mem_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_hdg_err_avg' ) WHERE Item = 'factor_tgt_hdg_err_avg' AND ( SELECT ABS(Value) FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' ) < ( SELECT ABS(Value) FROM sde_mem_facts WHERE Item = 'tgt_hdg_err_avg' )	

-- Prg3.0 definition. Replace mem fact factor_tgt_hdg_err_avg with fact factor_tgt_hdg_err_avg if newly calculated tgt_hdg_err_avg is smaller than the old one.
--------------------------------------------------------------------------------
9	

SELECT F.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( ( SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'evo_crs_counter_max_limit' ) ) AS F	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_mem_facts WHERE Item = 'factor_tgt_hdg_err_avg' ) WHERE Item = 'factor_tgt_hdg_err_avg' AND ( SELECT ABS(Value) FROM sde_mem_facts WHERE Item = 'tgt_hdg_err_avg') < ( SELECT ABS(Value) FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' )	

-- Prg3.0 definition. Replace fact factor_tgt_hdg_err_avg with mem_fact factor_tgt_hdg_err_avg if newly calculated tgt_hdg_err_avg is bigger than the old one.
--------------------------------------------------------------------------------
10

SELECT F.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( ( SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'evo_crs_counter_max_limit' ) ) AS F	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item LIKE 'mode evo_crs%'	

-- Prg3.0 definition. On mode_evo_counter_max_limit surpassed, reset mode evo.
--------------------------------------------------------------------------------
11	

SELECT F.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'evo_crs_counter_max_limit' ) ) AS F	

UPDATE sde_mem_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' ) WHERE Item = 'tgt_hdg_err_avg' AND ( SELECT ABS(Value) FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' ) < ( SELECT ABS(Value) FROM sde_mem_facts WHERE Item = 'tgt_hdg_err_avg' )	

-- Prg3.0 definition. Replace mem fact tgt_hdg_err_avg with fact tgt_hdg_err_avg if newly calculated tgt_hdg_err_avg is smaller than the old one.
--------------------------------------------------------------------------------
12	

SELECT F.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( ( SELECT Value FROM sde_facts WHERE Item='mode_crs' AND Value = 1 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'mode_prg' ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_evo_crs_counter' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'evo_crs_counter_max_limit' ) ) AS F	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg3' ) AS TEXT ) ) )	

-- Prg3.0 definition. On mode_evo_counter_max_limit surpassed, delete all records from cur ver prg3.
--------------------------------------------------------------------------------
