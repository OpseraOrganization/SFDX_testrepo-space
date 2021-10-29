/** * File Name: Test_PreventAccountCreation
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_PreventAccountCreation
{
    static testmethod void PreventAccountCreation_Triggers(){
        //variable declaration
        List<Lead> LeadList= new List<Lead>();

        Profile pf= [select id from Profile where name = 'C&PS D&S (Non US)'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        
        Profile ProfRec = [select name from Profile where name = 'Master Data Administrator'];
        User userRec = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
        insert userRec;

        System.runAs(userRec)
        {
            try
            {
                Account acc= new Account(name='NewAcnt');
                insert acc;
                Lead Initiator1=new Lead(LastName='Test',Account__c=acc.Id,Primary_Fax_Number__c='12345',Company='NewcOMPNY');
                LeadList.add(Initiator1);
                insert Initiator1;
            }
            catch(System.DMLException e){System.assert(e.getMessage().contains(
                'To create a new account please contact the Aero DataMaster Team'),
                  e.getMessage());
        }
        /*System.runAs(usr)
        {
            try
            {
                Account acc1= new Account(name='NewAct');
                insert acc1;
                Lead Ini1=new Lead(LastName='Test1',Account__c=acc1.Id,Primary_Fax_Number__c='1345',Company='Newcp');
                LeadList.add(Ini1);
                insert Ini1;
            }
            catch(System.DMLException e){System.assert(e.getMessage().contains(
                    'To create a new account please contact the Aero DataMaster Team'),
                      e.getMessage());
            }
        }*/
        }// end of method
    }// end of class               
}