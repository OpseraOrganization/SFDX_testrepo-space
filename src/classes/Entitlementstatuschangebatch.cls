global class Entitlementstatuschangebatch implements Database.batchable<sObject>, Schedulable{
    global string query;
  
  global Entitlementstatuschangebatch(){
     
      query = 'SELECT End_Date__c,Id,Name,Status__c FROM Entitlement__c WHERE End_Date__c < today AND Status__c=\'Active\'';
  }
    
  global Database.QueryLocator start(Database.BatchableContext BC){
     
       return Database.getQueryLocator(query);
  }
    
  global void execute(Database.BatchableContext BC, List<Entitlement__c> scope){
     List<Entitlement__c> lstentitlement = new List<Entitlement__c>();
     
      for(Entitlement__c ent:scope){
         ent.Status__c = 'Inactive';
         lstentitlement.add(ent);  
      }
        
      if(lstentitlement.size()>0){
         try{
             update lstentitlement;
            }
            catch(Exception ex){}
      }
  }
    
  global void finish(Database.BatchableContext BC){        
    
  } 
    
  global void execute(SchedulableContext sc){
        Entitlementstatuschangebatch EntitlementBatch = new Entitlementstatuschangebatch();
        database.executeBatch(EntitlementBatch,200);
  }
     
}