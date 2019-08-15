-- prg10.1
-- Manages mode crs.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_crs_counter'	

-- Prg10.1 definition. Reset mode crs counter to zero on mode crs zero.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_rst'

-- Prg10.1 definition. Cut off all thrusters on crs 0.	
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg10' ) AS TEXT ) ) )

-- Prg10.1 definition. Delete cur ver Prg10 when mode crs is 0.
--------------------------------------------------------------------------------
-- Setup values.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_crs_counter'	

-- Prg10.1 definition. Increases mode crs counter on mode crs 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * ( SELECT Value FROM sde_facts WHERE Item = 'speed_for_crs' ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_speed'

-- Prg10.1 definition. Set tgt speed = vs * tgt_speed_for_crs_factor on crs counter = [1,2].
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg10.1 definition. Set tgt altitude = altitudeoverground on crs counter = [3,4].
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) WHERE Status = 'applykbrules' AND Item = 'tgt_hdg'	

-- Prg10.1 definition. Set tgt hdg = hdg on crs counter = [1,2].
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_ailer'	

-- Prg10.1 definition. Activate mode_ailer on crs counter = [3,4].
--------------------------------------------------------------------------------
9	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_elev'	

-- Prg10.1 definition. Activate mode_elev on crs counter = [3,4].
--------------------------------------------------------------------------------
10

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 3	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_rudder'	

-- Prg10.1 definition. Activate mode_rudder on crs counter = 3.
--------------------------------------------------------------------------------
11 To prg19? ***

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5	

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) - ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) / ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) + ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) / 2 ) ) WHERE Status = 'applykbrules' AND Item = 'elev'	

-- Prg10.1 definition. Auto elev to acquire tgt alt on crs counter >= 5.
--------------------------------------------------------------------------------
12	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value < (-0.05) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.1 definition. If pitch on descent is too steep, increase pitch value for a shallower glide.
--------------------------------------------------------------------------------
13	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.3 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.1 definition. If alt over ground is less than tgt alt, put positive tgt pitch.
--------------------------------------------------------------------------------
14	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = (-0.05) WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.1 definition. If alt over ground is more than tgt alt, put negative tgt pitch.
--------------------------------------------------------------------------------
15	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg10.1 definition. If alt over ground = tgt alt, put zero tgt pitch.
--------------------------------------------------------------------------------
16 To prg19

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) - ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' ) + ( SELECT Value FROM sde_facts WHERE Item = 'pitch' ) ) * ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) / 2 ) )  ) WHERE Status != 'applykbrules' AND Item = 'elev_t'	

-- Prg10.1 definition. Auto elev t to acquire tgt pitch on crs counter >= 5.
--------------------------------------------------------------------------------
17	

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value < 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='elev_t' ) * (-1) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.1 definition. If elev t is negative and target pith is positive, invert the sign of elev_t.
--------------------------------------------------------------------------------
18

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'elev_t' AND Value < 0 ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'elev' AND Value < 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value < 0 )	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.1 definition. If elev < 0 and elev_t < 0, set elev_t = 0 for a shallower dive.
--------------------------------------------------------------------------------
19

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 0) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' AND Value < 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 )	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.1 definition. If elev_t > 0 and tgt_pitch < 0 and pitch > 0, set elev_t = 0 mult by factor for a shallower dive.
--------------------------------------------------------------------------------
20

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'elev_t' AND Value > 0 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'elev' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 )	

UPDATE sde_facts SET Value = ( 0.00 + (  ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.1 definition. If elev_t > 0 and elev > 0 and pitch > 0, set elev_t = 0 mult by factor.
--------------------------------------------------------------------------------
21

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_cs' ) + ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) - ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt_err_cs'	

-- Prg10.1 definition. Cumulative sum of tgt alt versus alt when counter > 5.
--------------------------------------------------------------------------------
22	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_cs' ) / ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) - 5 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt_err_avg'	

-- Prg10.1 definition. Calculate average of tgt alt vs alt error.
--------------------------------------------------------------------------------
23

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 5	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt_err_avg' ) / 1000 ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_alt_err'	

-- Prg10.1 definition. Calculate correction factor for elev t alt error.
--------------------------------------------------------------------------------
24	

SELECT E.Value FROM ( SELECT D.Value FROM ( ( SELECT A.Value FROM  ( (SELECT Value FROM sde_facts WHERE Item='elev_t' AND Value > 0) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'pitch' AND Value > 0 ) AS B ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) WHERE D.Value = 1 ) AS E JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS F	

UPDATE sde_facts SET Value = ( 0.00 + ( ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) ) ) WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg10.1 definition. If pitch > 0 and alt > tgt_alt and mode crs on and elev_t > 0 set elev t = 0.
--------------------------------------------------------------------------------
25

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_alt_err_comp' ) WHERE Status = 'applykbrules' AND Item = 'factor_tgt_alt_err_comp'	

-- Prg10.1 definition. Set factor_tgt_alt_err_comp = 1.4 on crs counter = [1,2] as initial value.
--------------------------------------------------------------------------------
26

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND  Item = 'mode_evo_crs'	

-- Prg10.1 definition. Set mode evo crs 0 on crs 0.
--------------------------------------------------------------------------------
27	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND  Item = 'mode_evo_crs'	

-- Prg10.1 definition. Set mode evo crs 1 on crs 1.
--------------------------------------------------------------------------------
28

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 3.0 WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'	

-- Prg10.1 definition. Set submode prg load Value field to 3.0 in order to load evo crs commands.
--------------------------------------------------------------------------------
29	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value = 4	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_prg'	

-- Prg10.1 definition. Activate mode prg on counter = 4.
--------------------------------------------------------------------------------
30

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg10.1 definition. Set tgt altitude = altitudeoverground on crs counter = [1,2].
--------------------------------------------------------------------------------
31

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item LIKE 'mode_thgroup_main'

-- Prg10.1 definition. Mainthruster on, on crs 1.
--------------------------------------------------------------------------------
32	*contr 12.2

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'leg_rel_equ_dist' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_wpt_max_radius' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status='applykbrules' AND Item = 'mode_wpt'	

-- Prg10.1 definition. Turn mode wpt on if dist to target wpt is higher than max tgt radius.
--------------------------------------------------------------------------------
33

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C = 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_navmode_control'

-- Mode crs def. Set mode navmode control 1 on count of prg31 records = 0 on sde_rules.
--------------------------------------------------------------------------------
34

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value > 5

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) - 1 ) WHERE Status = 'applykbrules' AND Item = 'delta_alt'

-- Prg10.1 definition. Substract delta alt if altitude < tgt_alt.
--------------------------------------------------------------------------------
35

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value > 5

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'delta_alt'

-- Prg10.1 definition. Sum delta alt if altitude > tgt_alt.
--------------------------------------------------------------------------------
36

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 32

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'delta_alt' ) / ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' ) ) WHERE Status = 'applykbrules' AND Item = 'factor_delta_alt'

-- Prg10.1 definition. Calculate normalized factor delta alt.
--------------------------------------------------------------------------------
37

SELECT Value FROM sde_facts WHERE Item = 'factor_delta_alt' AND Value > 1.00

UPDATE sde_facts SET Value = 1.00 WHERE Status = 'applykbrules' AND Item LIKE 'factor_delta_alt'

-- Prg10.1 definition. Set factor delta alt = 1 if it exceeds 1.
--------------------------------------------------------------------------------
38

SELECT Value FROM sde_facts WHERE Item = 'factor_delta_alt' AND Value < -1.00

UPDATE sde_facts SET Value = -1.00 WHERE Status = 'applykbrules' AND Item LIKE 'factor_delta_alt'

-- Prg10.1 definition. Set factor delta alt = -1 if it is lower than -1.
--------------------------------------------------------------------------------
39 - This should be moved to setup on a neww version.	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) WHERE Status = 'applykbrules' AND Item = 'proviso_tgt_speed'	

-- Prg10.1 definition. Set proviso tgt speed = tgt_speed on crs counter = [3,4].
--------------------------------------------------------------------------------
40 - This should be moved to setup on a new version.	

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'mode_learn_tgt_speed%'	

-- Prg10.1 definition. Set mode_learn_tgt_speed% = 0.00 on crs counter = [3,4].
--------------------------------------------------------------------------------
41

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter'  ) AS B ) WHERE A.Value = 0 AND B.Value > 4

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed_counter' ) + 1 ) WHERE Status='applykbrules' AND Item =  'mode_learn_tgt_speed_counter'

-- Prg10.1 definition. Increment counter if mode_learn_tgt_speed is off.
--------------------------------------------------------------------------------
41

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed_counter' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'learn_speed_tgt_speed'  ) AS B ) WHERE A.Value >= B.Value

UPDATE sde_facts SET Value = 1.00 WHERE Status='applykbrules' AND Item = 'mode_learn_tgt_speed'

-- Prg10.1 definition. If mode_learn_tgt_speed_counter >= learn_speed_tgt_speed then turn mode_learn_tgt_speed on.
--------------------------------------------------------------------------------
42

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_learn_tgt_speed' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg45' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value >= 1 AND C = 0

UPDATE sde_facts SET Value = ( SELECT ( CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg45' ) AS TEXT ) ) ) WHERE Value = 0 AND Status='applykbrules' AND Item = 'submode_prg_load'

-- Prg10.1 definition. Load prg45 on mode_learn_tgt_speed = 1 and no copy of prg45 is already present on sde_rules.
--------------------------------------------------------------------------------
43

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 0

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) - ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) WHERE Status='applykbrules' AND Item =  'delta_abs_alt'

-- Prg10.1 definition. Calculate the difference in meters between tgt alt and altitude over ground.
--------------------------------------------------------------------------------
44 *

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 1 AND Value <= 2

UPDATE sde_facts SET Value = 0.00 WHERE Status='applykbrules' AND Item = 'delta_abs_alt_avg' OR Item = 'delta_abs_alt_counter'

-- Prg10.1 definition. Reset avg each time mode crs starts.
--------------------------------------------------------------------------------
45

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item ='delta_abs_alt_counter' ) + ( SELECT Value FROM sde_facts WHERE Item ='delta_abs_alt' ) ) WHERE Status='applykbrules' AND Item = 'delta_abs_alt_counter'

-- Prg10.1 definition. Increment delta abs alt counter on each iteration.
--------------------------------------------------------------------------------
46

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value >= 5

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item ='delta_abs_alt_counter' ) / ( SELECT Value FROM sde_facts WHERE Item ='mode_crs_counter' ) ) WHERE Status='applykbrules' AND Item = 'delta_abs_alt_avg'

-- Prg10.1 definition. Calculate delta abs alt avg on each iteration.
--------------------------------------------------------------------------------
