@isTest
public class Test_UpdateMSPCustomerProfileCheck_Batch {
static testMethod void Test_UpdateMSPCustomerProfileCheck_Batch()
{
 list <Contract> scope =new list <Contract>();   
    Profile p = [select id from profile where name='System Administrator' limit 1];
 User usr = new User();
        usr.alias = 'dhivya';
        usr.email = 'dhivya124553@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='testtddhhi';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduserdhiv@testing.com';
        usr.isactive=true;
        insert usr;
          User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    Profile pf= [select id from Profile where name = 'Honeywell System Administrator' limit 1];
//  System.runAs ( thisUser ) {       
    
        
        system.debug('pf'+pf.id);
        User usr1 = new User(LastName = 'TestUsrCont',Username = 'tescontact@test.com',Email = 'testuserContact@test.com',Alias = 'tcnt' ,CommunityNickname= 'tucont' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',isactive=true,ProfileId = pf.Id);
        insert usr1;
        Test.StartTest();
    Account acc=new Account(name='Test');
    insert acc;
        Contact cont=new Contact(firstname='Test',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502456',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E534543',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id );
        insert cont;
    Contract con= new Contract();
    con.name='test';
    con.AccountId=acc.id;
    con.Renewal_Start_date__c=System.today().addDays(100);
    con.MSP_Customer_Profile_Automation__c='Data Loaded';
    con.Renewal_Order_Receipt_Name__c=cont.id;
    con.RecordTypeId = system.label.MSP_Contract_RTID;
    insert con;
    UpdateMSPCustomerProfileCheck_Batch MSPBatch = new UpdateMSPCustomerProfileCheck_Batch();
    database.executeBatch(MSPBatch,200);
    UpdateMSPCustomerProfileCheck_Batch rem = new UpdateMSPCustomerProfileCheck_Batch();
        String sch = '0 24 17 19 08 ?';
        System.Schedule('UpdateMSPCustomerProfileCheck_Batch-Testing', sch, rem ); 
    Test.StopTest();
//}
}
}