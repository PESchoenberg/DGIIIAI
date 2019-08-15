-- prg11.1
-- Manages thgroups used on mode crs.
--------------------------------------------------------------------------------
1	

SELECT Value FROM sde_facts WHERE Item = 'thgroup_rst' AND Value = 1	

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item LIKE 'thgroup_%'	

-- Prg11.1 definition. Resets all thgroup_ facts if thgroup rst = 1.
--------------------------------------------------------------------------------
2 

SELECT Value FROM sde_facts WHERE Item = 'thgroup_rst' AND Value = 1

UPDATE sde_facts SET Value = 0.00 WHERE Status = 'applykbrules' AND Item = 'thgroup_rst'

-- Prg11.1 definition. Set thgroup rst = 0 if thgroup rst = 1.
--------------------------------------------------------------------------------
3

SELECT Value FROM sde_facts WHERE Item = 'mode_crs_counter' AND Value > 4	

UPDATE sde_facts SET Value = ( 1 - ( ( SELECT Value FROM sde_facts WHERE Item = 'airspeed' ) * ( SELECT Value FROM sde_facts WHERE Item = 'factor_hvel' ) / ( SELECT Value FROM sde_facts WHERE Item = 'tgt_speed' ) ) ) WHERE Status = 'applykbrules' AND Item = 'factor_thgroup_main'	

-- Prg11.1 definition. Mode hvel definition. Set factor_mode_thgroup_main on crs counter > 4.
--------------------------------------------------------------------------------
4

SELECT Value FROM sde_facts WHERE Item = 'mode_thgroup_main' AND Value = 1	

UPDATE sde_facts SET Value = ( ( SELECT Value FROM sde_facts WHERE Item = 'thgroup_main' ) + ( SELECT Value FROM sde_facts WHERE Item = 'factor_thgroup_main' ) ) WHERE Status = 'applykbrules' AND Item = 'thgroup_main'	

-- Prg11.1 definition. Mode thgroup main definition. Add factor thgroup main to thgroup main.
--------------------------------------------------------------------------------
5

SELECT Value FROM sde_facts WHERE Item = 'thgroup_main' AND Value > 0.00	

UPDATE sde_facts SET Value = 0.00 WHERE Value > 0.00 AND Status = 'applykbrules' AND Item = 'thgroup_retro'	

-- Prg11.1 definition. Sets retro to zero power if main engine is on.
--------------------------------------------------------------------------------
6	

SELECT Value FROM sde_facts WHERE Item = 'thgroup_retro' AND Value > 0.00	

UPDATE sde_facts SET Value = 1.00 WHERE Value = 0.00 AND Status = 'applykbrules' AND Item = 'retro_doors'	

-- Prg11.1 definition. Open retro doors when retro engines are fired.
--------------------------------------------------------------------------------
7

SELECT Value FROM sde_facts WHERE Item = 'thgroup_retro' AND Value = 0.00	

UPDATE sde_facts SET Value = 0.00 WHERE Value = 1.00 AND Status = 'applykbrules' AND Item = 'retro_doors'	

-- Prg11.1 definition. Close retro doors when retro engines are idle.
--------------------------------------------------------------------------------
