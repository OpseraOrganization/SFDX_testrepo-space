/*******************************
	*Class name: AccountOwnerChangeAsync
	*Description: This Class will Update After Account Owner Change
	*Parameter: Account Values
	*******************************/ 
public class AccountOwnerChangeAsync implements Queueable {
	private List<Account> accountListOld;
	private List<Account> accountListNew;
	
	/*@InvocableMethod(label='Get Accounts' description='Get Accounts for which owner has changed')
	public static void updateRelatedOwners(List<Id> accIds) {
		
	}*/
	public AccountOwnerChangeAsync(List<Account> accountListOld , List<Account> accountListNew) {
		this.accountListOld  = accountListOld;
		this.accountListNew = accountListNew;
	}
	
	public void execute(QueueableContext context) {
		updateLeadandCertificationOwner(accountListOld, accountListNew);
		updateUserManager(accountListOld, accountListNew);
		accountMemberUpdate(accountListOld, accountListNew);
	}
	/*******************************
	*Method name: updateLeadandCertificationOwner
	*Description: This Method will Update Lead & certification owner After Account Owner Change
	*Parameter: Account Values
	*******************************/ 
	private void updateLeadandCertificationOwner( List<Account> accountListOld , List<Account> accountListNew){
		try{
			Set<id> oldAccountOwnerId = new Set<Id>();
			Set<id> oldAccountOwnerIdForDistributor = new Set<Id>();
			Set<id> oldAccountOwnerIdForIndirectReseller = new Set<Id>();
			Set<id> oldAccountOwnerIdForReseller = new Set<Id>();
			Set<id> oldAccountOwnerIdForOthers = new Set<Id>();

			Map<id,id> oldAccountInfo = new Map<id,id>();
			Map<id,id> oldAccountInfoForDistributor = new Map<id,id>();
			Map<id,id> oldAccountInfoForIndirectReseller = new Map<id,id>();
			Map<id,id> oldAccountInfoForReseller = new Map<id,id>();

			Set<id> oldAccountId = new Set<Id>();
			Set<id> oldAccountIdForDistributor = new Set<Id>();
			Set<id> oldAccountIdForIndirectReseller = new Set<Id>();
			Set<id> oldAccountIdForReseller = new Set<Id>();
			Set<id> oldAccountIdForOthers = new Set<Id>();
			
			Map<id,id> userIdToUserIdMap = new Map<id,id>();//Account owner old vs new
			Map<id,id> userIdToUserIdMapForDistributor = new Map<id,id>();
			Map<id,id> userIdToUserIdMapForIndirectReseller = new Map<id,id>();
			Map<id,id> userIdToUserIdMapForReseller = new Map<id,id>();
			Map<id,id> userIdToUserIdMapForOthers = new Map<id,id>();
			for(Account accInstance : accountListOld){
				if(accInstance.Partner_Type__c =='Distributor'){
					system.debug('Test1');
					oldAccountIdForDistributor.add(accInstance.id);
					oldAccountId.add(accInstance.id);
					oldAccountInfoForDistributor.put(accInstance.id, accInstance.OwnerId);
					oldAccountOwnerIdForDistributor.add(accInstance.OwnerId); 
					oldAccountOwnerId.add(accInstance.OwnerId);	
				}else if (accInstance.Partner_Type__c =='Indirect Reseller') {
					oldAccountIdForIndirectReseller.add(accInstance.id);
					oldAccountId.add(accInstance.id);
					oldAccountInfoForIndirectReseller.put(accInstance.id, accInstance.OwnerId);
					oldAccountOwnerIdForIndirectReseller.add(accInstance.OwnerId);
					oldAccountOwnerId.add(accInstance.OwnerId);	
				}else if (accInstance.Partner_Type__c =='Value Added Reseller'){
					oldAccountIdForReseller.add(accInstance.id);
					oldAccountId.add(accInstance.id);
					oldAccountInfoForReseller.put(accInstance.id, accInstance.OwnerId);
					oldAccountOwnerIdForReseller.add(accInstance.OwnerId); 
					oldAccountOwnerId.add(accInstance.OwnerId); 
				}else {
					oldAccountIdForOthers.add(accInstance.id);
					oldAccountId.add(accInstance.id);
					oldAccountOwnerIdForOthers.add(accInstance.OwnerId); 
					oldAccountOwnerId.add(accInstance.OwnerId); 
				}
			}
			for(Account newAccInstance : accountListNew){
				for(Account oldAccInstance : accountListOld){
					if(newAccInstance.OwnerId != oldAccInstance.OwnerId && newAccInstance.Id == oldAccInstance.Id && newAccInstance.Partner_Type__c=='Distributor'){
					  userIdToUserIdMapForDistributor.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
					  userIdToUserIdMap.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
				  } else if (newAccInstance.OwnerId != oldAccInstance.OwnerId && newAccInstance.Id == oldAccInstance.Id && newAccInstance.Partner_Type__c =='Indirect Reseller'){
					  userIdToUserIdMapForIndirectReseller.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
					  userIdToUserIdMap.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
				  } else if (newAccInstance.OwnerId != oldAccInstance.OwnerId && newAccInstance.Id == oldAccInstance.Id && newAccInstance.Partner_Type__c =='Value Added Reseller'){
					  userIdToUserIdMapForReseller.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
					  userIdToUserIdMap.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
				  } else {
					  userIdToUserIdMapForOthers.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
					  userIdToUserIdMap.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
				  }
				} 

		}
			List<Lead> leadListForOthers = [SELECT Id, OwnerId FROM Lead WHERE OwnerId IN : oldAccountOwnerIdForOthers Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			List<Lead> leadListForDistributor = [SELECT Partner_Sales_Manager__c,Partner_Sales_Manager__r.Id,id,ownerid,partneraccount.OwnerId,partneraccount.id FROM Lead where PartnerAccountId IN : oldAccountIdForDistributor And (RecordTypeId = '01241000000v9mLAAQ' Or RecordTypeId = '01241000000v9mJAAQ') Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			List<Lead> leadListForIndirectReseller = [SELECT Partner_Sales_Manager__c,Partner_Sales_Manager__r.Id,id,ownerid,partneraccount.OwnerId,partneraccount.id FROM Lead where Indirect_Reseller_Account__c IN : oldAccountIdForIndirectReseller And (RecordTypeId = '01241000000v9mMAAQ' Or RecordTypeId = '01241000000v9mKAAQ') Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			List<Lead> leadListForIndirectReseller1 = [SELECT Partner_Sales_Manager__c,Partner_Sales_Manager__r.Id,id,ownerid,partneraccount.OwnerId,partneraccount.id FROM Lead where PartnerAccountId IN : oldAccountIdForIndirectReseller And (RecordTypeId = '01241000000v9mMAAQ' Or RecordTypeId = '01241000000v9mKAAQ') Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			List<Lead> leadListForReseller = [SELECT Partner_Sales_Manager__c,Partner_Sales_Manager__r.Id,id,ownerid,partneraccount.OwnerId,partneraccount.id FROM Lead where PartnerAccountId  IN : oldAccountIdForReseller And (RecordTypeId = '01241000000v9mOAAQ' Or RecordTypeId = '01241000000v9mNAAQ') Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())] ;
			List<Certification__c> certList = [SELECT Id, OwnerId FROM Certification__c WHERE OwnerId IN : oldAccountOwnerId AND Partner__c IN : oldAccountId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			List<Lead> leadListToUpdate = new List<Lead>();
			List<Certification__c> certListToUpdate = new List<Certification__c>();	 

		   if(!leadListForOthers.IsEmpty()){
				for(Lead leadInstance : leadListForOthers){
					if(userIdToUserIdMapForOthers.containsKey(leadInstance.OwnerId)){
						leadInstance.OwnerId = userIdToUserIdMapForOthers.get(leadInstance.OwnerId);
						// leadListToUpdate.add(leadInstance);
					}			
			  }
			}
			
			if(!leadListForDistributor.IsEmpty()){
				for(Lead leadInstance : leadListForDistributor){
					Id oldAccoutOwner = oldAccountInfoForDistributor.get(leadInstance.partneraccount.id);
						if(oldAccoutOwner == leadInstance.Partner_Sales_Manager__r.Id){
							leadInstance.Partner_Sales_Manager__c = userIdToUserIdMapForDistributor.get(oldAccoutOwner);
							leadListToUpdate.add(leadInstance);  
					}			
			  }
			}


			if(!leadListForDistributor.IsEmpty()){
				for(Lead leadInstance : leadListForDistributor){
					Id oldAccoutOwner = oldAccountInfoForDistributor.get(leadInstance.partneraccount.id);
						if(oldAccoutOwner == leadInstance.OwnerId){
						  leadInstance.OwnerId = userIdToUserIdMapForDistributor.get(oldAccoutOwner);
						   leadListToUpdate.add(leadInstance); 
					}			
			  }
			} 


			if(!leadListForIndirectReseller.IsEmpty()){
				for(Lead leadInstance : leadListForIndirectReseller){
					Id oldAccoutOwner = oldAccountInfoForIndirectReseller.get(leadInstance.partneraccount.id);
						if(oldAccoutOwner == leadInstance.Partner_Sales_Manager__r.Id){
							leadInstance.Partner_Sales_Manager__c = userIdToUserIdMapForIndirectReseller.get(oldAccoutOwner);
							leadListToUpdate.add(leadInstance);
						
					}			
			  }
			}

			if(!leadListForIndirectReseller1.IsEmpty()){
				for(Lead leadInstance : leadListForIndirectReseller1){
					Id oldAccoutOwner = oldAccountInfoForIndirectReseller.get(leadInstance.partneraccount.id);
						if(oldAccoutOwner==leadInstance.OwnerId){
							leadInstance.OwnerId = userIdToUserIdMapForIndirectReseller.get(oldAccoutOwner);
						   leadListToUpdate.add(leadInstance);
						}
							   
			  }
			} 


			if(!leadListForReseller.IsEmpty()){
				for(Lead leadInstance : leadListForReseller){
					 Id oldAccoutOwner = oldAccountInfoForReseller.get(leadInstance.partneraccount.id);
						if(oldAccoutOwner==leadInstance.Partner_Sales_Manager__r.Id){
							 leadInstance.Partner_Sales_Manager__c = userIdToUserIdMapForReseller.get(oldAccoutOwner);
						   leadListToUpdate.add(leadInstance);
						}
								
			  }
			}

			if(!leadListForReseller.IsEmpty()){
				for(Lead leadInstance : leadListForReseller){
					Id oldAccoutOwner = oldAccountInfoForReseller.get(leadInstance.partneraccount.id);
						if(oldAccoutOwner==leadInstance.OwnerId){
							leadInstance.OwnerId = userIdToUserIdMapForReseller.get(oldAccoutOwner);
						  leadListToUpdate.add(leadInstance);
						}
							  
			  }
			} 

		   if(!certList.IsEmpty()){
				for(Certification__c certInstance : certList){
					if(userIdToUserIdMap.containsKey(certInstance.OwnerId)){
						certInstance.OwnerId = userIdToUserIdMap.get(certInstance.OwnerId); 
						certListToUpdate.add(certInstance);
					}			
			  } 
			}
			 Database.update(leadListToUpdate, false);
			 Database.update(certListToUpdate, false); 
			system.debug('DataChange');
			}Catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.AccountOwnerChangeAsync,PRMGlobalConstants.updateLeadandCertificationOwner);
			}

	}
   /*******************************
	*Method name: updateUserManager
	*Description: This Method will Update user Manager After Account Owner Change
	*Parameter: Account Values
	*Modified by SDC at 20180614 ticket#12186
	*******************************/ 
	private void updateUserManager( List<Account> accountListOld , List<Account> accountListNew){
		try{
			Set<id> oldAccountOwnerId = new Set<Id>();
			Set<id> accountIdset = new Set<id>();
			Map<id,id> userIdToUserIdMap = new Map<id,id>();//Account owner old vs new
			Map<id,account> accNewMap = new Map<id,account>();
			Map<id,account> accOldMap = new Map<id,account>();
			for(Account accNewInstance:accountListNew){
				accNewMap.put(accNewInstance.id,accNewInstance);
			}
			for(Account accInstance : accountListOld){
				oldAccountOwnerId.add(accInstance.OwnerId); 
				
				accOldMap.put(accInstance.id,accInstance);
			}
			for(Account newAccInstance : accountListNew){
				for(Account oldAccInstance : accountListOld){
					if(newAccInstance.OwnerId != oldAccInstance.OwnerId && newAccInstance.Id == oldAccInstance.Id){
						accountIdset.add(newAccInstance.id);
				  }
				}		   
			}
			List<User> userList = [SELECT Id,ManagerId,contact.accountid FROM User WHERE contact.accountid in :accountIdset Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			Map<Id,List<user>> accIdUserListMap = new Map<Id,List<user>>();
			for(User u:userList){
				if(u.contact!=null&&u.contact.accountid!=null){
				   if(accIdUserListMap.get(u.contact.accountid)==null){
						List<User> userTempList = new List<User>();
						userTempList.add(u);
						accIdUserListMap.put(u.contact.accountid,userTempList);
				   }else{
					  accIdUserListMap.get(u.contact.accountid).add(u);
				   }
				}
			}
			List<user> userToUpdate = new List<user>();
			for(ID accID:accountIdset){ 
				if(!accIdUserListMap.get(accID).IsEmpty()){
					for(User userInstance : accIdUserListMap.get(accID)){
						Account oldAccount = accOldMap.get(accID);
						Account newAccount = accNewMap.get(accID);
						if(oldAccount.OwnerId == userInstance.ManagerId){
							userInstance.ManagerId =  newAccount.OwnerId;
							userToUpdate.add(userInstance);
						}			
				  	} 
				}
			}
			
			if(!userList.IsEmpty()){
				Database.update(userToUpdate, false); 
			}		
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.AccountOwnerChangeAsync,PRMGlobalConstants.updateUserManager);
		}
	}
	
	/*******************************
	*Method name: accountMemberUpdate
	*Description: This method will add/delete the account memeber
	*Parameter: Account Values
	*******************************/ 
	private void accountMemberUpdate( List<Account> accountListOld , List<Account> accountListNew){
		try{
			Set<id> oldAccountOwnerId = new Set<Id>();
			Set<id> accountIds = new Set<Id>();
			Map<id,id> userIdToUserIdMap = new Map<id,id>();//Account owner old vs new
			Map<id,id> AccountIdToaccNewOwnerMap = new Map<id,id>();
			
			for(Account accInstance : accountListOld){
				oldAccountOwnerId.add(accInstance.OwnerId); 
				accountIds.add(accInstance.Id);			
			}
			for(Account newAccInstance : accountListNew){
				for(Account oldAccInstance : accountListOld){
					if(newAccInstance.OwnerId != oldAccInstance.OwnerId && newAccInstance.Id == oldAccInstance.Id){
					  userIdToUserIdMap.put(oldAccInstance.OwnerId, newAccInstance.OwnerId);
		  AccountIdToaccNewOwnerMap.put(oldAccInstance.Id, newAccInstance.OwnerId);
				  }
				}		   
			}
			List<Account_Member__c> accMemberList = [SELECT Account_Role__c,Account__c,Id,Is_active_User__c,Type__c, Name__c FROM Account_Member__c WHERE Account__c IN : accountIds AND Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER AND Name__c IN : oldAccountOwnerId AND Type__c =: PRMGlobalConstants.Internal Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			List<Account_Member__c> accMemberToBeDeleted = new List<Account_Member__c>();
			List<Account_Member__c> accMemberToBeAdded = new List<Account_Member__c>();
			
			if(!accMemberList.IsEmpty()){
				for(Account_Member__c accMemInstance : accMemberList){
					if(userIdToUserIdMap.containsKey(accMemInstance.Name__c)){
						accMemberToBeDeleted.add(accMemInstance);
					}			
			  } 
			}
			
			if(!AccountIdToaccNewOwnerMap.IsEmpty()){
			   for(id Instance : AccountIdToaccNewOwnerMap.KeySet()){
		  Account_Member__c accmem = new Account_Member__c();
		  accmem.Type__c = PRMGlobalConstants.Internal;
		  accmem.Account_Role__c = PRMGlobalConstants.PARTNER_SALES_MANAGER;
		  accmem.Account__c = Instance;
		  accmem.Name__c = AccountIdToaccNewOwnerMap.get(Instance);
		  accMemberToBeAdded.add(accmem); 
		 } 
			}
			
			if(!accMemberToBeDeleted.IsEmpty()){
				Database.Delete(accMemberToBeDeleted, false);
			} 
			if(!accMemberToBeAdded.IsEmpty()){
				Database.Insert(accMemberToBeAdded, false);
			}	  
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.AccountOwnerChangeAsync,PRMGlobalConstants.accountMemberUpdate);
		}
	}
	
}