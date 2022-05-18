/****************************************
 * Class Name : CH_AssetTriggerHandler 
 * Created Date: 25 September 2018
 * Created By : TCS
 * Last Modified by: Sónia Reis
 * Last Modified Date: 06 February 2020
 * Description : Handle the sequence of the CH_AssetTriggerHelper
 * Test Class: CH_AssetTriggerHelperTest 
 *****************************************/ 
public class CH_AssetTriggerHandler extends TriggerHandler {
	private List<Asset> oldList;
	private List<Asset> newList;
	private Map<Id, Asset> oldMap;
	private Map<Id, Asset> newMap;
	
	final static Id neaRecordType =Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
	final static Id cpRecordType =Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		
	public CH_AssetTriggerHandler() {
		this.oldList = (List<Asset>) Trigger.Old;
		this.newList = (List<Asset>) Trigger.New;
		this.oldMap  = (Map<Id, Asset>) Trigger.OldMap;
		this.newMap  = (Map<Id, Asset>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the Asset beforeInsert event on Asset.
	*/
	public override void beforeInsert(){
		CH_AssetTriggerHelper.populateCountryCode(newList);
		CH_AssetTriggerHelper.populateCountryName(recordTypeCheck(newList));
		//28440 - Added newAssetList to update all Assets for Customer_Compliance__c update
		CH_AssetTriggerHelper.populateAssetName(newList);
		//Replicating CH_copyNIDtoAssetName workflow here. Its not firing on the CreateNEA lightning page
		//Prateek - 24956 
	}
	
	/*
	* @description : afterInsert handle the Asset afterInsert event on Asset.
	*/
	public override void afterInsert(){
		CH_AssetTriggerHelper.createCoveredNEA(newList);
		
	}
	
	/*
	* @description : beforeUpdate handle the Asset beforeUpdate event on Asset.
	*/
	public override void beforeUpdate(){
		CH_AssetTriggerHelper.populateCountryCodeOnUpdate(oldMap, recordTypeCheck(newList));
		CH_AssetTriggerHelper.populateCountryName(newList);
		CH_AssetTriggerHelper.updateAssetName(oldMap, newList);
		CH_AssetTriggerHelper.validationRules(oldMap, newList);
		//Replicating CH_copyNIDtoAssetName workflow here. Its not firing on the CreateNEA lightning page
		//Prateek - 24956 
		/*CH_AssetTriggerHelper.CheckDuplicateBeforeUpdate(oldMap, newList);*/ //NOKIASC-36188
		CH_AssetTriggerHelper.assetStatusCheck(oldMap, newList);
	}
	
		/*
	* @description : afterUpdate handle the Asset afterUpdate event on Asset.
	*/
	public override void afterUpdate(){
		
	}
	
	/*
	* @description : beforeDelete handle the Asset beforeDelete event on Asset.
	*/
	public override void beforeDelete(){
		
	}
	
		/*
	* @description : afterDelete handle the Asset afterDelete event on Asset.
	*/
	public override void afterDelete(){
		
	}
	
	/********************
	*Method Name: recordTypeCheck
	*Parameter: New Asset List
	*Description: Used to check if record type 'Network Element Asset' and 'Covered Product'
	*******************/
	private static List <Asset> recordTypeCheck(List<Asset> newAssetList) {
		List<Asset> filteredList = new List<Asset>();
			for(Asset a : newAssetList){
	if(a.recordtypeId == neaRecordType || a.recordtypeId == cpRecordType){
		filteredList.add(a);
	}
			}
		return filteredList;
	}
}