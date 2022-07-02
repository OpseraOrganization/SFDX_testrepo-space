public with sharing class NokiaCPQLaunchCATController {
	
	public String cartId {get; set;}
	public String lineItemId {get; set;}
	public String country {get; set;}
	public String configMode {get; set;}
	public String configName {get; set;}
	public String showDebugMode {get; set;}
	public boolean externalConfiguration {get; set;}
	public String externalMaterial  {get; set;}
	public String externalSystemLink {get; set;}
	public string notesBody {get; set;}
	public String newConfig {get; set;}
	public List<Apttus_Config2__LineItem__c> currentLIList {get;set;}
	
	public NokiaCPQLaunchCATController(){
		newConfig = 'true';
		List<Attachment> configData = new List<Attachment>();
		List<CAT_Config_Mode_Setting__c> configModeRecordList = new List<CAT_Config_Mode_Setting__c>();
		List<String> debugModeUsers = new List<String>();
		cartId = ApexPages.currentPage().getParameters().get('id');
		lineItemId = ApexPages.currentPage().getParameters().get('lineItemId'); 
		
		currentLIList = [SELECT Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.NokiaCPQ_External_Configuration__c,
						 Apttus_Config2__ProductId__r.NokiaCPQ_External_Material_Number__c, Apttus_Config2__ProductId__r.NokiaCPQ_Link_To_External_Configuration__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__r.CountryNameISO2__c FROM Apttus_Config2__LineItem__c 
						 WHERE Id =: lineItemId LIMIT 1];
		
		externalConfiguration = currentLIList[0].Apttus_Config2__ProductId__r.NokiaCPQ_External_Configuration__c;
		externalMaterial = currentLIList[0].Apttus_Config2__ProductId__r.NokiaCPQ_External_Material_Number__c;
		externalSystemLink = currentLIList[0].Apttus_Config2__ProductId__r.NokiaCPQ_Link_To_External_Configuration__c;
		if(currentLIList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null){
			configName = currentLIList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c;
		}
		
		if(currentLIList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null && currentLIList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c != null){
			country = currentLIList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__r.CountryNameISO2__c;
		}
		
		List<Profile> currentProfile = [Select Id, Name from Profile where Id =: userinfo.getProfileId() LIMIT 1];
		if(currentProfile != null && !currentProfile.isEmpty()){
			configModeRecordList = [Select Profile__c, Configuration_Mode__c From CAT_Config_Mode_Setting__c Where Profile__c =: currentProfile[0].Name];
			
			if(!configModeRecordList.isEmpty()){
				configMode = configModeRecordList[0].Configuration_Mode__c;
			}
			else{
				configMode = 'BASIC';
			}
		}
		
		//Identify debug mode users
		if(Label.CPQ_Debug_Mode_Users != null){
			debugModeUsers = Label.CPQ_Debug_Mode_Users.split(';');
			User currentuser = [Select Id, Username From User Where id=: UserInfo.getUserId()];
			if(!debugModeUsers.isEmpty() && currentuser != null && debugModeUsers.contains(currentuser.Username)){
				showDebugMode = 'true';
			}
		}
		configData = [SELECT Body,Id FROM Attachment WHERE ParentId =: lineItemId Limit 1];
		
		if(!configData.isEmpty()){
			newConfig = 'false';
			Blob attachBody = configData[0].Body;
			notesBody = EncodingUtil.base64Encode(attachBody);
		}
	}
	
   
}