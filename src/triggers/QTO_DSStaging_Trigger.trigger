/******************************************************************************************************
Name : QTO_DSStaging_Trigger
Created Date: 11 September 2020
Created by: Bogdan Botcharov
Description : Trigger on DS_Staging__c object
*********************************************************************************************************/
trigger QTO_DSStaging_Trigger on DS_Staging__c (after insert) {

	if(Trigger.isInsert && Trigger.isAfter){
		Set<Id> newDSStagingIds = new Set<Id>();
		for(DS_Staging__c dsSO : Trigger.new)
			newDSStagingIds.add(dsSO.Id);

		QTO_StagingToCustomerDocTranslation.translatePayloadToDocument(newDSStagingIds);
	}
}