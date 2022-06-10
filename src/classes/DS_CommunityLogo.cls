/******************************************************************************************************
Name : DS_CommunityLogo
Created Date: 2nd June 2018
Created by: Accenture
Description : This class contains logic for adding Customer Logo in Community		
*********************************************************************************************************/
public with sharing class DS_CommunityLogo {
	
	/******************************
	*Method Name: getCurrentUserData
	*Description: This Method will get the required data for the logged in user
	********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			 
			return [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		 }catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_CommunityLogo , CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
	   }
	}
	/******************************
	*Method Name: getAccountAttachment
	*Description: Getting file from Account
	********************************/
	@AuraEnabled
	public static String getAccountAttachment(){
		 try{
		List<Account> accountList = new List<Account>();
		Set<String> accountNoSet = new Set<String>();
		id doc;
		id accountId = getCurrentUserData().accountId;
		
		Set<id> contentid = new Set<id>();
		for(ContentDocumentLink cdl1 :[select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :accountId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
				contentid.add(cdl1.ContentDocumentId);
			}
		ContentVersion cv  = [SELECT Id,ContentDocumentId,ContentBodyId,Title FROM ContentVersion where title = :CSWXGlobalConstant.cLogo and ContentDocumentId IN:contentid LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		String part1 = Label.DS_logoURLOne;
		String part2 = Label.ExecSumFileURLTwo;
		String urlToLogo = part1+cv.Id+part2+cv.ContentBodyId;
	   
		return urlToLogo;
		 }catch(Exception ex){
					ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_CommunityLogo, CSWXGlobalConstant.getAccountAttachment );
					return NULL;	
		  }
		}
		

}