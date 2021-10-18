/***********************************************
*	Class Name : AttachmentHandler
*	Created By : Accenture IDC
*	Created Date :13/May/2019
*	Description : To restrict uploading file on DP and Quote 

*********************************************/
Public  class DS_AttachmentHandler {


 /***************************************
*Method Name: beforeDelete
*Description: To restrict adding file in attachement obj 
*Parameters: attachenment record list
*****************************************/
	public static void beforeDelete(List<Attachment> attList) {
		System.debug('attList--->'+attList);
		try{
		
	
		Set<id> newIdSet=new Set<id>();
		For(Attachment ac:attList){
			newIdSet.add(ac.parentId); 
		}
	
	
		List<SWx_Upsell_Proposal__c> dpList =  [Select Id,RecordTypeId,Name, Upsell_Status__c, Proposal_Status__c, Analytics_Source__c from SWx_Upsell_Proposal__c where Id IN:newIdSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
		
		List<Apttus_Proposal__Proposal__c> qpList = [Select Id,RecordTypeId,Revision_Status__c, Analytics_Source__c, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Id IN :newIdSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
		   
		
	   
		if(!dpList.isEmpty())
		{
			
				for(SWx_Upsell_Proposal__c dp : dpList)
					for(Attachment att : attList)
					{	 
						if(att.ParentId==dp.id){  
						String Status =  dp.Proposal_Status__c;
						System.debug('status---->'+Status);
						
						 
							if(dp.RecordTypeId ==Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal Read Only').getRecordTypeId() || dp.RecordTypeId == Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('DS SWMP Proposals Read Only').getRecordTypeId()){
								
								att.addError(CSWXGlobalConstant.restrictFileUploadOnDpErrorMessage );
							
							}
						}
					
					}
				}
	
	   
		
		
			if(!qpList.isEmpty())
			{
				
				for(Apttus_Proposal__Proposal__c qp : qpList)
					for(Attachment att : attList)
					{	  
						if(att.ParentId==qp.id){  
							
							if(qp.RecordTypeId == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal Read Only').getRecordTypeId()){
								
								att.addError(CSWXGlobalConstant.restrictFileEditOnQpErrorMessage );
							
							}
						}
					
					}
			 }
		 }catch(Exception e){
				ExceptionHandler.addException(e,CSWXGlobalConstant.DS_AttachmentHandler  ,CSWXGlobalConstant.filebeforeDelete );
		   }	
		}
	   
   }