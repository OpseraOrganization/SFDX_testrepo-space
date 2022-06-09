public class FileParse {
	public class Wrapper_Object{
		@AuraEnabled public string strLabelName  { get; set; }
		@AuraEnabled public string strApiName  { get; set; }
	}
	@AuraEnabled
	public static List < String > getObjectType() {
		List<String> pickListValuesList= new List<String>();
		string strQuery = '';
		Id CurrentUserId ;
		
		Schema.DescribeFieldResult fieldResult = FileParse__mdt.Object_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}	 
		CurrentUserId = UserInfo.getUserId() ;
		strQuery = 'select id from Parse_Result__c where User_ID__c =\''+CurrentUserId+'\''; 
		
		// Database.executeBatch(new FileParse_DeleteResult(strQuery), 400);
		return pickListValuesList;   
	}
	
	@AuraEnabled
	public static list<Wrapper_Object> getObjects(string strObjectType) {
		list<String> sObjectList = new list<String>();
		list<Wrapper_Object> sObjectLabel = new list<Wrapper_Object>();
		
		
		for(FileParse__mdt oFileParse : [select Field_API_Name__c,Object_API_Name__c,MasterLabel from FileParse__mdt where Object_Type__c=:strObjectType order by MasterLabel])
		{
			if(! sObjectList.contains(oFileParse.Object_API_Name__c))
				sObjectList.add(oFileParse.Object_API_Name__c);
		}
		
		system.debug( 'sObjectList: ' + sObjectList);
		
		for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() )
		{
			Schema.DescribeSObjectResult objResult = o.getDescribe();
			if(sObjectList.contains(objResult.getName()))
			{
				Wrapper_Object oWrapper_Object = new Wrapper_Object();
				oWrapper_Object.strLabelName = objResult.getLabel();
				oWrapper_Object.strApiName = objResult.getName();
				system.debug( 'Sobject: ' + objResult);
				system.debug( 'Sobject API Name: ' + objResult.getName() );
				system.debug( 'Sobject Label Name: ' + objResult.getLabel() );   
				sObjectLabel.add(oWrapper_Object);
			}
			
		}
		system.debug( 'sObjectLabel: ' + sObjectLabel);		
		if(sObjectLabel.size() > 0)
		{
			//SObjectList.sort();
			return sObjectLabel;
		}
		else
			return null;
	}
	
	
	@AuraEnabled
	public static string passFile_Jason(string strJason_file, string strObjectName,string strDMLOperation)
	{
		Id jobId ;
		List<Object> lstRecords =(List<Object>)JSON.deserializeUntyped(strJason_file);
		system.debug('strDMLOperation'+strJason_file);
		if(strDMLOperation.toLowerCase() == 'insert')
		{
			jobId = Database.executeBatch(new Insert_Batch(lstRecords,strObjectName), 200);
		}
		else if(strDMLOperation.toLowerCase() == 'update')
		{
			system.debug('workng for update');
			jobId = Database.executeBatch(new Update_Batch(lstRecords,strObjectName), 200);
		}
		
		AsyncApexJob oApexJob = [SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,
								 Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,
								 NumberOfErrors,ParentJobId,Status,TotalJobItems FROM AsyncApexJob where id=:jobId];
		return string.valueof(jobId)   ;
	}
	
	@AuraEnabled
	public static string getBatchStatus(ID BatchJobID){
		AsyncApexJob oApexJob ;
		if(BatchJobID != null)
		{
			oApexJob = [SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,
						Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,
						NumberOfErrors,ParentJobId,Status,TotalJobItems FROM AsyncApexJob where id=:BatchJobID];
			if(oApexJob.Status == 'Completed')
				return 'Done';
			else
				return 'Not Done';
		}
		return null;
	}
	
	@AuraEnabled
	public static list< String > getFields(string strObjectType) {
		list<String> sObjectList = new list<String>();
		Map<String,String> mapOfValue = new Map<String,String>();
		List<Integer> keySetValues = new List<Integer>();
		//system.debug('strObjectType'+strObjectType);
		if(strObjectType==PRMGlobalConstants.CoOpAllocation){
			for(FileParse__mdt oFileParse : [select Field_API_Name__c,Object_API_Name__c,masterlabel from FileParse__mdt where Object_API_Name__c =:strObjectType order by masterlabel])
			{				
				if(!sObjectList.contains(oFileParse.Field_API_Name__c))
					sObjectList.add(oFileParse.Field_API_Name__c);
				mapOfValue.put(oFileParse.MasterLabel,oFileParse.Field_API_Name__c);
				Integer i=integer.valueof(oFileParse.MasterLabel);
				keySetValues.add(i);
				
			}
			keySetValues.sort();
			Map<String,String> sortedMapOfValue1 = new Map<String,String>();
			for(Integer s:keySetValues){
				String j =String.valueof(s);
				sortedMapOfValue1.put(j,mapOfValue.get(j));
				
			}		 
			List<String> apiNameList = new List<String>();
			for(String s:sortedMapOfValue1.values()){
				apiNameList.add(s);
			}
		   // system.debug('apiNameList>>'+apiNameList);
			
			
			if(apiNameList.size() > 0)
			{
				return apiNameList;
			}
			else
				return null;
			
		}else{
			//system.debug('strObjectType is'+strObjectType);
			for(FileParse__mdt oFileParse : [select Field_API_Name__c,Object_API_Name__c,masterlabel from FileParse__mdt where Object_API_Name__c =:strObjectType order by masterlabel])
			{
				if(! sObjectList.contains(oFileParse.Field_API_Name__c))
					sObjectList.add(oFileParse.Field_API_Name__c);
			}
		   // system.debug('sObjectList'+sObjectList);
			return sObjectList;
		}
		
		
	}
	
	@AuraEnabled
	public static list <Parse_Result__c> fetchContact(){
		
		string strCurrentUserId = UserInfo.getUserId();
		List <Parse_Result__c> returnConList = new List < Parse_Result__c > ();
		
		for(Parse_Result__c con: [SELECT Salesforce_ID__c, Result__c, Status__c, Field_Name__c From Parse_Result__c
								  where User_ID__c =:strCurrentUserId]) {
									  returnConList.add(con);
								  }
		return returnConList;
	}
}