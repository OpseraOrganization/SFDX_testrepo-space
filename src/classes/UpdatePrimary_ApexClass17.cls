/** * File Name: UpdatePrimary_ApexClass16
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class UpdatePrimary_ApexClass17 {
static testmethod void testUpdatePrimary(){

 //creating account;
 /*Account acc= new Account(name='Test Account17');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test17',LastName='Contact17',AccountId=acc.Id,Phone_3__c='9986512495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='5617' );
 insert cont;


Skills2__c skill= new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
insert skill;
test.starttest();
 //creating case
Case cases15=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
No_FCR_Reason__c='Not Trained',Type='Order',
Supported_Product__c='Radio',Origin = 'Email-MyAerospacePortalIssue');
insert cases15; 
 tRY
 {
Case casesFAX=new Case(AccountId=acc.Id,subject='has sent fax',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
No_FCR_Reason__c='Not Trained',Type='Order',
Supported_Product__c='Radio',Origin = 'Email-RSAeroQuoteQuality');
insert casesFAX; 
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                    'Email Message having success for Fax Creation not needed'),
                      e.getMessage());
}
test.stoptest();*/
 }

}