@isTest
private class eGreen_sheet_Approval_EditTest1{ 

static testMethod void eGreen_sheet_Approval_Edit_Testcls1()
{
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
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
WFRec.BG_A__c=True;
//WFRec.Airlines__c=True;
//WFRec.ATR__c=True;
//WFRec.BG_A_OE__c=True;
//WFRec.Boeing__c=True;
//WFRec.Defence_Space__c=True;
//WFRec.Defence_Space_OE__c=True;
//WFRec.HIS__c=True;
//WFRec.HTSI__c=True;
//WFRec.HTSI_OE__c=True;
//WFRec.Airbus__c=True;
WFRec.Requester_s_Comments__c='Test';
insert WFrec;

Profile ProfRec = [select name from Profile where name = 'D&S Sales'];

User userRec = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec;

Approver__c APPRec_MPM= new Approver__c();
APPRec_MPM.name='Test_App_rec';
APPRec_MPM.Approver_Name__c=userRec.id;
APPRec_MPM.Business_Unit__c='BGA';
APPRec_MPM.Region__c='Americas';
APPRec_MPM.Tier__c='Aero Tier 0';
APPRec_MPM.Approver_type__c='M&PM ';

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';

insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Finance Approver';

insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Notification';

insert APPRec_NT;

Save_As_Draft__c savDr= new Save_As_Draft__c();

savDr.Business_Approver1__c='Test_App_rec';
savDr.Business_Approver2__c='Test_App_rec';
savDr.Business_Approver3__c='Test_App_rec';
savDr.Business_Approver4__c='Test_App_rec';
savDr.Contract_Approvers1__c='Test_App_rec';
savDr.Contract_Approvers2__c='Test_App_rec';
savDr.Contract_Approvers3__c='Test_App_rec';
savDr.Contract_Approvers4__c='Test_App_rec';
savDr.Finance_Approver1__c='Test_App_rec';
savDr.Finance_Approver2__c='Test_App_rec';
savDr.Finance_Approver3__c='Test_App_rec';
savDr.Finance_Approver4__c='Test_App_rec';
savDr.M_PM_Approver1__c='Test_App_rec';
savDr.M_PM_Approver2__c='Test_App_rec';
savDr.M_PM_Approver3__c='Test_App_rec';
savDr.M_PM_Approver4__c='Test_App_rec';
savDr.Notification1__c='Test_App_rec';
savDr.Notification2__c='Test_App_rec';
savDr.Notification3__c='Test_App_rec';
savDr.Notification4__c='Test_App_rec';
savDr.Workflow_details__c=WFrec.id;

insert savDr;
ApexPages.StandardController controller= new ApexPages.StandardController(savDr);
System.currentPagereference().getParameters().put('id',savDr.id);
eGreen_sheet_Approval_Edit wrkDetails=new eGreen_sheet_Approval_Edit(controller);

WorkFlow_Approval_History__c wkhstryRec=new WorkFlow_Approval_History__c();
wkhstryRec.Workflow_details__c=WFrec.id;
wkhstryRec.Select_Approver__c=APPRec_CA.id;
wkhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wkhstryRec;

string LstVal1=wrkDetails.getoptions1();
LstVal1=APPRec_BA.id;
wrkDetails.setoptions1(LstVal1);

/*wrkDetails.getUserList1();
string LstVal1c=wrkDetails.getoptions1c();
LstVal1c=APPRec_CA.id;
wrkDetails.setoptions1c(LstVal1c);

wrkDetails.getUserList1c();

string LstVal1f=wrkDetails.getoptions1f();
LstVal1f=APPRec_FA.id;
wrkDetails.setoptions1f(LstVal1f);

wrkDetails.getUserList1f();

string LstVal1n=wrkDetails.getoptions1n();
LstVal1n=APPRec_NT.id;
wrkDetails.setoptions1n(LstVal1n);

wrkDetails.getUserList1n();

string LstVal2=wrkDetails.getoptions2();
LstVal2=APPRec_BA.id;
wrkDetails.setoptions2(LstVal2);
wrkDetails.getUserList2();


String LstVal2c=wrkDetails.getoptions2c();
LstVal2c=APPRec_CA.id;
wrkDetails.setoptions2c(LstVal2c);
wrkDetails.getUserList2c();

String LstVal2f=wrkDetails.getoptions2f();
LstVal2f=APPRec_FA.id;
wrkDetails.setoptions2f(LstVal2f);
wrkDetails.getUserList2f();

String LstVal2n=wrkDetails.getoptions2n();
LstVal2n=APPRec_NT.id;
wrkDetails.setoptions2n(LstVal2n);
wrkDetails.getUserList2n();

wrkDetails.getUserList3();
string Lstval3=wrkDetails.getoptions3();
Lstval3=APPRec_BA.id;
wrkDetails.setoptions3(Lstval3);

String LstVal3c=wrkDetails.getoptions3c();
LstVal3c=APPRec_CA.id;
wrkDetails.setoptions3c(LstVal3c);
wrkDetails.getUserList3c();

String LstVal3f=wrkDetails.getoptions3f();
LstVal3f=APPRec_FA.id;
wrkDetails.setoptions3f(LstVal3f);
wrkDetails.getUserList3f();

String LstVal3n=wrkDetails.getoptions3n();
LstVal3n=APPRec_NT.id;
wrkDetails.setoptions3n(LstVal3n);
wrkDetails.getUserList3n();

wrkDetails.getUserList4();
string Lstval4=wrkDetails.getoptions4();
Lstval4=APPRec_BA.id;
wrkDetails.setoptions4(Lstval4);

String LstVal4c=wrkDetails.getoptions4c();
LstVal4c=APPRec_CA.id;
wrkDetails.setoptions4c(LstVal4c);
wrkDetails.getUserList4c();

String LstVal4f=wrkDetails.getoptions4f();
LstVal4f=APPRec_FA.id;
wrkDetails.setoptions4f(LstVal4f);
wrkDetails.getUserList4f();

String LstVal4n=wrkDetails.getoptions4n();
LstVal4n=APPRec_NT.id;
wrkDetails.setoptions4n(LstVal4n);
wrkDetails.getUserList4n();

String LstVal1m=wrkDetails.getoptions1m();
LstVal1m=APPRec_MPM.id;
wrkDetails.setoptions1m(LstVal1m);
wrkDetails.getUserList1m();*/

String LstVal2m=wrkDetails.getoptions2m();
LstVal2m=APPRec_MPM.id;
wrkDetails.setoptions2m(LstVal2m);
wrkDetails.getUserList2m();

String LstVal3m=wrkDetails.getoptions3m();
LstVal3m=APPRec_MPM.id;
wrkDetails.setoptions3m(LstVal3m);
wrkDetails.getUserList3m();

String LstVal4m=wrkDetails.getoptions4m();
LstVal4m=APPRec_MPM.id;
wrkDetails.setoptions4m(LstVal4m);
wrkDetails.getUserList4m();
wrkDetails.Cancel();
wrkDetails.getWFRec();
//wrkDetails.getObjComm1();
//wrkDetails.sendMail();

//wrkDetails.savendraft();
}

}