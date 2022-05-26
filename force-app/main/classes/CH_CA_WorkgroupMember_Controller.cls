public without sharing class CH_CA_WorkgroupMember_Controller {
	// Get user name
	@AuraEnabled
	public static string getUserName(String userId){
		return [SELECT Name FROM User WHERE Id = :userId LIMIT 1].Name;
	} 
	
	// Get dummy queue userid
	@AuraEnabled
	public static string getQueueUserId(){
		String resultId = '' ;
		List<CH_Queue_User__c> listQueueUser= [select id, Username__c, email__C from CH_Queue_User__c];
		if(listQueueUser.size()>0){
			resultId =  [SELECT Id FROM User WHERE username = : listQueueUser[0].Username__c LIMIT 1].Id;
		}
		return resultId;
	} 
	
	 @AuraEnabled
	public static String checkloggedUser(){
		return UserInfo.getUserId();		
	}	
	@AuraEnabled
	public static List<String> getRoleList() {  
		List<String> pickListValues= new List<String>();
		pickListValues.add('--None--');
		Schema.DescribeFieldResult fieldResult = CH_Workgroup_Member__c.CH_Role__c.getDescribe();
		List<Schema.PicklistEntry> listOfValues = fieldResult.getPicklistValues();
		System.debug('CH_CA: listOfValues -'+ listOfValues);
		// System.debug('CH_CA: listOfValues1 -'+ JSON.serialize(listOfValues));
		if(listOfValues.size()>0){
			for( Schema.PicklistEntry pickListVal : listOfValues){
				pickListValues.add(pickListVal.getLabel());
			} 
		}
		pickListValues.sort();
		return pickListValues;
	}
	//get record aginst workgroup member id
	@AuraEnabled
	public static List<CH_Workgroup_Member__c> getWorkgroupMemberDetails(String wgMemberId){
		return [SELECT Id,CH_User__c,CH_User__r.Name,CH_User__r.Id,CH_Role__c,CH_Off_Duty__c,CH_Workgroup__c,CH_Workgroup__r.Id,CH_Workgroup__r.Name,CH_Workgroup_Member_Type__c,CH_HotlinePhone__c,CH_Description__c 
				FROM CH_Workgroup_Member__c 
				WHERE Id =: wgMemberId LIMIT 1];
	}
	@AuraEnabled	
	public static void editWorkgroupMember(String Id, Boolean chkOffDuty){
		
		CH_Workgroup_Member__c updateWGMember=[ SELECT Id,CH_User__c,CH_Role__c,CH_Off_Duty__c,CH_Workgroup__c,CH_Workgroup_Member_Type__c 
											   FROM CH_Workgroup_Member__c  
											   WHERE Id =: Id LIMIT 1];
		
		updateWGMember.CH_Off_Duty__c=chkOffDuty;		  
		update  updateWGMember;		 
		
	}
	
	@AuraEnabled
	public static void updateWorkgroupMember(Id  getRecordId, Boolean offDutyValue){
		System.debug('CH_CA: Record' + getRecordId);
		CH_Workgroup_Member__c returnWorkgroupMember =new CH_Workgroup_Member__c();
		CH_Workgroup_Member__c recordTypeList = [SELECT Id, CH_RecordTypeName__c,RecordTypeId,CH_Workgroup_Member_Type__c,CH_User__c,
												 CH_Off_Duty__c FROM CH_Workgroup_Member__c 
												 WHERE Id = :getRecordId LIMIT 1];
		try{
			
			recordTypeList.CH_Off_Duty__c=offDutyValue; 
			system.debug('recordTypeListq'+recordTypeList);
			update recordTypeList;
			system.debug('recordTypeListw'+recordTypeList);
		}
		
		// returnWorkgroupMember=recordTypeList;
		
		//return recordTypeList;
		
		catch (system.QueryException e){
			System.debug('CH_CA: exception occured' + e);
			
			// return null;
		}
		
	}
	//get record aginst workgroup member id
	@AuraEnabled
	public static CH_Workgroup_Member__c getCloneData(String recordId){
		CH_Workgroup_Member__c  workgroupMember=   [SELECT Id,Name,CH_User__c,CH_User__r.Name,CH_User__r.Id,CH_Role__c,CH_Off_Duty__c,CH_Workgroup__c,CH_Workgroup__r.Id,CH_Workgroup__r.Name,CH_Workgroup_Member_Type__c,CH_Queue_Email__c,CH_HotlinePhone__c,CH_Description__c 
													FROM CH_Workgroup_Member__c 
													WHERE Id =: recordId LIMIT 1];
		CH_Workgroup_Member__c cloneworkgroupMember = workgroupMember.clone(false, false, false, false);
		
		
		return cloneworkgroupMember;
	}
}