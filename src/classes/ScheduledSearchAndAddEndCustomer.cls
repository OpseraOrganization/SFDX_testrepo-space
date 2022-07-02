global class ScheduledSearchAndAddEndCustomer implements Schedulable {
   global void execute(SchedulableContext SC) {
	   Database.executeBatch(new SearchAndAddEndCustomer(), 2000); 
   }
}