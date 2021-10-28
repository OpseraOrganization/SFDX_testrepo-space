public class CH_LegalEntitesController {
	
	@AuraEnabled
	public static List<EntitlementContact> getContactList(Id recordId) {
		if(String.isBlank(recordId)) {
			return null;			 
		}
		return [SELECT Id, EntitlementId, Entitlement.Account.Name, Entitlement.Account.AccountNumber, Entitlement.ServiceContract.Name FROM EntitlementContact WHERE ContactId= : recordId];
	}

}