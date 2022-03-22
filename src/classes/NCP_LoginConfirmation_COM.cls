/**	
About   
-----
Description: Controller for the product landing page component

Created for: Nokia Customer Portal 
Created date: 12 18 2017

Update History	
--------------	
Created: 12 18 2017 – AES 

Issues / TODOs  
--------------
**/
public with sharing class NCP_LoginConfirmation_COM {
	
	/*
* @description	  gets the companies related to the user email
* @param			email related to the connected user
* @return		   list of company name
*/
	@AuraEnabled 
	public static Map<String,String> getAccounts() {
		system.debug('### AES getUserEmail '+UserInfo.getUserEmail());
		String emailString = '%'+UserInfo.getUserEmail().split('@').get(1);
		Map<String,String> companyMap = new Map<String,String>();
		/*Set<Id> accIdSet = new Set<Id>();
		// get the accounts
		for(NCP_Email_To_Company__c email:[Select id,NCP_Account__c From NCP_Email_To_Company__c Where NCP_Email_Domain__c like :emailString]){
			accIdSet.add(email.NCP_Account__c);
		}		
		system.debug('### AES accIdSet '+accIdSet);
		for(Account acc:[Select id,Name From Account where id IN:accIdSet]){
			companyMap.put(acc.id,acc.Name);
		}*/
		system.debug('### AES companyMap '+companyMap);
		return companyMap;
	}
	/*
* @description	  relates user to the selected company
* @param			the account name 
* @return		   
*/
	/*@AuraEnabled 
	public static void saveUser(String companyName, User userData) {
		system.debug('### AES userData '+userData);
		User connectedUser = [select id,AccountId,contactId from user where Id =:UserInfo.getUserId()];
		Integer HorizontalUserCount =[Select count() from user where NCP_IsHorizontal__c = true and AccountId  =:connectedUser.AccountId];
		Account acc = [Select id,Name From Account where Name=:companyName];
		Contact contact = [Select AccountId from Contact where Id =:connectedUser.contactId];
		contact.AccountId = acc.id;
		system.debug('### AES contact '+contact);
		//connectedUser.NCP_Require_Training__c = userData.NCP_Require_Training__c;
		//if (userData.NCP_Relationship__c != '') connectedUser.NCP_Relationship__c = userData.NCP_Relationship__c;
		
		if (HorizontalUserCount <= 20) {
			connectedUser.NCP_IsHorizontal__c = userData.NCP_IsHorizontal__c;
			connectedUser.NCP_Horizontal_Company_Name__c = userData.NCP_Horizontal_Company_Name__c;
		}
		
		update connectedUser;
		update contact;
		
		
	}*/
	
	@AuraEnabled
	public static List < String > getselectOptions() {
		List < String > allOpts = new list < String > ();
		// Get the object type of the SObject.
		Schema.sObjectType objType = user.getSObjectType();
		
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		
		// Get a map of fields for the SObject
		map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
		
		// Get the list of picklist values for this field.
		list < Schema.PicklistEntry > values =
			fieldMap.get('NCP_Relationship__c').getDescribe().getPickListValues();
		
		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a: values) {
			allOpts.add(a.getValue());
		}
		
		//allOpts.sort();
		return allOpts;
	}
	
	@AuraEnabled 
	public static List<Boolean> validateHorizontalUser(String companyName) {
		List<Boolean> results = new List<Boolean>();
		if(!String.isBlank(companyName)){
			Account acc = [Select Id From Account where Name=:companyName];

			/*List<NCP_Email_To_Company__c> etd = [SELECT NCP_Email_Domain__c, NCP_Account__c FROM NCP_Email_To_Company__c WHERE NCP_Account__c=:acc.Id AND NCP_Email_Domain__c IN:domains];
			if(etd.size() > 0) {
				results.add(true); 
			} 
			*/
			Integer HorizontalUserCount =[Select count() from user where NCP_IsHorizontal__c = true and AccountId  =:acc.Id];
			system.debug('### ABO HorizontalUserCount : '+HorizontalUserCount);
			if (HorizontalUserCount >= 20) {
				results.add(true);
			}else{
				results.add(false); 
			}
			
		}
		return results;
	}
	
}