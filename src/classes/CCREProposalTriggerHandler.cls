/*******************************
	
	Created by: Accenture
	Created Date: 10th Nov 2017
	Last modified by: Accenture
	Last modified date: 17th Nov 2017
	Description: This trigger handle logic to create config, config lineitem.
	*******************************/
Public without sharing Class CCREProposalTriggerHandler{

/*****************************
	 *Method Name: afterInsert
	 *Description: Method to call methods after Quote insert operation
	 *Parameters: List of quote proposals
	*******************************/
	public static void afterInsert(List<Apttus_Proposal__Proposal__c > quoteRecList){
		try{
			system.debug('quoteRecList : '+quoteRecList);
			if(!quoteRecList.isEmpty() && quoteRecList!=null){
				List<Apttus_Proposal__Proposal__c > quoteToShare = new List<Apttus_Proposal__Proposal__c >();
				for(Apttus_Proposal__Proposal__c quote : quoteRecList){
					if(quote.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.Direct_DS) || 
						quote.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.InDirect_DS)){
						system.debug('Inside if Quote : '+quote);

						quoteToShare.add(quote);
					}
				}
				system.debug('quoteToShare : '+quoteToShare);

				if(!quoteToShare.isEmpty()){
					CCREProposalTriggerHelper.shareQuoteWithAccountOwner(quoteToShare);
				}
			}   
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHandler,CSWXGlobalConstant.DSAfterInsert); }  
	}
	
   /*****************************
	 *Method Name: createConfiguration
	 *Description: Method to create configuration
	 *Parameters: List of quote proposals
	*******************************/
	 public static void createConfiguration(List<Apttus_Proposal__Proposal__c > quoteRecList){
	 try{
		if(!quoteRecList.isEmpty() && quoteRecList!=null){
			CCREProposalTriggerHelper.createConfiguration(quoteRecList);
			/* CCRE Functionality Commented in Sprint 21,DSI-1252*/
		  //  CCREProposalTriggerHelper.createCCRELineItemForProposal(quoteRecList);

		}
	   }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHandler,CSWXGlobalConstant.createConfigurationMethod);
			   
		   }  
	}
	
	/*****************************
	 *Method Name: updateOpportunity
	 *Description: Method to update Opportunity
	 *Parameters: List of quote proposals
	*******************************/
	public static void updateOpportunity(Map<Id,Apttus_Proposal__Proposal__c > updatedQuoteMap)
	{
	   List<Id> oppid = new List<Id>();
	   try{
		system.debug('In Trigger handler>>');
		if(!updatedQuoteMap.isEmpty() && updatedQuoteMap!=null){
	   
			for(Apttus_Proposal__Proposal__c  prop: updatedQuoteMap.values()){
				if(prop.LOA_Status__c==CSWXGlobalConstant.LOA_STATUS && (prop.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.Direct_DS) || prop.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.InDirect_DS))) {
					oppId.add(prop.Apttus_Proposal__Opportunity__c);
				}
				}		
		   // CCREProposalTriggerHelper.byPassG4(oppId);
			if(!oppid.isEmpty()){
			CCREProposalG4Helper updateJob1 = new CCREProposalG4Helper(oppid);
			ID jobID = System.enqueueJob(updateJob1);
			}
		}	   
	   
		}
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHandler,CSWXGlobalConstant.updateOpportunity);
			   
		}
	
	
	}
	
	 /*****************************
	 *Method Name: checkQuoteApprovalStage
	 *Description: Method to checkApprovalStage
	 *Parameters: List of quote proposals
	*******************************/
	public static void checkQuoteApprovalStage(List<Apttus_Proposal__Proposal__c > quoteList,Map<Id, Apttus_Proposal__Proposal__c > oldrecords)
	{
	   try{
		if(!quoteList.isEmpty() && quoteList!=null && !oldrecords.isEmpty() && oldrecords!=null){
			CCREProposalTriggerHelper.checkQuoteApprovalStage(quoteList,oldrecords);
		}
		}
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHandler,CSWXGlobalConstant.updateQuoteShare);
			   
		} 
	
	
	}

	/*****************************
	 *Method Name: updateQuoteShare
	 *Description: To create Quote Share 
	 *Parameters: List of quote proposals
	*******************************/
	public static void updateQuoteShare(List<Apttus_Proposal__Proposal__c > quoteList,Map<Id,Apttus_Proposal__Proposal__c > oldrecords)
	{
		try{
		if(!quoteList.isEmpty() && quoteList!=null && !oldrecords.isEmpty() && oldrecords!=null){
			CCREProposalTriggerHelper.updateQuoteShare(quoteList,oldrecords);
		}
		}
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHandler,CSWXGlobalConstant.updateQuoteShare);
			   
		}  
	}
}