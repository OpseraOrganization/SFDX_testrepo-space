@isTest(SeeAllData=true)
private class TestClass_ApexTrgr_WAHRejectedUpdate{ 

    static testMethod void ApproverUpdateTest()
    {
        Profile prf = [Select id from profile where name = 'System Administrator'];
        UserRole rl = [select id from userrole where name='GTO AM DS FSE 6A'];
        
        User usr =new User(EmployeeNumber='H248860',firstname='Test',lastname='test',
        Username='tinulin@nttdata.com.qa', Email='mariakitheri.tinulin@nttdata.com', Alias='sdfsdf', CommunityNickname='sdfsd',
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
APPRec_CA.Email__c = 'mariakitheri.tinulin@nttdata.com';

insert APPRec_CA;
        Workflow_details__c wfDetailTest = new Workflow_details__c(Status__c = 'In Progress');
        insert wfDetailTest ;
        WorkFlow_Approval_History__c tstWfAppHstry = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Pending Approval',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);       
        insert tstWfAppHstry;
        
        WorkFlow_Approval_History__c tstWfAppHstry1 = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Pending Approval',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);
        insert tstWfAppHstry1;
        
        WorkFlow_Approval_History__c tstWfAppHstry2 = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Rejected',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);
        insert tstWfAppHstry2;
        
        tstWfAppHstry2.Approval_Status__c='Approved';
        update tstWfAppHstry2;
        
        
        WorkFlow_Notification_History__c Wnh = new WorkFlow_Notification_History__c(Workflow_details__c = wfDetailTest .id,Select_Approver__c = APPRec_CA.id,Email__c = 'mariakitheri.tinulin@nttdata.com');
        insert wnh;
        test.stoptest();
        tstWfAppHstry1.Approval_Status__C ='Rejected';
        try{
        update tstWfAppHstry1;
        }Catch(DMLException e){}
        tstWfAppHstry.Approval_Status__C ='Approved';
        try{
        update tstWfAppHstry;
        }Catch(DMLException e){}     
        
      }  
        
    }
}