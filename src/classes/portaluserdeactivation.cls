global class portaluserdeactivation  implements Database.Batchable<sObject>, Schedulable
{  
    global Database.QueryLocator start(Database.BatchableContext BC){
        //return Database.getQueryLocator([SELECT id,Name,IsActive,Email,Federation_Formula__c,CreatedDate,lastlogindate  from user where ID = '005e00000017SGaAAM' or ID ='005e0000000tvqUAAQ' or ID ='005e0000000wuizAAA']);
        return Database.getQueryLocator([select id, name,CreatedDate,IsActive,Email,Federation_Formula__c,Contact.Account.Name,lastlogindate   from user where IsActive =true and ProfileId = :label.Training_Customer_Portal_label and ((createddate <  LAST_N_DAYS:90 and lastlogindate =null) or (createddate < LAST_N_DAYS:90 and lastlogindate !=null and lastlogindate < LAST_N_DAYS:90)) and (NOT Username LIKE '%honeywell%') and (NOT email LIKE '%honeywell%') limit 1000]);       
    }
    string header = 'Record Id, Name , Email,Honeywell ID,Created Date,Account Name,Last Login Date \n';
    string finalstr = header ;    
    List<user> listuser = new List<user>();
    global void execute(Database.BatchableContext BC, List<sObject> scope){           
            for(sObject sol:scope)
            {
                user checkuser =(user) sol;
                if(checkuser.IsActive ==true){ 
                    system.debug('test11111'+checkuser.IsActive);
                    checkuser.IsActive = false;
                    listuser.add(checkuser); 
                    string recordString = checkuser.id+','+checkuser.Name+','+checkuser.email+','+checkuser.Federation_Formula__c+','+checkuser.CreatedDate+','+checkuser.Contact.Account.Name+','+checkuser.lastlogindate+','+'\n';
                    finalstr = finalstr +recordString;              
                }           
            } 
            system.debug('checking listuser size'+listuser.size());             
            if(listuser.size()>0){
                try
                {                                        
                    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    blob csvBlob = Blob.valueOf(finalstr);
                    string csvname= 'Auto Generated Training Portal Deactivated User List.csv';
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();                 
                    String subject ='Auto Generated Training Portal Deactivated User List';
                    email.setSubject(subject);
                    email.setToAddresses( new String[]{Label.portal_deactivated_send_email_address} );
                    email.setCCAddresses(new String[]{Label.portal_deactivated_send_email_address1,Label.portal_deactivated_send_email_address2,Label.portal_deactivated_send_email_address3});
                    email.setHtmlBody('Hi,<br/><br/>This is auto generated email from Salesforce.<br/>Please Find Attached Sheet for the list of Deactivated Training portal users.<br/><br/><br/>Thanks,<br/>SFDC ADMIN.');
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    update listuser; 
                    
                }
                catch(Exception ex){}                
            }
    }      
    global void finish(Database.BatchableContext BC){    
    }
    global void execute(SchedulableContext sc) 
    {
           integer  u=[SELECT count() FROM User WHERE (ProfileId =: label.Portal_User_License1 or ProfileId =: label.Portal_User_License2 or  ProfileId =: label.Portal_User_License3 or ProfileId =: label.Portal_User_License4) and IsActive = true];
          
           integer total=7500;
           integer  total1=total-u;                     
           if(total1<=100)
           {           
           portaluserdeactivation portal = new portaluserdeactivation();
           database.executebatch(portal,500);
           }
       
    }
}