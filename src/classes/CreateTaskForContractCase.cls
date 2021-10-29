global class CreateTaskForContractCase implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
    String OnHold = 'On Hold';
    String ReinstatementOpp = 'Reinstatement Opp';
    String HAPPMPPContracts = 'HAPP MPP Contracts';
    String query = 'SELECT  Id,Status,Sub_Status__c,Due_Date__c FROM Case where RecordType.Name=:HAPPMPPContracts'+' and Sub_Status__c =:ReinstatementOpp'+' and Status = :OnHold';
        System.debug('query is---------->'+query);
        return Database.getQueryLocator(query);
   }
    
    global void execute(Database.BatchableContext bc, List<Case> caseRecords){
    system.debug('Inside execute method');
        try{
        system.debug('Inside execute method');
        String blank = '';
        List<Task> taskList = new List<Task>();
set<id> caseIds = new set<id>();
for(Case caseRec:caseRecords){
    caseIds.add(caseRec.id);
}
system.debug('after for loop:'+caseIds);
Set<Id> existingIds = new Set<id>();
for(Task taskRec:[ select id,whatId from Task where whatId in : caseIds and Subject='Contract Expired']){
    existingIds.add(taskRec.whatId);
}
system.debug('existingIds values:'+existingIds);
            for(Case caseRec:caseRecords){
          If(!existingIds.contains(caseRec.id)){
                    Task t = new Task(); 
                    t.OwnerId = '0051300000CUHXF';
                    t.Subject = 'Contract Expired';
                    t.Priority = 'Normal';
                    t.Status = 'Not Started';
                    t.Description = 'Contract Expired';
                    t.whatId = caseRec.Id;
                    t.ActivityDate = caseRec.Due_Date__c;
                    t.RecordTypeId = Label.MSPAv_Mech_Task;
                    taskList.add(t);  
           }
}
            insert taskList;
             System.debug('task is---------->'+taskList );
         }catch(Exception e){
            System.debug('Error1 : '+e.getMessage()); 
            System.debug('Error line1 : '+e.getLineNumber());
        } 
     }
      
    global void finish(Database.BatchableContext BC){
      // Nothing here.
    }   
}