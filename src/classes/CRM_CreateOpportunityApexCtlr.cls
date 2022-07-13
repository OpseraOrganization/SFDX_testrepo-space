/****************************************
* Class Name : CRM_CreateOpportunityApexCtlr
* Created Date: 01.10.2020
* Created By : CO Team - Joao Rodrigues
* Description :
* Test Class: CRM_CreateOpportunityApexCtlrTest
*****************************************/ 
public with sharing class CRM_CreateOpportunityApexCtlr {
	
	private static string FT_OFFER_DEFAULT_NAME = GlobalConstants.UNDERSCORE + 'Offer1';
	private static string FT_G4_CONDITION_DEFAULT_VALUE = 'No LoA';//'G4 Approved or Contracted';
	
	/********************
*Method Name: getFormData
*Parameter: recordId (AccountId or Contact Id)
*Description:  Fetch the contact / account Details needed to display on opportunity creation form.
*******************/
	@AuraEnabled
	public static WrapperFull getFormData(Id recordId)
	{
		WrapperFull wrp = new WrapperFull();
		wrp.contactRec = null;
		wrp.campaignRec = null;
		wrp.accountRec = null;
		wrp.canCreate = canCreate();
		if(wrp.canCreate)
		{
			String sObjectName = getObjectFromId(recordId);
			if(sObjectName.equals('Contact'))
			{
				wrp.contactRec = getContact(recordId);
				wrp.accountRec = getAccount(wrp.contactRec.account.Id);
				wrp.campaignRec = getCampaign(recordId);
				wrp.businessPartnerRole = wrp.contactRec.Account.BusinessPartnerRole__c;
			}
			else if(sObjectName.equals('Account'))
			{
				wrp.accountRec= getAccount(recordId);
				wrp.businessPartnerRole = wrp.accountRec.BusinessPartnerRole__c;
			}
			
			wrp.accountRoleValues = getAllAccountRoleValues();
			wrp.contractSigningValues = getAllContractSigningValues();
			wrp.currencyValues = getAllCurrencyValues();
			wrp.oppTypeValues = getAllOppTypesValues();
			wrp.oppTypeValues.remove(GlobalConstants.FAST_TRACK_OPP_TYPE);
			wrp.oppEndCustomerInfoValues = getAllOppECInformationValues();
			wrp.oppECMarketSegValues = getAllOppECMktSegValues();
			wrp.oppECCountryValues = getAllOppECCountryValues();
			wrp.oppECActSecValues = getAllOppActSecValues();
			
			wrp.contractSigningHelpText =  Opportunity.Contract_Signing_Entity__c.getDescribe().getInlineHelpText();
			wrp.winDecDateHelpText =  Opportunity.G5_Approval_Date__c.getDescribe().getInlineHelpText();
			
			wrp.defaultAccountRole = getAccountRoleDefaultValue(wrp.businessPartnerRole, getAccountRoleMappings());
			wrp.defaultCurrency = getCurrentUserISOCode();
			
		}
		return wrp;
	}
	/********************
*Method Name: saveIndirectOppFromAcc
*Parameter: Opportunity, AccountId and  endCustomerLEId)
*Description:  creates indirect opportunity
*******************/
	@AuraEnabled
	public static Opportunity saveIndirectOpportunityWithAccount(Opportunity oppty, Id accountId, Id endCustomerLEId)
	{
		oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
		oppty.Business_Type__c = 'Standard Opportunity';
		oppty.Phase_Status__c = GlobalConstants.PLANNED;
		oppty.closeDate = oppty.G5_Planned_Date__c;//Da Account temos 2199-09-09
		oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		oppty.End_Customer_LE__c = endCustomerLEId;
		oppty.AccountId = accountId;
		insert oppty;
		return oppty;
	}
	
	@AuraEnabled
	public static Opportunity saveDirectOpportunityWithAccount(Opportunity oppty, Id accountId)
	{
		oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
		oppty.Business_Type__c = 'Standard Opportunity';
		oppty.Phase_Status__c = GlobalConstants.PLANNED;
		oppty.closeDate = oppty.G5_Planned_Date__c;//Da Account temos 2199-09-09
		oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Direct_Record_Type).getRecordTypeId();
		oppty.AccountId = accountId;
		insert oppty;
		return oppty;
	}
	
	/********************
*Method Name: saveIndirectOpportunityWithContact
*Parameter: Contact Id , campaignId , accountId , Oppotunity , endCustomerId
*Description:   Save the indirect sales opportunity
*******************/
	@AuraEnabled
	public static Opportunity saveIndirectOpportunityWithContact(Opportunity oppty,Id contactId,Id campaignId,Id accountId,Id endCustomerLEId,String contactRole) {
		// Perform isAccessible() and isUpdateable() checks here
		system.debug('Oppty.....'+oppty);
		system.debug('contactId.....'+contactId);
		system.debug('campaignId.....'+campaignId);
		system.debug('accountId.....'+accountId);
		//try{
		oppty.AccountId = accountId;
		oppty.CampaignId = campaignId;
		oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
		oppty.closeDate = oppty.G5_Planned_Date__c;
		oppty.Phase_Status__c = GlobalConstants.PLANNED;
		oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		oppty.End_Customer_LE__c= endCustomerLEId;
		oppty.Contact_Source__c  = contactId;
		upsert oppty;
		
		Contact con = new Contact();
		con.Id = contactId;
		con.status__c = GlobalConstants.CLOSED_CONVERTED;
		update con;
		
		//insert Contact role
		OpportunityContactRole ocr = new OpportunityContactRole();
		ocr.ContactId = con.Id;
		ocr.IsPrimary = true;
		ocr.OpportunityId = oppty.Id;
		ocr.Role = contactRole;
		insert ocr;
		//}catch(Exception exc){
		//  ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.SAVE_INOPPTY_WITH_CONTACT );
		//}
		return oppty;
	}
	
	/********************
*Method Name: saveOpportunityWithContact
*Parameter: Contact Id , campaignId , accountId , Oppotunity
*Description:   Save the direct sales opportunity
*******************/
	@AuraEnabled
	public static Opportunity saveOpportunityWithContact(Opportunity oppty,Id contactId,Id campaignId,Id accountId,String contactRole) {
		system.debug('Oppty.....'+oppty);
		system.debug('contactId.....'+contactId);
		system.debug('campaignId.....'+campaignId);
		system.debug('accountId.....'+accountId);
		//try{
		oppty.AccountId = accountId;
		oppty.CampaignId = campaignId;
		oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
		oppty.Phase_Status__c = GlobalConstants.PLANNED;
		oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
		oppty.closeDate = oppty.G5_Planned_Date__c;
		oppty.Contact_Source__c  = contactId;
		upsert oppty;
		
		Contact con = new Contact();
		con.Id = contactId;
		con.status__c = GlobalConstants.CLOSED_CONVERTED;
		update con;
		
		//insert Contact role
		OpportunityContactRole ocr = new OpportunityContactRole();
		ocr.ContactId = con.Id;
		ocr.IsPrimary = true;
		ocr.OpportunityId = oppty.Id;
		ocr.Role = contactRole;
		insert ocr;
		//}catch(Exception exc){
		//	ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.SAVE_OPPTY_WITH_CONTACT );
		//}
		return oppty;
	}
	
	/********************
*Method Name: getDetailsApex
*Parameter: oppId , cafastTrackType
*Description:   Get details of master opportunity for fast track creation
*******************/
	@AuraEnabled
	public static WrapperFullFT getFTDetailsApex(Id oppId, String fastTrackType, Id contextId)
	{
		WrapperFullFT wpFull = new WrapperFullFT();
		try
		{
			wpFull.canCreate = canCreate();
			if(wpFull.canCreate)
			{
				Opportunity masterOpp = [SELECT Id, Name, Lead_BG__c, Lead_BU__c, Contract_Signing_Entity__c, CurrencyIsoCode, G5_Planned_Date__c, Supporting_BGs_BUs__c, Partner_Originated__c, Account_Role__c, Multiple_or_Unknown_EC_Activity_Sector__c, Multiple_or_Unknown_EC_Country__c, Multiple_or_Unknown_EC_Market_Segment__c, End_Customer_Information__c, End_Customer_LE__c, Enterprise_Main_Solution__c, CLM_Existing_Contract_Reference__c, X2nd_Currency__c
										 FROM Opportunity where Id = :oppId LIMIT 1][0];
				Account contextAccount = [SELECT Id, L4Name__c FROM Account Where Id = :contextId][0];
				
				wpFull.masterOppId = masterOpp.Id;
				wpFull.fastTrackOpp = setFastTrack(masterOpp, fastTrackType);
				wpFull.accMarket = contextAccount.L4Name__c;
				wpFull.oifLine = setOIF();
				wpFull.successMessage = 'Master Opportunity Retrieved Successfully.';
			}
			return wpFull;
		}
		catch(DMLException err)
		{
			wpFull.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wpFull.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wpFull.errorMessage = err.getMessage();
			}
		}
		return wpFull;
	}
	
	/********************
*Method Name: saveFastTrackApex
*Parameter: fastTrack , fastTrackType, accountId
*Description:   Creates a new Fast Track Opp with offer
*******************/
	@AuraEnabled
	public static WrapperFullFT saveFastTrackApex(String fastTrack, String fastTrackType, String oifLine, Id accountId, Id masterOppId)
	{
		WrapperFullFT wpFull = new WrapperFullFT();
		Savepoint savePointRec = Database.setSavepoint();
		try
		{
			Opportunity fastTrackOpp = (Opportunity) JSON.deserialize(fastTrack, Opportunity.class);
			Order_Intake_Forecast__c oifLineRec = (Order_Intake_Forecast__c) JSON.deserialize(oifLine, Order_Intake_Forecast__c.class);
			
			fastTrackOpp.AccountId = accountId;
			fastTrackOpp.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			fastTrackOpp.Phase_Status__c = GlobalConstants.OFFERSUBMITTEDTOCUSTOMER;
			fastTrackOpp.Reference_Opportunity__c = masterOppId;
			fastTrackOpp.Gate_2_Bypass_no_complex_offer__c = True ;
			fastTrackOpp.No_Complex_Offer_Decision_Maker__c = System.UserInfo.getName();
			fastTrackOpp.G2_Approval_Date__c = System.Now();
			fastTrackOpp.G2_Planned_Date__c = System.Today();
			fastTrackOpp.Gate_3_Bypass_no_offer_support__c = True;
			fastTrackOpp.No_Offer_Support_Decision_Maker__c = System.UserInfo.getName();
			fastTrackOpp.G3_Approval_Date__c = System.Now();
			fastTrackOpp.G3_Planned_Date__c = System.Today();
			fastTrackOpp.G4_Approval_Date__c = System.Now();
			fastTrackOpp.G4_Planned_Date__c = System.Today();
			fastTrackOpp.G5_Planned_Date__c = [SELECT Id, End_date__c FROM Nokia_Financial_Calendar__c WHERE Id = :oifLineRec.POPlanReceipt__c][0].End_Date__c;
			
			fastTrackOpp.Approvals_Current_Status__c = GlobalConstants.APPROVED;
			fastTrackOpp.ApprovalStatusTechField__c = GlobalConstants.G4_APPROVED_TECH;
			fastTrackOpp.Approvals_Current_Status__c = GlobalConstants.G4_APPROVED;
			fastTrackOpp.CloseDate = System.Today() + 7;
			fastTrackOpp.Amount = 0;
			insert fastTrackOpp;
			createOIF(JSON.serialize(oifLineRec), fastTrackOpp.Id);
			createOffer(fastTrackOpp.Id, fastTrackOpp.Name);
			
			
			wpFull.fastTrackOppId = fastTrackOpp.Id;
			wpFull.successMessage = 'Fast Track Opportunity Created with success.';
		}
		catch(DMLException err)
		{
			Database.rollback(savePointRec);
			wpFull.errorMessage = err.getDmlMessage(0).unescapeHtml4();
		}
		catch (Exception err)
		{
			Database.rollback(savePointRec);
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wpFull.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wpFull.errorMessage = err.getMessage();
			}
		}
		return wpFull;
	}
	
	@AuraEnabled
	public static Boolean checkOIFcreationApex(Id oppId)
	{
		Boolean hasOIF = false;
		List<Order_Intake_Forecast__c> oifList = [SELECT Id FROM Order_Intake_Forecast__c WHERE Opportunity__c = :oppId];
		if(oifList.size() > 0)
		{
			hasOIF = true;
			//OIF was created in future method and the unweighted value was not update (already in future method)
			updateUnweightedVal(oppId);
		}
		return hasOIF;
	}
	
	@AuraEnabled
	public static void updateUnweightedVal(Id ftOppId)
	{
		Set<Id> ftIdSet = new Set<Id>();
		ftIdSet.add(ftOppId);
		OpportunityTriggerHelper.Currenychange(ftIdSet);
	}
	
	private static Order_Intake_Forecast__c setOIF()
	{
		Order_Intake_Forecast__c oifLine = new Order_Intake_Forecast__c();
		oifLine.RecordTypeId = Schema.SObjectType.Order_Intake_Forecast__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.OPEN_OIF_RT_DEVNAME).getRecordTypeId();
		oifLine.BusinessLine__c = null;
		oifLine.OIF_Value__c = null;
		oifLine.Forecast_Category__c = null;
		oifLine.POPlanReceipt__c = null;
		oifLine.Rev_RecPlan_Receipt__c = null;
		return oifLine;
	}
	
	private static void createOffer(Id oppId, String oppName)
	{
		Offer__c offerRec = new Offer__c();
		offerRec.Opportunity__c = oppId;
		Integer maxLength = Offer__c.getSObjectType().getDescribe().fields.getMap().get('Name').getDescribe().getLength();
		if(oppName.length() + FT_OFFER_DEFAULT_NAME.length() > maxLength ){ //if it will go over the max allowed on name field in offer
			oppName = oppName.left(maxLength-FT_OFFER_DEFAULT_NAME.length());
		}
		offerRec.Name = oppName + FT_OFFER_DEFAULT_NAME;
		offerRec.Customer_Offer_Due_Date__c = System.Today() + 7;
		offerRec.LOA_Bypass__c = FT_G4_CONDITION_DEFAULT_VALUE;
		offerRec.Decision_Maker__c = System.UserInfo.getName();
		offerRec.G4_Approval_Date__c = System.Today();
		offerRec.G4_passed__c = TRUE;
		offerRec.Approval_Forum__c = null;
		insert offerRec;
		
		createOfferTeam(offerRec.Id);
	}
	
	@future
	private static void createOfferTeam(Id offerId)
	{
		List<Offer_Team__c> offerMembers = new List<Offer_Team__c>();
		offerMembers.add(new Offer_Team__c(Offer__c=offerId,Name__c=System.UserInfo.getUserId(),Team_Member_Role__c=GlobalConstants.ACCOUNT_MANAGER_TRICORN, Offer_Access__c = GlobalConstants.READ_EDIT_ACCESS  ));
		offerMembers.add(new Offer_Team__c(Offer__c=offerId,Name__c=System.UserInfo.getUserId(),Team_Member_Role__c=GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE, Offer_Access__c = GlobalConstants.READ_EDIT_ACCESS  ));
		insert offerMembers;
	}
	
	@future
	private static void createOIF(String oifLineStr, Id oppId)
	{
		Order_Intake_Forecast__c oifLineRec = (Order_Intake_Forecast__c) JSON.deserialize(oifLineStr, Order_Intake_Forecast__c.Class);
		oifLineRec.Opportunity__c = oppId;
		insert oifLineRec;
	}
	
	private static Opportunity setFastTrack(Opportunity masterOpp, String fastTrackType)
	{
		Opportunity fastTrackOpp = new Opportunity();
		fastTrackOpp.Name = '';
		fastTrackOpp.Business_Type__c = GlobalConstants.FAST_TRACK_OPP_TYPE;
		fastTrackOpp.Description = '';
		fastTrackOpp.Lead_BG__c = masterOpp.Lead_BG__c;
		fastTrackOpp.Lead_BU__c = masterOpp.Lead_BU__c;
		fastTrackOpp.Supporting_BGs_BUs__c = masterOpp.Supporting_BGs_BUs__c;
		fastTrackOpp.Probability = 50;
		fastTrackOpp.Contract_Signing_Entity__c = masterOpp.Contract_Signing_Entity__c;
		fastTrackOpp.CurrencyIsoCode = masterOpp.CurrencyIsoCode;
		fastTrackOpp.G5_Planned_Date__c = masterOpp.G5_Planned_Date__c;
		if(fastTrackType.contains(GlobalConstants.Indirect))
		{
			fastTrackOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();
			fastTrackOpp.Account_Role__c = masterOpp.Account_Role__c;
			fastTrackOpp.End_Customer_Information__c = masterOpp.End_Customer_Information__c == null ? GlobalConstants.EC_INFO_KNWON : masterOpp.End_Customer_Information__c;
			fastTrackOpp.End_Customer_LE__c = masterOpp.End_Customer_LE__c;
			fastTrackOpp.Multiple_or_Unknown_EC_Market_Segment__c = masterOpp.Multiple_or_Unknown_EC_Market_Segment__c;
			fastTrackOpp.Multiple_or_Unknown_EC_Activity_Sector__c = masterOpp.Multiple_or_Unknown_EC_Activity_Sector__c;
			fastTrackOpp.Multiple_or_Unknown_EC_Country__c = masterOpp.Multiple_or_Unknown_EC_Country__c;
			fastTrackOpp.Partner_Originated__c = masterOpp.Partner_Originated__c;
		}
		else
		{
			fastTrackOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			fastTrackOpp.Account_Role__c = null;
			fastTrackOpp.End_Customer_Information__c = GlobalConstants.EC_INFO_KNWON;
			fastTrackOpp.End_Customer_LE__c = null;
			fastTrackOpp.Multiple_or_Unknown_EC_Market_Segment__c = null;
			fastTrackOpp.Multiple_or_Unknown_EC_Activity_Sector__c = null;
			fastTrackOpp.Multiple_or_Unknown_EC_Country__c = null;
			fastTrackOpp.Partner_Originated__c = null;
		}
		
		//Values that are hidden in UI
		fastTrackOpp.Enterprise_Main_Solution__c = masterOpp.Enterprise_Main_Solution__c;
		fastTrackOpp.CLM_Existing_Contract_Reference__c = masterOpp.CLM_Existing_Contract_Reference__c;
		fastTrackOpp.CLM_Contract_Request_Type__c ='None';
		fastTrackOpp.X2nd_Currency__c = masterOpp.X2nd_Currency__c;
		
		return fastTrackOpp;
	}
	
	/********************
*Method Name: getContact
*Parameter: Contact Id
*Description:  Fetch the contact Details need to display on opportunity creation form.
*******************/
	@AuraEnabled
	public static Boolean canCreate()
	{
		Boolean canCreate = false;
		Schema.DescribeSObjectResult oppObj = Schema.SObjectType.Opportunity;
		Map<String,Schema.RecordTypeInfo> rtMapByName = oppObj.getRecordTypeInfosByDeveloperName();
		Schema.RecordTypeInfo indOppRecType =  rtMapByName.get(GlobalConstants.Indirect_Record_Type);
		Schema.RecordTypeInfo dirOppRecType =  rtMapByName.get(GlobalConstants.Direct_Record_Type);
		Boolean checkRTaccess = (indOppRecType.isAvailable() && dirOppRecType.isAvailable());
		if(oppObj.isCreateable() && checkRTaccess )
		{
			canCreate = true;
		}
		return canCreate;
	}
	/********************
*Method Name: getContact
*Parameter: Contact Id
*Description:  Fetch the contact Details need to display on opportunity creation form.
*******************/
	private static Contact getContact(Id contactId) {
		Contact con = [SELECT Firstname, Lastname, account.name, account.Id, account.BusinessPartnerRole__c, Campaign_Name__c, Purchasing_Role__c FROM contact WHERE Id = :contactId];
		//Requirement# 3583
		if(String.isBlank(con.Purchasing_Role__c))
			con.Purchasing_Role__c = GlobalConstants.BUSINESS_USER;
		return con;
	}
	
	/********************
*Method Name: getAccount
*Parameter: Account Id
*Description:  Fetch the Account Details need to display on opportunity creation form
*******************/
	private static Account getAccount(Id accountId) {
		//Requirement# 3583
		Account acc = [SELECT Id, Name, BusinessPartnerRole__c FROM Account WHERE Id = :accountId];
		return acc;
	}
	
	/********************
*Method Name: getCampaign
*Parameter: Contact Id
*Description:  Fetch the campaign Details need to display on opportunity creation form
*******************/
	@AuraEnabled
	public static Campaign getCampaign(Id contactId) {
		try{
			if(contactId!=NULL){
				Contact con =  [SELECT Id,Marketing_Campaign__c,MKT_AttributionCampaign__c,MKT_AttributionCampaign__r.Name FROM contact WHERE Id = :contactId];
				Campaign cmpgn;
				if(con.MKT_AttributionCampaign__c!=null)
				{
					cmpgn = [select Id,Name from Campaign where Id =: con.MKT_AttributionCampaign__c order by createddate limit 1];
				}
				else if(con.Marketing_Campaign__c!=null)
				{
					cmpgn = [select Id,Name from Campaign where Id =: con.Marketing_Campaign__c order by createddate limit 1];
				}
				if(cmpgn!=NULL){
					return cmpgn;
				}
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_CAMPAIGN );
		}
		return NULL;
	}
	
	/********************
*Method Name: getAllCurrencyValues
*Parameter:
*Description:  Fetching all Currency Values from picklist
*******************/
	public static Map<string,string> getAllCurrencyValues()
	{
		Map<string,string> currencies = new  Map<string,string>();
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			// Get the list of picklist values for this field.
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.CURRENCY_ISO_CODE ).getDescribe().getPickListValues();
			
			List<String> orderedList = new List<String>();
			Map<String, String> valueLabelMap = new Map<String,String>();
			for (Schema.PicklistEntry a : values)
			{
				orderedList.add(a.getValue());
				valueLabelMap.put(a.getValue(), a.getValue() + ' - ' + a.getLabel());
			}
			orderedList.sort();
			for (String picklistVal : orderedList)
			{
				currencies.put(picklistVal, valueLabelMap.get(picklistVal)); //Euro, Eur - Euro
			}
		}
		catch(Exception exc)
		{
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_CURRENCY_VAL );
		}
		return currencies;
	}
	/********************
*Method Name: getAllOppTypesValues
*Parameter:
*Description:  Fetching all opportunity types Bussiness Type Values from picklist
* AuraEnabled notation only needed for DIRECT OPPS
*******************/
	public static Map<string,string> getAllOppTypesValues(){
		Map<string,string> oppTypes= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.BUSSINESS_TYPE).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{
				oppTypes.put(a.getLabel(), a.getValue());
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_OPP_TYPES_VAL );
		}
		return oppTypes;
	}
	
	/********************
*Method Name: getAllOppECInformationValues
*Parameter:
*Description:  Fetching all opportunity types End Customer Information Values from picklist
*******************/
	public static Map<string,string> getAllOppECInformationValues(){
		Map<string,string> oppECInformations= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.END_CUSTOMER_INFORMATION).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{
				oppECInformations.put(a.getLabel(), a.getValue());
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_EC_INFORMATION_VAL);
		}
		return oppECInformations;
	}
	
	/********************
*Method Name: getAllOppECMktSegValues
*Parameter:
*Description:  Fetching all opportunity types End Customer Market Segments Values from picklist
*******************/
	public static Map<string,string> getAllOppECMktSegValues(){
		Map<string,string> oppECMKTSegInformations= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.M_O_U_EC_MARKET_SEGMENT).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{
				oppECMKTSegInformations.put(a.getLabel(), a.getValue());
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_MTK_SEG_VAL );
		}
		return oppECMKTSegInformations;
	}
	
	/********************
*Method Name: getAllOppECCountryValues
*Parameter:
*Description:  Fetching all opportunity types End Customer Country Values from picklist
*******************/
	public static Map<string,string> getAllOppECCountryValues(){
		Map<string,string> oppECCountryInformations= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.M_O_U_EC_Country).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{
				oppECCountryInformations.put(a.getLabel(), a.getValue());
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_COUNTRY_VAL );
		}
		return oppECCountryInformations;
	}
	
	/********************
*Method Name: getAllOppActSecValues
*Parameter:
*Description:  Fetching all opportunity types End Customer Activity Segment Values from picklist
*******************/
	public static Map<string,List<string>> getAllOppActSecValues(){
		Map<string,List<string>> oppActSecValues= new Map<string,List<string>>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			//Get picklist values
			List<Schema.PicklistEntry> ctrlEntries = fieldMap.get(GlobalConstants.M_O_U_EC_MARKET_SEGMENT).getDescribe().getPickListValues();
			List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(fieldMap.get(GlobalConstants.M_O_U_EC_ACT_SEC).getDescribe().getPicklistValues());
			List<String> controllingValues = new List<String>();
			
			for (Schema.PicklistEntry ple : ctrlEntries) {
				String label = ple.getLabel();
				oppActSecValues.put(label, new List<String>());
				controllingValues.add(label);
			}
			
			for (PicklistEntryWrapper plew : depEntries) {
				String label = plew.label;
				String validForBits = base64ToBits(plew.validFor);
				for (Integer i = 0; i < validForBits.length(); i++) {
					String bit = validForBits.mid(i, 1);
					if (bit == '1') {
						oppActSecValues.get(controllingValues.get(i)).add(label);
					}
				}
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_ACT_SEC_VAL );
		}
		return oppActSecValues;
	}
	
	public static String decimalToBinary(Integer val) {
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		return bits;
	}
	
	public static String base64ToBits(String validFor) {
		if (String.isEmpty(validFor)) return '';
		
		String validForBits = '';
		
		for (Integer i = 0; i < validFor.length(); i++) {
			String thisChar = validFor.mid(i, 1);
			Integer val = base64Chars.indexOf(thisChar);
			String bits = decimalToBinary(val).leftPad(6, '0');
			validForBits += bits;
		}
		
		return validForBits;
	}
	
	private static final String base64Chars = '' +
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
		'abcdefghijklmnopqrstuvwxyz' +
		'0123456789+/';
	
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
		return (List<PicklistEntryWrapper>)
			JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper{
		public String active {get;set;}
		public String defaultValue {get;set;}
		@AuraEnabled
		public String label {get;set;}
		@AuraEnabled
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){
		}
	}
	
	/********************
*Method Name: getAllContractSigningValues
*Parameter:
*Description:  Fetching all  Contract Signing Values from picklist
* AuraEnabled notation only needed for DIRECT OPPS
*******************/
	public static Map<string,string> getAllContractSigningValues(){
		Map<string,string> contractSigningEntities= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.CONTRACT_SIGNING).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values){
				contractSigningEntities.put(a.getLabel(), a.getValue());
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_CONTRACT_SIGNING_VAL );
		}
		return contractSigningEntities;
	}
	
	/********************
*Method Name: getAllAccountRoleValues
*Parameter:
*Description:  Fetching all Account Role Values from picklist
* AuraEnabled notation only needed for DIRECT OPPS
*******************/
	public static Map<string,string> getAllAccountRoleValues(){
		Map<string,string> accountRoles= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.ACCOUNT_ROLE).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values){
				accountRoles.put(a.getLabel(), a.getValue());
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_CONTRACT_SIGNING_VAL );
		}
		return accountRoles;
	}
	
	/********************
*Method Name: getFieldMap
*Parameter:
*Description:  common exection in fetching picklist values
*******************/
	private static map<String, Schema.SObjectField> getFieldMap(){
		// Get the object type of the SObject.
		Schema.sObjectType objType = Opportunity.getSObjectType();
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		// Get a map of fields for the SObject
		return objDescribe.fields.getMap();
	}
	
	/********************
*Method Name: getCurrentUserISOCode
*Parameter:
*Description:  get currentUserISO code
*******************/
	public static String getCurrentUserISOCode()
	{
		return userinfo.getDefaultCurrency();//EUR
	}
	
	/********************
*Method Name: getBPR2AccountRoleMap
*Parameter:
*Description:  finds the account role default value on opp based on business partner type on account.
*******************/
	public static List<CRM_AccountRole_Opp_Map__c> getAccountRoleMappings()
	{
		return CRM_AccountRole_Opp_Map__c.getall().values();
	}
	
	
	/********************
*Method Name: getBPR2AccountRoleMap
*Parameter:
*Description:  finds the account role default value on opp based on business partner type on account.
*******************/
	public static String getAccountRoleDefaultValue(String accBusinessPartnerRole, List<CRM_AccountRole_Opp_Map__c> bprToArMaps)
	{
		String defaultAccountRoleValue = '';
		if(accBusinessPartnerRole != null && !accBusinessPartnerRole.equals(''))
		{
			for(CRM_AccountRole_Opp_Map__c arMap : bprToArMaps)
			{
				System.debug(arMap.BPR_at_Account__c + ' vs ' + accBusinessPartnerRole);
				if(arMap.BPR_at_Account__c.equals(accBusinessPartnerRole))
				{
					defaultAccountRoleValue = arMap.AR_on_opportunity__c;
					break;
				}
			}
		}
		System.Debug('>>> defaultAccountRoleValue>>> '+defaultAccountRoleValue);
		return defaultAccountRoleValue;
	}
	
	private static String getObjectFromId(Id recordId)
	{
		Schema.SObjectType sobjectType = recordId.getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		return sobjectName;
	}
	
	/********************
*Method Name: convertFastTrack
*Parameter: opportunity record Id
*Description:  converts a Fast Track opportunity to Standard Opportunity
*******************/
	@AuraEnabled
	public static Boolean convertFastTrack(Id recordId){
		Opportunity oppty = new Opportunity(Id=recordId,StageName='Develop Opportunity',Phase_Status__c='Opportunity in Progress',Business_Type__c='Standard Opportunity' );
		GlobalConstants.BYPASS_OPPTYPECHANGE = true;
		update oppty;
		return true;
	}
	
	
	//Used for Indirect Opp
	public class WrapperFull
	{
		@AuraEnabled
		public Boolean canCreate {get;set;}
		@AuraEnabled
		public Map<string,string> accountRoleValues {get;set;}
		@AuraEnabled
		public Map<string,string> contractSigningValues {get;set;}
		@AuraEnabled
		public Map<string,string> currencyValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppTypeValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppEndCustomerInfoValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppECMarketSegValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppECCountryValues {get;set;}
		@AuraEnabled
		public Map<string,List<string>> oppECActSecValues {get;set;}
		@AuraEnabled
		public String defaultAccountRole {get;set;}
		@AuraEnabled
		public String defaultCurrency {get;set;}
		@AuraEnabled
		public Account accountRec {get;set;}
		@AuraEnabled
		public Contact contactRec {get;set;}
		@AuraEnabled
		public Campaign campaignRec {get;set;}
		@AuraEnabled
		public String contractSigningHelpText {get;set;}
		@AuraEnabled
		public String winDecDateHelpText {get;set;}
		private String businessPartnerRole {get;set;}
	}
	
	//Used for Fast Track Opp
	public class WrapperFullFT
	{
		@AuraEnabled public Boolean canCreate;
		@AuraEnabled public Id masterOppId;
		@AuraEnabled public String accMarket;
		@AuraEnabled public Opportunity fastTrackOpp;
		@AuraEnabled public Order_Intake_Forecast__C oifLine;
		@AuraEnabled public Id fastTrackOppId;
		@AuraEnabled public Id offerId;
		@AuraEnabled public String successMessage;
		@AuraEnabled public String errorMessage;
	}
}