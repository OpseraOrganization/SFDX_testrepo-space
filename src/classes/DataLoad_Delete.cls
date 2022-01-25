global class DataLoad_Delete implements Schedulable {
	
	// Execute at regular intervals
	global void execute(SchedulableContext ctx){
		
		string strQuery = 'select id from Parse_Result__c'; 
		
		 Database.executeBatch(new FileParse_DeleteResult(strQuery), 200);
	}
}