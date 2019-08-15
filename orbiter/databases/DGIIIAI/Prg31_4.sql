-- prg31.4
-- Manages navmodes.
--------------------------------------------------------------------------------
-- Closing an cleaning up.
--------------------------------------------------------------------------------
1

SELECT D.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs'  ) AS B ) WHERE A.Value = 0 AND B.Value = 0 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_trs' ) AS D ) WHERE D.Value = 0

DELETE FROM sde_rules WHERE Context = ( SELECT ( 'prg' || CAST( ( SELECT Value FROM sde_facts WHERE Item = 'cur_ver_prg31' ) AS TEXT ) ) )

-- Prg31.4 definition. If mode hato = 0 and mode crs = 0 and mode trs = 0, delete prg31 from sde_rules.
--------------------------------------------------------------------------------
-- Setup values.
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'mode_navmode_control' AND Value = 1

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_navmode_control'

-- Prg31.4 definition. Toggle mode navmode control off once loaded.
--------------------------------------------------------------------------------
3

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value >= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) AND ( B.Value <= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' )  ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 1.00 WHERE Value != 1.00 AND Status = 'applykbrules' AND Item = 'navmode_hlevel'

-- Prg31.4 definition. Mode crs. If crs is on and tgt_alt = altitudeoverground, activate navmode hlevel.
--------------------------------------------------------------------------------
4

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value < ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) OR ( B.Value > ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' ) ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_hlevel'

-- Prg31.4 definition. Mode crs. If crs is on and tgt_alt != altitudeoverground, deactivate navmode hlevel.
--------------------------------------------------------------------------------
5

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value >= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) AND ( B.Value <= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' )  ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 1.00 WHERE Value != 1.00 AND Status = 'applykbrules' AND Item = 'navmode_holdalt'

-- Prg31.4 definition. Mode crs. If tgt alt = altitudeoverground and mode crs is on and holdalt is off, turn holdalt on.
--------------------------------------------------------------------------------
6

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value < ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) OR ( B.Value > ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' ) ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'navmode_holdalt'

-- Prg31.4 definition. Mode crs. If altitudeoverground < tgt_alt * min_alt_multiplier or altitudeoverground > tgt_alt * max_alt_multiplier and crs = 1, then set off navmode holdalt.
--------------------------------------------------------------------------------
-- Inhibit navmodes according to specific conditions.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE ( Item = 'mode_hato' OR Item = 'mode_trs' ) AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'navmode%'	

-- Prg31.4 definition. Mode hato. Mode trs. Inhibit navmodes on mode hato, mode trs on.
--------------------------------------------------------------------------------
8

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS B ) WHERE ( B.Value != A.Value ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'navmode%'

-- Prg31.4 definition. Mode crs. Inhibit navmodes on tgt hdg != hdg and mode crs = 1.
--------------------------------------------------------------------------------
9

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_prograde'	

-- Prg31.4 definition. Mode crs. Inhibit navmode_prograde on mode crs on.
--------------------------------------------------------------------------------
10

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_retrograde'	

-- Prg31.4 definition. Mode crs. Inhibit navmode_retrograde on mode crs on.
--------------------------------------------------------------------------------
11

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_normal'	

-- Prg31.4 definition. Mode crs. Inhibit navmode_normal on mode crs on.
--------------------------------------------------------------------------------
12

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_antinormal'	

-- Prg31.4 definition. Mode crs. Inhibit navmode_antinormal on mode crs on.
--------------------------------------------------------------------------------
13

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_killrot'	

-- Prg31.4 definition. Mode crs. Inhibit navmode_killrot on mode crs on.
--------------------------------------------------------------------------------
14

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_hover' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'navmode_holdalt' ) AS B ) WHERE ( A.Value > 0.00 AND B.Value = 0.00 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'thgroup_hover'

-- Prg31.4 definition. Mode crs. Cut off stray thgroup hover > 0 when navmode holdalt = 0 an mode crs = 1.
--------------------------------------------------------------------------------
15

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_hover' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'navmode_holdalt' ) AS B ) WHERE ( A.Value > 0.00 AND B.Value = 0.00 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'thgroup_hover'

-- Prg31.4 definition. Mode crs. Cut off stray thgroup hover > 0 when navmode holdalt = 0 an mode hato = 1.
--------------------------------------------------------------------------------
16

SELECT D.Value FROM ( ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_pitchup' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_pitchdown' ) AS B ) WHERE ( ( B.Value = A.Value ) AND ( A.Value != 0.00 ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'navmode_hlevel' AND Value = 0 ) AS E )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item = 'thgroup_att_pitchup' OR Item = 'thgroup_att_pitchdown' )

-- Prg31.4 definition. Mode crs. Cut off *att_pitchup and *att_pitchdown when their values are equal, mode crs is on and navmode hlevel is off.
--------------------------------------------------------------------------------
17

SELECT D.Value FROM ( ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_up' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_down' ) AS B ) WHERE ( ( B.Value = A.Value ) AND ( A.Value != 0.00 ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'navmode_hlevel' AND Value = 0 ) AS E )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item = 'thgroup_att_up' OR Item = 'thgroup_att_down' )

-- Prg31.4 definition. Mode crs. Cut off *att_up and *att_down when their values are equal, mode crs is on and navmode hlevel is off.
--------------------------------------------------------------------------------
18

SELECT C.Value FROM ( ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_bankright' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_bankleft' ) AS B ) WHERE ( A.Value != 0.00 OR B.Value != 0.00 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'navmode_hlevel' AND Value = 0 ) AS E )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item LIKE 'thgroup_att_bank%'

-- Prg31.4 definition. Mode crs. Cut off stray thgroup bank != 0 when navmode hlevel = 0 an mode crs = 1.
--------------------------------------------------------------------------------
