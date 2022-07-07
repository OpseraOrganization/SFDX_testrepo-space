/****************************************************************
* Class Name : HWS_QuoteActions 
* Created Date: 02-11-2021
* Created By: TCS
* Description : Controller class to handle all custom 
				actions on Service Quote Object
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
public with sharing class HWS_QuoteActions{  
	@AuraEnabled
	public static string syncPriceAction(string sRecordId) {
		try{
			List<Id> lstIds = new List<Id>();
			lstIds.add(id.valueof(sRecordId)); 
			string returnStatement = HWS_QuoteUpdation.QuoteUpdate(lstIds,false, true);
			return returnStatement;
		}
		catch (Exception e) {
			String errorMsg = e.getMessage();
			throw new AuraHandledException(errorMsg);
		}
	}
	
	
	public static void throwException(){
		AuraHandledException e = new AuraHandledException(System.Label.HWS_Sync_Price_Failed);
		e.setMessage(System.Label.HWS_Sync_Price_Failed);
		
		throw e;
	}
	
	/*******************************************************
	* Method Name : acceptOwnerShip 
	* Description : logic for quote assignment when Accept Ownership is clicked
					HWSDDP-43
	*********************************************************/
	@AuraEnabled
	public static void acceptOwnerShip(String sRecordId){
		try{
			HWS_Service_Quote__c servQuote = [SELECT Id,OwnerId,HWS_Workgroup__c FROM HWS_Service_Quote__c WHERE Id =: sRecordId LIMIT 1];
			if(servQuote.HWS_Workgroup__c != null){
				String userQuery = 'SELECT Id FROM User WHERE Name = "CH Queue" LIMIT 1';
				List<User> chQueueUser = DML_SObject.doQuery(userQuery,true); // query in without sharing mode
				String wgMemberQuery = 'SELECT Id,CH_User__c,CH_Role__c FROM CH_Workgroup_Member__c WHERE CH_Workgroup__c = "{0}"';
				List<Object> parameters = new List<Object>();
				parameters.add(servQuote.HWS_Workgroup__c);
				List<CH_Workgroup_Member__c> wgMemberList = DML_SObject.doQuery(wgMemberQuery,parameters,true); // query in without sharing mode
				List<Id> wgUserList = new List<Id>();
				List<Id> wgRoleManagerList = new List<Id>();
				for(CH_Workgroup_Member__c wm : wgMemberList){
					wgUserList.add(wm.CH_User__c);
					if(wm.CH_Role__c == 'WG Manager-Quotation Manager'){
						wgRoleManagerList.add(wm.CH_User__c);
					}
				}
	
				//checks if user belongs to WG member and Owner is CH Queue User
				//or user belongs to WG member and Owner is not CH Queue User but user is manager
				if((wgUserList.contains(UserInfo.getUserId()) && servQuote.OwnerId == chQueueUser[0].Id) 
					|| (wgUserList.contains(UserInfo.getUserId()) &&  wgRoleManagerList.contains(UserInfo.getUserId())
					&& servQuote.OwnerId != chQueueUser[0].Id && servQuote.OwnerId != UserInfo.getUserId())){
					servQuote.OwnerId = UserInfo.getUserId();
					DML_SObject.doUpdate(new List<SObject>{servQuote},true,true); // do update in withoutSharing
				}
				else if(wgUserList.contains(UserInfo.getUserId()) && servQuote.OwnerId != chQueueUser[0].Id && servQuote.OwnerId != UserInfo.getUserId()){
					String warningMsg = Label.HWS_AcceptOwnership_Manager_Warning_Msg;
					AuraHandledException e = new AuraHandledException(warningMsg);
					e.setMessage(warningMsg);
					throw e;
				}
				else if(wgUserList.contains(UserInfo.getUserId()) && servQuote.OwnerId == UserInfo.getUserId()){
					String warningMsg = Label.HWS_AcceptOwnership_Already_Assigned_Msg;
					AuraHandledException e = new AuraHandledException(warningMsg);
					e.setMessage(warningMsg);
					throw e;
				}
				//show warning msg if user doesn't belong to WG tries to accept Ownership
				else{ 
					String warningMsg = Label.HWS_AcceptOwnership_Warning_Msg;
					AuraHandledException e = new AuraHandledException(warningMsg);
					e.setMessage(warningMsg);
					throw e;
				}
			}
			else{
				String warningMsg = Label.HWS_No_WG_FOUND;
				AuraHandledException e = new AuraHandledException(warningMsg);
				e.setMessage(warningMsg);
				throw e;
			}
		}
		catch (Exception e) {
			String errorMsg = e.getMessage();
			throw new AuraHandledException(errorMsg);
		}
	}
	
	/*******************************************************
	* Method Name : getWgMemberDetails
	* Description : logic for display WG member and do assignment
					HWSDDP-114
	*********************************************************/
	@AuraEnabled(cacheable=true)
	public static List<CH_Workgroup_Member__c> getWgMemberDetails(String workgroupId){
		Id ch_ca_wgm_RecordTypeId = Schema.getGlobalDescribe().get('CH_Workgroup_Member__c').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		String wgMemberQuery = 'SELECT Id,CH_User__c,CH_User__r.Name,CH_Role__c,CH_Workgroup__c,CH_Workgroup__r.CH_Type__c,CH_Workgroup_Member_Type__c FROM CH_Workgroup_Member__c WHERE CH_Workgroup__c = "{0}" AND RecordTypeId = "{1}"';
		List<Object> parameters = new List<Object>();
		parameters.add(workgroupId);
		parameters.add(ch_ca_wgm_RecordTypeId);
		List<CH_Workgroup_Member__c> wgMemberList = DML_SObject.doQuery(wgMemberQuery,parameters,true); // query in without sharing mode;
		return wgMemberList;	  
	}
	/*******************************************************
	* Method Name : updateOwnership
	* Description : logic to update OwnerId on Service Quote
					HWSDDP-114
	*********************************************************/
	@AuraEnabled
	public static void updateOwnership(String userName, String userRole, String sRecordId,String workgroupId){
		try{
			CH_Workgroup_Member__c wgMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE CH_Role__c =: userRole 
						AND CH_User__r.Name =: userName AND CH_Workgroup__c =:workgroupId LIMIT 1];
			HWS_Service_Quote__c servQuote = new HWS_Service_Quote__c();
			servQuote.Id = sRecordId;
			servQuote.OwnerId = wgMember.CH_User__c;
			DML_SObject.doUpdate(new List<SObject>{servQuote},true,false); // update in with sharing
		}
		catch(Exception e){
			String errorMsg = e.getMessage();
			throw new AuraHandledException(errorMsg);
		}
	}
	/*******************************************************
	* Method Name : getValidUser
	* Description : logic to check user having permissionset and for recordtypename
					HWSDDP-64
	*********************************************************/
	 @AuraEnabled(cacheable=true)
	public static actionwrapper getValidUser(String compId){	   
	  
		List<PermissionSetAssignment> validPermission=[select Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id =:UserInfo.getUserId() AND PermissionSet.Label in ('HWS_CustomerDeliveryManager','HWS_OrderCoordinator')];
		HWS_Service_Quote__c servicequote = [SELECT Id, RecordtypeId, RecordType.name FROM HWS_Service_Quote__c where Id = : compId];
		string recordName=servicequote.RecordType.name;
		actionwrapper w= new actionwrapper(validPermission,recordName);
		return w;	  
	}
	/*******************************************************
	* Class Name : actionwrapper
	* Description : Call from LWC
					HWSDDP-32, HWSDDP-64
	*********************************************************/
	  public class actionwrapper {
		@AuraEnabled
		public List<PermissionSetAssignment> validPermission{get; set;}
		@AuraEnabled
			public string recordName{get; set;}   
		public actionwrapper(List<PermissionSetAssignment> validPermission, string recordName){
			this.validPermission = validPermission;
			this.recordName = recordName;
		}
		}		
		

}