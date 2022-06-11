public with sharing class HWS_customLookUpController {

	@AuraEnabled
	public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String contractLineItemId) {
		String parentContractLineItemId;
		String sQuery;
		if (String.isNotBlank(contractLineItemId)) {
			if(contractLineItemId.subString(0,3) == '810') {
				parentContractLineItemId =   contractLineItemId;
			} else {
				parentContractLineItemId = [SELECT ServiceContractId From ContractLineItem WHERE Id=:contractLineItemId].ServiceContractId;	   
			}	
		}
		String searchKey = searchKeyWord + '%';
		
		List < sObject > returnList = new List < sObject > ();
	  
	   // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 
		if (String.isNotBlank(contractLineItemId)) {
			sQuery =  'select Id, Name, HWS_Account__r.Name ,HWS_Status__c from ' +ObjectName + ' where HWS_Status__c= \'Active\' AND  HWS_ServiceContract__c =:parentContractLineItemId AND (HWS_Account__r.Name LIKE: searchKey OR  HWS_Account__r.AccountNumber LIKE: searchKey OR HWS_Account__r.NCP_P20_ID__c LIKE: searchKey ) order by createdDate DESC';	
		} else {
			sQuery =  'select Id, Name, HWS_Account__r.Name ,HWS_Status__c from ' +ObjectName + ' where HWS_Status__c= \'Active\' AND (HWS_Account__r.Name LIKE: searchKey OR  HWS_Account__r.AccountNumber LIKE: searchKey OR HWS_Account__r.NCP_P20_ID__c LIKE: searchKey ) order by createdDate DESC';
		}  

		List < sObject > lstOfRecords = Database.query(sQuery);
		System.debug('lstOfRecords===='+lstOfRecords);
		for (sObject obj: lstOfRecords) {
			returnList.add(obj);
		}
		return returnList;
	}
	@AuraEnabled
	public static List<String> getCountryList(String retroAccountId) {
		List<String> shipToCountryList = new List<String>();
		String shipCountry = [Select HWS_ShipToCountry__c FROM HWS_RetrofitAccount__c WHERE Id =:retroAccountId].HWS_ShipToCountry__c;
		String accountCountry = [SELECT HWS_Account__r.Country__c FROM HWS_RetrofitAccount__c WHERE Id =:retroAccountId].HWS_Account__r.Country__c;
		Set<String> picklistValues = new Set<String>( shipCountry.split(';') );  

		for (String country : picklistValues) {
			shipToCountryList.add(country);	
		}
		if(shipToCountryList.indexOf(accountCountry) > 0){
			shipToCountryList.remove(shipToCountryList.indexOf(accountCountry));
			shipToCountryList.add(0,accountCountry);
		}
		return shipToCountryList;
	}
	
   
}