-- prg22.0
-- Manages mode taxi.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value <= ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' )	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'nosewheelsteering'	

-- Prg22.0 definition. Mode taxi. Turn on nose wheel steering when speed [0,vtx1].
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' )	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'nosewheelsteering'	

-- Prg22.0 definition. Mode taxi. Disconnect nose wheel steering when speed (vtx1,c).
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND ( ( Value <= ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' ) ) AND ( Value > ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' ) ) )	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_taxi'	

-- Prg22.0 definition. Mode taxi. Mode taxi on if airspeed between (vx0,vx1].
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value <= ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' )	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_stop'	

-- Prg22.0 definition. Mode taxi. Mode stop on  when speed [0,vtx0].
--------------------------------------------------------------------------------
5	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' )	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'mode_stop'	

-- Prg22.0 definition. Mode taxi. Mode stop off when speed (vtx0,c).
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value >= ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' )	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'mode_fly'	

-- Prg22.0 definition. Mode taxi. Mode fly on when speed [vtx1,c).
--------------------------------------------------------------------------------
7	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value < ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' )	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'mode_fly'	

-- Prg22.0 definition. Mode taxi. Mode fly off when speed [0,vtx1).
--------------------------------------------------------------------------------
