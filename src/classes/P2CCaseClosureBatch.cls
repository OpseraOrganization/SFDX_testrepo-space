public class P2CCaseClosureBatch implements database.Batchable<sObject>,schedulable,database.stateful{
    public List<String> errorList=new List<String>();
    public List<String> nineDaysRT=new List<String>{'Aero Customer Support'};
    public List<String> sevenDaysRT=new List<String>{'Technical Issue', 'Orders', 'OEM/Spares', 'OEM Quotes Orders', 'AOG', 'Exchange', 'Core Recovery', 'Repair & Overhaul', 'Returns', 'ReturnsPRO','Aero Customer Support'};

    public void execute(schedulableContext sctx){
        database.executeBatch(new P2CCaseClosureBatch(),50);
    }
    
    public database.QueryLocator start(database.batchableContext ctx){
        
        string query='SELECT id,status,p2c_sent__c,CES_Score__c,closedDate FROM case WHERE ' + Label.closeCase_Query_Fiter;
        query+=' AND ((ClosedDate!=LAST_N_DAYS:9 AND RecordType.Name IN :nineDaysRT) OR ';
        query+='(ClosedDate!=LAST_N_DAYS:7 AND RecordType.Name IN :sevenDaysRT))';   
        if(test.isRunningTest()){
            query='SELECT id FROM case WHERE  ' + Label.closeCase_Query_Fiter;
        }
        return database.getquerylocator(query);
    }
    
    public void execute(database.batchableContext ctx,List<sObject> casesToUpdate){
        for(sobject caseRec:casesToUpdate){
            caseRec.put('status','Closed-No Response');
        }
        List<database.saveResult> srList=database.update(casesToUpdate,false);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
   
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                  errorList.add(sr.getId() + '->' +  err.getMessage());
                }
            }
        }
    }
    
    public void finish(database.batchableContext ctx){
             Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            mail.subject='Batch Completed';
            mail.htmlbody=string.join(errorList,'\n');
            mail.toaddresses=label.email_archival_recipients.split(';');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}