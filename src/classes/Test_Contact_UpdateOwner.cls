/** * File Name: Test_Contact_UpdateOwner
* Description :Trigger to update owner
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log =============================================================== **/
@isTest
private class Test_Contact_UpdateOwner{

    static testMethod void myUnitTest() {
    
        User MasterUsr= [select id from User where name = 'API User SFDC Cust Master'];
        Profile pf= [select id from Profile where name = 'Honeywell System Administrator'];
        // User usr1 = new User(LastName = 'TestUsrCont',Username = 'tuContact@test.com',Email = 'testuserContact@test.com',Alias = 'tcnt' ,CommunityNickname= 'tucont' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',IsActive= False,ProfileId = pf.Id);
        // insert usr1;
        User usr1 = new User(LastName = 'TestUsrCont',Username = 'tuContact@test.com',Email = 'testuserContact@test.com',Alias = 'tcnt' ,CommunityNickname= 'tucont' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',ProfileId = pf.Id);
        insert usr1;
        
        //creating account;
        Account acc= new Account(name='Test Contact Inactive Account');
        insert acc;

        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502456',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E534543',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id );
        insert cont;
       
        // usr1.IsActive= False;
        // update usr1;
       
        // User Inactiveusr= [select id,IsActive  from User where  IsActive  =False limit 1];

       cont.ownerid =MasterUsr.id;
       update cont;
       
       cont.Contact_Status__c = 'Inactive';
       cont.OwnerId = Label.Inactive_Record_Owner_Id;
       update cont;
    }
}