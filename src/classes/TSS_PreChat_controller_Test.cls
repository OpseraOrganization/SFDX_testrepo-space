@isTest
public class TSS_PreChat_controller_Test {
    static testmethod void preChatCtrlTest1(){
        test.startTest();
        Profile p = [select id from profile where name ='Overage Authenticated Website User' limit 1];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>p<<<<<<<<<<<>>>>'+p);
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        system.debug('>>>>>acc Sumit>>>>'+acc);
        
        Contact con = new Contact();
        con.LastName = 'G';
        con.FirstName = 'sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit.gupta@testdata.com';
        con.Email='sumit.gupta@ntestdata.com';
        insert con;
        system.debug('>>>>>con Sumit>>>>'+con);
        
        //For Line 34
        User usr = new User();
        usr.alias = 'Sumit';
        usr.email = 'sumit@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='G';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        usr.isactive=true;
        usr.contactId=con.Id;
        insert usr;
        system.debug('>>>>>>>>>>>>usr<<<<<<<<<<<'+usr);
        
        system.runAs(usr){
        	TSS_PreChat_controller.GetUserAccount();
        }
        test.stopTest();
    }
}