/******************************************************************************************************
Name : DS_CPOHandler
Created Date: 18th October 2018
Created by: Accenture
Description : This class is calling helper having  logic to map fields between cpo, agreement and quote objects
*********************************************************************************************************/
Public without sharing Class DS_CPOHandler{
   /* method to  create CPO */
	public static void DS_CreateCPO(List<Apttus_Proposal__Proposal__c> updatedQuoteList,Map<Id, Apttus_Proposal__Proposal__c> oldQuoteList) {
		try{  
			List<Apttus_Proposal__Proposal__c> updatedQuoteRecList = new List<Apttus_Proposal__Proposal__c>();
			if(!updatedQuoteList.isEmpty() && updatedQuoteList!=null){
				for(Apttus_Proposal__Proposal__c  prop: updatedQuoteList){
					if( prop.Apttus_Proposal__Approval_Stage__c != oldQuoteList.get(prop.Id).Apttus_Proposal__Approval_Stage__c  &&  prop.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(CSWXGlobalConstant.Approval_stage_accepted) && (prop.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.Direct_DS) || prop.Quote_Type__c.equalsIgnoreCase(CSWXGlobalConstant.InDirect_DS))){
				   
						 updatedQuoteRecList.add(prop);
					  
					}
				 }
			 }
			
			 if(!updatedQuoteRecList.isempty() && updatedQuoteRecList!= null){
				 DS_CPOHelper.DS_CreateCPO(updatedQuoteRecList);
			 }
		
		 }catch(Exception ex){
			 
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOHandler,CSWXGlobalConstant.DS_CreateCPO);
			   
		   }
   }


}