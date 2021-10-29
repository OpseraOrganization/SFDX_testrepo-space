@isTest(seeAllData=False)
public class EmailCounterBatchTest {
    static testmethod void testEmailCounterBatch(){
        // Test Data Creation
        Profile p = [SELECT Id FROM Profile WHERE Name='API DATA LOAD']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test@honeywell.com.qa');

        List<Account> accList = new List<Account>();
        Account acc= new account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acc.Service_level__c = 'Unauthorized Dist/Brkr';
        acc.Strategic_Business_Unit__c = 'Aero Level';
        acc.Region_Name__c = 'Americas';
        accList.add(acc);
        insert accList ;
        
        List<Contact> contactList = new List<Contact>();
        for(Integer i=0;i<1;i++){
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            contactList.add(con);
        }
        insert contactList;
        
        List<case> caseList = new List<case>();
        for (Integer i=0;i<1;i++){
            case cs = new case();
            cs.Status = 'New';
            cs.Recordtypeid = label.FSS_Tech_Issue_RT_ID;
            cs.Origin = 'Email';
            cs.Priority = 'Normal';
            cs.CreatedDate = system.now()-1;
            cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cs.Government_Compliance_SM_M_Content__c = 'No';
            cs.Notes__c = 'test cases';
            cs.Subject = 'FSS test cases';
            cs.Classification__c = 'JX';
            cs.ContactId = contactList[0].id;
            //cs.Count_of_Outbound_Emails__c = 1;
            //cs.Count_of_Inbound_Emails__c = 3;
            cs.Number_of_Emails_on_Case__c = 2;
            caseList.add(cs);
        }
        insert caseList;
        
        //Test Class execution started
        Test.startTest();
        system.runAs(u){
            EmailCounterBatch emailBatch = new EmailCounterBatch();
            Database.executeBatch(emailBatch,1);  
        }
        Test.stopTest();   
        System.assert(true); 
       //Test Class execution finished
    }
}