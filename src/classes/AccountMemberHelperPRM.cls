/********************************************************************************************************************************************************
Name:			AccountTeamMemberPRM
Description:	 Helper for AccountTeamMember
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/04/2016	  1.0		Sneha			Helper Class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class AccountMemberHelperPRM
{
	/**
* Description : shareLeadOnInsert 
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void shareCertificationOnInsertPSM(List<Account_Member__c> accTeamList, List<User> userList)
	{
		if(accTeamList[0].Account_Role__c == PRMGlobalConstants.PARTNER_SALES_MANAGER ){
			List<Certification__Share> certiShareToInsert  = new List<Certification__Share>();
			set<Id> accId = new set<Id>();
			set<Id> userSet = new set<Id>();
			Map<id,Set<id>> accTeamToAccMap = new Map<id,Set<id>>();
			set<Id> userSet2 = new set<Id>();
			for(user userInst :userList){
				userSet2.add(userInst.id);
			}
			try{
				for(Account_Member__c accTeam : accTeamList)
				{
					Set<id> userId = new Set<id>(); 
					if(accTeamToAccMap.Containskey(accTeam.Account__c)){
						userId = accTeamToAccMap.get(accTeam.Account__c);
					}
					userId.add(accTeam.Name__c);
					accTeamToAccMap.put(accTeam.Account__c,userId);
					userSet.add(accTeam.Name__c);
					accId.add(accTeam.Account__c);
				}
				// List<Certification__c> cerList = [SELECT Id, Partner__c,Owner.ProfileId   FROM Certification__c WHERE Partner__c   in : accId AND
				//		OwnerId IN :  userSet2	Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				
				for(Certification__c cerRec: [SELECT Id, Partner__c,Owner.ProfileId   FROM Certification__c WHERE Partner__c   in : accId AND
											  OwnerId IN :  userSet2	Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				{
					
					for(id userIdInstance : accTeamToAccMap.get(cerRec.Partner__c )){
						Certification__Share share = new Certification__Share();
						share.UserOrGroupId = userIdInstance;
						share.ParentId  = cerRec.Id;
						share.AccessLevel = PRMGlobalConstants.READ;
						share.RowCause = PRMGlobalConstants.MANUAL;
						certiShareToInsert.add(share);
					}
					
				}
				
				if(!certiShareToInsert.IsEmpty()){
					Database.SaveResult[] crList = Database.insert(certiShareToInsert, false);
				}
				
			}catch(Exception e) {
				ExceptionHandler.addException(e,PRMGlobalConstants.AccountTeamMemberPRM,PRMGlobalConstants.shareCertificationOnInsertPSM);
			}
		}  
		
	}
	/**
* Description : shareCertificationOnUpdate 
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void shareCertificationOnUpdatePSM(List<Account_Member__c> accTeamList,Account_Member__c accMemNew , Account_Member__c accMemOld, List<User> userList)
	{
		If(accMemNew.Account_Role__c != accMemOld.Account_Role__c && accMemNew.Account_Role__c != NULL && 
		   (accMemNew.Account_Role__c == PRMGlobalConstants.PARTNER_SALES_MANAGER)){
			   List<Certification__Share> certiShareToInsert  = new List<Certification__Share>();
			   set<Id> accId = new set<Id>();
			   List<Certification__c> cerList = new List<Certification__c> ();
			   set<Id> userSet = new set<Id>();
			   Map<id,Set<id>> accTeamToAccMap = new Map<id,Set<id>>();
			   set<Id> userSet2 = new set<Id>();
			   for(user userInst :userList){
				   userSet2.add(userInst.id);
			   }
			   try{
				   for(Account_Member__c accTeam : accTeamList)
				   {
					   Set<id> userId = new Set<id>(); 
					   if(accTeamToAccMap.Containskey(accTeam.Account__c)){
						   userId = accTeamToAccMap.get(accTeam.Account__c);
					   }
					   userId.add(accTeam.Name__c);
					   accTeamToAccMap.put(accTeam.Account__c,userId);
					   userSet.add(accTeam.Name__c);
					   accId.add(accTeam.Account__c);
				   }
				   cerList = [SELECT Id, Partner__c,Owner.ProfileId   FROM Certification__c 
							  WHERE Partner__c in : accId AND OwnerId IN : userSet2   
							  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				   
				   if(!cerList.IsEmpty()){
					   for(Certification__c cerRec: cerList)
					   {
						   
						   for(id userIdInstance : accTeamToAccMap.get(cerRec.Partner__c )){
							   Certification__Share share = new Certification__Share();
							   share.UserOrGroupId = userIdInstance;
							   share.ParentId  = cerRec.Id;
							   share.AccessLevel = PRMGlobalConstants.READ;
							   share.RowCause = PRMGlobalConstants.MANUAL;
							   certiShareToInsert.add(share);
						   }
						   
					   }
				   }
				   if(!certiShareToInsert.IsEmpty()){
					   Database.SaveResult[] crList = Database.insert(certiShareToInsert, false);
				   }
				   
			   }catch(Exception e) {
				   ExceptionHandler.addException(e,PRMGlobalConstants.AccountTeamMemberPRM,PRMGlobalConstants.shareCertificationOnUpdatePSM); 
			   }
			   
			   
		   }
	}
	/**
* Description : shareCertificationOnUpdate 
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void shareCertificationOnUpdateAccountRolePSM(List<Account_Member__c> accTeamList,Account_Member__c accMemNew , Account_Member__c accMemOld, List<User> userList)
	{
		If(accMemNew.Account_Role__c != accMemOld.Account_Role__c && accMemNew.Account_Role__c != NULL 
		   && (accMemOld.Account_Role__c == PRMGlobalConstants.PARTNER_SALES_MANAGER)){
			   
			   List<Certification__Share> certiShareToDelete  = new List<Certification__Share>();
			   set<Id> accId = new set<Id>();
			   set<Id> userSet = new set<Id>();
			   Map<id,Set<id>> accTeamToAccMap = new Map<id,Set<id>>();
			   set<Id> userSet2 = new set<Id>();
			   for(user userInst :userList){
				   userSet2.add(userInst.id);
			   }
			   try{
				   for(Account_Member__c accTeam : accTeamList)
				   {
					   Set<id> userId = new Set<id>(); 
					   if(accTeamToAccMap.Containskey(accTeam.Account__c)){
						   userId = accTeamToAccMap.get(accTeam.Account__c);
					   }
					   userId.add(accTeam.Name__c);
					   accTeamToAccMap.put(accTeam.Account__c,userId);
					   userSet.add(accTeam.Name__c);
					   accId.add(accTeam.Account__c);
				   }
				   //List<Certification__c> cerList = [SELECT Id, Partner__c,Owner.ProfileId FROM Certification__c WHERE Partner__c in : accId AND OwnerId IN :  userSet2	Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				   
				   Set<id> certSetId=new Set<id>();
				   Set<id> userIDSet=new Set<id>();
				   
				   for(Certification__c cerRec: [SELECT Id, Partner__c,Owner.ProfileId FROM Certification__c 
												 WHERE Partner__c in : accId AND OwnerId IN :  userSet2	
												 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				   {
					   for(ID usersetID : userSet){
						   certSetId.add(cerRec.ID);
						   userIDSet.add(usersetID);
					   }
					   
				   }
				   for(Certification__Share certiShareInstanceToDelete : [Select Id from Certification__Share where UserOrGroupId =: userIDSet AND ParentId =: CertSetId
																		  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				   {
					   certiShareToDelete.add(certiShareInstanceToDelete);
				   }
				   
				   if(!certiShareToDelete.IsEmpty()){
					   Database.DeleteResult[] crList = Database.delete(certiShareToDelete, false);
				   }
				   
			   }catch(Exception e) {
				   ExceptionHandler.addException(e,PRMGlobalConstants.AccountTeamMemberPRM,PRMGlobalConstants.shareCertificationOnUpdateAccountRolePSM); 
			   }
			   
			   
		   }
	}
	
	/**
* Description : unshareCertificationOnDelete 
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void unshareCertificationOnDelete(List<Account_Member__c> accTeamList)
	{
		set<Id> accId = new set<Id>();
		set<Id> userSet = new set<Id>();
		try{
			for(Account_Member__c accTeam : accTeamList)
			{
				userSet.add(accTeam.Name__c);
				accId.add(accTeam.Account__c);
			}
			
			
			//List<Certification__c> cerList = [SELECT Id, Partner__c   FROM Certification__c WHERE Partner__c   in : accId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];	
			
			set<Id> certificationRecIdSet = new set<Id>();
			for(Certification__c certificationRec:  [SELECT Id, Partner__c   FROM Certification__c WHERE Partner__c in : accId 
													 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				certificationRecIdSet.add(certificationRec.Id);
			}
			List<Certification__Share> shareList = [Select Id from Certification__Share where ParentId in : certificationRecIdSet and UserOrGroupId in : userSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			if(!shareList.IsEmpty()){
				Database.DeleteResult[] crList = Database.delete(shareList, false);
			}  
			
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.AccountTeamMemberPRM,PRMGlobalConstants.unshareCertificationOnDelete);	
		}
	}
	/**
* Description : shareFund with Accountmember
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void shareFundOnInsertAccMember(List<Account_Member__c> accTeamList)
	{
		List<Fund__Share> fundShareToInsert = new List<Fund__Share> ();
		set<Id> accId = new set<Id>();
		set<Id> userSet = new set<Id>();
		Map<id,Set<id>> accTeamToAccMap = new Map<id,Set<id>>();
		
		try{
			for(Account_Member__c accTeam : accTeamList)
			{
				Set<id> userId = new Set<id>(); 
				if(accTeamToAccMap.Containskey(accTeam.Account__c)){
					userId = accTeamToAccMap.get(accTeam.Account__c);
				}
				userId.add(accTeam.Name__c);
				// system.debug('userId+++'+userId);
				accTeamToAccMap.put(accTeam.Account__c,userId);
				// system.debug('accTeamToAccMap+++'+accTeamToAccMap);
				userSet.add(accTeam.Name__c);
				// system.debug('userSet+++'+userSet);
				accId.add(accTeam.Account__c);
				// system.debug('accId+++'+accId);
			}
			for(Fund__c fundRec: [SELECT Id, Partner_Name__c, Owner.ProfileId   FROM Fund__c WHERE Partner_Name__c   in : accId 
								  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				
				for(id userIdInstance : accTeamToAccMap.get(fundRec.Partner_Name__c )){
					Fund__Share share = new Fund__Share();
					share.UserOrGroupId = userIdInstance;
					share.ParentId  = fundRec.Id;
					share.AccessLevel = PRMGlobalConstants.EDIT;
					share.RowCause = Schema.Fund__Share.RowCause.Apex_Sharing__c;
					fundShareToInsert.add(share);
				}
				//system.debug('fundRec+++'+fundRec);
				
			}
			
			if(!fundShareToInsert.IsEmpty()){
				Database.SaveResult[] crList = Database.insert(fundShareToInsert, false);
			}
			
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.AccountTeamMemberPRM,PRMGlobalConstants.shareCertificationOnInsertPSM);
		}
		
		
	}
	public static void validateAccMember(List<Account_Member__c> accTeamList, Boolean isUpdate){
		Set<Id> accIds = new Set<Id>();
		Map<Id,List<Account_Member__c>> accMemberMap = new Map<Id,List<Account_Member__c>>();
		String operation = (isUpdate ? 'update' : 'create');
		for(Account_Member__c accMem : accTeamList){
			accIds.add(accMem.Account__c);
		}
		for(Account_Member__c accMem : [Select Id, Account__c, Name__c, Type__c, Account_Role__c from Account_Member__c where Account__c in: accIds]){
			if(accMemberMap.keySet().contains(accMem.Account__c)){
				accMemberMap.get(accMem.Account__c).add(accMem);
			}else{
				List<Account_Member__c> tempList = new List<Account_Member__c>{accMem};
					accMemberMap.put(accMem.Account__c, tempList);
			}
		}
		for(Account_Member__c accMem : accTeamList){
			for(Account_Member__c existingAccMem : accMemberMap.get(accMem.Account__c)){
				if(accMem.Account__c == existingAccMem.Account__c && accMem.Name__c == existingAccMem.Name__c && accMem.Type__c == existingAccMem.Type__c
				   && accMem.Account_Role__c == existingAccMem.Account_Role__c && accMem.Id != existingAccMem.Id){
					   accMem.addError('The Account Member you are trying to ' + operation + ' already exists in this Account Members list');
				   }
			}
		}
	}
}