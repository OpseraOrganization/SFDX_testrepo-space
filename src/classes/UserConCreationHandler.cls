/**************************************************************************************************************************
NOKIASC-4622 :  Automatic creation of Contact for Nokia User
Author : Avanti Vaidya/TCS
Modified By: HCL Technologies
Modified Date: 11 February 2021
**************************************************************************************************************************/
global class UserConCreationHandler {
	
	public static String userDataCombineStr;
	
   /*********************************************************************************************
	* Name: CallFutureConCreation
	* Param:List of user
	* Return: void
	* Description:  method called from  UserTriggerHandler
	**********************************************************************************************/
	public static void CallFutureConCreation(List<User> userList){
		
		List<String> nokiaIdSet = new List<String>();
		List<String> emailSet = new List<String>();
		List<String> userDataList= new List<String>();
		Boolean isUserCreated = false;
	
			for(User usr : userList){
	if(usr.CH_Case_Handling_Internal_Contact__c && usr.isActive && usr.Active_Nokia_Employee__c ){			  
		isUserCreated = true;
		if(usr.Nokia_ID__c != null){
			nokiaIdSet.add(usr.Nokia_ID__c);
		}
		emailSet.add(usr.email);
		userDataCombineStr = usr.firstname + ';'+ usr.LastName + ';'+ usr.email+ ';' +usr.MobilePhone+ ';'+ usr.Nokia_ID__c;			
		userDataList.add(userDataCombineStr);
	}
			}
			if(isUserCreated){
	UserConCreationHandler.contactCreationUpdationProcess(nokiaIdSet, emailSet, userDataList );
			}
	}
   /*********************************************************************************************
	* Name: CallFutureUpdateConStatus
	* Param:user old map and user new map
	* Return: void
	* Description:  method to called from  UserTriggerHandler
	**********************************************************************************************/
	public static void CallFutureUpdateConStatus(Map<Id, User> userOldMap ,  Map<Id, User> userNewMap){
		List<String> nokiaIdSet = new List<String>(); 
		List<String> emailSet = new List<String>();
		List<String> userDataList= new List<String>();
		List<String> nokiaIdDeactivatedSet = new List<String>();
		List<String> emailDeactivatedSet = new List<String>();
		Boolean isUserDeactivated = false;
		Boolean isUserActivated = false;
	  
	for(Id usrId : userNewMap.keySet()){
		User usrOld = userOldMap.get(usrId);
		User usrNew = userNewMap.get(usrId);
		if((usrNew.IsActive != usrOld.IsActive && usrNew.CH_Case_Handling_Internal_Contact__c != usrOld.CH_Case_Handling_Internal_Contact__c && usrNew.CH_Case_Handling_Internal_Contact__c == false && usrNew.IsActive == false) 
		||(usrNew.CH_Case_Handling_Internal_Contact__c != usrOld.CH_Case_Handling_Internal_Contact__c && usrNew.CH_Case_Handling_Internal_Contact__c == false)){	
		 isUserDeactivated = true;
						   if(usrNew.Nokia_ID__c != null)
		  nokiaIdDeactivatedSet.add(usrNew.Nokia_ID__c);
		 emailDeactivatedSet.add(usrNew.email);
		//TCS - updated logic to fix problem of contact override of portal users - defect: https://yoursl.atlassian.net/browse/NOKIASC-21122
		}else if(((usrNew.IsActive != usrOld.IsActive && usrNew.IsActive == true &&  usrNew.CH_Case_Handling_Internal_Contact__c == true && usrNew.Active_Nokia_Employee__c ) 
		 || (usrNew.IsActive == true &&  usrNew.CH_Case_Handling_Internal_Contact__c == true && usrNew.CH_Case_Handling_Internal_Contact__c != usrOld.CH_Case_Handling_Internal_Contact__c && usrNew.Active_Nokia_Employee__c) 
		 || (usrNew.CH_Case_Handling_Internal_Contact__c == true && usrNew.Active_Nokia_Employee__c && usrNew.IsActive == true
			 && (usrOld.firstname != usrNew.firstname || usrOld.LastName !=  usrNew.LastName || usrOld.email != usrNew.email ||  usrOld.MobilePhone != usrNew.MobilePhone)) )) 
		{			 
		 isUserActivated = true;
		 if(usrNew.Nokia_ID__c != null)
		  nokiaIdSet.add(usrNew.Nokia_ID__c);
		 emailSet.add(usrNew.email);
		 userDataCombineStr = usrNew.firstname + ';'+ usrNew.LastName + ';'+ usrNew.email+ ';' +usrNew.MobilePhone+ ';'+ usrNew.Nokia_ID__c;
		 userDataList.add(userDataCombineStr);
		}
	}
	if(isUserDeactivated){
		UserConCreationHandler.updateContactStatus(nokiaIdDeactivatedSet, emailDeactivatedSet);
	}
	if(isUserActivated){	   
		UserConCreationHandler.contactCreationUpdationProcess(nokiaIdSet, emailSet, userDataList);
	}
		
	}
   /*********************************************************************************************
	* Name: contactCreationUpdationProcess
	* Param: Id list, email Id list, user Id list
	* Return: void
	* Description:  method to called from  callFutureConCreation
	**********************************************************************************************/
	@future
	public static void contactCreationUpdationProcess(List<String> nokiaIdSet, List<String> emailSet, List<String> userDataList){		
		try{   
			system.debug('nokiaIdSet--'+nokiaIdSet + '---emailSet--'+ emailSet +  '--userDataList--'+ userDataList);
			String customerAccountId;
			Account_Ids__c customerAccObj = Account_Ids__c.getValues('Customer Account');
			if(customerAccObj != null){
	customerAccountId = customerAccObj.Account_Id__c != null ? customerAccObj.Account_Id__c : '';
			}
			
			String legalAccountId;
			Account_Ids__c legalAccObj = Account_Ids__c.getValues('Legal Entity');
			if(legalAccObj != null){
	legalAccountId = legalAccObj.Account_Id__c != null ? legalAccObj.Account_Id__c : '';
			}   
			List<Contact> conList = new List<Contact>();
			Map<String, Contact> conEmailUpdateMap = new Map<String,Contact>();
			if(nokiaIdSet != null){
	conList = [Select id, firstname, AccountId,Account.name, LastName, email, phone, Status__c, CH_LegacyContactId__c, CH_ContactType__c FROM contact where CH_LegacyContactId__c IN : nokiaIdSet OR email IN : emailSet ];	
			}else{
	conList = [Select id, firstname, AccountId,Account.name, LastName, email, phone, Status__c, CH_LegacyContactId__c, CH_ContactType__c FROM contact where email IN : emailSet ];	
			}
			system.debug('conList--'+conList); //Debug purpose
			if(!conList.isEmpty()){
	for(Contact con : conList){
		conEmailUpdateMap.put(con.Email, Con);
	}
	}
		
			if(conList.isEmpty()){
	List<Contact> conInsertList = new List<Contact>();
	
	for(String userDataStr : userDataList){
		List<String> splitUserDataList = userDataStr.split(';');
		if(!splitUserDataList.isEmpty()){
			
			Contact con = new Contact();
			con.firstname = splitUserDataList[0] == 'null' ?  '' :  splitUserDataList[0];
			
			if(String.isNotBlank(splitUserDataList[1])){
				con.LastName = splitUserDataList[1];
			}
			
			if(String.isNotBlank(splitUserDataList[2])){
				con.Email = splitUserDataList[2];
			}
			
			con.MobilePhone =  splitUserDataList[3] == 'null' ? '' : splitUserDataList[3];
			con.CH_LegacyContactId__c = splitUserDataList[4] == 'null'  ? '' : splitUserDataList[4] ;
			
			con.AccountId = customerAccountId;
			con.Contact_Status__c = 'Active';
			con.CH_ContactType__c = 'Nokia Employee';
			conInsertList.add(con);
		}
	}
	
	
	if(!conInsertList.isEmpty()){
		insert conInsertList;
		system.debug('conInsertList---'+conInsertList);
		getAccContRelationList(conInsertList, legalAccountId);
	}
			}else{
	List<Contact> conUpdateList = new List<Contact>();
	  String emailStr;
	for(String userDataStr : userDataList){
		List<String> splitUserDataList = userDataStr.split(';');
		
		
		if(!splitUserDataList.isEmpty()){
			 if(String.isNotBlank(splitUserDataList[2])){
		emailStr = splitUserDataList[2];
			 }
			
			if(conEmailUpdateMap.containsKey(emailStr)){
				
				Contact con = conEmailUpdateMap.get(emailStr);
				if(con != null){
		con.firstname = splitUserDataList[0] == 'null' ?  '' :  splitUserDataList[0];
		
		if(String.isNotBlank(splitUserDataList[1])){
			con.LastName = splitUserDataList[1];
		}
		
		if(String.isNotBlank(splitUserDataList[2])){
			con.Email = splitUserDataList[2];
		}
		
		con.MobilePhone =  splitUserDataList[3] == 'null' ? '' : splitUserDataList[3];
		con.CH_LegacyContactId__c = splitUserDataList[4] == 'null'  ? '' : splitUserDataList[4] ;
		con.AccountId = customerAccountId;		 
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Nokia Employee';
		conUpdateList.add(con); //Adding to contact list
				}
			}
			
		}
		
	}
	if(!conUpdateList.isEmpty()){
		system.debug('conUpdateList  debuggg--'+conUpdateList);
		update conUpdateList;
		getAccContRelationList(conUpdateList, legalAccountId);
	}
			}
		}catch(Exception e){
			System.debug('Exception = '+e.getMessage() + 'Line number--'+ e.getLineNumber());
		}
	}
	
   /*********************************************************************************************
	* Name: updateContactStatus
	* Param: de-activated Id list, deactivated email Id list
	* Return: void
	* Description:  method to called from  CallFutureUpdateConStatus
	**********************************************************************************************/
	@future
	public static void updateContactStatus(List<String> nokiaIdDeactivatedSet, List<String> emailDeactivatedSet){		
		try{
			system.debug('emailDeactivatedSet handler ---'+ emailDeactivatedSet + 'nokiaIdDeactivatedSet--'+nokiaIdDeactivatedSet);
			List<Contact> conInactiveList = new List<Contact>();
			Set<Id> contactIdSet = new Set<Id>();
			
			List<Contact> conDeclareList = new List<Contact>();
			if(nokiaIdDeactivatedSet != null){
	system.debug('nokiaIdDeactivatedSet--'+ nokiaIdDeactivatedSet);
	conDeclareList =  [Select id, firstname, AccountId,Account.name, LastName, email, phone, Status__c,CH_LegacyContactId__c,CH_ContactType__c FROM contact where CH_LegacyContactId__c IN : nokiaIdDeactivatedSet OR email IN : emailDeactivatedSet ] ;
			}else{
	conDeclareList= [Select id, firstname, AccountId,Account.name, LastName, email, phone, Status__c, CH_LegacyContactId__c,CH_ContactType__c FROM contact where email IN : emailDeactivatedSet ];
			}
			
			if(!conDeclareList.isEmpty()){
	for(Contact conObj : conDeclareList) {
		conObj.Contact_Status__c = 'Inactive';
		conInactiveList.add(conObj);
		contactIdSet.add(conObj.id);
	} 
	system.debug('contactIdSet--'+contactIdSet);
	if(!conInactiveList.isEmpty()){
		update conInactiveList;
		system.debug('conInactiveList if not empty---'+conInactiveList);
		Set<Id> userOrGroupIdSet = new Set<Id>();
		Set<Id> caseIdSet = new Set<Id>();
		Id grpId = [select Id , DeveloperName from Group where DeveloperName = 'CH_DVT_Queue' Limit 1 ].id;
		for (GroupMember grpMem : [SELECT id, UserOrGroupId,GroupId  FROM GroupMember WHERE GroupId =: grpId ]  ){
		userOrGroupIdSet.add(grpMem.UserOrGroupId);
		} 
		for(Case caseObj : [Select id, Status, contactId FROM case where contactId IN : contactIdSet AND Status != 'Closed' ]){
			caseIdSet.add(caseObj.id);
			
		}
		sendMailTOQueueMembers(userOrGroupIdSet, caseIdSet);
	} 
			}
		}catch(Exception e){
			System.debug('Error = '+e.getMessage() + 'Line number--'+ e.getLineNumber());
		}
		
	}
	
   /*********************************************************************************************
	* Name: sendMailTOQueueMembers
	* Param: Set Id, Set Id
	* Return: void
	* Description:  method to called from  updateContactStatus
	* History : Changing access modifier from public to private
	**********************************************************************************************/
	@testVisible
	private static void sendMailTOQueueMembers(Set<Id> queueMemIdSet, Set<Id> caseIdSet){
		try{
			Id emailTempId = [Select Id from EmailTemplate where DeveloperName = 'CH_Internal_Case_Contact_Deactivated' limit 1].id;
			if(emailTempId != null){
	List<Messaging.singleEmailMessage> mails = new List<Messaging.singleEmailMessage>();
	for(Id caseId : caseIdSet){
		if(caseId != null){
			for(Id queueMemId : queueMemIdSet){
				if(queueMemId != null){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setTargetObjectId(queueMemId);
		email.setTemplateId(emailTempId);
		email.setSaveAsActivity(false); 
		email.setWhatId(caseId);
		mails.add(email);	
		system.debug('mails---'+mails); 
				}
			}
		}
	}
	
	if(!mails.isEmpty()){
		Messaging.sendEmail(mails);
	}
			}
			
		}catch(Exception e){
			System.debug('Error = '+e.getMessage() + 'Line number--'+ e.getLineNumber());
		}
	}
	
   /*********************************************************************************************
	* Name: getAccContRelationList
	* Param: List of Contact, string
	* Return: void
	* Description:  method to called from  contactCreationUpdationProcess
	* History : Changing access modifier from public to private
	**********************************************************************************************/
	@testVisible
	private static void getAccContRelationList(List<Contact> contactList, String accountId){
		try{
			List<AccountContactRelation> accConRelationList = new List<AccountContactRelation>();
			List<AccountContactRelation> accConRelationInsUpList = new List<AccountContactRelation>();
			Set<Id> accConRelContactIds = new Set<Id>();
			if(!contactList.isEmpty()){
	for(Contact con : contactList){
		accConRelContactIds.add(con.id);
	}
	accConRelationList = [Select id , AccountId, contactId, Roles, NCP_Entitlement_Relationship__c FROM AccountContactRelation Where contactId IN : AccConRelContactIds AND  NCP_Entitlement_Relationship__c = true ];
	if(accConRelationList.isEmpty()){
		for(Id conIds :  accConRelContactIds){
			AccountContactRelation accConRelationObj = new AccountContactRelation(AccountId = accountId, ContactId = conIds, NCP_Entitlement_Relationship__c = true, Roles = 'Business User');
			accConRelationInsUpList.add(accConRelationObj);
		}
					if(!accConRelationInsUpList.isEmpty())
			insert accConRelationInsUpList;
	}else{
		update accConRelationList ;
	}
			}
		}catch(Exception e){
			System.debug('Error = '+e.getMessage() + 'Line number--'+ e.getLineNumber());
		}
	}
}