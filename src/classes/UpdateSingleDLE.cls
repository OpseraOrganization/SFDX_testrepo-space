global class UpdateSingleDLE implements Database.Batchable<sObject>{
  
  global String Query;
  global List<Account> updateList= new List<Account>();
  
  global UpdateSingleDLE(List<Account> accList){
	updateList = accList;
  } 
  global Database.QueryLocator start(Database.BatchableContext BC){
	return Database.getQueryLocator(query);
  }
  
  global void execute(Database.BatchableContext BC, List<sObject> scope){
	List<Account> accList = new List<Account>();
	Integer counter =0;
	for(Sobject scp : scope){
	  Account acc= (Account)scp;
	  acc.Default_Legal_Entity__c = true;
	  acclist.add(acc);
	} 
	Database.update(acclist,false);
	
  }
  
  global void finish(Database.BatchableContext BC){
	Set<String> allCustomers = new  Set<String>();
   /* for(Account acc1: [select id,parentId from account 
			   where recordtype.name = 'Legal Entity' 
			   and Default_Legal_Entity__c = true ]){
				 allCustomers.add(acc1.parentId);
			   }
	*/
	UpdatewithoutDLEBatch batch = new UpdatewithoutDLEBatch(allCustomers);
	batch.Query = 'select Id,name,Default_Legal_Entity__c,parentId,Active__c from account '+
	  'where recordtype.name = \'Legal Entity\' and Default_Legal_Entity__c = false '+
	  'and Active__c = true and parent.Id!=null';
	
	Id batchInstanceId = Database.executeBatch(batch, 200);
  }
}