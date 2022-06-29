/***************************************
* Class Name : HWS_RetrofitAccountHelper 
* Created Date: 29 June 2021
* Description : Helper class for HWS_RetrofitAccountHandler
*****************************************/
public without sharing class HWS_RetrofitAccountHelper {
	/*******************************************************
	* Method Name : checkDuplicateAccountServiceContract 
	* Description : checks for duplicate record entry for 
	*		Account-Service Contract combination
	*********************************************************/
	public static void checkDuplicateAccountServiceContract(Map<Id,HWS_RetrofitAccount__c> oldMap,List<HWS_RetrofitAccount__c> newList){
		Set<String> accountIdSet= new Set<String>();
		Set<String> serviceContractIdSet= new Set<String>();
		Set<String> existingAccServiceContractSet = new Set<String>();
		for(HWS_RetrofitAccount__c retAcc : newList){
			if(oldMap != null){
				if(retAcc.HWS_Account__c != oldMap.get(retAcc.Id).HWS_Account__c || retAcc.HWS_ServiceContract__c != oldMap.get(retAcc.Id).HWS_ServiceContract__c){
					accountIdSet.add(retAcc.HWS_Account__c);
					serviceContractIdSet.add(retAcc.HWS_ServiceContract__c);
				}
			}
			else{
				accountIdSet.add(retAcc.HWS_Account__c);
				serviceContractIdSet.add(retAcc.HWS_ServiceContract__c);
			}
			
		}
		//fetch the existing records
		for(HWS_RetrofitAccount__c existRec : [SELECT Id,HWS_Account__c,HWS_ServiceContract__c FROM HWS_RetrofitAccount__c
														   WHERE HWS_Account__c IN:accountIdSet OR  HWS_ServiceContract__c IN:serviceContractIdSet]){
			existingAccServiceContractSet.add(existRec.HWS_Account__c+'-'+existRec.HWS_ServiceContract__c);
		}
		//check if combination exists, if yes display error
		if(!existingAccServiceContractSet.isEmpty()){
			for(HWS_RetrofitAccount__c retroAcc : newList){
				String accContractCombo = retroAcc.HWS_Account__c+'-'+retroAcc.HWS_ServiceContract__c;
				if(existingAccServiceContractSet.contains(accContractCombo)){
					retroAcc.addError(System.Label.HWS_Duplicate_Retrofit_Record_Error);
				}
			}
		}
	}
	/*******************************************************
	* Method Name : updateShipToCountry 
	* Description : checks if legal Account country is present 
	* 	in Ship To Country field. If not, add to Ship To Country
	*********************************************************/
	public static void updateShipToCountry(List<HWS_RetrofitAccount__c> newList){
		Map<Id,String> legalAccCountryMap = new Map<Id,String>();
		Map<Id,String> contractRetrofitTypeMap = new Map<Id,String>(); //added for NOKIASC-37155
		Set<String> accountIdSet= new Set<String>();
		Set<String> contractIdSet= new Set<String>(); //added for NOKIASC-37155
		for(HWS_RetrofitAccount__c retAcc : newList){
			accountIdSet.add(retAcc.HWS_Account__c);
			contractIdSet.add(retAcc.HWS_ServiceContract__c);
		}
		List<Account> legalAccList = [SELECT Id,Country__c,(SELECT Id,CH_CountryName__c,HWS_Retrofit_Type__c FROM ServiceContracts) FROM Account WHERE Id IN :accountIdSet];
		List<ServiceContract> serContractLst =[SELECT Id,AccountId,CH_CountryName__c,HWS_Retrofit_Type__c FROM ServiceContract WHERE Id IN :contractIdSet];
		if(!legalAccList.isEmpty()){
			for(Account acc : legalAccList ){
				legalAccCountryMap.put(acc.Id,acc.Country__c);
			}
		}
		//added for NOKIASC-37155 -- START
		if(!serContractLst.isEmpty()){
			for(ServiceContract sc : serContractLst){
				contractRetrofitTypeMap.put(sc.Id,sc.HWS_Retrofit_Type__c);
				legalAccCountryMap.put(sc.Id,sc.CH_CountryName__c);
			}
		}
		//added for NOKIASC-37155 -- END
		for(HWS_RetrofitAccount__c retroAcc : newList){			
			//added for NOKIASC-37155 -- START
			if(contractRetrofitTypeMap.get(retroAcc.HWS_ServiceContract__c) == 'Local Retrofit' && (retroAcc.HWS_ShipToCountry__c != null && 
			(!retroAcc.HWS_ShipToCountry__c.contains(legalAccCountryMap.get(retroAcc.HWS_ServiceContract__c))
				|| retroAcc.HWS_ShipToCountry__c.split(';').size() > 1))){
				retroAcc.addError(System.Label.HWS_SoldToCountry_Validation_Msg);
			}
			//added for NOKIASC-37155 -- END
			if(retroAcc.HWS_ShipToCountry__c != null ){
				if(!retroAcc.HWS_ShipToCountry__c.contains(legalAccCountryMap.get(retroAcc.HWS_Account__c))){
					retroAcc.HWS_ShipToCountry__c += ';'+legalAccCountryMap.get(retroAcc.HWS_Account__c);
				}
			}
			else{
				retroAcc.HWS_ShipToCountry__c = legalAccCountryMap.get(retroAcc.HWS_Account__c);
			}
		}
	}
}