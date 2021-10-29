@isTest
public class ServiceRequest_Aircraft_ClsTest
{
static testMethod void testeGreen_sheet_Approval_draft(){

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

Contact CntRec= new Contact();
CntRec.Accountid=AccRec.id;
CntRec.FirstName='Testing';
CntRec.LastName='Check';
CntRec.Email='anila.francis@wipro.com';
insert CntRec;

Case ca = new Case();
ca.Recordtypeid = label.General_RT_ID;
ca.Origin = 'phone';
ca.Export_Compliance_Content_ITAR_EAR__c = 'No';
ca.Government_Compliance_SM_M_Content__c = 'No';
ca.Classification__c = 'gcc';
ca.type = 'Other';
ca.status = 'Open';
ca.Contact = CntRec;
insert ca;
   
   test.starttest();
   Service_Request__c SRrec = new Service_Request__c();
   SRrec.Contact_Name__c=CntRec.id;
   SRrec.recordtypeid = '01230000000ZewNAAS';
   SRrec.SR_Type__c = 'Field Event';
   SRrec.Subject__C = 'test';
   SRrec.Status__C = 'Open';
   SRrec.Priority__c = 'High';
   SRrec.Problem_Description__c = 'test';
   SRrec.Deliverable__c = 'test';
   SRrec.Atr__c  = 'Service/Support';
    SRrec.Attribute_Details__c  =  'Product Investigation';
    SRrec.Attribute_Sub__c  =  'Field Service Support';
    SRrec.Complexity_Level__c ='1-Part Price/Availability';
    SRrec.Customer_Due_Date__c = system.today();
    // SRrec.HON_Commit_Date__c = system.today();
    // SRrec.Allow_Past_HON_commit_Date__c = true;
    SRrec.Case_Number__c = ca.id ;
    SRrec.Ownerid=label.EPS_ATR_Queue;
    SRrec.Gate_1_Completion_Date__c = system.today();
    SRrec.CSB_Gate__c ='test';
   insert SRrec;
   
   SRrec.Status__c = 'closed';
   SRrec.Date_Closed__c = system.today() +101;
   SRrec.Key_Code__c = '';
   update SRrec;
   
   Service_Request__c SRrec1 = new Service_Request__c();
   SRrec1.Contact_Name__c=CntRec.id;
   SRrec1.recordtypeid = '01230000000ZewNAAS';
   SRrec1.SR_Type__c = 'Field Event';
   SRrec1.Subject__C = 'test';
   SRrec1.Status__C = 'Open';
   SRrec1.Priority__c = 'High';
   SRrec1.Problem_Description__c = 'test';
   SRrec1.Deliverable__c = 'test';
   SRrec1.Atr__c  = 'Service/Support';
    SRrec1.Attribute_Details__c  =  'Product Investigation';
    SRrec1.Attribute_Sub__c  =  'Field Service Support';
    SRrec1.Complexity_Level__c ='1-Part Price/Availability';
    SRrec1.Customer_Due_Date__c = system.today();
    // SRrec1.HON_Commit_Date__c = system.today();
    // SRrec1.Allow_Past_HON_commit_Date__c = true;
    SRrec1.Case_Number__c = ca.id ;
    SRrec1.Gate_2_Completed__c = system.today();
    SRrec1.CSB_Gate__c = 'Gate 3';
    SRrec1.Key_Code__c = 'test';
    SRrec1.Ownerid =Label.EPS_BGA_Queue;
   insert SRrec1;
   
   SRrec.Status__c = 'Rejected';
   SRrec.Date_Closed__c = system.today() +80;
   SRrec1.Ownerid=label.EPS_ATR_Queue;
   update SRrec1;
   
   Service_Request__c SRrec2 = new Service_Request__c();
   SRrec2.Contact_Name__c=CntRec.id;
   SRrec2.recordtypeid = '01230000000ZewNAAS';
   SRrec2.SR_Type__c = 'Field Event';
   SRrec2.Subject__C = 'test';
   SRrec2.Status__C = 'Open';
   SRrec2.Priority__c = 'High';
   SRrec2.Problem_Description__c = 'test';
   SRrec2.Deliverable__c = 'test';
   SRrec2.Atr__c  = 'Service/Support';
    SRrec2.Attribute_Details__c  =  'Product Investigation';
    SRrec2.Attribute_Sub__c  =  'Field Service Support';
    SRrec2.Complexity_Level__c ='1-Part Price/Availability';
    SRrec2.Customer_Due_Date__c = system.today();
    // SRrec2.HON_Commit_Date__c = system.today();
    // SRrec2.Allow_Past_HON_commit_Date__c = true;
    SRrec2.Case_Number__c = ca.id ;
    SRrec2.Gate_2_Completed__c = system.today();
    SRrec2.CSB_Gate__c = 'Gate 3';
    SRrec2.Key_Code__c = 'test';
    SRrec2.Ownerid = Label.EPS_D_S_Queue;
    SRrec2.Date_Closed__c = system.today() +80;
   insert SRrec2;
   
   SRrec2.Status__c = 'Rejected';
   SRrec2.Date_Closed__c = system.today() +80;
   SRrec2.Clone_Button_clicked__c = false;
   SRrec2.recordtypeid ='01230000000ZewM';
   String strProfileId = string.valueof(Userinfo.getProfileId()).substring(0,15);
   strProfileId = '00e300000017loa';
   SRrec2.Ownerid = label.EPS_ATR_Queue;
   SRrec2.Gate_2_Completed__c = null;
   SRrec2.Gate_1_Completion_Date__c = system.today();
   SRrec2.CSB_Gate__c = 'Gate 1';
   update SRrec2;
   
   Service_Request__c SRrec3 = new Service_Request__c();
   SRrec3.Contact_Name__c=CntRec.id;
   SRrec3.recordtypeid = '01230000000ZewNAAS';
   SRrec3.SR_Type__c = 'Field Event';
   SRrec3.Subject__C = 'test';
   SRrec3.Status__C = 'Rejected';
   SRrec3.Priority__c = 'High';
   SRrec3.Problem_Description__c = 'test';
   SRrec3.Deliverable__c = 'test';
   SRrec3.Atr__c  = 'Service/Support';
    SRrec3.Attribute_Details__c  =  'Product Investigation';
    SRrec3.Attribute_Sub__c  =  'Field Service Support';
    SRrec3.Complexity_Level__c ='1-Part Price/Availability';
    SRrec3.Customer_Due_Date__c = system.today();
    // SRrec3.HON_Commit_Date__c = system.today();
    // SRrec3.Allow_Past_HON_commit_Date__c = true;
    SRrec3.Case_Number__c = ca.id ;
    SRrec3.Gate_2_Completed__c = system.today();
    SRrec3.CSB_Gate__c = 'Gate 3';
    SRrec2.Key_Code__c = 'test';
    SRrec3.Ownerid = Label.EPS_D_S_Queue;
    SRrec3.Date_Closed__c = system.today() +80;
    SRrec3.Gate_1_Completion_Date__c = null;
    SRrec3.Gate_2_Completed__c = null;
   insert SRrec3;
   
   SRrec3.Status__c = 'Closed';
   SRrec3.Date_Closed__c = system.today() +80;
   SRrec3.Ownerid = label.EPS_ATR_Queue;
   SRrec3.CSB_Gate__c = 'Gate 3';
   SRrec3.Key_Code__c = '';
   update SRrec3;
   
   Service_Request__c SRrec4 = new Service_Request__c();
   SRrec4.Contact_Name__c=CntRec.id;
   SRrec4.recordtypeid = '01230000000ZewNAAS';
   SRrec4.SR_Type__c = 'Field Event';
   SRrec4.Subject__C = 'test';
   SRrec4.Status__C = 'Rejected';
   SRrec4.Priority__c = 'High';
   SRrec4.Problem_Description__c = 'test';
   SRrec4.Deliverable__c = 'test';
   SRrec4.Atr__c  = 'Service/Support';
    SRrec4.Attribute_Details__c  =  'Product Investigation';
    SRrec4.Attribute_Sub__c  =  'Field Service Support';
    SRrec4.Complexity_Level__c ='1-Part Price/Availability';
    SRrec4.Customer_Due_Date__c = system.today();
    // SRrec4.HON_Commit_Date__c = system.today();
    // SRrec4.Allow_Past_HON_commit_Date__c = true;
    SRrec4.Case_Number__c = ca.id ;
    SRrec4.Gate_2_Completed__c = system.today();
    SRrec4.CSB_Gate__c = 'Gate 3';
    SRrec4.Key_Code__c = '';
    SRrec4.Ownerid = Label.EPS_D_S_Queue;
    SRrec4.Date_Closed__c = system.today() +80;
    SRrec4.Gate_1_Completion_Date__c = null;
    SRrec4.Gate_2_Completed__c = null;
   insert SRrec4;
   test.stoptest();
   
   
   list<Platform__c> pla = [select id from Platform__c limit 2];
   PageReference ref = new PageReference('/AddmultipleAircrafts?id='+SRrec.id); 
    Test.setCurrentPage(ref);
        AddmultipleAircraftsController SRAirCrftCls=new AddmultipleAircraftsController();
       SRAirCrftCls.ap.Aircraft_Platforms_Affected__c=pla[0].id;
      //SRAirCrftCls.saveAirPlaAff();
      SRAirCrftCls.addAirPlaAff();
      SRAirCrftCls.listAPA[1].Aircraft_Platforms_Affected__c=pla[1].id;
      SRAirCrftCls.saveAirPlaAff();
    PageReference ref1 = new PageReference('/AddmultipleAircrafts?id='+SRrec.id); 
    Test.setCurrentPage(ref1);
    AddmultipleAircraftsController SRAirCrftCls1=new AddmultipleAircraftsController();
    SRAirCrftCls.cancelAirPlaAff();
    ServiceRequest_Aircraft_Cls.ccMethod();
   }
}