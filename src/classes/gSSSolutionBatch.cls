/**********************************Change Log******************************** 
SR : 404603
Object - Solution
Description:
Used to implement the update the status of the solution from 'Approved' 
to 'Audit' when the solution remains in the Approved status longer than 
Audit Frequency value and send emails to specific users. 

****************************************************************************/
global class gSSSolutionBatch implements Database.batchable<sObject>, Schedulable{
    global string query;
    //Constants for Audit frequecy values
    static final Integer WEEKLY = 7;
    static final Integer BIWEEKLY= 14;
    static final Integer MONTHLY = 30;
    static final Integer QUARTERLY = 90;
    static final Integer SEMIANNUAL = 180;
    static final Integer ANNUAL = 365;
    static final Integer BIENNAL = 730;
    static final Integer EIGHTEENMONTHS = 540;
    
    global gSSSolutionBatch(){
        //Query to fetch Solutions of 'GSS Solution' record type
        query = 'select id, SolutionNumber, Record_Type_Name__c, Audit_Frequency__c, Content_Review_Approval_Date__c from Solution where Record_Type_Name__c = \'GSS Solution\' and status = \'Approved\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Solution> listSolutions = new List<Solution>();
        //Go through the solutions to update the status from 'Approve' to 'Audit'
        for(sObject sol:scope){//Start of Solution loop
            Solution checkSolution =(Solution) sol;
            if(checkSolution.Content_Review_Approval_Date__c != null){
            if((checkSolution.Audit_Frequency__c == 'Weekly' && checkSolution.Content_Review_Approval_Date__c + WEEKLY == System.Today())
            || (checkSolution.Audit_Frequency__c == 'Bi-weekly' && checkSolution.Content_Review_Approval_Date__c + BIWEEKLY == System.Today())
            || (checkSolution.Audit_Frequency__c == 'Monthly' && checkSolution.Content_Review_Approval_Date__c + MONTHLY == System.Today() )
            || (checkSolution.Audit_Frequency__c == 'Quarterly' && checkSolution.Content_Review_Approval_Date__c + QUARTERLY == System.Today() )
            || (checkSolution.Audit_Frequency__c == 'Semi-Annual' && checkSolution.Content_Review_Approval_Date__c + SEMIANNUAL == System.Today())
            || (checkSolution.Audit_Frequency__c == 'Annually' && checkSolution.Content_Review_Approval_Date__c + ANNUAL == System.Today() )
            || (checkSolution.Audit_Frequency__c == 'Biennal' && checkSolution.Content_Review_Approval_Date__c + BIENNAL == System.Today() )
            || (checkSolution.Audit_Frequency__c == '18 Months' && checkSolution.Content_Review_Approval_Date__c + EIGHTEENMONTHS == System.Today())
            ){
                checkSolution.status = 'Audit';
                listSolutions.add(checkSolution);
            }
            }
            
        }//End of Solution loop
        
        if(listSolutions.size()>0){//Start of If
            try{//Start of try
                update listSolutions;
                
                list<id> listToAddresses = new list<id>();
                Group gssSolutionApprovers = [select (select userOrGroupId from groupMembers) from group where DeveloperName='GSS_Solution_Approvers' ];
                for(GroupMember gm: gssSolutionApprovers.GroupMembers)
                    listToAddresses.add(gm.userOrGroupid);
                
                EmailTemplate eTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'GSS_Solution_Notification' limit 1];
                List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>(); 
                for(Solution sol:listSolutions){
                    for(Id uid : listToAddresses){
                        Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                        mail.setTemplateID(eTemplate.Id);              
                        mail.setWhatId(sol.Id);
                        mail.setTargetObjectId(uid);
                        mail.setSaveAsActivity(false);
                        mails.add(mail);
                        
                    }
                }
                Messaging.sendEmail(mails);
            }//End of try
            catch(Exception ex){}
             
        }//End of If
    }
    
    global void finish(Database.BatchableContext BC){        
    
    } 
    
    global void execute(SchedulableContext sc){
        gSSSolutionBatch gssBatch = new gSSSolutionBatch();
        database.executeBatch(gssBatch,200);
    }
    
    //Method uses two parameters whatid and targetobjectid to send email
    /*global void sendMailToRecipients(Id solutionId, Id usrId){        
        Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
            string templateId = '00Xe0000000QQTu';
            mail.setTemplateID(templateId);              
            mail.setWhatId(solutionId);
            mail.setTargetObjectId(usrId);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEMailMessage[] { mail });
           
    } */   
}