-- prg8.3
-- Manages mode rudder. Calculates new heading on turns and assigns those values to tgt hdg. Also calculates tgt yaw and rudder trim values.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.3 definition. Reset mode rudder counter to zero on mode rudder zero.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_cs'	

-- Prg8.3 definition. tgt_hdg_err_cs to zero on mode rudder zero; this leads to avg on mode rudder 0.

--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 0	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg8' ) AS TEXT ) ) )	

-- Prg8.3 definition. Delete context cur ver prg8 when mode rudder is 0.
--------------------------------------------------------------------------------
-- Main
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_rudder_counter'	

-- Prg8.3 definition. Increases mode rudder counter on mode rudder 1.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = 0 WHERE ( Value < 0 OR Value >= 360 ) AND Status = 'applykbrules' AND Item LIKE '%hdg'	

-- Prg8.3 definition. Set headings into the interval [0,360).
--------------------------------------------------------------------------------
6

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_cs' ) + ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) )  WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_cs'	

-- Prg8.3 definition. On mode rudder 1 and bank <= max_bank_rudder_t, increase tgt_hdg_err_cs by adding current rudder Value.
--------------------------------------------------------------------------------
7	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_cs' ) / ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder_counter' ) )  WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_err_avg'	

-- Prg8.3 definition. On mode rudder 1 and bank <= max_bank_rudder_t, calculate avg.
--------------------------------------------------------------------------------
8

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) <= ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_err_avg' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_tgt_hdg_err_avg' ) )  WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.3 definition. On mode rudder 1 and bank <= max_bank_rudder_t, tgt_hdg_err_avg to rudder_t.
--------------------------------------------------------------------------------
9	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'bank' AND abs( Value ) > ( SELECT Value FROM sde_facts WHERE Item = 'max_bank_rudder_t' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.3 definition. On mode rudder 1 and bank > max_bank_rudder_t, 0.00 to rudder_t.
--------------------------------------------------------------------------------
10	

SELECT Value FROM sde_facts WHERE Item = 'yaw'	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item='yaw' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_yaw'	

-- Prg8.3 definition. Calculates tgt_yaw by inverting the yaw value.
--------------------------------------------------------------------------------
11	

SELECT Value FROM sde_facts WHERE Item = 'mode_yaw_damper' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_yaw' ) / ( 5 ) ) WHERE Status = 'applykbrules' AND Item = 'rudder_t'	

-- Prg8.3 definition. Yaw damper actuator signal.
--------------------------------------------------------------------------------
12	

SELECT Value FROM sde_facts WHERE Item = 'hdg' AND ( Value >= 0 AND Value < 90 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'hdg_quadrant'

-- Prg8.3 definition. Check if hdg is on q1.
--------------------------------------------------------------------------------
13	

SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND ( Value >= 0 AND Value < 90 )

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_quadrant'

-- Prg8.3 definition. Check if tgt hdg is on q1.
--------------------------------------------------------------------------------
14	

SELECT Value FROM sde_facts WHERE Item = 'hdg' AND ( Value >= 90 AND Value < 180 )

UPDATE sde_facts SET Value = 2 WHERE Status = 'applykbrules' AND Item = 'hdg_quadrant'

-- Prg8.3 definition. Check if hdg is on q2.
--------------------------------------------------------------------------------
15	

SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND ( Value >= 90 AND Value < 180 )

UPDATE sde_facts SET Value = 2 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_quadrant'

-- Prg8.3 definition. Check if tgt hdg is on q2.
--------------------------------------------------------------------------------
16	

SELECT Value FROM sde_facts WHERE Item = 'hdg' AND ( Value >= 180 AND Value < 270 )

UPDATE sde_facts SET Value = 3 WHERE Status = 'applykbrules' AND Item = 'hdg_quadrant'

-- Prg8.3 definition. Check if hdg is on q3.
--------------------------------------------------------------------------------
17	

SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND ( Value >= 180 AND Value < 270 )

UPDATE sde_facts SET Value = 3 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_quadrant'

-- Prg8.3 definition. Check if tgt hdg is on q3.
--------------------------------------------------------------------------------
18	

SELECT Value FROM sde_facts WHERE Item = 'hdg' AND ( Value >= 270 AND Value < 360 )

UPDATE sde_facts SET Value = 4 WHERE Status = 'applykbrules' AND Item = 'hdg_quadrant'

-- Prg8.3 definition. Check if hdg is on q4.
--------------------------------------------------------------------------------
19	

SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND ( Value >= 270 AND Value < 360 )

UPDATE sde_facts SET Value = 4 WHERE Status = 'applykbrules' AND Item = 'tgt_hdg_quadrant'

-- Prg8.3 definition. Check if tgt hdg is on q4.
--------------------------------------------------------------------------------
20

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 1 ) AND ( B.Value = 2 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq1tq2.
--------------------------------------------------------------------------------
21	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 1 ) AND ( B.Value = 3 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq1tq3.
--------------------------------------------------------------------------------
22

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 1 ) AND ( B.Value = 4 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Neg rudder value on hq1tq4.
--------------------------------------------------------------------------------
23	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 2 ) AND ( B.Value = 1 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Neg rudder value on hq2tq1.
--------------------------------------------------------------------------------
24	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 2 ) AND ( B.Value = 3 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq2tq3.
--------------------------------------------------------------------------------
25

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 2 ) AND ( B.Value = 4 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq2tq4.
--------------------------------------------------------------------------------
26

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 3 ) AND ( B.Value = 1 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Neg rudder value on hq3tq1.
--------------------------------------------------------------------------------
27	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 3 ) AND ( B.Value = 2 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Neg rudder value on hq3tq2.
--------------------------------------------------------------------------------
28	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 3 ) AND ( B.Value = 4 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq3tq4.
--------------------------------------------------------------------------------
29	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 4 ) AND ( B.Value = 1 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq4tq1.
--------------------------------------------------------------------------------
30	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 4 ) AND ( B.Value = 2 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Pos rudder value on hq4tq2.
--------------------------------------------------------------------------------
31	

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = 4 ) AND ( B.Value = 3 ) ) AS C

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Neg rudder value on hq4tq3.
--------------------------------------------------------------------------------
32 *

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = B.Value ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) > ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( 1 ) ) * ( ( ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) - ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) * ( 1.00 ) ) / ( 90 ) ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.3 definition. Pos tgt rudder value on hq=tq h<t.
----------------------------------- ---------------------------------------------
33 *

SELECT C.Value FROM ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg_quadrant' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg_quadrant' ) AS B ) WHERE ( A.Value = B.Value ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) ) AS D WHERE ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) < ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) )

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item = 'max_rudder' ) * ( -1 ) ) * ( ( ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) - ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) ) * ( 1.00 ) ) / ( 90 ) ) ) WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.3 definition. Pos tgt rudder value on hq=tq h>t.
--------------------------------------------------------------------------------
34 *

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'hdg') AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS B ) WHERE A.Value = B.Value

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'

-- Prg8.3 definition. Tgt rudder zero on h=t.
--------------------------------------------------------------------------------
35

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 1) AS B ) WHERE A.Value = 1 AND B.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'vr' ) ) AS D ) WHERE C.Value = 1 AND D.Value > 0	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg8.3 definition. Keep rudder on zero when on the ground and speed < vr.
--------------------------------------------------------------------------------
36

SELECT Value FROM sde_facts WHERE Item = 'mode_rudder' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'tgt_rudder' ) WHERE Status = 'applykbrules' AND Item = 'rudder'	

-- Prg8.3 definition. Rudder actuator signal.
--------------------------------------------------------------------------------
