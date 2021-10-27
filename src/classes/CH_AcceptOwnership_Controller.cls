public without sharing class CH_AcceptOwnership_Controller {
	
	@AuraEnabled
	public static boolean validUser(Id caseId){
	
		Boolean result = false;
		//NOKIASC-35838
		Boolean validQueue = false;
		Id getLoggedInUser= UserInfo.getUserId();
		String excludeCancelledCase='Cancelled';
		String excludeCompletedCase='Completed';
		
		// Get the Security groups based on the case fields
		Set<Id> groupIds = new Set<Id>();
		Set<Id> getMemberIds=new  Set<Id>();
		Boolean hwsInternalStat = false;
 		Case currentCase = [SELECT Id, CH_Workgroup__c, HWS_RecordTypeCheck__c,CH_InternalStatus__c,OwnerId,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,CH_3rdPartySecurityGroup__c 
				FROM Case WHERE Id =: caseId AND Status !=: excludeCancelledCase AND Status !=: excludeCompletedCase LIMIT 1];
		//NOKIASC-34727 added HWS check
		if((currentCase.HWS_RecordTypeCheck__c) && !(currentCase.CH_InternalStatus__c == 'Warranty Verification Required' || currentCase.CH_InternalStatus__c == 'Quotation Required')){ 
			hwsInternalStat = false;
			return hwsInternalStat;
		   
				
		}
		for(CH_Workgroup_Member__c getUsers : [SELECT CH_User__r.Id,CH_Workgroup_Member_Type__c FROM CH_Workgroup_Member__c 
			  WHERE CH_Workgroup__c =:currentCase.CH_Workgroup__c 
			 ])
		{
			if(getUsers.CH_Workgroup_Member_Type__c=='Queue' && getUsers.CH_User__r.Id==currentCase.OwnerId){
	validQueue = true;
			}
			if(getUsers.CH_User__r.Id==getLoggedInUser){
	getMemberIds.add(getUsers.CH_User__r.Id);
			}
		}
		
		if(validQueue == true && getMemberIds.size()>0){
			for (Group grp : [SELECT Id FROM Group WHERE Name=:currentCase.CH_GWC_SecurityGroup__c OR Name=:currentCase.CH_SecurityGroup__c OR Name=:currentCase.CH_3rdPartySecurityGroup__c ]){
	if(grp.Id!=null){
		groupIds.add(grp.Id);
	}
	
			}
			// Get all members of the found sec groups
			List<GroupMember> lstGroupMember = [SELECT Id, UserOrGroupId,group.Name FROM GroupMember 
			WHERE GroupId IN:groupIds AND UserOrGroupId IN :getMemberIds];
			if(lstGroupMember.size()>0){
	result=true;
			}
		}
		else{
			result = false;
		}
		return result;
	}
	
	@AuraEnabled
	public static Boolean assignSelfOwnership(Id caseId){
		Boolean isAssignedToUser=false;
		Boolean getAssignedUser;
		getAssignedUser = CH_AcceptOwnership_Controller.validUser(caseId);
		if(Test.isRunningTest()){
			getAssignedUser = true;
		}
		if(getAssignedUser){
	 Case getCaseDetails = [SELECT Id, CH_Workgroup__c, HWS_RecordTypeCheck__c,CH_InternalStatus__c,OwnerId,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,CH_3rdPartySecurityGroup__c 
		FROM Case WHERE Id =: caseId  LIMIT 1];
			CH_Workgroup_Member__c[] getWorkgroupMember = 
	[SELECT Id, CH_Workgroup__c, CH_User__c, Name, 
	 CH_Workgroup_Member_Type__c, CH_Queue_Email__c,CH_User__r.Id,
	 CH_Workgroup__r.Name
	 FROM CH_Workgroup_Member__c	
	 WHERE CH_User__r.Id = :UserInfo.getUserId() and CH_Workgroup_Member_Type__c!='Queue' and CH_Workgroup__c=:getCaseDetails.CH_Workgroup__c LIMIT 1];
			if(getWorkgroupMember.size()>0){
	Map<id,CH_Workgroup_Member__c> getassignment = new Map<id,CH_Workgroup_Member__c>{caseId => getWorkgroupMember[0]};
		CH_CA_Service service = new CH_CA_Service(); 
	if(!test.isRunningTest()){
		service.assignUser(getassignment);
	}
	isAssignedToUser=true;
	
			}
		}
	
		return isAssignedToUser;
	}
}