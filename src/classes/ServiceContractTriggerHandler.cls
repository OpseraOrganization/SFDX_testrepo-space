/**
About
-----
Description: This Class is used as handler for ServiceContractTrigger Trigger .

Created for: Nokia Customer Portal
Created: 04 19 2018

Update History
--------------
Created: 04 19 2018 – aboukrim@salesforce.com
-------------
**/

public class ServiceContractTriggerHandler extends TriggerHandler {
	
	private List<ServiceContract> newServiceContractList;
	private List<ServiceContract> oldServiceContractList;
	private Map<Id, ServiceContract> newServiceContractMap;
	private Map<Id, ServiceContract> oldServiceContractMap;
	
	public ServiceContractTriggerHandler() {
		newServiceContractList = (List<ServiceContract>) Trigger.new;
		oldServiceContractList = (List<ServiceContract>) Trigger.old;
		newServiceContractMap = (Map<Id, ServiceContract>) Trigger.newMap;
		oldServiceContractMap = (Map<Id, ServiceContract>) Trigger.oldMap;
	}
	
	protected override void afterInsert() {
		ServiceContractTriggerHelper serviceContractHelper = new ServiceContractTriggerHelper();
		serviceContractHelper.getAccountFromParent(newServiceContractList, true);
		ServiceContractTriggerHelper.createServiceContractShare(newServiceContractList);
	}
	
	protected override void beforeUpdate() {
		//ServiceContractTriggerHelper.GetAccountFromParent(newServiceContractList, false);
		ServiceContractTriggerHelper serviceContractHelper = new ServiceContractTriggerHelper();
		serviceContractHelper.getAccountFromParent(newServiceContractList, false);
	}
	
	protected override void afterUpdate() {
		ServiceContractTriggerHelper.updateServiceContractShare(newServiceContractList, oldServiceContractMap);
		ServiceContractTriggerHelper.updateServiceContractOwnerChanged(newServiceContractList, oldServiceContractMap);
		ServiceContractTriggerHelper.updateChildSuspensionOwnerWithServConOwner(newServiceContractList, oldServiceContractMap);
	}
}