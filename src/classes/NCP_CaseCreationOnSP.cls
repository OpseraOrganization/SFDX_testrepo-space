/**	
About   
-----
Description: Checks if the Support tiles should be visible for external users based on CARES contract conditions
Created for: Nokia Customer Portal 
Created date: 06-04-2021

Details / Methods   
-----------------	

Update History	
--------------	
Created: 06-04-2021 
Updated: N/A

Issues / TODOs  
--------------
**/
public without sharing class NCP_CaseCreationOnSP {
	//Checks if the user is authorized to view 'Create software support ticket' and 'Create Hardware support ticket' tiles on Services tab
	public static List<List<EntitlementContact>> checkforCHTileDisplay(User usr){
		List <List<EntitlementContact>> entldContactsCHList = new List<List<EntitlementContact>>();
		List<EntitlementContact> entldContactsSWS = new List<EntitlementContact>();
		List<EntitlementContact> entldContactsHWS = new List<EntitlementContact>();
		Id userContactId = usr.contactId;
		
		List<EntitlementContact> entldContacts = [SELECT Id,Entitlement.ServiceContract.CH_PortalCaseCreationSWMaintenance__c,Entitlement.ServiceContract.CH_PortalCaseCreationHWS__c FROM EntitlementContact WHERE (ContactId =: userContactId
																																																					 AND Entitlement.ServiceContract.Status = 'Active' AND Entitlement.ServiceContract.NCP_External_Status__c = 'Active') AND (Entitlement.ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true OR Entitlement.ServiceContract.CH_PortalCaseCreationHWS__c = true)];
		for(EntitlementContact ec : entldContacts){
			if(ec.Entitlement.ServiceContract.CH_PortalCaseCreationSWMaintenance__c == true)
				entldContactsSWS.add(ec);
			if(ec.Entitlement.ServiceContract.CH_PortalCaseCreationHWS__c == true) 
				entldContactsHWS.add(ec);
		}
		System.debug('entldContactsSWS list equals' +entldContactsSWS);
		System.debug('entldContactsHWS list equals' +entldContactsHWS);		
		entldContactsCHList.add(entldContactsSWS);
		entldContactsCHList.add(entldContactsHWS);
		
		return entldContactsCHList;
	}
	//Checks if the user is authorized to view 'Create software support ticket' link on Product detail page
	public static Boolean isSWSEntitledOnProduct(Id prId)
	{		
		String userId = System.UserInfo.getUserId();
		User userInfo = [select id, contactId from User where id =:userId];
		List<List<EntitlementContact>> entContacts = checkforCHTileDisplay(userInfo);   
		Boolean isSWSEntitled = false;
		Set<ID> scid = new Set<ID>();
		if(entContacts[0].size()>0){
			for(EntitlementContact ec : entContacts[0])
			{
				scid.add(ec.Entitlement.ServiceContractId);
			}
			System.debug('Service contract id is ' +scid);
			System.debug('prid is ' +prId);
			for(Entitlement e : [SELECT Id,ContractLineItem.Product2Id,ContractLineItem.NCP_External_Status__c,ContractLineItem.Status,ContractLineItem.CH_ServiceClassification__c FROM Entitlement WHERE ServiceContract.ID IN :scid AND Name != 'Authorized Contact']){
				if(e.ContractLineItem.Product2Id == prId && e.ContractLineItem.NCP_External_Status__c == 'Active' && e.ContractLineItem.Status == 'Active' && e.ContractLineItem.CH_ServiceClassification__c == 'SW Maintenance'){
					isSWSEntitled = true;
					break;
				}
			}
		}
		return isSWSEntitled;
	}
	
}