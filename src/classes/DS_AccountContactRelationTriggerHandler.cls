/*******************************
Class name :DS_AccountContactRelationTriggerHandler	 
Created by: Accenture
Description: This handler is written for the Trigger on Account Contact Relationship object
Team: Digital Sales
*******************************/
public without sharing class DS_AccountContactRelationTriggerHandler extends TriggerHandler {
	private List<AccountContactRelation> oldList;
	private List<AccountContactRelation> newList;
	private Map<Id, AccountContactRelation> oldMap;
	private Map<Id, AccountContactRelation> newMap;
	 
	public DS_AccountContactRelationTriggerHandler() {
		this.oldList = (List<AccountContactRelation>) Trigger.Old;
		this.newList = (List<AccountContactRelation>) Trigger.New;
		this.oldMap  = (Map<Id, AccountContactRelation>) Trigger.OldMap;
		this.newMap  = (Map<Id, AccountContactRelation>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the AccountContactRelation beforeInsert event on AccountContactRelation.
	*/
	public override void beforeInsert(){
		
	}
	
	/*
	* @description : afterInsert handle the AccountContactRelation afterInsert event on AccountContactRelation.
	*/
	public override void afterInsert(){
		try{
		
			Set<Id> accountIdSet  = new Set<Id>();
			for(AccountContactRelation obj : newList) {
				accountIdSet.add(obj.AccountId);
			}
			System.debug('**********accountIdSet***************'+accountIdSet);
			Map<ID, Account> accMap  = new Map<ID, Account>([Select Id,RecordTypeId from Account where Id IN : accountIdSet and RecordType.Name =:CSWXGlobalConstant.recordTypeLogisticAccount LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			System.debug('*******accMap************'+accMap);
			LisT<AccountContactRelation> filterOnlyLogisitcAccountList = new List<AccountContactRelation>();
			System.debug('***************newMap*****************'+newMap.keySet());
			for(Id Key : newMap.keySet()) {
				if(accMap.containsKey(newMap.get(Key).AccountId)) {
					filterOnlyLogisitcAccountList.add(newMap.get(Key));
				}
			}
			if(!filterOnlyLogisitcAccountList.isEmpty())
				DS_AccountContactRelationTriggerHelper.checkRecordExist(newList);
			   
	}catch(Exception ex){ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_AccountContactRelationTriggerHandlerclass,CSWXGlobalConstant.checkRecordExistmethod);}
	}
	
	/*
	* @description : beforeUpdate handle the AccountContactRelation beforeUpdate event on AccountContactRelation.
	*/
	public override void beforeUpdate(){
		
	}
	
	/*
	* @description : afterUpdate handle the AccountContactRelation afterUpdate event on AccountContactRelation.
	*/
	public override void afterUpdate(){
		
	}
	
	/*
	* @description : beforeDelete handle the AccountContactRelation beforeDelete event on AccountContactRelation.
	*/
	public override void beforeDelete(){
		
	}
	
	/*
	* @description : afterDelete handle the AccountContactRelation afterDelete event on AccountContactRelation.
	*/
	public override void afterDelete(){
		
	}
}