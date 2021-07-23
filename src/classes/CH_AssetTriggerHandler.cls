/****************************************
 * Class Name : CH_AssetTriggerHandler 
 * Created Date: 25 September 2018
 * Created By : TCS
 * Last Modified by: Sónia Reis
 * Last Modified Date: 06 February 2020
 * Description : Handle the sequence of the CH_AssetTriggerHelper
 * Test Class: CH_AssetTriggerHelperTest 
 *****************************************/ 
public class CH_AssetTriggerHandler {
	
	//to bypass the trigger in case of deployment, insert the name of the userDeployment in the custom setting 
	private static final String OBJECT_NAME = String.valueOf(Asset.sObjectType);
	
	final static Id neaRecordType = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
	final static Id cpRecordType = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
	
	
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New Asset List
	*Description: Used to handle before insert operation
	*******************/
	public static void beforeInsertOperation(List < Asset > newAssetList) {
		if (!PAD.cantRun(OBJECT_NAME)){
			
			List<Asset> filteredList = new List<Asset>();
			filteredList = recordTypeCheck(newAssetList);
			CH_AssetTriggerHelper.populateCountryCode(newAssetList);
			if(filteredList.size()>0){
				CH_AssetTriggerHelper.populateCountryName(filteredList);
			}
			//28440 - Added newAssetList to update all Assets for Customer_Compliance__c update
			
			CH_AssetTriggerHelper.populateAssetName(newAssetList);
			//Replicating CH_copyNIDtoAssetName workflow here. Its not firing on the CreateNEA lightning page
			//Prateek - 24956 
			CH_AssetTriggerHelper.assetName_NIDValidation(null, newAssetList);
			CH_AssetTriggerHelper.CheckDuplicateBeforeInsert(newAssetList, 'Insert');
		} 
	}
	
	/********************
	*Method Name: beforeUpdateOperation
	*Parameter: Old Asset Map, New Asset List
	*Description: Used to handle before update operation
	*******************/
	public static void beforeUpdateOperation(Map < Id, Asset > oldAssetMap, List < Asset > newAssetList) {
		
		if (!PAD.cantRun(OBJECT_NAME)){
			
			List<Asset> filteredList = new List<Asset>();
			filteredList = recordTypeCheck(newAssetList);
			
			if(filteredList.size()>0){
				CH_AssetTriggerHelper.populateCountryCodeOnUpdate(oldAssetMap, filteredList);
			}
			CH_AssetTriggerHelper.populateCountryName(newAssetList);
			CH_AssetTriggerHelper.updateAssetName(oldAssetMap, newAssetList);
			CH_AssetTriggerHelper.validationRules(oldAssetMap, newAssetList);
			//Replicating CH_copyNIDtoAssetName workflow here. Its not firing on the CreateNEA lightning page
			//Prateek - 24956 
			CH_AssetTriggerHelper.assetName_NIDValidation(oldAssetMap, newAssetList);
			CH_AssetTriggerHelper.CheckDuplicateBeforeUpdate(oldAssetMap, newAssetList);
			CH_AssetTriggerHelper.assetStatusCheck(oldAssetMap, newAssetList);
		}
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: New Asset List
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List < Asset > newAssetList) {
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_AssetTriggerHelper.createCoveredNEA(newAssetList);
			// CH_AssetTriggerHelper.UpdateNEA(newAssetList);
		}
	}
	
	/********************
	*Method Name: recordTypeCheck
	*Parameter: New Asset List
	*Description: Used to check if record type 'Network Element Asset' and 'Covered Product'
	*******************/
	private static List < Asset > recordTypeCheck(List < Asset > newAssetList) {
		List<Asset> filteredList = new List<Asset>();
			for(Asset a : newAssetList){
				if(a.recordtypeId == neaRecordType || a.recordtypeId == cpRecordType){
					filteredList.add(a);
				}
			}
		return filteredList;
	}
}