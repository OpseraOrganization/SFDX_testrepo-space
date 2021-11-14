/******************************************************************************************************
Name : OpportunityTeamHandlerDS 
Created Date: 13 Feb 2019
Created by: Accenture
Description : This class contains the logic for reading SM,PM and AM from Opportunity team and populating on Quote.
*********************************************************************************************************/
public  without sharing class DS_OpportunityTeamHandler {

Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows(); 

/******************************************************************************************************
	Name : beforeDelete
	Created Date: 13 Feb 2019
	Created by: Accenture
	Description : This Method will delete SM,PM,AM from quote whenever SM,PM,AM will be deleted from opty team 
*********************************************************************************************************/
	public static void beforeDelete(Map<id,OpportunityTeamMember> opportunityTeamMemberOldMap){
		try{
		afterInsertPlusDelete(opportunityTeamMemberOldMap,CSWXGlobalConstant.DeleteDML);
		}catch(Exception e){
			ExceptionHandler.addException(e,CSWXGlobalConstant.OpportunityTeamHandlerDS  ,CSWXGlobalConstant.beforeDelete);
		}
	}

/******************************************************************************************************
	Name : afterInsert
	Created Date: 13 Feb 2019
	Created by: Accenture
	Description : This Method will insert SM,PM,AM in quote whenever SM,PM,AM will be inserted in opty team 
*********************************************************************************************************/
	public static void afterInsert(Map<id,OpportunityTeamMember> opportunityTeamMemberNewMap){
		try{
		
		   afterInsertPlusDelete(opportunityTeamMemberNewMap,CSWXGlobalConstant.InsertDML);
		   
		}catch(Exception e){
			ExceptionHandler.addException(e,CSWXGlobalConstant.OpportunityTeamHandlerDS  ,CSWXGlobalConstant.afterInsert);
		}
	 }
	
/******************************************************************************************************
	Name : afterUpdate
	Created Date: 13 Feb 2019
	Created by: Accenture
	Description : This Method will update SM,PM,AM on quote whenever SM,PM,AM will be updated in opty team 
*********************************************************************************************************/
	public static void afterUpdate(Map<id,OpportunityTeamMember> opportunityTeamMemberNewMap,Map<id,OpportunityTeamMember> opportunityTeamMemberOldMap){
	   try{
		
			Set<Id> optyId = new Set<Id>();
			
			for(Id OTM :opportunityTeamMemberNewMap.keySet()){
				
				optyId.add(opportunityTeamMemberNewMap.get(OTM).OpportunityId);
			}
			
			Map<Id,Apttus_Proposal__Proposal__c> OptyQuoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();

			for(Apttus_Proposal__Proposal__c quoteRecList  :[select id,DSSolutionManager__c,DSPricingManager__c,Quote_Type__c,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in :optyId LIMIT:limitRows]){

				OptyQuoteMap.put(quoteRecList.Apttus_Proposal__Opportunity__c,quoteRecList);

			}
										   
										   
										   
			List<Apttus_Proposal__Proposal__c> quoteRecList = new List<Apttus_Proposal__Proposal__c>();
										   
		   for(Id OTM :opportunityTeamMemberNewMap.keySet()){
			  
			   if(OptyQuoteMap.containsKey(opportunityTeamMemberNewMap.get(OTM).OpportunityId)){
					Apttus_Proposal__Proposal__c  quote = OptyQuoteMap.get(opportunityTeamMemberNewMap.get(OTM).OpportunityId);
					if((opportunityTeamMemberNewMap.get(OTM).OpportunityId == quote.Apttus_Proposal__Opportunity__c) && quote.Quote_Type__c ==CSWXGlobalConstant.Direct_DS){
						
						if(opportunityTeamMemberNewMap.get(OTM).TeamMemberRole == CSWXGlobalConstant.SM){
							quote.DSSolutionManager__c=opportunityTeamMemberNewMap.get(OTM).UserId;
					  
							
							if(opportunityTeamMemberOldMap.get(OTM).TeamMemberRole ==CSWXGlobalConstant.accMemPM){
								quote.DSPricingManager__c=null;
					  
							}
						}
				  
				  
						else if(opportunityTeamMemberNewMap.get(OTM).TeamMemberRole == CSWXGlobalConstant.accMemPM){
							quote.DSPricingManager__c=opportunityTeamMemberNewMap.get(OTM).UserId;
					  
						   
							if(opportunityTeamMemberOldMap.get(OTM).TeamMemberRole ==CSWXGlobalConstant.SM){
								quote.DSSolutionManager__c=null;
					  
							}
						}
					  OptyQuoteMap.put(opportunityTeamMemberNewMap.get(OTM).OpportunityId,quote);
				   }
			  
			   }
			
			
			}
			  if(!OptyQuoteMap.isEmpty())
				update OptyQuoteMap.values();   
		 }catch(Exception e){
			 ExceptionHandler.addException(e,CSWXGlobalConstant.OpportunityTeamHandlerDS  ,CSWXGlobalConstant.afterUpdate);
		}


	}
	
   /* ************ Logic to insert/delete SM,PM,AM in quote when  SM,PM,AM inserted/deleted in Opty Team ********** */ 
   public static void afterInsertPlusDelete(Map<id,OpportunityTeamMember> opportunityTeamMemberNewMap, String DMLType){
		try{
			Set<Id> optyId = new Set<Id>();
				
			for(Id OTM :opportunityTeamMemberNewMap.keySet()){
					
				optyId.add(opportunityTeamMemberNewMap.get(OTM).OpportunityId);
			}
				
				System.debug('optyId--->'+optyId);
			Map<Id,Apttus_Proposal__Proposal__c> OptyQuoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
										   
			 for(Apttus_Proposal__Proposal__c quoteRecList  :[select id,DSSolutionManager__c,DSPricingManager__c,Quote_Type__c,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in :optyId LIMIT:limitRows]){
					 System.debug('quoteRecList  --->'+quoteRecList);									 
				OptyQuoteMap.put(quoteRecList.Apttus_Proposal__Opportunity__c,quoteRecList);
														  
			}
										   
			 
			List<Apttus_Proposal__Proposal__c> quoteRecList = new List<Apttus_Proposal__Proposal__c>();
										   
			for(Id OTM :opportunityTeamMemberNewMap.keySet()){
				if(OptyQuoteMap.containsKey(opportunityTeamMemberNewMap.get(OTM).OpportunityId)){
														  
														  
					 Apttus_Proposal__Proposal__c  quote = OptyQuoteMap.get(opportunityTeamMemberNewMap.get(OTM).OpportunityId);									 
												
				 if((opportunityTeamMemberNewMap.get(OTM).OpportunityId == OptyQuoteMap.get(opportunityTeamMemberNewMap.get(OTM).OpportunityId).Apttus_Proposal__Opportunity__c) && quote.Quote_Type__c ==CSWXGlobalConstant.Direct_DS ){
														  
														   
			  
						
						if(opportunityTeamMemberNewMap.get(OTM).TeamMemberRole == CSWXGlobalConstant.accMemPM){
						   
							if(DMLType ==CSWXGlobalConstant.InsertDML && opportunityTeamMemberNewMap.get(OTM).UserId != null){
								quote.DSPricingManager__c=opportunityTeamMemberNewMap.get(OTM).UserId;
							
							}
							
							if(DMLType ==CSWXGlobalConstant.DeleteDML){
								quote.DSPricingManager__c=null;
							
							}

							
						}
				  
						else if(opportunityTeamMemberNewMap.get(OTM).TeamMemberRole == CSWXGlobalConstant.SM ){
							if(DMLType ==CSWXGlobalConstant.InsertDML &&  opportunityTeamMemberNewMap.get(OTM).UserId != null){
								quote.DSSolutionManager__c=opportunityTeamMemberNewMap.get(OTM).UserId;
							
							}
							
							if(DMLType ==CSWXGlobalConstant.DeleteDML){
								quote.DSSolutionManager__c=null;
							
							}
							   
							
						}
						OptyQuoteMap.put(opportunityTeamMemberNewMap.get(OTM).OpportunityId,quote);
				  
			  
						}
				}
					
			}
			
			if(!OptyQuoteMap.isEmpty()) {
			  
			  update OptyQuoteMap.values();  
			}			 
		 }catch(Exception e){
		 
			 ExceptionHandler.addException(e,CSWXGlobalConstant.OpportunityTeamHandlerDS  ,CSWXGlobalConstant.afterInsertPlusDelete );
		}


	}
}