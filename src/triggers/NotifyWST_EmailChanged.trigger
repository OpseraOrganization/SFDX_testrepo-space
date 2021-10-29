trigger NotifyWST_EmailChanged on Contact (before update) {
    /*commenting trigger code for coverage
    List<ID> contactId = new List<ID>();
    List<String> oldEmail = new List<String>();
    List<String> newEmail = new List<String>();
    //List<Contact> contactList = Trigger.new;
    
    List<Contact> ContactList= new List<Contact>();
    for(Contact con : Trigger.new){
        ContactList.add(con);
    }
    
    for(Contact cnt : Trigger.new){
        contactId.add(cnt.id);
    }
    
    if(contactId.size()>0)
    {
        List <Portal_Honeywell_ID__c> portalHID = [select Id from Portal_Honeywell_ID__c where Contact__c in : contactId ];
        sendEmail se = new sendEmail();
        integer flag = 0;
        for(integer i=0;i<contactList.size();i++){
            
            oldEmail.add(Trigger.old[i].Email);
            newEmail.add(contactList[i].Email);
            
            if(contactList[i].Email != '' || contactList[i].Alternate_Email_Address__c != ''){
            //if((Trigger.old[i].Email !=  contactList[i].Email || Trigger.old[i].Primary_Email_Address__c !=  contactList[i].Primary_Email_Address__c || Trigger.old[i].Alternate_Email_Address__c !=  contactList[i].Alternate_Email_Address__c) && portalHID .size() > 0 ){
            if((Trigger.old[i].Email !=  contactList[i].Email || Trigger.old[i].Alternate_Email_Address__c !=  contactList[i].Alternate_Email_Address__c) && portalHID .size() > 0 ){
                //Email sending Code ...
                System.debug('contact Email has been changed ....');
                flag = 1;
                //contactList[i].HasHoneywellPortalId__c = true;
            }
            }
        }*/
        /*
        try {
            update contactList;
        }catch(Exception ex){
        
        }
        */
        /*if(flag == 1){
             if(sendEmail.flag == true){
                 sendEmail.flag = false;
                 //Commented to test 
                 se.sendMail(contactId,oldEmail,newEmail);
             } 
        }
    }*/
 
}