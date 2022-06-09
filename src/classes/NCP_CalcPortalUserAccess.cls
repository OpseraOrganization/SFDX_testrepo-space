public without sharing class NCP_CalcPortalUserAccess {

	@AuraEnabled
	public static sharingWrapper fetchData() {

		String userInfo = UserInfo.getUserId();

		//Account Sharing, Contact Sharing, Service Contract Sharing and Authorized Entitlement Sharing) for list of records that user is associated with.

		List<AccountShare> accountShareList = [SELECT ID,AccountId, UserOrGroupId FROM AccountShare WHERE UserOrGroupId = :userInfo];
		List<ContactShare> contactShareList = [SELECT ID,ContactId, UserOrGroupId FROM ContactShare WHERE UserOrGroupId = :userInfo];
		List<ServiceContractShare> serviceContractShareList = [SELECT ID,ParentId, UserOrGroupId FROM ServiceContractShare WHERE UserOrGroupId = :userInfo];
		List<NCP_Authorised_Entitlement__Share> autorisedEntitlemtShareList = [SELECT ID,ParentId, UserOrGroupId FROM NCP_Authorised_Entitlement__Share WHERE UserOrGroupId = :userInfo];

		List<Id> accountIdList = new List<Id>();
		List<Id> contactIdList = new List<Id>();
		List<Id> serviceContractIdList = new List<Id>();
		List<Id> autorisedEntitlemtIdList = new List<Id>();

		for(AccountShare single :  accountShareList){
			Id accId =  single.AccountId;
			accountIdList.add(accId);
		}
		for(ContactShare single :  contactShareList){
			Id contact =  single.ContactId;
			contactIdList.add(contact);
		}
		for(ServiceContractShare single :  serviceContractShareList){
			Id contact =  single.ParentId;
			serviceContractIdList.add(contact);
		}
		for(NCP_Authorised_Entitlement__Share single :  autorisedEntitlemtShareList){
			Id contact =  single.ParentId;
			autorisedEntitlemtIdList.add(contact);
		}

		List<account> accountList = [SELECT Id,Name FROM Account Where Id IN : accountIdList];
		List<Contact> contactList = [SELECT Id,Name FROM Contact Where Id IN : contactIdList];
		List<ServiceContract> serviceContractList = [SELECT Id,Name FROM ServiceContract Where Id IN : serviceContractIdList];
		List<NCP_Authorised_Entitlement__c> autorisedEntitlemtList = [SELECT Id,Name,NCP_Account__r.Name,NCP_Contact__r.Name,NCP_Service_Contract__r.Name,NCP_Contract_Line_Item__c
		FROM NCP_Authorised_Entitlement__c Where Id IN : autorisedEntitlemtIdList];

		sharingWrapper userSharing = new sharingWrapper();
		userSharing.userId = userInfo;
		userSharing.accountShareList = accountList;
		userSharing.contactShareList = contactList;
		userSharing.serviceContractList = serviceContractList;
		userSharing.autorisedEntitlemtList = autorisedEntitlemtList;

		return userSharing;
	}

	public class sharingWrapper {
		@AuraEnabled
		String userId { get; set; }
		@AuraEnabled
		List<account> accountShareList { get; set; }
		@AuraEnabled
		List<Contact> contactShareList { get; set; }
		@AuraEnabled
		List<ServiceContract> serviceContractList { get; set; }
		@AuraEnabled
		List<NCP_Authorised_Entitlement__c> autorisedEntitlemtList{ get; set; }
	}

}