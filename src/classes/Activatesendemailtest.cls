/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class Activatesendemailtest {

    static testMethod void myUnitTest() {
    user tstuser = [select id from user where name = 'sfdc admin'];
    test.starttest(); 
        
        Campaign cam = new Campaign();
        cam.Name='test campaign12';
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus';
        cam.Status = 'Planned';
        cam.Type = 'Test';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 645655;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'test';
         insert cam;
    Discretionary__c DiscNew=new Discretionary__c ();
    DiscNew.CBT__c='Airlines';
    DiscNew.SBU__c='ATR';
    DiscNew.Estimated_Completion_Date__c = System.today()+10;
    DiscNew.Campaign__c=cam.id;
    insert DiscNew;
    
    Plant_Code_Master__c PlntcodeMstr = new Plant_Code_Master__c();
    PlntcodeMstr.Name='Testing';
    insert PlntcodeMstr;
    
    Plant_Code_del__c PntcodeRec= new Plant_Code_del__c();
    PntcodeRec.Name='Testing';
    PntcodeRec.Plant_Code_Master__c=PlntcodeMstr.id;
    PntcodeRec.SBU__c='ATR';
    PntcodeRec.CBT__c='Airlines';
    PntcodeRec.Backup_Account_Opener__c = tstuser.id;
    PntcodeRec.Primary_Account_Opener__c = tstuser.id;
    insert PntcodeRec; 
  
    Discretionary_Line_Item__c DiscLineItem=new Discretionary_Line_Item__c();
    DiscLineItem.Discretionary_Request__c= DiscNew.Id;
    DiscLineItem.Plant_Code_Master__c=PlntcodeMstr.id;
    insert DiscLineItem;
    
    
    PageReference pageRef = Page.Activate_send_Email;
    pageRef.getParameters().put('id', String.valueOf(DiscLineItem.Id)); 
    Test.setCurrentPage(pageRef);
    ApexPages.StandardController sc = new ApexPages.StandardController(DiscLineItem);
    Activatesendemail testd = new Activatesendemail(sc);
    testd.updateActivate_send_Email_field();
    testd.back();
  
    }
}