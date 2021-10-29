/**********************************Change Log******************************** 
SR : 405714
Object - Case
Description:
Send reminder emails to Tech agents based on the Priority of the cases
****************************************************************************/
global class sendGDCRemindersBatch implements Database.batchable<sObject>, Schedulable{
    global string query;
        
    global sendGDCRemindersBatch(){
        //Query to fetch cases of GDC Tech Issue records
        query = 'select id, priority,Case.DateSetForOpen__c, Case_Record_Type__c,contactId from Case where Case_Record_Type__c= \'GDC Tech Issue\' and status=\'Open\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Case> listReminderCases = new List<Case>();
        List<Case> listCaseUpdates = new List<Case>();
        system.debug('----> scope' + scope);
        for(sObject gdcCase : scope)
        {   
            case gdcCase1 = (case)gdcCase;
            if(gdcCase1.DateSetForOpen__c != null){ 
                system.debug('---->gdcCase1.DateSetForOpen__c ' + gdcCase1.DateSetForOpen__c.date().adddays(10) + ' -----> system.Today() ' + system.Today());
                if(gdcCase1.Priority == 'Low' && gdcCase1.DateSetForOpen__c.date().adddays(10) == system.Today() ){
                    listReminderCases.add(gdcCase1);
                    gdcCase1.DateSetForOpen__c = system.now();
                    listCaseUpdates.add(gdcCase1);
                    system.debug('---->Low' + gdcCase1);   
                }else if(gdcCase1.Priority == 'Normal' && gdcCase1.DateSetForOpen__c.date().adddays(5) == system.Today()){
                    listReminderCases.add(gdcCase1);
                    gdcCase1.DateSetForOpen__c = system.now();
                    listCaseUpdates.add(gdcCase1);
                    system.debug('---->Normal' + gdcCase1);
                }else if(gdcCase1.Priority == 'High' && gdcCase1.DateSetForOpen__c.date().adddays(2) == system.Today()){
                    listReminderCases.add(gdcCase1);
                    gdcCase1.DateSetForOpen__c = system.now();
                    listCaseUpdates.add(gdcCase1);
                    system.debug('---->Critical' + gdcCase1);
                }
                
            }
        }
         try{
             if(listCaseUpdates.size() > 0){
                 update listCaseUpdates;
             }
         }catch(Exception ex){
             system.debug('Error from sendGDCRemindersBatch --->' + ex.getMessage());
         }   
        
         Id eTemplate = Label.Followup_GDC_reminder_email;   
         system.debug('eTemplate---->'+eTemplate); 
         List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>(); 
         system.debug('---->reminders' + listReminderCases);
         for(Case gdc : listReminderCases){
               
             Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
             mail.setTemplateID(eTemplate);              
             mail.setWhatId(gdc.Id);
             mail.setTargetObjectId(gdc.contactId);
             mail.setSaveAsActivity(false);
             mails.add(mail);
         }
         Messaging.sendEmail(mails);
               
    }
    
    global void finish(Database.BatchableContext BC){        
        
    } 
    
    global void execute(SchedulableContext sc){
        sendGDCRemindersBatch gdcBatch = new sendGDCRemindersBatch();
        database.executeBatch(gdcBatch,200);
    }
}