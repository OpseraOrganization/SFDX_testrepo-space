/******************************
	*Class Name: DS_SWMPExecSummary
	*Description: This class is used to display Executive Summary PPT of SWMP in Customer portal
	********************************/
public with sharing class DS_SWMPExecSummary {
	
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
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_SWMPExecSummary, CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
	   }
	}
	/******************************
	*Method Name: getAccountAttachment
	*Description: Getting file from Account for Catalogue Executive Summary 
	********************************/
	@AuraEnabled
	public static String getAccountAttachment(){
		try{
			List<Account> accountList = new List<Account>();
			Set<String> accountNoSet = new Set<String>();
			id doc;
			id accountId = getCurrentUserData().accountId;
			
			Set<id> contentid = new Set<id>();
			for(ContentDocumentLink cdl1 :[select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :accountId  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
					contentid.add(cdl1.ContentDocumentId);
				}
			
		   
			ContentVersion cv  = [SELECT Id,ContentDocumentId,ContentBodyId,Title FROM ContentVersion where title =:CSWXGlobalConstant.SWMPExecSummary and ContentDocumentId IN:contentid  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			String part1 = Label.ExecSumFileURLOne;
			String part2 = Label.ExecSumFileURLTwo;
			String part3 = Label.ExecSumFileURLThree;	 
			String urlToPPT = part1+cv.Id+part2+cv.ContentBodyId+part3; 
			return urlToPPT;
			 
		}catch(Exception ex){
					ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_SWMPExecSummary, CSWXGlobalConstant.getAccountAttachment );
					return CSWXGlobalConstant.No_URL;	
		  }
		}
}