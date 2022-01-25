/**
 * @description	   : 
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 11-25-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/
public class QTO_ScheduledJobUtility {

	private static final String DEFAULT_JOB_NAME = 'Auto Association Job';
	private static final Integer BATCH_APEX_CONCURRENT_LIMIT = 5;
	

	public Boolean scheduleBatchJob(Database.Batchable<sObject> job, Integer batchSize){
		return scheduleBatchJob(job, batchSize, null);
	}
	
	Boolean bBatchLimit = true;
	
	/* Responsible for scheduling job based on if the org still has capacity to schedule more jobs*/
	public Boolean scheduleBatchJob(Database.Batchable<sObject> job, Integer batchSize, Id scheduledJobId)
	{
		//Only schedule the job if batch limit has not been exceeded yet. Batch Limit Size : 5		
		List<AsyncApexJob> jobsRunning = [
			Select 
				Id, ApexClass.Name, CreatedBy.Username, Status, CreatedDate
			From AsyncApexJob 
			where
				JobType = 'BatchApex' AND
				Status != 'Completed' AND
				Status != 'Aborted' AND
				Status != 'Failed'
			order by createdDate];
		
		Integer numOfJobsRunning = jobsRunning.size();
		Integer numOfProcessableJobs = BATCH_APEX_CONCURRENT_LIMIT - numOfJobsRunning;
	 system.debug('HS - > Number of batch :' + numOfProcessableJobs);
		if (numOfProcessableJobs > 0){
	  system.debug('HS - > Executing batch :' );
			Database.executeBatch(job, batchSize);
		} 
		else {
			bBatchLimit = false;
		}
		
		return bBatchLimit;
	} 
	


}