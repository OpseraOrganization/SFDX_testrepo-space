/**
 * Created by tweinberger on 06/09/2018.
 */
public with sharing class ContractLineItemTriggerHandler extends TriggerHandler {
	
		private List<ContractLineItem> newContractLineItemList;
	private List<ContractLineItem> oldContractLineItemList;
	private Map<Id, ContractLineItem> newContractLineItemMap;
	private Map<Id, ContractLineItem> oldContractLineItemMap;

	public ContractLineItemTriggerHandler() {
		newContractLineItemList = CH_ContractLineItemTriggerHelper.getListCHAndSupportServiceContracts((List<ContractLineItem>) Trigger.new,'Support Portal');
		oldContractLineItemList = (List<ContractLineItem>) Trigger.old;
		newContractLineItemMap = (Map<Id, ContractLineItem>) Trigger.newMap;
		oldContractLineItemMap = (Map<Id, ContractLineItem>) Trigger.oldMap; 
	}

	protected override void beforeInsert() {
		if(newContractLineItemList!=null && newContractLineItemList.size()>0){ //added null check
		   ContractLineItemTriggerHelper.createBeforeInsertContractLineItem(newContractLineItemList);
		   
		}
	}
	
}