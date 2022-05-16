/****************************************
* Class Name : CH_CreateNEA_Controller
* Created Date: 31 Oct 2019
* Created By : Prateek Sarangi (prateek.sarangi.ext@nokia.com)
* Description : Controller for Create NEA from CLI component (CH_CreateNEA)
* Test Class: 

Name			Modified DATE	Comments
Rajeshwari		22 Nov	NOKIASC-25121 - Only NE Admin Permission User Should have access to create NEA
Rajeshwari		20 Feb 2019			NOKIASC-25159 - CLI cannot have NEAs linked when Contract type internal or Service Classification blank.
*****************************************/
public with sharing class CH_CreateNEA_Controller {
	
	@AuraEnabled
	public static ContractLineItem getCLIDetails(Id idCLI) {
		try{
			List<ContractLineItem> ContractLineItem = [
	SELECT id, CH_Account__c, Product2Id, CH_CountryISOName__c, CH_ServiceClassification__c,ServiceContract.AccountId, ServiceContract.Account.AccountNumber, Asset.Id,
	Asset.Product2.Name, Asset.Product2.NCP_Nokia_Product_Id__c, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductVariant__r.NCP_Nokia_Product_Id__c,
	Asset.CH_ProductRelease__r.Name, Asset.CH_ProductRelease__r.CH_NSNLegacyCode__c, Asset.CH_Solution__r.Name, Asset.CH_Solution__r.NCP_Nokia_Product_Id__c,
	Asset.Address__c, Asset.CH_CountryISOName__c, Asset.CH_NetworkElementID__c, Asset.CH_LabEnvironment__c 
	FROM ContractLineItem 
	WHERE id = :idCLI
	LIMIT 1
			];
			system.debug(ContractLineItem[0]);
			return (ContractLineItem.isEmpty() ? null : ContractLineItem[0]);
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	
	@AuraEnabled
	public static Id saveNEARecord(Asset asset, Boolean checkbox) {
		String msg ='';
		Id NEARecordType =Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
		
		try{
			// bypass the exception: Cannot specify both an external ID reference Address__r and a salesforce id, Address__c: []
			asset.RecordTypeId = NEARecordType;
			System.debug(asset.CH_CountryISOName__c);
			insert asset;
			
		}
		catch(DmlException e){
			//Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
			//we can get from DmlException			
			//Get All DML Messages
			for (Integer i = 0; i < e.getNumDml(); i++) {
	//Get Validation Rule & Trigger Error Messages
	msg += e.getDmlMessage(i) +  '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(msg);
			
		}
		catch(Exception e){
			throw new AuraHandledException('Something went wrong '+e.getMessage());
		}
		return asset.Id;
	}
	
	/* Modified By - Rajeshwari
Details - NOKIASC-25121 - Only NE Admin Permission User Should have access to create NEA*/
	@Auraenabled
	public static Boolean validatePermissionSet(){
		Boolean hasAccess = false;
		List<PermissionSetAssignment> lstcurrentUserPerSet =	[SELECT Id, PermissionSet.Name,AssigneeId
	 FROM PermissionSetAssignment
	 WHERE AssigneeId = :Userinfo.getUserId() 
	 and PermissionSet.Name ='CH_NEAssetAdmin'  ];
		if( !lstcurrentUserPerSet.isempty() && lstcurrentUserPerSet.size() >0){
			hasAccess = true;
		}
		system.debug('validatePermissionSet -->'+hasAccess);
		return hasAccess;
	} 
	
	
	//suniti- 24906
	//Rajeshwari NOKIASC-25159 Added condition to check CH_InternalCDBServiceType__c
	@Auraenabled
	public static Boolean CheckforButton(Id idCLI){
		Boolean hasAccess = true;
		List<ContractLineItem> CheckFieldValue = [SELECT Id, CH_ServiceType__c,CH_ServiceClassification__c, ServiceContractId, ServiceContract.CH_InternalCDBServiceType__c 
	 FROM ContractLineItem WHERE id = :idCLI];
			
			if (CheckFieldValue.size() > 0 && ((CheckFieldValue[0].CH_ServiceClassification__c == '' || CheckFieldValue[0].CH_ServiceClassification__c == null)
	|| (CheckFieldValue[0].ServiceContractId !=null &&  CheckFieldValue[0].ServiceContract.CH_InternalCDBServiceType__c)))	
			{
	hasAccess = false;  
			}
		return hasAccess;
	}	 
	
	@AuraEnabled
	public static String getAddressCountryName(String addressId) {
		try{
			List<Schema.Address> oAddress = [ select id, country from Address where id =:addressId  ];
			SYSTEM.debug(addressId+' addressId -->'+oAddress);
			return oAddress[0].country;
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	
	@AuraEnabled
	public static SObject getAccountLocation(String accountId, String accountNumber) {
		return [SELECT Id FROM Location WHERE Name = :accountNumber AND CH_AccountName__c = :accountId LIMIT 1];
	}
/****************************************
* Method Name : getCountryName
* Returns : ISO_Country_Codes__c 
* Date : 07/07/2021
* NOKIASC-36196
*****************************************/
	@AuraEnabled
	public static List<ISO_Country_Codes__c> getCountryName(){			
	  return [SELECT Country_Name__c,Name FROM ISO_Country_Codes__c ORDER BY Country_Name__c ] ;	
	}
}