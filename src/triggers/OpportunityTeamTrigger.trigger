/***********************************************
*	Trigger Name : OpportunityTeamTrigger
*	Created By : Accenture IDC
*	Created Date :23/Dec/2016
*	Description : This will handle the Opportunity Team Actions
*	Requirement : Doc Strategy Requirement 657
*********************************************/
trigger OpportunityTeamTrigger on OpportunityTeamMember (before insert , before update, After insert , before delete,  after update, after delete) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		//DHCT.DHC_StaticThresholdBreachCalculation.triggerFlow = DHCT.DHC_StaticThresholdBreachCalculation.triggerFlow('OpportunityTeamTrigger', 'OpportunityTeamMember');
	}
	if(Trigger.isUpdate){
		if(Trigger.isAfter){			
		   OpportunityTeamHandler.afterUpdate(Trigger.newMap , Trigger.oldMap);		   
		}
	}
	
	if(Trigger.isDelete){
		 if(Trigger.isBefore){
				OpportunityTeamHandler.beforeDelete(Trigger.old);
				DS_OpportunityTeamHandler.beforeDelete(Trigger.oldMap);
				//Code added to unshare proposal records with Opportunity team members when deleted. Requirement : 2087
				// Added by Puneet Gosain (Nokia CPQ) Date: 22/05/2017
			   //OpportunityTeamHandler.afterDeleteUnshareProposalRecords(Trigger.oldMap);
			}
		 if(Trigger.isAfter){
				OpportunityTeamHandler.afterDelete(Trigger.old);
				OpportunityTeamHandlerPRM.afterDelete(Trigger.old);
	NokiaCPQShareProposalsWithOTM.unshareProposalRecordAfterOTMTriggerDelete(Trigger.oldMap);
		 }
	}
	
	if(Trigger.isInsert){
		 if(Trigger.isBefore){
				OpportunityTeamHandler.beforeInsert(Trigger.new);
				OpportunityTeamHandlerPRM.beforeInsertOTM(Trigger.new[0]);
			}
		  if(Trigger.isAfter){
				//OpportunityTeamHandler.AfterInsert(Trigger.newMap);
				DS_OpportunityTeamHandler.afterInsert(Trigger.newMap);
				OpportunityTeamHandlerPRM.afterInsert(Trigger.new);
				OpportunityTeamHelper_PRM.shareFilesOnInsert(Trigger.new);
	if(!System.isFuture() && !System.isBatch() && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
				  NokiaCPQShareProposalsWithOTM.quoteProposalShare(Trigger.newMap.keyset());
			  }
			}
	}
	//@HCL Team added (oldMap) as a new parameter in OpportunityTeamHandler.beforeUpdate@	  
	// Modified on 4th July 2019
	
	if(Trigger.isUpdate){
		 if(Trigger.isBefore){
			   OpportunityTeamHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
			}
		 if(Trigger.isAfter){
				DS_OpportunityTeamHandler.afterUpdate(Trigger.newMap,Trigger.oldMap);
				OpportunityTeamHandler.afterUpdate(Trigger.newMap,Trigger.oldMap);
			}
	}
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		//DHCT.DHC_StaticThresholdBreachCalculation.fetchRunTimeLimitStatus('OpportunityTeamTrigger', 'OpportunityTeamMember', //DHCT.DHC_StaticThresholdBreachCalculation.triggerFlow);
	 }
}