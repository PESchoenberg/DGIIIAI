-- prg8.1
-- Manages mode rudder. Calculates new heading on turns and assigns those values to tgt hdg. Also calculates tgt yaw and rudder trim values.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.1 definition. Reset mode rudder counter to zero on mode rudder zero.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_cs'	

-- Prg8.1 definition. tgt_hdg_err_cs to zero on mode rudder zero; this leads to avg on mode rudder 0.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg8' ) AS TEXT ) ) )	

-- Prg8.1 definition. Delete context cur ver prg8 when mode rudder is 0.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.1 definition. Increases mode rudder counter on mode rudder 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = 0 WHERE ( Value < 0 OR Value >= 360 ) AND Status = 'applykbrules' AND Item LIKE '%hdg'	

-- Prg8.1 definition. Set headings into the interval [0,360).
--------------------------------------------------------------------------------
6	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value > 180 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) - 360 )  WHERE Status = 'applykbrules' AND Item = 'turn_rel_hdg'	

-- Prg8.1 definition. Recalculate tgt hdg if value is higher than 180 deg.
--------------------------------------------------------------------------------
7	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'hdg' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'turn_dir_hdg'	

-- Prg8.1 definition. Set turn dir hdg to zero if hdg and tgt hdg are the same.
--------------------------------------------------------------------------------
8	

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='mode_rudder' AND Value = 1) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'hdg' AND Value != ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) ) AS B ) WHERE A.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'turn_rel_hdg' AND Value < 0 ) AS D ) WHERE C.Value = 1	

UPDATE sde_facts SET Value = -1 WHERE Status = 'applykbrules' AND Item = 'turn_fac_hdg'	

-- Prg8.1 definition. Set turn factor to -1, indicating that a left side turn will be actuated.
--------------------------------------------------------------------------------
9	

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'hdg' AND Value != ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) ) AS B ) WHERE A.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'turn_rel_hdg' AND Value >= 0 ) AS D ) WHERE C.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'turn_fac_hdg'	

-- Prg8.1 definition. Set turn factor to 1, indicating that a right side turn will be actuated.
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'turn_rel_hdg' ) + ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) * ( SELECT Value FROM sde_facts WHERE Item = 'turn_fac_hdg' ) ) ) WHERE Status = 'applykbrules' AND Item = 'turn_res_hdg'	

-- Prg8.1 definition. Intermediate calculation of turn angle.
--------------------------------------------------------------------------------
11	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'turn_res_hdg' AND Value > 180 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'turn_res_hdg' ) - 360 ) WHERE Status='applykbrules' AND Item = 'turn_res_hdg'	

Prg8.1 definition. Final calculation of turn angle.
--------------------------------------------------------------------------------
12	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'turn_res_hdg' AND Value < -180 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'turn_res_hdg' ) + 360 ) WHERE Status = 'applykbrules' AND Item = 'turn_res_hdg'	

-- Prg8.1 definition. Final calculation of turn angle.
--------------------------------------------------------------------------------
13	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'turn_res_hdg' ) / ( 180 ) ) * 2 ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Assign tgt rudder value.
--------------------------------------------------------------------------------
14	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) WHERE Status = 'applykbrules' AND Item = 'turn_rel_hdg'	

-- Prg8.1 definition. Set turn rel hdg to the value of tgt hdg before transformation.
--------------------------------------------------------------------------------
15	

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 1) AS B ) WHERE A.Value = 1 AND B.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'vr' ) ) AS D ) WHERE C.Value = 1 AND D.Value > 0	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Keep rudder on zero when on the ground and speed < vr.
--------------------------------------------------------------------------------
16

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'hdg' AND Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Set rudder 0 if tgt_hdg and hdg are the same.
--------------------------------------------------------------------------------
17	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) + 1 )  WHERE Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.1 definition. Increase counter value if mode rudder on.
--------------------------------------------------------------------------------
18

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_cs' ) + ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) )  WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_cs'	

-- Prg8.1 definition. On mode rudder 1 and bank <= max_bank_rudder_t, increase tgt_hdg_err_cs by adding current rudder Value.
--------------------------------------------------------------------------------
19	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_cs' ) / ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) )  WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_avg'	

-- Prg8.1 definition. On mode rudder 1 and bank <= max_bank_rudder_t, calculate avg.
--------------------------------------------------------------------------------
20

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_hdg_err_avg' ) )  WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.1 definition. On mode rudder 1 and bank <= max_bank_rudder_t, tgt_hdg_err_avg to rudder_t.
--------------------------------------------------------------------------------
21	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) > ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.1 definition. On mode rudder 1 and bank > max_bank_rudder_t, 0.00 to rudder_t.
--------------------------------------------------------------------------------
22	

SELECT Value FROM sde_facts WHERE Item = 'yaw'	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='yaw' ) * -1 ) WHERE Status = 'applykbrules' AND Item = 'tgt_yaw'	

-- Prg8.1 definition. Calculates tgt_yaw by inverting the yaw value.
--------------------------------------------------------------------------------
23	

SELECT Value FROM sde_facts WHERE Item = 'mode_yaw_damper' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_yaw' ) / 5 ) WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.1 definition. Yaw damper actuator signal.
--------------------------------------------------------------------------------
24	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk1tk2r<0.
--------------------------------------------------------------------------------
25	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk1tk3r<0.
--------------------------------------------------------------------------------
26	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk1tk4r>0.
--------------------------------------------------------------------------------
27	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk2tk1r>0.
--------------------------------------------------------------------------------
28	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk2tk3r<0.
--------------------------------------------------------------------------------
29

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk2tk4r<0.
--------------------------------------------------------------------------------
30	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk3tk1r>0.
--------------------------------------------------------------------------------
31	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk3tk2r>0.
--------------------------------------------------------------------------------
32	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk3tk4r<0.
--------------------------------------------------------------------------------
33	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk4tk1r<0.
--------------------------------------------------------------------------------
34	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk4tk2r>0.
--------------------------------------------------------------------------------
36	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = (( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.1 definition. Invert tgt rudder value on hk4tk3r>0.
--------------------------------------------------------------------------------
37

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg') AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE A.Value = B.Value

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.1 definition. Tgt rudder zero on tgt hdg = hdg.
--------------------------------------------------------------------------------

38 (24)

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) WHERE Status = 'applykbrules' AND Item = 'rudder'	

-- Prg8.1 definition. Rudder actuator signal.
--------------------------------------------------------------------------------
