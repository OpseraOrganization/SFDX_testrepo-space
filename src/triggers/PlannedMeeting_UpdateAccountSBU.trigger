/****************************************************************
Modification History:
06-Feb-2018 : INC0000175466 - To update Recipient fields on related Contact record.
****************************************************************/
trigger PlannedMeeting_UpdateAccountSBU on Planned_Meeting__c (before insert,before update) {
Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
if(p.Name!='API DATA LOAD'){
List<Planned_Meeting__c> lstplannedmeeting = Trigger.new;
List<Id> contactId =new List<Id>(); //added  for prepopulating Account Name value from contact's Account
List<Id> accountId =new List<Id>();//added for sbu
set<Id> accids = new set<Id>();
    for(integer i=0;i<lstplannedmeeting.size();i++){
    lstplannedmeeting[i].owner_name__c = lstplannedmeeting[i].ownerid;
    //added for prepopulating Account Name value from contact's Account
        if(lstplannedmeeting[i].Contact_Name__c!=null){
            contactId.add(lstplannedmeeting[i].Contact_Name__c);
            accountId.add(lstplannedmeeting[i].Account_Name__c);//prepopulating sbu value            
          }
    }
    //added for prepopulating Account Name value from contact's Account
    if(contactId.size()>0){
        //getting the data from Contacts
        List<Contact> contacts=[Select Id ,accountId ,SBU_Contact__c, AIN_Survey_Recipient__c, ProPilot_Survey_Recipient__c  from Contact where Id in:contactId];
        List<Contact> contactsUpdate = new List<Contact>();
        for(Planned_Meeting__c  cps:Trigger.new){
            if(cps.Contact_Name__c!=null){
                //auto populating account
                Integer contactSize=contacts.size();
                for(integer i=0;i< contactSize;i++){
                    if(contacts[i].Id==cps.Contact_Name__c){
                        cps.Account_Name__c=contacts[i].AccountId;
                        cps.SBU__c=contacts[i].SBU_Contact__c;
                        // Added code for INC0000175466
                        if((cps.AIN_Survey_Recipient__c!=null || (trigger.isUpdate && cps.AIN_Survey_Recipient__c!=trigger.oldMap.get(cps.Id).AIN_Survey_Recipient__c)) || (cps.ProPilot_Recipient__c!=null || (trigger.isUpdate && cps.ProPilot_Recipient__c!=trigger.oldMap.get(cps.Id).ProPilot_Recipient__c))){
                            system.debug('=====inside IF====='+cps);
                            if(null!=cps.AIN_Survey_Recipient__c && cps.AIN_Survey_Recipient__c == TRUE)
                                contacts[i].AIN_Survey_Recipient__c = TRUE;
                            else
                                contacts[i].AIN_Survey_Recipient__c = FALSE;
                            if(null!=cps.ProPilot_Recipient__c && cps.ProPilot_Recipient__c == TRUE)
                                contacts[i].ProPilot_Survey_Recipient__c = TRUE;
                            else
                                contacts[i].ProPilot_Survey_Recipient__c = FALSE;
                            contactsUpdate.add(contacts[i]);
                        }
                        // End code for INC0000175466
                    }// end of if
                }//end of for  
            }// end of if
        }// end of for 
        if(contactsUpdate.size()>0)
            update contactsUpdate;
    }// end of if
}
}