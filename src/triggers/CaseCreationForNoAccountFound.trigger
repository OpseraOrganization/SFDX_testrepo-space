trigger CaseCreationForNoAccountFound on Contact (after insert) {
    List<Contact> lstContacts = Trigger.new;
    List<Case> cs = new List<Case>();
    
    Id rt = [Select Id from recordType where Name = 'Customer Master Data'].Id;
    
    if(lstContacts.size() > 0){
    for(integer i=0;i<lstContacts.size();i++){
     if(lstContacts[i].Account_Name__c == 'NO ACCOUNT FOUND'){
         Case cse = new Case();
         cse.Origin = 'Fax';
         cse.Status = 'New';
         cse.RecordTypeId = rt;
         cse.Classification__c = 'Customer Master Team / eBusiness';
         cse.ContactId = lstContacts[i].Id;
         cse.Type_of_Change__c = 'New Account';
         cse.Type = 'Other';
         cse.Ownerid = label.Customer_Master_Data_SFDC_Accounts;
         cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
         cse.Government_Compliance_SM_M_Content__c = 'NO';
         cs.add(cse);
         
     }
    }
    try {
        if(cs.size() > 0){
            insert cs;
        }
    }catch(Exception ex){}
    }
    //Code changes to copy contact information back to lead - Create New Contact functionality.
    if(lstContacts.size() == 1 && lstContacts.get(0).lead_ID__c != null){
        Lead leadRec = [select id,Contact__c from Lead where id=:lstContacts.get(0).lead_ID__c];
        leadRec.Contact__c = lstContacts.get(0).id;
        update leadRec;
    }
}