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
		ContractLineItemTriggerHelper.createBeforeInsertContractLineItem(newContractLineItemList);
	}
	protected override void afterInsert() {
		Map<Id, ContractLineItem> newCLIMap = new Map<Id, ContractLineItem>();
		if(newContractLineItemList?.size() > 0){
			for(ContractLineItem cli : CH_ContractLineItemTriggerHelper.getListCHAndSupportServiceContracts(newContractLineItemMap.values(),'Support Portal')){
				newCLIMap.put(cli.Id, cli);
			}
			if(newCLIMap?.size() > 0){
				Id jobId =System.enqueueJob(new CH_ContractLineItemQueueableProcess(new Map<Id,ContractLineItem>(), newCLIMap, true,false));
			}
		}
	}
}