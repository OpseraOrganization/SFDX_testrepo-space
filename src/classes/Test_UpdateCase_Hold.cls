@isTest (seealldata=true)
public class Test_UpdateCase_Hold{
static testmethod void UpdateCase_Hold(){
list<case> lc = new list<case>();
  Account acc= new Account(name='Test Account');
        insert acc;
  Contact cont=new Contact(firstname='Test',LastName='Contact',Email='shrivaths.kulkarni@nttdata.com',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
  Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No',Sales_Order_Number__c='test1234', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', reason_for_hold__c = '8130 TAG', vn_name__c =cont.id);// For ticket INC000010025414
        // cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', vn_name__c =cont.id); //For ticket INC000010025414
     //insert case1;
     lc.add(case1);
     Case case2=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Returns_Recordtypeid,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Customer Hold', reason_for_hold__c = '8130 TAG');// For ticket INC000010025414
        // cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Customer Hold'); //For ticket INC000010025414
     lc.add(case2);
     insert lc;

     
 lc[0].sub_status__c='Customer Hold';
 case1.vn_name__c = null;
    //Update case1;
 lc[1].sub_status__c='Business Hold';
   
    Update lc;
   
}
static testmethod void UpdateCase_Hold1(){
 Account acc= new Account(name='Test Account');
        insert acc;
  Contact cont=new Contact(firstname='Test',LastName='Contact',Email='shriva.k@nttdata.com',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
          Contact cont1=new Contact(firstname='Test',LastName='Contact',Email='shriva@nttdata.com',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123587');
        insert cont1;
             Case case3=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Internal_Escalations_RecordId,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', reason_for_hold__c = '8130 TAG', vn_name__c =cont.id); //For ticket INC000010025414
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', vn_name__c =cont.id); //For ticket INC000010025414
    insert case3; 
    
    test.starttest();
    case3.vn_name__c = cont1.id;
    Update case3;
    case3.status='open';
    Update case3;
    test.stoptest();
}
static testmethod void UpdateCase_Hold2(){
 Account acc= new Account(name='Test Account');
        insert acc;
  Contact cont=new Contact(firstname='Test',LastName='Contact',Email='shriva.k@nttdata.com',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;

             Case case3=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
         //No_FCR_Reason__c='Not Trained',
         recordtypeid=label.Internal_Escalations_RecordId,Type='Order Changes',Order_Type__c = 'Spares',
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', reason_for_hold__c = '8130 TAG', vn_name__c =cont.id); //For ticket INC000010025414
        // cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', vn_name__c =cont.id); //For ticket INC000010025414
    insert case3; 
    
    test.starttest();
    //case3.reason_for_hold__c = 'Consumption Ordering - 07'; For ticket INC000010025414
    Update case3;
    test.stoptest();
}
}