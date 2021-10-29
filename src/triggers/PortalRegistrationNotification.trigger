/** * File Name: ToolAccessNotification
* Description Trigger - To send Welcome aboard Email to Contact for when a new contact is created in Portal
* Copyright : TCS
* * @author : TCS
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
*                  1.0            TCS                 Initial Version created
* 
*************************************************************************************************************************************************
**/ 
trigger PortalRegistrationNotification on Portal_User_Registration__c (after update) {
Portal_User_Registration__c newUser=Trigger.new[0];
if (Trigger.isUpdate ){
      
       if(newUser!=null && newUser.Contact_Creation_in_SFDC__c!= null && newUser.Contact__c!=null && Trigger.newMap.get(newUser.Id).Contact_Creation_in_SFDC__c!=Trigger.oldMap.get(newUser.Id).Contact_Creation_in_SFDC__c &&Trigger.newMap.get(newUser.Id).Contact_Creation_in_SFDC__c== 'Y'){
             List<String> requester1=new List<String>();
             List<Contact> Contact=[select name,id ,Email,account.name  from contact where id =:newUser.Contact__c];
             
                        
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             if (Contact.size()>0){
              
              if(Contact[0].Email!=null ){
                    requester1.add(Contact[0].Email);
                }
                if ((Contact[0].account.name.toUppercase())== 'HONEYWELL UNIDENTIFIED PORTAL USERS'){
                     System.debug('toolListappved'+(Contact[0].account.name));
                     mail.setTemplateId(label.CompanyValidation); 
                }
                else if ((Contact[0].account.name.toUppercase())!= 'HONEYWELL UNIDENTIFIED PORTAL USERS'){
                    mail.setTemplateId(label.PortalRegistrationCompletion); 
                }
                
                         
            
            String subj = '';
            String body = '';
            if(Contact[0].Email!=null){
            
             subj='Web Registration Completed';
             
                 mail.settargetObjectId(newUser.Contact__c);
                 mail.setToAddresses(requester1);
                 mail.setOrgWideEmailAddressId(label.RegistrationAddress);                               
                 //mail.setTemplateId(label.PortalRegistrationCompletion);                          
                 Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
             
             }          
             
             
    }
    }
    
     
}
}