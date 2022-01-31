public with sharing  class DirectQuoteSharingWCustTriggerHelper{
 
 /*****************************
	 *Method Name: afterInsertQuoteShare
	 *Description: To create Quote Share 
	 *Parameters: List of quote proposals
	*******************************/
   public static void shareDirectQuoteWithCustomer(List<Apttus_Proposal__Proposal__c > records){
		try{
			Map<String,String> mapOfQuoteAccount=new Map<String,String>();

			Map<Id, List<User>> userAccountMap = new Map<Id,List<User>>();
			Set<Id> userIdSet = new Set<Id>();
			
			Map<String,Apttus_Proposal__Proposal__Share> propShareMap = new Map<String,Apttus_Proposal__Proposal__Share>();
			for(Apttus_Proposal__Proposal__c quo:records){
				if(quo.LOA_Status__c==CSWXGlobalConstant.quoteShareApproved && quo.Apttus_Proposal__Approval_Stage__c==CSWXGlobalConstant.quoteShareApproved){
					mapOfQuoteAccount.put(quo.id,quo.Apttus_Proposal__Account__c);
				}
				if(quo.Revision_Status__c=='Revision'){
					mapOfQuoteAccount.put(quo.id,quo.Apttus_Proposal__Account__c);
				}
					
			}
			System.debug('mapOfQuoteAccount>>>>>>'+mapOfQuoteAccount);
			if(!mapOfQuoteAccount.isEmpty()) 
			{
			   List<String> keys = mapOfQuoteAccount.values();
			   List<User> lstUser;
			   String userQuery = 'Select Id,Profile.Name,Name,ContactID,AccountId from User where AccountId=:keys  '+Label.DS_User_Filter_for_Quote_Share_With_Community_user;
			   for(User listUser : Database.Query(userQuery))
				{
					//userAccountMap.put(listUser.Id, listUser.AccountId);
					userIdSet.add(listUser.Id);
					if(!userAccountMap.containsKey(listUser.AccountId)) {
						lstUser = new List<User>();
						lstUser.add(listUser);
					}
					else {
						lstUser = new List<User>(); 
						lstUser = userAccountMap.get(listUser.AccountId);
						lstUser.add(listUser);
					}
					userAccountMap.put(listUser.AccountId,lstUser);	 
				}
			
				//Creates the logics for existence of Quote share. 
				List<Apttus_Proposal__Proposal__Share> propShareList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, IsDeleted FROM Apttus_Proposal__Proposal__Share where ParentId IN : mapOfQuoteAccount.keyset() and  UserOrGroupId IN :userIdSet];
				
				for(Apttus_Proposal__Proposal__Share objPropShare : [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, IsDeleted FROM Apttus_Proposal__Proposal__Share where ParentId IN : mapOfQuoteAccount.keyset() and  UserOrGroupId IN :userIdSet]) {
					String Key  = objPropShare.ParentId + '-'+ objPropShare.UserOrGroupId;
					if(!propShareMap.containsKey(Key)) {
						propShareMap.put(Key,objPropShare);
					}
				}
			
				List<Apttus_Proposal__Proposal__Share> quoteShareList = new List<Apttus_Proposal__Proposal__Share>();
				Apttus_Proposal__Proposal__Share objQShare;
				for(String quoteId:mapOfQuoteAccount.keyset()){
					
				   Id AccountIdVal = mapOfQuoteAccount.get(quoteId);
				   if(userAccountMap.containsKey(AccountIdVal)) {
					   
					   for(User objUser :  userAccountMap.get(AccountIdVal)) {
						   String keyValue = quoteId + '-'+objUser.Id;
						   if(!propShareMap.containsKey(keyValue)) {
							  objQShare = new  Apttus_Proposal__Proposal__Share();
							  objQShare.ParentId = quoteId;
							  objQShare.UserOrGroupId = objUser.Id;
							  objQShare.AccessLevel = 'Edit';
							  quoteShareList.add(objQShare);
						   }
						  
					   }
				   }
				   
				   
					
				}
				if(!quoteShareList.isEmpty()){
					insert quoteShareList;
				}
			}
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.updateQuoteShareHelper);
			   
		}  
	 }
	 
}