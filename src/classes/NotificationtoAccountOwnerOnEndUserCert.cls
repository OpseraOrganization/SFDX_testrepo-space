/*******************************************************************************
Name            :   NotificationtoAccountOwnerOnEndUserCert
Created By      :   NTT Data
Created Date    :   27-May-2015
Test Class      :   NotificationAccOwnerOnEndUserCertTest
Usages          :   This Class is to fetch the Accounts to send notification alert if
                    End User Certification Expiration Date is 8 weeks of today.
*******************************************************************************/
global class NotificationtoAccountOwnerOnEndUserCert implements Database.batchable<sObject>,Schedulable{
    global string query;
    Date todaydate = system.today();
    DateTime accexpdate;
    List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
    global NotificationtoAccountOwnerOnEndUserCert(){
        //Query to fetch Accounts
        query = 'select id,Ownerid,Owner.Email,Name,End_User_Cert_on_File__c,End_User_Cert_Expiration_Date__c from Account where End_User_Cert_on_File__c=True and End_User_Cert_Expiration_Date__c !=null';
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>(); 
        Set<Id> listReminderaccts = new Set<Id>();
        List<Account> acclist = new List<Account>();
        Date dt;
        for(sObject acc : scope){   
            Account accDetails = (Account)acc;
            accexpdate = accDetails.End_User_Cert_Expiration_Date__c;
            dt = accexpdate.Date(); 
            if(todaydate.daysBetween(dt)==56){
                system.debug('----------'+accDetails.id);
                listReminderaccts.add(accDetails.id);
            }
            system.debug('++++++++++++');
        }
        if(listReminderaccts.size()>0)
            acclist = [select id,Ownerid,Owner.Email,Name,End_User_Cert_on_File__c,End_User_Cert_Expiration_Date__c from Account where id IN:listReminderaccts];
        if(acclist.size()>0){
            for(Account a : acclist){
                system.debug('Inside acc----->');  
                String sub = 'End User Cert for '+a.Name+' Expires in 8 weeks';
                String htmlbody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="500" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td><table height="400" width="500" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">The End User Certification for '+a.Name+' expires on '+a.End_User_Cert_Expiration_Date__c+'. Please take the appropriate actions to work with the customer on creating a new certification.</font></td></tr></table></td></tr></table><br/><br/></body></html>';
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                if(a.OwnerId == Label.API_User_SFDC_Cust_Master){
                    String[] toadd = new String[]{'amy.mesa@honeywell.com'};
                    msg.setToAddresses(toadd);
                }else{
                    String[] toadd1 = new String[]{a.Owner.Email};
                    msg.setToAddresses(toadd1);
                }
                msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                msg.setBccSender(false);             
                msg.setUseSignature(false);
                msg.setSubject(sub);
                msg.setHtmlBody(htmlbody);
                msg.setWhatId(a.id);  
                msgList.add(msg);
            }
            if(msgList.size()>0){
                try{
                    Messaging.sendEmail(msgList);
                }catch(Exception emailexe){
                    system.debug('Accounts Mail Sending Invalid------>'+emailexe.getMessage());
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){} 
    
    global void execute(SchedulableContext sc){
        NotificationtoAccountOwnerOnEndUserCert ordersBatch = new NotificationtoAccountOwnerOnEndUserCert();
        database.executeBatch(ordersBatch,20);
    }
}