@isTest(SeeAllData=true)
private class eGreen_sheet_Approval_TM1{ 

static testMethod void eGreen_sheet_Approval_Testcls1()
{
Platform__c PLFrec= new Platform__c();
PLFrec.name='PLF_Test_rec';
insert PLFrec;
id lstval;
list<string> lstofAP= new list<string>();
list<Approver__c> mpm_app1=new  list<Approver__c>();
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
WFRec.APAC__c=True;
WFRec.Global__c=True;
WFRec.EMEAI__c=True;
WFRec.Middle_East_APU_s_Only__c=True;
WFRec.Airbus__c =true;
//WFRec.BG_A__c=True;
insert WFrec;

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
WFrec1.Status__c='In progress';
WFrec1.Approval_Level_Required__c='Aero Tier 0';
WFrec1.Approval_Level_in_Progress__c='Aero Tier 0';
WFrec1.Americas__c=False;
WFrec1.APAC__c=False;
WFrec1.Global__c=False;
WFrec1.EMEAI__c=False;
WFrec1.Middle_East_APU_s_Only__c=False;
//WFRec.BG_A__c=True;
insert WFrec1;

Profile ProfRec = [select name from Profile where name = 'D&S Sales eGreensheet Approver (Non-US)'];

User userRec = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec;

Approver__c APPRec_MPM= new Approver__c();
APPRec_MPM.name='Test_App_rec';
APPRec_MPM.Approver_Name__c=userRec.id;
APPRec_MPM.Business_Unit__c='BGA';
APPRec_MPM.Region__c='Americas';
APPRec_MPM.Tier__c='Aero Tier 0';
APPRec_MPM.Approver_type__c='M&PM ';
APPRec_MPM.Out_of_Office__c = true;
APPRec_MPM.From__c =system.today();
APPRec_MPM.To__c =system.today();
APPRec_MPM.Active__c =true;
insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Out_of_Office__c = true;
//APPRec_BA.From__c =system.today();
//APPRec_BA.To__c =system.today();
APPRec_BA.Active__c =true;
insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;
//APPRec_CA.From__c =system.today();
//APPRec_CA.To__c =system.today();
APPRec_CA.Active__c =true;
insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Finance Approver';
APPRec_FA.Out_of_Office__c = true;
//APPRec_FA.From__c =system.today();
//APPRec_FA.To__c =system.today();
insert APPRec_FA;


Approver__c APPRec_Product= new Approver__c();
APPRec_Product.name='Test_App_rec';
APPRec_Product.Approver_Name__c=userRec.id;
APPRec_Product.Business_Unit__c='BGA';
APPRec_Product.Region__c='Americas';
APPRec_Product.Tier__c='Aero Tier 0';
APPRec_Product.Approver_type__c='Product Approver';
APPRec_Product.Out_of_Office__c = true;
//APPRec_FA.From__c =system.today();
//APPRec_FA.To__c =system.today();
insert APPRec_Product;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Notification';
APPRec_NT.Out_of_Office__c = true;
//APPRec_NT.From__c =system.today();
//APPRec_NT.To__c =system.today();
insert APPRec_NT;

mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_BA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_Product);
ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_CA.id;

wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

ApexPages.StandardController controller1= new ApexPages.StandardController(WFrec1);
System.currentPagereference().getParameters().put('id',WFrec1.id);
eGreen_sheet_Approval WFAPProval1=new eGreen_sheet_Approval(controller1);

WorkFlow_Approval_History__c wfhstryRec1= new WorkFlow_Approval_History__c();
wfhstryRec1.Workflow_details__c=WFrec.id;
wfhstryRec1.Select_Approver__c=APPRec_NT.id;

wfhstryRec1.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec1;

APPRec_NT.Delegation_Valid_From1__c= system.today() -2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;

APPRec_NT.Delegation_Valid_From2__c= system.today() -2;
APPRec_NT.Delegation_Valid_To2__c= system.today() +2;

APPRec_NT.Delegation_Valid_From3__c= system.today() -2;
APPRec_NT.Delegation_Valid_To3__c= system.today() +2;

APPRec_NT.Delegation_Valid_From4__c= system.today() -2;
APPRec_NT.Delegation_Valid_To4__c= system.today() +2;
update APPRec_NT;
/*ApexPages.StandardController controller2= new ApexPages.StandardController(WFrec1);
System.currentPagereference().getParameters().put('id',WFrec1.id);
eGreen_sheet_Approval WFAPProval2=new eGreen_sheet_Approval(controller2);

WorkFlow_Approval_History__c wfhstryRec2= new WorkFlow_Approval_History__c();
wfhstryRec2.Workflow_details__c=WFrec.id;
wfhstryRec2.Select_Approver__c=APPRec_FA.id;

wfhstryRec2.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec2;*/
WFAPProval.savendraft();

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=APPRec_BA.id;
string LstVal1c=APPRec_CA.id;
string LstVal1f=APPRec_FA.id;
string LstVal1n=APPRec_NT.id;
string LstVal2=APPRec_BA.id;
string LstVal2c=APPRec_CA.id;
string LstVal2f=APPRec_FA.id;
string LstVal2n=APPRec_NT.id;
string Lstval3=APPRec_BA.id;
string LstVal3c=APPRec_CA.id;
string LstVal3f=APPRec_FA.id;
string LstVal3n=APPRec_NT.id;
string LstVal3m=APPRec_MPM.id; 
string Lstval4=APPRec_BA.id;
string LstVal4c=APPRec_CA.id;
string LstVal4f=APPRec_FA.id;
string LstVal4n=APPRec_NT.id;
string LstVal1m=APPRec_MPM.id;
string LstVal2m=APPRec_MPM.id;
string LstVal4m=APPRec_MPM.id; 

Save_As_Draft__c saveAsDrft= new Save_As_Draft__c();

LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);
//WFAPProval.savendraft();
//WFAPProval.Cancel();

WFAPProval.sendMail();
//WFAPProval.savendraft();
WFAPProval.Cancel();
WFAPProval.getUserList1();

LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();

LstVal3c=WFAPProval.getoptions3c();
LstVal3c=APPRec_CA.id;
WFAPProval.setoptions3c(LstVal3c);

LstVal3f=WFAPProval.getoptions3f();
LstVal3f=APPRec_FA.id;
WFAPProval.setoptions3f(LstVal3f);

LstVal4n=WFAPProval.getoptions2n();
LstVal4n=APPRec_NT.id;
WFAPProval.setoptions2n(LstVal4n);

string t = WFAPProval.getoptions1p();
WFAPProval.setoptions1p('');

string t1 = WFAPProval.getoptions2p();
WFAPProval.setoptions2p('');

string t2 = WFAPProval.getoptions3p();
WFAPProval.setoptions3p('');

string t3 = WFAPProval.getoptions4p();
WFAPProval.setoptions4p('');

}

}