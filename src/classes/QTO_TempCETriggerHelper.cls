/*
Name - QTO_TempCETriggerHelper
Test Class - QTO_TempCETriggerTest
Used by - QTO_TempCETriggerHandler, QTO_TempCETrigger
Created - Neeharika Upadrasta, Nokia, Oct/12/2020
Purpose - To create Commercial Entitlement records from Temp CE objects. As soon as Temp CE records are uploaded by users, this trigger upserts CE
		  records with either insert new values or update existing records based on Sold-To-Party & Product Code combination
Change Description - 
*/
public with sharing class QTO_TempCETriggerHelper {

	public void insertCommercialEnts(List<QTO_Temp_CE__c> tempCEList){
		
		Set<String> accountNums = new Set<String>();
		Set<String> productCodes = new Set<String>();
		Map<String, Account> accountNumToIdMap = new Map<String, Account>();
		Map<String, Id> productNumToIdMap = new Map<String, Id>();
		List<Commercial_Entitlement__c> commEntList = new List<Commercial_Entitlement__c>();
		
		//Get Account numbers of Importer, End User and Sold To Party accounts. Also get product codes for querying product Ids
		for(QTO_Temp_CE__c tempCE : tempCEList){
			accountNums.add(tempCE.QTO_EndUser__c);
			accountNums.add(tempCE.QTO_Importer__c);
			accountNums.add(tempCE.QTO_SoldToParty__c);
			productCodes.add(tempCE.QTO_ProductCode__c);
		}
		
		if(accountNums.size() > 0){
			for(Account acc : [Select Id,Acc_No__c,ParentId from Account where Acc_No__c in: accountNums]){
				accountNumToIdMap.put(acc.Acc_No__c, acc);
			}
		}
		
		if(productCodes.size() > 0){
			for(Product2 prod : [Select Id,ProductCode from Product2 where ProductCode in: productCodes]){
				productNumToIdMap.put(prod.ProductCode, prod.Id);
			}
		}
		
		//Only create Commercial Entitlements if there are valid Accounts and Products associated with data uploaded by users.
		if(!accountNumToIdMap.isEmpty() && (!productNumToIdMap.isEmpty())){
			
			String prodCodeSoldTo = '';
			Commercial_Entitlement__c newCE = new Commercial_Entitlement__c();
			Map<String,Commercial_Entitlement__c> productCodeToCEMap = new Map<String,Commercial_Entitlement__c>();
			
			//Create a map for each unique combination of Product Code and Sold To Party
			for(Commercial_Entitlement__c existingCE : [Select Id,Product_Code__c,Sold_To_Party__r.Acc_No__c
														from Commercial_Entitlement__c 
														where Product_Name__c in: productNumToIdMap.values()
														and Sold_To_Party__c in: accountNumToIdMap.values()]){
				productCodeToCEMap.put(existingCE.Product_Code__c+'-'+existingCE.Sold_To_Party__r.Acc_No__c,existingCE);											   
			}
			
			for(QTO_Temp_CE__c tempCE : tempCEList){				
				prodCodeSoldTo = tempCE.QTO_ProductCode__c+'-'+tempCE.QTO_SoldToParty__c;
				//If Product Code-Sold To Party combination exists, update the existing Commercial Entitlement
				if(productCodeToCEMap.containsKey(prodCodeSoldTo)){
					newCE = productCodeToCEMap.get(prodCodeSoldTo);
					newCE.Authorised_Quantity__c = tempCE.QTO_Authorized_Quantity__c;
					newCE.QTO_Comments__c = tempCE.QTO_Comments__c;
					newCE.Entitlement_Start_Date__c = tempCE.QTO_EntitlementStartDate__c;
					newCE.Entitlement_End_Date__c = tempCE.QTO_EntitlementEndDate__c;
					newCE.QTO_End_User__c = accountNumToIdMap.get(tempCE.QTO_EndUser__c).Id;
					newCE.QTO_Importer_of_Record__c = accountNumToIdMap.get(tempCE.QTO_Importer__c).Id;
					newCE.QTO_Send_to_SWMP__c = true;
					newCE.Status__c = 'Entitled';
					commEntList.add(newCE);
				} 
				else{ //If it doesn't exist, insert a new Commercial Entitlement
					//Only insert a new record if Sold To and Product Code are valid
					if(accountNumToIdMap.containsKey(tempCE.QTO_SoldToParty__c) && productNumToIdMap.containsKey(tempCE.QTO_ProductCode__c)){
						newCE = new Commercial_Entitlement__c(Authorised_Quantity__c = tempCE.QTO_Authorized_Quantity__c,
														  QTO_Comments__c = tempCE.QTO_Comments__c,
														  Entitlement_Start_Date__c = tempCE.QTO_EntitlementStartDate__c,
														  Entitlement_End_Date__c = tempCE.QTO_EntitlementEndDate__c,
														  QTO_End_User__c = accountNumToIdMap.get(tempCE.QTO_EndUser__c).Id,
														  QTO_Importer_of_Record__c = accountNumToIdMap.get(tempCE.QTO_Importer__c).Id,
														  Parent_Account__c = accountNumToIdMap.get(tempCE.QTO_SoldToParty__c).Id,
														  Product_Name__c = productNumToIdMap.get(tempCE.QTO_ProductCode__c),
														  Sold_To_Party__c = accountNumToIdMap.get(tempCE.QTO_SoldToParty__c).Id,
														  QTO_Send_to_SWMP__c = true,
														  Status__c = 'Entitled');
						commEntList.add(newCE);
					}
					else{
						tempCE.addError('Please check Account Numbers and/or Product Codes');
					}
				}
			}			
			if(commEntList.size() > 0)
				upsert commEntList;
		}
		else{
			tempCEList[0].addError('Please check Account Numbers and/or Product Codes');
		}	 
	}
	
	public void deleteOldTempCE(List<QTO_Temp_CE__c> tempCEList){
		List<QTO_Temp_CE__c> oldTempCEs = new List<QTO_Temp_CE__c>([Select Id from QTO_Temp_CE__c Where Id NOT IN: tempCEList]);
		
		if(oldTempCEs.size() > 0){
			delete oldTempCEs;
		}
	}   
}