/****************************************************************************************
Name         : AccountRevalidationBatch
Created By   : Manish Das
Company Name : TCS
Project      : ADE
Created Date : 11/29/2017 
Usages       : Batch class for sending revalidation mails

Modification History  :
Date         Version No.   Modified by            Brief Description of Modification

****************************************************************************************/

global class AccountRevalidationBatch implements Database.Batchable<sObject>,Schedulable {
    //global Date RD = Date.Today()-337;
    global  Date RD1 = Date.Today()-337;
    global  Date RD2 = Date.Today()-344;
    global  Date RD3 = Date.Today()-351;
    global  Date RD4 = Date.Today()-358;
    global  Date RD5 = Date.Today()-365;
    global string searchString='active';
    global Date RD6;
    global String query;
    global string paddress;
     global string [] trimaddress;
     global  string trimmedaddress;
     global string accountid;
     global boolean intdomain;

    global Database.QueryLocator start(Database.BatchableContext bc){ 
        //System.debug('RD date'+RD);   
        query = 'Select Portal_Created_Date__c,Id,name, Portal_Status__c ,Revalidated_Date__c, Email_Sent_Counter__c, Contact__c,Contact__r.Primary_Contact__c,Contact__r.Contact_Is_Employee__c,Contact__r.Accountid,Contact__r.RecordTypeid,Contact__r.Primary_Email_Address__c  from Portal_Honeywell_ID__c where ((Revalidated_Date__c != Null and Email_Sent_Counter__c< 5 and Portal_Status__c  like   \'%' + searchString + '%\' ) OR (Email_Sent_Counter__c = Null and Primary_Honeywell_ID__c != false and Portal_Status__c like  \'%' + searchString + '%\'   )) and Contact__r.Contact_Is_Employee__c =false ';
        
         return Database.getQueryLocator(query); 
         //System.debug('query'+query);
    }
    
    global void execute(Database.batchableContext bc,List<SObject> scope){
        List<SObject> purReValidationUsers = new List<SObject>();
        for(Sobject s : scope){ 
            Portal_Honeywell_ID__c portaluser = (Portal_Honeywell_ID__c) s;
         if (portaluser != null){
            RD6= portaluser.Revalidated_Date__c;
         }
          paddress=portaluser.Contact__r.Primary_Email_Address__c;
          if(paddress!=null)
          {
         trimaddress=paddress.split('@');
         trimmedaddress=trimaddress[1];
         system.debug('trimmed address'+trimmedaddress);
        
         }
          //List<String> toAddresses=new List<String>();
                 //     toAddresses.add('phani.raj@honeywell.com');
          System.debug('queryoutside'+RD1);
          System.debug('label is '+label.Honeywelldomain);
          System.debug('portaluser.Revalidated_Date__c'+portaluser.Revalidated_Date__c);
           //System.debug('RD'+RD);
          //RD2= Date.RD1;
            if(portaluser != null && portaluser.Revalidated_Date__c == RD1 &&  portaluser.Portal_Status__c != 'Deleted' && (trimmedaddress!=label.Bendixkingcheck && trimmedaddress!=label.Honeywelldomain) && portaluser.Contact__r.RecordTypeid !=label.HoneywellRecordtype){
               System.debug('query ==> '+portaluser.Contact__r.Primary_Email_Address__c);
             
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {portaluser.Contact__r.Primary_Email_Address__c};
                //List<String> toAddresses=new List<String>();
                  //    toAddresses.add('manish.das@honeywell.com');
                mail.setToAddresses(toAddresses);  
                
                mail.settargetObjectId(portaluser.Contact__c);
                mail.setwhatid(portaluser.id);
                mail.setTemplateId(Label.AccountRevalidationTemplate);  
                mail.setOrgWideEmailAddressId(Label.RegistrationAddress);   
                mail.setSaveAsActivity(false);
                                
            
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('New Email_Sent_Counter__c ==> '+portaluser.Email_Sent_Counter__c);
                
                if(portaluser.Email_Sent_Counter__c!=null || portaluser.Email_Sent_Counter__c == 0 )
                    portaluser.Email_Sent_Counter__c = portaluser.Email_Sent_Counter__c + 1;
                else
                    portaluser.Email_Sent_Counter__c = 1;
                 System.debug('New Email_Sent_Counter__c else ==> '+portaluser.Email_Sent_Counter__c);
                  purReValidationUsers.add(portaluser);
            }
        
       
        
        
        if (portaluser.Portal_Status__c != 'Deleted'  && RD6!= null && (trimmedaddress!=label.Bendixkingcheck || trimmedaddress!=label.Honeywelldomain ) && portaluser.Contact__r.RecordTypeid !=label.HoneywellRecordtype  ){
        if((portaluser != null && RD6 == RD2) ||  (portaluser != null && RD6 == RD3) || (portaluser != null && RD6 == RD4)){
               System.debug('queryinside7'+RD1);
             
           /*     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses1= new String[] {portaluser.Contact__r.Primary_Email_Address__c};
                  
              //List<String> toAddresses1=new List<String>();
                //      toAddresses1.add('manish.das@honeywell.com');
                
                mail.setToAddresses(toAddresses1);
                mail.settargetObjectId(portaluser.Contact__c);
                mail.setwhatid(portaluser.id);
                mail.setTemplateId(Label.AccountRevalidationTemplate);  
                mail.setOrgWideEmailAddressId(Label.RegistrationAddress);   
                mail.setSaveAsActivity(false);
                                
            
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                
                if(portaluser.Email_Sent_Counter__c!=null)
                    portaluser.Email_Sent_Counter__c = portaluser.Email_Sent_Counter__c + 1;
                   System.debug('New Email_Sent_Counter__c  ==> '+portaluser.Email_Sent_Counter__c);
                   purReValidationUsers.add(portaluser);
                
                
                //if(portaluser.Email_Sent_Counter__c!=null)
                  //  portaluser.Email_Sent_Counter__c = portaluser.Email_Sent_Counter__c + 1;
                //else
                  //  portaluser.Email_Sent_Counter__c = 1;
                //System.debug('New Email_Sent_Counter__c  ==> '+portaluser.Email_Sent_Counter__c);
                //purReValidationUsers.add(portaluser);
            }
        }
        
      
        if (portaluser.Portal_Status__c != 'Deleted'  && RD6!= null && (trimmedaddress!=label.Bendixkingcheck || trimmedaddress!=label.Honeywelldomain) && portaluser.Contact__r.RecordTypeid !=label.HoneywellRecordtype   ){
        if(portaluser != null && RD6 == RD5){
               System.debug('queryinside5'+RD5);
             
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses3= new String[] {portaluser.Contact__r.Primary_Email_Address__c};
                //List<String> toAddresses3=new List<String>();
                     // toAddresses3.add('phani.raj@honeywell.com');
                mail.setToAddresses(toAddresses3);  
                
                mail.settargetObjectId(portaluser.Contact__c);
                mail.setwhatid(portaluser.id);
                mail.setTemplateId(Label.AccountSuspensionTemplate);  
                mail.setOrgWideEmailAddressId(Label.RegistrationAddress);   
                mail.setSaveAsActivity(false);
                                
            
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                if(portaluser.Email_Sent_Counter__c!=null)
                   portaluser.Email_Sent_Counter__c = portaluser.Email_Sent_Counter__c + 1;
                //System.debug('New Email_Sent_Counter__c  ==> '+portaluser.Email_Sent_Counter__c);
                purReValidationUsers.add(portaluser);
            }
        }
      
       
        
    }
        if(purReValidationUsers.size() > 0){
            update purReValidationUsers;
       }
      
         List<SObject>purList=new List<SObject>();
         List<String> HneywellIds=new List<String>();
         for(Sobject s : scope){
            Portal_Honeywell_ID__c pu = (Portal_Honeywell_ID__c) s;
            if(pu.Email_Sent_Counter__c==5){
            purList.add(pu);
            HneywellIds.add(pu.Name);
            }
         }
          List<SObject> HIDListToUpdate=new List<SObject>();
          
          List<SObject> HIDList=[select id,name from Portal_Honeywell_ID__c where name in:HneywellIds];
          system.debug('the HID list is'+HIDList);
          
        
        
        for(Sobject s1:HIDList){
            Portal_Honeywell_ID__c pHidList=(Portal_Honeywell_ID__c) s1;
            for(String s:HneywellIds){
                if(s==pHidList.name){
                     pHidList.Portal_Status__c='InActive';
                     HIDListToUpdate.add(pHidList);
                }
            }
            
        }
        
         
         update HIDListToUpdate;      
         
    }
    global void finish(Database.BatchableContext bc){
    }
    
    global void execute(SchedulableContext sc){
        AccountRevalidationBatch emailAccountRevalidationBatch = new AccountRevalidationBatch();
        database.executeBatch(emailAccountRevalidationBatch,200);
    }
    
}