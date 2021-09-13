/******************************
* Author : Christie JJ
* Date : 06/04/2021
* Description : The scheduled class runs daily invoking the PreApprovedProductsBatchJob Class
*******************************/

public class PreApprovedProductsJobScheduler implements Schedulable 
{
	public void execute(SchedulableContext sc) 
	{
		PreApprovedProductsBatchJob batchJob = new PreApprovedProductsBatchJob(); 
		database.executebatch(batchJob);
	}
}