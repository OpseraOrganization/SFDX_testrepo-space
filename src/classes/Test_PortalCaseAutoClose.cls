@isTest
public class Test_PortalCaseAutoClose{

static testmethod void PortalCaseAutoClose(){
     
     //test.startTest();
    List<Case> cslist = new List<Case>();
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,
  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T147567');
     insert cont;
       
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No',Sales_Order_Number__c='test1234', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Customer Hold',Reason_for_hold__c='Business Hold'); //For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Customer Hold'); //For ticket INC000010025414
     insert case1;
          
    Case1.status = 'Re-Open';
     Update case1;
     
     Test.startTest();       
     Case case2=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
     //No_FCR_Reason__c='Not Trained',
     recordtypeid=label.QuotesRecordID,Type='Place Order',Order_Type__c = 'Spares',Sales_Order_Number__c='test1234',Product_Type__c='Electrical',
     cage_code__c = '123', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Customer Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold'); //For ticket INC000010025414
     //cage_code__c = '123', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Customer Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case2;
     
     case2.ownerid=label.portal_quotes;
     case2.status='Re-Open';
     update case2;
       // Sprint 2- Only for Code Coverage - Start
        //case1.ownerid=label.R_O_Basingstoke_Quotes_Queue_ID;
        //update case1;        
        // Sprint 2- Only for Code Coverage - End

     
     Case_Line_Item__c cli1 =  new Case_Line_Item__c (Case_Number__c = case1.id,Price__c = 10.00,Quantity__c=10.00);
     Case_Line_Item__c cli2 =  new Case_Line_Item__c (Case_Number__c = case1.id,Price__c = 10.00,Quantity__c=20.00);
     Case_Line_Item__c cli3 =  new Case_Line_Item__c (Case_Number__c = case1.id,Price__c = 10.00,Quantity__c=30.00);
     Case_Line_Item__c cli4 =  new Case_Line_Item__c (Case_Number__c = case1.id,Price__c = 10.00,recordtypeid=label.AverageTimeHold_RecID);
     
     
     case2.status='Discard';
     Update case2;
     Test.stopTest();
     
}
static testmethod void PortalCaseAutoClose1(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
     insert cont;
      Test.startTest(); 
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        // No_FCR_Reason__c='Not Trained',
        recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Engineering Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold'); //For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Engineering Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='Import Hold';
     update case1;
}
static testmethod void PortalCaseAutoClose2(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567');
     insert cont;
      Test.startTest(); 
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'MTO Customer',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold'); //For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'MTO Customer',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='Business Hold';
     update case1;
}
static testmethod void PortalCaseAutoClose3(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H123567');
     insert cont;
     Test.startTest();  
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Sales_Order_Number__c='test1234',Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Export Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold');// For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Export Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='Credit Hold';
     update case1;
}

static testmethod void PortalCaseAutoClose4(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567');
     insert cont;
      Test.startTest(); 
     Case case1=new Case(contactid = Cont.id,Sales_Order_Number__c='test1234',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        // No_FCR_Reason__c='Not Trained',
        recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'MTO',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold'); //For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'MTO',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='Quality Hold';
     update case1;
}

static testmethod void PortalCaseAutoClose5(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
     insert cont;
       Test.startTest();
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234',classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Pricing Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold'); //For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Pricing Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='Integrated Supply Chain Hold';
     update case1;
}
static testmethod void PortalCaseAutoClose6(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
     insert cont;
     Test.startTest();  
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Pricing Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold');// For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Pricing Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='MTO';
     update case1;
}
static testmethod void PortalCaseAutoClose7(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
     insert cont;
      Test.startTest(); 
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Pricing Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold');// For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Pricing Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='MTO Customer';
     update case1;
}
static testmethod void PortalCaseAutoClose8(){
     
     
     Account acc= new Account(name='Test Account');
     insert acc;
   
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
     insert cont;
     Test.startTest();  
     Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        // No_FCR_Reason__c='Not Trained',
        recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Import Hold',VN_Name__c=cont.id,Reason_for_hold__c='Business Hold');//For ticket INC000010025414
        // cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Import Hold',VN_Name__c=cont.id); //For ticket INC000010025414
     insert case1;
     
     case1.sub_status__c='Engineering Hold';
     update case1;
}

}