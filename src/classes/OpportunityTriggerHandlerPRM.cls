/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			Opportunity
Description:	 Email notification for OTM & Direct Opportuniy creation by PSM
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
2	Prateek	 
Pooja

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class OpportunityTriggerHandlerPRM{
	/** Description : Email for Approved/Reject Support
* @param NA
* @return User
* @throws NA
**/
	public static void afterUpdate(opportunity oppNew , opportunity oppOld){
		try{
			
			if(oppNew.PRMPartner_User_Name__c != oppOld.PRMPartner_User_Name__c && oppNew.PRMPartner_User_Name__c != NULL ){
				OpportunityTriggerHelperPRM.PartnerOpportunityTeam(oppNew);
			}
			
			if(oppNew.Lead_Type__c == PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION && oppNew.PRMSales_Support_Requested__c == PRMGlobalConstants.TRUE_VALUE ){
				if(oppNew.PRMSales_Support_Status__c == PRMGlobalConstants.Accepted && oppOld.PRMSales_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnApproved(oppNew);
				} 
				if(oppNew.PRMSales_Support_Status__c == PRMGlobalConstants.Declined && oppOld.PRMSales_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnDeclined(oppNew);
				}
			}  
			
			if(oppNew.Lead_Type__c == PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION && oppNew.PRMOther_Support_Requested__c == PRMGlobalConstants.TRUE_VALUE){
				if(oppNew.PRMOther_Support_Status__c == PRMGlobalConstants.Accepted && oppOld.PRMOther_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnApproved(oppNew);
				} 
				if(oppNew.PRMOther_Support_Status__c == PRMGlobalConstants.Declined && oppOld.PRMOther_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnDeclined(oppNew);
				}		 
			}
			
			if(oppNew.Lead_Type__c == PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION && oppNew.PRMPricing_Support_Requested__c == PRMGlobalConstants.TRUE_VALUE){
				if(oppNew.PRMPricing_Support_Status__c == PRMGlobalConstants.Accepted && oppOld.PRMPricing_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnApproved(oppNew);
				}
				if(oppNew.PRMPricing_Support_Status__c == PRMGlobalConstants.Declined && oppOld.PRMPricing_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnDeclined(oppNew);
				}		 
			}
			
			if(oppNew.Lead_Type__c == PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION && oppNew.PRMTechnical_Support_Requested__c == PRMGlobalConstants.TRUE_VALUE){
				if(oppNew.PRMTechnical_Support_Status__c == PRMGlobalConstants.Accepted && oppOld.PRMTechnical_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnApproved(oppNew);
				} 
				if(oppNew.PRMTechnical_Support_Status__c == PRMGlobalConstants.Declined && oppOld.PRMTechnical_Support_Status__c == null ){
					OpportunityTriggerHelperPRM.sendNotificationOnDeclined(oppNew);
				}		 
			}
			
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHandlerPRM,PRMGlobalConstants.afterUpdate);
		}
		
	}
	
	/** Description : afterInsert
* @param NA
* @return User
* @throws NA
**/   
	
	public static void afterInsert(List<opportunity> opptyListNew){
		try{
			Map<id,id> opptyMap = new Map<id,id> ();
			List<opportunity> listToUpdate = new List<opportunity>();
			Map<id,Id> partnerCompanyMap = new Map<id,Id>();
			
			if(opptyListNew[0].PRMPartner_User_Name__c != null){
				OpportunityTriggerHelperPRM.PartnerOpportunityTeam(opptyListNew[0]);
			}		
			
			
			for(opportunity opportunity : opptyListNew ){
				if(opportunity.Indirect_Reseller_Company__c != Null && opportunity.RecordTypeId == system.Label.Create_Indirect_Sales_Opportunity){
					opptyMap.put(opportunity.Id,opportunity.Indirect_Reseller_Company__c);
				}
			}
			if(!opptyMap.IsEmpty()){
				for(Partner_Company__c partnerCompany : [SELECT Country_Headquarters__c,Id,LastViewedDate,Market__c,Name,OwnerId,Partner_Name__c,Partner_Type__c FROM Partner_Company__c WHERE id IN : opptyMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
					
					if(partnerCompany.Partner_Type__c.EqualsIgnoreCase(PRMGlobalConstants.IndirectReseller)){
						partnerCompanyMap.put(partnerCompany.id,partnerCompany.Partner_Name__c);
					}
				}
			}
			opportunity opportunity1 = new opportunity();
			for(id opportunityId : opptyMap.keyset()){
				if(partnerCompanyMap.containskey(opptyMap.get(opportunityId))){
					
					opportunity1.id = opportunityId;
					opportunity1.Indirect_Reseller_Account__c = partnerCompanyMap.get(opptyMap.get(opportunityId));
					listToUpdate.add(opportunity1); 
				}
			}
			if(!listToUpdate.IsEmpty()){
				Database.update(listToUpdate);
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHandlerPRM,PRMGlobalConstants.afterInsert);
		}
		
	}
	
	/** Description : Map Company to End Customer
* @param NA afterUpdateOppty
* @return User
* @throws NA
**/
	
	public static void afterUpdateOppty(Map<Id,opportunity> opportunityOldMap,Map<Id,opportunity> opportunityNewMap){
		
		try{
			opportunity opp1 = new opportunity();
			opportunity opportunity1 = new opportunity();
			opportunity opportunity2 = new opportunity();
			Map<id,id> opportunityMap = new Map<id,id> ();
			List<opportunity> listToUpdate = new List<opportunity>();
			Map<id,Id> partnerCompanyMap = new Map<id,Id>();
			for(opportunity opportunity : opportunityNewMap.values() ){
				if(opportunityOldMap.get(opportunity.Id).Indirect_Reseller_Company__c != opportunityNewMap.get(opportunity.Id).Indirect_Reseller_Company__c &&
				   opportunity.Indirect_Reseller_Company__c != Null && opportunity.RecordTypeId == system.Label.Create_Indirect_Sales_Opportunity){
					   opportunityMap.put(opportunity.Id, opportunity.Indirect_Reseller_Company__c);
				   }
			}
			if(!opportunityMap.IsEmpty()){
				for(Partner_Company__c partnerCompany : [SELECT Country_Headquarters__c,Id,LastViewedDate,Market__c,Name,OwnerId,Partner_Name__c,Partner_Type__c FROM Partner_Company__c WHERE id IN : opportunityMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
					
					if(partnerCompany.Partner_Type__c.EqualsIgnoreCase(PRMGlobalConstants.IndirectReseller)){
						partnerCompanyMap.put(partnerCompany.id,partnerCompany.Partner_Name__c);
					}
				}
			}
			for(id opportunityId : opportunityMap.keyset()){
				if(partnerCompanyMap.containskey(opportunityMap.get(opportunityId))){
					
					opportunity2.id = opportunityId;
					opportunity2.Indirect_Reseller_Account__c = partnerCompanyMap.get(opportunityMap.get(opportunityId));
					listToUpdate.add(opportunity2); 
				}else{
					
					opportunity1.id = opportunityId;
					opportunity1.Indirect_Reseller_Account__c = null;
					listToUpdate.add(opportunity1); 
				}
			}
			if(!listToUpdate.IsEmpty()){
				Database.update(listToUpdate);
			}
			else {
				List<opportunity> oppty = new List<opportunity>();
				for(opportunity opp : opportunityNewMap.values()){
					if(opportunityOldMap.get(opp.Id).Indirect_Reseller_Company__c != opportunityNewMap.get(opp.Id).Indirect_Reseller_Company__c &&
					   string.isNotBlank(opportunityOldMap.get(opp.Id).Indirect_Reseller_Company__c) && String.isBlank(opp.Indirect_Reseller_Company__c)){
						   
						   opp1.Id = opp.Id;
						   opp1.Indirect_Reseller_Account__c =null;
						   oppty.add(opp1);
					   }
				}
				Database.update(oppty);
			}
			
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHandlerPRM,PRMGlobalConstants.afterUpdateOppty);
		}
		
	}
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadNewMap
* Return: void
* Methode : ShareOpptyWithApprover
* Description: Method for afterUpdateOpportunity
* High Level Process : share oppty
**********************************************************************************************************************/  
	public static void shareOpptyWithApprover(Map<Id,Opportunity> opptyNewMap){
		try{
			for(Opportunity oppty : opptyNewMap.Values()){
				if(string.IsNotblank(oppty.PRMRBC_Direct_Sales_Approver__c) && oppty.RecordTypeId == system.Label.Create_Indirect_Sales_Opportunity && oppty.PartnerAvailable__c == PRMGlobalConstants.YES){	
					OpportunityTriggerHelperPRM.shareOpptyWithRBCApprover(oppty);
				}
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHandlerPRM,PRMGlobalConstants.ShareOpptyWithApprover);
		}
	}   
	
	/*******************************
*Method name: afterOTMDelete
*Description: This Method will delete partner from otm
*Parameter: Opportunity Values
*******************************/
	public static void afterOTMDelete(opportunity opptyOld, opportunity opptyNew){
		if(opptyOld.PRMPartner_User_Name__c != opptyNew.PRMPartner_User_Name__c ){
			List<OpportunityTeamMember> opptyTeamListNew = new List<OpportunityTeamMember>();
			opptyTeamListNew = [SELECT Id,Name,OpportunityAccessLevel,OpportunityId FROM OpportunityTeamMember WHERE OpportunityId =: opptyNew.ID Limit 1];
			try{
				if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
					OpportunityTriggerHelperPRM.deletePartnerFromOTM(opptyTeamListNew, opptyOld, opptyNew);
				}
			}
			catch(System.Exception e){
				ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHandlerPRM,PRMGlobalConstants.afterOTMDelete);
			}
		}
	}
	/*******************************
*Method name: recordTypeUpdate
*Description: This Method will Remove PRM realted fields on Indirect to direct Record type Update
*Parameter: Opportunity Values
******************************/  
	public static void recordTypeUpdate(Map<Id,opportunity> opportunityOldMap,Map<Id,opportunity> opportunityNewMap){
		for(opportunity opportunity : opportunityNewMap.values() ){
			
			if(opportunityOldMap.get(opportunity.Id).RecordTypeId != opportunityNewMap.get(opportunity.Id).RecordTypeId && opportunityNewMap.get(opportunity.Id).PartnerAvailable__c == PRMGlobalConstants.YES && opportunityNewMap.get(opportunity.Id).RecordTypeId == system.label.Direct_Opportunity_Record_Type){
				OpportunityTriggerHelperPRM.indirectToDirectUpdate(opportunityNewMap);
			}
		}
	}
}