trigger FSECOntactPlan_UpdateOwner on Contact_Plan__c (before insert,before update) {
List<Contact_Plan__c> lstcontactplan = Trigger.new;
List<Id> contactId =new List<Id>(); //added by Madhu for prepapulating Account Name value from contact's Account
    for(integer i=0;i<lstcontactplan.size();i++){
    lstcontactplan[i].owner_name__c = lstcontactplan[i].ownerid;
    //added by Madhu for prepapulating Account Name value from contact's Account
        if(lstcontactplan[i].Contact_Name__c!=null){
            contactId.add(lstcontactplan[i].Contact_Name__c);
        }
    }
    //added by Madhu for prepapulating Account Name value from contact's Account
    if(contactId.size()>0){
    //getting the data from Contacts
    List<Contact> contacts=[Select Id ,accountId from Contact where Id in:contactId]; 
     for(Contact_Plan__c  cps:Trigger.new){
      if(cps.Contact_Name__c!=null){
      //auto populating account
        Integer contactSize=contacts.size();
        for(integer i=0;i< contactSize;i++){
          if(contacts[i].Id==cps.Contact_Name__c){
             cps.Account_Name__c=contacts[i].AccountId;
          }// end of if
         }//end of for  
       }// end of if
     }// end of for       
    }// end of if
}