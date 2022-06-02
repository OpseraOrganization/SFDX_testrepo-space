/****************************************
* Class Name : CH_NetworkElementAssetServicesHelper
* Created Date: 31 Oct 2019
* Created By : Rajeshwari
* Description : Helper for Network Element Tab from CLI Related/Add/Unlink
* Test Class: 
Name			Modified DATE	   Comments  
*****************************************/
public without sharing class CH_NetworkElementAssetServicesHelper {
	/****************************************
* Created By : Rajeshwari
* Description : Picklist values for Fields
*****************************************/	
	public static List<String> getPicklistOptions(String fieldName, String sObjectName){
		system.debug('getPicklistOptions -->'+fieldName +sObjectName);
		List<String> options = new List<String>();
		Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
		Schema.SObjectType sobjType = gd.get(sObjectName);
		Schema.DescribeSObjectResult r = sobjType.getDescribe();
		Map<String,Schema.SObjectField> field_map = r.fields.getMap();
		List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
		if(fieldName =='Status' || fieldName=='CH_Status__c'){
			options.add('Active');
			options.add('Inactive');
		}
	   
		else{
			for (Schema.PicklistEntry f : pick_list_values) {
				options.add(f.getLabel());
			}
		}
		system.debug('Options: ' + options);
		return options;
	}
	
  /****************************************
* Created By : Sonia
* Description : This method is used to get all picklist options related
to the Address fields ( city or State/Province ) from that current contractLineItemId
*****************************************/   
   
	public static List<String> getAddressesOptions(String contractLineItemId, String field){
		set<string> accountId = new set<string> ();
		String productId = null;
		String Country = null;
		String pVariant = null;
		String solution = null;
		List<ContractLineItem> objContractLineItem = [select id ,  Asset.CH_Solution__c,Asset.CH_ProductVariant__c, Asset.Product2Id,ASset.CH_CountryISO2__c, 
													  AssetId, Asset.CH_ProductRelease__c, ServiceContractId ,
													  ServiceContract.AccountId from ContractLineItem where
													  id =:contractLineItemId];
		for(ContractLineItem cli :objContractLineItem){
			if(cli.ServiceContractId !=null){
				accountId.add(cli.ServiceContract.AccountId);
			}
			productId = cli.Asset.Product2Id;
			Country = cli.Asset.CH_CountryISO2__c;
			pVariant = cli.Asset.CH_ProductVariant__c;
			solution = cli.Asset.CH_Solution__c;
		} 
		system.debug('productId '+productId); 
		system.debug('Country '+Country); 
		system.debug('pVariant '+pVariant); 
		system.debug('solution '+solution); 
		system.debug('accountId '+accountId);
		String query = 'select Id, CH_City__c, CH_State_Province__c, AccountId, CH_ProductRelease__r.Name,CH_ProductRelease__c,CH_ProductVariant__r.Name, CH_ProductVariant__c, CH_Solution__r.Name, CH_Solution__c from Asset where accountId in :accountId  and Product2Id = :productId and CH_CountryISO2__c = :Country ORDER BY '+field;
		system.debug(query); 
		List<Asset> coveredNEAList = database.query(query);
		system.debug(field+'coveredNEAList -->'+coveredNEAList);
		Set<String> stringAddresses = new Set<String>();
		for(Asset nea :  coveredNEAList){
			if(field.equals('CH_City__c') && nea.CH_City__c!=null){
				stringAddresses.add(nea.CH_City__c);
			}
			if (field.equals('CH_State_Province__c')){
				if(nea.CH_State_Province__c!=null){
					stringAddresses.add(nea.CH_State_Province__c);
				}
			}
			if(field.equals('CH_ProductRelease__r.Name') && nea.CH_ProductRelease__c!=null){
				stringAddresses.add(nea.CH_ProductRelease__r.Name);
			}
			if(field.equals('CH_ProductVariant__r.Name') && nea.CH_ProductVariant__c!=null){
				stringAddresses.add(nea.CH_ProductVariant__r.Name);
			}
			if(field.equals('CH_Solution__r.Name') && nea.CH_Solution__c!=null){
				stringAddresses.add(nea.CH_Solution__r.Name);
			}
		}
		List<String> returnList = new List<String>();
		returnList.addAll(stringAddresses);
		return returnList;
	}
  /****************************************
* Created By : Rajeshwari
* Description : ASsign Selected Fiter option to Wrapper Variable
*****************************************/ 
	public static CH_NetworkElementAssetWrapper.FilterSelectionWrapper assignFilterFieldDetails(String fieldLabel, String fieldAPIName, Boolean isPickValue, List<String> fieldAPISet, 
																								List<String> pickValueOperator, List<String> otherOperator,  List<string> fieldSet, 
																								Boolean isChanged, String contractLineItemId){
		system.debug('assignFilterFieldDetails Method starts here');
		CH_NetworkElementAssetWrapper.FilterSelectionWrapper objFilterDetails = new CH_NetworkElementAssetWrapper.FilterSelectionWrapper();
		objFilterDetails.fieldAPI = fieldAPIName;
		objFilterDetails.fieldName = fieldLabel;
		objFilterDetails.isPickValue = isPickValue; 
		objFilterDetails.isNew = false;																						   
		if(isPickValue){
			system.debug('fieldAPIName -->'+fieldAPIName);
			if(fieldAPIName!='CH_City__c' && fieldAPIName!='CH_State_Province__c' && fieldAPIName !='CH_ProductVariant__r.Name' && fieldAPIName !='CH_Solution__r.Name' &&
			   fieldAPIName !='CH_ProductRelease__r.Name'){
				if(fieldAPIName == 'CH_Status__c'){
					objFilterDetails.picklistValue = getPicklistOptions(fieldAPIName, 'CH_CoveredNetworkElementAsset__c');}
				else{
					objFilterDetails.picklistValue = getPicklistOptions(fieldAPIName, 'Asset');}
			}
			else{				
				objFilterDetails.picklistValue = getAddressesOptions(contractLineItemId, fieldAPIName);
				
			}
		}																							 
		objFilterDetails.fieldValue = null;
		
		objFilterDetails.isSelected = false; 
		if(isPickValue){
			objFilterDetails.operators = pickValueOperator;
		}elsE{
			objFilterDetails.operators = otherOperator;
		}
		objFilterDetails.fieldList = fieldSet;
	   
		system.debug('assignFilterFieldDetails Method ends here'+objFilterDetails);
		return objFilterDetails;
	}
	
	
	  /****************************************
* Created By : Rajeshwari
* Description : Gets query Operators
*****************************************/ 
	public static  map<String,string> getQueryOperator(){
		map<String,string> operator = new map<String,string>();
		operator.put('Equal','=');
		operator.put('Contains','LIKE');
		operator.put('Not Equal','!=');
		return operator;
	}
	  /****************************************
* Created By : Rajeshwari
* Description : API Name for Fields
*****************************************/ 
	public static  map<String,string> getAPINameForDataTable(){
		map<String,string> fieldName = new map<String,string>();
		fieldName.put('AssetNID','CH_NetworkElementAsset__r.CH_NetworkElementID__c');
		fieldName.put('AssetName','CH_NetworkElementAsset__r.Name');
		fieldName.put('AssetStatus','CH_NetworkElementAsset__r.CH_Status__c');
	 //   fieldName.put('AssetCity','CH_NetworkElementAsset__r.CH_City__c');
	 //   fieldName.put('AssetState','CH_NetworkElementAsset__r.CH_State_Province__c');
		fieldName.put('AssetAddressDetails','CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c');
	 //   fieldName.put('AssetStreet','CH_NetworkElementAsset__r.Address__r.Street');
		fieldName.put('LabEnvironment','CH_NetworkElementAsset__r.CH_LabEnvironment__c');
		fieldName.put('AssetProduct','CH_NetworkElementAsset__r.Product2.Name');
		fieldName.put('AssetSolution','CH_NetworkElementAsset__r.CH_Solution__r.Name');
		fieldName.put('AssetProductVariant','CH_NetworkElementAsset__r.CH_ProductVariant__r.Name');
		fieldName.put('AssetProductRelease','CH_NetworkElementAsset__r.CH_ProductRelease__r.Name');
		fieldName.put('NEAStatus','CH_NetworkElementAsset__r.Status');
		return fieldName;
	}
	  /****************************************
* Created By : Rajeshwari
* Description : get ServiceClassificationType from ContractLineItem
*****************************************/ 
	public static ContractLineItem getServiceClassificationType(String contractLineItemId){
		string clType = null;
		return [select id,  CH_ServiceClassification__c, ServiceContract.CH_ServiceContractType__c from ContractLineItem where id =:contractLineItemId limit 1];
	}
	
	/****************************************
* Created By : Rajeshwari
* Description : Assign Picklist value for Release/Solution/Varian during Filter
*****************************************/ 
	public static CH_NetworkElementAssetWrapper.AssetPagerWrapper  assignPicklistValue(CH_NetworkElementAssetWrapper.AssetPagerWrapper obj){
		obj.releaseValue = new set<String>();
		obj.solutionValue = new set<String>();
		obj.variantValue = new set<String>();
		if(obj.networkEleAssests !=null && !obj.networkEleAssests.isempty()){
			for( CH_CoveredNetworkElementAsset__c cnea : obj.networkEleAssests){
				if(cnea.CH_NetworkElementAsset__r !=null){
					system.debug('--> PR'+cnea.CH_NetworkElementAsset__r.CH_ProductRelease__c);
					if(cnea.CH_NetworkElementAsset__r.CH_ProductRelease__c !=null){
						obj.releaseValue.add(cnea.CH_NetworkElementAsset__r.CH_ProductRelease__r.Name);
					}
					 system.debug('--> Solution'+cnea.CH_NetworkElementAsset__r.CH_Solution__c);
					if(cnea.CH_NetworkElementAsset__r.CH_Solution__c !=null){
						 system.debug('--> Solution 2'+cnea.CH_NetworkElementAsset__r.CH_Solution__c);
						obj.solutionValue.add(cnea.CH_NetworkElementAsset__r.CH_Solution__r.Name);
					}
					 system.debug('--> CH_ProductVariant__c'+cnea.CH_NetworkElementAsset__r.CH_ProductVariant__c);
					if(cnea.CH_NetworkElementAsset__r.CH_ProductVariant__c !=null){
						obj.variantValue.add(cnea.CH_NetworkElementAsset__r.CH_ProductVariant__r.Name);
					}
				}
			}
		}
		return obj;
	}
	
	public static CH_NetworkElementAssetWrapper.AssetPagerWrapper  assignPicklistValueForasset(CH_NetworkElementAssetWrapper.AssetPagerWrapper obj){
		obj.releaseValue = new set<String>();
		obj.solutionValue = new set<String>();
		obj.variantValue = new set<String>();
		if(obj.oAssets !=null && !obj.oAssets.isempty()){
			for( Asset cnea : obj.oAssets){
				if(cnea !=null){
					if(cnea.CH_ProductRelease__c !=null){
						obj.releaseValue.add(cnea.CH_ProductRelease__r.Name);
					}
					
					if(cnea.CH_Solution__c !=null){
						 
						obj.solutionValue.add(cnea.CH_Solution__r.Name);
					}
				   
					if(cnea.CH_ProductVariant__c !=null){
						obj.variantValue.add(cnea.CH_ProductVariant__r.Name);
					}
				}
			}
		}
		system.debug(' ProductRelease -->'+obj.releaseValue);
		system.debug(' ProductVariant -->'+obj.variantValue);
		system.debug(' Solution -->'+obj.solutionValue);
		return obj;
	}
	
	
	
}