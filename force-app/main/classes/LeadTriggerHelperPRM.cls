/****************************************
 *Class Name : leadTriggerHelperPRM
 *Created Date: 27 July 2017
 *Created By : Accenture
 *Last Modified by: Accenture
 *Last Modified Date: 27 July 2017
 *Description : Contains Business Logic of Lead Trigger (It Contains Functionality of PRM)
 *Test Class: LeadTriggerHelperTest
 *****************************************/
public without sharing class LeadTriggerHelperPRM {
	
	/*******************************
	*Method name: MakeCommnetsMandatoryForResubmmition
	*Description: This Method will make Description mandatory when partner tries to resubmit "Rejected" Deal.
	*Parameter: Lead Values
	*******************************/  
   public static void makeCommentsMandatoryRejectedDeal(List<Lead> leadNewList, List<Lead> leadOldList) {	
	  try{   
	   if(leadOldList[0].Status ==PRMGlobalConstants.REJECTED_STATUS  && leadNewList[0].Status ==PRMGlobalConstants.PendingApproval) {
		   if(leadNewList[0].Rejection_Description__c  == leadNewList[0].Description ){
				leadNewList[0].addError(System.Label.Description_check_before_Resubmitting_Lead);
		   }
	   } 
	  }
	   catch(Exception e) {ExceptionHandler.addException(e,PRMGlobalConstants.LEAD_TRIGGER_HALPER,PRMGlobalConstants.makeCommentsMandatoryRejectedDeal);
		}   
	}   
	
	/*******************************
	*Method name: updateValueAssignment
	*Description: Lead PSM Update when assigned to Partner
	*Parameter: Lead Values
	*******************************/  
	public static void updateValueAssignment(List<Lead> leadList,Map<id,Lead>leadOldMap) {
		List<Lead> leadToUpdate = new List<Lead>();
		try{
			for(Lead leadInstance : [SELECT OwnerId,Owner.ProfileId,RecordTypeId,Status FROM Lead where Id IN: leadList Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			if(leadInstance.ownerId != leadOldMap.get(leadInstance.Id).ownerId){
				if((leadInstance.Owner.ProfileId == System.Label.Partner_User_ID && leadInstance.RecordTypeId == System.Label.Direct_Sales_Label) ||(leadInstance.Owner.ProfileId == System.Label.PRM_User_Id && leadInstance.RecordTypeId == System.Label.Direct_Sales_Label) ){
					if(leadInstance.Status == PRMGlobalConstants.OpenLead ||leadInstance.Status == PRMGlobalConstants.RedirectedPRM ){
						leadInstance.Lead_value_assigment__c = PRMGlobalConstants.SentToPartner ;
						leadToUpdate.add(leadInstance);
					}
				}
			}
		}
		if(!leadToUpdate.IsEmpty()){
			update leadToUpdate;
		}
		} catch(Exception e) { ExceptionHandler.addException(e,PRMGlobalConstants.LEAD_TRIGGER_HALPER,PRMGlobalConstants.updateValueAssignment);
		} 
		
			
	}
	public static void ShareToDistributorPRM(List<Lead> leadNew)
	{
		try
		{
		   /********Lead share with DistributorPRM__c ********/
			 List<LeadShare> leadShareToDistributorPRM = new List<LeadShare> ();
			 for(Lead lead : leadNew)
			 {
					 LeadShare share = new LeadShare();
					 share.UserOrGroupId = lead.DistributorPRM__c;
					 share.LeadId = lead.Id;
					 share.LeadAccessLevel = PRMGlobalConstants.EDIT;
					 share.RowCause = PRMGlobalConstants.MANUAL;
					 leadShareToDistributorPRM.add(share);
				
			 }
			 Database.SaveResult[] srListoDistributorPRM= Database.insert(leadShareToDistributorPRM, false); 
		}
		catch(Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.LEAD_TRIGGER_HANDLER_PRM,PRMGlobalConstants.afterUpdateLead);
		}
	}
}//end of class LeadTriggerHepler