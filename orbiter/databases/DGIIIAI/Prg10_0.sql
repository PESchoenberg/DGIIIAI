1	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_crs_counter'	

-- Prg10.0 definition. Reset mode crs counter to zero on mode crs zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_rst'

-- Prg10.0 definition. Cut off all thrusters on crs 0.	
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

DELETE FROM sde_rules WHERE Context = 'prg10.0'	

-- Prg10.0 definition. Delete Prg10.0 when mode crs is 0.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_crs_counter'	

-- Prg10.0 definition. Increases mode crs counter on mode crs 1.
--------------------------------------------------------------------------------
5	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * 3) WHERE Status = 'applykbrules' AND Item = 'tgt_speed'	

-- Prg10.0 definition. Set tgt speed = vs * 3 on crs counter = [1,2].
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg10.0 definition. Set tgt altitude = altitudeoverground on crs counter = [1,2].
--------------------------------------------------------------------------------
7	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) WHERE Status = 'applykbrules' AND Item = 'tgt_hdg'	

-- Prg10.0 definition. Set tgt hdg = hdg on crs counter = [1,2].
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_ailer'	

-- Prg10.0 definition. Activate mode_ailer on crs counter = [3,4].
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_elev'	

-- Prg10.0 definition. Activate mode_elev on crs counter = [3,4].
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 3	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_rudder'	

--Prg10.0 definition. Activate mode_rudder on crs counter = 3.
--------------------------------------------------------------------------------
11	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5	

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) - ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) / ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) + ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) / 2 ) ) WHERE Status = 'applykbrules' AND Item = 'elev'	

-- Prg10.0 definition. Auto elev to acquire tgt alt on crs counter >= 5.
--------------------------------------------------------------------------------
12	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value < (-0.05) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.0 definition. If pitch on descent is too steep, increase pitch value for a shallower glide.
--------------------------------------------------------------------------------
13	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.3 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.0 definition. If alt over ground is less than tgt alt, put positive tgt pitch.
--------------------------------------------------------------------------------
14	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = (-0.05) WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.0 definition. If alt over ground is more than tgt alt, put negative tgt pitch.
--------------------------------------------------------------------------------
15	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.0 definition. If alt over ground = tgt alt, put zero tgt pitch.
--------------------------------------------------------------------------------
16	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) - ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) + ( SELECT Value FROM sde_facts WHERE Item = 'pitch' ) ) * ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) / 2 ) )  ) WHERE Status != 'applykbrules' AND Item = 'elev_t'	

-- Prg10.0 definition. Auto elev t to acquire tgt pitch on crs counter >= 5.
--------------------------------------------------------------------------------
17	

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value < 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='elev_t' ) * (-1) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.0 definition. If elev t is negative and target pith is positive, invert the sign of elev_t.
--------------------------------------------------------------------------------
18	

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'elev_t' AND Value < 0 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'elev' AND Value < 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value < 0 )	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.0 definition. If elev < 0 and elev_t < 0, set elev_t = 0 for a shallower dive.
--------------------------------------------------------------------------------
19	

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 0) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' AND Value < 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 )	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.0 definition. If elev_t > 0 and tgt_pitch < 0 and pitch > 0, set elev_t = 0 mult by factor for a shallower dive.
--------------------------------------------------------------------------------
20	

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'elev_t' AND Value > 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'elev' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 )	

UPDATE sde_facts SET Value = ( 0.00 + (  ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.0 definition. If elev_t > 0 and elev > 0 and pitch > 0, set elev_t = 0 mult by factor.
--------------------------------------------------------------------------------
21	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_cs' ) + ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) - ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt_err_cs'	

-- Prg10.0 definition. Cumulative sum of tgt alt versus alt when counter > 5.
--------------------------------------------------------------------------------
22	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_cs' ) / ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) - 5 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt_err_avg'	

-- Prg10.0 definition. Calculate average of tgt alt vs alt error.
--------------------------------------------------------------------------------
23	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_avg' ) / 1000 ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_alt_err'	

-- Prg10.0 definition. Calculate correction factor for elev t alt error.
--------------------------------------------------------------------------------
24	

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 0) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS F	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.0 definition. If pitch > 0 and alt > tgt_alt and mode crs on and elev_t > 0 set elev t = 0.
--------------------------------------------------------------------------------
25	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_alt_err_comp'	

-- Prg10.0 definition. Set factor_tgt_alt_err_comp = 1.4 on crs counter = [1,2] as initial value.
--------------------------------------------------------------------------------
26	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND  Item = 'mode_evo_crs'	

-- Prg10.0 definition. Set mode evo crs 0 on crs 0.
--------------------------------------------------------------------------------
27	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND  Item = 'mode_evo_crs'	

-- Prg10.0 definition. Set mode evo crs 1 on crs 1.
--------------------------------------------------------------------------------
28	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 3.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg10.0 definition. Set submode prg load Value field to 3.0 in order to load evo crs commands.
--------------------------------------------------------------------------------
29	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_prg'	

-- Prg10.0 definition. Activate mode prg on counter = 4.
--------------------------------------------------------------------------------
30	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg10.0 definition. Set tgt altitude = altitudeoverground on crs counter = [1,2].
--------------------------------------------------------------------------------
31

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_thgroup_main'

-- Prg10.0 definition. Mainthruster on, on crs 1.
--------------------------------------------------------------------------------
