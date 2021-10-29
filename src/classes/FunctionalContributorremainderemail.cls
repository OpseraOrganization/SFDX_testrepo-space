global class FunctionalContributorremainderemail implements Database.Batchable<sObject>, Schedulable
{  
    Date today1 = date.valueof(system.today()); 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {        
        return Database.getQueryLocator([select id,X2_Days_from_requested_date__c,Comments__c,X3_Days_Reminder__c,X5_Days_Reminder__c,Email_Update_Status__c,Non_SFDC_Recipient__c,Opportunity_Proposal__c,Request_Date__c,SFDC_Recipients__c,Reminder_Email_Date__c from Functional_Contributor_Update__c where Email_Update_Status__c = 'In progress' and X2_Days_from_requested_date__c < today limit 10000]);       
    }
           
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {           
            List<Functional_Contributor_Update__c> functional = new List<Functional_Contributor_Update__c>();
            List<Functional_Contributor_Update__c> functional1 = new List<Functional_Contributor_Update__c>();
            for(sObject sol:scope)
            {
                Functional_Contributor_Update__c checkremainder =(Functional_Contributor_Update__c) sol;
                Date newdate=checkremainder.Request_Date__c+3;
                Date newdate1=checkremainder.Request_Date__c+5;
                if(newdate <= today1 && checkremainder.Reminder_Email_Date__c == null && checkremainder.X3_Days_Reminder__c== false)
                {                    
                    system.debug('venkattttt---->'+checkremainder.id);
                    checkremainder.Reminder_Email_Date__c=today1;
                    checkremainder.X3_Days_Reminder__c=true;
                    functional.add(checkremainder);                     
                }
                if(newdate1 <= today1 && checkremainder.Reminder_Email_Date__c != null && checkremainder.X5_Days_Reminder__c == false)
                {  
                    system.debug('venkattttt555---->'+checkremainder.id);
                    checkremainder.X5_Days_Reminder__c=true;
                    functional1.add(checkremainder);                    
                }                               
            } 
            system.debug('checking listuser size'+functional.size());
            system.debug('checking listuser size'+functional1.size());          
            if(functional.size()>0)
            {
                try
                {   
                    system.debug('venkkkkkkkk'+functional);
                    update functional;                                                                     
                }
                catch(Exception ex){}                
            }
             if(functional1.size()>0)
            {
                try
                {                                   
                    system.debug('venkkkkkkkatttttt'+functional1);
                    update functional1;                                                            
                }
                catch(Exception ex){}                
            }
    }      
    global void finish(Database.BatchableContext BC){    
    }
     global void execute(SchedulableContext sc){
        FunctionalContributorremainderemail functionalbatch = new FunctionalContributorremainderemail();
        database.executeBatch(functionalbatch,600);
    }
}