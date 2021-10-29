/*
Created By : Puvaneswari
Created Date : 10-March-2020
Usages : test class methods for CaseQualityHandler and CaseQualityController     
*/
@isTest
public class TestCaseQualityHandler {
    @testSetup
    public static void setupData() {
        TriggerInactive.testTrigger = false;
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        //  testAccts.add(new Account(Name = 'TestAcct'+i));
        
        User testUser = new User(FirstName = 'TestFirstName',LastName = 'TestLastName',Email = 'test_radha@in.ibm.com',
                                 Username = 'test_radha@in.ibm.com',Alias = 'TestF',ProfileId = p1.Id,
                                 TimeZoneSidKey = 'America/Denver',LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
                                 LanguageLocaleKey = 'en_US');
        insert testUser;
        Account act = new Account (  Name ='Test Account New',Customer_Status__c = 'Active',Strategic_Business_Unit__c = 'ATR',
                                   CBT__c ='Airlines',Region_Name__c = 'Americas', Sub_Region_Name__c = 'Canada',Service_Level__c = 'Unauthorized Dist/Brkr',               
                                   Type = 'OEM',REPORT_ACCOUNT_NAME__c = 'Test Account New',Market_Name__c = 'Marine',CBT_Team__c ='Asia Pacific ATR');
        insert act;
        Contact con = new Contact ( LastName = 'Balu', FirstName = 'Puvana',AccountId = act.Id,Primary_Email_Address__c ='puvaneswari.balu@nttdata.com',
                                   Address_Line_1__c='Address 1',Address_Line_2__c='Address 1', Address_Line_3__c='Address 1',City_Name__c='MN',
                                   State_Code__c='55667',Country_Name__c='USA',Email='puvaneswari.balu@nttdata.com');
        insert con;
        list<case> csList = new list<Case>();
        for(integer i=0; i<5; i++)
        {
            case cs = new Case(Origin = 'Email', Quote_Number__c = 'My1234', ContactId = con.Id,AccountId = act.Id,Type_of_Change__c = 'New Account',
                               Type = 'Other', OwnerId = testUser.Id , Communication_Channel__c= 'E-mail');      
            if(i<=1)
            {   cs.Status = 'Open';
             cs.Case_Priority__c ='Priority 1 – AOG/Urgent: Answer < 4 hrs';
             cs.Customer_Update_Frequency__c = 'Every 30 mins';
             cs.Time_Email_Sent__c = datetime.now().addMinutes(5);
            }
            else if(i<=3)
            {
                cs.Status = 'Done';
                cs.Case_Priority__c ='Priority 2 – AOG/Critical: Answer < 24 hrs';
                cs.Customer_Update_Frequency__c = 'Every 8 hours';
                cs.Time_Email_Sent__c = datetime.now().addHours(6);
            }
            else
            {
                cs.Status = 'Done';
                cs.Case_Priority__c ='Priority 4 – Complex: 1 week to 30 days';
                cs.Customer_Update_Frequency__c = 'Every 7 days';
                cs.Time_Email_Sent__c = datetime.now().addDays(5);
            }
            csList.add(cs);
        }
        Insert csList;
    }
    public static testMethod void testCreateSessions()
    {
        user u = [select id from User limit 1];
        List<Case_Quality_Audit__c> cqaList = new List<Case_Quality_Audit__c>();
        list<case> caseRecord = [Select id,CaseNumber,Origin,Communication_Channel__c,Customer_Update_Frequency__c,CreatedDate,Time_Email_Sent__c from Case limit 5];
        test.startTest();
        system.runAs(u){
            for (case c: caseRecord)
            { 
                CaseQualityController.checkCaseQuality(c.id);
             }
        }
        test.stopTest();
    }
    public static testMethod void testCreateSessions1()
    {
        TriggerInactive.testTrigger = false;
        list<case> caseRecord = [Select id,CaseNumber,Origin,IsClosed,Communication_Channel__c,Customer_Update_Frequency__c,CreatedDate,Time_Email_Sent__c from Case limit 5];
        list<Case_Quality_Audit__c> cqaList =new list<Case_Quality_Audit__c>();
        list<EmailMessage> emList =new list<EmailMessage>();
        list<String> statusList = new list<String>{'New','Read','Relied','Sent','Forwarded'};
            for(integer i = 0; i<5;i++)
        {
            
            EmailMessage emailMess1=new  EmailMessage(subject='AutoReply-Test'+i, ParentId =caseRecord[i].id,status = string.valueOf(i));
            emList.add(emailMess1);
            Case_Quality_Audit__c cq = New Case_Quality_Audit__c(Case__c=caseRecord[i].id);
            cqaList.add(cq);
        }
        test.startTest();
        insert emList;
        insert cqaList;
        for(case c: caseRecord){
            ApexPages.StandardController sc = new ApexPages.standardController(c);
            CaseQualityController controller = new CaseQualityController(sc);
            CaseQualityController.Emails();
        }
        test.stopTest();
    }   
}