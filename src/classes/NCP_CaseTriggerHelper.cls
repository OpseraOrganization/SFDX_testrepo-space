/****************************************
* Class Name : NCP CaseTriggerHelper
* Created Date: 01 Feb 2020
* Created By : HCL
* Last Modified by: HCL
* Last Modified Date: 01 Feb 2020
* Description : 1. Approve Support Tickets
				2. Send email to Key Users
				3. Update Case Status to Approved			  

 *****************************************/
public without sharing class NCP_CaseTriggerHelper {

	/****************************************
	 * Added by SAlesforce to create case team from service contract
	 *****************************************/

   public static void approveSupportTicket(List<Case> lstCase){

		Map<Id, List<String>> caseEmailList = new Map<Id, List<String>>();
		Map<String, List<String>> mapUser = new Map<String, List<String>>();
		Map<String, String> mapNullKeyUser = new Map<String, String>();
		Map<Id,String> userMap = new Map<Id,String>();
		Map<Id,String> userCountryMap = new Map<Id,String>();
		List<Case> caseUpdateList = new List<Case>();
		Set<Id> setIds = new Set<Id>();
		Set<String> setSTIds = new Set<String>();		
		set<Id> userInfoIds = new Set<Id>();		 
		String x;
		
		for (Case c : lstCase) {
			setIds.add(c.id);
		}
		
		List<Case> caseList = [Select id,OwnerId,Status,ProductId,Product.Name,Issue_Reported_By__c,NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c,NCP_Contract_Name__c,NCP_List_of_Requested_Available_Services__c from Case where Id IN:setIds];
		List<CaseTeamMember> ctmList = [select MemberId,ParentId from CaseTeamMember where ParentId IN:setIds ];
		
		for (Case c : caseList){
			if (string.isNotBlank(c.NCP_Contract_Name__c)) {
				setSTIds.add(c.NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c);
			} else if (string.isNotBlank(c.NCP_List_of_Requested_Available_Services__c)) {
				setSTIds.add(c.NCP_List_of_Requested_Available_Services__c);
			}
			system.debug('c.Issue_Reported_By__c:'+c.Issue_Reported_By__c);
			if(string.isNotBlank(c.Issue_Reported_By__c)){
				userInfoIds.add(c.Issue_Reported_By__c);
			}			
		}
		
		system.debug('userInfoIds:'+userInfoIds);
						
		for (NCP_Service_Tile__mdt tile : [SELECT NCP_Key_Users__c,NCP_Entitlement_Access_Type__c FROM NCP_Service_Tile__mdt where NCP_Entitlement_Access_Type__c IN:setSTIds]) {
			if (String.isNotBlank(tile.NCP_Key_Users__c)) {
				mapUser.put(tile.NCP_Entitlement_Access_Type__c, tile.NCP_Key_Users__c.split(';'));
			}else{
				mapNullKeyUser.put(tile.NCP_Entitlement_Access_Type__c,'BLANK');
			}
		}
		
		for(User us:[select Id,Email,NCP_Relationship__c,Country__c from User where ID IN: userInfoIds]){
			if(us.NCP_Relationship__c == 'Internal'){
				userMap.put(us.ID,'Internal');
			}
			if(us.NCP_Relationship__c != 'Internal'){
				userMap.put(us.Id,'External');
			}
			if(us.Country__c != NULL){
				userCountryMap.put(us.Id,us.Country__c);
			}
		}
		
		Map<String,Id> keyUserIdMap = new Map<String,Id>();
		Map<Id,String> keyUserMap = new Map<Id,String>();		
		String EmailValue ;
		
		For(Case c: CaseList){
			
			if(userCountryMap.get(c.Issue_Reported_By__c) != NULL){
			
				EmailValue = NCP_Country_ESM_Mapping__c.getvalues(userCountryMap.get(c.Issue_Reported_By__c)).EService_Managers__c;
				keyUserMap.put(c.Issue_Reported_By__c,EmailValue);
			}
		
		}

		for(User us:[select Id,Email,NCP_Relationship__c,Country__c from User where ID IN: keyUserMap.values()]){
			keyUserIdMap.put(us.Country__c,us.Id);
		}		
		
	/*	
		For(NCP_Timezone_Mapping__c namTZ: NCP_Timezone_Mapping__c.getAll().Values()){
			if(namTZ.NAM_Timezone__c == attributes.get('nokiaTimeZone'))
				CSTimezoneValue = namTZ.SF_TimeZone__c ;
		}		
  */
		
		for(Case c: CaseList){
			
			if(userMap.get(c.Issue_Reported_By__c) == 'Internal'){														  
				
				system.debug('inside INTERNAL value');
			 
				system.debug('inside values 123'+c.NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c);
				system.debug('inside values 12345'+c.NCP_List_of_Requested_Available_Services__c);
				system.debug('inside values 12345'+mapUser.get(c.NCP_List_of_Requested_Available_Services__c));
				
				x = NCP_PreApproval_COM.getNAMResponse(c.Id);
				 system.debug('x value in Handler1:'+x);			   
				if(mapUser.get(c.NCP_List_of_Requested_Available_Services__c) == null){

					system.debug('inside this if 123'+c.NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c);
					system.debug('inside this if 123'+c.NCP_List_of_Requested_Available_Services__c);
					
					if(x != NULL){
						system.debug('inside this if 12345');
						NCP_PreApproval_COM.updateCaseStatus(c.Id);						
					}									
				}
			}			
			system.debug('Email in Map:'+userMap.get(c.Issue_Reported_By__c));
			system.debug('Email in Map:'+userMap.get(c.Issue_Reported_By__c));
					   
			if(userMap.get(c.Issue_Reported_By__c) == 'External'){
				
				if(c.ProductId != NULL){
					
					CaseTriggerHelper.addCaseTeamMembers(lstCase);				   
					
					if(userCountryMap.get(c.Issue_Reported_By__c) != NULL && !ctmList.IsEmpty()){
					
						c.OwnerId = keyUserIdMap.get(userCountryMap.get(c.Issue_Reported_By__c));
						Database.DMLOptions options = new Database.DMLOptions();
						options.assignmentRuleHeader.useDefaultRule = false;
						c.setOptions(options)  ;					  
						caseUpdateList.add(c);
					}												
				}
			} 
		}
		
		if(!caseUpdateList.IsEmpty()){					  
			update caseUpdateList ;		   
		}   
		// NCP_CaseTriggerHelper.sendEmailToKeyUser(lstCase);
	}

	public static void sendEmailToKeyUser(List<Case> lstCase) {

		Map<Id, List<String>> caseEmailList = new Map<Id, List<String>>();
		Map<String, List<String>> mapUser = new Map<String, List<String>>();
		Set<Id> setIds = new Set<Id>();
		Set<String> setSTIds = new Set<String>();
		Boolean updateStatusCheck = False ;
		for (Case c : lstCase) {
			setIds.add(c.id);
		}
		List<Case> caseList = [Select id,NCP_NAM_Entitlement_Requested__c, Issue_Reported_By__c,NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c,NCP_Contract_Name__c,NCP_List_of_Requested_Available_Services__c from Case where Id IN:setIds];
		for (Case c : caseList){
			if (string.isNotBlank(c.NCP_Contract_Name__c)) {
				setSTIds.add(c.NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c);
			} else if (string.isNotBlank(c.NCP_List_of_Requested_Available_Services__c)) {
				setSTIds.add(c.NCP_List_of_Requested_Available_Services__c);
			}
		}
		for (NCP_Service_Tile__mdt tile : [SELECT NCP_Key_Users__c,NCP_Entitlement_Access_Type__c FROM NCP_Service_Tile__mdt where NCP_Entitlement_Access_Type__c IN:setSTIds]) {
			if (String.isNotBlank(tile.NCP_Key_Users__c)) {
				mapUser.put(tile.NCP_Entitlement_Access_Type__c, tile.NCP_Key_Users__c.split(';'));
			}else{
				updateStatusCheck = TRUE ;
			}
		}
		for (Case c : caseList) {
			if (mapUser.get(c.NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c) != null) {
				caseEmailList.put(c.Id, mapUser.get(c.NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c));
			} else if (mapUser.get(c.NCP_List_of_Requested_Available_Services__c) != null) {
				caseEmailList.put(c.Id, mapUser.get(c.NCP_List_of_Requested_Available_Services__c));
			}
		}
		NCP_Utils.sendEmail(caseEmailList, NCP_Constants.EMAIL_TEMPLATE_KEYUSER);
		List<Case> updateStatusCaseList = new List<Case>();
		for(Case cValue: lstcase){
			if(cValue.NCP_NAM_Entitlement_Requested__c == 'SUCCESS'){
				updateStatusCaseList.add(cValue);
			}
		}
		if(!updateStatusCaseList.isEmpty() && updatestatusCheck == TRUE){
			NCP_CaseTriggerHelper.updateCaseStatus(updateStatusCaseList);
		}
		
	}

	public static void updateCaseStatus(List<Case> lstCase){
		 
		Map<Id, List<String>> caseEmailList = new Map<Id, List<String>>();
		Map<String, List<String>> mapUser = new Map<String, List<String>>();
		Set<Id> setIds = new Set<Id>();
		Set<String> setSTIds = new Set<String>();
		List<case> caseListnew = new List<case>();
		
		for (Case c : lstCase) {
			setIds.add(c.id);
		}
		List<Case> caseList = [Select id,NCP_NAM_Entitlement_Requested__c ,Status, Issue_Reported_By__c,NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c,NCP_Contract_Name__c,NCP_List_of_Requested_Available_Services__c from Case where Id IN:setIds];
		
		for(case c: caseList){
			if(c.NCP_NAM_Entitlement_Requested__c == 'SUCCESS'){
				
				system.debug('Update Case Status Check method:');
				c.Status = 'Approved' ;
				caseListnew.add(c);			   
			}		
		}
		
		if (!caseListnew.isEmpty()) {	  
			Database.SaveResult[] MySaveResult = database.update(caseListnew, false);
			for (Database.SaveResult sr : MySaveResult) {
				if (!sr.isSuccess()) {
					Database.Error err = sr.getErrors()[0];
					throw new AuraHandledException(err.getMessage());			  
				}else{
					CaseTriggerHelper.manageEntitlements(lstCase);
				}
			}
		}
	}   
}