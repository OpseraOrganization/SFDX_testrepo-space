global class Update7DaysCaseAgedate implements Database.batchable<sObject>,Schedulable{
    global string query;
    Date dt = date.valueOf(label.Created_Date_31Aug2015);
    global Update7DaysCaseAgedate(){
        query = 'select id,Case_object__c,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Case_object__r.CreatedDate from Case_Extension__c where Case_object__r.IsClosed=False and (Case_object__r.Case_Record_Type__c= \'Repair & Overhaul\' or Case_object__r.Case_Record_Type__c= \'Orders\' or Case_object__r.Case_Record_Type__c= \'Quotes\' or Case_object__r.Case_Record_Type__c= \'Internal Escalations\' or Case_object__r.Case_Record_Type__c= \'OEM Quotes Orders\') and Case_object__r.Createddate>:dt and Age_in_Minutes__c=7';
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Case_Extension__c> casextlist = new List<Case_Extension__c>();
        List<Case_Extension__c> casextlistupd = new List<Case_Extension__c>();
        set<id> extid = new set<id>();
        set<Id> Caseslist = new set<Id>();
        Integer emlist;
        for(sObject caseRec : scope){   
            system.debug('-------->'+caseRec);
            Case_Extension__c CasExRec = (Case_Extension__c)caseRec;
            Caseslist.add(CasExRec.Case_object__c);
            extid.add(CasExRec.id);
        }
        system.debug('11111111111111>Cases '+Caseslist);
        system.debug('22222222222222> ext '+extid);
        if(Caseslist.size()>0){ 
            emlist = [select count() from EmailMessage where parentid IN:Caseslist];
            if(emlist>0){
                casextlist = [select id,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c from Case_Extension__c where id IN:extid];
                if(casextlist.size()>0){
                    for(Case_Extension__c ce:casextlist){
                        ce.X7_Days_Case_Age_date__c = system.now();
                        ce.X7_Days_Case_Age__c = TRUE;
                        casextlistupd.add(ce);
                    }
                }
                if(casextlistupd.size()>0)
                    update casextlistupd;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){} 
    
    global void execute(SchedulableContext sc){
        Update7DaysCaseAgedate ordersBatch = new Update7DaysCaseAgedate();
        database.executeBatch(ordersBatch,20);
    }
}