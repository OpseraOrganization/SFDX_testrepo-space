/**
 * Created by bkandov on 01/07/2018.
 */

public with sharing class ServiceContractTeamTriggerHandler extends TriggerHandler {

	private List<NCP_Service_Contract_Team__c> newServiceContractTeamList;
	private List<NCP_Service_Contract_Team__c> oldServiceContractTeamList;
	private Map<Id, NCP_Service_Contract_Team__c> newServiceContractTeamMap;
	private Map<Id, NCP_Service_Contract_Team__c> oldServiceContractTeamMap;

	public ServiceContractTeamTriggerHandler() {
		newServiceContractTeamList = (List<NCP_Service_Contract_Team__c>) Trigger.new;
		oldServiceContractTeamList = (List<NCP_Service_Contract_Team__c>) Trigger.old;
		newServiceContractTeamMap = (Map<Id, NCP_Service_Contract_Team__c>) Trigger.newMap; 
		oldServiceContractTeamMap = (Map<Id, NCP_Service_Contract_Team__c>) Trigger.oldMap;
	}

	protected override void afterInsert() {
		ServiceContractTeamTriggerHelper.createServiceContractTeamShare(newServiceContractTeamList);
	}

	protected override void afterUpdate() {
		ServiceContractTeamTriggerHelper.updateServiceContractTeamShare(newServiceContractTeamList, oldServiceContractTeamMap);
	}

	protected override void afterDelete() {
		ServiceContractTeamTriggerHelper.deleteServiceContractTeamShare(oldServiceContractTeamList);
	}

}