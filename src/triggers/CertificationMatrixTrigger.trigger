/****************************************
 * Trigger Name : CertificationMatrixTrigger 
 * Created Date: 12 september 2017
 * Created By : Supriyam
 * Last Modified by: Accenture
 * Last Modified Date: 12 september 2017
 * Description : All certification matrix Related Actions will be tracked here
 *****************************************/
trigger CertificationMatrixTrigger on Certification_Matrix__c (After insert, After update) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isAfter)
		{
			if(Trigger.isInsert)
			{
			   CertificationMatrixHandlerPRM.afterInsertOperation(Trigger.new);
			}
			else if(Trigger.isUpdate)
			{
				CertificationMatrixHandlerPRM.afterUpdate(Trigger.oldMap,Trigger.newMap);
			}
		}
	}

}