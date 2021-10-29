@isTest(seeAllData = true)
private class eGreen_sheet_Approval_TM{ 
static testMethod void eGreen_sheet_Approval_Testcls()
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
AccRec.Sales_Channel__c = 'Divest';
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
WFrec.Approval_Level_in_Progress__c='Tier 0';
WFRec.Americas__c=True;
WFRec.Sales_Channel__c = 'Americas AM';
user usr = [select id from user where id !=:UserInfo.getUserID() and isActive=true limit 1];
//WFRec.ownerid=usr.id;
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
//WFRec.BG_A__c=True;
insert WFrec;

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

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Sales_Channel__c = 'Divest';
APPRec_BA.Out_of_Office__c = true;
insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Notification';
APPRec_FA.Out_of_Office__c = true;
insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Finance Approver';
APPRec_NT.Out_of_Office__c = true;
APPRec_NT.From__c= system.today() -3;
APPRec_NT.To__c= system.today() +2;

insert APPRec_NT;



mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_BA);

ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);
WFAPProval.getUserList1p();
WFAPProval.getUserList2p();

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_NT.id;
wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);

WFAPProval.getUserList1();
string LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

string LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

string LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

string LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


String LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

String LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();
WFAPProval.Cancel();
WFAPProval.savendraft();



String ss = WFAPProval.getoptions3n();
WFAPProval.setoptions2n(APPRec_NT.id);
String ab = WFAPProval.getoptions3f();
String abc = WFAPProval.getoptions3c();


APPRec_NT.Delegation_Valid_From1__c= system.today() -2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;
update APPRec_NT;
//WFAPProval.sendMail();


/*String LstVal2n=WFAPProval.getoptions2n();
LstVal2n=APPRec_NT.id;
WFAPProval.setoptions2n(LstVal2n);
WFAPProval.getUserList2n();

WFAPProval.getUserList3();
string Lstval3=WFAPProval.getoptions3();
Lstval3=APPRec_BA.id;
WFAPProval.setoptions3(Lstval3);

String LstVal3c=WFAPProval.getoptions3c();
LstVal3c=APPRec_CA.id;
WFAPProval.setoptions3c(LstVal3c);
WFAPProval.getUserList3c();

String LstVal3f=WFAPProval.getoptions3f();
LstVal3f=APPRec_FA.id;
WFAPProval.setoptions3f(LstVal3f);
WFAPProval.getUserList3f();

WFAPProval.getoptions1p();
WFAPProval.setoptions1p('test');
WFAPProval.getoptions2p();
WFAPProval.setoptions2p('test1');
WFAPProval.getoptions3p();
WFAPProval.setoptions3p('test2');
WFAPProval.getoptions4p();
WFAPProval.setoptions4p('test3');


String LstVal3n=WFAPProval.getoptions3n();
LstVal3n=APPRec_NT.id;
WFAPProval.setoptions3n(LstVal3n);
WFAPProval.getUserList3n();

WFAPProval.getUserList4();
string Lstval4=WFAPProval.getoptions4();
Lstval4=APPRec_BA.id;
WFAPProval.setoptions4(Lstval4);

String LstVal4c=WFAPProval.getoptions4c();
LstVal4c=APPRec_CA.id;
WFAPProval.setoptions4c(LstVal4c);
WFAPProval.getUserList4c();

String LstVal4f=WFAPProval.getoptions4f();
LstVal4f=APPRec_FA.id;
WFAPProval.setoptions4f(LstVal4f);
WFAPProval.getUserList4f();

String LstVal4n=WFAPProval.getoptions4n();
LstVal4n=APPRec_NT.id;
WFAPProval.setoptions4n(LstVal4n);
WFAPProval.getUserList4n();

String LstVal1m=WFAPProval.getoptions1m();
LstVal1m=APPRec_MPM.id;
WFAPProval.setoptions1m(LstVal1m);
WFAPProval.getUserList1m();

String LstVal2m=WFAPProval.getoptions2m();
LstVal2m=APPRec_MPM.id;
WFAPProval.setoptions2m(LstVal2m);
WFAPProval.getUserList2m();

String LstVal3m=WFAPProval.getoptions3m();
LstVal3m=APPRec_MPM.id;
WFAPProval.setoptions3m(LstVal3m);
WFAPProval.getUserList3m();

String LstVal4m=WFAPProval.getoptions4m();
LstVal4m=APPRec_MPM.id;
WFAPProval.setoptions4m(LstVal4m);
WFAPProval.getUserList4m();*/
//WFAPProval.Cancel();
//lstofAP.add(APPRec_NT.id);

//WFAPProval.sendMail();


//WFAPProval.savendraft();

//LstVal1=WFAPProval.getoptions1();
//LstVal1=APPRec_BA.id;
//WFAPProval.setoptions1(LstVal1);

//WFAPProval.getUserList1();
//LstVal1c=WFAPProval.getoptions1c();
//LstVal1c=APPRec_CA.id;
//WFAPProval.setoptions1c(LstVal1c);

//WFAPProval.getUserList1c();

//LstVal1f=WFAPProval.getoptions1f();
//LstVal1f=APPRec_FA.id;
//WFAPProval.setoptions1f(LstVal1f);

//WFAPProval.getUserList1f();

//LstVal1n=WFAPProval.getoptions1n();
//LstVal1n=APPRec_NT.id;
//WFAPProval.setoptions1n(LstVal1n);

//WFAPProval.getUserList1n();

//LstVal2=WFAPProval.getoptions2();
//LstVal2=APPRec_BA.id;
//WFAPProval.setoptions2(LstVal2);
//WFAPProval.getUserList2();


//LstVal2c=WFAPProval.getoptions2c();
//LstVal2c=APPRec_CA.id;
//WFAPProval.setoptions2c(LstVal2c);
//WFAPProval.getUserList2c();

//LstVal2f=WFAPProval.getoptions2f();
//LstVal2f=APPRec_FA.id;
//WFAPProval.setoptions2f(LstVal2f);
//WFAPProval.getUserList2f();

//LstVal2n=WFAPProval.getoptions2n();
//LstVal2n=APPRec_NT.id;
//WFAPProval.setoptions2n(LstVal2n);
//WFAPProval.getUserList2n();

//WFAPProval.getUserList3();
//Lstval3=WFAPProval.getoptions3();
//Lstval3=APPRec_BA.id;
//WFAPProval.setoptions3(Lstval3);

//LstVal3c=WFAPProval.getoptions3c();
//LstVal3c=APPRec_CA.id;
//WFAPProval.setoptions3c(LstVal3c);
//WFAPProval.getUserList3c();

//LstVal3f=WFAPProval.getoptions3f();
//LstVal3f=APPRec_FA.id;
//WFAPProval.setoptions3f(LstVal3f);
//WFAPProval.getUserList3f();

//LstVal3n=WFAPProval.getoptions3n();
//LstVal3n=APPRec_NT.id;
//WFAPProval.setoptions3n(LstVal3n);
//WFAPProval.getUserList3n();

//WFAPProval.getUserList4();
//Lstval4=WFAPProval.getoptions4();
//Lstval4=APPRec_BA.id;
//WFAPProval.setoptions4(Lstval4);

//LstVal4c=WFAPProval.getoptions4c();
//LstVal4c=APPRec_CA.id;
//WFAPProval.setoptions4c(LstVal4c);
//WFAPProval.getUserList4c();

//LstVal4f=WFAPProval.getoptions4f();
//LstVal4f=APPRec_FA.id;
//WFAPProval.setoptions4f(LstVal4f);
//WFAPProval.getUserList4f();

//LstVal4n=WFAPProval.getoptions4n();
//LstVal4n=APPRec_NT.id;
//WFAPProval.setoptions4n(LstVal4n);
//WFAPProval.getUserList4n();

//LstVal1m=WFAPProval.getoptions1m();
//LstVal1m=APPRec_MPM.id;
//WFAPProval.setoptions1m(LstVal1m);
//WFAPProval.getUserList1m();

////LstVal2m=WFAPProval.getoptions2m();
//LstVal2m=APPRec_MPM.id;
//WFAPProval.setoptions2m(LstVal2m);
//WFAPProval.getUserList2m();

//LstVal3m=WFAPProval.getoptions3m();
//LstVal3m=APPRec_MPM.id;
//WFAPProval.setoptions3m(LstVal3m);
//WFAPProval.getUserList3m();

//LstVal4m=WFAPProval.getoptions4m();
//LstVal4m=APPRec_MPM.id;
//WFAPProval.setoptions4m(LstVal4m);
//WFAPProval.savendraft();
}
static testMethod void eGreen_sheet_Approval_Testcls11()
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
user usr = [select id from user where id !=:UserInfo.getUserID() and isActive=true limit 1];
//WFRec.ownerid=usr.id;
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
//WFRec.BG_A__c=True;
insert WFrec;

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

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Out_of_Office__c = true;

insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Notification';
APPRec_FA.Out_of_Office__c = true;
insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Finance Approver';
APPRec_NT.Out_of_Office__c = true;
APPRec_NT.From__c= system.today() -3;
APPRec_NT.To__c= system.today() +2;

insert APPRec_NT;



mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_BA);

ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_NT.id;
wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);

WFAPProval.getUserList1();
string LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

string LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

string LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

string LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


String LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

String LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();
WFAPProval.Cancel();
WFAPProval.savendraft();



String ss = WFAPProval.getoptions3n();
WFAPProval.setoptions2n(APPRec_NT.id);
String ab = WFAPProval.getoptions3f();
String abc = WFAPProval.getoptions3c();


APPRec_NT.Delegation_Valid_From1__c= system.today() -2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;
update APPRec_NT;
//WFAPProval.sendMail();


/*String LstVal2n=WFAPProval.getoptions2n();
LstVal2n=APPRec_NT.id;
WFAPProval.setoptions2n(LstVal2n);
WFAPProval.getUserList2n();

WFAPProval.getUserList3();
string Lstval3=WFAPProval.getoptions3();
Lstval3=APPRec_BA.id;
WFAPProval.setoptions3(Lstval3);

String LstVal3c=WFAPProval.getoptions3c();
LstVal3c=APPRec_CA.id;
WFAPProval.setoptions3c(LstVal3c);
WFAPProval.getUserList3c();

String LstVal3f=WFAPProval.getoptions3f();
LstVal3f=APPRec_FA.id;
WFAPProval.setoptions3f(LstVal3f);
WFAPProval.getUserList3f();

WFAPProval.getoptions1p();
WFAPProval.setoptions1p('test');
WFAPProval.getoptions2p();
WFAPProval.setoptions2p('test1');
WFAPProval.getoptions3p();
WFAPProval.setoptions3p('test2');
WFAPProval.getoptions4p();
WFAPProval.setoptions4p('test3');


String LstVal3n=WFAPProval.getoptions3n();
LstVal3n=APPRec_NT.id;
WFAPProval.setoptions3n(LstVal3n);
WFAPProval.getUserList3n();

WFAPProval.getUserList4();
string Lstval4=WFAPProval.getoptions4();
Lstval4=APPRec_BA.id;
WFAPProval.setoptions4(Lstval4);

String LstVal4c=WFAPProval.getoptions4c();
LstVal4c=APPRec_CA.id;
WFAPProval.setoptions4c(LstVal4c);
WFAPProval.getUserList4c();

String LstVal4f=WFAPProval.getoptions4f();
LstVal4f=APPRec_FA.id;
WFAPProval.setoptions4f(LstVal4f);
WFAPProval.getUserList4f();

String LstVal4n=WFAPProval.getoptions4n();
LstVal4n=APPRec_NT.id;
WFAPProval.setoptions4n(LstVal4n);
WFAPProval.getUserList4n();

String LstVal1m=WFAPProval.getoptions1m();
LstVal1m=APPRec_MPM.id;
WFAPProval.setoptions1m(LstVal1m);
WFAPProval.getUserList1m();

String LstVal2m=WFAPProval.getoptions2m();
LstVal2m=APPRec_MPM.id;
WFAPProval.setoptions2m(LstVal2m);
WFAPProval.getUserList2m();

String LstVal3m=WFAPProval.getoptions3m();
LstVal3m=APPRec_MPM.id;
WFAPProval.setoptions3m(LstVal3m);
WFAPProval.getUserList3m();

String LstVal4m=WFAPProval.getoptions4m();
LstVal4m=APPRec_MPM.id;
WFAPProval.setoptions4m(LstVal4m);
WFAPProval.getUserList4m();*/
//WFAPProval.Cancel();
//lstofAP.add(APPRec_NT.id);

//WFAPProval.sendMail();


//WFAPProval.savendraft();

//LstVal1=WFAPProval.getoptions1();
//LstVal1=APPRec_BA.id;
//WFAPProval.setoptions1(LstVal1);

//WFAPProval.getUserList1();
//LstVal1c=WFAPProval.getoptions1c();
//LstVal1c=APPRec_CA.id;
//WFAPProval.setoptions1c(LstVal1c);

//WFAPProval.getUserList1c();

//LstVal1f=WFAPProval.getoptions1f();
//LstVal1f=APPRec_FA.id;
//WFAPProval.setoptions1f(LstVal1f);

//WFAPProval.getUserList1f();

//LstVal1n=WFAPProval.getoptions1n();
//LstVal1n=APPRec_NT.id;
//WFAPProval.setoptions1n(LstVal1n);

//WFAPProval.getUserList1n();

//LstVal2=WFAPProval.getoptions2();
//LstVal2=APPRec_BA.id;
//WFAPProval.setoptions2(LstVal2);
//WFAPProval.getUserList2();


//LstVal2c=WFAPProval.getoptions2c();
//LstVal2c=APPRec_CA.id;
//WFAPProval.setoptions2c(LstVal2c);
//WFAPProval.getUserList2c();

//LstVal2f=WFAPProval.getoptions2f();
//LstVal2f=APPRec_FA.id;
//WFAPProval.setoptions2f(LstVal2f);
//WFAPProval.getUserList2f();

//LstVal2n=WFAPProval.getoptions2n();
//LstVal2n=APPRec_NT.id;
//WFAPProval.setoptions2n(LstVal2n);
//WFAPProval.getUserList2n();

//WFAPProval.getUserList3();
//Lstval3=WFAPProval.getoptions3();
//Lstval3=APPRec_BA.id;
//WFAPProval.setoptions3(Lstval3);

//LstVal3c=WFAPProval.getoptions3c();
//LstVal3c=APPRec_CA.id;
//WFAPProval.setoptions3c(LstVal3c);
//WFAPProval.getUserList3c();

//LstVal3f=WFAPProval.getoptions3f();
//LstVal3f=APPRec_FA.id;
//WFAPProval.setoptions3f(LstVal3f);
//WFAPProval.getUserList3f();

//LstVal3n=WFAPProval.getoptions3n();
//LstVal3n=APPRec_NT.id;
//WFAPProval.setoptions3n(LstVal3n);
//WFAPProval.getUserList3n();

//WFAPProval.getUserList4();
//Lstval4=WFAPProval.getoptions4();
//Lstval4=APPRec_BA.id;
//WFAPProval.setoptions4(Lstval4);

//LstVal4c=WFAPProval.getoptions4c();
//LstVal4c=APPRec_CA.id;
//WFAPProval.setoptions4c(LstVal4c);
//WFAPProval.getUserList4c();

//LstVal4f=WFAPProval.getoptions4f();
//LstVal4f=APPRec_FA.id;
//WFAPProval.setoptions4f(LstVal4f);
//WFAPProval.getUserList4f();

//LstVal4n=WFAPProval.getoptions4n();
//LstVal4n=APPRec_NT.id;
//WFAPProval.setoptions4n(LstVal4n);
//WFAPProval.getUserList4n();

//LstVal1m=WFAPProval.getoptions1m();
//LstVal1m=APPRec_MPM.id;
//WFAPProval.setoptions1m(LstVal1m);
//WFAPProval.getUserList1m();

////LstVal2m=WFAPProval.getoptions2m();
//LstVal2m=APPRec_MPM.id;
//WFAPProval.setoptions2m(LstVal2m);
//WFAPProval.getUserList2m();

//LstVal3m=WFAPProval.getoptions3m();
//LstVal3m=APPRec_MPM.id;
//WFAPProval.setoptions3m(LstVal3m);
//WFAPProval.getUserList3m();

//LstVal4m=WFAPProval.getoptions4m();
//LstVal4m=APPRec_MPM.id;
//WFAPProval.setoptions4m(LstVal4m);
//WFAPProval.savendraft();
}
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
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
//WFRec.BG_A__c=True;
insert WFrec;

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

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Out_of_Office__c = true;

insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Notification';
APPRec_FA.Out_of_Office__c = true;
insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Finance Approver';
APPRec_NT.Out_of_Office__c = true;


insert APPRec_NT;



mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_BA);

ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_NT.id;
wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);

WFAPProval.getUserList1();
string LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

string LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

string LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

string LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


String LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

String LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();
WFAPProval.Cancel();
WFAPProval.savendraft();



String ss = WFAPProval.getoptions3n();
//WFAPProval.setoptions2n(APPRec_NT.id);
String ab = WFAPProval.getoptions3f();
String abc = WFAPProval.getoptions3c();

APPRec_NT.Delegation_Valid_From1__c= system.today() +2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;



APPRec_NT.Delegation_Valid_From2__c= system.today() -2;
APPRec_NT.Delegation_Valid_To2__c= system.today() +2;
update APPRec_NT;


//WFAPProval.sendMail();


}

static testMethod void eGreen_sheet_Approval_Testcls2()
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
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
//WFRec.BG_A__c=True;
insert WFrec;

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

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Out_of_Office__c = true;

insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Notification';
APPRec_FA.Out_of_Office__c = true;
insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Finance Approver';
APPRec_NT.Out_of_Office__c = true;


insert APPRec_NT;



mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_BA);

ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_NT.id;
wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);

WFAPProval.getUserList1();
string LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

string LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

string LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

string LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


String LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

String LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();
WFAPProval.Cancel();
WFAPProval.savendraft();



String ss = WFAPProval.getoptions3n();
//WFAPProval.setoptions2n(APPRec_NT.id);
String ab = WFAPProval.getoptions3f();
String abc = WFAPProval.getoptions3c();


APPRec_NT.Delegation_Valid_From1__c= system.today() +2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;

APPRec_NT.Delegation_Valid_From2__c= system.today() +2;
APPRec_NT.Delegation_Valid_To2__c= system.today() +2;


APPRec_NT.Delegation_Valid_From3__c= system.today() -2;
APPRec_NT.Delegation_Valid_To3__c= system.today() +2;
update APPRec_NT;


//WFAPProval.sendMail();


}

static testMethod void eGreen_sheet_Approval_Testcls3()
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
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
//WFRec.BG_A__c=True;
insert WFrec;

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

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Out_of_Office__c = true;

insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Notification';
APPRec_FA.Out_of_Office__c = true;
insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Finance Approver';
APPRec_NT.Out_of_Office__c = true;


insert APPRec_NT;



mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_BA);

ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_NT.id;
wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);

WFAPProval.getUserList1();
string LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

string LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

string LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

string LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


String LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

String LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();
WFAPProval.Cancel();
WFAPProval.savendraft();



String ss = WFAPProval.getoptions3n();
//WFAPProval.setoptions2n(APPRec_NT.id);
String ab = WFAPProval.getoptions3f();
String abc = WFAPProval.getoptions3c();


APPRec_NT.Delegation_Valid_From1__c= system.today() +2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;

APPRec_NT.Delegation_Valid_From2__c= system.today() +2;
APPRec_NT.Delegation_Valid_To2__c= system.today() +2;

APPRec_NT.Delegation_Valid_From3__c= system.today() +2;
APPRec_NT.Delegation_Valid_To3__c= system.today() +2;

APPRec_NT.Delegation_Valid_From4__c= system.today() -2;
APPRec_NT.Delegation_Valid_To4__c= system.today() +2;
update APPRec_NT;


//WFAPProval.sendMail();


}
static testMethod void eGreen_sheet_Approval_Testcls4()
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
//WFRec.APAC__c=True;
//WFRec.Global__c=True;
//WFRec.EMEAI__c=True;
//WFRec.Middle_East_APU_s_Only__c=True;
//WFRec.BG_A__c=True;
insert WFrec;

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

insert APPRec_MPM;

Approver__c APPRec_BA= new Approver__c();
APPRec_BA.name='Test_App_rec';
APPRec_BA.Approver_Name__c=userRec.id;
APPRec_BA.Business_Unit__c='BGA';
APPRec_BA.Region__c='Americas';
APPRec_BA.Tier__c='Aero Tier 0';
APPRec_BA.Approver_type__c='Business Approver';
APPRec_BA.Out_of_Office__c = true;

insert APPRec_BA;

Approver__c APPRec_CA= new Approver__c();
APPRec_CA.name='Test_App_rec';
APPRec_CA.Approver_Name__c=userRec.id;
APPRec_CA.Business_Unit__c='BGA';
APPRec_CA.Region__c='Americas';
APPRec_CA.Tier__c='Aero Tier 0';
APPRec_CA.Approver_type__c='Contract Approver';
APPRec_CA.Out_of_Office__c = true;

insert APPRec_CA;

Approver__c APPRec_FA= new Approver__c();
APPRec_FA.name='Test_App_rec';
APPRec_FA.Approver_Name__c=userRec.id;
APPRec_FA.Business_Unit__c='BGA';
APPRec_FA.Region__c='Americas';
APPRec_FA.Tier__c='Aero Tier 0';
APPRec_FA.Approver_type__c='Notification';
APPRec_FA.Out_of_Office__c = true;
insert APPRec_FA;

Approver__c APPRec_NT= new Approver__c();
APPRec_NT.name='Test_App_rec';
APPRec_NT.Approver_Name__c=userRec.id;
APPRec_NT.Business_Unit__c='BGA';
APPRec_NT.Region__c='Americas';
APPRec_NT.Tier__c='Aero Tier 0';
APPRec_NT.Approver_type__c='Finance Approver';
APPRec_NT.Out_of_Office__c = true;


insert APPRec_NT;



mpm_app1.add(APPRec_MPM);
mpm_app1.add(APPRec_NT);
mpm_app1.add(APPRec_FA);
mpm_app1.add(APPRec_CA);
mpm_app1.add(APPRec_BA);

ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);
System.currentPagereference().getParameters().put('id',WFrec.id);
eGreen_sheet_Approval WFAPProval=new eGreen_sheet_Approval(controller);

WorkFlow_Approval_History__c wfhstryRec= new WorkFlow_Approval_History__c();
wfhstryRec.Workflow_details__c=WFrec.id;
wfhstryRec.Select_Approver__c=APPRec_NT.id;
wfhstryRec.Tier__c=WFrec.approval_level_in_progress__c;
insert wfhstryRec;

//WorkFlow_Approval_History__c ObjComm1=WFAPProval.getObjComm1();
//WFAPProval.setObjComm1();
//WFAPProval.getObjComm1();
//WFAPProval.getSuglist();
string LstVal1=WFAPProval.getoptions1();
LstVal1=APPRec_BA.id;
WFAPProval.setoptions1(LstVal1);

WFAPProval.getUserList1();
string LstVal1c=WFAPProval.getoptions1c();
LstVal1c=APPRec_CA.id;
WFAPProval.setoptions1c(LstVal1c);

WFAPProval.getUserList1c();

string LstVal1f=WFAPProval.getoptions1f();
LstVal1f=APPRec_FA.id;
WFAPProval.setoptions1f(LstVal1f);

WFAPProval.getUserList1f();

string LstVal1n=WFAPProval.getoptions1n();
LstVal1n=APPRec_NT.id;
WFAPProval.setoptions1n(LstVal1n);

WFAPProval.getUserList1n();

string LstVal2=WFAPProval.getoptions2();
LstVal2=APPRec_BA.id;
WFAPProval.setoptions2(LstVal2);
WFAPProval.getUserList2();


String LstVal2c=WFAPProval.getoptions2c();
LstVal2c=APPRec_CA.id;
WFAPProval.setoptions2c(LstVal2c);
WFAPProval.getUserList2c();

String LstVal2f=WFAPProval.getoptions2f();
LstVal2f=APPRec_FA.id;
WFAPProval.setoptions2f(LstVal2f);
WFAPProval.getUserList2f();
WFAPProval.Cancel();
WFAPProval.savendraft();



String ss = WFAPProval.getoptions3n();
//WFAPProval.setoptions2n(APPRec_NT.id);
String ab = WFAPProval.getoptions3f();
String abc = WFAPProval.getoptions3c();

APPRec_NT.From__c= system.today() +2;
APPRec_NT.To__c= system.today() +2;

APPRec_NT.Delegation_Valid_From1__c= system.today() -2;
APPRec_NT.Delegation_Valid_To1__c= system.today() +2;

APPRec_NT.Delegation_Valid_From2__c= system.today() +2;
APPRec_NT.Delegation_Valid_To2__c= system.today() +2;

APPRec_NT.Delegation_Valid_From3__c= system.today() +2;
APPRec_NT.Delegation_Valid_To3__c= system.today() +2;

APPRec_NT.Delegation_Valid_From4__c= system.today() +2;
APPRec_NT.Delegation_Valid_To4__c= system.today() +2;
update APPRec_NT;


WFAPProval.sendMail();


}
}