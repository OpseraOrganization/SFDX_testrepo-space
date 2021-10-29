/**********************************Change Log******************************** 
Tikcet : INC000006437197
Object - Case
Description:
Sent cases status to Open and send alerts to case owners
****************************************************************************/
global class setCaseStatusOpen implements Database.batchable<sObject>, Schedulable{
    global string query;
        
    global setCaseStatusOpen(){
        //Query to fetch cases of GDC Tech Issue records
        query = 'select id,Classification__c,Sub_Status__c, status,Internal_HW_Action__c,ownerid,CaseNumber from Case where (Case_Record_Type__c= \'D&S Quotes Orders\' or Case_Record_Type__c= \'Repair & Overhaul\') and status=\'On Hold\' and (Classification__c= \'CSO D&S Repair\' or Classification__c= \'CSO D&S Internal\') and lastmodifieddate <= YESTERDAY and lastmodifieddate >= LAST_N_DAYS:2';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Case> listReminderCases = new List<Case>();
        List<Case> listCaseUpdates = new List<Case>();
        system.debug('----> scope' + scope);
        for(sObject caseRec : scope)
        {   
            case caseRec1 = (case)caseRec;
            if(caseRec1.Sub_Status__c =='Business Hold' || caseRec1.Sub_Status__c =='Integrated Supply Chain Hold' || caseRec1.Sub_Status__c =='Quality Hold' || caseRec1.Sub_Status__c =='Contract Hold' || caseRec1.Sub_Status__c =='Export Hold' || caseRec1.Sub_Status__c =='Engineering Hold'){
                caseRec1.status = 'Open';
                listCaseUpdates.add(caseRec1); 
                listReminderCases.add(caseRec1);
            }
        }
        try{
            if(listCaseUpdates.size() > 0){
                update listCaseUpdates;
            }
        }catch(Exception ex){
            system.debug('Error from setCaseStatusOpen--->' + ex.getMessage());
        }   
        
        List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>(); 
        system.debug('---->reminders' + listReminderCases);
        string msgBody = 'status has been changed to Open. Please provide an Internal Honeywell Action and notify the action owner via email using the appropriate Honeywell Internal Action template.';
        string msgSubject = '- Status has been changed to Open';
        for(Case orderCase : listReminderCases){
            if(string.valueof(orderCase.ownerid).startswith('00G') == false && (orderCase.Internal_HW_Action__c == null || orderCase.Internal_HW_Action__c == '')){  
                Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                mail.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                mail.setTargetObjectId(orderCase.ownerid);
                string msgBodyNew = orderCase.CaseNumber + ' '+ msgBody;
                string msgSubjectNew = orderCase.CaseNumber + ' '+ msgSubject;
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
        setCaseStatusOpen ordersBatch = new setCaseStatusOpen();
        database.executeBatch(ordersBatch,200);
    }
}