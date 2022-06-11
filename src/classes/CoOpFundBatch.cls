/*******************************************************************
 * Class Name : CoOpFundBatch
 * Created Date: 28 may 2018
 * Created By : Accenture
 * Last Modified by: HCL Technologies
 * Last Modified Date: 26 Feb 2021
 * Description : Share fund records to users 
 * Test Class: CoOpFundBatchTest/UserHelperPRMTest
 *********************************************************************/
global class CoOpFundBatch implements Database.Batchable<sObject>{
	private List<User> newuserid =  new List<User> ();
	/************************************
	*Method Name: CoOpFundBatch
	*Parameter: String
	*Description: Constructor
	*************************************/
   global CoOpFundBatch(List<User> userList) {
	this.newuserid = userList;
	} 
	
	/**********************************************************
	*Method Name: start
	*Parameter: Database.BatchableContext
	*Description: Start Method of Batch Class
	***********************************************************/
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{
		List<contact> contactList = new List<contact>();
		List<Id> accountId = new List<Id>();
		String strAccounts = PRMGlobalConstants.BLANK_VALUE;
		String strAccounts2 = PRMGlobalConstants.BLANK_VALUE;
		Map<String, OTM_Sharing_Exception__c> customMap = OTM_Sharing_Exception__c.getAll();
		set<Id> contactSet = new set<Id>();
		set<Id> accSet = new set<Id>();
		
		for(User userInstance : newuserid){
			contactSet.add(userInstance.ContactId);
		} 
		
		contactList = [select id, accountid from contact 
		where Id In: contactSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		List<user> userList1 = [select id, contact.accountid from user 
		where IsActive = true and ContactId IN: contactList Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		for(User userinstance :userList1){
			accSet.add(userinstance.contact.accountid);
		}
		
		for(id idset: accSet){
			if(customMap.containsKey(idset)){
	OTM_Sharing_Exception__c accountSharingSetting = customMap.get(idset);
	strAccounts = accountSharingSetting.Contact_Account_Name__c;		
	strAccounts2 = accountSharingSetting.Contact_Account_Name2__c;
			if(strAccounts2 != null ){
	strAccounts = strAccounts + PRMGlobalConstants.SemiColon + strAccounts2;
			}
	accountId = strAccounts.split(PRMGlobalConstants.SemiColon);
		}
	}
		
		if(!accountId.IsEmpty()){
			accSet.addAll(accountId); 
		}
 
		return Database.getQueryLocator([SELECT id,Partner_Name__c FROM Fund__c where Partner_Name__c IN: accSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
		
	}
	
	/********************************************************
	*Method Name: execute
	*Parameter: Database.BatchableContext  BC
	*Description: Execute Method of Batch Class
	**********************************************************/
	global void execute(Database.BatchableContext BC, List<Fund__C> fundlist) {
	
		List<contact> contactList = new List<contact>();
		set<Id> contactSet = new set<Id>();
		
		for(User userInstance : newuserid){
			contactSet.add(userInstance.ContactId);
		} 
		
		contactList = [select id, accountid from contact 
		where Id In: contactSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		List<user> userList2 = [select id, contact.accountid from user 
		where IsActive = true and ContactId IN: contactList Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		List<Fund__Share> fundShareToUserInsert  = new List<Fund__Share>();
		
		Set<id> fundId = new Set<id>(); 
		Set<id> userId = new Set<id>(); 
		Set<id> fundIdset = new Set<id>(); 
		Map<id,Set<id>> userToFundMap = new Map<id,Set<id>>();
		Map<id,Set<id>> accToFundMap = new Map<id,Set<id>>();
		system.debug('Fundlist:'+ fundlist);
		system.debug('contactList::'+ contactList);
		system.debug('userList2::'+userList2);
		
		for(Fund__C fund : fundlist ){
			if(accToFundMap.containsKey(fund.Partner_Name__c)){
			fundId = accToFundMap.get(fund.Partner_Name__c);   
			}
			fundId.add(fund.id);
			accToFundMap.put(fund.Partner_Name__c,fundId);
		}
		
		for(user userInstance : userList2){
			if(accToFundMap.containsKey(userInstance.contact.accountid)){
	fundIdset = (accToFundMap.get(userInstance.contact.accountid));
	userToFundMap.put(userInstance.id,fundIdset);
			}
		}
		
		system.debug('userToFundMap::'+userToFundMap);
		if(!userToFundMap.IsEmpty()){
		for(user userInstance : userList2){
			for(id fundIdInstance : userToFundMap.get(userInstance.id)){
	Fund__Share share = new Fund__Share();
	share.UserOrGroupId = userInstance.id;
	share.ParentId  = fundIdInstance;
	share.AccessLevel = PRMGlobalConstants.EDIT;
	share.RowCause = Schema.Fund__Share.RowCause.Apex_Sharing__c;
	fundShareToUserInsert.add(share);
			}
		}
	}
		if(!fundShareToUserInsert.IsEmpty()){
			Database.SaveResult[] fdList = Database.insert(fundShareToUserInsert, false);
		}
		
	}
	/**********************************************************
	*Method Name: finish
	*Parameter: Database.BatchableContext
	*Description: finish Method of Batch Class
	***********************************************************/
	global void finish(Database.BatchableContext BC){
	
	}

}