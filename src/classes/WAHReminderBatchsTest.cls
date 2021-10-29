@isTest
private class WAHReminderBatchsTest{ 
    
    static testMethod void WAHReminderexecute()
    {
        
        Profile prf = [Select id from profile where name = 'System Administrator'];
        UserRole rl = [select id from userrole where name='GTO AM DS FSE 6A'];
        
        User usr =new User(EmployeeNumber='E123456',firstname='Test',lastname='test',
                           Username='dfdsf@fff.com', Email='soniya.ramachandran@nttdata.com', Alias='sdfsdf', CommunityNickname='sdfsd',
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
            APPRec_CA.Approver_type__c='Contract Approver';
            
            insert APPRec_CA;
            
            Plant_Code_Master__c pcm = new Plant_Code_Master__c();
            pcm.name='Test PCode';
            pcm.Plant_Name__c='Test PName';
            pcm.Public_Plant_Name__c='Test Public PName';
            pcm.City__c='Ohio';
            pcm.Country_Code__c='+1';
            pcm.CurrencyIsoCode='USD';
            
            insert pcm;
            
            Opportunity_Proposal__c op = new Opportunity_Proposal__c();
            op.Request_Type__c='UCA';
            op.Site__c=pcm.Id;
            op.Pricing_Analyst__c=usr.id;
            op.Pricing_Manager__c=usr.Id;
            op.Proposal_Status__c='Cost Update';
            insert op;            
            
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
            WFrec.Status__c='In Progress';
            WFrec.Approval_Level_Required__c='Aero Tier 0';
            WFrec.Approval_Level_in_Progress__c='Aero Tier 0';
            WFRec.Americas__c=True;
            WFRec.Requester_s_Comments__c='Test';
            WFRec.Opportunity_Proposal__c=op.Id;
            insert WFrec;
            
            
            WorkFlow_Approval_History__c wkhstryRec1=new WorkFlow_Approval_History__c();
            wkhstryRec1.Workflow_details__c=WFrec.id;
            wkhstryRec1.Tier__c=WFrec.Approval_Level_in_Progress__c;
            wkhstryRec1.Approval_Status__c='Pending Approval';
            wkhstryRec1.Email__c='soniya.ramachandran@nttdata.com';
            wkhstryRec1.Approver__c='TEST User';
            wkhstryRec1.Select_Approver__c=APPRec_CA.id;
            wkhstryRec1.Approver_Type__c='Contract Approver';
            wkhstryRec1.Delete_Check_Box__c=False;
            wkhstryRec1.Approval_submitted_date__c=system.today();            
            //wkhstryRec1.OPRO_Number_SFDC_ID__c=op.Id;
            //wkhstryRec1.OPRO_Number__c=op.Name;
            insert wkhstryRec1;
            wkhstryRec1= [select Email__c from Workflow_Approval_History__c where Id = :wkhstryRec1.id];
            WAHReminderBatchs objskup = new WAHReminderBatchs ();
            ID batchprocessid = Database.executeBatch(objskup );         
                              
            
            WAHReminderBatchs rem= new WAHReminderBatchs ();
            DataBase.executeBatch(rem); 
                      
            Test.StopTest();
        }
    }
}