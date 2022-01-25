/****************************************
* Class Name : CaseTriggerHelper
* Created Date: 17 April 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 19 April 2017
* Description : 1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
			  
 * Test Class: 
 *****************************************/
public without sharing class CaseTriggerHelper {

	/****************************************
	 * Added by SAlesforce to create case team from service contract
	 *****************************************/


	public static void sendEmailToKeyUser(List<Case> lstCase) {

		Map<Id, List<String>> caseEmailList = new Map<Id, List<String>>();
		Map<String, List<String>> mapUser = new Map<String, List<String>>();
		Set<Id> setIds = new Set<Id>();
		Set<String> setSTIds = new Set<String>();
		for (Case c : lstCase) {
			setIds.add(c.id);
		}
		List<Case> caseList = [Select id,NCP_Contract_Name__r.NCP_Entitlement_Access_Type__c,NCP_Contract_Name__c,NCP_List_of_Requested_Available_Services__c from Case where Id IN:setIds];
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
	}

	public static void addCaseTeamMembers(List<Case> lstCase) {

		CaseTeamMember[] newmembers = new CaseTeamMember[]{};  //list of new team members to add
		CaseShare[] newShare = new CaseShare[]{};  //list of new shares to add
		Set<ID> UserIds = new Set<ID>();
		Set<ID> scIds = new Set<ID>();
		Map<Id, List<String>> mapEmails = new Map<Id, List<String>>();
		Map<Id, List<String>> mapAtosEmails = new Map<Id, List<String>>();
		Id role = [Select Id from CaseTeamRole where Name = :NCP_Constants.APPROVER_VALUE].Id;
		List<String> contractList = new List<String>();
		Map<Id,List<String>> mapCaseSC = new Map<Id,List<String>>();
		Map<String,List<NCP_Service_Contract_Team__c>> mapPM = new Map<String,List<NCP_Service_Contract_Team__c>>();
		for (Case req :lstCase){
			if(String.isNotBlank(req.NCP_Service_Contract_team__c)) {
				contractList.addAll((req.NCP_Service_Contract_team__c).split(';'));
				mapCaseSC.put(req.Id,(req.NCP_Service_Contract_team__c).split(';'));
			}
		}

		for(NCP_Service_Contract_Team__c pm:[Select NCP_Team_Member__c,NCP_Service_Contract_Id__r.ContractNumber,NCP_Status__c From NCP_Service_Contract_Team__c where NCP_Service_Contract_Id__r.ContractNumber IN:contractList and NCP_Status__c = :NCP_Constants.STATUS_ACTIVE]){
			if(!mapPM.containsKey(pm.NCP_Service_Contract_Id__r.ContractNumber)){
				mapPM.put(pm.NCP_Service_Contract_Id__r.ContractNumber, new List<NCP_Service_Contract_Team__c>());
				mapPM.get(pm.NCP_Service_Contract_Id__r.ContractNumber).add(pm);
			}else{
				mapPM.get(pm.NCP_Service_Contract_Id__r.ContractNumber).add(pm);
			}
		}
		system.debug('### AES mapCaseSC '+mapCaseSC);
		system.debug('### AES mapPM '+mapPM);
		for (Case req :lstCase) {
			if (req.NCP_Contract_Type__c == NCP_Constants.TYPE_OTHER) {
				NCP_CustomerCommunitySetting__c mhc = NCP_CustomerCommunitySetting__c.getInstance(NCP_Constants.DEFAULT_VALUE);
				if(String.isNotBlank(mhc.NCP_ATOS_User__c)){
					List<String> atosNames = (mhc.NCP_ATOS_User__c).split(';');
					mapAtosEmails.put(req.Id, atosNames);
				}
			}	
			system.debug('### AES mapCaseSC.get(req.Id) '+mapCaseSC.get(req.Id));				   
			List<NCP_Service_Contract_Team__c> projectMembersLst = new List<NCP_Service_Contract_Team__c>();
			if (mapCaseSC.get(req.Id) != null){
				system.debug('### AES mapCaseSC.get(req.Id) '+mapCaseSC.get(req.Id)); 
				for(String scN:mapCaseSC.get(req.Id)){
					system.debug('### AES scN '+scN);
					if(mapPM.get(scN) != null){ 
						projectMembersLst.addAll(mapPM.get(scN));
					}
				}
			}
			system.debug('### AES projectMembersLst '+projectMembersLst);
			if(!projectMembersLst.isEmpty()){
				for (integer i = 0; i < projectMembersLst.size(); i++) {
					CaseTeamMember Teammemberad = new CaseTeamMember();
					Teammemberad.ParentId = req.Id;
					Teammemberad.MemberId = projectMembersLst[i].NCP_Team_Member__c;
					Teammemberad.TeamRoleId = role;
					newmembers.add(Teammemberad);
					Database.SaveResult[] lsr = Database.insert(newmembers, false);//insert any valid members then add their share entry if they were successfully added
					Integer newcnt = 0;
					for (Database.SaveResult sr : lsr) {
						if (!sr.isSuccess()) {
							Database.Error emsg = sr.getErrors()[0];
							//system.debug('\n\nERROR ADDING TEAM MEMBER:'+emsg);
						} else {
							newShare.add(new CaseShare(UserOrGroupId = newmembers[newcnt].MemberId, CaseId = newmembers[newcnt].ParentId, CaseAccessLevel = 'Edit'));
						}
						newcnt++;
					}
					Database.SaveResult[] lsr0 = Database.insert(newShare, false); //insert the new shares
					Integer newcnt0 = 0;
					for (Database.SaveResult sr0 : lsr0) {
						if (!sr0.isSuccess()) {
							Database.Error emsg0 = sr0.getErrors()[0];
							//system.debug('\n\nERROR ADDING SHARING:'+newShare[newcnt0]+'::'+emsg0);
						}
						newcnt0++;
					}
				}
			} else {
				// send email to help desk if the case team is empty 
				NCP_CustomerCommunitySetting__c mhc = NCP_CustomerCommunitySetting__c.getInstance(NCP_Constants.DEFAULT_VALUE);
				if(String.isNotBlank(mhc.NCP_Nokia_HelpDesk_Email__c)){
					List<String> helpDeskEmails = (mhc.NCP_Nokia_HelpDesk_Email__c).split(';');
					mapEmails.put(req.Id, helpDeskEmails);
				}
			}
		}
		if (NCP_Utils.isInternalUser()) {
			if (!mapEmails.isEmpty()) {
				NCP_Utils.sendEmail(mapEmails, NCP_Constants.EMAIL_TEMPLATE_INTERNAL);
			}
		} else {
			if (!mapEmails.isEmpty()) {
				NCP_Utils.sendEmail(mapEmails, NCP_Constants.EMAIL_TEMPLATE_TEAM);
			}
		}
		if (!mapAtosEmails.isEmpty()) {
			NCP_Utils.sendEmail(mapAtosEmails, NCP_Constants.EMAIL_TEMPLATE_TEAM);
		}
	}

	public static void manageEntitlements(List<Case> lstCase){
		
		Set<Id> setIds = new Set<Id>();
		Map<Id,Case> mapCase = new Map<Id,Case>();
		List<Case> internalCases = new List<Case>();
		List<Case> cases = new List<Case>();	
		for(Case c:lstCase){
			setIds.add(c.Id);
			mapCase.put(c.id,c);
		}	 
		for(Case c:[Select Id,Issue_Reported_By__c,Issue_Reported_By__r.NCP_Is_Internal__c,Issue_Reported_By__r.ContactId,NCP_Contract_Name__c,NCP_Contract_Type__c,
							NCP_List_of_Requested_Other_Services__c,NCP_List_of_Requested_Available_Services__c,NCP_Product_Name__c,NCP_Service_Contract__c
							from Case where Id IN:setIds]){
			if(c.Issue_Reported_By__r.NCP_Is_Internal__c == true){
				internalCases.add(c);
			}else{
				cases.add(c);
			}
		}
		if(!internalCases.isEmpty()){
			createInternalServices(internalCases);
		}
		if(!cases.isEmpty()){
			createEntitlements(cases);
		}
	}

	public static void createEntitlements(List<Case> reqList) {
		
		Set<Id> setSCId = new Set<Id>();
		Set<Id> setCNId = new Set<Id>();
		Set<Id> setPNId = new Set<Id>();
		Map<Id,Id> mapCLI = new  Map<Id,Id>();
		Map<Id,List<ServiceContract>> mapSCChild = new Map<Id,List<ServiceContract>>();

		for(Case req:reqList){
			setSCId.add(req.NCP_Service_Contract__c);
			setCNId.add(req.NCP_Contract_Name__c);
			setPNId.add(req.NCP_Product_Name__c);
		}
		
		for(ServiceContract child:[Select Id,NCP_Entitlement_Access_Type__c,ParentServiceContractId From ServiceContract Where ParentServiceContractId =:setSCId]){
			if(!mapSCChild.containsKey(child.ParentServiceContractId)){
				mapSCChild.put(child.ParentServiceContractId,new List<ServiceContract>());
				mapSCChild.get(child.ParentServiceContractId).add(child);
			}else{
				mapSCChild.get(child.ParentServiceContractId).add(child);   
			}
		}
		for(contractLineItem li:[Select Id,Product2Id from contractLineItem where ServiceContractId IN:setSCId and Product2Id IN:setPNId and ServiceContract.ContractNumber IN:setCNId]){
			mapCLI.put(li.Product2Id,li.Id);
		}
		List<NCP_Authorised_Entitlement__c> authList = new List<NCP_Authorised_Entitlement__c>();
		for(Case req:reqList){
			if (string.isNotBlank(req.NCP_Contract_Name__c) && (req.NCP_Contract_Type__c == NCP_Constants.TYPE_OTHER || req.NCP_Contract_Type__c == NCP_Constants.TYPE_CDB)) {
				NCP_Authorised_Entitlement__c auth = new NCP_Authorised_Entitlement__c();
				auth.NCP_Contact__c = req.Issue_Reported_By__r.ContactId;
				auth.NCP_Service_Contract__c = req.NCP_Contract_Name__c;
				authList.add(auth);
			}
			if (string.isBlank(req.NCP_Contract_Name__c) && req.NCP_Contract_Type__c == NCP_Constants.TYPE_OTHER && string.isNotBlank(req.NCP_List_of_Requested_Other_Services__c)) {
				List<String> services = req.NCP_List_of_Requested_Other_Services__c.split(';');
				system.debug('### services '+services);
				for (ServiceContract child : mapSCChild.get(req.NCP_Service_Contract__c)) {
					if(services.contains(child.NCP_Entitlement_Access_Type__c)){
						NCP_Authorised_Entitlement__c auth = new NCP_Authorised_Entitlement__c();
						auth.NCP_Contact__c = req.Issue_Reported_By__r.ContactId;
						auth.NCP_Service_Contract__c = child.Id;
						authList.add(auth);
					}
				}
			}
			if (string.isNotBlank(req.NCP_Product_Name__c)) {
				//contractLineItem li = [Select Id from contractLineItem where ServiceContractId = :req.NCP_Service_Contract__c and Product2Id = :req.NCP_Product_Name__c and ServiceContract.ContractNumber = :req.NCP_Contract_Name__c];
				NCP_Authorised_Entitlement__c auth = new NCP_Authorised_Entitlement__c();
				auth.NCP_Contact__c = req.Issue_Reported_By__r.ContactId;
				auth.NCP_Contract_Line_Item__c = mapCLI.get(req.NCP_Product_Name__c);
				authList.add(auth);
			}
		}
		system.debug('### authList '+authList);
		if (!authList.isEmpty()) {
			Database.SaveResult[] MySaveResult = database.insert(authList, false);
			for (Database.SaveResult sr : MySaveResult) {
				if (!sr.isSuccess()) {
					Database.Error err = sr.getErrors()[0];
					throw new AuraHandledException(err.getMessage());
					//System.debug('### AES Exception '+err);			   
				}/*else{
					req.Status = NCP_Constants.STATUS_CLOSED;
				}*/
			}
		}
	}

	public static void createInternalServices(List<Case> reqList) {

		List<NCP_Internal_Users_Services__c> iusList = new List<NCP_Internal_Users_Services__c>();
		for(Case req:reqList){
			if (string.isNotBlank(req.NCP_List_of_Requested_Available_Services__c)) {
				List<String> accessList = req.NCP_List_of_Requested_Available_Services__c.split(';');
				for (String acc : accessList) {
					NCP_Internal_Users_Services__c sc = new NCP_Internal_Users_Services__c();
					sc.NCP_Service__c = acc;
					sc.NCP_User__c = req.Issue_Reported_By__c;
					iusList.add(sc);
				}
			}
		}
		if (!iusList.isEmpty()) {
			Database.SaveResult[] MySaveResult = database.insert(iusList, false);
			for (Database.SaveResult sr : MySaveResult) {
				if (!sr.isSuccess()) {
					Database.Error err = sr.getErrors()[0];
					throw new AuraHandledException(err.getMessage());
					//System.debug('### AES Exception '+err);				
				}/*else{
					req.Status = NCP_Constants.STATUS_CLOSED;
				}*/
			}
		}
	}

	public static Id getCaseRecordTypeId(String recordtypeDevName) {
		Schema.DescribeSObjectResult caseRTs = Case.SObjectType.getDescribe();
		Map<String,Schema.RecordTypeInfo> rtMapByName = caseRTs.getRecordTypeInfosByDeveloperName();
		Schema.RecordTypeInfo ncpCaseRt =  rtMapByName.get(recordtypeDevName);
		//system.debug(ncpCaseRt.getRecordTypeId());
		return ncpCaseRt.getRecordTypeId();
	}
	
	/*
	public static void populateCaseEntitlement(list<Case> cases){
		if(UserInfo.getUserType() == 'PowerCustomerSuccess'){
		 	set<Id> assetIds = new set<Id>();
			  for(Case aCase : cases){
				  if(aCase.assetId != null && aCase.entitlementId == null){
					  assetIds.add(aCase.assetId);
				  }
			  }
			  if(!assetIds.isEmpty()){ 
				  map<Id,Id> assetEntit = new map<Id,Id>();
				  for(ContractLineItem scli : [SELECT CH_Entitlement__c, AssetId FROM ContractLineItem WHERE assetId IN :assetIds AND CH_Entitlement__r.status = 'Active']){
					  assetEntit.put(scli.AssetId, scli.CH_Entitlement__c);
				  }
				  for(Case aCase : cases){
					  if(aCase.assetId != null && aCase.entitlementId == null && assetEntit.containsKey(aCase.assetId)){
						 aCase.entitlementId = assetEntit.get(aCase.assetId);
					  }
				  }
			  }   
		}
	  }
	*/
}