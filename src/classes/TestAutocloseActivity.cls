@isTest
public class TestAutocloseActivity{
    static testMethod void TestAutocloseActivity(){
        TriggerInactive.testTrigger = false;
        Profile p = [select id from profile where name='System Administrator' limit 1];
        User u = new User();
        u.alias = 'standt';
        u.email='harikishore.vutukuri@nttdata.com';
        u.emailencodingkey='UTF-8';
        u.lastname='Testing';
        u.languagelocalekey='en_US';
        u.localesidkey='en_US';
        u.profileid = p.Id;
        u.timezonesidkey='America/Los_Angeles';
        u.CommunityNickname='tcs';
        u.Username='myTest2User@nttdata.com';
        insert u;
        
        User u1 = new User();
        u1.alias = 'standte';
        u1.email='harikishore.vutukuri@nttdata.commm';
        u1.emailencodingkey='UTF-8';
        u1.lastname='Testing test';
        u1.languagelocalekey='en_US';
        u1.localesidkey='en_US';
        u1.profileid = p.Id;
        u1.timezonesidkey='America/Los_Angeles';
        u1.CommunityNickname='tcscc';
        u1.Username='myTest2User@nttdata.commm';
        insert u1;

        Account a= new Account();
        a.Name='Tesst Account';
        a.Customer_Status__c='Active';
        a.Region_Name__c='Americas';
        a.Sub_Region_Name__c='Africa';
        a.Service_Level__c='Comprehensive';
        a.Strategic_Business_Unit__c='ATR';
        a.CBT__c='Airbus';
        a.CBT_Team__c='Airbus';
        a.Market_Name__c='Air Transport';
        a.Business_Owner__c='Ryan, Justin';
        a.Type='Air Cargo Transporter';
        a.REPORT_ACCOUNT_NAME__c='Test Report';
        insert a;

        Contact c= new Contact();
        c.AccountId=a.Id;
        c.LastName='Hari';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='test@test.com';
        c.Phone_1__c= '12345678';
        insert c;
        Test.StartTest();
        Case c1= new Case();
        c1.Origin='Email';
        c1.Export_Compliance_Content_ITAR_EAR__c='No';
        c1.Government_Compliance_SM_M_Content__c='Yes';
        c1.Status='Open';  
        c1.Type='AOG';
        c1.HON_Commit_Date__c=date.Today()+5;
        c1.ContactId=c.Id;
        c1.OwnerId = u.id;
        c1.Date_Time_Stamp_First_Assigned_to_User__c = system.now();
        c1.Date_Time_Stamp_User_Assignment_Change__c = system.now();
        insert c1;
        c1.OwnerId = '00G30000002YnyO';
        c1.Status = 'On Hold';
        c1.Sub_Status__c = 'Waiting for Customer response';
        c1.Status_Changed__c = true;
        c1.Date_Time_Stamp_First_Assigned_to_User__c = system.now();
        c1.Date_Time_Stamp_User_Assignment_Change__c = system.now();
        c1.VN_Name__c=c.id;
        c1.Reason_for_hold__c='Business Hold';
        update c1;

        Task tsk = new Task();
        tsk.Priority = 'High';
        tsk.Status = 'Open';
        tsk.Subject = 'Other';
        tsk.Whatid= c1.id;
        insert tsk;
        c1.Status='cancelled';
        c1.Reason_for_Cancellation__c= 'Duplicate CASE';
        c1.resolution__c = 'abc test test';
        update c1;
        Test.StopTest();
    }
}