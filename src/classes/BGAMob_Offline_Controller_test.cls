@istest(seealldata = true)
public class BGAMob_Offline_Controller_test{

static testMethod void TestMethod1(){

ApexPages.StandardController controller;
BGAMob_Offline_Controller bga = new BGAMob_Offline_Controller(controller);
BGAMob_Offline_Controller.queryContacts();
BGAMob_Offline_Controller.querySkills();
BGAMob_Offline_Controller.queryAccountAddress();
//BGAMob_Offline_Controller.phoneGapUrl ='android';
Test.setCurrentPageReference(new PageReference('Page.BGAMob_HomePage'));
System.currentPageReference().getParameters().put('User-Agent', 'android');
string temp = bga.phoneGapUrl;

}
}