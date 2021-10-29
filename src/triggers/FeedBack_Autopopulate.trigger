/** * File Name: FeedBack_Autopopulate
* Description :Trigger to autopopulate account details
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger FeedBack_Autopopulate on Feedback__c (before insert,before update) {
//variable declarations
List<Id> contactId =new List<Id>();
List<Contact> contacts= new List<Contact> ();
Integer contactSize=0;
Id VOCId;
RecordType[] rec = [Select Id,Name from RecordType where name='NSS' or name='NPS' or name='VOC'];
for(integer i=0;i<rec.size();i++){
// Certido Ticket-348739-- starts //
  if(rec[i].name=='VOC')
  VOCId=rec[i].Id;
//  Certido Ticket-348739-- End // 
}
for( Feedback__c feedback:Trigger.new){
  // getting the Contacts 
  if(feedback.Contact__c!=null  && feedback.RecordTypeId==VOCId)   
  contactId.add(feedback.Contact__c);  
  // Customer Rating
  if(trigger.isinsert || (trigger.isupdate && feedback.Account__C !=trigger.oldMap.get(feedback.id).aCCOUNT__c) || feedback.VOC_SBU__C==null) 
  {
      feedback.VOC_SBU__C=feedback.Account_SBU__C ;
  }
  // Customer Rating
  }// end of for  
// For Auto Population from Contacts
if(contactId.size()>0){
//getting the data from Contacts
contacts=[Select Id ,accountId from Contact where Id in:contactId]; 
 for(Feedback__c  FEs:Trigger.new){
 if(FEs.Contact__c!=null){
  //auto populating account
  contactSize=contacts.size();
    for(integer i=0;i<contactSize;i++){
      if(contacts[i].Id==FEs.Contact__c){
        FEs.Account__c=contacts[i].AccountId;
      }// end of if
     }//end of for  
   }// end of if
 }// end of for       
}// end of if
// end of autopopulation from Contacts
}// end of trigger