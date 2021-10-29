/** * File Name: Test_Feedback_ApexClass1
* Description Test Method
* Copyright : NTT DATA
* * @author :  NTT DATA
* Modification Log =============================================================== 
*  4/1/15-Modified to cover Duplicate_Check_for_Feedback trigger code
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(SeeAllData=true)
private  class Test_Feedback_ApexClass1 {
    static testmethod void testCallCenter(){
    //creating account;
        
         Account acc= new Account(name='Test Account',Strategic_Business_Unit__c = 'ATR');
         insert acc;
         
        //creating contact;
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        //AccountTeamMember acTeam = new AccountTeamMember();
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E147567' );
        insert cont;
        
         //creating case
         Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
         Type='Order',Supported_Product__c='ADIRS',RecordTypeid=Label.Repair_Overhaul_RT_ID,Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Customer_Support_Focal__c =cont.id,Business_Focal__c=cont.id,Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test');
         insert cases;
        
        Test.startTest();
        Feedback__C voc= new Feedback__C(Account__c=acc.id,RecordTypeId=label.ATR_VOC_Record_Type,contact__C=cont.Id,Delivery_Weight__c=100,Warranty__c='1',Repair_Performance__c ='1',Delivery_Customer_Rating__c='Blue - Best in Class',ATR_Survey_Group__c ='Airbus',Consolidated_score__c = 1);
        try{
        insert voc;
        }catch(Exception e){
        }

        
        Feedback__C nss= new Feedback__C(Account__c=acc.id,Case__c = cases.id, RecordTypeId=label.NSS_Feedback,contact__C=cont.Id,ATR_Survey_Group__c ='Airbus',Consolidated_score__c = 1,NPS_Recommend__c =5,Ease_of_Contact_Availability__c =5,Quality_and_Accuracy__c =5,Courtesy_and_Professionalism__c = 5,Overall_satisfaction__c =5,Knowledge_Technical_Expertise__c =5,Timeliness_of_response__c=5,contact_requested__c ='yes');
        insert nss;
       
        
        Feedback__c fb = [SELECT Name FROM Feedback__c WHERE id =: voc.Id LIMIT 1];
       
        Go_Green_plan__C GGP= new Go_Green_plan__C(Account__c=accTeam.AccountId,Feedback_Record_Number__c=String.ValueOf(fb.Name),contact__C=cont.Id);
        try{
        insert GGP;
        }catch(Exception e){
        }
        Test.stopTest();
        voc.Warranty__c='2';
        update voc;
        
        
        PageReference pageRef = Page.ATRVOCSurveyRatings;
        Test.setCurrentPage(pageRef);               
        ApexPages.StandardController aps = new ApexPages.StandardController(GGP);
        ATRVOCSurvetratingscls atc = new ATRVOCSurvetratingscls(aps);
        
    }// end of method
    static testmethod void test_TaskCreation(){
         Account acc= new Account(name='Test Account',Strategic_Business_Unit__c = 'BGA');
         insert acc;
         
        //creating contact;
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        //AccountTeamMember acTeam = new AccountTeamMember();
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E147567' );
        insert cont;
        
         //creating case
         Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
         Type='Order',Supported_Product__c='ADIRS',RecordTypeid=Label.Repair_Overhaul_RT_ID,Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Customer_Support_Focal__c =cont.id,Business_Focal__c=cont.id,Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test');
         insert cases;
         
         //Creating user
         Profile pf= [select id from Profile where name = 'System Administrator'];
         User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
         insert usr;
         
         //Creating planned meeting
         Planned_Meeting__c planmeet = new Planned_Meeting__c(Owner_Name__c =usr.id,Ownerid =usr.id,RecordTypeid =label.PlannedMeeting_Contactplan,Assigned_To__c =usr.id,Name = 'Test',Meeting_Purpose__c ='test purpose',Account_Name__c =acc.id,Location__c ='India',SBU__c = 'D&S');
         insert planmeet;
         
        Test.startTest();
        try{
        Feedback__C tcm= new Feedback__C(Account__c=acc.id,RecordTypeId=label.TCM_Survey_Feedback_RecID,Planned_Meeting__c =planmeet.id, contact__C=cont.Id,No_of_Contacts_to_Resolve__c = '2',Quality_of_answers_for_TCM__c = 'Very Dissatisfied',Overall_satisfaction_for_TCM__c = 'Very Dissatisfied',Confidence_in_honeywell_for_TCM__c = 'Very doubtful');
        insert tcm;
        }catch(Exception e) {
        }
        Test.stopTest();
    }
    static testmethod void test_TaskCreation1(){
         Account acc= new Account(name='Test Account',Strategic_Business_Unit__c = 'D&S');
         insert acc;
         
        //creating contact;
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        //AccountTeamMember acTeam = new AccountTeamMember();
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E147567' );
        insert cont;
        
         //creating case
         Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
         Type='Order',Supported_Product__c='ADIRS',RecordTypeid=Label.Case_AOG_RecordType,Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Customer_Support_Focal__c =cont.id,Business_Focal__c=cont.id,Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test');
         insert cases;
         
         //Creating user
         Profile pf= [select id from Profile where name = 'System Administrator'];
         User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
         insert usr;
         
         //Creating planned meeting
         Planned_Meeting__c planmeet = new Planned_Meeting__c(Ownerid =usr.id,RecordTypeid =label.PlannedMeeting_Contactplan,Assigned_To__c =usr.id,Name = 'Test',Meeting_Purpose__c ='test purpose',Account_Name__c =acc.id,Location__c ='India',SBU__c = 'D&S');
         insert planmeet;
         
         Test.startTest();
         try{
         Feedback__C nss1= new Feedback__C(Ownerid =usr.id,Account__c=acc.id,Planned_Meeting__c =planmeet.id, Case__c = cases.id, RecordTypeId=label.NSS_Feedback,contact__C=cont.Id,Delivery_Weight__c=100,Warranty__c='1',Repair_Performance__c ='1',Delivery_Customer_Rating__c='Blue - Best in Class',ATR_Survey_Group__c ='Airbus',Consolidated_score__c = 1,NPS_Recommend__c =5,Ease_of_Contact_Availability__c =5,Quality_and_Accuracy__c =5,Courtesy_and_Professionalism__c = 5,Overall_satisfaction__c =5,Knowledge_Technical_Expertise__c =5,Timeliness_of_response__c=5,contact_requested__c ='yes');
         insert nss1; 
         }catch(Exception e) {
         }
         Test.stopTest();
         }
         static testmethod void test_TaskCreation2(){
         Account acc= new Account(name='Test Account',Strategic_Business_Unit__c = 'BGA');
         insert acc;
         
        //creating contact;
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        //AccountTeamMember acTeam = new AccountTeamMember();
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E147567' );
        insert cont;
        
         //creating case
         Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
         Type='Order',Supported_Product__c='ADIRS',RecordTypeid=Label.Repair_Overhaul_RT_ID,Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Customer_Support_Focal__c =cont.id,Business_Focal__c=cont.id,Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test');
         insert cases;
         
         //Creating user
         Profile pf= [select id from Profile where name = 'System Administrator'];
         User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
         insert usr;
         
         //Creating planned meeting
         Planned_Meeting__c planmeet = new Planned_Meeting__c(Ownerid =usr.id,RecordTypeid =label.PlannedMeeting_Contactplan,Assigned_To__c =usr.id,Name = 'Test',Meeting_Purpose__c ='test purpose',Account_Name__c =acc.id,Location__c ='India',SBU__c = 'D&S');
         insert planmeet;
         
        Test.startTest();
        try{
        Feedback__C nss1= new Feedback__C(Ownerid =usr.id,Account__c=acc.id,Planned_Meeting__c =planmeet.id, Case__c = cases.id, RecordTypeId=label.NSS_Feedback,contact__C=cont.Id,Delivery_Weight__c=100,Warranty__c='1',Repair_Performance__c ='1',Delivery_Customer_Rating__c='Blue - Best in Class',ATR_Survey_Group__c ='Airbus',Consolidated_score__c = 1,NPS_Recommend__c =5,Ease_of_Contact_Availability__c =5,Quality_and_Accuracy__c =5,Courtesy_and_Professionalism__c = 5,Overall_satisfaction__c =5,Knowledge_Technical_Expertise__c =5,Timeliness_of_response__c=5,contact_requested__c ='yes');
        insert nss1;
        }catch(Exception e) {
        }
        Test.stopTest();
    }
    
    static testmethod void test_TaskCreation3(){
         Account acc= new Account(name='Test Account',Strategic_Business_Unit__c = 'BGA');
         insert acc;
         
        //creating contact;
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        //AccountTeamMember acTeam = new AccountTeamMember();
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E147567' );
        insert cont;
        
         //creating case
         Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
         Type='Order',Supported_Product__c='ADIRS',RecordTypeid=Label.Repair_Overhaul_RT_ID,Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Customer_Support_Focal__c =cont.id,Business_Focal__c=cont.id,Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test');
         insert cases;
         
         //Creating user
         Profile pf= [select id from Profile where name = 'System Administrator'];
         User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
         insert usr;
         
         //Creating planned meeting
         Planned_Meeting__c planmeet = new Planned_Meeting__c(Ownerid =usr.id,RecordTypeid =label.PlannedMeeting_Contactplan,Assigned_To__c =usr.id,Name = 'Test',Meeting_Purpose__c ='test purpose',Account_Name__c =acc.id,Location__c ='India',SBU__c = 'D&S');
         insert planmeet;
         
        Test.startTest();
        try{
        Feedback__C nss1= new Feedback__C(Ownerid =usr.id,Account__c=acc.id,Planned_Meeting__c =planmeet.id, Case__c = cases.id, RecordTypeId=label.NSS_Feedback,contact__C=cont.Id,Delivery_Weight__c=100,Warranty__c='1',Repair_Performance__c ='1',Delivery_Customer_Rating__c='Blue - Best in Class',ATR_Survey_Group__c ='Airbus',Consolidated_score__c = 1,NPS_Recommend__c =5,Ease_of_Contact_Availability__c =5,Quality_and_Accuracy__c =5,Courtesy_and_Professionalism__c = 5,Overall_satisfaction__c =1,Knowledge_Technical_Expertise__c =5,Timeliness_of_response__c=5,contact_requested__c ='yes');
        insert nss1;
        }catch(Exception e) {
        }
        Test.stopTest();
    }
}// end of class