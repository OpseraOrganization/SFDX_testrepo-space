global  class FileParse_DeleteResult implements Database.Batchable<sObject>{
 
	global final string strQuery;
	
	global FileParse_DeleteResult(string query){
		
		
		this.strQuery=query;
	
	}
	
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		system.debug('strQuery'+strQuery);
		return  Database.getQueryLocator(strQuery);
	}
	
	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		delete scope;
	  }
	public void finish(Database.BatchableContext info) {
		
		   
		
	}
	
	
}