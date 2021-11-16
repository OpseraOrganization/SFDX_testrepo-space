/***********************************************
*	Class Name : AccountMovementHandler
*	Created By : Accenture IDC
*	Created Date :14/Dec/2016
*	Description : it will Run when Account will be added or removed from territory


*********************************************/
public with sharing  class AccountMovementHandler {
 /****************************************
	*Method Name: afterInsert
	*Description: This will handle the methods from AccountMovementHelper that will fire after Insert
	*Parameters: objectTerritoryAssociationList
	*****************************************/
  /*  public static void afterUpdate(Map<id,Account> accountOldMap, Map<id,Account> accountNewMap){
		List<Account> accAdditionList = new List<Account>();
		List<Account> accRemovalList = new List<Account>();
		List<Account> accNewList = new List<Account>();
		List<Account> accOldList = new List<Account>();
		Map<id,Account> accountMapNew = new Map<id,Account>();
		Map<id,Account> accountMapOld = new Map<id,Account>();
		Map<id,Account> accountMapNsaNew = new Map<id,Account>();
		Map<id,Account> accountMapNonNsaOld = new Map<id,Account>();
		for(id accId : accountOldMap.Keyset()){
			if(accountOldMap.get(accId).L7ID__c != accountNewMap.get(accId).L7ID__c){
				if(accountOldMap.get(accId).L7ID__c == Null && accountNewMap.get(accId).L7ID__c != Null){
					accAdditionList.add(accountNewMap.get(accId));
				} else if(accountOldMap.get(accId).L7ID__c != Null && accountNewMap.get(accId).L7ID__c == Null){
					accRemovalList.add(accountOldMap.get(accId));
				} else if(!((accountOldMap.get(accId).Customer_Compliance__c == null || accountOldMap.get(accId).Customer_Compliance__c == 'Unassigned') && 
					(accountNewMap.get(accId).Customer_Compliance__c != null && accountNewMap.get(accId).Customer_Compliance__c != 'Unassigned')) && 
					(accountOldMap.get(accId).L7ID__c != Null && accountNewMap.get(accId).L7ID__c != Null)){
						
					accountMapNew.put(accId,accountNewMap.get(accId));
					accountMapOld.put(accId,accountOldMap.get(accId));
				} else if((accountOldMap.get(accId).Customer_Compliance__c == null || accountOldMap.get(accId).Customer_Compliance__c == 'Unassigned') && 
					(accountNewMap.get(accId).Customer_Compliance__c != null && accountNewMap.get(accId).Customer_Compliance__c != 'Unassigned') && 
					(accountOldMap.get(accId).L7ID__c != Null && accountNewMap.get(accId).L7ID__c!= Null)){
						
					accountMapNsaNew.put(accId,accountNewMap.get(accId));
					accountMapNonNsaOld.put(accId,accountOldMap.get(accId));
				}
			}
		}
		if( !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){ 
			system.debug('accAdditionList>>>' +accAdditionList);
			system.debug('accRemovalList>>>' +accRemovalList);
			system.debug('accountMapNew>>>' +accountMapNew.Values());
			system.debug('accountMapNonNsaOld>>>' +accountMapNonNsaOld.Values());
			if(!accountMapNonNsaOld.Values().IsEmpty()){
				AccountMovementHelper.accountMovementNonNsa_Nsa(accountMapNonNsaOld,accountMapNsaNew);
			}
			if(!accountMapNew.Values().IsEmpty()){
				AccountMovementHelper.batch_AccountMovementOfTerritory(accountMapOld,accountMapNew);
			}
			if(!accAdditionList.IsEmpty()){
				AccountMovementHelper.batch_AccountAdditionToTerritory(accAdditionList);
			}
			if(!accRemovalList.IsEmpty()){
				AccountMovementHelper.batch_AccountRemovalFromTerritory(accRemovalList);
			}
			
		}
	}
*/
}