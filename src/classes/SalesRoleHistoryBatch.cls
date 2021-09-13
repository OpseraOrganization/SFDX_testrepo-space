/******************************************************************************************************
Name : SalesRoleHistoryBatch
Created Date: 14 JUNE 2018
Created by: Accenture
Description : To create User to territory association on Sales Role History insertion	   
*********************************************************************************************************/
Global class SalesRoleHistoryBatch implements Database.Batchable<Sales_Role_History__c>,Database.Stateful{
	
	private List<Sales_Role_History__c> salesRoleId =  new List<Sales_Role_History__c> ();
	Set<String> hierarchyIds = new Set<String>();
	Set<String> hierarchyIdNSA = new Set<String>();
	Map<String, Id> hierarchyTerritoryMap = new Map<String, Id>();
	Map<String, Id> hierarchyTerritoryMapNSA = new Map<String, Id>();
	Set<Id> nsaUserIds = new Set<Id>();
	Set<Id> newUserIds = new Set<Id>();
	
	List<String> deletionErrors = new List<String>();
	List<String> insertionErrors = new List<String>();
	
	List<String> insertionSuccess = new List<String>();
	List<String> deletionSuccess = new List<String>();
	
	List<String> exceptionMessages = new List<String>();
	
	List<UserTerritory2Association> u2tSuccessInsertRecords = new List<UserTerritory2Association>();
	List<Id> u2tSuccessDeleteRecords = new List<Id>();
	
	List<UserTerritory2Association> u2tFailureInsertRecords = new List<UserTerritory2Association>();
	List<Id> u2tFailureDeleteRecords = new List<Id>();
	
	List<UserTerritory2Association> insertLockedRecords = new List<UserTerritory2Association>();
	List<Id> deleteLockedRecords = new List<Id>();
	 
	/********************
	*Method Name: SalesRoleHistoryBatch
	*Parameter: String
	*Description: Constructor
	*******************/
	global SalesRoleHistoryBatch(List<Sales_Role_History__c> salesRoleHistoryList) {
		this.salesRoleId = salesRoleHistoryList;
	} 
	
	/********************
	*Method Name: start
	*Parameter: Database.BatchableContext
	*Description: Start Method of Batch Class
	*******************/
	global Iterable<Sales_Role_History__c> start(Database.BatchableContext info){ 
	   for(Sales_Role_History__c history: salesRoleId){
			hierarchyIds.add(history.Hierarchy_Id__c);
			system.debug('hierarchyIds>>>'+hierarchyIds);
			hierarchyIdNSA.add(history.Hierarchy_Id__c+GlobalConstants.NSA);
			newUserIds.add(history.New_User__c);
			system.debug('newUserIds>>>'+newUserIds);
		}
		
		for(Territory2 territoryVar : [select Id,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Hierarchy_ID__c In: hierarchyIds 
									   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			hierarchyTerritoryMap.put(territoryVar.Hierarchy_ID__c,territoryVar.Id);
		} 
		
		system.debug('hierarchyTerritoryMap>>>'+hierarchyTerritoryMap);
		for(Territory2 territoryVar : [select Id,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Hierarchy_ID__c In: hierarchyIdNSA 
									   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			hierarchyTerritoryMapNSA.put(territoryVar.Hierarchy_ID__c,territoryVar.Id);
		}
		system.debug('hierarchyTerritoryMapNSA>>>'+hierarchyTerritoryMapNSA);
		for(User nsaUser : [select Id,NSA_Compliant__c from User where NSA_Compliant__c = true AND Id In: newUserIds
							LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			nsaUserIds.add(nsaUser.Id);
		}
		system.debug('nsaUserIds>>>'+nsaUserIds);
		return new List<Sales_Role_History__c>{new Sales_Role_History__c()};
			
	}
	
	/********************
	*Method Name: execute
	*Parameter: Database.BatchableContext  BC
	*Description: Execute Method of Batch Class
	*******************/	
	global void execute(Database.BatchableContext BC, List<Sales_Role_History__c> salesRoleHistoryList){
		Set<Id> userIds = new Set<Id>();
		Set<String> organisationLabel= new Set<String>();
		List<Id> associationsToDelete = new List<Id>();																 
		Map<Id, Set<Id>> territoryUsersMap = new Map<Id, Set<Id>>();
		UserTerritory2Association userToTerritory = new UserTerritory2Association();
		UserTerritory2Association userToTerritory1 = new UserTerritory2Association();
		List <UserTerritory2Association> associationsToAdd = new List <UserTerritory2Association>();
		
		try{
			for(Sales_Role_History__c history: salesRoleId){
				if((GlobalConstants.DELETED.equalsIgnoreCase(history.Operation_Type__c)) || (GlobalConstants.MODIFIED.equalsIgnoreCase(history.Operation_Type__c))){
					userIds.add(history.Old_User__c);
					system.debug('history.Old_User__c>>>'+history.Old_User__c);
					organisationLabel.add(history.Organisation__c);
					system.debug('history.Organisation__c>>>'+history.Organisation__c);
					
					if(!territoryUsersMap.containsKey(hierarchyTerritoryMap.get(history.Hierarchy_Id__c))){											  
						territoryUsersMap.put(hierarchyTerritoryMap.get(history.Hierarchy_Id__c), new Set<Id>{history.Old_User__c});
						 system.debug('territoryUsersMap>>>'+territoryUsersMap);
						territoryUsersMap.put(hierarchyTerritoryMapNSA.get(history.Hierarchy_Id__c+GlobalConstants.NSA), new Set<Id>{history.Old_User__c});
					}
					else{
						territoryUsersMap.get(hierarchyTerritoryMap.get(history.Hierarchy_Id__c)).add(history.Old_User__c);
					}
				} 
				if(((GlobalConstants.MODIFIED.equalsIgnoreCase(history.Operation_Type__c)) || (GlobalConstants.CREATED.equalsIgnoreCase(history.Operation_Type__c))) && (newUserIds.contains(history.New_user__c))){
					userToTerritory = new UserTerritory2Association();
					userToTerritory.Territory2Id = hierarchyTerritoryMap.get(history.Hierarchy_Id__c);
					userToTerritory.RoleInTerritory2 = history.New_Role_Name__c;
					userToTerritory.UserId = history.New_User__c;
					system.debug('history.New_User__c>>>'+history.New_User__c);
					associationsToAdd.add(userToTerritory);
					system.debug('associationsToAdd>>>'+associationsToAdd);
				}
				
				system.debug('associationsToAddOut>>>'+associationsToAdd);
				if(((GlobalConstants.MODIFIED.equalsIgnoreCase(history.Operation_Type__c)) || (GlobalConstants.CREATED.equalsIgnoreCase(history.Operation_Type__c))) && (nsaUserIds.contains(history.New_user__c)) && (!hierarchyTerritoryMapNSA.isEmpty())){
					if( hierarchyTerritoryMapNSA.containsKey(history.Hierarchy_Id__c+GlobalConstants.NSA)){
						userToTerritory1 = new UserTerritory2Association();
						userToTerritory1.Territory2Id = hierarchyTerritoryMapNSA.get(history.Hierarchy_Id__c+GlobalConstants.NSA);
						userToTerritory1.RoleInTerritory2 = history.New_Role_Name__c;
						userToTerritory1.UserId = history.New_User__c;
						associationsToAdd.add(userToTerritory1);
						system.debug('associationsToAdd>>>'+associationsToAdd);
					 }
				}
			}
			
			Map<Id,Set<String>> srMap = new Map<Id,Set<String>>();
			for(Sales_Role__c srList:[select User__c ,Organisation__c,Role_Name__c from Sales_Role__c where User__c In : userIds]){
				if(srMap.containskey(srList.User__c)){
					srMap.get(srList.User__c).add(srList.Organisation__c);
					srMap.get(srList.User__c).add(srList.Organisation__c+GlobalConstants.SPACE_NSA);
					srMap.get(srList.User__c).add(srList.Organisation__c+GlobalConstants.NSA); 
				}
				else{
					srMap.put(srList.User__c,new Set<String>{srList.Organisation__c});  
					srMap.get(srList.User__c).add(srList.Organisation__c+GlobalConstants.SPACE_NSA); 
					srMap.get(srList.User__c).add(srList.Organisation__c+GlobalConstants.NSA); 
				}
				
				system.debug('srMap>>>>'+srMap);
				system.debug('srMap>>>>'+srMap.size());
			}
			
			if(!territoryUsersMap.isEmpty()){
				for(UserTerritory2Association association : [SELECT Territory2Id,territory2.name,RoleInTerritory2, UserId FROM UserTerritory2Association where IsActive = True
															 and Territory2.Territory2Model.State =: GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE
															 and Territory2Id In : territoryUsersMap.keySet() and UserId In : userIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
					
					system.debug('association.RoleInTerritory2>>>'+association.RoleInTerritory2);
					
					if(territoryUsersMap.containsKey(association.Territory2Id)){											  
						
						for(Id userId : territoryUsersMap.get(association.Territory2Id)){
							
							if(userId == association.UserId){ 
								
								if(srMap.containsKey(userId)){
									system.debug('In loop for User Id'+userId);
									system.debug('srMap.get(userId)......'+srMap.get(userId)); 
									if(!srMap.get(userId).contains(association.territory2.name)){
										system.debug('Ready to delete');				  
										associationsToDelete.add(association.Id);
										system.debug('associationsToDelete>>>>'+associationsToDelete);
									} 
								}else{
									system.debug('Ready to delete');				  
									associationsToDelete.add(association.Id);
									system.debug('associationsToDelete>>>>'+associationsToDelete);
								}
							}
						}
					}
				}
				
				if(!associationsToDelete.isEmpty()){
					Boolean someFailure = false;
					Database.DeleteResult[] deleteResults = Database.delete(associationsToDelete, false);
					Integer deleteCounter = 0;
					for (Database.DeleteResult dr : deleteResults){
						if (!dr.isSuccess()){
							someFailure = true;
							for(Database.Error err : dr.getErrors()){
								deletionErrors.add('Error occured while deleting : '+err.getStatusCode() + ' : ' + err.getMessage());
								deletionErrors.add('UserTerritory2Association fields that affected this deletion error : ' + err.getFields());
								System.debug('Error occured while deleting : '+err.getStatusCode() + ' : ' + err.getMessage());
								System.debug('UserTerritory2Association fields that affected this error : ' + err.getFields());
								u2tFailureDeleteRecords.add(associationsToDelete.get(deleteCounter));
								if(err.getMessage().contains('UNABLE_TO_LOCK_ROW')){
									deleteLockedRecords.add(associationsToDelete.get(deleteCounter));
								} 
							}
						}else{
							deletionSuccess.add(dr.getId());
							u2tSuccessDeleteRecords.add(associationsToDelete.get(deleteCounter));
						}
						deleteCounter++;
					}
				}
			}
			
			system.debug('associationsToAddinsert>>'+associationsToAdd);
			if(!associationsToAdd.isEmpty()){
				Boolean someFailure = false;
				Database.SaveResult[] insertResults = Database.insert(associationsToAdd, false);
				Integer insertCounter = 0;
				for (Database.SaveResult dr : insertResults){
					if (!dr.isSuccess()){
						someFailure = true;
						for(Database.Error err : dr.getErrors()){
							insertionErrors.add('Error occured while Inserting: '+err.getStatusCode() + ' : ' + err.getMessage());
							insertionErrors.add('UserTerritory2Association fields that affected this insertion error : ' + err.getFields());
							System.debug('Error occured while Inserting : '+err.getStatusCode() + ' : ' + err.getMessage());
							System.debug('UserTerritory2Association fields that affected this error : ' + err.getFields());
							u2tFailureInsertRecords.add(associationsToAdd.get(insertCounter));
							if(err.getMessage().contains('UNABLE_TO_LOCK_ROW')){
								insertLockedRecords.add(associationsToAdd.get(insertCounter));
							} 
						}
					}else{
						insertionSuccess.add(dr.getId());
						u2tSuccessInsertRecords.add(associationsToAdd.get(insertCounter));
					}
					insertCounter ++;
				}
			}
		}catch(Exception exc){
			exceptionMessages.add(exc.getMessage());
		}
	}
	
	
	
	/********************
	*Method Name: finish
	*Parameter: Database.BatchableContext  BC
	*Description: Finish Method of Batch Class
	*******************/			
	global void finish(Database.BatchableContext BC){
		SRT2TerritoryAssociation__c emailSettingForU2t = SRT2TerritoryAssociation__c.getOrgDefaults();
		if(emailSettingForU2t.SendMail__c || Test.isRunningTest()){
			 List<String> ccEmails = new List<String>();
			 if(emailSettingForU2t.CCEmailAddress__c!=NULL){
				 ccEmails = emailSettingForU2t.CCEmailAddress__c.split(GlobalConstants.COMMA);
			 }
		   
			 if(!exceptionMessages.isEmpty() || Test.isRunningTest()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[]{emailSettingForU2t.EmailId__c}); 
				mail.setSubject('Exception Occured');	 
				if(!ccEmails.isEmpty()){
					mail.setCcAddresses(ccEmails);
				}
				// Set the message body and send the email
				mail.setPlainTextBody(buildBodyFor(exceptionMessages));
				if(!Test.isRunningTest())
					Messaging.sendEmail(new Messaging.Email[] { mail });
			}
			
			if(!insertionSuccess.isEmpty()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[]{emailSettingForU2t.EmailId__c}); 
				mail.setSubject('Successfully inserting user in territory');	 
				if(!ccEmails.isEmpty()){
					mail.setCcAddresses(ccEmails);
				}
				// Set the message body and send the email
				mail.setPlainTextBody(buildBodyFor(insertionSuccess));
				if(!Test.isRunningTest())
					Messaging.sendEmail(new Messaging.Email[] { mail });
			}
			
			if(!deletionSuccess.isEmpty()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[]{emailSettingForU2t.EmailId__c}); 
				mail.setSubject('Successfully Deleting user in territory');	 
				if(!ccEmails.isEmpty()){
					mail.setCcAddresses(ccEmails);
				}
				// Set the message body and send the email
				mail.setPlainTextBody(buildBodyFor(deletionSuccess));
				if(!Test.isRunningTest())
					Messaging.sendEmail(new Messaging.Email[] { mail });
			}
			
			if(!insertionErrors.isEmpty()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[]{emailSettingForU2t.EmailId__c}); 
				mail.setSubject('Error while inserting user in territory');	 
				if(!ccEmails.isEmpty()){
					mail.setCcAddresses(ccEmails);
				}
				// Set the message body and send the email
				mail.setPlainTextBody(buildBodyFor(insertionErrors) +'		'+buildStringFor(u2tFailureInsertRecords));
				if(!Test.isRunningTest())
					Messaging.sendEmail(new Messaging.Email[] { mail });
			}
			
			if(!deletionErrors.isEmpty()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[]{emailSettingForU2t.EmailId__c}); 
				mail.setSubject('Error while Deleting user in territory');	 
				if(!ccEmails.isEmpty()){
					mail.setCcAddresses(ccEmails);
				}
				// Set the message body and send the email
				mail.setPlainTextBody(buildBodyFor(deletionErrors));
				if(!Test.isRunningTest())
					Messaging.sendEmail(new Messaging.Email[] { mail });
			}
		}
		Id failureId;
		if(emailSettingForU2t.InterfaceLog__c || Test.isRunningTest()){
			if((!insertionSuccess.isEmpty()) || (!deletionSuccess.isEmpty()))
				insertSuccessInterfaceLog();
			if((!insertionErrors.isEmpty()) || (!deletionErrors.isEmpty()) || (!exceptionMessages.isEmpty())|| Test.isRunningTest() )
				failureId = insertFailureInterfaceLog();
				
			 if(!deleteLockedRecords.isEmpty() || !insertLockedRecords.isEmpty() || Test.isRunningTest()){	
				TerrritoryILogUpdater tiLog = new TerrritoryILogUpdater();
				tiLog.failureId = failureId ;
				tiLog.insertLockedRecords = insertLockedRecords ;
				tiLog.deleteLockedRecords = deleteLockedRecords ;
				System.enqueueJob(tiLog);
			}
		}
	}
	
	String buildBodyFor(List<String> messages){
		String errorMessages= '';
		
		for(String msg : messages){
			errorMessages = errorMessages +'\r\n'+ msg;
		}
		return errorMessages;
	}
	
	public String buildStringFor(List<UserTerritory2Association> U2TRecords){
		String messages= '';
		
		for(UserTerritory2Association u2t : U2TRecords){
			messages = messages +'\r\n'+ u2t;
		}
		return messages;
	}
	
	void insertSuccessInterfaceLog(){
		
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = 'SRT2TerritoryAssociation';
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.INBOUND;
		interfaceLog.Status__c = GlobalConstants.SUCCESS;
		interfaceLog.Comment__c = +buildBodyFor(deletionSuccess)+'		'+buildBodyFor(insertionSuccess);
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = salesRoleId +'';
		interfaceLog.Interface_Type__c = 'SRT2TerritoryAssociation';
		interfaceLog.Message_Type__c = GlobalConstants.INBOUND;  
		insert interfaceLog;
	}
	
	public Id insertFailureInterfaceLog(){
		
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = 'SRT2TerritoryAssociation';
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.INBOUND;
		interfaceLog.Status__c = GlobalConstants.FAILURE;
		interfaceLog.Comment__c = buildBodyFor(exceptionMessages)+'	'+buildBodyFor(deletionErrors)+'		'+buildBodyFor(insertionErrors)+'	'+buildStringFor(u2tFailureInsertRecords);
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = salesRoleId +'';
		interfaceLog.Interface_Type__c = 'SRT2TerritoryAssociation';
		interfaceLog.Message_Type__c = GlobalConstants.INBOUND;  
		insert interfaceLog;
		return interfaceLog.Id;
	}
	
}