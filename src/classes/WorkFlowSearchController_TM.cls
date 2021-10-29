@isTest
private class WorkFlowSearchController_TM{ 

static testMethod void WorkFlowSearchController_Testcls()
{

Date d1 =Date.newInstance(2009,08,12);
Date date1 =Date.newInstance(2009,08,12);
Date date2 =Date.newInstance(2010,08,12);
system.debug('BBBBBBBBBBBB'+date1);
system.debug('11BBBBBBBBBBBB'+date2);
date d= system.today();
date d2= system.today();
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

//RecordType r1 = [select id ,name from RecordType where name='Competitive'];
  ID r1 = label.D_S_Complex;
//Opportunity Opprec= new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=AccRec.Id,StageName='Prospecting',CloseDate=d1,Tech_Sales_Product_Area__c='Integrated Avionics' );
Opportunity Opprec= new Opportunity(Name='Complexopp',recordtypeid =r1,Accountid=AccRec.Id,StageName='Prospecting',CloseDate=d1,Tech_Sales_Product_Area__c='Integrated Avionics',ATR_Aircraft_Quantity__c = 1);
insert Opprec;


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
/*WFrec.BG_A__c=True;
WFrec.BG_A_OE__c=True;
WFrec.Airbus__c=True;
WFrec.Airlines__c=True;
WFrec.Americas__c=True;
WFrec.APAC__c=True;
WFrec.ATR__c=True;
WFrec.Boeing__c=True;
WFrec.RACC__c=True;
WFrec.Defence_Space__c=True;
WFrec.Defence_Space_OE__c=True;
WFrec.EMEAI__c=True;
WFrec.Global__c=True;
WFrec.HIS__c=True;
WFrec.HTSI__c=True;
WFrec.HTSI_OE__c=True;
WFrec.Middle_East_APU_s_Only__c=True;
WFrec.Standard__c=True;*/
WFrec.Opportunity_Description__c=Opprec.id;

insert WFrec;


ApexPages.StandardController controller= new ApexPages.StandardController(WFrec);

WorkFlowSearchController WFSearch=new WorkFlowSearchController(controller);
//string name=WFrec.name;

System.currentPagereference().getParameters().put('name', 'Test');

WFSearch.getStatusoptions();
WFSearch.getnavigation3();
//WFSearch.toggleSort();
String cnam = 'Acc_Text_rec';
//String Statusdtl='Draft';

//system.debug('JJJJJJJJJJJJJJJ'+Statusval);
//System.currentPagereference().getParameters().put('cusname', WFrec.Customer_Name__c);
//System.currentPagereference().getParameters().put('atlas', WFrec.Atlas_or_P_DR__c);
//System.currentPagereference().getParameters().put('opportunity', WFrec.Opportunity_Description__c);
//System.currentPagereference().getParameters().put('platform', WFrec.Platform__c);
//System.currentPagereference().getParameters().put('Statusdtl', WFrec.Status__c);
System.currentPagereference().getParameters().put('cusname', 'Test');
System.currentPagereference().getParameters().put('Statusdtl', 'Draft');
System.currentPagereference().getParameters().put('exposed', '1');
System.currentPagereference().getParameters().put('atlas', 'Test');
System.currentPagereference().getParameters().put('opportunity', 'Test');
System.currentPagereference().getParameters().put('platform', 'Test');
System.currentPagereference().getParameters().put('salesmin', '30');
System.currentPagereference().getParameters().put('salesmax', '40');
System.currentPagereference().getParameters().put('arlne', 'True');
System.currentPagereference().getParameters().put('BGA', 'True');
System.currentPagereference().getParameters().put('RAC', 'True');
System.currentPagereference().getParameters().put('Defspce', 'True');
System.currentPagereference().getParameters().put('HIS', 'True');
System.currentPagereference().getParameters().put('ATR', 'True');
System.currentPagereference().getParameters().put('DefspceOE', 'True');
System.currentPagereference().getParameters().put('BGAOE', 'True');
System.currentPagereference().getParameters().put('HTSI', 'True');
System.currentPagereference().getParameters().put('fiveyrmaxsalesmin', '5');
System.currentPagereference().getParameters().put('fiveyrmaxsalesmax', '10');
System.currentPagereference().getParameters().put('frmdate', '2/10/2010');
System.currentPagereference().getParameters().put('todate', '2/10/2011');
//System.currentPagereference().getParameters().put('frmdate', '');
//System.currentPagereference().getParameters().put('todate', '');


WFSearch.runSearch();
WFSearch.exportexcel();


}

}