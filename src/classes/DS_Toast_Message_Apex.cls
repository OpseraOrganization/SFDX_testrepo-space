public with sharing class DS_Toast_Message_Apex {

  @AuraEnabled  
  public static Integer checkApprovalStage(Id recordId)
  {	
	Integer flag = 0;
	Id profileId=userinfo.getProfileId();
	String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
	system.debug('ProfileName'+profileName);
	//List<Apttus_Proposal__Proposal__History> proplistHistory = new List<Apttus_Proposal__Proposal__History>();
	List<Apttus_Proposal__Proposal__c> proplist =new List<Apttus_Proposal__Proposal__c>();
	
	String ApprovalStage = CSWXGlobalConstant.QP_HISTORY;
	
	//proplistHistory = [Select Id, NewValue, OldValue, ParentId from Apttus_Proposal__Proposal__History WHERE Field =: ApprovalStage AND ParentId =: recordId LIMIT: Limits.getLimitQueryRows()- Limits.getQueryRows()];
	proplist=[Select Id,Apttus_Proposal__Approval_Stage__c, Changed_Approval_Stage__c, LOA_Status__c from Apttus_Proposal__Proposal__c  where id=:recordId LIMIT: Limits.getLimitQueryRows()- Limits.getQueryRows()];
	List<Apttus_Proposal__Proposal__c> proplist2 =new List<Apttus_Proposal__Proposal__c>();
	for(Apttus_Proposal__Proposal__c prop: proplist){
	  if(prop.Changed_Approval_Stage__c && (prop.LOA_Status__c==CSWXGlobalConstant.LOA_STATUS || prop.LOA_Status__c==CSWXGlobalConstant.APPROVED) && profileName=='Nokia Sales Profile'){
		flag = 1;
		prop.Changed_Approval_Stage__c=false;
		proplist2.add(prop);
		
	  }
	}
	update proplist2;
	return flag;
	  
  }  
}