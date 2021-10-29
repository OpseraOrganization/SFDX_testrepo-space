/**********************************Change Log******************************** 
Tikcet : INC000006437197
Object - Case
Description:
Sent cases status to Open and send alerts to case owners
****************************************************************************/
global class setCaseStatusOpenThruEmails implements Database.batchable<sObject>, Schedulable{
    global string query;
    global setCaseStatusOpenThruEmails(){
        query = 'select id, status,parentid,Subject,LastModifiedDate from EmailMessage where  (status = \'1\' OR status = \'0\') and lastmodifieddate <= YESTERDAY and lastmodifieddate >= LAST_N_DAYS:2';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<EmailMessage> listAllEmails = new List<EmailMessage>();
        map<id,id> caseIds = new map<id,id>();
        system.debug('----> scope' + scope);
        integer i = 0;
        for(sObject emessage : scope)
        {   
            EmailMessage em = (EmailMessage)emessage;
            if(em.subject != null){
                if( (integer.valueof(em.lastmodifieddate.day()) == Integer.valueof(datetime.now().day()-1) && integer.valueof(em.lastmodifieddate.hour()) <= integer.valueof(datetime.now().hour()) || 
                (integer.valueof(em.lastmodifieddate.day()) == integer.valueof(datetime.now().day()-2) && integer.valueof(em.lastmodifieddate.hour()) >= integer.valueof(datetime.now().hour())))
                && em.subject.indexOf('HIA - Action') != -1 || em.subject.indexOf('HIA-Action') != -1 || (em.subject.indexOf('HIA') != -1 && em.subject.indexOf('Action') != -1 && em.subject.indexOf('HIA') < em.subject.indexOf('Action')) ){
                    if(caseIds.get(em.parentid) == null){
                        caseIds.put(em.parentid,em.parentid);
                    }
                    i++;
                    system.debug('i---------->' + i);
                }
            }
        }
        List<case> listCaseUpdates = new List<Case>();     
        if(caseIds.size() > 0){
            List<Case> listCase = [select id, status,Internal_HW_Action__c ,sub_status__c, classification__c, ownerid,CaseNumber from Case where id in: caseIds.keySet() and (RecordTypeId =: Label.D_S_Quotes_Orders_RT_ID or RecordTypeId =: Label.Repair_Overhaul_RT_ID) and Status ='On Hold' and (Classification__c = 'CSO D&S Repair' or Classification__c = 'CSO D&S Internal')];
            for(Case cas:listCase){
                if(cas.Sub_Status__c =='Business Hold' || cas.Sub_Status__c =='Integrated Supply Chain Hold' || cas.Sub_Status__c =='Quality Hold' || cas.Sub_Status__c =='Contract Hold' || cas.Sub_Status__c =='Export Hold' || cas.Sub_Status__c =='Engineering Hold'){
                    cas.status = 'Open';
                    listCaseUpdates.add(cas);
                }
            }
            if(listCaseUpdates.size() > 0){
                update listCaseUpdates;
            }
        }
        
        List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>(); 
        string msgBody = 'status has been changed to Open. The email history on this case shows that you have sent a Honeywell Internal Action message to a Honeywell employee and that you received a response 24 hours ago. Please check the case to see the response and take appropriate actions.';
        string msgSubject = '- Status has been changed to Open';
        for(Case caserecord: listCaseUpdates){
            if(string.valueof(caserecord.ownerid).startswith('00G') == false && (caserecord.Internal_HW_Action__c == null || caserecord.Internal_HW_Action__c == '')){  
                Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                mail.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                mail.setTargetObjectId(caserecord.ownerid);
                string msgBodyNew = caserecord.CaseNumber + ' '+ msgBody;
                string msgSubjectNew = caserecord.CaseNumber + ' '+ msgSubject;
                mail.setSubject(msgSubjectNew);
                mail.setPlainTextBody(msgBodyNew);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }
        }
        Messaging.sendEmail(mails);
    }
    
    global void finish(Database.BatchableContext BC){} 
    
    global void execute(SchedulableContext sc){
        setCaseStatusOpenThruEmails Batch = new setCaseStatusOpenThruEmails();
        database.executeBatch(Batch,200);
    }
}