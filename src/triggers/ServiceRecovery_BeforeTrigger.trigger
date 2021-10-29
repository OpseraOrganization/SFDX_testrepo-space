/** * File Name: ServiceRecovery_BeforeTrigger
* Description :
* autopopulates account,contact from Cases
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger   ServiceRecovery_BeforeTrigger on Service_Recovery_Report__c (before insert,before update) {
List<Id> caseId =new List<Id>();
List<Case> cases= new List<Case> ();
List<Id> contactId =new List<Id>();
List<Contact> contacts= new List<Contact> ();
Integer contactSize=0,caseSize=0;
   for(Service_Recovery_Report__c servReport: Trigger.New){ 
     // getting the Case Numbers
      if(servReport.Case_Number__c !=null )
      caseId.add(servReport.Case_Number__c);
      // getting the Contacts 
      if(  servReport.Contact_Name__c!=null)
      contactId.add(servReport.Contact_Name__c);      
   }// end of for

// For Auto Population from Cases
if(caseId.size()>0){
//getting the data from Cases
cases=[Select Id ,accountId,contactId from Case where Id in:caseId]; 
 for(Service_Recovery_Report__c  SR:Trigger.new){
  if(SR.Case_Number__c !=null ){
  //auto populating account,cases
  caseSize=cases.size();
    for(integer i=0;i<caseSize;i++){
      if(cases[i].Id==SR.Case_Number__c){
        SR.Account_Name__c=cases[i].AccountId;
        SR.Contact_Name__c=cases[i].ContactId;
      }// end of if
     }//end of for  
   }// end of if
 }// end of for       
}// end of if
// end of autopopulation from Cases

// For Auto Population from Contacts
if(contactId.size()>0){
//getting the data from Contacts
contacts=[Select Id ,accountId from Contact where Id in:contactId]; 
 for(Service_Recovery_Report__c  SRs:Trigger.new){
  if(  SRs.Contact_Name__c!=null){
  //auto populating account
  contactSize=contacts.size();
    for(integer i=0;i<contactSize;i++){
      if(contacts[i].Id==SRs.Contact_Name__c){
        SRs.Account_Name__c=contacts[i].AccountId;
      }// end of if
     }//end of for  
   }// end of if
 }// end of for       
}// end of if
// end of autopopulation from Contacts
}// end of trigger