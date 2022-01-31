global class CSTCampaignMemeberStatusSchedular implements Schedulable{   
	global void execute(SchedulableContext SC)
{		
	ID jobID = System.enqueueJob(new CSTCampaignMemberCalloutQueuable());	
}  
}