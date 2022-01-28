/******************************************************************************************************
Name : CCREProposalHandler
Created by: Accenture
Description : This class contains logic for bypassing Gates	   
*********************************************************************************************************/
Public without sharing Class CCREProposalHandler  {
	 /******************************
	*Method Name: byPassGates
	*Description: This Method will bypass the Gates
	********************************/
	public static void byPassGates(List<Apttus_Proposal__Proposal__c> updatedQuoteList,Map<Id, Apttus_Proposal__Proposal__c> oldQuoteList ) {
		List<Id> oppid = new List<Id>();

		try{  
			system.debug('<<In Handler>>');  
			for(Apttus_Proposal__Proposal__c  prop: updatedQuoteList){
				if( prop.Apttus_Proposal__Approval_Stage__c != oldQuoteList.get(prop.Id).Apttus_Proposal__Approval_Stage__c && oldQuoteList.get(prop.Id).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(CSWXGlobalConstant.APPROVED) &&  prop.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(CSWXGlobalConstant.Approval_stage_accepted) && (prop.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.Direct_DS) || prop.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.InDirect_DS))){
				
				oppId.add(prop.Apttus_Proposal__Opportunity__c);
				
				}
				}
			if(!oppid.isEmpty()){
			CCREProposalHelper updateJob1 = new CCREProposalHelper(oppid);
			ID jobID = System.enqueueJob(updateJob1);
			}			  
		}  
			
		catch(Exception ex){ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHandler,CSWXGlobalConstant.byPassGates );
			   
		}
		   
 }  
}