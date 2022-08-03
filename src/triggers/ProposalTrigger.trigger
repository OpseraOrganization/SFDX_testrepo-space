/****************************************
 * Trigger Name : ProposalTrigger   
 * Created Date: 8 December 2017
 * Created By : Accenture
 * Description : This trigger routes the records to a helper class 
 
 Updated- 12-March: App - DS, Added logic to create configuration and configuration lineitem 
 *****************************************/
Trigger ProposalTrigger on Apttus_Proposal__Proposal__c (Before insert,after insert, Before Update,After Update,Before delete){ 
	if(!Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER) {
	 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		
		if(Trigger.isBefore&&(Trigger.isInsert||Trigger.isUpdate)){ 
	
			if(Trigger.isInsert){
	CQ_ProposalTriggerHandler.BeforeInsert(Trigger.new);
	ProposalTriggerHandler.handleBeforeInsertTrigger(Trigger.new);
			}
			
			// Process IsUpdate Trigger logic
			if(Trigger.isUpdate){
	//Added Below check to execute update trigger only once in case of quote creation/cloning 
	if(Nokia_CPQ_Constants.ProposalBeforeUpdate == 'True'){
		CQ_ProposalTriggerHandler.BeforeUpdate(Trigger.newMap, Trigger.oldMap);

		ProposalTriggerHandler.beforeUpdateTrigger(Trigger.newMap, Trigger.oldMap); 
	
		ProposalTriggerHandler.beforeUpdateCheckBlankFields(Trigger.newMap, Trigger.oldMap);
		
		//As per existing code, below flag will be true if coming from insert i.e. in case of quote creation/cloning
		if(Nokia_CPQ_Constants.ProposalBeforeUpdateTriggerExecute == 'True'){
			Nokia_CPQ_Constants.ProposalBeforeUpdate = 'False';
		}
	}	
			}
		}
	}
	
	if (Trigger.isAfter){
	
		if(Trigger.isInsert){
			System.debug('inside insert---->');
			CQ_ProposalTriggerHandler.AfterInsert(Trigger.newMap); 
			ProposalTriggerHandler.afterInsertCPQTrigger(Trigger.newMap);
	// Method to share Quote records by Ankit Maheshwari
			QuoteProposalShareHandler.quoteProposalShare(Trigger.newMap.keyset());
	DirectQuoteSharingWCustTriggerHandler.afterInsertDirectQuoteShares(Trigger.new);
			

			if(checkRecursive.runOnce()){
			System.debug('Trigger.new--->'+Trigger.new);
	 DS_GetSMNPM.getOptyTeamMember(Trigger.newMap);
	CCREProposalTriggerHandler.createConfiguration(Trigger.new);
	
			}
			
	for(Apttus_Proposal__Proposal__c prop: Trigger.new){
	if(String.isNotBlank(prop.Quote_Type__c) && prop.Quote_Type__c.contains(GlobalConstants.DIRECT_QUOTE_TYPE) && prop.isClone()){
		Nokia_CPQ_Constants.isCloneRun = true;
		system.debug('Nokia_CPQ_Constants.isCloneRun'+Nokia_CPQ_Constants.isCloneRun);
		break;
	}
	
			}
		}
		 
		if(Trigger.isUpdate){
			system.debug('recursion**'+ Nokia_CPQ_Constants.ProposalBeforeUpdateTriggerExecute + ' * After Update * ' + Nokia_CPQ_Constants.ProposalAfterUpdate);
			
			CQ_ProposalTriggerHandler.AfterUpdate(Trigger.newMap, Trigger.oldMap);

			//Added Below check to execute update trigger only once in case of quote creation/cloning 
			if(Nokia_CPQ_Constants.ProposalAfterUpdate == 'True'){
	ProposalTriggerHandler.afterUpdateCPQTrigger(Trigger.newmap, Trigger.oldMap);
	IndirectCPQ_ProposalTriggerHandler.afterUpdateMethod(Trigger.new,Trigger.OldMap);
	
			
	//Heema: Added in Release 5
	system.debug('--createServiceRecord called--');
	ProposalTriggerHandler.createServiceRecord(Trigger.newMap,Trigger.OldMap);
	//Added by RG for Approval Process Starts
	ProposalTriggerHandler.opptyApprovalforIndirectQuote(Trigger.newMap);
	//Added by RG for Approval Process ends
	//true if coming from insert
	if(Nokia_CPQ_Constants.ProposalBeforeUpdateTriggerExecute == 'True'){
		Nokia_CPQ_Constants.ProposalAfterUpdate = 'False';
	}
			}
			
			//Check for isDigitalSales added after Spring 19 release to bypass the logic for CPQ quotes
			Boolean isDigitalSales = false;
			for(Apttus_Proposal__Proposal__c prop: Trigger.new){
	if(String.isNotBlank(prop.Quote_Type__c) && prop.Quote_Type__c.contains(Nokia_CPQ_Constants.QUOTE_TYPE_DS)){isDigitalSales = true; break;}
			}
			if(checkRecursive.runOnce()){
	if(isDigitalSales){
		DS_CPOHandler.DS_CreateCPO(Trigger.new,Trigger.OldMap);
		CCREProposalTriggerHandler.updateOpportunity(Trigger.newMap);
		CCREProposalHandler.byPassGates(Trigger.new,Trigger.OldMap);
	}   
			}
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && isDigitalSales){
	CCREProposalTriggerHandler.updateQuoteShare(Trigger.new,Trigger.oldMap);
	CCREProposalTriggerHandler.checkQuoteApprovalStage(Trigger.new,Trigger.oldMap);
			} 
		}
	}
	  if(Trigger.isDelete){   
		system.debug('Calling Delete........');
		if(Trigger.isBefore){CQ_ProposalTriggerHandler.BeforeDelete(Trigger.Old);}
	}
	}
}