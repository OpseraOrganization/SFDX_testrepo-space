global class BatchConUserEmailUpdate implements Database.Batchable<sObject>,schedulable  {
   
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query;
			query = 'SELECT Id,Name, Profile.Name, email, CH_OldEmail__c FROM User Where isActive = true AND LastModifiedDate >= LAST_N_DAYS:1 AND CH_CheckEmailsAreNotEquals__c = true AND CH_Case_Handling_Internal_Contact__c = true AND Active_Nokia_Employee__c = true';
		if(Test.isRunningTest()){
			query = 'SELECT Id,Name, Profile.Name, email, CH_OldEmail__c FROM User Where isActive = true AND LastModifiedDate >= LAST_N_DAYS:1 AND CH_CheckEmailsAreNotEquals__c = true AND CH_Case_Handling_Internal_Contact__c = true AND Active_Nokia_Employee__c = true LIMIT 1';
		}
		return Database.getQueryLocator(query);
	}
   
	global void execute(Database.BatchableContext BC, List<User> UserList) {
	  
	  Map<String,String> userEmailMap = new Map<String,String>();
	  
		 List<User> userUpdateList = new List<User>();
		 for(User usr : UserList){
		  userEmailMap.put(usr.CH_OldEmail__c, usr.Email); 
			usr.CH_OldEmail__c = usr.Email;
			userUpdateList.add(usr);
		 }
		 
	   
		 List<Contact> updateConList = new List<Contact>();
			for(Contact con :  [Select id, name , email FROM contact where email IN : userEmailMap.keyset()]){
				String userNewEmail = userEmailMap.get(con.Email);
				
				 con.Email = userNewEmail ;
					 updateConList.add(con);
				 
		   }
		  
		
		if(!updateConList.isEmpty()){
			update updateConList;
			  system.debug('updateConList---'+updateConList);
		}
		if(!userUpdateList.isEmpty()){
			update userUpdateList ;
			 system.debug('userUpdateList ---'+userUpdateList );
		}
	}   
	
	global void finish(Database.BatchableContext BC) {
	}
	
	 global void execute(SchedulableContext sc){   
		 batchConUserEmailUpdate  batchConUsrUp= new batchConUserEmailUpdate ();
		 Database.executebatch(batchConUsrUp ,200);	   
	} 
}