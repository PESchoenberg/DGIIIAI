-- prg8.2
-- Manages mode rudder. Calculates new heading on turns and assigns those values to tgt hdg. Also calculates tgt yaw and rudder trim values.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.2 definition. Reset mode rudder counter to zero on mode rudder zero.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_cs'	

-- Prg8.2 definition. tgt_hdg_err_cs to zero on mode rudder zero; this leads to avg on mode rudder 0.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg8' ) AS TEXT ) ) )	

-- Prg8.2 definition. Delete context cur ver prg8 when mode rudder is 0.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.2 definition. Increases mode rudder counter on mode rudder 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = 0 WHERE ( Value < 0 OR Value >= 360 ) AND Status = 'applykbrules' AND Item LIKE '%hdg'	

-- Prg8.2 definition. Set headings into the interval [0,360).
--------------------------------------------------------------------------------
6

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_cs' ) + ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) )  WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_cs'	

-- Prg8.2 definition. On mode rudder 1 and bank <= max_bank_rudder_t, increase tgt_hdg_err_cs by adding current rudder Value.
--------------------------------------------------------------------------------
7	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_cs' ) / ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) )  WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_avg'	

-- Prg8.2 definition. On mode rudder 1 and bank <= max_bank_rudder_t, calculate avg.
--------------------------------------------------------------------------------
8

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_hdg_err_avg' ) )  WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.2 definition. On mode rudder 1 and bank <= max_bank_rudder_t, tgt_hdg_err_avg to rudder_t.
--------------------------------------------------------------------------------
9	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) > ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.2 definition. On mode rudder 1 and bank > max_bank_rudder_t, 0.00 to rudder_t.
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'yaw'	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='yaw' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_yaw'	

-- Prg8.2 definition. Calculates tgt_yaw by inverting the yaw value.
--------------------------------------------------------------------------------
11	

SELECT Value FROM sde_facts WHERE Item = 'mode_yaw_damper' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_yaw' ) / ( 5 ) ) WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.2 definition. Yaw damper actuator signal.
--------------------------------------------------------------------------------
12	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk1tk2.
--------------------------------------------------------------------------------
13	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk1tk3.
--------------------------------------------------------------------------------
14

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Neg rudder value on hk1tk4.
--------------------------------------------------------------------------------
15	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Neg rudder value on hk2tk1.
--------------------------------------------------------------------------------
16	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk2tk3.
--------------------------------------------------------------------------------
17

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk2tk4.
--------------------------------------------------------------------------------
18

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Neg rudder value on hk3tk1.
--------------------------------------------------------------------------------
19	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Neg rudder value on hk3tk2.
--------------------------------------------------------------------------------
20	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C JOIN

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk3tk4.
--------------------------------------------------------------------------------
21	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C JOIN

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk4tk1.
--------------------------------------------------------------------------------
22	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Pos rudder value on hk4tk2.
--------------------------------------------------------------------------------
23	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' AND Value < 0 ) AS D

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Neg rudder value on hk4tk3.
--------------------------------------------------------------------------------
24

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) > ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk1tk1t>r.
--------------------------------------------------------------------------------
25

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 0 AND A.Value < 90 ) AND ( B.Value >= 0 AND B.Value < 90 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk1tk1t<r.
--------------------------------------------------------------------------------
26

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) > ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk2tk2t>r.
--------------------------------------------------------------------------------
27

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 90 AND A.Value < 180 ) AND ( B.Value >= 90 AND B.Value < 180 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk2tk2t<r.
--------------------------------------------------------------------------------
28

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) > ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk3tk3t>r.
--------------------------------------------------------------------------------
29

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 180 AND A.Value < 270 ) AND ( B.Value >= 180 AND B.Value < 270 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk3tk3t<r.
--------------------------------------------------------------------------------
30

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) > ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk4tk4t>r.
--------------------------------------------------------------------------------
31

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE ( A.Value >= 270 AND A.Value < 360 ) AND ( B.Value >= 270 AND B.Value < 360 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Invert tgt rudder value on hk4tk4t<r.
--------------------------------------------------------------------------------
32

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg') AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE A.Value = B.Value

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.2 definition. Tgt rudder zero on tgt hdg = hdg.
--------------------------------------------------------------------------------
33

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 1) AS B ) WHERE A.Value = 1 AND B.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'vr' ) ) AS D ) WHERE C.Value = 1 AND D.Value > 0	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.2 definition. Keep rudder on zero when on the ground and speed < vr.
--------------------------------------------------------------------------------
34

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) WHERE Status = 'applykbrules' AND Item = 'rudder'	

-- Prg8.2 definition. Rudder actuator signal.
--------------------------------------------------------------------------------
