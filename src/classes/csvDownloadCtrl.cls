public class csvDownloadCtrl {
@AuraEnabled
   public static list <Parse_Result__c> fetchParseResult(string BatchJobID){
	  
	   string strCurrentUserId = UserInfo.getUserId();
	  List <Parse_Result__c> returnConList = new List < Parse_Result__c > ();
		
	  for(Parse_Result__c con: [SELECT Salesforce_ID__c, IsError__c , Apex_JobID__c,Result__c, Status__c, Field_Name__c From Parse_Result__c
										where User_ID__c=:strCurrentUserId ]) 
										{
										if(con.Apex_JobID__c.contains(BatchJobID) || BatchJobID.contains(con.Apex_JobID__c) )
										{
										returnConList.add(con);
										}
			 
		  }
		 return returnConList;
   }
	
	
	@AuraEnabled
	public static AsyncApexJob getBatchStatus(ID BatchJobID){
		if(BatchJobID != NULL)
		{		 
			AsyncApexJob oApexJob = [SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,
			Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,
			NumberOfErrors,ParentJobId,Status,TotalJobItems FROM AsyncApexJob where id=:BatchJobID];

			return oApexJob;
		}
		else
			return null;
	}
}