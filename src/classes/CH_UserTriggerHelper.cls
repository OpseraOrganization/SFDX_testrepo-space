/*************************
* Class Name : CH_UserTriggerHelper 
* Modified Date: April 2021
* Create By : CH Team
* Description : This Class is used  for all Portal Activated 
Users. Whenever users are activated this call is triggered to share all case record (CH Cases only)
* Modification Log:
Modified By    	Modified For US#    Modified Date
Rajeshwari/Flavio  NOKIASC-35646	   Dec-2021
 * ******************************/
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
				
	   /*
* @description : Identify the User who is actvated from Inactive also when User is created
	 Applicable only for Portal User where ContactId!=null
* @param : Map<Id,User> oOldUserMap, List<User> oNewUserList
* @return : void
*/		  
	public static void identifyActivatedUser(Map<Id,User> oOldUserMap, List<User> oNewUserList) {
		set<string> activatedUserID = new set<string>();
		for(User oUSer :oNewUserList){
			if( (oOldUserMap !=null && oUser.IsActive && oUSer.IsActive !=  oOldUserMap.get(oUser.Id).IsActive && oUser.ContactId !=null) ||
			   (oOldUserMap ==null && oUSer.IsActive && oUSer.ContactId !=null)){
				   activatedUserID.add(oUSer.Id);
			   }
		}
		if(!activatedUserID.isempty()){
			queryActiveUser(activatedUserID );
		}
		system.debug('IdentifyActivatedUser'+activatedUserID);
	}
	
	/*
* @description : Future Method to shareCase
* @param : Set<Id> oldSet, Set<Id> newSet
* @return : void
*/
	@future
	public static void queryActiveUser(set<string> activatedUserID ){
		List<User> oNewUserList  = [select id , isActive, ContactId from user where id in :activatedUserID and isactive =true];
		shareCaseRecord( oNewUserList)  ;
	}
	/*
* @description : Query Case and Authorized Contact and create CAse share Record for Portal Users
* @param : List<User> oNewUserList
* @return : void
*/
	public static void shareCaseRecord( List<User> oNewUserList) {
		Map<String, String> oUserIdToContactId = new Map<String, String>();
		try {
			for(User oNewUser : oNewUserList) {
				oUserIdToContactId.put(oNewUser.ContactId, oNewUser.Id);
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
					system.debug('objCaseShareList  -->'+objCaseShareList.size());
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