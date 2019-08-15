-- prg21.0
-- Manages airspeed.
--------------------------------------------------------------------------------
1

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND ( ( Value <= ( SELECT Value FROM sde_facts WHERE Item = 'vtx1' ) ) AND ( Value > ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' ) ) )	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'brakes_air'	

-- Prg21.0 definition. Airbrakes. Close airbrakes if airspeed between (vx0,vx1].
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'thgroup_main' AND Value > 0

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'brakes_air'

-- Prg21.0 definition. Airbrakes. Close airbrakes if main engine is working.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'thgroup_retro' AND Value >= 0.5

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'brakes_air'

-- Prg21.0 definition. Airbrakes. Open airbrakes if retro thrust is at 0.5 or more
--------------------------------------------------------------------------------
