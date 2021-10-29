/*
Created By : Shwetha Penumalla
Created Date : 29-April-2020
Usages : test class methods for DisplayArticleOnCaseController    
*/
@isTest
public class DisplayArticleOnCaseControllerTest {
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
        for(integer i=0; i<3; i++)
        {
            case cs = new Case(Origin = 'Email', Quote_Number__c = 'My1234', ContactId = con.Id,AccountId = act.Id,Type_of_Change__c = 'New Account',
                               Type = 'Other', OwnerId = testUser.Id);      
               cs.Status = 'Open';
             cs.Time_Email_Sent__c = datetime.now().addMinutes(5);
            
         
            csList.add(cs);
        }
        Insert csList;
    }
    
    public static  testMethod void DisplayArticlesTest(){
        TriggerInactive.testTrigger = false;
        list<case> caseRecord = [Select id,CaseNumber,Origin,IsClosed,Communication_Channel__c,Customer_Update_Frequency__c,CreatedDate,Time_Email_Sent__c from Case limit 3];
        list<Case_Quality_Audit__c> cqaList =new list<Case_Quality_Audit__c>();
        Case_Quality_Audit__c cq = New Case_Quality_Audit__c(Case__c=caseRecord[0].id);
        insert cq;
        //cqaList.add(cq);
        //insert cqaList;
        Knowledge__kav k = new Knowledge__kav(URLName = 'test-sample-article',Title = 'testsample' ,validationStatus = 'WIP',Technical_review_needed__c='No'
                                                             //,Engineering_review_needed__c = 'No',Marcom_review_needed__c='No',Product_Mgmt_review_needed__c = 'No',Legal_review_needed__c='No'
                                                             ,Question_Problem__c = 'Sample',
                                              Answer_Solution__c ='Sample answer'
                                                             );  
        Insert k;
        Knowledge__kav k1 = new Knowledge__kav();
        k1 = [select id,KnowledgeArticleId from Knowledge__kav where id =:k.id];
      //  KbManagement.PublishingService.publishArticle(k1.KnowledgeArticleId, true);
        caseArticle c = new caseArticle();
       c.KnowledgeArticleId = k1.KnowledgeArticleId;
        c.caseID = caseRecord[0].id;
        insert c;
        test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', cq.id);
       
             ApexPages.StandardController sc = new ApexPages.standardController(cq);
            DisplayArticleOnCaseController controller = new DisplayArticleOnCaseController(sc);
            DisplayArticleOnCaseController.DisplayArticles();
        
           
        
        
        test.stopTest();
    }
    
}