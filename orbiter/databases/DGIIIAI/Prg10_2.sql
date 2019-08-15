-- prg10.2
-- Manages mode crs.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_crs_counter'	

-- Prg10.2 definition. Reset mode crs counter to zero on mode crs zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_rst'

-- Prg10.2 definition. Cut off all thrusters on crs 0.	
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg10' ) AS TEXT ) ) )

-- Prg10.2 definition. Delete cur ver Prg10 when mode crs is 0.
--------------------------------------------------------------------------------
-- Setup values.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_crs_counter'	

-- Prg10.2 definition. Increases mode crs counter on mode crs 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * ( SELECT Value FROM sde_facts WHERE Item = 'speed_for_crs' ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_speed'

-- Prg10.2 definition. Set tgt speed = vs * tgt_speed_for_crs_factor on crs counter = [1,2].
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg10.2 definition. Set tgt altitude = altitudeoverground on crs counter = [1,2].
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) WHERE Status = 'applykbrules' AND Item = 'tgt_hdg'	

-- Prg10.2 definition. Set tgt hdg = hdg on crs counter = [1,2].
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_ailer'	

-- Prg10.2 definition. Activate mode_ailer on crs counter = [3,4].
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_elev'	

-- Prg10.2 definition. Activate mode_elev on crs counter = [3,4].
--------------------------------------------------------------------------------
10

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 3	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_rudder'	

-- Prg10.2 definition. Activate mode_rudder on crs counter = 3.
--------------------------------------------------------------------------------
11	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value < (-0.05) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.2 definition. If pitch on descent is too steep, increase pitch value for a shallower glide.
--------------------------------------------------------------------------------
12	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.3 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.2 definition. If alt over ground is less than tgt alt, put positive tgt pitch.
--------------------------------------------------------------------------------
13	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = (-0.05) WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.2 definition. If alt over ground is more than tgt alt, put negative tgt pitch.
--------------------------------------------------------------------------------
14	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.2 definition. If alt over ground = tgt alt, put zero tgt pitch.
--------------------------------------------------------------------------------
15

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) - ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) + ( SELECT Value FROM sde_facts WHERE Item = 'pitch' ) ) * ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) / 2 ) )  ) WHERE Status != 'applykbrules' AND Item = 'elev_t'	

-- Prg10.2 definition. Auto elev t to acquire tgt pitch on crs counter >= 5.
--------------------------------------------------------------------------------
16	

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value < 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='elev_t' ) * (-1) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.2 definition. If elev t is negative and target pitch is positive, invert the sign of elev_t.
--------------------------------------------------------------------------------
17

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'elev_t' AND Value < 0 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'elev' AND Value < 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value < 0 )	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.2 definition. If elev < 0 and elev_t < 0, set elev_t = 0 for a shallower dive.
--------------------------------------------------------------------------------
18

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 0) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' AND Value < 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 )	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.2 definition. If elev_t > 0 and tgt_pitch < 0 and pitch > 0, set elev_t = 0 mult by factor for a shallower dive.
--------------------------------------------------------------------------------
19

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'elev_t' AND Value > 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'elev' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 )	

UPDATE sde_facts SET Value = ( 0.00 + (  ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.2 definition. If elev_t > 0 and elev > 0 and pitch > 0, set elev_t = 0 mult by factor.
--------------------------------------------------------------------------------
20

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_cs' ) + ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) - ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt_err_cs'	

-- Prg10.2 definition. Cumulative sum of tgt alt versus alt when counter > 5.
--------------------------------------------------------------------------------
21	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_cs' ) / ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) - 5 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt_err_avg'	

-- Prg10.2 definition. Calculate average of tgt alt vs alt error.
--------------------------------------------------------------------------------
22

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_avg' ) / 1000 ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_alt_err'	

-- Prg10.2 definition. Calculate correction factor for elev t alt error.
--------------------------------------------------------------------------------
23	

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 0) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS F	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.2 definition. If pitch > 0 and alt > tgt_alt and mode crs on and elev_t > 0 set elev t = 0.
--------------------------------------------------------------------------------
24

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_alt_err_comp'	

-- Prg10.2 definition. Set factor_tgt_alt_err_comp = 1.4 on crs counter = [1,2] as initial value.
--------------------------------------------------------------------------------
25

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND  Item = 'mode_evo_crs'	

-- Prg10.2 definition. Set mode evo crs 0 on crs 0.
--------------------------------------------------------------------------------
26	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND  Item = 'mode_evo_crs'	

-- Prg10.2 definition. Set mode evo crs 1 on crs 1.
--------------------------------------------------------------------------------
27

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 3.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg10.2 definition. Set submode prg load Value field to 3.0 in order to load evo crs commands.
--------------------------------------------------------------------------------
28	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_prg'	

-- Prg10.2 definition. Activate mode prg on counter = 4.
--------------------------------------------------------------------------------
29

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg10.2 definition. Set tgt altitude = altitudeoverground on crs counter = [1,2].
--------------------------------------------------------------------------------
30

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_thgroup_main'

-- Prg10.2 definition. Mainthruster on, on crs 1.
--------------------------------------------------------------------------------
31	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_dist' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_max_radius' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_wpt'	

-- Prg10.2 definition. Turn mode wpt on if dist to target wpt is higher than max tgt radius.
--------------------------------------------------------------------------------
32

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_navmode_control'

-- Prg10.2 definition. Set mode navmode control 1 on count of prg31 records = 0 on sde_rules.
--------------------------------------------------------------------------------
33

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value > 5

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) - 1 ) WHERE Status = 'applykbrules' AND Item = 'delta_alt'

-- Prg10.2 definition. Rest delta alt if altitude < tgt_alt.
--------------------------------------------------------------------------------
34

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value > 5

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'delta_alt'

-- Prg10.2 definition. Sum delta alt if altitude > tgt_alt.
--------------------------------------------------------------------------------
35

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 32

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) / ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) ) WHERE Status = 'applykbrules' AND Item = 'factor_delta_alt'

-- Prg10.2 definition. Calculate normalized factor delta alt.
--------------------------------------------------------------------------------
36

SELECT Value FROM sde_facts WHERE Item = 'factor_delta_alt' AND Value > 1.00

UPDATE sde_facts SET Value = 1.00 WHERE Status = 'applykbrules' AND Item LIKE 'factor_delta_alt'

-- Prg10.2 definition. Set factor delta alt = 1 if it exceeds 1.
--------------------------------------------------------------------------------
37

SELECT Value FROM sde_facts WHERE Item = 'factor_delta_alt' AND Value < -1.00

UPDATE sde_facts SET Value = -1.00 WHERE Status = 'applykbrules' AND Item LIKE 'factor_delta_alt'

-- Prg10.2 definition. Set factor delta alt = -1 if it is lower than -1.
--------------------------------------------------------------------------------
