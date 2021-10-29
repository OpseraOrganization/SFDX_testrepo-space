//BatchhJob class

global class GenerateMaintEvent_Platform_B implements Database.Batchable<sObject>{
    global String query;

    //Start Method of Batch Apex   
    global database.querylocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
//Execute method
    global void execute(Database.BatchableContext BC, List<Sobject> scope){
         
           List<Platform__c> plat =(List<Platform__c>)scope; 
        set<Id> platId = new set<Id>();
        for (Platform__c newplat: plat )
         platId.add(newplat.Id);
         
           CalculateAircraftMaintenanceEvent.gen_B_EventData(platId);
                
          
   }
    
       
     global void finish(Database.BatchableContext BC){
    }
}