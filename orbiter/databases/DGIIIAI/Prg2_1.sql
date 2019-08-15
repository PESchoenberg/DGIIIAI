-- prg2.1
-- Atm flight program. Hato, crs. Performs a hato take off, ascent, and crs. Wpt mode can be activated by the pilot during crs flight.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'mode_prg' AND Value = 0
 
UPDATE sde_facts SET Value = 1 WHERE Value = 0 AND Status='applykbrules' AND Item = 'mode_prg'

-- Prg2.1 definition. Set mode prg to 1 on each iteration.
--------------------------------------------------------------------------------
2	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item='groundcontact' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value = 0.00 ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Value = 0 AND Status='applykbrules' AND Item = 'mode_hato'	

-- Prg2.1 definition. Set mode hato 1 while on the ground and with speed 0.
--------------------------------------------------------------------------------
3	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'def_alt_for_hato' ) ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' ) AS B ) WHERE B.Value = 0	

UPDATE sde_facts SET Value = 1 WHERE Value = 0 AND Status='applykbrules' AND Item = 'mode_crs'	

-- Prg2.1 definition. Set mode crs 1 while over hato limit alt and mode hato 0.
--------------------------------------------------------------------------------
