public  without sharing  class CH_UserTriggerQueueableProcess  implements Queueable { 
	
	List<user> userList = new List<user>();
	Set<Id> userId = new Set<Id>();
	Map<Id,user> oldUserItemMap = new Map<Id,user>();
	Map<Id,user> newUserItemMap = new Map<Id,user>();
	boolean afterInsertCheck;
	boolean afterUpdateCheck;
	public CH_UserTriggerQueueableProcess( Map<Id,user> oldUserMap, Map<Id,user> newUserMap, boolean afterInsertCheck, boolean afterUpdateCheck){
		this.oldUserItemMap = oldUserMap;
		this.newUserItemMap = newUserMap;
		this.afterInsertCheck = afterInsertCheck;
		this.afterUpdateCheck = afterUpdateCheck; 
		userList =[select id, isActive, ContactId from User where id in :newUserMap.Keyset()];
	}
	public void execute(QueueableContext context){
		 CH_UserTriggerHelper.shareCase(oldUserItemMap, userList);
	}

}