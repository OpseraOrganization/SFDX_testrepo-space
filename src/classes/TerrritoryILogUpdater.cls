public class TerrritoryILogUpdater implements Queueable {
	 
	 public List<UserTerritory2Association> insertLockedRecords = new List<UserTerritory2Association>();
	 public List<Id> deleteLockedRecords = new List<Id>();
	 public Id failureId;
	 
	 public void execute(QueueableContext context) {
		Boolean isSuccess = true;
		if(!deleteLockedRecords.isEmpty()){	
			Database.DeleteResult[] deleteResults = Database.delete(deleteLockedRecords , false);
			for (Database.DeleteResult dr : deleteResults){
				if (!dr.isSuccess()){
					isSuccess = false;
				}
			}
		}
		
		if(!insertLockedRecords.isEmpty()){
			Database.SaveResult[] insertResults = Database.insert(insertLockedRecords, false);
			for (Database.SaveResult dr : insertResults){
				if (!dr.isSuccess()){
					isSuccess = false;
				}
			}
		}
		
		if(isSuccess){
			List<Interface_Log__c>  iLogRecList = [select Id,Comment__c,Status__c from Interface_Log__c where Id =: failureId];
			if(!iLogRecList.isEmpty()){
			   Interface_Log__c iLogRec = iLogRecList.get(0);
			   iLogRec.Comment__c = 'Committed @'+system.now()+' '+deleteLockedRecords+' '+insertLockedRecords+'	 '+iLogRec.Comment__c;
			   iLogRec.Status__c = GlobalConstants.SUCCESS; 
			   update iLogRec;
			}
		}
	 }
}