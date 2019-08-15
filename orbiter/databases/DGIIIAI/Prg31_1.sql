-- prg31.1
-- Manages navmodes
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'navmode%'	

-- Prg31.0 definition. Mode hato. Inhibit navmodes on mode hato on.
--------------------------------------------------------------------------------
2

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value >= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) AND ( B.Value <= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' )  ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 1.00 WHERE Value != 1.00 AND Status = 'applykbrules' AND Item = 'navmode_hlevel'

-- Prg31.0 definition. Mode crs. If crs is on and tgt_alt = altitudeoverground, activate navmode hlevel.
--------------------------------------------------------------------------------
3

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value < ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) OR ( B.Value > ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' ) ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_hlevel'

-- Prg31.0 definition. Mode crs. If crs is on and tgt_alt != altitudeoverground, deactivate navmode hlevel.
--------------------------------------------------------------------------------
4

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value >= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) AND ( B.Value <= ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' )  ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 1.00 WHERE Value != 1.00 AND Status = 'applykbrules' AND Item = 'navmode_holdalt'

-- Prg31.0 definition. Mode crs. If tgt alt = altitudeoverground and mode crs is on and holdalt is off, turn holdalt on.
--------------------------------------------------------------------------------
5

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_alt' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' ) AS B ) WHERE ( B.Value < ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'min_alt_multiplier' ) ) ) OR ( B.Value > ( A.Value * ( SELECT Value FROM sde_facts WHERE Item = 'max_alt_multiplier' ) ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'navmode_holdalt'

-- Prg31.0 definition. Mode crs. If altitudeoverground < tgt_alt * min_alt_multiplier or altitudeoverground > tgt_alt * max_alt_multiplier and crs = 1, then set off navmode holdalt.
--------------------------------------------------------------------------------
6

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'tgt_hdg' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'hdg' ) AS B ) WHERE ( B.Value != A.Value ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'navmode%'

-- Prg31.0 definition. Mode crs. Inhibit navmodes on tgt hdg != hdg and mode crs = 1.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_prograde'	

-- Prg31.0 definition. Mode crs. Inhibit navmode_prograde on mode crs on.
--------------------------------------------------------------------------------
8

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_retrograde'	

-- Prg31.0 definition. Mode crs. Inhibit navmode_retrograde on mode crs on.
--------------------------------------------------------------------------------
9

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_normal'	

-- Prg31.0 definition. Mode crs. Inhibit navmode_normal on mode crs on.
--------------------------------------------------------------------------------
10

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_antinormal'	

-- Prg31.0 definition. Mode crs. Inhibit navmode_antinormal on mode crs on.
--------------------------------------------------------------------------------
11

SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'navmode_killrot'	

-- Prg31.0 definition. Mode crs. Inhibit navmode_killrot on mode crs on.
--------------------------------------------------------------------------------
12

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_hover' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'navmode_holdalt' ) AS B ) WHERE ( A.Value > 0.00 AND B.Value = 0.00 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'thgroup_hover'

-- Prg31.0 definition. Mode crs. Cut off stray thgroup hover > 0 when navmode holdalt = 0 an mode crs = 1.
--------------------------------------------------------------------------------
13

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_hover' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'navmode_holdalt' ) AS B ) WHERE ( A.Value > 0.00 AND B.Value = 0.00 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS D )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'thgroup_hover'

-- Prg31.0 definition. Mode crs. Cut off stray thgroup hover > 0 when navmode holdalt = 0 an mode hato = 1.
--------------------------------------------------------------------------------
14

SELECT D.Value FROM ( ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_pitchup' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_pitchdown' ) AS B ) WHERE ( ( B.Value = A.Value ) AND ( A.Value != 0.00 ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'navmode_hlevel' AND Value = 0 ) AS E )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item = 'thgroup_att_pitchup' OR Item = 'thgroup_att_pitchdown' )

-- Prg31.0 definition. Mode crs. Cut off *att_pitchup and *att_pitchdown when their values are equal, mode crs is on and navmode hlevel is off.
--------------------------------------------------------------------------------
15

SELECT D.Value FROM ( ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_up' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_down' ) AS B ) WHERE ( ( B.Value = A.Value ) AND ( A.Value != 0.00 ) ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'navmode_hlevel' AND Value = 0 ) AS E )

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND ( Item = 'thgroup_att_up' OR Item = 'thgroup_att_down' )

-- Prg31.0 definition. Mode crs. Cut off *att_up and *att_down when their values are equal, mode crs is on and navmode hlevel is off.
--------------------------------------------------------------------------------
16

SELECT C.Value FROM ( ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_bankright' ) AS A JOIN (SELECT Value FROM sde_facts WHERE Item = 'thgroup_att_bankright' ) AS B ) WHERE ( A.Value != 0.00 OR B.Value != 0.00 ) ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_crs' AND Value = 1 ) AS D ) JOIN ( SELECT Value FROM sde_facts WHERE Item = 'navmode_hlevel' AND Value = 0 ) AS E )

UPDATE sde_facts SET Value = 0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item LIKE 'thgroup_att_pitch%'

-- Prg31.0 definition. Mode crs. Cut off stray thgroup bank != 0 when navmode hlevel = 0 an mode crs = 1.
--------------------------------------------------------------------------------
