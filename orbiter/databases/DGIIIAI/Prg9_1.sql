-- prg9.1
-- Manages mode hato.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 0	

UPDATE sde_facts SET Value = 0 WHERE Value != 0 AND Status = 'applykbrules' AND Item = 'mode_hato_counter'	

-- Prg9.1 definition. Reset mode hato counter to zero on mode hato zero.
--------------------------------------------------------------------------------
2=

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 0	

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg9' ) AS TEXT ) ) )	

-- Prg9.1 definition. Delete cur ver Prg9 when mode hato is 0.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' ) + 1 ) WHERE Status = 'applykbrules' AND Item = 'mode_hato_counter'	

-- Prg9.1 definition. Increases mode hato counter on mode hato 1.
--------------------------------------------------------------------------------
4=	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'aerosurf_rst'	

-- Prg9.1 definition. Activate aerosurf_rst on hato counter = [1,2].
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_thgroup_main'	

-- Prg9.1 definition. Activate mode_thgroup_ on hato counter = [3,4].
--------------------------------------------------------------------------------
6

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'vs' ) * 2 ) WHERE Status = 'applykbrules' AND Item = 'tgt_speed'	

-- Prg9.1 definition. Set tgt speed for hato.
--------------------------------------------------------------------------------
7=

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'def_alt_for_hato' ) WHERE Status = 'applykbrules' AND Item = 'tgt_alt'	

-- Prg9.1 definition. Set tgt altitude for hato.
--------------------------------------------------------------------------------
8	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'def_dec_alt_for_hato' ) WHERE Status = 'applykbrules' AND Item = 'dec_alt'	

-- Prg9.1 definition. Set decision altitude.
--------------------------------------------------------------------------------
9

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 5 AND Value <= 6	

UPDATE sde_facts SET Value = 1.00 WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg9.1 definition. Set elev trim on 1 on hato counter = [5,6].
--------------------------------------------------------------------------------
10=	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 5 AND Value <= 6	

UPDATE sde_facts SET Value = 0.5 WHERE Status = 'applykbrules' AND Item = 'tgt_pitch'	

-- Prg9.1 definition. Set tgt pitch for hato mode on hato counter = [5,6].
--------------------------------------------------------------------------------
11

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 10	

UPDATE sde_facts SET Value = ( ( ( SELECT Value FROM sde_facts WHERE Item='tgt_pitch' ) - ( SELECT Value FROM sde_facts WHERE Item = 'pitch' ) ) / ( SELECT Value FROM sde_facts WHERE Item = 'tgt_pitch' )  )  WHERE Status = 'applykbrules' AND Item = 'elev_t'	

-- Prg9.1 definition. Auto trim to acquire tgt pitch on hato counter >= 10.
--------------------------------------------------------------------------------
12=	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 11 AND Value <= 14	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_main'  )  + 0.25 )  WHERE Status = 'applykbrules' AND Item = 'thgroup_main'	

-- Prg9.1 definition. Set thgroup main = 1 on hato counter = [11,14].
--------------------------------------------------------------------------------
13	

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 )  AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 1 ) AS B ) WHERE A.Value = 1 AND B.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'vr' ) ) AS D ) WHERE C.Value = 1 AND D.Value > 0	

UPDATE sde_facts SET Value = 0.50 WHERE Status = 'applykbrules' AND Item = 'tgt_elev'	

-- Prg9.1 definition. Set tgt elev on 0.5 on airspeed >= vr and while still on ground.
--------------------------------------------------------------------------------
14=

SELECT C.Value FROM ( ( SELECT A.Value FROM ( (SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 0 ) AS B ) WHERE A.Value = 1 AND B.Value = 0 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'dec_alt' ) AND Value >= 150 ) AS D ) WHERE C.Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_elev'	

-- Prg9.1 definition. Set tgt elev on 0 once the ship passes 150 m AGL and until it reaches dec alt.
--------------------------------------------------------------------------------
15	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value= 1.00 WHERE Status = 'applykbrules' AND Item = 'all_rst'	

-- Prg9.1 definition. Reset all once alt over ground >= tgt alt on hato.
--------------------------------------------------------------------------------
16=

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'dec_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1.00 WHERE Status = 'applykbrules' AND Item = 'mode_yaw_damper'	

-- Prg9.1 definition. Set yaw damper on when altitudeoverground >= dec_alt.
--------------------------------------------------------------------------------
17

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_yaw_damper' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT Value FROM sde_facts WHERE item = 'dec_alt' ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_yaw_damper'	

-- Prg9.1 definition. Set yaw damper off when altitudeoverground < dec_alt.
--------------------------------------------------------------------------------
18=	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_ailer'	

-- Prg9.1 definition. Activate mode_ailer on hato counter = [3,4].
--------------------------------------------------------------------------------
19

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value = 3	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_rudder'	

-- Prg9.1 definition. Activate mode_rudder on hato counter = 3.
--------------------------------------------------------------------------------
20	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 5 AND Value <= 6	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_ailer'	

-- Prg9.1 definition. Set tgt ailer on 0 on hato counter = [5,6].
--------------------------------------------------------------------------------
21=

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 5 AND Value <= 6	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_rudder'	

-- Prg9.1 definition. Set tgt rudder on 0 on hato counter = [5,6].
--------------------------------------------------------------------------------
22	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 3 AND Value <= 4	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_elev'	

-- Prg9.1 definition. Activate mode_elev on hato counter = [3,4].
--------------------------------------------------------------------------------
23	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 5 AND Value <= 6	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'tgt_elev'	

-- Prg9.1 definition. Set tgt elev on 0 on hato counter = [5,6].
--------------------------------------------------------------------------------
24=	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_doors_close'	

-- Prg9.1 definition. Mode doors close on hato counter = [1,2].
--------------------------------------------------------------------------------
25	

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 1 AND Value <= 2	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_extensions_close'	

-- Prg9.1 definition. Mode extensions close on hato counter = [1,2].
--------------------------------------------------------------------------------
26=	

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 1 ) AS B ) WHERE A.Value = 1 AND B.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'vr' ) ) AS D ) WHERE C.Value = 1 AND D.Value > 0	

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) WHERE Status = 'applykbrules' AND Item = 'tgt_hdg'	

-- Prg9.1 definition. Set tgt hdg on hdg value on airspeed >= vr and while still on ground.
--------------------------------------------------------------------------------
27

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' ) AS A JOIN ( SELECT COUNT(*) AS C FROM sde_prg_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) ) ) AS B ) WHERE A.Value = 1 AND C > 0

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_navmode_control'

-- Prg9.1 definition. Set mode navmode control 1 on count of prg31 records = 0 on sde_rules.
--------------------------------------------------------------------------------
28=

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' )  AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'groundcontact' ) AS B ) WHERE A.Value = 1 AND B.Value = 0 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value <= ( SELECT Value FROM sde_facts WHERE Item = 'dec_alt' ) ) AS D )

UPDATE sde_facts SET Value = ( SELECT Value FROM sde_facts WHERE Item = 'hdg' ) WHERE Status = 'applykbrules' AND Item = 'tgt_hdg'

-- Prg9.1 definition. Set tgt hdg on hdg value while still off ground but below dec alt.
--------------------------------------------------------------------------------
29*

SELECT Value FROM sde_facts WHERE Item = 'mode_hato_counter' AND Value >= 1 AND Value <= 2

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_wpt'	

-- Prg9.1 definition. Set mode wpt on  on hato counter = [1,2].
--------------------------------------------------------------------------------
