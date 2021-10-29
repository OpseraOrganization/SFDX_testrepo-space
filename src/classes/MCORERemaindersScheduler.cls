global class MCORERemaindersScheduler implements Schedulable{
   global void execute(SchedulableContext SC) {
      MCORESendRemainderBatch M = new MCORESendRemainderBatch(); 
      Database.executeBatch(m,10);    
   }
}