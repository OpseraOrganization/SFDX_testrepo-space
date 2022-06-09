trigger CPO_Trigger on Apttus_Config2__CustomerPurchaseOrder__c (Before insert, Before update,
																 After update, After insert) 
{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
	{
		if(Trigger.isBefore){
			if(Trigger.isUpdate){
				if (!Test.isRunningTest()) {
					//DSI-2146
					//CPOTriggerHandler.checkEnrichment(Trigger.New, Trigger.oldMap);
					//CPOTriggerHandler.checkMandatoryFields(Trigger.new, Trigger.oldMap);
				}
				CPOTriggerHandler.createEntitlement(Trigger.new, Trigger.oldMap);
			}		   
		}
		
		if(Trigger.isAfter) {
			if(Trigger.isUpdate){
				CPOTriggerHandler.createEntitlement(Trigger.new, Trigger.oldMap);
				//CPO_QueueableCPOCDStatusChanger.checkCPOCommercialEnrichmentEligibity(Trigger.new, Trigger.oldMap); // DSI - 2300
			}
			
			if(Trigger.isInsert){
				CPOTriggerHandler.shareCSMandCDMwithCustomer(Trigger.new);
			}
			
			
		}
	}
}