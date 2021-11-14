/*----------------  
 Class Name: DS_ContractOverview 
Created By: Accenture
Created date - -7-2018,
Last Modified By: Accenture
Description: This class having logic to display filters and slides on Contract Overview tab on DS portal.
 ---------------------------*/
public with sharing class DS_ContractOverview {
	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();	
	
	/******************************
	*Method Name: getCurrentUserData
	*Description: This Method will get the required data for the logged in user
	********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			  return [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;  
		 }
	}
	
   /******************************
	*Method Name: getFrameContractReference
	*Description: This Method will get Frame Contract Reference from fileupload obj.
	********************************/ 
	 @AuraEnabled
	public static List<String> getFrameContractReference() {
	 List<String> frameContractRefList = new List<String>();
	 Set<String> frameContractRef = new Set<String>();
	 id accountId = getCurrentUserData().accountId;
	 try{
		 for(File_Upload__c str : [select id,Frame_Contract_Reference__r.Name,Technology_Txt__c,Frame_Contract_Reference__r.Apttus__FF_Agreement_Number__c   from File_Upload__c where  Frame_Contract_Reference__r.Apttus__Account__c =:accountId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		   frameContractRef.add(str.Frame_Contract_Reference__r.Name + CSWXGlobalConstant.dash + str.Frame_Contract_Reference__r.Apttus__FF_Agreement_Number__c);
		 }
		 frameContractRefList.addAll(frameContractRef);
		 return frameContractRefList;
	   }catch (Exception ex) { 
		  ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContractOverview ,CSWXGlobalConstant.getFrameContractReference);
		  return null;
	   }   
	 }
	   
	 /******************************
	*Method Name: getPO
	*Description: This Method will get PO from fileupload obj.
	********************************/ 
	 @AuraEnabled
	public static List<String> getPO() {
	 List<String> poList = new List<String>();
	 id accountId = getCurrentUserData().accountId;
	 Set<String> poSet = new Set<String>();
	 try{
		 for(File_Upload__c str : [select id,Frame_Contract_Reference__r.Name, Purchase_Order__r.Name,Technology_Txt__c from File_Upload__c where Purchase_Order__r.Apttus_Config2__AccountId__c = :accountId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		   poSet.add(str.Purchase_Order__r.Name);
		 }
		  
		 poList.addAll(poSet);
		 return poList;
	   }catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContractOverview ,CSWXGlobalConstant.getPO);
			 return null;
	   }   
	 }
	
	 /******************************
	*Method Name: getFiles
	*Description: This Method will get the required PPT based on selected PO and Agreement 
	*Parameter:String frameContractRef,String po
	********************************/
	  @AuraEnabled
	 public static String getFiles(String frameContractRef,String po) {
		 	
			String[] frameContractRefNumber = frameContractRef.split(CSWXGlobalConstant.dash);
			String frameContractRefNo =frameContractRefNumber[1];
			system.debug('frameContractRefNumber'+frameContractRefNumber);
		 	system.debug('frameContractRefNo'+frameContractRefNo);
			String urlToPPT;   
			try{
			id accountId = getCurrentUserData().accountId;
			Id fileUploadId = [select Id from File_Upload__c where Frame_Contract_Reference__r.Apttus__FF_Agreement_Number__c= :frameContractRefNo AND Purchase_Order__r.Name=:po AND Account__c =:accountId limit 1].id;
				 Set<id> contentid = new Set<id>();
				 for(ContentDocumentLink cdlink : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :fileUploadId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){ 
					 contentid.add(cdlink.ContentDocumentId);
				 }
				 
			if(!contentid.isEmpty()){
			   for(ContentVersion cv : [SELECT ContentDocumentId,FileExtension,Title,ContentBodyId FROM ContentVersion where ContentDocumentId IN:contentid AND Title=:CSWXGlobalConstant.contractOverview LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]){	 
							String part1 = Label.ExecSumFileURLOne;
							String part2 = Label.ExecSumFileURLTwo;
							String part3 = Label.ExecSumFileURLThree;	 
							urlToPPT = part1+cv.Id+part2+cv.ContentBodyId+part3;													  
				 }
				}else{ 
					urlToPPT=CSWXGlobalConstant.no_URL;
				}

			return urlToPPT;
	 }catch (Exception ex) { 
			 ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContractOverview ,CSWXGlobalConstant.getFiles);
			 return CSWXGlobalConstant.NONE;  
	   }  
   }  
}