/** * File Name: CampaignTarget_Insert_Test
* Description Test Method
* Class Tested: CampaignTarget_Insert
* * @author : NTTDATA
* Modification Log 
=============================================================== /**
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
@isTest
private class CampaignTarget_Insert_Test {

    static testMethod void myUnitTest()
    {
      test.starttest(); 
         Account acc = new Account(
            Name = 'Test Account'            
        );
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Singh';
        con.FirstName = 'Kapil';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
        con.Email='kapil.nowhere@gmail.com';
        insert con;
        
        list<Platform__c> plist= new list<Platform__c>();
         Platform__c p = new Platform__c();
         p.Name = 'Test Paltform';
         p.Model__c = '36-16A';
         p.Make__c = 'VARIOUS OEMS';
         plist.add(p);
         
         Platform__c p1 = new Platform__c();
         p1.Name = 'Test Paltform';
         p1.Model__c = '36-16A';
         p1.Make__c = 'VARIOUS OEMS';
         plist.add(p1);
         insert plist;
         
        list<Fleet_Asset_Detail__c> fleetlist= new list<Fleet_Asset_Detail__c>();
        Fleet_Asset_Detail__c make=new Fleet_Asset_Detail__c(
        Platform_Name__c = p.id,
        Account__c=acc.id
        );
        fleetlist.add(make);
        
        Fleet_Asset_Detail__c make1=new Fleet_Asset_Detail__c(
        Platform_Name__c = p.id,
        Account__c=acc.id
        );
        fleetlist.add(make1);
        insert fleetlist;
         
         Campaign cam = new Campaign();
         cam.Name='Test Campaign';
         cam.CampaignPrimarySBU__c='D&S';
         cam.Type='Email';
         cam.Platform__c=p.id;
         insert cam;
         
         Campaign_Target__c ct= new  Campaign_Target__c();
         ct.Campaign__c=cam.id;
         ct.Target_Contact__c=con.id;
         insert ct;
         
         cam.Platform__c=p1.Id;
         update cam;
         
     test.stopTest();
    }
}