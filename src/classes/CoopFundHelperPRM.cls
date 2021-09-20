/* description: Trigger helper to perform functions before and after Fund creation
* *author:	Accenture IDC.
* ============================================================================
* VERSION	 AUTHOR	DATE	 DETAIL	 FEATURES/CSR/TTP
* 1.0	Pooja Kurkute			08/05/2018	Release 4.1 PRM	  CO-OP
* ============================================================================ 
*/
public without sharing class CoopFundHelperPRM {
	/**********************************************************************************************************************
* Description: Method to share fund manually
**********************************************************************************************************************/		 
	public static void shareFundOnCreation(List<Fund__c> fundList){
		try{
			//List<Fund__c> fundList = new List<Fund__c>();
			// fundList = [SELECT id,Name,Partner_Name__c FROM Fund__c WHERE id IN: fundList1 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			List<Fund__Share> fundShareToInsert  = new List<Fund__Share>();
			set<Id> accSet = new set<Id>();
			set<Id> allAccSet = new set<Id>();
			list<Id> accountId = new list<Id>();
			Map<id,list<id>> fundToUserMap = new Map<id,list<id>>();
			Map<id,list<id>> accToUserMap = new Map<id,list<id>>();
			Map<id,list<id>> accToUserWCrossPartner = new Map<id,list<id>>();
			
			String strAccounts = PRMGlobalConstants.BLANK_VALUE;
			String strAccounts2 = PRMGlobalConstants.BLANK_VALUE;
			Map<String, OTM_Sharing_Exception__c> customMap = OTM_Sharing_Exception__c.getAll();
			map<ID, list<ID>> crossShareAcc = new map<ID, list<ID>>();
			
			for(Fund__C fundinstance :fundList){
	accSet.add(fundinstance.Partner_Name__c);
	allAccSet.add(fundinstance.Partner_Name__c);
			}
			
			for(id accid: accSet){
	if(customMap.containsKey(accid)){
		strAccounts = OTM_Sharing_Exception__c.getInstance(accid).Contact_Account_Name__c;		
		strAccounts2 = OTM_Sharing_Exception__c.getInstance(accid).Contact_Account_Name2__c;
		if(strAccounts2 != null ){
			strAccounts = strAccounts + PRMGlobalConstants.SemiColon + strAccounts2;
		}
		accountId = strAccounts.split(PRMGlobalConstants.SemiColon);
		allAccSet.addAll(accountId);
		accountId.add(accid);
		
	 //   system.debug('accountId'+AccountId);
		crossShareAcc.put(accid, accountId);
	}
			}
		 //   system.debug('crossShareAcc... '+crossShareAcc);
			
			
			//system.debug('accSet+++' + accSet);
			
			//List<user> userList = [select id, contact.accountid from user where IsActive = true and contactid IN: contactList];
			
			
	 for(user u : [select id , contact.accountid, accountid, ProfileId from user 
		where IsActive = true and accountid in: allAccSet 
		and (ProfileId =: System.Label.PRM_Partner_Relationship_Manager_Login_ID 
			or ProfileId =: System.Label.PRM_Partner_Profile_Id
			or ProfileId =: System.Label.Customers_Login_Profile_ID
		or ProfileId =: System.Label.Customers_Profile_ID) 
		Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){ 
		list<id> userIdset =  new list<id>();
		if(accToUserMap.containsKey(u.accountid)){
			userIdset = accToUserMap.get(u.accountid);	 
		}
		
		userIdset.add(u.id);
		
		// system.debug('userIdset+++' + userIdset);
		accToUserMap.put(u.accountid,userIdset);
		//   system.debug('accToUserMap+++' + accToUserMap);
			}
			
			for(id accid: accSet){
	list<id> crosssharedAcc = crossShareAcc.get(accid);
	list<ID> allUserSet = accToUserMap.get(accid);
	if(crosssharedAcc != Null){
		for(id crossaccount : crosssharedAcc){
			allUserSet.addall(accToUserMap.get(crossaccount));
		}
	}
	
	accToUserWCrossPartner.put(accid, allUserSet);
			}
			
			
			
			for(fund__c fundi : fundList){
	if(accToUserWCrossPartner.containsKey(fundi.Partner_Name__c)){
		list<id> userId = (accToUserWCrossPartner.get(fundi.Partner_Name__c)); 
	  //  system.debug('userId+++' + userId);
		fundToUserMap.put(fundi.id,userId);
	}
			}
			
	 // system.debug('fundToUserMap+++' + fundToUserMap);
			
			for(fund__c fundi : fundList){
	for(id userIdInstance : fundToUserMap.get(fundi.id)){
		Fund__Share share = new Fund__Share();
		share.UserOrGroupId = userIdInstance;
		share.ParentId  = fundi.Id;
		share.AccessLevel = PRMGlobalConstants.EDIT;
		share.RowCause = Schema.Fund__Share.RowCause.Apex_Sharing__c;
		fundShareToInsert.add(share);
	}
			}
	 // system.debug('fundShareToInsert+++' + fundShareToInsert);
			if(!fundShareToInsert.IsEmpty()){
	Database.SaveResult[] fdList = Database.insert(fundShareToInsert, false);
			}
		} catch(System.Exception e){
			ExceptionHandler.addException(e, PRMGlobalConstants.CoopFundHelperPRM , PRMGlobalConstants.shareFundOnCreation );}

	}
	 
/********************
	*Method Name: fundShareToAccMember
	*Parameter: List<Fund__c> fundList
	*Description: share Fund__c with acc members
	*******************/
	public static void fundShareToAccMember(List<Fund__c> fundList){
		List<Fund__Share> fundShareToInsert = new List<Fund__Share> ();
		Map<id,Set<Id>> accountMemberMap = new Map<id,Set<Id>>();
		Map<id,id> fundaccMap = new Map<id,id> ();
		List<Account> accountFund = new list<Account>();
		try{
			for(Fund__c fundInstance : fundList){
	fundaccMap.put(fundInstance.Partner_Name__c,fundInstance.Id);
			}
			for(Account_Member__c accTeam : [SELECT Account__c,Name__c FROM Account_Member__c 
			WHERE Account__c IN :  fundaccMap.keySet()  
			Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Set<id> acctmemberId = new Set<id>();
	if(!accountMemberMap.containskey(accTeam.Account__c)){
	 acctmemberId.add(accTeam.Name__c);
	}else{
	 acctmemberId = accountMemberMap.get(accTeam.Account__c);
	 acctmemberId.add(accTeam.Name__c);
	}
	accountMemberMap.put( accTeam.Account__c , acctmemberId);
			}
			//system.debug('accTeam+++'+accountMemberMap);
			for(Account fundtoAccount : [SELECT Id FROM Account 
		 WHERE id IN :  fundaccMap.keySet() AND Active__c  = True 
	 Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	 //system.debug('fundtoAccount+++'+fundtoAccount);
	for(id users : accountMemberMap.get(fundtoAccount.id)){
		Fund__Share share = new Fund__Share();
		share.UserOrGroupId = users;
		share.ParentId = fundaccMap.get(fundtoAccount.id);
		share.AccessLevel = PRMGlobalConstants.EDIT;
		share.RowCause = Schema.Fund__Share.RowCause.Apex_Sharing__c;
		fundShareToInsert.add(share);	
	}
	 //system.debug('fundtoAccount+++after loop'+fundtoAccount);
			}
			// system.debug('fundShareToInsert+++'+fundShareToInsert);
			//insert fundShareToInsert;
			Database.SaveResult[] srList = Database.insert(fundShareToInsert, false);
			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (sr.isSuccess()) {
		// Operation was successful, so get the ID of the record that was processed
		
	}
	else {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			
		}
	}
			}
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.CASE_SHARE_TO_OPPTY_MEMBER);
		}
	}
	
	public static void checkMainFund(List<Fund__c> fundList){
		Set<Id> newMainFundAccIds = new Set<Id>();
		Set<Id> newMainFundIds = new Set<Id>();
		List<Fund__c> newMainFunds = new List<Fund__c>();
		List<Fund__c> oldMainFunds = new List<Fund__c>();
		Map<Id,Fund__c> newMainFundsMap = new Map<Id,Fund__c>();
		for(Fund__c fund : fundList){
			if(fund.PRM_Main_Fund__c){
				newMainFundAccIds.add(fund.Partner_Name__c);
				newMainFundIds.add(fund.Id);
				newMainFunds.add(fund);
				newMainFundsMap.put(fund.Partner_Name__c,fund);
			}
		}
		
		if(!newMainFundAccIds.isEmpty()){
			oldMainFunds = [Select id, Name, Partner_Name__c, PRM_Main_Fund__c from Fund__c where PRM_Main_Fund__c = true and Partner_Name__c in :newMainFundAccIds and Id not in :newMainFundIds];
			for(Fund__c newFund : newMainFunds){
				for(Fund__c oldFund : oldMainFunds){
					if(newFund.Partner_Name__c == oldFund.Partner_Name__c){
						newFund.addError('There can only be one Main Fund for an Account. You need to uncheck the existing Main Fund: ' + oldFund.Name);
					}
				}
			}
		}
	}
	
}