@isTest(SeeAllData=true)
private class TestClass_ApexTrgr_WNHApproverUpdate{ 

    static testMethod void WNHApproverUpdateTest()
    {
  
 Profile prf = [Select id from profile where name = 'System Administrator'];
        UserRole rl = [select id from userrole where name='GTO AM DS FSE 6A'];
        
        User usr =new User(EmployeeNumber='E123456',firstname='Test',lastname='test',
        Username='dfdsf@fff.com', Email='akila.rajmahadev@nttdata.com', Alias='sdfsdf', CommunityNickname='sdfsd',
        TimeZoneSidKey='America/Phoenix',LocaleSidKey='en_US',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',           
        ProfileId=prf.id,userroleid=rl.id);         
        insert usr;
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {       
        Test.StartTest();
        Platform__c PLFrec= new Platform__c();
PLFrec.name='PLF_Test_rec';
insert PLFrec;

Account AccRec = new Account();
AccRec.name='Acc_Text_rec';
AccRec.Type='OEM';
AccRec.Strategic_Business_Unit__c='ATR';
AccRec.CBT__c='Airbus';
AccRec.Customer_Status__c='Active';
AccRec.Region_Name__c='Americas';
AccRec.Sub_Region_Name__c='Canada';
AccRec.Service_Level__c='Standard';

insert AccRec;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=usr.id;
APPRec_CA.Business_Unit__c='ATR';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';

insert APPRec_CA;
        Workflow_details__c wfDetailTest = new Workflow_details__c(Status__c = 'In Progress');
        insert wfDetailTest ;
        WorkFlow_Approval_History__c tstWfAppHstry = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Pending Approval',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);
        
        insert tstWfAppHstry;
        
       WorkFlow_Approval_History__c tstWfAppHstry1 = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Pending Approval',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);
        insert tstWfAppHstry1;
        test.stoptest();
        
        tstWfAppHstry1.Approval_Status__c = 'Approved';
        Update tstWfAppHstry1;    
       
     }   
   } 
}