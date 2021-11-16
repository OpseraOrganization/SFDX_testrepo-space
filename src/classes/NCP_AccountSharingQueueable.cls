public with sharing class NCP_AccountSharingQueueable implements Queueable {

	public Map<Id, AccountContactRelation> myAcrMap = new Map<Id, AccountContactRelation>();
	
	public NCP_AccountSharingQueueable(Map<Id, AccountContactRelation>  acrMap){
		this.myAcrMap = acrMap;
	}
	public void execute(QueueableContext context) {
		AccountContactRelationTriggerHelper.createAccountContactRelationShare(myAcrMap);
	}
}