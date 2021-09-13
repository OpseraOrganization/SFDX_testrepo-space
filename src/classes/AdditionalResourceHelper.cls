/**
* @description: Trigger helper to Update Additional Resource Record
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  Sonali Kothavale		  13.dec/2017   Sprint 2 Rel 3.1
* ============================================================================ 
*/
public class AdditionalResourceHelper{
/*******************************
*Method name: additionalResourceAccount
*Description: This Method will update Account on Additional Resource
*Parameter: 
*******************************/ 
	public static void additionalResourceAccount(List<Additional_Resource_Request__c> addResList){
   
		map<String, String> arrContact = new map<String, String>();
		map<id,id> userContactMap = new map<id,id>();
		map<String, String> conAcc= new map<String, String>();
		List<Additional_Resource_Request__c> updateARR = new list<Additional_Resource_Request__c>();
		List<Additional_Resource_Request__c> addRes= [select id,Partner_User__c, Partner_Contact__c from Additional_Resource_Request__c where Id In : addResList Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		set<id> contactyId = new set<ID> ();
		try{
		for(Additional_Resource_Request__c arr: addRes){
			contactyId.add(arr.Partner_Contact__c);
		}
		for(Additional_Resource_Request__c addRR : addRes){
		arrContact.put(addRR.ID, addRR.Partner_Contact__c);
		}
		for(Contact cont : [select id, accountid from Contact where id in: contactyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		conAcc.put(cont.ID, cont.Accountid);
		}
		for(user user :  [Select id ,ContactId from user where contactId IN:contactyId] ){
			userContactMap.put(user.contactid,user.id);
		}
		for(Additional_Resource_Request__c addRR : addRes){
			addRR.Partner_Account__c= conAcc.get(arrContact.get(addRR.id));
			system.debug('>>>>>>eclipse '+userContactMap.get(arrContact.get(addRR.id)));
			addRR.Partner_User__c = userContactMap.get(arrContact.get(addRR.id));
			updateARR.add(addRR);
		 }
			system.debug('updateARR'+updateARR);
		 database.update(updateARR);
		 }catch(Exception e) {
					ExceptionHandler.addException(e,PRMGlobalConstants.AdditionalResourceHelper,PRMGlobalConstants.additionalResourceAccount);	   
							 }
	 }
	
}