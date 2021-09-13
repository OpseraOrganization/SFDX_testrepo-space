global without sharing  class Update_Batch implements Database.Batchable<object> 
{
	
	global final List<object> lstRecords;
	global final string strObjectName;
	
	global Update_Batch(List<object> lstRecord,string strObjectName)
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
			
			sObject sObj_Update = Schema.getGlobalDescribe().get(strObjectName).newSObject() ;
			Map<String, Object> mapkeyValue = (Map<String, Object>)oRecord;
			
			for (String attributeName : mapkeyValue.keyset()) 
			{
				
				string strValue = string.valueof(mapkeyValue.get(attributeName));
				if(strValue != 'Blank')
				{
					if(mapField_DataType.get(attributeName.toLowerCase()) == 'id')
					{
						sObj_Update.put(attributeName, strValue);
					}else if(mapField_DataType.get(attributeName.toLowerCase()) == 'date')
					{
						sObj_Update.put(attributeName, Date.valueOf(strValue));
					}
					else if(mapField_DataType.get(attributeName.toLowerCase()) == 'double' || mapField_DataType.get(attributeName.toLowerCase()) == 'percent' ||
							mapField_DataType.get(attributeName.toLowerCase()) == 'currency')
					{
						sObj_Update.put(attributeName, decimal.valueOf(strValue));
						
					}else if(mapField_DataType.get(attributeName.toLowerCase()) == 'reference' ||
							 mapField_DataType.get(attributeName.toLowerCase()) == 'picklist' ||
							 mapField_DataType.get(attributeName.toLowerCase()) == 'string' )
					{
						sObj_Update.put(attributeName, strValue);
					} else if(mapField_DataType.get(attributeName.toLowerCase()) == 'time' ||
							  mapField_DataType.get(attributeName.toLowerCase()) == 'datetime' )
					{
						sObj_Update.put(attributeName, Datetime.valueOf(strValue));
					} 
				}
			}
			lstContact_Update.add(sObj_Update);
			
		}
		
		 string strClassId = Label.FileParse_Id;
		List<String> parts = strClassId.split( ',' );
		system.debug(''+parts.get(0));
		
		System.debug('lstContact_Update : '+lstContact_Update.size());
		
		ID oApexJobId;
		if(!Test.isRunningTest())
		oApexJobId = [SELECT ApexClassId,ID FROM AsyncApexJob where ApexClassId=:parts.get(1) order by CreatedDate desc Limit 1].id;
		
		Schema.SObjectField accountType = objectFields.get('id').getDescribe().getSObjectField();
		
		
		List<Parse_Result__c> lstWrapper = new List<Parse_Result__c>();
		
		
		string strCurrentUserId = UserInfo.getUserId() ;
		
		if(lstContact_Update.size() > 0)
		{
			System.debug('lstContact_Update : '+lstContact_Update.size());
			Database.saveResult[] saveResults_Update = Database.Update(lstContact_Update, false);
			for(Database.saveResult saveResult : saveResults_Update)
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
						oParseResult.Apex_JobID__c = string.valueof(oApexJobId);
						oParseResult.IsError__c = true;
						oParseResult.Field_Name__c = string.valueof(err.getFields());
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