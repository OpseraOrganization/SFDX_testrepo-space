/*----------------  
 Class Name: DS_Networkoverview 
Created By: Accenture
Created date - 16-7-2018,
Last Modified By: Accenture
Description: This class having logic to display filters and slides on Network Overview tab on DS portal.
 ---------------------------*/
public with sharing class DS_Networkoverview {
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
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_Networkoverview, CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
		 }
	}
	
   /******************************
	*Method Name: getTechnology
	*Description: This Method will get technology from fileupload obj.
	********************************/
	 @AuraEnabled
	public static List<String> getTechnology() {
 
	 List<String> techList = new List<String>();
	 Set<String> techSet = new Set<String>();
	 try{
		 for(File_Upload__c str : [select id,Technology_Txt__c from File_Upload__c where Technology_Txt__c !=: CSWXGlobalConstant.NONE and Account__c =:getCurrentUserData().accountId and  Document_Type__c =: CSWXGlobalConstant.Networkoverview  LIMIT:limitRows ]) {
		   techSet.add(str.Technology_Txt__c);
		 }
	 
		 for(String s:techSet){
			 techList.add(s);
		 }
		 
		return techList;
		  
	
	   }catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Networkoverview,CSWXGlobalConstant.getTechnology);
			 return null;
	   }   
  

	
	 }
	
	 /******************************
	*Method Name: getFiles
	*Description: This Method will get the required PPT based on selected Technology 
	*Parameter:String technology
	********************************/
	  @AuraEnabled
	 public static Map<String,String> getFiles(String technology) {
		 Map<String,String> tabsToFileURL = new Map<String,String>();
		 Set<String> mapKeys = new Set<String>(); 
		 
		 mapKeys.add(CSWXGlobalConstant.NetworkTrends);
		 mapKeys.add(CSWXGlobalConstant.benchmarking);
		 mapKeys.add(CSWXGlobalConstant.InstalledBase);
		 
		 id accountId = getCurrentUserData().accountId;
		 
		 Id fileUploadId;
		 try{
			 if(!String.isBlank(technology) && technology != CSWXGlobalConstant.NONE ){
				 
			   
				 fileUploadId = [select Id from File_Upload__c where Technology_Txt__c =: technology and Document_Type__c =: CSWXGlobalConstant.Networkoverview and Account__c =:accountId limit 1].id;  
				 
				 Set<id> contentid = new Set<id>();
				 for(ContentDocumentLink cdl1 : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :fileUploadId]){
					 contentid.add(cdl1.ContentDocumentId);
					 System.debug('contentid>>>>>'+contentid);
				 }
				   
			   
				 for(ContentVersion cv : [SELECT ContentDocumentId,FileExtension,Title,ContentBodyId FROM ContentVersion where ContentDocumentId IN:contentid]){ 
					 
					 if(cv.Title == CSWXGlobalConstant.NetworkTrends || cv.Title == CSWXGlobalConstant.benchmarking ||cv.Title == CSWXGlobalConstant.InstalledBase){
							
							String part1 = Label.ExecSumFileURLOne;
							String part2 = Label.ExecSumFileURLTwo;
							String part3 = Label.ExecSumFileURLThree;	 
							String urlToPPT = part1+cv.Id+part2+cv.ContentBodyId+part3;							
							tabsToFileURL.put(cv.Title,urlToPPT);
						
					}
				 }
				for(String key : mapKeys){
					 if(!tabsToFileURL.containsKey(key)){
						  tabsToFileURL.put(key,CSWXGlobalConstant.noURL);
					 }
					 
				 }
				return tabsToFileURL;
			}
			 else{
			   for(String key : mapKeys){
					 
						  tabsToFileURL.put(key,CSWXGlobalConstant.noRecord);
						 
					 
				 }
					return tabsToFileURL;
			  }
			}catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Networkoverview,CSWXGlobalConstant.getFiles);
				 return null;
			  }
	 
	 }
	
   
}