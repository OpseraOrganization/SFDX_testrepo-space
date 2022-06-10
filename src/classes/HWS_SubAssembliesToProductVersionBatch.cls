/****************************************
* Class Name : HWS_SubAssembliesToProductVersionBatch
* Created Date: 25 June 2020
* Created By : Sai Lakshman Kanukollu
* Last Modified by: Sai Lakshman Kanukollu
* Last Modified Date: 25 June 2020
* Description : This batch class is used to update Item Type field to "Assembly" in Product Version Item object
* Reference: NOKIASC-28642
* Test Class: HWS_SubAssembliesToProductBatch_TEST
*****************************************/

public class HWS_SubAssembliesToProductVersionBatch implements Database.Batchable<sObject>,Database.Stateful
{
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		
		String query = 'SELECT Id, HWS_NSNCode__c,HWS_Item_Type__c,HWS_Part_Number__c,HWS_Part_name__c  FROM HWS_Product_Serviceable_Sales_Item__c  WHERE HWS_Item_Type__c = \'Sub Assembly\' AND HWS_Is_Assembly_Processed__c = false ';
		return Database.getQueryLocator(query);
	}
	public void execute(Database.BatchableContext BC, List < HWS_Product_Serviceable_Sales_Item__c > scope) {
		
		try {
			Set<String> nsnCodeSet = new Set<String>();
			Map<String,String> nsnPartNameMap = new Map<String, String>();
			for (HWS_Product_Serviceable_Sales_Item__c serSales: scope) {
				nsnCodeSet.add(serSales.HWS_Part_Number__c);
				nsnPartNameMap.put(serSales.HWS_Part_Number__c,serSales.HWS_Part_name__c);
				
			}
			updateProductVersionField(nsnCodeSet,nsnPartNameMap);
			
		} catch(Exception ex) {
			System.debug('### An exception has occurred : ' + ex.getMessage());
		}
	}
	
	public void finish(Database.BatchableContext BC) {
		
	}
	
	
	/********************
* Method Name: updateProductVersionField
* Parameter: Set < String > nsnCodeSet
* Description: Used to update HWS_Item_Type__c field on Product Version Item
* Reference: NOKIASC-28642
*******************/
	public void updateProductVersionField (Set < String > nsnCodeSet,Map<String,String> nsnPartNameMap) {
		Set<String> nsnCode = new Set<String>();
		Set<String> productversionNSNCode = new Set<String>();
		Set<String> leftOverNSNCodes = new Set<String>();
		//Create a new list for interface logs to store callout failures
		List<interface_log__c> ilogs = new List<interface_log__c>();
		List<HWS_Product_Serviceable_Sales_Item__c> processedList = new List<HWS_Product_Serviceable_Sales_Item__c>();
		List<HWS_Product_Serviceable_Sales_Item__c> unProcessedList = new List<HWS_Product_Serviceable_Sales_Item__c>();
		List<HWS_Product_Version_Item__c> prodVersionsToUpdate = new List<HWS_Product_Version_Item__c>();
		List<HWS_Product_Version_Item__c> assemblyPrdVersions = [SELECT Id, HWS_NSNCode__c  FROM HWS_Product_Version_Item__c
																 WHERE HWS_NSNCode__c =: nsnCodeSet];
		for (HWS_Product_Version_Item__c prodVersionObject: assemblyPrdVersions) {
			prodVersionObject.HWS_IsAssembly__c= true;
			prodVersionObject.Name= nsnPartNameMap.get(prodVersionObject.HWS_NSNCode__c);
			prodVersionsToUpdate.add(prodVersionObject);
			productversionNSNCode.add(prodVersionObject.HWS_NSNCode__c);
		}
		
		for(String nscod : nsnCodeSet){
			if(!productversionNSNCode.contains(nscod)){
				leftOverNSNCodes.add(nscod);
			}
		}
		
		try
		{
			Database.SaveResult[] srList = Database.update(prodVersionsToUpdate, false);
			
			// Iterate through each returned result
			for(Integer index = 0, size = srList.size(); index < size; index++)
			{
				if(srList[index].isSuccess()){
					nsnCode.add(prodVersionsToUpdate[index].HWS_NSNCode__c);
					system.debug('product3333'+nsnCode);
				}
				else{
					Interface_log__c ilog = createErrorLog(srList[index].getErrors(),prodVersionsToUpdate[index],'update');
					if(ilog != null){
						ilogs.add(ilog);
					}
				}
			}
			
			for(HWS_Product_Serviceable_Sales_Item__c psi : [select Id,HWS_Is_Assembly_Processed__c from HWS_Product_Serviceable_Sales_Item__c where HWS_Part_Number__c  in:nsnCode ]){
				psi.HWS_Is_Assembly_Processed__c=true;
				processedList.add(psi);
			}
			
			for(HWS_Product_Serviceable_Sales_Item__c psi : [select Id,HWS_Is_Assembly_Processed__c,HWS_Unprocessed_reason__c from HWS_Product_Serviceable_Sales_Item__c where HWS_Part_Number__c  in:leftOverNSNCodes ]){
				psi.HWS_Unprocessed_reason__c ='NSN code not found in Product Version Item';
				unProcessedList.add(psi);
			}
			Database.update(processedList,false);
			Database.update(unProcessedList,false);
			Database.insert(ilogs,false);
		}
		catch (DmlException e)
		{
			System.debug('There was an error during the Product Upsert!'+e);
		}
		
	}
	
	public Interface_log__c createErrorLog(Database.Error[] errors, HWS_Product_Version_Item__c productVersionItem, String operationType)
	{
		Interface_log__c ilog = new Interface_log__c();
		if(errors.size()>0){
			for (Database.Error err : errors)
			{
				ilog.comment__c = 'Fields: '+err.getFields()+' Message: '+err.getMessage()+
					' Status Code: '+err.getStatusCode();
			}
		}
		ilog.Interface_Type__c = 'PMDSOR-HWS';
		ilog.Message_Type__c = 'Inbound';
		ilog.Operation_Type__c = operationType;
		ilog.Interface_Request_Sent__c = 'HWS_SubAssembliesToProductVersionBatch: '+productVersionItem.Name+' NSN Code: '+productVersionItem.HWS_NSNCode__c;
		ilog.Status__c = 'Failure';
		ilog.Name = 'Product Version Item failed with '+productVersionItem.HWS_NSNCode__c;
		return ilog;
	}
	
}