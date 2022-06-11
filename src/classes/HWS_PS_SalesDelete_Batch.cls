global without sharing class HWS_PS_SalesDelete_Batch implements database.Batchable<sobject>{
	list<HWS_Product_Serviceable_Sales_Item__c> llist=new list<HWS_Product_Serviceable_Sales_Item__c>();
	
	global database.querylocator start(database.BatchableContext bc){
		string query='select Id,HWS_Is_Processed__c  from HWS_Product_Serviceable_Sales_Item__c where HWS_Is_Processed__c = TRUE and CreatedDate<LAST_N_DAYS:7';
		return database.getQueryLocator(query); 
	}
	global void execute(database.BatchableContext bc,list<HWS_Product_Serviceable_Sales_Item__c> le){
		
		delete le;			
		database.emptyRecycleBin(le); 
	}
	global void finish(database.BatchableContext bc){
		String cs2 = HWS_GenericSettings__c.getValues('HWS_PS_VersionDelete').HWS_Field1__c;
		String cs3 = HWS_GenericSettings__c.getValues('HWS_BulkUploadDelete').HWS_Field1__c;
		if(cs2=='true'){ Database.executeBatch(new HWS_PS_VersionDelete_Batch(),200);
					   }
		else if (cs3=='true') { Database.executeBatch(new HWS_BulkUploadDelete_Batch(),200);
							  }
	}
}