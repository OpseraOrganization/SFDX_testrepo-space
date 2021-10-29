@isTest(SeeAllData=true)
private class Send_Mail_NotificationClassTest{ 

static testMethod void myUnitTest()
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

Approver__c APPRec_MPM= new Approver__c();
APPRec_MPM.name='Test_App_rec';
APPRec_MPM.Approver_Name__c=usr.id;
APPRec_MPM.Business_Unit__c='ATR';
APPRec_MPM.Region__c='Americas';
APPRec_MPM.Tier__c='Aero Tier 0';
APPRec_MPM.Approver_type__c='M&PM ';

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=usr.id;
APPRec_CA.Business_Unit__c='ATR';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Notification';

insert APPRec_CA;


Workflow_details__c WFrec= new Workflow_details__c();
WFrec.Wokflow_Name__c='WF_Test_rec';
WFrec.Approval_Level_in_Progress__c='Draft';
WFrec.Atlas_or_P_DR__c='Test';
WFrec.Proposal_Title__c='TM_rec';
WFrec.Contract_Manager__c='TM_Mngr';
WFrec.Pricing_Proposal_Type__c='TINA';
WFrec.Sales_K__c=1;
WFrec.X5_Year_Revenue_K__c=1;
WFrec.Terms_and_Conditions__c='Standard';
WFrec.Front_End_Loss__c=1;
WFrec.Exposed_Cost__c=1;
WFrec.Front_End_Loss_Max_Year__c=1;
WFrec.Exposed_Cost_Max_Year_K__c=1;
WFrec.Contract_Type__c='Cost Sharing';
WFrec.Platform__c=PLFrec.id;
WFrec.Customer_Name__c=AccRec.id;
WFrec.Status__c='Draft';
WFrec.Approval_Level_Required__c='Aero Tier 0';
WFrec.Approval_Level_in_Progress__c='Aero Tier 0';
WFRec.Americas__c=True;
WFRec.Requester_s_Comments__c='Test';
insert WFrec;


WFrec.Status__c='In Progress';
update WFrec;
Workflow_details__c WFrec1= new Workflow_details__c();
WFrec1.Wokflow_Name__c='WF_Test_rec';
WFrec1.Approval_Level_in_Progress__c='Draft';
WFrec1.Atlas_or_P_DR__c='Test';
WFrec1.Proposal_Title__c='TM_rec';
WFrec1.Contract_Manager__c='TM_Mngr';
WFrec1.Pricing_Proposal_Type__c='TINA';
WFrec1.Sales_K__c=1;
WFrec1.X5_Year_Revenue_K__c=1;
WFrec1.Terms_and_Conditions__c='Standard';
WFrec1.Front_End_Loss__c=1;
WFrec1.Exposed_Cost__c=1;
WFrec1.Front_End_Loss_Max_Year__c=1;
WFrec1.Exposed_Cost_Max_Year_K__c=1;
WFrec1.Contract_Type__c='Cost Sharing';
WFrec1.Platform__c=PLFrec.id;
WFrec1.Customer_Name__c=AccRec.id;
WFrec1.Status__c='Approved';
WFrec1.Approval_Level_Required__c='Aero Tier 0';
WFrec1.Approval_Level_in_Progress__c='Aero Tier 0';
WFRec1.Americas__c=True;
WFRec1.Requester_s_Comments__c='Test';
insert WFrec1;


WorkFlow_Approval_History__c wkhstryRec1=new WorkFlow_Approval_History__c();
wkhstryRec1.Workflow_details__c=WFrec.id;
wkhstryRec1.Tier__c=WFrec.Approval_Level_in_Progress__c;
wkhstryRec1.Approval_Status__c='Pending Approval';
//wkhstryRec1.Email__c='akila.rajmahadev@nttdata.com';
wkhstryRec1.Select_Approver__c=APPRec_CA.id;
wkhstryRec1.Approver_Type__c='Notification';
wkhstryRec1.Delete_Check_Box__c=False;
wkhstryRec1.Approval_submitted_date__c=system.today();
insert wkhstryRec1;

Workflow_Notification_History__c wnh=new Workflow_Notification_History__c();
wnh.Email__c='akila.rajmahadev@nttdata.com';
wnh.Select_Approver__c=APPRec_CA.id;
wnh.Workflow_details__c=WFrec.id;
insert wnh;

Workflow_Notification_History__c wnh2=new Workflow_Notification_History__c();
wnh2.Email__c='akila.rajmahadev@nttdata.com';
wnh2.Select_Approver__c=APPRec_CA.id;
wnh2.Workflow_details__c=WFrec1.id;
insert wnh2;

/*wkhstryRec1= [select Email__c from Workflow_Approval_History__c where Id = :wkhstryRec1.id];
WAHReminderBatchs objskup = new WAHReminderBatchs ();
        objskup.noofdays=1;
        DateTime dt = System.now();
        dt=dt.addDays(-objskup.noofdays);
        
        Integer intcount = [SELECT count() from WorkFlow_Approval_History__c WHERE LastModifiedDate >:dt];      
        System.debug('COUNTTTTTTTTTTT'+intcount);
        ID batchid = Database.executeBatch(objskup ,intcount );
        
        
        
        WAHReminderBatchs rem= new WAHReminderBatchs ();
        String sch = '0 42 02 24 06 ?';
        System.Schedule('SkillUpdateScheduler-Testing', sch, rem );*/
        
        Test.StopTest();
        }
        }
        }