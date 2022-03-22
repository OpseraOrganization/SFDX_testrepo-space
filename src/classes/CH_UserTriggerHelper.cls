public inherited sharing class CH_UserTriggerHelper {
	public static final string MANUAL_ROW_CASE = 'Manual';
	public static final string READ_ACCESS_LEVEL = 'Read';
	public static set<String> serviceContractIds = new  set<String> ();
	static final set<string> SHARING_ELIGIBLE_REC_TYPES = new set<string>{
		'CH_NokiaStandardCase', 'CH_NokiaIncidentWithRestoration', 'CH_NokiaInformationRequest',
		'HWS_Advance_Exchange_In_Days', 'HWS_Advance_Exchange_In_Hours', 'HWS_Child_Case_Read_Only',
		'HWS_Parent_Case', 'HWS_Parent_Case_Ready_Only', 'HWS_Return_For_Repair', 'HWS_Spare_Part_Sales',
		'HWS_Spare_Part_Sales_Read_only'
	};
	  
	public static void shareCase(Map<Id,User> oOldUserMap, List<User> oNewUserList) {
		Map<String, String> oUserIdToContactId = new Map<String, String>();
		Boolean hasOldValues = oOldUserMap != null && !oOldUserMap.isEmpty();
		//
		try {
			for(User oNewUser : oNewUserList) {
	if(oNewUser.IsActive && oNewUser.ContactId != null) {
		User oOldUser = hasOldValues ? oOldUserMap.get(oNewUser.Id) : null;
		if(oOldUser == null || !oOldUser.IsActive || oOldUser.ContactId == null) {
			oUserIdToContactId.put(oNewUser.ContactId, oNewUser.Id);
		}
	}
			}
			if(!oUserIdToContactId.isempty()){
	List<EntitlementContact> oEntitlementContactList = [select id, EntitlementID,Entitlement.ServiceContractID , ContactId from EntitlementContact  where ContactId in : oUserIdToContactId.keySet()];
	map<id, set<Id>> entContactMap = getEntitlementContact(oEntitlementContactList);
	if(!entContactMap.isempty()) {
		List<CaseShare> objCaseShareList = new List<CaseShare>();
		for(Case aCase : [select id, EntitlementID, serviceContractID,  Entitlement.ServiceContract.CH_Entitlement__c  from Case where  CH_RecordTypeDevName__c  IN : SHARING_ELIGIBLE_REC_TYPES AND  Entitlement.ServiceContract.CH_Entitlement__c in : entContactMap.keyset() and status not in ('Completed','Cancelled')  ]){
			if(entContactMap.containsKey(aCase.Entitlement.ServiceContract.CH_Entitlement__c)){
				for(Id contactId : entContactMap.get(aCase.Entitlement.ServiceContract.CH_Entitlement__c)){
		if(oUserIdToContactId.containsKey(contactId)){
			objCaseShareList.add(new CaseShare(CaseAccessLevel = READ_ACCESS_LEVEL, CaseId = aCase.Id, RowCause = MANUAL_ROW_CASE, UserOrGroupId = oUserIdToContactId.get(contactId)));  
		}
				}
			}
		}
		if(!objCaseShareList.isempty()){
			database.insert(objCaseShareList, false) ;
		}
	}
			}
		}
		catch (Exception Ex)
		{
			system.debug(' Exception while sharing the record '+Ex);
		}
	}
	
	public static  map<id, set<Id>> getEntitlementContact(List<EntitlementContact> entitlementContacts){
		map<id, set<Id>> entContacts = new map<id, set<Id>>();
		for(EntitlementContact entCtt : entitlementContacts){
			if(entContacts !=null && entContacts.containsKey(entCtt.EntitlementId)){
	entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
			}else{
	entContacts.put(entCtt.EntitlementId, new set<Id>{entCtt.contactId}); 
			}
		}
		return entContacts;
	}
}