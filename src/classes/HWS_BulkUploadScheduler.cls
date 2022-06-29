/****************************************
* Name : HWS_BulkUploadScheduler
* Author : TCS
* Description : To avoid 100 batch job limit, this class first check the total number of batch jobs running in the system. If the count is close(80) then it will schedule batch job after 30 mins. 
* This class is called from HWS_CreateSupportTicketportal.cls 
* Test class : HWS_BulkUpload_Batch_Test 
* ReqNo : NOKIASC-37921
****************************************/
 global without sharing class HWS_BulkUploadScheduler Implements Schedulable
	{   
		public boolean isSchduleJob = false;
		public string sReferenceNumber;
		public string sActiontype;
		public string sServiceType;
		public Boolean Pending;
		public Id iAccountId;
		public Id iContactId; 
		global HWS_BulkUploadScheduler( string ReferenceNumber, string Actiontype, string serviceType, Boolean isPending,Id accountId, Id contactId){
			this.sReferenceNumber = ReferenceNumber;
			this.sActiontype = Actiontype;
			this.sServiceType = serviceType;
			this.Pending = isPending;
			this.iAccountId = accountId;
			this.iContactId = contactId;
		}
		global void execute(SchedulableContext sc)
		{
			schduleJob();
			if(this.isSchduleJob){
				HWS_BulkUpload_Batch cls = new HWS_BulkUpload_Batch(this.sReferenceNumber, this.sActiontype, this.sServiceType,this.Pending,this.iAccountId,this.iContactId,0,'Parentinsert', null);
				HWS_GenericSettings__c record = HWS_GenericSettings__c.getValues('HWS_BulkUploadBachSize');
				string BatchSize ;
				if(record == null)
					BatchSize = '25';
				else
					BatchSize= (string) record.get('HWS_Field1__c');

				Database.executeBatch(cls, integer.valueof(BatchSize));
			}
		}

		public void schduleJob()
		{
			List<AsyncApexJob> batchJobs = [SELECT ApexClassId FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status  IN ('Processing','Preparing','Queued', 'Holding')];
			 integer iJobSize = integer.valueof(System.Label.HWS_BulkAllowedJobs);
			if(iJobSize == null )
				iJobSize = 80;  
			if(batchJobs.size() < iJobSize){
				this.isSchduleJob = true;
			}
			else{
				List<AsyncApexJob> ScheduledJobs = [SELECT ApexClassId FROM AsyncApexJob WHERE JobType = 'ScheduledApex' AND Status  IN ('Processing','Preparing','Queued', 'Holding')];
				
				if(ScheduledJobs.size() < 99){
					Datetime dt = Datetime.now() + (0.024305); // adding 30 mins from current time
					String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
					HWS_BulkUploadScheduler run = new HWS_BulkUploadScheduler(this.sReferenceNumber, this.sActiontype, this.sServiceType,this.Pending,this.iAccountId,this.iContactId); 
					System.schedule('HWS_BulkUploadScheduler - '+timeForScheduler+' -- '+dt.millisecond() , timeForScheduler, run);
				}
				else{
					this.isSchduleJob = true;
				}
			}
		}
	}