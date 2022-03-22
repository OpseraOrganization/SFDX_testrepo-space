public class CH_CaseTriggerDataProvider {
	private static Map < Id, Contact > contactMap = new Map < Id, Contact > (); 
		
	public static Map < Id, Contact > getContactMap(Set < Id > contactIds) {
		if(contactMap == null || contactMap.isEmpty()) {
			System.debug('### Contact Map Gun Reloaded');
			for(Contact contactObj: Database.query(getContactQuery(contactIds))) {
				contactMap.put(contactObj.Id, contactObj);
			}
		} 
		// Remove all existing entry to avoid querying it again
		contactIds.removeAll(contactMap.keySet());
		// Process ids which is not present in the list
		if(!contactIds.isEmpty()) {
			for(Contact contactObj: Database.query(getContactQuery(contactIds))) {
				contactMap.put(contactObj.Id, contactObj);
			}
		}
		return contactMap;
	}
	
	public static String getContactQuery(Set < Id > contactIds) {
		// **Added account.name for NOKIASC-22365
		return 'SELECT Id, Name, CH_Legal_Entity_Name__c, account.name FROM Contact WHERE Id IN :contactIds'; 
	}
}