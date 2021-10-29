global class CreateTaskForFAAMSPEngine implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
    String HONEYWELL = '%Honeywell%';
    Date futureDate = system.today().addDays(180);
    String query = 'select id,Name,Account__c,Platform_APU_Maker__c,Platform_Engine_Maker__c,APU_Engine_OEM_Warranty_Period__c from Fleet_Asset_Detail__c where (Platform_APU_Maker__c like :HONEYWELL or Platform_Engine_Maker__c like :HONEYWELL) and APU_Engine_OEM_Warranty_Period__c = :futureDate';
        System.debug('query is---------->'+query);
        return Database.getQueryLocator(query);
   }
    
global void execute(Database.BatchableContext bc, List<Fleet_Asset_Detail__c > faaRecords){
    system.debug('Inside execute method');
        try{
        system.debug('Inside execute method');
        String blank = '';
        List<Task> taskList = new List<Task>();
set<id> faaIds = new set<id>();
for(Fleet_Asset_Detail__c faaRec:faaRecords){
    faaIds.add(faaRec.id);
}
system.debug('after for loop:'+faaIds);
Set<Id> existingAPUIds = new Set<id>();
Set<Id> existingEngineIds = new Set<id>();
for(Task taskRec:[ select id,whatId from Task where whatId in : faaIds and Subject like 'OEM Warranty Expired - MSP%']){
    if(taskRec.Subject == 'OEM Warranty Expired - MSP APU'){
        existingAPUIds.add(taskRec.whatId);
    }
    if(taskRec.Subject == 'OEM Warranty Expired - MSP ENG'){
        existingEngineIds.add(taskRec.whatId);
    }
}


            for(Fleet_Asset_Detail__c faaRec:faaRecords){
              if(!existingAPUIds.contains(faaRec.id) && faaRec.Platform_APU_Maker__c != null && 'Honeywell'.contains(faaRec.Platform_APU_Maker__c)){
                        Task t = new Task(); 
                        t.OwnerId = Label.Task_Owner;
                        t.Subject = 'OEM Warranty Expired - MSP APU';
                        t.Priority = 'Normal';
                        t.Status = 'Not Started';
                        t.Description = 'OEM Warranty Expired - MSP APU';
                        t.whatId = faaRec.Id;
                        //t.ActivityDate = Date.today();
                        t.Accounts_Name__c = faaRec.Account__c;
                        t.RecordTypeId = Label.MSP_Engine_APU;
                        taskList.add(t);  
               }
               if(!existingEngineIds.contains(faaRec.id) && faaRec.Platform_Engine_Maker__c != null && 'Honeywell'.contains(faaRec.Platform_Engine_Maker__c)){
                        Task t = new Task(); 
                        t.OwnerId = Label.Task_Owner;
                        t.Subject = 'OEM Warranty Expired - MSP ENG';
                        t.Priority = 'Normal';
                        t.Status = 'Not Started';
                        t.Description = 'OEM Warranty Expired - MSP ENG';
                        t.whatId = faaRec.Id;
                        //t.ActivityDate = Date.today();
                        t.Accounts_Name__c = faaRec.Account__c;
                        t.RecordTypeId = Label.MSP_Engine_APU;
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