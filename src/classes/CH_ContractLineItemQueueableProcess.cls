public without sharing class CH_ContractLineItemQueueableProcess implements Queueable{
	List<ContractLineItem> contractLineItemList = new List<ContractLineItem>();
	Set<Id> contractLineItemId = new Set<Id>();
	Map<Id,ContractLineItem> oldContractLineItemMap = new Map<Id,ContractLineItem>();
	Map<Id,ContractLineItem> newContractLineItemMap = new Map<Id,ContractLineItem>();
	boolean afterInsertCheck;
	boolean afterUpdateCheck;
	public CH_ContractLineItemQueueableProcess( Map<Id,ContractLineItem> oldCLIMap, Map<Id,ContractLineItem> newCLIMap, boolean afterInsertCheck, boolean afterUpdateCheck){
		this.oldContractLineItemMap = oldCLIMap;
		this.newContractLineItemMap = newCLIMap;
		this.afterInsertCheck = afterInsertCheck;
		this.afterUpdateCheck = afterUpdateCheck; 
		contractLineItemList = [select id, CH_CDB_EntitlementId__c, CH_PreviousCDBEntitlementId__c from ContractLineItem  where id in : newContractLineItemMap.keySet()];
	}
	public void execute(QueueableContext context){
		CH_ContractLineItemTriggerHelper.linkToVendorContract(oldContractLineItemMap, contractLineItemList);
	}
	
}