/**
 * @description: A helper class for PreferredDistributor Trigger.
 * @author:	Accenture IDC.
 *
 * ============================================================================
 * History:
 * -------
 * 
 * API VERSION		   DATE		 DETAIL
 * 41.0				  03/08/2018   PRM Release 3.1 hypercare
 * ============================================================================ 
 */
 public with sharing class PreferredDistributorHelper {
 /**********************************************************************************************************************
	* author: Accenture
	* Date: March-201r
	* Param: List<junction__c> PrefDistToUpdate 
	* Return: void
	* Description: Helper method after delete to call flow to update IR/NIRA preferred distributor flag

**********************************************************************************************************************/ 

public static void updateDeleteFLag(List<junction__c> PrefDistDelete)
{
   try{   
			List<junction__c> PrefDistToUpdate = new List<junction__c>();
			for(junction__c PrefDist : PrefDistDelete){
				system.debug('PrefDist .....'+ PrefDist);			
				Flow.Interview flow = new Flow.Interview.Update_IR_NIRA_to_populate_Preferred_Distributor(new map<String,Object>{'CaseID' => PrefDist.case__c});	
				flow.start();
			}
			system.debug('PrefDistToUpdate.....'+ PrefDistToUpdate);
		   // Database.update(PrefDistToUpdate);
	   }
		catch(Exception Ex){ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER, 'updateDeleteFLag');}   
	}
}