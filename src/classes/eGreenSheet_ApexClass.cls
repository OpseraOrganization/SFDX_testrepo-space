/** * File Name: eGreenSheet_ApexClass
* Description Test Method for e-green sheet
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class eGreenSheet_ApexClass {

static testmethod void testeGreenSheet(){
List<WorkFlow_Approval_History__c> wfHistoryList = new List<WorkFlow_Approval_History__c>();
List<Workflow_details__c> wfList = new List<Workflow_details__c>();

Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserEgreen',Username = 'tu1egreen@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,
CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;

// Creating workflow and history object
Approver__c sam= new Approver__c(name='test',approver_name__c=usr.id,Business_Unit__c='ATR', email__c ='tu1egreen@test.com');
insert sam;
Workflow_details__c wf= new Workflow_details__c(ATR__c=true,Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf;
/*
Workflow_details__c wf1= new Workflow_details__c(Airlines__c=true,Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf1;
Workflow_details__c wf2= new Workflow_details__c(BG_A__c=true,
Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf2;

Workflow_details__c wf3= new Workflow_details__c(Boeing__c=true,
Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf3;
Workflow_details__c wf4= new Workflow_details__c(RACC__c=true,
Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf4;
*/
//insert wfList;

//WorkFlow_Approval_History__c wfHistory= new WorkFlow_Approval_History__c(Workflow_details__c=wf.Id,
//Approval_Status__c='Approved');
//wfHistoryList.add(wfHistory);
WorkFlow_Approval_History__c wfHistory1= new WorkFlow_Approval_History__c(Workflow_details__c=wf.Id,
Approval_Status__c='Approved', select_approver__c = sam.id, email__c = sam.email__c);
wfHistoryList.add(wfHistory1);

insert wfHistoryList;
update wfHistory1;
wfHistory1.Approval_Status__c='Rejected';
update wfHistory1;
wfHistory1.Approval_Status__c='Pending Approval';
update wfHistory1;

Approver__c app= new Approver__c(Approver_Name__c=usr.Id);
insert app;
Test.starttest();
delete wf;
Workflow_details__c wf5= new Workflow_details__c(Defence_Space__c=true,
Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf5;
Workflow_details__c wf6= new Workflow_details__c(HIS__c=true,
Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf6;
Workflow_details__c wf7= new Workflow_details__c(HTSI__c=true,
Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf7;

Test.stopTest();
} 

}