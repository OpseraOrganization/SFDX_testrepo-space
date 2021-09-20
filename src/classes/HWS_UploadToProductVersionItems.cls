/****************************************
* Name : HWS_UploadToProductVersionItems
* Author : TCS
* Description : This class is for loading data from edp to Product VersionItems and create interface logs
* ReqNo : 
****************************************/
public without sharing class HWS_UploadToProductVersionItems {
	/****************************************
* Name : uploadToProductVersionItemStagingTable
* Description : load data to Product Version Item Table
* Parameters: HttResponse, URL
* Returns: List of Product Version Item Records
*****************************************/
	public static List<HWS_Product_Version_Item__c> jsonToProductVersionItemStagingTable(HttpResponse response1, String path){
		List<HWS_Product_Version_Item__c> partRevList = new List<HWS_Product_Version_Item__c>();
		Set<String> nsnCodeSET= new Set<String>();
		List<interface_log__c> ilogs = new List<interface_log__c>();
		List<PVItemWrapper> prodVerItems = (List<PVItemWrapper>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<PVItemWrapper>.class);
		for(PVItemWrapper partRev: prodVerItems)
		{
		  try{
			HWS_Product_Version_Item__c pvItem = new HWS_Product_Version_Item__c();
			pvItem.HWS_LifeCycleStatus__c = partRev.Current;
			pvItem.HWS_Is_Processed__c = false;
			pvItem.HWS_NSNCode__c = partRev.NSNCode;
			pvItem.HWS_NSNSourceSystem__c = partRev.NSNSourceSystem;
			pvItem.HWS_Type__c = partRev.Type;
			pvItem.HWS_Unit_of_Measure__c = partRev.UnitofMeasure;
			pvItem.HWS_EDPLastModifiedDate__c = partRev.EDP_LastModifiedDate;
			pvItem.HWS_EDPActiveStatus__c = partRev.EDP_ActiveStatus;
			pvItem.HWS_SparePart__c = partRev.SparePart;
			pvItem.HWS_Is_Assembly_Processed__c = false;
			pvItem.Name = partRev.Name; 
			if(!nsnCodeSET.contains(pvItem.HWS_NSNCode__c))
			{
				partRevList.add(pvItem);
				nsnCodeSET.add(pvItem.HWS_NSNCode__c);
			}
			}
			 catch(Listexception e){
		  iLogs = HWS_Utility_Batch.createInterfaceLogs(partRev.NSNCode,'EDP Release Stage','Inbound','Insert','HWS_UploadToProductVersionItems', e.getMessage(),partRev.EDP_LastModifiedDate);
	
		  }
		}
		nsnCodeSET.clear();
		Database.insert(ilogs);
		return partRevList;
	}
	/****************************************
* Name : createInterfaceLogsToProductVersionItem
* Description : create interface logs for  Product Version Item
* Parameters: Response, List of  Product Relationships Items, url
* Returns: 
*****************************************/
	public static void createInterfaceLogsAndProductVersionItem(HttpResponse response1,List<HWS_Product_Version_Item__c> partRevList,String pathSI){
		List<Database.UpsertResult> resultspr = Database.upsert(partRevList,HWS_Product_Version_Item__c.HWS_NSNCode__c,false);
   
		List<interface_log__c> ilogs = new List<interface_log__c>();
		Interface_Log__c ilogcallout = new Interface_Log__c();
		ilogcallout.Interface_Type__c = HWS_Constants.EDP_Release_Stage;
		ilogcallout.Message_Type__c = 'Inbound';
		ilogcallout.Operation_Type__c = 'Insert';
		
		
		if(response1.getStatuscode() !=200){
			ilogcallout.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
	'Response: '+response1.getStatus()+'\n'+
	'Response Code'+response1.getStatuscode();
			ilogcallout.Status__c = 'Failure';
			ilogcallout.Name = 'Product Version Item Extended Class Rest Callout Failed';
		}
		ilogs.add(ilogcallout);
		
		////part Revision Interface Logs////
		for(Integer index = 0, size = resultspr.size(); index < size; index++) {
			String operationtype= resultspr[index].isCreated()?'Insert':'Update';
			system.debug('Count of upsert result: '+resultspr.size());
			system.debug('Result  value upsert: '+resultspr[index].isSuccess());
			if(!resultspr[index].isSuccess()) { 
	////PR Error Interface Logs///
	Interface_Log__c ilogPr = new Interface_Log__c();
	for (Database.Error err : resultspr[index].getErrors()){
		ilogPr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
			'Status Code: '+err.getStatusCode();
	}
	

	ilogPr.Interface_Type__c = HWS_Constants.EDP_Release_Stage;
	ilogPr.Message_Type__c = 'Inbound';
	ilogPr.Operation_Type__c = operationtype;
	ilogPr.Status__c = 'Failure';
	ilogPr.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
		'NSNCode: '+ partRevList[index].HWS_NSNCode__c +'\n'+
		'Type: '+ partRevList[index].HWS_Type__c +'\n'+
		'Description: '+ partRevList[index].HWS_Description__c +'\n'+
		'EDP_LastModifiedDate: '+ partRevList[index].HWS_EDPLastModifiedDate__c;
	ilogPr.Name = 'Product Version Item '+operationtype+' Failure with NSNCode: '+ partRevList[index].HWS_NSNCode__c;
	ilogs.add(ilogPr);
	

	
			}	 
		}
		 if(ilogs.size() > 0)
		 Database.Insert(ilogs,false); 
		 
		partRevList.clear();
	}
	public class PVItemWrapper{
		public String Name{get;set;}
		public String Current{get;set;}
		public String Description{get;set;}
		public String NSNCode{get;set;}
		public String NSNSourceSystem{get;set;}
		public String Revision{get;set;}
		public String Type{get;set;}
		public String UnitofMeasure{get;set;}
		public DateTime EDP_LastModifiedDate{get;set;}
		public Boolean EDP_ActiveStatus{get;set;}
		public String SparePart{get;set;}
		
	}
	
}