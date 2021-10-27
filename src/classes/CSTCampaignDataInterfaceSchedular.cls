global class CSTCampaignDataInterfaceSchedular implements Schedulable {
	global void execute(SchedulableContext SC) {
		ID jobID = System.enqueueJob(new CSTCamapignCalloutQueueable());
	} 
}