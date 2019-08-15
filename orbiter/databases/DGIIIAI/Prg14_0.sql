-- prg14.0
-- Manages external lights.
--------------------------------------------------------------------------------
1	

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value > ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' )	

UPDATE sde_facts SET Value = 1.00 WHERE Value != 1.00 AND Status = 'applykbrules' AND Item = 'l_nav'	

-- Prg14.0 definition. Lights control. Turn NAV lights on if speed is in the interval (vtx0,c).
--------------------------------------------------------------------------------
2

SELECT Value FROM sde_facts WHERE Item = 'airspeed' AND Value <= ( SELECT Value FROM sde_facts WHERE Item = 'vtx0' )	

UPDATE sde_facts SET Value=0.00 WHERE Value != 0.00 AND Status = 'applykbrules' AND Item = 'l_nav'	

-- Prg14.0 definition. Lights control. Turn NAV lights off on speed [0,vtx0].
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_fly' AND Value = 1.00	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'l_stro'	

-- Prg14.0 definition. Lights control. Strobe lights on if mode fly is true.
--------------------------------------------------------------------------------
4	

SELECT Value FROM sde_facts WHERE Item = 'mode_fly' AND Value = 0.00	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'l_stro'	

-- Prg14.0 definition. Lights control. Strobe lights off if mode fly is false.
--------------------------------------------------------------------------------
