/******************************************************************************************************
Name : IndirectCPQ_OpportunityTriggerHelper
Created by: Accenture
Description : Helper class for Indirect CPQ to handle oppty process.		
*********************************************************************************************************/
public without sharing class IndirectCPQ_OpportunityTriggerHelper {
	/******************************
*Method Name: completeOpptyInfo
*Description: This Method is used to add mandatory opportunity fields when partner user creates oppty.
********************************/		   
 public static void completeOpptyInfo(List<Opportunity> optyList){ 
		
		try{
	Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
			Map<Id,Id> accTOLEMap = new Map<Id,Id>();
			Set<ID>accIDSet = new Set<ID>();
			Map<Id,Id> accOwnerMap = new Map<Id,Id>(); // hcl
			
			for(Opportunity opty : optyList){
	accIDSet.add(opty.AccountId);
			}
			System.debug('accIDSet>>>>'+accIDSet);
			
			for(Account legalEntityAcc : [Select ID, ParentId,Parent.Owner.Id, Name from Account where Default_Legal_Entity__c = true AND Active__c = true AND ParentID IN : accIDSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	accTOLEMap.put(legalEntityAcc.ParentId,legalEntityAcc.Id);
	accOwnerMap.put(legalEntityAcc.ParentId,legalEntityAcc.Parent.Owner.Id); //hcl
			}
			System.debug('accTOLEMap>>>>'+accTOLEMap);
			System.debug('OptyList>>>'+optyList);
			System.debug('accOwnerMap>>>>'+accOwnerMap);//hcl
			
			for(Opportunity optyRecord  : optyList){
	system.debug('owner>>>'+optyRecord.Account.OwnerID);
	  /* if(accTOLEMap.get(optyRecord.AccountId)!= null){
		optyRecord.End_Customer_LE__c = accTOLEMap.get(optyRecord.AccountId);
		optyRecord.End_Customer_Information__c  = 'Known End Customer';//hcl
		optyRecord.Multiple_or_Unknown_EC_Market_Segment__c = null; //hcl 
		optyRecord.Multiple_or_Unknown_EC_Activity_Sector__c = null; //hcl 
		optyRecord.Multiple_or_Unknown_EC_Country__c = null; //hcl
	}
	*/
	optyRecord.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
	  optyRecord.Unweighted_Amount_EUR__c =0;
	optyRecord.Contract_Signing_Entity__c = 'fALU';
	optyRecord.G3_Planned_Date__c = System.today();
	optyRecord.G4_Planned_Date__c = System.today().addMonths(2);
	optyRecord.G5_Planned_Date__c = System.today().addMonths(3);
	optyRecord.G6_Planned_Date__c = System.today().addMonths(4);
	optyRecord.CloseDate = System.today().addMonths(3);
	optyRecord.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
	optyRecord.Phase_Status__c = GlobalConstants.PLANNED;
	optyRecord.isPartnerOpportunity__c = true;
	optyRecord.Gate_3_Bypass_no_offer_support__c= true;//hcl
	//hcl
	 /*  if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser)){
	   System.debug('True>>CustomPermission_CPQPartnerUser');
		optyRecord.OwnerId = accOwnerMap.get(optyRecord.AccountId); 
	 }*/
	
	if(RecordTypeId !=null){
	   optyRecord.RecordTypeId = RecordTypeId;
	}
	
			} 
			System.debug('OptyList>>>'+optyList); //hcl
		}Catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_OpportunityTriggerHelper.class.getName(),GlobalConstants.completeOpptyInfomethod);
		}
	}
	
	/******************************
*Method Name: updateOpty_afterinsert
*Description: This Method is used to add mandatory opportunity fields when partner user creates oppty.
********************************/   
	public static void updateOpty_afterinsert(List<Opportunity> optyList){
		try{
			System.debug('updateOpty_afterinsert>>>'+optyList);
			
			Id refOpptyId;
			
			List<Opportunity> finalOptyList = new List<Opportunity>();
			Set<Id> optyIDSet = new Set<Id>();
			
			for(Opportunity opty : optyList){
	optyIDSet.add(opty.ID);
			}
			System.debug('optyIDSet>>>>'+optyIDSet);
			
			Set<String>opptyNoSet = new Set<String>();
			Map<String,String>marketToOpptyMap = new Map<String,String>();
			Map<String,ID> referenceOptyIDMap = new Map<String,ID>();
			for(Reference_Oppty_Based_on_Acc_Market__mdt mdtrecord : [Select Market_Value__c,Reference_Oppty__c 
					  from Reference_Oppty_Based_on_Acc_Market__mdt LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])  {
					opptyNoSet.add(mdtrecord.Reference_Oppty__c);  
					marketToOpptyMap.put(mdtrecord.Market_Value__c,mdtrecord.Reference_Oppty__c)  ;
					  }
			for(Opportunity opty: [Select ID, name, Opportunity_ID__c from Opportunity where Opportunity_ID__c IN : opptyNoSet]){
	
	referenceOptyIDMap.put(opty.Opportunity_ID__c,opty.Id);
			}
			
			for(Opportunity optyRecord  : [Select Id, Name, CreatedBy.Name, Account.name,Lead_BU__c, Lead_BG__c, Account.GEOLevel1ID__c, Account.Owner.Name, Account.OwnerID, Opportunity_ID__c, Account.Market__c, Account.CurrencyIsoCode, Account.BusinessPartnerRole__c,Apttus_Approval__Approval_Status__c,
			 ApprovalStatusTechField__c,Approvals_Current_Status__c,G2_Approval_Date__c,StageName,Phase_Status__c 
			 from Opportunity 
			 where ID IN : optyIDSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			  
			if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser)){
			  optyRecord.OwnerId = optyRecord.Account.OwnerID; 
			  optyRecord.No_Offer_Support_Decision_Maker__c = optyRecord.Account.Owner.Name; //hcl
			  }
			  optyRecord.CurrencyIsoCode = optyRecord.Account.CurrencyIsoCode ;
	 System.debug('finalmapvalue>>>'+referenceOptyIDMap.get(marketToOpptyMap.get(optyRecord.Account.GEOLevel1ID__c)));
			  optyRecord.Reference_Opportunity__c = referenceOptyIDMap.get(marketToOpptyMap.get(optyRecord.Account.GEOLevel1ID__c));
			  /*if(optyRecord.Account.BusinessPartnerRole__c.equals(GlobalConstants.Alliance)){
			   optyRecord.Account_Role__c = GlobalConstants.AlliancePartner ;  
			  }*/  // changed for SH2022; Alliance was deactivated
			  //else if(optyRecord.Account.BusinessPartnerRole__c.equals(GlobalConstants.Distributor)){// changed for SH2022
			  if(optyRecord.Account.BusinessPartnerRole__c.equals(GlobalConstants.Distributor)){  
					optyRecord.Account_Role__c = GlobalConstants.GPPDistributorPartner;  
			  }
			  else if(optyRecord.Account.BusinessPartnerRole__c.equals(GlobalConstants.DirectCustomer)){
			   optyRecord.Account_Role__c = GlobalConstants.GPPSPAAPpartner ;  
			  }
			  else if(optyRecord.Account.BusinessPartnerRole__c.equals(GlobalConstants.DirectResellerPartner)){
			   optyRecord.Account_Role__c = GlobalConstants.GPPVARpartner  ; 
			  }
			  
			  finalOptyList.add(optyRecord) ;
			  
			 }
			
			Database.Update(finalOptyList);
			addOpptyTeamMember(finalOptyList);
			chatterNotificationToAccountOwner(finalOptyList);
			
			// Call to Bypass Gates for Opportunity
			IndirectCPQ_UpdateGate2HistoryData updateJob1 = new IndirectCPQ_UpdateGate2HistoryData(finalOptyList);
			ID jobID = System.enqueueJob(updateJob1);
			// IndirectCPQ_CreateOIFAndOffer updateJob1= new IndirectCPQ_CreateOIFAndOffer(finalOptyList);
			// ID jobID = System.enqueueJob(updateJob1); 
		}Catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_OpportunityTriggerHelper.class.getName(),GlobalConstants.updateOpty_afterinsertmethod);
		}
	}
	/******************************
*Method Name: addOpptyTeamMember
*Description: This Method is used to add Opportunity Team Members when partner user creates oppty.
********************************/   
	Public static void addOpptyTeamMember(List<Opportunity> finalOptyList){
		try{
			List<OpportunityTeamMember> oTMList = new list<OpportunityTeamMember>();
			List<OpportunityTeamMember> updatedOTMList = new list<OpportunityTeamMember>();
			Set<Id> finaloptyIDSet = new Set<Id>();
			Set<String> pricingManagerSet = new Set<String>();
			Map<String, String> BGtoPricingManagerMap = new Map<String,String>();
			Map<String, ID> usernameTOIdMap = new Map<String,ID>();
			
			//Addding Pricing Manager as OTM based on Business Group , Business Unit and Geo Level1 ID
			for(Pricing_Manager_Based_on_BG__mdt pmMDT : [Select Business_Group__c, Business_Unit__c, Geo_Level1_ID__c, Pricing_Manager__c 
				from Pricing_Manager_Based_on_BG__mdt where Pricing_Manager__c != Null LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	  pricingManagerSet.add(pmMDT.Pricing_Manager__c);
	  BGtoPricingManagerMap.put(pmMDT.Business_Group__c+ GlobalConstants.dash +pmMDT.Business_Unit__c+ GlobalConstants.dash +pmMDT.Geo_Level1_ID__c,pmMDT.Pricing_Manager__c) ;
	
			}
			System.debug('pricingManagerSet>>>>'+pricingManagerSet);
			System.debug('BGtoPricingManagerMap>>>>'+BGtoPricingManagerMap);
			
			for(User userRecord : [Select ID,Name,Username from User where Username IN : pricingManagerSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
	usernameTOIdMap.put(userRecord.Username,userRecord.Id);
	
			}
			System.debug('usernameTOIdMap>>>>'+usernameTOIdMap);
			
	 
			OpportunityTeamMember oTM, oTM2, oTM3, oTM4 ;
			String key;
			for(Opportunity opty : finalOptyList){
	finaloptyIDSet.add(opty.Id);
	
	if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser)){
	oTM = new OpportunityTeamMember();
	oTM.OpportunityId = opty.Id;
	oTM.OpportunityAccessLevel = GlobalConstants.EDIT_ACCESS;
	oTM.UserId = opty.Account.OwnerID;
	oTM.TeamMemberRole = GlobalConstants.PartnerSalesManager_User;
	oTMList.add(oTM); 
		
	oTM2 = new OpportunityTeamMember();
	oTM2.OpportunityId = opty.Id;
	oTM2.OpportunityAccessLevel = GlobalConstants.EDIT_ACCESS;
	oTM2.UserId = opty.CreatedById;
	oTM2.TeamMemberRole = GlobalConstants.TEAM_ROLE;
	oTMList.add(oTM2);   
		
	}
	else if(FeatureManagement.checkPermission(GlobalConstants.custompermission_PartnerSalesManager)){
	   oTM3 = new OpportunityTeamMember();
	oTM3.OpportunityId = opty.Id;
	oTM3.OpportunityAccessLevel = GlobalConstants.EDIT_ACCESS;
	oTM3.UserId = opty.CreatedById;
	oTM3.TeamMemberRole = GlobalConstants.PartnerSalesManager_User;
	oTMList.add(oTM3); 
		
	}
	
	  
	
	key = opty.Lead_BG__c+ GlobalConstants.dash + opty.Lead_BU__c + GlobalConstants.dash + opty.Account.GEOLevel1ID__c;
	id test=usernameTOIdMap.get(BGtoPricingManagerMap.get(key));
	System.debug('key>>>>'+key);
	System.debug('Valuee>>>>'+test);
	 oTM4 = new OpportunityTeamMember();
	oTM4.OpportunityId = opty.Id;
	oTM4.OpportunityAccessLevel = GlobalConstants.EDIT_ACCESS;
	oTM4.UserId = usernameTOIdMap.get(BGtoPricingManagerMap.get(key)) ;
	oTM4.TeamMemberRole = GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER;
	oTMList.add(oTM4);
	
			}
			System.debug('OTMLIST>>>>>'+oTMList);
			Database.insert(oTMList);
			
		 /*   for(OpportunityTeamMember opptyTeamMember : [Select OpportunityId, UserId, TeamMemberRole from OpportunityTeamMember Where OpportunityId IN : finaloptyIDSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	
	if(opptyTeamMember.TeamMemberRole == System.Label.ACC_MANAGER_TRICON_SCO){
		opptyTeamMember.TeamMemberRole =GlobalConstants.TEAM_ROLE;
		updatedOTMList.add(opptyTeamMember);
	}
			}
			
			Database.update(updatedOTMList); */
		}Catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_OpportunityTriggerHelper.class.getName(),GlobalConstants.addOpptyTeamMembermethod);
		}
	}
	
	
	/******************************
*Method Name: chatterNotificationToAccountOwner
*Description: This Method is used to Send Chatter notification to Account Manager (PSM) when partner user creates oppty.
*******************************/	 
	public static void chatterNotificationToAccountOwner(List<Opportunity> finalOptyList){
		try{
			
			ConnectApi.FeedItemInput feedItemInput;
			ConnectApi.MessageBodyInput messageBodyInput;
			ConnectApi.TextSegmentInput textSegmentInput;
			ConnectApi.MentionSegmentInput mentionSegmentInput ;
			
			
			
			for(Opportunity opty : finalOptyList){
	messageBodyInput = new ConnectApi.MessageBodyInput(); 
	messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
	
	textSegmentInput = new ConnectApi.TextSegmentInput();
	feedItemInput = new ConnectApi.FeedItemInput();
	mentionSegmentInput = new ConnectApi.MentionSegmentInput();
	String chatterText;
	
	//chatterText  = GlobalConstants.NEWLINE + opty.CreatedBy.Name + GlobalConstants.fromString +  opty.Account.name + GlobalConstants.chattermsg1 + opty.Name + GlobalConstants.chattermsg2;	 
	chatterText  = GlobalConstants.NEWLINE + opty.CreatedBy.Name + GlobalConstants.chattermsg1 + opty.Name +  GlobalConstants.forString + opty.Account.name + GlobalConstants.chattermsg2;	
	
	mentionSegmentInput.Id = opty.Account.OwnerID; 
	messageBodyInput.messageSegments.add(mentionSegmentInput);
	
	textSegmentInput.text = chatterText;
	messageBodyInput.messageSegments.add(textSegmentInput);
	
	
	
	feedItemInput.body = messageBodyInput;
	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	feedItemInput.subjectId = opty.ID;
	
	if(!Test.isRunningTest() )
		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);	
	
			}
			
		} Catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_OpportunityTriggerHelper.class.getName(),GlobalConstants.chatterNotificationToAccountOwnermethod);
		}
	}
   
	public static void  updateOpportunityRegion(Map<Id,List<Opportunity>> oppoMap){ 
		for(Account a:[SELECT id,GEOLevel1ID__c FROM Account WHERE id IN :oppoMap.keySet() ])  
		{ 
			if(string.isNotBlank(a.GEOLevel1ID__c)){
	List<Opportunity> opttyList = oppoMap.get(a.id);
	for (Opportunity opp : opttyList) {
		opp.NokiaCPQ_Region__c= a.GEOLevel1ID__c;	  
	}
			} 
		}
	}
	
	/******************************
*Method Name: optyOwnertoPartnerSharing_Helper
*Description: This Method is used to share Opportunity Owner record with Partner users when Account owner is different from Opportunity owner.
*******************************/	
	/*public static void optyOwnertoPartnerSharing_Helper(List<Opportunity> opptyList){
		try{  
			Set<Id> accountIDSet = new Set<Id>();
			Map<Id,Id> optyToAccMap = new MAp<Id,Id>(); 
			Map<Id,List<Contact>> accounttoContactMap = new map<Id,List<Contact>>();
			Map<ID,ID>contacttoUserMap = new Map<Id,ID>();
			List<UserShare> userShareList = new List<userShare>();
			UserShare userShareRecord; 
			Set<ID> contactIDSet = new Set<Id>();
			
			for(Opportunity oppty : opptyList){
	accountIDSet.add(oppty.AccountId);
	optyToAccMap.put(oppty.Id,Oppty.AccountId);
			}
			
			System.Debug('accountIDSet>>>'+accountIDSet);
			System.Debug('optyToAccMap>>>'+optyToAccMap);
			
			for(Contact con : [Select ID, AccountID from Contact where AccountID IN : accountIDSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])  {
	contactIDSet.add(con.Id);
	if(!accounttoContactMap.containsKey(con.AccountID)){
		accounttoContactMap.put(con.AccountID, new List<Contact>{con});  
		
	}else{
		accounttoContactMap.get(con.AccountID).add(con);
	}
			}
			
			System.Debug('accounttoContactMap>>>'+accounttoContactMap);
			
			for(User userRecord : [Select ID,ContactID from User where ContactID IN: contactIDSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	contacttoUserMap.put(userRecord.ContactID,userRecord.Id);
			}
			
			System.Debug('contacttoUserMap>>>'+contacttoUserMap);
			
			for(Opportunity opty : opptyList){
	for(Contact con: accounttoContactMap.get(optyToAccMap.get(opty.Id))){
		userShareRecord   = new UserShare();
		userShareRecord.UserAccessLevel = GlobalConstants.READ;
		userShareRecord.UserOrGroupId= contacttoUserMap.get(con.ID);
		userShareRecord.UserId = opty.OwnerId; 
		userShareList.add(userShareRecord);
	}
	
			}
			System.debug('userShareList>>>>'+userShareList);
			database.insert(userShareList);
		} Catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_OpportunityTriggerHelper.class.getName(),GlobalConstants.chatterNotificationToAccountOwnermethod);
		}
		
	}*/ 
  
}