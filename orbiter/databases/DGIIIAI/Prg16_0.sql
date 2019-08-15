-- prg16.0
-- Manages landing gear.
--------------------------------------------------------------------------------
1

SELECT D.Value FROM ( ( SELECT A.Value FROM ( (SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( SELECT value FROM sde_facts WHERE Item = 'dec_alt' ) ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 0 ) AS B ) WHERE A.Value != 0 AND B.Value = 0 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'mode_hato' AND Value = 1 ) AS D ) WHERE D.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Status = 'applykbrules' AND Item = 'mode_lgear'	

-- Prg16.0 definition. Mode lgear. Set on 1 when on hato, groundcontact = 0 and altitudeoverground < dec alt.
--------------------------------------------------------------------------------
2	

SELECT Value FROM sde_facts WHERE Item = 'groundcontact' AND Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_lgear'	

-- Prg16.0 definition. Mode lgear. Set on 0 when groundcontact = 1.
--------------------------------------------------------------------------------
3	

SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value >= ( SELECT value FROM sde_facts WHERE Item = 'dec_alt' )	

UPDATE sde_facts SET Value = 0 WHERE Status = 'applykbrules' AND Item = 'mode_lgear'	

-- Prg16.0 definition. Mode lgear. Set on 0 when altitudeoverground >= dec_alt.
--------------------------------------------------------------------------------
4	

SELECT C.Value FROM ( ( SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_lgear' AND Value = 1) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value > ( ( SELECT Value FROM sde_facts WHERE Item = 'dec_alt' )  /  10  ) ) AS B ) WHERE A.Value = 1 ) AS C JOIN ( SELECT Value FROM sde_facts WHERE Item = 'lgear' AND Value = 1 ) AS D ) WHERE C.Value = 1	

UPDATE sde_facts SET Value = 0 WHERE Value = 1 AND Status = 'applykbrules' AND Item = 'lgear'	

-- Prg16.0 definition. Mode lgear. Gear up.
--------------------------------------------------------------------------------
5	

SELECT A.Value FROM ( ( SELECT Value FROM sde_facts WHERE Item = 'mode_lgear' AND Value = 1 ) AS A JOIN ( SELECT Value FROM sde_facts WHERE Item = 'altitudeoverground' AND Value < ( ( SELECT Value FROM sde_facts WHERE Item = 'dec_alt' ) / 10 ) ) AS B ) WHERE A.Value = 1	

UPDATE sde_facts SET Value = 1 WHERE Value = 0 AND Status = 'applykbrules' AND Item = 'lgear'	

-- Prg16.0 definition. Mode lgear. Gear down.
--------------------------------------------------------------------------------
