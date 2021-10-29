@istest(seealldata = true)
public class BGACSM_test{

static testMethod void TestMethod1(){


ApexPages.StandardController controller;
BGACSM bga = new BGACSM(controller);

bga.getSkillType();
bga.skillvalue_selector();
BGACSM.getStatevalues('Area Covered US');
BGACSM.getASMCountryvalues();
BGACSM.getResultValue('Area Covered US','Arizona');
BGACSM.getResultValue('Area Covered US','--None--');
BGACSM.getResultValue('india','--None--');


BGACSM.getResValue('Area Covered US','Arizona');
BGACSM.getResValue('Area Covered US','--None--');
BGACSM.getResValue('india','--None--');


BGACSM.gethelisupport('Area Covered US','Arizona');
BGACSM.gethelisupport('Area Covered US','--None--');
BGACSM.gethelisupport('india','--None--');


}


}