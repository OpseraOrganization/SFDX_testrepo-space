@istest(seealldata = true)
public class skils_testpage_test{

static testMethod void TestMethod1(){

ApexPages.StandardController controller;
skils_testpage stp = new skils_testpage(controller);
stp.skillvalue_selector();
stp.getSkillValues();
stp.mymethod();
stp.getCountries();
stp.getEmployregion();
skils_testpage.getFSECountryvalues();
skils_testpage.getStatevalues('test');
skils_testpage.getResultValue('test','chicago');
skils_testpage.getEscalateValue('Asia/Pacific Rim');
skils_testpage.getatstollfreeno('test','USA');
stp.getSkillType();
}

static testMethod void TestMethod2(){
skils_testpage.getResultValue('Areas Covered Canada','chicago');
skils_testpage.getEscalateValue('Europe/MiddleEast/Africa/India');
skils_testpage.getStatevalues('Area Covered US');
skils_testpage.getatstollfreeno('ATS','USA');
}


static testMethod void TestMethod3(){
skils_testpage.getResultValue('Areas Covered Canada','--None--');
skils_testpage.getResultValue('test','--None--');
skils_testpage.getEscalateValue('Americas');
skils_testpage.getatstollfreeno('AERO','USA');
}

}