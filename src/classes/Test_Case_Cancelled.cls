/** * File Name:  Test_Case_Cancelled 
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(seealldata=true)
public with sharing class Test_Case_Cancelled {

static testMethod void CaseCancelled(){
TriggerInactive.TestCaseCancelled = false;
    Integer yr=System.today().year();
    String year=String.valueof(yr);
    //creating Account;
    Account acc=new Account();
    acc.name='Wipro Offshore Case Cancelled Test Account'; 
    acc.Service_Level__c ='Unauthorized Dist/Brkr';
    insert acc;
    //creating contact;
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',  Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E575671',Employee_Contact_Role__c='Administrator'); 
     insert cont;
     //Skills2__c skills=[Select Contact_Name__c,Contact_Email__C,Supported_Product__c,Primary_Secondary__c from Skills2__c 
                 //where  (Primary_Secondary__c='Primary' ) order by Primary_Secondary__c limit 1];
    //creating Case 
    Case c=new Case();
    c.Status ='Cancelled';
    //c.Is_Cancelled__c=false;
    c.Reason_for_Cancellation__c = 'Duplicate CASE';
    //RecordType rec =[Select r.Name, r.Id From RecordType r where name = 'AOG' limit 1];
   // c.RecordTypeId = rec.Id;
    c.RecordTypeId='01230000000Zemy';
    c.Classification__c ='APAC ACT Internal';
    c.Sub_Class__c ='Advance Exchange';
    c.Export_Compliance_Content_ITAR_EAR__c='No';
    c.Government_Compliance_SM_M_Content__c='No';
    //c.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
    c.Type='AOG';
    c.Quote_Total_Gtr_Than_5000__c = 'No';
    c.origin='Phone';
    c.ContactId=cont.Id;
    c.Supported_Product__c = null;
    insert c;
    //c.Is_Cancelled__c =true;
    //update c;
    
    Test.startTest();
   
    //Case_Cancelled CC=new Case_Cancelled();
   //String sch='0 0 23 * * ?';  
   // System.schedule('Sample Scheduling',sch,CC);
   
   Test.stoptest();
}
}