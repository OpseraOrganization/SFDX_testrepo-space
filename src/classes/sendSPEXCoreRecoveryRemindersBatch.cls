/**********************************Change Log******************************** 
SR : 421342
Object - Case
Description:
Send reminder emails to SPEX Core Recovery Team 
****************************************************************************/
global class sendSPEXCoreRecoveryRemindersBatch implements Database.batchable<sObject>, Schedulable{
    global string query;
    global List<Messaging.SingleEMailMessage>  mails;
    global list<id> listToAddresses;
    
    
    global sendSPEXCoreRecoveryRemindersBatch (){
        //Query to fetch cases
        query = 'select id, priority, ownerid, createddate,Sub_Class__c,Detail_Class__c from Case where Case_Record_Type__c= \'Rotable Core\' and status=\'Open\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    
        mails = new List<Messaging.SingleEMailMessage>();    
        listToAddresses = new list<id>();
    
        List<Case> listReqExcahngeReminderCases = new List<Case>();
        List<Case> listFriendlyRentalReqReminderCases = new List<Case>();
        List<Case> listRentalUnitReqReminderCases = new List<Case>();
        List<Case> listPastDueExcahngeReminderCases= new List<Case>();
        //system.debug('----> scope' + scope);
        
        for(sObject sxCase : scope)
        {   
            case spexCase = (case)sxCase;
            if((spexCase.Sub_Class__c =='ER01 - Avionics Exch & Rent' || spexCase.Sub_Class__c =='ER07 - Mechanical Exchanges') 
            && (spexCase.Detail_Class__c == 'Exchange')){
                if(spexCase.CreatedDate.date().adddays(10)== system.today())//9
                    listReqExcahngeReminderCases.add(spexCase);
                else if(spexCase.CreatedDate.date().adddays(28)== system.today()){//0
                    listPastDueExcahngeReminderCases.add(spexCase);
                }
            }else if((spexCase.Sub_Class__c =='ER01 - Avionics Exch & Rent') 
            && (spexCase.Detail_Class__c == 'Rental')
            ){
                if(spexCase.CreatedDate.date().adddays(30)== system.today() )//5
                  listFriendlyRentalReqReminderCases.add(spexCase);
                else if(spexCase.CreatedDate.date().adddays(60)== system.today())//8
                    listRentalUnitReqReminderCases.add(spexCase); 
            }
            //listCasesFromQuery.add();
        }
         
        //Get all template IDs        
         Id eTempFriendly_reminder_Rental_unit_request = Label.Lbl_Friendly_reminder_Rental_unit_request;
         Id eTempFriendly_reminder_request_Exchange = Label.Lbl_Friendly_reminder_request_Exchange;
         Id eTempPast_Due_Exchange = Label.Lbl_Past_Due_Exchange;
         Id eTempRental_unit_request = Label.Lbl_Rental_unit_request;
         
        
         //Get user in SPEX_Core_Recovery_Team queue
         Group spexCoreTeam = [select (select userOrGroupId from groupMembers) from group where DeveloperName='SPEX_Core_Recovery_Team'];
         for(GroupMember gm: spexCoreTeam.GroupMembers)
             listToAddresses.add(gm.userOrGroupid);
 
         
         addTomails(listReqExcahngeReminderCases,eTempFriendly_reminder_request_Exchange);
         addTomails(listFriendlyRentalReqReminderCases,eTempFriendly_reminder_Rental_unit_request );
         addTomails(listRentalUnitReqReminderCases,eTempRental_unit_request );
         addTomails(listPastDueExcahngeReminderCases,eTempPast_Due_Exchange );
         
         
         
         Messaging.sendEmail(mails);
               
    }
    
    global void addTomails(List<case> caseForReminders, Id emailTemplate){
        for(Case spexCs: caseForReminders){
             if(((string)spexcs.OwnerId).contains('00G'))
             {  
                 for(Id uid : listToAddresses){
                        Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                        mail.setTemplateID(emailTemplate);              
                        mail.setWhatId(spexcs.Id);
                        mail.setTargetObjectId(uid);
                        mail.setSaveAsActivity(false);
                        mails.add(mail);
                        system.debug('spexCs---->ID' +  spexCs.id);
                 system.debug('mails-->' + mails);       
                 }
             }else{
                 Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                 mail.setTemplateID(emailTemplate);//Need to chnage the teplate based on the user inputs              
                 mail.setWhatId(spexCs.Id);
                 mail.setTargetObjectId(spexCs.ownerid);
                 mail.setSaveAsActivity(false);
                 mails.add(mail);
                 system.debug('2mails-->' + mails);   
             }
         }

    
    }
    global void finish(Database.BatchableContext BC){        
        
    } 
    
    global void execute(SchedulableContext sc){
        sendSPEXCoreRecoveryRemindersBatch spexBatch = new sendSPEXCoreRecoveryRemindersBatch();
        database.executeBatch(spexBatch,200);
    }
}