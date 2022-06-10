trigger SalesRoleAuditTrigger on Sales_Role_Audit__c (After Insert) {
	if(!Test.isRunningTest())
	{
		System.enqueueJob(new CMDPack4Callout());
	}
}