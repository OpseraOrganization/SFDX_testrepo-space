global without sharing  class Insert_Batch implements Database.Batchable<object> 
{
	
	global final List<object> lstRecords;
	global final string strObjectName;
	
	global Insert_Batch(List<object> lstRecord,string strObjectName)
	{
		this.lstRecords=lstRecord;
		this.strObjectName=strObjectName;
	}
	
	public Iterable<object> start(Database.BatchableContext BC) 
	{
		return  lstRecords;
	}
	
	public void execute(Database.BatchableContext info, List<object> lstRecords) 
	{
		List<sObject> lstContact_Insert = new List<sObject>();
		List<sObject> lstContact_Update = new List<sObject>();
		Map<String, Object> mapkeyValue1 = (Map<String, Object>)lstRecords.get(0);
		Map<string,string> mapField_DataType = new Map<string,string>();
		Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap();
		
		for(String s : objectFields.keySet())
		{
			Schema.DescribeFieldResult lfieldLabel = objectFields.get(s).getDescribe();
			Schema.DisplayType dType = lfieldLabel.getType();
			string fieldType = String.ValueOf(dType);
			mapField_DataType.put(s.toLowerCase(),fieldType.toLowerCase());
		}
		
		for (Object oRecord : lstRecords) 
		{
			sObject sObj_Insert = Schema.getGlobalDescribe().get(strObjectName).newSObject() ;
			Map<String, Object> mapkeyValue = (Map<String, Object>)oRecord;
			
			for (String attributeName : mapkeyValue.keyset()) 
			{
				
				string strValue = string.valueof(mapkeyValue.get(attributeName));
				System.debug(attributeName+'attributeName : '+strValue);
				if(strValue != 'Blank')
				{
					System.debug(attributeName+'attributeName 1: '+strValue);
					if(mapField_DataType.get(attributeName.toLowerCase()) == 'date')
					{
						sObj_Insert.put(attributeName, Date.valueOf(strValue));
					}
					else if(mapField_DataType.get(attributeName.toLowerCase()) == 'double' || mapField_DataType.get(attributeName.toLowerCase()) == 'percent' ||
							mapField_DataType.get(attributeName.toLowerCase()) == 'currency')
					{
						System.debug(attributeName+'lstContact_Update : '+strValue);
						System.debug('lstContact_Update : '+decimal.valueOf(strValue));
						if(strValue != null)
							sObj_Insert.put(attributeName, decimal.valueOf(strValue));
						
					}else if(mapField_DataType.get(attributeName.toLowerCase()) == 'reference' ||
							 mapField_DataType.get(attributeName.toLowerCase()) == 'picklist' ||
							 mapField_DataType.get(attributeName.toLowerCase()) == 'string' )
					{
						sObj_Insert.put(attributeName, strValue);
					} else if(mapField_DataType.get(attributeName.toLowerCase()) == 'time' ||
							  mapField_DataType.get(attributeName.toLowerCase()) == 'datetime' )
					{
						sObj_Insert.put(attributeName, Datetime.valueOf(strValue));
					} 
				}
			}
			lstContact_Insert.add(sObj_Insert);		 
		}
		
		System.debug('lstContact_Update : '+lstContact_Update);
		
		string strClassId = Label.FileParse_Id;
		List<String> parts = strClassId.split( ',' );
		system.debug(''+parts.get(0));
		
		ID oApexJobId ;
		if(!Test.isRunningTest())
		oApexJobId = [SELECT ApexClassId,ID FROM AsyncApexJob where ApexClassId=:parts.get(0) order by CreatedDate desc Limit 1].id;
		
		
		System.debug('oApexJob.get1 : '+oApexJobId);
		
		Schema.SObjectField accountType = objectFields.get('id').getDescribe().getSObjectField();
		
		
		List<Parse_Result__c> lstWrapper = new List<Parse_Result__c>();
		
		
		string strCurrentUserId = UserInfo.getUserId() ;
		
		if(lstContact_Insert.size() > 0)
		{
			Database.saveResult[] saveResults_Insert = Database.insert(lstContact_Insert, false);
			for(Database.saveResult saveResult : saveResults_Insert)
			{
				System.debug('Error occured : '+saveResult);
				if (!saveResult.isSuccess()) 
				{
					for(Database.Error err : saveResult.getErrors()) 
					{
						Parse_Result__c oParseResult = new Parse_Result__c();
						oParseResult.Salesforce_ID__c = '';
						oParseResult.Result__c = string.valueof(err.getStatusCode());
						oParseResult.Status__c	 = err.getMessage();
						oParseResult.User_ID__c	 = strCurrentUserId;
						oParseResult.Field_Name__c = string.valueof(err.getFields());
						oParseResult.Apex_JobID__c = string.valueof(oApexJobId);
						oParseResult.IsError__c = true;
						lstWrapper.add(oParseResult);
						System.debug('Error occured : '+err.getStatusCode() + ' : ' + err.getMessage());
						System.debug('CollaborationGroupMember fields that affected this error : ' + err.getFields());
					}
				}			
				else
				{		
					Parse_Result__c oParseResult = new Parse_Result__c();
					oParseResult.Salesforce_ID__c = saveResult.getId();
					oParseResult.Result__c = 'Success';
					oParseResult.Status__c	 ='Created';
					oParseResult.Field_Name__c = '';
					oParseResult.Apex_JobID__c = string.valueof(oApexJobId);
					oParseResult.User_ID__c	 = strCurrentUserId;
					lstWrapper.add(oParseResult);
					System.debug('isSuccess occured : '+ saveResult.getId());
				}
			}
		}
		
		if(lstWrapper.size()> 0)
			insert lstWrapper ;
		
	}
	public void finish(Database.BatchableContext info) {
	}
}