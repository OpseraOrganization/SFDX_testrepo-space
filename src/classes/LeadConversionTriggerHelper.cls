/**
* @description: Trigger helper to perform Validation and functions before and after Lead conversion
* @author:  Accenture IDC.
* @test class: CustomLeadConversionTest
* ============================================================================
* History:
* -------
* 
* VERSION	AUTHOR DATE	 DETAIL  FEATURES/CSR/TTP
* 1.0   PRATEEK PRASOON 26/12/2016   Sprint 4 PRM
* 2.0   MIGUEL SILVA 16/04/2021 NOKIA_R21.5
* ============================================================================ 
*/
public without sharing class LeadConversionTriggerHelper{
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: List<Lead> leadList , Map<id,Lead> 
* Return: void
* Description: Method for after conversion of lead
* High Level Process : 
**********************************************************************************************************************/ 
	public static void leadConversion(List<Lead> leadList,Map<id,Lead> leadOldMap) {
		try{
			if(!Test.isRunningTest()){
	PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE = false;
			}
			leadList = [SELECT End_Customer_Legal_Entity_Account__c, CreatedBy.Name , PartnerAccountId, Id, Estimated_Amount__c, PRMCompetitor__c, IsConverted, Distributor_Account__c, convertedOpportunityId, RecordTypeId, Company, OwnerId, Close_Date__c, Opportunity_Record_Type__c from Lead WHERE Id =: leadList[0].Id Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			//PRm Deal Reg Record type check added
			PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(leadList[0].RecordTypeId);  
			
			if (!leadOldMap.get(leadList[0].Id).IsConverted && leadList[0].IsConverted && prmLeadRecordId != null && leadList[0].RecordTypeId != null){
	
	ConversionFutureMethod(leadList[0].Id);
			}
			
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.leadConversion);
		}
	}
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: List<Lead> leadListOld,List<Lead> leadListNew
* Return: void
* Description: Method for update of lead for validation
* High Level Process : 
**********************************************************************************************************************/ 
	public static void beforeConversion(List<Lead> leadListOld,List<Lead> leadListNew){
		try{
			Map<ID, Schema.RecordTypeInfo> nMap = Schema.SObjectType.Lead.getRecordTypeInfosById();
			
			PRMGlobalConstants.RUN_OPPORTUNITY_TRIGGER_ON_LEAD_CONVERSION = false;
			
			List<DealProduct__c> dealProduct =  new List<DealProduct__c>();
			//PRm Deal Reg Record type check added
			PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(leadListNew[0].RecordTypeId);  
			if(prmLeadRecordId != null && leadListNew[0].RecordTypeId != null){
	
	//Req# 2310 PSM can't submit for Approval without changing LEad owner
	if(String.IsBlank(leadListOld[0].Partner_Market__c) && PRMGlobalConstants.Open.equalsIgnoreCase(leadListOld[0].Status) && PRMGlobalConstants.PendingApproval.equalsIgnoreCase(leadListNew[0].Status)){
		leadListNew[0].Status.addError(System.label.PSM_Select_Partner_Before_Submit_for_Approval);
	} 
	// Req #2705
	Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Distributor_account__r.Involve_Distributor_in_IR_Deal_Registrat__c 
				 FROM Lead where id in : leadListNew Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	for(Lead lead : leadListNew) {
		if(leadMap.get(leadListNew[0].Id).Distributor_account__r.Involve_Distributor_in_IR_Deal_Registrat__c
		&& nMap.get(leadListNew[0].RecordTypeId).getName().equals(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION)){
		 
		 if((leadListNew[0].Direct_Sales_Approver__c == Null || leadListNew[0].DistributorPRM__c ==Null || leadListNew[0].End_Customer_Legal_Entity_Account__c == null ||
							   leadListNew[0].Enterprise_Main_Solution__c == null || leadListNew[0].Lead_BG__c == null || leadListNew[0].Lead_BU__c == null)
		 && PRMGlobalConstants.Approved.equalsIgnoreCase(leadListNew[0].Partner_Sales_Manager_Approver_Status__c) && UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Sale_Profile_18_digit_ID) ) {
		  
		  leadListNew[0].DistributorPRM__c.adderror(PRMGlobalConstants.DirectSales_Distr_Req);
		  
		 }
		}else {
		 if((leadListNew[0].Direct_Sales_Approver__c == Null || leadListNew[0].End_Customer_Legal_Entity_Account__c == null ||
							   leadListNew[0].Enterprise_Main_Solution__c == null || leadListNew[0].Lead_BG__c == null || leadListNew[0].Lead_BU__c == null)
		 && PRMGlobalConstants.Approved.equalsIgnoreCase(leadListNew[0].Partner_Sales_Manager_Approver_Status__c )){   
		  leadListNew[0].Direct_Sales_Approver__c.adderror(PRMGlobalConstants.DirectSales_Distr_Req_v2);
		 }
		}
		//SFPRM-503
		if(lead.DOD_Requested__c && lead.PRMDOD_Requested__c && lead.DOD_Status__c == 'Approved with DOD'){
			lead.addError(PRMGlobalConstants.Deferred_DOD_Error);
		}
		if(lead.DOD_Requested__c && lead.PRMDOD_Requested__c && lead.DOD_Status__c != 'Approved with DOD' && lead.Status == PRMGlobalConstants.Approved){
			lead.Bus_Ops_Approval_Status__c = 'Deferred';
			lead.DOD_Status__c = 'Approved with DOD Deferred';
		}else if(!lead.DOD_Requested__c && lead.PRMDOD_Requested__c && lead.DOD_Status__c != 'Approved with DOD' && lead.Status == PRMGlobalConstants.Approved){
			lead.Bus_Ops_Approval_Status__c = 'Rejected';
			lead.DOD_Status__c = 'Approved without DOD';
		}
	}   
	// SF Ticket number : 00005695
	
	/*if(String.IsBlank(leadListNew[0].Direct_Sales_Approver__c) && PRMGlobalConstants.Approved.equalsIgnoreCase(leadListNew[0].Partner_Sales_Manager_Approver_Status__c)){
leadListNew[0].Direct_Sales_Approver__c.addError(System.label.Direct_Sales_Approved_field_Check);
}*/
	//Req# 2229 Rejected Deal should be resubmitted with Discription
	if((UserInfo.getProfileId().equalsIgnoreCase(system.Label.PRM_Partner_Profile_Id) && leadListNew[0].Status.equalsIgnoreCase(PRMGlobalConstants.PendingApproval)) || (UserInfo.getProfileId().equalsIgnoreCase(system.Label.PRM_Partner_Relationship_Manager_Login_ID) && leadListNew[0].Status.equalsIgnoreCase(PRMGlobalConstants.PendingApproval))){
		
		dealProduct = [SELECT Id FROM DealProduct__c WHERE Deal__c =:leadListNew[0].Id  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		if(dealProduct.IsEmpty()){
			leadListNew[0].Status.addError(System.label.ProductAddValidation);
		}
	}
	if(nMap.get(leadListNew[0].RecordTypeId).getName().equals(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION)
	   && UserInfo.getProfileId().equalsIgnoreCase(system.Label.PRM_Partner_Relationship_Manager_Login_Id)
	   && leadMap.get(leadListNew[0].Id).distributor_account__r.Involve_Distributor_in_IR_Deal_Registrat__c
	   && leadListNew[0].Partner_Sales_Manager_Approver_Status__c == PRMGlobalConstants.Approved
	   && leadListNew[0].Status == PRMGlobalConstants.REJECTED_STATUS && leadListOld[0].Status != leadListNew[0].Status
	   && leadListNew[0].Distributor_PRM_Rejection_Reason__c == null) {
		leadListNew[0].Distributor_PRM_Rejection_Reason__c.addError(PRMGlobalConstants.DistPRM_Rejection_Reason_Erros);   
	   }
	
	
	//Requirement #2763
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.PRM_Partner_Relationship_Manager_Login_Id) 
	   && String.IsBlank(leadListNew[0].Rejection_Reason__c) && PRMGlobalConstants.REJECTED_STATUS.equalsIgnoreCase(leadListNew[0].Status)
	   && leadListOld[0].Status != leadListNew[0].Status){
		leadListNew[0].Rejection_Reason__c.addError(System.label.Lead_Rejection_Reason_Error);
	   }	
			} 
			
			
			
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.beforeConversion);
		} 
		
	}
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: List<Lead> leadListNew
* Return: void
* Description: Method for afterInsert
* High Level Process : 
**********************************************************************************************************************/  
	public static void afterInsert(List<Lead> leadListNew){
		try{
			Map<id,id> leadMap = new Map<id,id> ();
			List<Lead> listToUpdate = new List<Lead>();
			Map<id,Id> partnerCompanyMap = new Map<id,Id>();
			
			for(lead lead : leadListNew ){
	//PRm Deal Reg Record type check added
	PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(lead.RecordTypeId);  
	
	if(lead.Indirect_Reseller_Company__c != Null && prmLeadRecordId != null){
		leadMap.put(lead.Id,lead.Indirect_Reseller_Company__c);
		
	}
			}
			for(Partner_Company__c partnerCompany : [SELECT Country_Headquarters__c,Id,LastViewedDate,Market__c,Name,OwnerId,Partner_Name__c,Partner_Type__c FROM Partner_Company__c WHERE id IN : leadMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	
	if(partnerCompany.Partner_Type__c.EqualsIgnoreCase(PRMGlobalConstants.IndirectReseller)){
		partnerCompanyMap.put(partnerCompany.id,partnerCompany.Partner_Name__c);
	}
			}
			for(id leadId : leadMap.keyset()){
	
	if(partnerCompanyMap.containskey(leadMap.get(leadId))){
		
		lead lead = getNewLead();
		lead.id = leadId;
		lead.Indirect_Reseller_Account__c = partnerCompanyMap.get(leadMap.get(leadId));
		listToUpdate.add(lead); 
	}
			}
			if(!listToUpdate.IsEmpty()){
	if(!Test.isRunningTest()){
		PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE = false;
	}
	Database.update(listToUpdate);
			}
		}
		
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.afterInsert);
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadOldMap,Map<Id,Lead> leadNewMap
* Return: void
* Description: Method for afterInsert
* High Level Process : 
**********************************************************************************************************************/  
	public static void populateDistributorAccount(List<Lead> leadListNew){
		try{
			Map<id,id> leadMap = new Map<id,id> ();
			List<Lead> listToUpdate = new List<Lead>();
			Map<id,Id> partnerCompanyMap = new Map<id,Id>();
			
			for(lead lead : leadListNew ){
	//PRm Deal Reg Record type check added
	PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(lead.RecordTypeId);  
	
	if(lead.Distributor_Partner_Company__c != Null && prmLeadRecordId != null){
		leadMap.put(lead.Id,lead.Distributor_Partner_Company__c);
		
	}
			}
			for(Partner_Company__c partnerCompany : [SELECT Country_Headquarters__c,Id,LastViewedDate,Market__c,Name,OwnerId,Partner_Name__c,Partner_Type__c FROM Partner_Company__c WHERE id IN : leadMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	
	if(partnerCompany.Partner_Type__c.EqualsIgnoreCase(PRMGlobalConstants.Distr)){
		partnerCompanyMap.put(partnerCompany.id,partnerCompany.Partner_Name__c);
	}
			}
			for(id leadId : leadMap.keyset()){
	
	if(partnerCompanyMap.containskey(leadMap.get(leadId))){
		
		lead lead = getNewLead();
		lead.id = leadId;
		lead.Distributor_Account__c = partnerCompanyMap.get(leadMap.get(leadId));
		listToUpdate.add(lead);
	}
			}
			if(!listToUpdate.IsEmpty()){
	if(!Test.isRunningTest()){
		PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE = false;
	}
	Database.update(listToUpdate);
			}
		}
		
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.populateDistributorAccount);
		}
		
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadOldMap,Map<Id,Lead> leadNewMap
* Return: void
* Description: Method for afterInsert
* High Level Process : 
**********************************************************************************************************************/ 
	public static void afterUpdate(Map<Id,Lead> leadOldMap,Map<Id,Lead> leadNewMap){
		try{
			Map<id,id> leadMap = new Map<id,id> ();
			List<Lead> listToUpdate = new List<Lead>();
			Map<id,Id> partnerCompanyMap = new Map<id,Id>();
			
			for(lead lead : leadNewMap.values() ){
	//PRm Deal Reg Record type check added
	PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(lead.RecordTypeId);  
	
	if(leadOldMap.get(lead.Id).Indirect_Reseller_Company__c != leadNewMap.get(lead.Id).Indirect_Reseller_Company__c
	   && lead.Indirect_Reseller_Company__c != Null && prmLeadRecordId != null ){
		leadMap.put(lead.Id,lead.Indirect_Reseller_Company__c);
	   }
			}
			if(!leadMap.IsEmpty()){  
	for(Partner_Company__c partnerCompany : [SELECT Country_Headquarters__c,Id,LastViewedDate,Market__c,Name,OwnerId,Partner_Name__c,Partner_Type__c FROM Partner_Company__c WHERE id IN : leadMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		
		if(partnerCompany.Partner_Type__c.EqualsIgnoreCase(PRMGlobalConstants.IndirectReseller)){
			partnerCompanyMap.put(partnerCompany.id,partnerCompany.Partner_Name__c);
		}
	}
			}
			for(id leadId : leadMap.keyset()){
	
	if(partnerCompanyMap.containskey(leadMap.get(leadId))){
		
		lead lead = getNewLead();
		lead.id = leadId;
		lead.Indirect_Reseller_Account__c = partnerCompanyMap.get(leadMap.get(leadId));
		listToUpdate.add(lead); 
	}
			}
			if(!listToUpdate.IsEmpty()){
	if(!Test.isRunningTest()){
		PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE = false;
	}
	Database.update(listToUpdate);
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.afterUpdate);
		}
		
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadOldMap,Map<Id,Lead> leadNewMap
* Return: void
* Description: Method for afterInsert
* High Level Process : 
**********************************************************************************************************************/ 
	public static void updateDistributorAccount(Map<Id,Lead> leadOldMap,Map<Id,Lead> leadNewMap){
		try{
			Map<id,id> leadMap = new Map<id,id> ();
			List<Lead> listToUpdate = new List<Lead>();
			Map<id,Id> partnerCompanyMap = new Map<id,Id>();
			
			for(lead lead : leadNewMap.Values() ){
	//PRm Deal Reg Record type check added
	PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(lead.RecordTypeId);  
	
	if(leadOldMap.get(lead.Id).Distributor_Partner_Company__c != leadNewMap.get(lead.Id).Distributor_Partner_Company__c 
	   && lead.Distributor_Partner_Company__c != Null && prmLeadRecordId != null){
		leadMap.put(lead.Id,lead.Distributor_Partner_Company__c);
	   }
			}
			if(!leadMap.IsEmpty()){
	for(Partner_Company__c partnerCompany : [SELECT Country_Headquarters__c,Id,LastViewedDate,Market__c,Name,OwnerId,Partner_Name__c,Partner_Type__c FROM Partner_Company__c WHERE id IN : leadMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		
		if(partnerCompany.Partner_Type__c.EqualsIgnoreCase(PRMGlobalConstants.Distr)){
			partnerCompanyMap.put(partnerCompany.id,partnerCompany.Partner_Name__c);
		}
	}
			}
			for(id leadId : leadMap.keyset()){
	
	if(partnerCompanyMap.containskey(leadMap.get(leadId))){
		
		lead lead = getNewLead();
		lead.id = leadId;
		lead.Distributor_Account__c = partnerCompanyMap.get(leadMap.get(leadId));
		listToUpdate.add(lead);
	}
			}
			if(!listToUpdate.IsEmpty()){
	if(!Test.isRunningTest()){
		PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE = false;
	}
	Database.update(listToUpdate);
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.updateDistributorAccount);
		}
		
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: 
* Return: Order_Intake_Forecast__c
* Description: Method to create new instance of Order_Intake_Forecast__c
* High Level Process : 
**********************************************************************************************************************/ 
	public static Order_Intake_Forecast__c getOrderIntakeForecast(){
		return new Order_Intake_Forecast__c();
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: 
* Return: OpportunityTeamMember
* Description: Method to create new instance of OpportunityTeamMember
* High Level Process : 
**********************************************************************************************************************/ 
	public static OpportunityTeamMember getOpportunityTeamMembers(){
		return new OpportunityTeamMember();
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: 
* Return: lead
* Description: Method to create new instance of lead
* High Level Process : 
**********************************************************************************************************************/ 
	public static lead getNewLead(){
		return new lead();
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: List<Lead> leadList , Map<id,Lead> 
* Return: void
* Description: Method for after conversion of lead
* High Level Process : 
**********************************************************************************************************************/ 
	@future 
	public static void ConversionFutureMethod(Id leadId) {
		try{
			if(PRMGlobalConstants.LeadConversion_Run_Once){
	List<account> accList = new List<account>();
	List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
	List<account> accLEList = new List<account>();
	List<account> partnerAccList = new List<account>();
	Set<id> idSet = new Set<id>();
	Map<id,String> userIdToNameMap = new Map<id,String>();
	List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
	List<id> userIdList = new List<id>();
	Boolean quickConvert = false;
	
	
	Order_Intake_Forecast__c oif = new Order_Intake_Forecast__c();
	List<Lead> leadList = new List<Lead>();
	leadList = [SELECT Id, Deal_Registration_Auto_Number__c,End_Customer_Legal_Entity_Account__c, CreatedBy.Name , PartnerAccountId, PartnerAccount.OwnerId,
				Estimated_Amount__c, PRMCompetitor__c, IsConverted, Distributor_Account__c, Distributor_Account__r.OwnerId, Distributor_Account__r.Owner.Name,
				convertedOpportunityId, RecordTypeId, Company, OwnerId, Owner.Name, Close_Date__c, Opportunity_Record_Type__c,Description
				from Lead WHERE Id =: leadId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	
	//PRm Deal Reg Record type check added
	PRMDealRegRecordTypes__c prmLeadRecordId = PRMDealRegRecordTypes__c.getInstance(leadList[0].RecordTypeId);
	
	accLEList = [SELECT Id,Name,ParentId,recordType.name FROM Account WHERE Id =: leadList[0].End_Customer_Legal_Entity_Account__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	
	if (leadList[0].IsConverted && prmLeadRecordId != null && leadList[0].RecordTypeId != null){
		
		accList = [SELECT Id, Name, Active__c FROM Account WHERE
		  (Id =: accLEList[0].ParentId and recordType.name =: PRMGlobalConstants.CUSTOMER)
		  OR ( Id =: accLEList[0].Id and recordType.name =: PRMGlobalConstants.PROSPECT) limit 1];
		partnerAccList = [SELECT Id, Name, Active__c, Partner_Type__c FROM Account WHERE
			  (Id =: leadList[0].PartnerAccountId and recordType.name =: PRMGlobalConstants.CUSTOMER)
			  OR ( Id =: leadList[0].PartnerAccountId and recordType.name =: PRMGlobalConstants.PROSPECT) limit 1];
		
		if(leadList[0].Distributor_Account__c != null ){
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c =: leadList[0].Distributor_Account__c AND Account_Role__c = : PRMGlobalConstants.Partner_Relationship_Manager AND Is_active_User__c = : PRMGlobalConstants.TRUE_VALUE   Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			
		}else {
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c in : idSet AND Account_Role__c = : PRMGlobalConstants.Partner_Relationship_Manager AND Is_active_User__c = : PRMGlobalConstants.TRUE_VALUE Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			
		}
		if(leadList[0].convertedOpportunityId != NULL){
			List<Order_Intake_Forecast__c> oifList = new List<Order_Intake_Forecast__c>();
			List<DealProduct__c> dealProductUpdateList = new List<DealProduct__c>();
			List<User> user = new List<User>();
			List<Nokia_Financial_Calendar__c> nokiaCalender = new List<Nokia_Financial_Calendar__c>();
			user = [SELECT Name,ContactId FROM User WHERE Id =: leadList[0].OwnerId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			nokiaCalender = [SELECT Current_Period__c,End_Date__c,Id,IsDeleted,Name,Period_Number__c,Start_Date__c,Year__c FROM Nokia_Financial_Calendar__c WHERE Start_Date__c <=: leadList[0].Close_Date__c AND End_Date__c >: leadList[0].Close_Date__c limit 1];
			if( nokiaCalender.IsEmpty()){
				nokiaCalender = new List<Nokia_Financial_Calendar__c>();
				nokiaCalender = [SELECT Current_Period__c,Id FROM Nokia_Financial_Calendar__c WHERE Current_Period__c = true limit 1];
			}
			
			
			for(DealProduct__c dealProductInstance : [SELECT BusinessLine__c,Value__c,Id FROM DealProduct__c WHERE Deal__c =: leadList[0].Id  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				oif = getOrderIntakeForecast();
				if(!nokiaCalender.IsEmpty()){
		dealProductInstance.Nokia_Financial_Calendar__c = nokiaCalender[0].Id;
		oif.BusinessLine__c = dealProductInstance.BusinessLine__c;
		oif.Forecast_Category__c= PRMGlobalConstants.ROP;
		oif.OIF_Value__c = dealProductInstance.Value__c;
		oif.POPlanReceipt__c= nokiaCalender[0].Id;
		oif.Rev_RecPlan_Receipt__c = nokiaCalender[0].Id;
		oif.Opportunity__c=  leadList[0].convertedOpportunityId;
		dealProductUpdateList.add(dealProductInstance);
		oifList.add( oif);
				}
				
			}
			Database.update(dealProductUpdateList);
			Opportunity opp = [SELECT id,Deal_Registration__c,Name,RecordTypeId,CreatedById, StageName, PRMPartner_User_Name__c,End_Customer__c,
			 End_Customer_LE__c,OwnerId, Org_L7__c,Gate_3_Bypass_no_offer_support__c, Account_Role__c, Description, Partner_Originated__c,
			 Indirect_Reseller_Account__c, Account.OwnerId,Account.Owner.Name,Indirect_Reseller_Account__r.OwnerId
			 FROM Opportunity where Id = :leadList[0].convertedOpportunityId  Limit 1];
			
			if(opp != Null){
				if(user[0].Id != Null){
		opp.PRMPartner_User_Name__c = user[0].Id  ;
		opp.Marketo_Lead__c = leadList[0].CreatedBy.Name;
				}
				if(accLEList[0].recordType.name != PRMGlobalConstants.PROSPECT){
		opp.End_Customer__c = accList[0].Id;
				}
				
				if(leadList[0].Distributor_Account__c != null){
		opp.Indirect_Reseller_Account__c = leadList[0].PartnerAccountId;
		opp.Account_Role__c = PRMGlobalConstants.GPPDistributorPartner;
				}
				if(!accLEList.IsEmpty()){
		opp.End_Customer_LE__c = accLEList[0].Id;
				}else{
		opp.End_Customer_LE__c = null;
				} 
				if(!partnerAccList.IsEmpty()){
		if(partnerAccList[0].Partner_Type__c == PRMGlobalConstants.AlliancePartner){
			opp.Account_Role__c = PRMGlobalConstants.AlliancePartner;
		}else if(partnerAccList[0].Partner_Type__c == PRMGlobalConstants.IndustrialPartnerSystemIntegrator){
			opp.Account_Role__c = PRMGlobalConstants.Industrialpartner;
		}else if(partnerAccList[0].Partner_Type__c == PRMGlobalConstants.Distr){
			opp.Account_Role__c = PRMGlobalConstants.GPPDistributorPartner;
		}else if(partnerAccList[0].Partner_Type__c == PRMGlobalConstants.IndirectReseller){
			opp.Account_Role__c = PRMGlobalConstants.GPPDistributorPartner;
		}else if(partnerAccList[0].Partner_Type__c == PRMGlobalConstants.BusinessPartnerRole){
			opp.Account_Role__c = PRMGlobalConstants.GPPVARpartner;
		}else if(partnerAccList[0].Partner_Type__c == PRMGlobalConstants.ServiceProvider){
			opp.Account_Role__c = PRMGlobalConstants.GPPSPAAPpartner;
		}
				}
				//MSilva - SFPRM-452 updating Opp OwnerId to the Account Owner of the Distributor
				opp.OwnerId = (leadList[0].PartnerAccountId != null ? leadList[0].PartnerAccount.OwnerId : opp.CreatedById);
				
				String recordTypeDevName = leadList[0].Opportunity_Record_Type__c.split(' ').get(1) + '_Record_Type';
				opp.recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
				opp.Business_Type__c = PRMGlobalConstants.OPPORTUNITYTYPE;
				opp.Contract_Signing_Entity__c = PRMGlobalConstants.ContractSigningEntity;
				opp.Deal_Registration__c = leadList[0].Deal_Registration_Auto_Number__c;
				opp.Description = leadList[0].Description;
				opp.Partner_Originated__c = 'Yes';
				
			}
			set<id> opptyIdSet = new Set<Id> ();
			opptyIdSet.add(leadList[0].convertedOpportunityId);
			
			if(opp != null){
				PRMGlobalConstants.LeadConversion_Run_Once=false;
				System.debug('Começou update --> ' + opp.StageName);
				update opp;
				System.debug('Acabou update --> ' + opp.StageName);
			}
			
			if(!nokiaCalender.IsEmpty()){
				List<Order_Intake_Forecast__c> oifrecordchecking = new List<Order_Intake_Forecast__c>();
				oifrecordchecking = [SELECT id,Opportunity__c FROM Order_Intake_Forecast__c WHERE Opportunity__c =: leadList[0].convertedOpportunityId];
				if(oifrecordchecking.isEmpty()) {
		Database.Insert( oifList);
				}
				if(!opptyIdSet.IsEmpty()){
		OpportunityTriggerHelper opportunityTriggerHelper = new OpportunityTriggerHelper();
		opportunityTriggerHelper.BatchCurrenychange(opptyIdSet);
				}
			}
			if(leadList[0].Distributor_Account__c == null){
				userIdToNameMap.put(leadList[0].OwnerId, leadList[0].Owner.Name);
				OpportunityTeamMember otm = getOpportunityTeamMembers();
				otm.TeamMemberRole = PRMGlobalConstants.PARTNER;
				otm.OpportunityId= opp.Id;
				otm.UserId= leadList[0].OwnerId;
				otm.OpportunityAccessLevel = GlobalConstants.EDIT;
				opportunityTeamMemberList.add(otm);
				userIdList.add(otm.UserId);
			}else{
				// MSilva - SFPRM-288 - Create Opportunity Team Member for Account Owner as PSM
				userIdToNameMap.put(leadList[0].Distributor_Account__r.OwnerId, leadList[0].Distributor_Account__r.Owner.Name);
				OpportunityTeamMember otm = getOpportunityTeamMembers();
				otm.TeamMemberRole = PRMGlobalConstants.PARTNER_SALES_MANAGER;
				otm.OpportunityId= opp.Id;
				otm.UserId= leadList[0].Distributor_Account__r.OwnerId;
				otm.OpportunityAccessLevel = GlobalConstants.EDIT;
				opportunityTeamMemberList.add(otm);
				userIdList.add(otm.UserId);
			}
			
			if(opp.Account.OwnerId != null){
				userIdToNameMap.put(opp.Account.Owner.Id, opp.Account.Owner.Name);
				OpportunityTeamMember otm = new OpportunityTeamMember();
				otm.OpportunityId = opp.Id;
				otm.TeamMemberRole = 'Partner Sales Manager';
				otm.OpportunityAccessLevel = 'Edit';
				otm.UserId = opp.Account.OwnerId;
				opportunityTeamMemberList.add(otm);
				userIdList.add(otm.UserId);
			}
			for(Account_Member__c accountMember : accountMemberList){
				userIdToNameMap.put(accountMember.Name__c, accountMember.Name__r.Name);
				OpportunityTeamMember opptyMember = getOpportunityTeamMembers();
				opptyMember.TeamMemberRole = PRMGlobalConstants.PARTNER;
				opptyMember.OpportunityId= opp.Id;
				opptyMember.UserId= accountMember.Name__c;
				opptyMember.OpportunityAccessLevel = GlobalConstants.EDIT;
				opportunityTeamMemberList.add(opptyMember);
				userIdList.add(opptyMember.UserId);
				
			}
			
			EmailNotification.SendMails(userIdList,opp,opportunityTeamMemberList,userIdToNameMap);
			
			Database.Insert(opportunityTeamMemberList);
			
			
			if(opp.Gate_3_Bypass_no_offer_support__c){
				opp.Apttus_Approval__Approval_Status__c = PRMGlobalConstants.Approved;
				opp.ApprovalStatusTechField__c = PRMGlobalConstants.Approved_G2;
				opp.Approvals_Current_Status__c = PRMGlobalConstants.Approved_G2;
				opp.G2_Approval_Date__c = System.now();
				opp.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
				opp.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
				update opp;
				
				List<Sales_Role__c> sales= [SELECT Organisation__c,OwnerId,Role_Code__c,User__c,User__r.Name FROM Sales_Role__c where Role_Code__c=:PRMGlobalConstants.NSNG_COCT AND Organisation__c=:opp.Org_L7__c Limit 1];
				
				List<Apttus_Approval__Backup_Approver__c> app=new List<Apttus_Approval__Backup_Approver__c>();
				if(!sales.isEmpty()){
		app=[select id,Apttus_Approval__Current_User__c,Apttus_Approval__Current_User__r.Name,Delegate_Approver1__c,Delegate_Approver2__c,Delegate_Approver3__c,Apttus_Approval__Backup_User__c from Apttus_Approval__Backup_Approver__c where Apttus_Approval__IsActive__c=true and Apttus_Approval__InEffect__c=true and  Apttus_Approval__Current_User__c=:sales[0].User__c LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				}
				
				
				Apttus_Approval__ApprovalProcessInstance__c appInstance=[SELECT Id, Name, Apttus_Approval__ApprovalProcessId__c FROM Apttus_Approval__ApprovalProcessInstance__c where Name=:PRMGlobalConstants.G2_Approvals_New Limit 1 ]; 
				List<Apttus_Approval__Approval_Request_History__c > insertAppReq=new List<Apttus_Approval__Approval_Request_History__c >();
				
				
				
				for(Integer i=0;i<2;i++){
		Apttus_Approval__Approval_Request_History__c  req=new Apttus_Approval__Approval_Request_History__c ();
		req.Apttus_Approval__Step_Name__c=PRMGlobalConstants.Gate_2;
		req.Apttus_Approval__Assigned_To_Type__c=GlobalConstants.USER;
		req.Apttus_Approval__Request_Comments__c=PRMGlobalConstants.SalesPhaseIdentifyOpportunity;
		req.Apttus_Approval__Approval_Status__c=PRMGlobalConstants.NotifiedName;
		req.Apttus_Approval__Active__c=true;
		req.Apttus_Approval__Related_Opportunity__c =opp.id;		
		req.Apttus_Approval__Object_Type__c=PRMGlobalConstants.OBJECT_OPPORTUNITY;
		req.Apttus_Approval__Object_Name__c=Opp.Name;
		req.Apttus_Approval__Notify_Only__c =true;
		req.Apttus_Approval__Initial_Submitter__c=Opp.Account.OwnerID;
		req.Apttus_Approval__Date__c=System.now();
		req.Apttus_Approval__DateAssigned__c=System.now();
		req.Apttus_Approval__DateApproved__c=System.now();
		req.Apttus_Approval__ProcessInstanceId__c=appInstance.id; 
		//AM
		if(i==0 && !sales.isEmpty()){
			
			req.Apttus_Approval__Assigned_To_Name__c=sales[0].User__r.Name;
			req.Apttus_Approval__Approver_Comments__c=PRMGlobalConstants.Notified_System_Info_Notified_User+' '+sales[0].User__r.Name+' '+System.now();
			req.Apttus_Approval__StepLabel__c=PRMGlobalConstants.Notify_CT_Head;
			
		}
		//Opp Owner
		if(i==1){
			req.Apttus_Approval__Assigned_To_Name__c=opp.OwnerId;
			req.Apttus_Approval__Approver_Comments__c=PRMGlobalConstants.Notified_System_Info_Notified_User+' '+opp.OwnerId+' '+System.now();
			req.Apttus_Approval__StepLabel__c=PRMGlobalConstants.Gate_2_Bypass;
		}
		
		insertAppReq.add(req);
				}
				
				
				if(!insertAppReq.isEmpty()){
		insert insertAppReq;
				}
				
				System.enqueueJob(new IndirectCPQ_CreateOIFAndOffer(new List<Opportunity>{opp}));
			}
			
		}
	}
			}
			//PRMGlobalConstants.LeadConversion_Run_Once=false;
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.LeadConversionTriggerHelper,PRMGlobalConstants.ConversionFutureMethod);
		}
	}
}