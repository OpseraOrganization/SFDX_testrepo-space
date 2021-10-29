public class BatchInsert implements Database.Batchable<sObject>{
  SObject[] records;
  public BatchInsert(SObject[] source) {
    records = source;
  }
  public SObject[] start(Database.BatchableContext context) {
    return records;
  }
  public void execute(Database.BatchableContext context, SObject[] scope) {
    set<id> whatIds = new set<id>();
    map<string,SObject> objectMap = new map<string,SObject>();
    for (SObject c : scope) {
        Task ct = (Task)c;
        whatIds.add(ct.whatId);
        objectMap.put(ct.whatId+ct.Task_Subject__c,c);
    }
    Set<string> whatIdWithSubject = new Set<String>();
    for(Task t:[select id,Task_Subject__c,whatId from Task where RecordTypeId=:Label.MSP_Engine_APU and Task_Subject__c<>null and whatId in :whatIds]){
        objectMap.remove(t.whatId+t.Task_Subject__c);
    }
    
    Database.insert(objectMap.values(), false);
  }
  public void finish(Database.BatchableContext context) {
  }
}