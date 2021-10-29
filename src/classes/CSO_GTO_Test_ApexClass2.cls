/** * File Name: CSO/GTO_Test_ApexClass2
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* */

@isTest
private  class CSO_GTO_Test_ApexClass2 {
static testmethod void testCallCenter(){
Test.startTest();
 Account acc= new Account(name='Test Account');
 insert acc;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E132567' );
 insert cont;
Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order');
 insert cases;
 Case_Line_Item__c caseLine= new Case_Line_Item__c(Part_Number__c='111',Case_Number__c=cases.Id,Comments__c='Testing');
 insert caseLine;
 Test.stopTest();
}
}