public class DS_ContentDocumentTriggerHelper {
  /*****************************
 *Method Name:restrictDelete
 *Description: Method to restrict deletion of files from DP and Quote Proposal based on particular Status
 *Parameters:contentDoclink
 *Test coverage from: 
 *******************************/
public static void restrictDelete(List<ContentDocument> contentDoclink){
		
	Set<Id> contentDocIdSet=new Set<Id>();
	Set<Id> Linked_Entity_Set=new Set<Id>();
	Map<Id,String> dpidtodpstatusmap = new Map<Id,String>();
	Map<Id,String> qpIdToQpStatusMap = new Map<Id,String>();
	Map<Id,Id> dpIdtodpRecordTypeId = new Map<Id,Id>();
	Map<Id,Id> qpIdtoqpRecordTypeId = new Map<Id,Id>();
	String analyticsSource;
	String userId  = UserInfo.getUserId();
	boolean flag1= false;   
	boolean flag2= false;
	User user1 =[SELECT Id, IsPortalEnabled from User where id=: userId];
	List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
   
	try{
	
		for(ContentDocument cd : contentDoclink){
			contentDocIdSet.add(cd.Id);
		}
		
		for(ContentDocumentLink cdl :[Select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink 
										where ContentDocumentId IN : contentDocIdSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows()) ]){	
			cdlList.add(cdl);
			Linked_Entity_Set.add(cdl.LinkedEntityId);
		}
	
		if(!Linked_Entity_Set.isEmpty() ){
			for(SWx_Upsell_Proposal__c dp: [Select Id,RecordTypeId, Upsell_Status__c, Proposal_Status__c, Analytics_Source__c from SWx_Upsell_Proposal__c where Id IN :Linked_Entity_Set Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				dpidtodpstatusmap.put(dp.Id,dp.Proposal_Status__c);
				dpIdtodpRecordTypeId.put(dp.Id,dp.RecordTypeId);
			}
			for(Apttus_Proposal__Proposal__c qp: [Select Id,RecordTypeId, Analytics_Source__c, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Id IN :Linked_Entity_Set Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				qpIdToQpStatusMap.put(qp.Id, qp.Apttus_Proposal__Approval_Stage__c);
				qpIdtoqpRecordTypeId.put(qp.Id, qp.RecordTypeId);
				analyticsSource = qp.Analytics_Source__c;
			}
		}
	
		for(ContentDocument cdoc : contentDoclink){
				
			for(ContentDocumentLink cdl1 : cdlList){
			  
			   System.debug('object --->'+cdl1.LinkedEntityId.getSObjectType().getDescribe().getName());
				if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP)){
					String statusdp = dpidtodpstatusmap.get(cdl1.LinkedEntityId);
				  
				   if(dpIdtodpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.CXMDPReadOnlyLayout).getRecordTypeId()  ){
						flag1=true;
					}
				}
				else if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes) ){
					String statusQp= qpIdToQpStatusMap.get(cdl1.LinkedEntityId);
				   
				   
				   if(qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteReadOnlyLayout).getRecordTypeId()  ){
						 flag2=true;
					}   
					if(user1.IsPortalEnabled && statusQp.equalsIgnoreCase(CSWXGlobalConstant.Approval_stage_rework) && qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId()){
						
						flag2=true;
					}
				}
		
				if(flag1){
					cdoc.addError(CSWXGlobalConstant.restrictFileUploadOnDpErrorMessage);
				}
				if(flag2){
					cdoc.addError(CSWXGlobalConstant.restrictFileUploadOnQpErrorMessage);
				}
				if(flag1 & flag2){
					cdoc.addError(CSWXGlobalConstant.restrictFileUploadOnDpNQpErrorMessage);
				}
			}
		}
	}catch (Exception ex) { 
	  ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContentDocumentTriggerHelper,CSWXGlobalConstant.restrictDeletemethod);
		}
	}   
			 
			 
}