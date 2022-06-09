/******************************
Class Name: OpportunityTriggerHelper
Created by: HCL Technologies
Created Date: 7th Jan 2021
Description: This class will handle the logic implemented on Opportunity
Note : Fix to handle unwanted update on probability in inline editing on Opportunity
******************************/
public inherited sharing class OpportunityTriggerHelper
{
	public final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	public final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();
	public final Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	public final Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();
	private final Id preOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PREOPPTY_RECORD_TYPE).getRecordTypeId();
	public String approvaldata;
	public static boolean isExecuting = false;

	//--- DEFAULT CONSTRUCTOR ---
	public OpportunityTriggerHelper()
	{
		system.debug('"OpportunityTriggerHelper" class instance initiated.');
	}

	public class InvocableVariableOpportunity
	{
		@InvocableVariable(label='Opportunity' required = true)
		public Opportunity theOpportunity;
	}

	//Sales Process: Sprint 5 : Req-758 Notify HSSE
	/*****************************
*Method Name: notifyHSSERiskCountry
*Description: On update of phase status
*Parameters: Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap
*******************************/
	@InvocableMethod
	public static void notifyHSSERiskCountry(List<Opportunity> opportunityList) {
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_NOTIFY_HSSE == False) {
	String country;
	Set<String> isoCodeList = new Set<String>();
	Map<String, String> isoCodeCountryMap = new Map<String, String>();
	List<ID> idlist = new List<ID>();
	List<Risk_Country__c> csList = new List<Risk_Country__c>();
	List<SendTo__c> recipientList = new List<SendTo__c>();
	List<String> sendToList = new List<String>();
	Map<Id, String> optyIdISOcode = new Map<Id, String>();
	csList = [SELECT id, Name, Country__c, ISO_Code__c FROM Risk_Country__c WHERE ExtremeRisk__c = true OR HighRisk__c = True Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	if(csList != Null) {
		for (Risk_Country__c obj1: csList) {
			isoCodeList.add(obj1.ISO_Code__c);
			isoCodeCountryMap.put(obj1.ISO_Code__c, obj1.Country__c);
		}
		Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
		Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();
		recipientList = [SELECT name FROM SendTo__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		for(SendTo__c obj: recipientList) {
			sendToList.add(obj.Name);
		}
		for(Opportunity optyid : opportunityList) {
			idlist.add(optyid.Id);
		}
		List<Opportunity> optyList = [SELECT id, End_Customer__r.CountryNameISO2__c FROM Opportunity WHERE id in:idlist];
		If(!optyList.isEmpty()) {
			for(Opportunity optyObject : optyList) {
				optyIdISOcode.put(optyObject.id, optyObject.End_Customer__r.CountryNameISO2__c);
			}
		}
		for (Opportunity Obj: opportunityList) {
			if((Obj.RecordTypeId.equals(oppDirectRecordTypeId) || Obj.RecordTypeId.equals(oppIndirectRecordTypeId)) && isoCodeList.contains(optyIdISOcode.get(Obj.Id))) {
				country = isoCodeCountryMap.get(optyIdISOcode.get(Obj.Id));
				OpportunityTriggerHelper opptTrigHelper = new OpportunityTriggerHelper();
				opptTrigHelper.sendEmail(Obj.Id, sendToList, country);
			}
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_NOTIFY_HSSE = True;
		} Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.NOTIFYHSSERISKCOUNTRY);
		}
	}

	/*****************************
*Method Name: Currenychange
*Description: Update unweighted amount
*Parameters: OpptyID
*******************************/
	@Future
	public static void Currenychange(Set<ID> opptyid) {
		List<Opportunity> updateOppty = new List<Opportunity>();
		Map<Object, Set<String>> aggResultMap = new Map<Object, Set<String>>();
		try {
			List<AggregateResult> aggResultList = [SELECT Business_Group__c, Opportunity__c FROM Order_Intake_Forecast__c
			   WHERE Opportunity__c  = :opptyid AND Allocation__c = false
			   GROUP BY Business_Group__c, Opportunity__c Limit:Limits.getLimitQueryRows()];
			for(AggregateResult aggResult:aggResultList)
			{
	if (!aggResultMap.containsKey(aggResult.get('Opportunity__c')))
		aggResultMap.put(aggResult.get('Opportunity__c'), new Set<String>());

	if (aggResultMap.containsKey(aggResult.get('Opportunity__c')))
		aggResultMap.get(aggResult.get('Opportunity__c')).add(String.ValueOf(aggResult.get('Business_Group__c')));
			}

			List<Opportunity> newoppList = [SELECT id, Positive_OIF_EUR__c, OIF_Value_Won_USD__c, Mono_or_Multi_BG__c, Sales_Outcome__c, OIF_Value_Cancel_USD__c, Positive_OIF__c, Negative_OIF_EUR__c, Negative_OIF__c, RecordType.name FROM Opportunity WHERE id = :opptyid AND RecordType.name != 'Pre-opportunity' Limit:opptyid.size()];
			for (Opportunity newopp:newoppList) {
	if(aggResultMap <> Null &&aggResultMap.get(newopp.id) <> Null && aggResultMap.get(newopp.id).size() > 1)
		newopp.Mono_or_Multi_BG__c='Multi-BG';
	else if(aggResultMap <> Null &&aggResultMap.get(newopp.id) <> Null && aggResultMap.get(newopp.id).size() == 1)
		newopp.Mono_or_Multi_BG__c='Mono-BG';
	else
		newopp.Mono_or_Multi_BG__c = null;
	if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
		newopp.amount = newopp.Positive_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Won_USD__c.setScale(2);
		newopp.Is_Automated__c = TRUE;
	} else if ((newopp.Sales_Outcome__c <> GlobalConstants.WON)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
		newopp.amount = newopp.Negative_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Cancel_USD__c.setScale(2);
		newopp.Is_Automated__c = TRUE;
	}
	updateOppty.add(newopp);
			}
			if(!updateOppty.isEmpty()) {
	update updateOppty;
	GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE = TRUE;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CURRENCY_CHANGE);
		}
	}

	/*****************************
*Method Name: MassupdateonOIFLines
*Description: This method will used to update the all OIF lines to cancelled/Lost
*Parameters: List<Opportunity>
*******************************/
	@Future
	public static void MassupdateonOIFLines(Set<Id> opptyMap) {
		list<Order_Intake_Forecast__c> oifUpdate = new List<Order_Intake_Forecast__c>();
		try{
			List<Order_Intake_Forecast__c> oifRecList = [SELECT Id, Opportunity__c, Opportunity__r.Sales_Outcome__c, Forecast_Category__c, BusinessLine__c FROM Order_Intake_Forecast__c WHERE Opportunity__c = :opptyMap and Allocation__c = false AND BusinessLine__c != Null];
			for(Order_Intake_Forecast__c OIFRec:oifRecList) {
	if(OIFRec.Opportunity__r.Sales_Outcome__c <> Null && (OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.CANCEL_BY_CUSTOMER) || OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.WITHDRAWN_BY_NOKIA) || OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.OPP_OBSOLETE)))
	{
		OIFRec.Forecast_Category__c = GlobalConstants.CANCEL;
		oifUpdate.add(OIFRec);
	} else if(OIFRec.Opportunity__r.Sales_Outcome__c <> Null && (OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.OPP_LOST_TO_COMPETITOR))) {
		if(OIFRec.Forecast_Category__c <> Null && !OIFRec.Forecast_Category__c.equalsignorecase(GlobalConstants.CANCEL) && !OIFRec.Forecast_Category__c.equalsignorecase(GlobalConstants.EXCLUDED))
			OIFRec.Forecast_Category__c = GlobalConstants.LOST;
		if(OIFRec.Forecast_Category__c <> Null && OIFRec.Forecast_Category__c.equalsignorecase(GlobalConstants.EXCLUDED))
			OIFRec.Forecast_Category__c = GlobalConstants.CANCEL;
		oifUpdate.add(OIFRec);
	}
			}
			if(!oifUpdate.isEmpty())
	Database.update(oifUpdate, False);
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.MASS_UPDATE);
		}
	}

	/*****************************
*Method Name: updateProbabilityOfPSROInFuture
*Description: This method will call FROM 'updateProbabilityOfPSROAsSalesOptyAfterUpdate'
*Requirement: PreSales : 5072
*Parameters: salesOptyIdsSet
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	@future
	public static void updateProbabilityOfPSROInFuture(Set<Id> salesOptyIdsSet) {
		List<Opportunity> salesOptyList = new List<Opportunity>();
		List<Opportunity> psroOptyListToUpdate = new List<Opportunity>();
		try{
			salesOptyList = [SELECT Id, Probability, (SELECT Id, Probability, StageName FROM PreSalesOpportunities__r WHERE StageName != : GlobalConstants.COMPLETED_OPPTY AND StageName != : GlobalConstants.CANCELLED AND StageName != : GlobalConstants.SUBMITTED_FOR_APPROVAL) FROM Opportunity WHERE Id in: salesOptyIdsSet Limit : salesOptyIdsSet.size() ];
			for(Opportunity salesOpty : salesOptyList) {
	for(Opportunity psroOpty : salesOpty.PreSalesOpportunities__r) {
		psroOpty.Probability = salesOpty.Probability;
		psroOptyListToUpdate.add(psroOpty);
	}
			}

			if(!psroOptyListToUpdate.isEmpty()) {
	Database.update(psroOptyListToUpdate);
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEPROBABILITYOFPSROINFUTURE);
		}
	}

	/*****************************
*Method Name: ClosedOpptyStatustoTeam
*Description:  Chatter Post to Oppty and Offer Team members to inform about to Opportunity Closed Status info
Req:5077 - chatter post on oppty close(positive and negative)
Req 5546 Ap release
*Parameters: opportunitiesMap
*******************************/
	@future
	public static void ClosedOpptyStatustoTeam(Set<Id> opptyIdSet) {

		map<ID, Set<ID>> mapOppIdRelatedUsers = new map<ID, Set<ID>>();
		map<Id, Opportunity> opportunitiesMap;
		list<Id> lstIds;
		Set<Id> emptySet = new set<Id>();
		Map<String, String> organizationinfo = new Map<String, String>();
		Map<String, ID> cTHeadinfo = new Map<String, ID>();
		Map<ID, Set<ID>> cTHeadDelegate = new Map<ID, Set<ID>>();
		Map<ID, ID> cTHeadID = new Map<ID, ID>();
		Map<ID, Offer__c> opptyIdOfferMap = new Map<ID, Offer__c>();
		String supportingBGsBUs='';
		ConnectApi.FeedItemInput feedItemInput ;
		ConnectApi.MessageBodyInput messageBodyInput;
		ConnectApi.TextSegmentInput textSegmentInput;
		try{
			GlobalConstants.OPPORTUNITY_CLOSE_CHECK = True;
			if(opptyIdSet.size() > 0) {
	opportunitiesMap = new Map<Id,Opportunity>([SELECT Id,Org_L7__c,CT_Head__c,OwnerId,Name,Account_Name__c,StageName,Opportunity_ID__c,Country__c,CurrencyIsoCode,Amount,Lead_BU__c,
						Lead_BG__c,Supporting_BGs_BUs__c,LOA_Level__c,Sales_Outcome__c,Sales_Outcome_Reason__c,Second_Reason__c,Third_Reason__c FROM opportunity
						WHERE id in: opptyIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
			}
			Map<Id, Offer__c> offerinfo = new Map<Id, Offer__c>([SELECT id, name, Opportunity__c, LoA_Approval_Level__c, LoA_Level_Before_Trigger_Approval__c FROM Offer__c WHERE ActiveOffer__c = True AND Opportunity__c = :opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ]);
			for(Offer__c offr : offerinfo.values()) {
	opptyIdOfferMap.put(offr.Opportunity__c, offr);
			}
			//fill the mapOppIdRelatedUsers map by Offer Team
			if(offerinfo.size() > 0) {
	for(Offer_Team__c offerTeamMembers: [SELECT id, Offer__c, Name__c, Offer__r.Opportunity__c FROM Offer_Team__c WHERE Team_Member_Role__c != :GlobalConstants.TEAM_ROLE AND Offer__c = :Offerinfo.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ]) {
		if (!mapOppIdRelatedUsers.containsKey(OfferTeamMembers.Offer__r.Opportunity__c)) {
			emptySet = new Set<Id>();
			mapOppIdRelatedUsers.put(OfferTeamMembers.Offer__r.Opportunity__c, emptySet);
		}
		if(mapOppIdRelatedUsers.containsKey(OfferTeamMembers.Offer__r.Opportunity__c))
			mapOppIdRelatedUsers.get(OfferTeamMembers.Offer__r.Opportunity__c).add(OfferTeamMembers.Name__c);
	}
			}
			// fill the mapOppIdRelatedUsers map by opportunity Owners
			for (Opportunity opp: opportunitiesMap.values()) {
	if(opp.Org_L7__c <> Null)
		Organizationinfo.put(opp.Org_L7__c, opp.Org_L7__c);
	if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
		emptySet = new Set<Id>();
		mapOppIdRelatedUsers.put(opp.Id, emptySet);
	}
	if(opp.CT_Head__c != Null)
		mapOppIdRelatedUsers.get(opp.Id).add(opp.CT_Head__c);
	mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
			}
			//colleting the CT Head Information
			if(Organizationinfo.size() > 0) {
	List<Sales_Role__c> salesroleList = [SELECT Organisation__c, OwnerId, Role_Code__c, User__c FROM Sales_Role__c WHERE Role_Code__c = :Label.NF_NSNG_HCT AND Organisation__c = :Organizationinfo.KeySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ];
	for(Sales_Role__c salesrole:salesroleList) {
		cTHeadinfo.put(Salesrole.Organisation__c, Salesrole.User__c);
		cTHeadID.put(Salesrole.User__c, Salesrole.User__c);
	}
	//colleceting the delegates info
	List<Apttus_Approval__Backup_Approver__c> delegateInfoList = [SELECT id, Apttus_Approval__Current_User__c, Delegate_Approver1__c, Delegate_Approver2__c, Delegate_Approver3__c, Apttus_Approval__Backup_User__c
					 FROM Apttus_Approval__Backup_Approver__c WHERE Apttus_Approval__IsActive__c = true and Apttus_Approval__InEffect__c = true and Apttus_Approval__Current_User__c = :cTHeadID.Keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	for (Apttus_Approval__Backup_Approver__c delegateInfo:delegateInfoList) {
		if(!CTHeadDelegate.containsKey(DelegateInfo.Apttus_Approval__Current_User__c)) {
			emptySet = new Set<Id>();
			CTHeadDelegate.put(DelegateInfo.Apttus_Approval__Current_User__c, emptySet);
		}
		if(DelegateInfo.Delegate_Approver1__c <> NUll && CTHeadDelegate <> NUll)
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Delegate_Approver1__c);

		if(DelegateInfo.Delegate_Approver2__c <> NUll && CTHeadDelegate <> NUll )
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Delegate_Approver2__c);

		if(DelegateInfo.Delegate_Approver3__c <> NUll && CTHeadDelegate <> NUll )
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Delegate_Approver3__c);

		if(DelegateInfo.Apttus_Approval__Backup_User__c <> NUll && CTHeadDelegate <> NUll)
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Apttus_Approval__Backup_User__c);
	}
	for (Opportunity opp: opportunitiesMap.values()) {
		if(cTHeadinfo.get(opp.Org_L7__c) <> Null) {
			if (opp.Org_L7__c <> Null && !mapOppIdRelatedUsers.containsKey(opp.Id)) {
				emptySet = new Set<Id>();
				mapOppIdRelatedUsers.put(opp.Id, emptySet);
			}
			if(opp.Org_L7__c <> Null)
				mapOppIdRelatedUsers.get(opp.Id).add(cTHeadinfo.get(opp.Org_L7__c));
			//passing the delegates id
			if(!CTHeadDelegate.isEmpty() && CTHeadDelegate.get(cTHeadinfo.get(opp.Org_L7__c)).size() > 0) {
				for(ID delegateID:CTHeadDelegate.get(cTHeadinfo.get(opp.Org_L7__c))) {
		if(DelegateID <> NUll)
			mapOppIdRelatedUsers.get(opp.Id).add(DelegateID);
				}
			}
		}
	}
			}
			// fill the Map by approvers /stackeholders /valIdators
			List<Apttus_Approval__Approval_Request__c> reqInfoList = [SELECT Id, Apttus_Approval__Step_Name__c, Apttus_Approval__Backup_From_User__c, Apttus_Approval__Assigned_To_Id__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c FROM Apttus_Approval__Approval_Request__c WHERE Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet() AND Apttus_Approval__Assigned_To_Id__c <> NULL LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ];
			for(Apttus_Approval__Approval_Request__c reqInfo:reqInfoList) {
	if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c)) {
		emptySet = new Set<Id>();
		mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
	}
	mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Assigned_To_Id__c);
	if (ReqInfo.Apttus_Approval__DelegateApproverIds__c != GlobalConstants.SALES_EMPTY) {
		String[] delegateApproverIds = ReqInfo.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
		for (string delegateapproverId: delegateApproverIds) {
			if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c)) {
				emptySet = new Set<Id>();
				mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
			}
			mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(delegateapproverId);
		}
	}
	if (ReqInfo.Apttus_Approval__Backup_From_User__c != GlobalConstants.SALES_EMPTY) {
		if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c)) {
			emptySet = new Set<Id>();
			mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
		}
		mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Backup_From_User__c);
	}
			}

			// fill the map by opportunity team members
			List<OpportunityTeamMember> opportunityTeamMemberList = [SELECT UserId, OpportunityId FROM OpportunityTeamMember WHERE TeamMemberRole != :GlobalConstants.TEAM_ROLE AND OpportunityId IN: opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ];
			for (OpportunityTeamMember opportunityTeamMember: opportunityTeamMemberList) {
	if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
		emptySet = new Set<Id>();
		mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, emptySet);
	}
	if(mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId))
		mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
			}

			for (ID oppId: opportunitiesMap.keySet()) {
	if (mapOppIdRelatedUsers.get(OppId) != null) {
		integer numberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / 24).round(System.RoundingMode.UP);
		integer startLoop = 0;
		for (integer i = 0; i < NumberOfPost; i++) {
			feedItemInput = new ConnectApi.FeedItemInput();
			messageBodyInput = new ConnectApi.MessageBodyInput();
			textSegmentInput = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));

			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentBold;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentBold;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentSpace;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentSpace;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentParagraph;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentParagraph;
			ConnectApi.MentionSegmentInput mentionSegmentInput;

			//Tag for Bold
			markupBeginSegmentBold = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			markupEndSegmentBold = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentBold.markupType = ConnectApi.MarkupType.Bold;

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.DEAR;
			messageBodyInput.messageSegments.add(textSegmentInput);

			for (integer j = StartLoop; j < StartLoop + 24; j++) {
				if (lstIds.size() > j) {
		mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = lstIds[j];
		if(mentionSegmentInput != null) {
			messageBodyInput.messageSegments.add(mentionSegmentInput);
		}
				}
			}
			StartLoop += 24;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.COMMAS;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//first line of chatter info
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.The_Opportunity;
			textSegmentInput.text += GlobalConstants.SPACE + opportunitiesMap.get(oppId).Name;
			textSegmentInput.text += GlobalConstants.SPACE + GlobalConstants.HYPHEN;
			textSegmentInput.text += GlobalConstants.SPACE + opportunitiesMap.get(oppId).Account_Name__c;
			textSegmentInput.text += GlobalConstants.SPACE + GlobalConstants.HAS_BEEN;
			textSegmentInput.text += GlobalConstants.SPACE + opportunitiesMap.get(oppId).StageName;
			textSegmentInput.text += GlobalConstants.DOT_SYMBOL;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// Oppty ID
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text += GlobalConstants.oppty_Number + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Opportunity_ID__c;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// opportunity name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.oppty_Name + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Name;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// Customer name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Customer + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Account_Name__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Account_Name__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			// Country name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text += GlobalConstants.Country + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Country__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Country__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			// Unweighted Amount
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Unweighted_Amounts + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).CurrencyIsoCode + GlobalConstants.SPACE + opportunitiesMap.get(oppId).Amount;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			// New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Lead BG
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Lead_BG + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Lead_BG__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Lead_BG__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//Lead BU
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Lead_BU + GlobalConstants.SPACE;

			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Lead_BU__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Lead_BU__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//Supporting BG/BU
			if(opportunitiesMap.get(oppId).Supporting_BGs_BUs__c <> Null && opportunitiesMap.get(oppId).Supporting_BGs_BUs__c <> ''){
				supportingBGsBUs = opportunitiesMap.get(oppId).Supporting_BGs_BUs__c.replaceAll(';',', ');
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +='Supporting BGs/BUs:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(supportingBGsBUs != Null){
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+supportingBGsBUs;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			// New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// LOA Level
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.LoALevel + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opptyIdOfferMap.size() > 0 && opptyIdOfferMap.containsKey(oppId) && opptyIdOfferMap.get(oppId).LoA_Approval_Level__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opptyIdOfferMap.get(oppId).LoA_Approval_Level__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			// LoA Level before STA
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.LoA_Level_Before_STA + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opptyIdOfferMap.size() > 0 && opptyIdOfferMap.containsKey(oppId) && opptyIdOfferMap.get(oppId).LoA_Level_Before_Trigger_Approval__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opptyIdOfferMap.get(oppId).LoA_Level_Before_Trigger_Approval__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Opportunity Conclusion
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Opportunity_Conclusion + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//Sales Outcome
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Sales_Outcomes + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Sales_Outcome__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Sales_Outcome__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//MainReason
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Main_Reason + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Sales_Outcome_Reason__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Sales_Outcome_Reason__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//SecondReason
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Second_Reasons + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Second_Reason__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Second_Reason__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//ThirdReason
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot + GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Third_Reasons + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Third_Reason__c != Null) {
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + opportunitiesMap.get(oppId).Third_Reason__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Regards
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Regards + GlobalConstants.COMMA;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Nokia_CRM;
			messageBodyInput.messageSegments.add(textSegmentInput);

			///New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Oppty link
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.OPPORTUNITY_LINK;
			textSegmentInput.text += URL.getSalesforceBaseUrl().toExternalForm();
			textSegmentInput.text += GlobalConstants.LINK2 + opportunitiesMap.get(oppId).Id;
			messageBodyInput.messageSegments.add(textSegmentInput);

			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = oppId;
			if (!test.isRunningTest()) {
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
			}
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CLOSED_OPPTY_POST);
		}
	}

	/*****************************
*Method Name: probabilityUpdate
*Description: This method will update probability on oppty with the old value if changed by inline editing, and set 0 for negative value and 100 for positive
*Parameters: Opportunity List, Opportunity Map
*Test coverage from: OpportunityTriggerHelperTest
* 1.0: Chnaging the logic FROM Sales Outcome to StageName
*******************************/
	public void probabilityUpdateInline( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		List<Opportunity> opptyRecList = new List<Opportunity>();
		if (OpportunityTriggerHelper.isExecuting) // if was executed during the same context, avoid recursion
			return;

		try
		{
			for (Opportunity opptyObj: opptyNewMap.values())
			{
	if (opptyObj.Probability == 0 && opptyOldMap.get(opptyObj.Id).probability != 0 &&
		opptyObj.StageName != opptyOldMap.get(opptyObj.Id).StageName &&
		(opptyObj.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY || opptyObj.StageName == GlobalConstants.DEVELOP_OPPORTUNITY || opptyObj.StageName == GlobalConstants.CREATE_OFFER || opptyObj.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE) &&
		(opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId))
	{
		Opportunity opptyRec = new Opportunity(Id = opptyObj.Id);
		opptyRec.probability = opptyOldMap.get(opptyObj.Id).probability;
		opptyRecList.add(opptyRec);
	}
			}
			if (!opptyRecList.isEmpty())
			{
	Database.update(opptyRecList, false);
			}
			OpportunityTriggerHelper.isExecuting = true;
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.PROBABILITY_UPDATE);
		}
	}

	/*****************************
*Method Name: setAccRole
*Description: This method will fill in the ACCOUNT ROLE field on indirect opp creation or converting it FROM a direct one
*Requirement: ft-128
*Parameters: Opportunity List
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void setAccRole(List<Opportunity> opptyList, Map<Id, Opportunity> optyOldMap)
	{
		Set<Id> accountIdSetForAccountRole = new Set<Id>();
		Map<Id, Account> idToAccountMap;
		List<CRM_AccountRole_Opp_Map__c> accRoleToBprMap = CRM_CreateOpportunityApexCtlr.getAccountRoleMappings();

		Map<string, string> accountRoleMap = CRM_CreateOpportunityApexCtlr.getAllAccountRoleValues();
		for (Opportunity opptyObj: opptyList)
		{
			if(checkAccountRoleEleg(opptyObj))
			{
	accountIdSetForAccountRole.add(opptyObj.accountId);
			}
		}
		if (!accountIdSetForAccountRole.isEmpty())
		{
			idToAccountMap = new Map<Id, Account>([SELECT id, Country__c, BusinessPartnerRole__c, ALCR_Record_Type__c FROM Account WHERE Id IN: accountIdSetForAccountRole LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
		}
		for (Opportunity opptyObj: opptyList)
		{
			if(checkAccountRoleEleg(opptyObj))
			{
	Account acc = idToAccountMap.get(opptyObj.accountId);
	String accRoleValueLbl = CRM_CreateOpportunityApexCtlr.getAccountRoleDefaultValue(acc.BusinessPartnerRole__c, accRoleToBprMap);
	opptyObj.Account_Role__c = accountRoleMap.get(accRoleValueLbl);
			}
		}
	}

	/*********
*Method Name: checkAccountRoleEleg
*Description: This method will avaluate if the account role should or not be updated
*Requirement: ft-128
*Parameters: Opportunity List
*Test coverage from: OpportunityTriggerHelperTest
* *******/
	@TestVisible
	private Boolean checkAccountRoleEleg(Opportunity opptyObj, Map<Id, Opportunity> optyOldMap)
	{
		Boolean isIndirectOpp = opptyObj.RecordTypeId == inDirectRecordTypeId;
		Boolean accRoleEmpty = opptyObj.Account_Role__c == null || opptyObj.Account_Role__c == '';
		Boolean result = accRoleEmpty && isIndirectOpp;
		return result;
	}

	/*********
*Method Name: checkAccountRoleEleg
*Description: This method will avaluate if the account role should or not be updated
*Requirement: ft-128
*Parameters: Opportunity List
*Test coverage from: OpportunityTriggerHelperTest
* *******/
	private Boolean checkAccountRoleEleg(Opportunity opptyObj)
	{
		Boolean isIndirectOpp = opptyObj.RecordTypeId == inDirectRecordTypeId;
		Boolean accRoleEmpty = opptyObj.Account_Role__c == null || opptyObj.Account_Role__c == '';
		Boolean result = accRoleEmpty && isIndirectOpp;
		return result;
	}

	/*****************************
*Method Name: convertionrateupdate
*Description: This method will update Unweighted Amount EUR to new rate vale(Ref:Dated Exchange Rate Values)
*Parameters: Opportunity opptyList
*******************************/
	public void convertionrateupdate(List<Opportunity> opptyList) {
		Set<Opportunity> opprec = new Set<Opportunity>();
		Set<String> oppcurrency = new Set<String>();
		map<String, Decimal> datedrate = new map<String, Decimal>();
		// collecting today date
		try {
			for (Opportunity newrec: opptyList) {
	opprec.add(newrec);
	oppcurrency.add(newrec.CurrencyIsoCode);
			}
			//collecting the Active period
			List<Nokia_Financial_Calendar__c > currentPeiod = [SELECT id, name, Start_Date__c, End_Date__c FROM Nokia_Financial_Calendar__c WHERE Current_Period__c = True ORDER BY End_Date__c ASC LIMIT 1];

			if(currentPeiod.size() > 0) {
	//collecting the rate
	List<Dated_Exchange_Rates__c> ratecollectList = [SELECT Id, CurrencyIsoCode, DER_Period__c, DER_Period__r.Start_Date__c, Exchange_Rate__c, Start_Date__c
				 FROM Dated_Exchange_Rates__c
				 WHERE(CurrencyIsoCode = :oppcurrency or CurrencyIsoCode  = :GlobalConstants.USD)
				 AND DER_Period__c = :currentPeiod.get(0).ID LIMIT: Limits.getLimitQueryRows()];
	for (Dated_Exchange_Rates__c ratecollect: ratecollectList)
		datedrate.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
	for (Opportunity updaterec: opptyList) {
		if (updaterec.OIF_Lines__c == 0) {
			if((!updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)) && updaterec.Amount <> 0) {
				if((!updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR))&& datedrate.get(GlobalConstants.USD) <> NUll && datedrate.get(updaterec.CurrencyIsoCode) <> Null)
		updaterec.Unweighted_Amount_USD__c=((updaterec.Amount/datedrate.get(updaterec.CurrencyIsoCode))*datedrate.get(GlobalConstants.USD)).setscale(2);
				else if(datedrate.get(GlobalConstants.USD) <> Null && updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR)) {
		updaterec.Unweighted_Amount_USD__c=(updaterec.Amount*datedrate.get(GlobalConstants.USD)).setscale(2);
				}
			} else
				updaterec.Unweighted_Amount_USD__c = updaterec.Amount;
			if ((!updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR)) && updaterec.Amount <> 0) {
				updaterec.Unweighted_Amount_EUR__c = (updaterec.Amount / datedrate.get(updaterec.CurrencyIsoCode)).setscale(2);
			} else{
				updaterec.Unweighted_Amount_EUR__c = updaterec.Amount;
			}
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.EXCHANGERATE);
		}
	}

	/*****************************
*Method Name: BatchCurrenychange
*Description: Update unweighted amount
*Parameters: Oppty ID
*******************************/
	public void BatchCurrenychange(Set<ID> opptyid) {
		List<Opportunity> updateOppty = new List<Opportunity>();
		try {
			List<Opportunity> newOppList = [SELECT id, Positive_OIF_EUR__c, OIF_Value_Won_USD__c, Sales_Outcome__c, OIF_Value_Cancel_USD__c, Positive_OIF__c, Negative_OIF_EUR__c, Negative_OIF__c FROM Opportunity WHERE id = :opptyid Limit:opptyid.size()];
			for (Opportunity newopp:newOppList) {
	if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
		newopp.amount = newopp.Positive_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Won_USD__c.setScale(2);
		newopp.Is_Automated__c = TRUE;
	}else if ((newopp.Sales_Outcome__c <> GlobalConstants.WON)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
		newopp.amount = newopp.Negative_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Cancel_USD__c.setScale(2);
		newopp.Is_Automated__c = TRUE;
	}
	updateOppty.add(newopp);
			}

			if(!updateOppty.isEmpty()) {
	List<Database.saveResult> srs = Database.update(updateOppty, false);
	ExceptionHandler.addExceptionForOIFBtach(updateOppty, srs);
	GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE = TRUE;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.BATCH_CURRENCY_CHANGE);
		}
	}

	//Requirement 722: Sales Process: Opportunity Decision date will update as per the NFC active period
	/*****************************
*Method Name: DecisonUpdate
*Description: Opportunity Active rate will update as per the NFC active period, Req 5470
*Parameters: Opportunity List
*******************************/
	public void DecisonUpdate(List<Opportunity> opptyList) {
		try {
			List<Opportunity> opportunityList = new List<Opportunity>();
			for (Opportunity opplist: opptyList) {
	//Adding a filter to avoide descision period is updated on Opportunity Creation.
	if ((opplist.id  != null) && String.isnotEmpty(opplist.StageName) &&  String.isEmpty(opplist.Decision_Period__c)  &&(opplist.StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY) || opplist.StageName.equalsignorecase(GlobalConstants.CANCELLED_BY_CUSTOMER) || opplist.StageName.equalsignorecase(GlobalConstants.LOST_TO_COMPETITOR) || opplist.StageName.equalsignorecase(GlobalConstants.OBSOLETE) ||  opplist.StageName.equalsignorecase(GlobalConstants.WITH_DRAW_BY_NOKIA)))
		//Sales outcome not empry then decision Period will update as per the Active NFC Period Name
		opportunityList.add(opplist);
	else if(opplist.StageName.equalsignorecase(GlobalConstants.IDENTIFY_OPPORTUNITY) || opplist.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) || opplist.StageName.equalsignorecase(GlobalConstants.CREATE_OFFER) ||opplist.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE))
		opplist.Decision_Period__c = '';
			}
			if(!opportunityList.isEmpty()) {
	//Collecting the Active period Name
	List<Nokia_Financial_Calendar__c> currentPeiod = [SELECT id, name, Start_Date__c, End_Date__c FROM Nokia_Financial_Calendar__c WHERE Current_Period__c = True ORDER BY End_Date__c LIMIT 1];
	if(currentPeiod.size() > 0) {
		for(Opportunity opp : opptyList) {
			opp.Decision_Period__c = currentPeiod.get(0).Name;
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.DECISION_UPDATE);
		}
	}

	//Requirement 722: Sales Process: Opportunity owner will follow Opportunity on Chatter
	/*****************************
*Method Name: FollowOpportunity
*Description: Opportunity owner will follow Opportunity on Chatter
*Parameters: Opportunity List
*******************************/
	public void FollowOpportunity(List<Opportunity> opptyList) {
		List<EntitySubscription> opptyEntitySubList = new List<EntitySubscription>();
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_FOLLOW_OPPTY == False) {
	for (Opportunity opptyObj: opptyList) {
		EntitySubscription opptyEntity = new EntitySubscription();
		opptyEntity.ParentId = opptyObj.id;
		opptyEntity.SubscriberId = opptyObj.OwnerId;
		opptyEntity.NetworkId = Network.getNetworkId();
		opptyEntitySubList.add(opptyEntity);
	}
	database.insert(opptyEntitySubList);
			}
			GlobalConstants.OPPORTUNITYTRIGGER_FOLLOW_OPPTY = True;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.FOLLOW_OPPORTUNITY);
		}
	}

	/*
* @desc   this method used to create opportunity team members for delegates approvers
* @param   opportunities: the map of opportunities which are approved or rejected
*/
	/*
public void createOpportunityTeamMembers(map<Id, Opportunity> opportunitiesMap) {
// Variables declaration
map<ID, Set<Id>> mapOppIdMemberIds = new map<ID, Set<Id>>();
map<ID, Set<Id>> mapOppIdFacilitatorsIds = new map<ID, Set<Id>>();
List<OpportunityTeamMember> opportunitiesTeamMembersToCreate = new List<OpportunityTeamMember>();
//get the Delegate Approvers Ids map
for (Opportunity opportunity: opportunitiesMap.values()) {
if (!mapOppIdFacilitatorsIds.containsKey(opportunity.Id)) {
mapOppIdFacilitatorsIds.put(opportunity.Id, new Set<ID>());
}
if (opportunity.Facilitator_Delegate_1__c != null)
mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Delegate_1__c);
if (opportunity.Facilitator_Delegate_2__c != null)
mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Delegate_2__c);
if (opportunity.Facilitator_Delegate_3__c != null)
mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Delegate_3__c);
if (opportunity.Facilitator_Backup__c != null)
mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Backup__c);
if (opportunity.NF_Facilitator_User__c != null)
mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.NF_Facilitator_User__c);
}
// Fill the map of opportunity and related users in opportunity team members
List<OpportunityTeamMember> opportunitiesTeamMembers = [SELECT UserId, OpportunityId
FROM OpportunityTeamMember
WHERE OpportunityId IN: mapOppIdFacilitatorsIds.keySet()
];
for (OpportunityTeamMember oppTeamMember: opportunitiesTeamMembers) {
if (!mapOppIdMemberIds.containsKey(oppTeamMember.OpportunityId)) {
mapOppIdMemberIds.put(oppTeamMember.OpportunityId, new Set<ID>());
}
mapOppIdMemberIds.get(oppTeamMember.OpportunityId).add(oppTeamMember.UserId);
}

for (Id oppId: mapOppIdFacilitatorsIds.keySet()) {
set<ID> existingMemberIds = new set<ID>();
existingMemberIds = mapOppIdMemberIds.get(oppId);
for (Id FacilitatorId: mapOppIdFacilitatorsIds.get(oppId)) {
if (FacilitatorId != null && ((existingMemberIds != null && !existingMemberIds.contains(FacilitatorId)) || existingMemberIds == null)) {
opportunitiesTeamMembersToCreate.add(new OpportunityTeamMember(
UserId = FacilitatorId, OpportunityId = oppId, OpportunityAccessLevel = 'Edit'));
}
}
}
}
*/
	//Requirement 870: Default Legal Entity Logic
	/*****************************
*Method Name: populateDefaultLE
*Description: this method used to populate default legalEntities on opportunity
*Parameters: Opportunity List
*******************************/
	public void populateDefaultLE(List<Opportunity> opportunityList, Map<ID, Opportunity> optyOldMap,  Map<Id,Account> accountsInfo) {
		List<Opportunity> validCustomerChanges = new List<Opportunity>();
		for (Opportunity opp: opportunityList) {
			if (optyOldMap.size() > 0) {
	if (opp.AccountId != optyOldMap.get(opp.Id).AccountId || opp.End_Customer__c != optyOldMap.get(opp.Id).End_Customer__c) {
		validCustomerChanges.add(opp);
	}
			} else {
	if (opp.Legal_Entity__c == NULL || opp.End_Customer__c == NULL)
		validCustomerChanges.add(opp);
			}
		}
		for (Opportunity opp: validCustomerChanges) {
			if (opp.RecordTypeId == directRecordTypeId && opp.End_Customer__c != NULL) {
	if(accountsInfo.containsKey(opp.End_Customer__c)){
		Id endCustLEId = accountsInfo.get(opp.End_Customer__c).ChildAccounts.size() > 0 ? accountsInfo.get(opp.End_Customer__c).ChildAccounts[0].Id : null;
		opp.End_Customer_LE__c = endCustLEId;
	} else
		opp.End_Customer_LE__c = NULL;
			}
			if (opp.accountId != NULL) {
	if(accountsInfo.containsKey(opp.accountId)){
		Id accLEId = accountsInfo.get(opp.accountId).ChildAccounts.size() > 0 ? accountsInfo.get(opp.accountId).ChildAccounts[0].Id : null;
		opp.Legal_Entity__c = accLEId;
	} else
		opp.Legal_Entity__c = NULL;
			}
		}

	// if(validCustomerChanges.size() > 0) {

			/*
			List<String> allAccountIds = new List<String>();
			Map<string, string> customerVsDefaultLE = new Map<string, string>();
			for (Opportunity opp: validCustomerChanges) {
	allAccountIds.add(opp.accountId);
	//Null Check added by HCL on 9th Aug 2019
	if(opp.End_Customer__c != null) {
		allAccountIds.add(opp.End_Customer__c);
	}
			}
			List<Account> defaultLEList = [SELECT Id, parentId FROM Account WHERE RecordType.name = 'Legal Entity'
			 and Default_Legal_Entity__c = true
			 and parentId IN: allAccountIds
			 limit: (Limits.getLimitQueryRows() - Limits.getQueryRows())
			];
			for (Account defaultLE: defaultLEList) {
	customerVsDefaultLE.put(defaultLE.parentId, defaultLE.Id);
			}

			Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			for (Opportunity opp: validCustomerChanges) {
	if (opp.RecordTypeId == oppDirectRecordTypeId && opp.End_Customer__c != NULL) {
		if(customerVsDefaultLE.containsKey(opp.End_Customer__c))
			opp.End_Customer_LE__c = customerVsDefaultLE.get(opp.End_Customer__c);
		else
			opp.End_Customer_LE__c = NULL;
	}
	if (opp.accountId != NULL) {
		if(customerVsDefaultLE.containsKey(opp.accountId))
			opp.Legal_Entity__c = customerVsDefaultLE.get(opp.accountId);
		else
			opp.Legal_Entity__c = NULL;
	}
			}

		}*/
	}

	/***************************************
*Method Name: updateOffersOnG4ApprovalDateIsUpdated
*Description: This method will update the 'Active Offer' G4/G5 Approval date field on update of G4/G5 Appproval date of Opportunity. REQ#942& defect D-2793
*Parameters: Opportunity Maps old/new
*History : 22-12-2017 AJ: Requirement : 3545, Comment Logic to transfer G5 Approval date from Oppty to Active Offer & Delete field from Offer.
*******************************/
	public static void updateOffersOnG4ApprovalDateIsUpdated(Map<ID, Opportunity> opptyMap, Map<ID, Opportunity> opptyOldMap) {
		List<Offer__c> offerToUpdate = new List<Offer__c>();
		Map<ID, List<Offer__c>> oppOfferListMap = new Map<ID, List<Offer__c>>();
		Set<Id> opptyIdSet = new Set<Id>();

		for(Opportunity objO: opptyMap.values()) {
			if(objO.TotalOfferCount__c > 0 && objO.NF_LoA_Bypass__c > 0) {
	opptyIdSet.add(objO.Id);
			}
		}

		if(!opptyIdSet.isEmpty() && opptyIdSet.size() > 0) {
			List<Offer__c> offerList = [Select id, ActiveOffer__c, Opportunity__c, G4_Approval_Date__c from Offer__c where Opportunity__c IN: opptyIdSet AND ActiveOffer__c = True];
			try {
	for (Offer__c offer: offerList) {
		//checking for active Offer
		if (offer.ActiveOffer__c == True) {
			List<Offer__c> offList = new List<Offer__c>();
			//Opportunity can have multiple Offer hence the below check
			if (oppOfferListMap.get(offer.Opportunity__c) != Null) {
				//Fetching the already existing opportunity id and adding offer List
				offList.addAll(oppOfferListMap.get(offer.Opportunity__c));
				offList.add(offer);
				oppOfferListMap.put(offer.Opportunity__c, offList);
			}
			if (oppOfferListMap.get(offer.Opportunity__c) == Null) {
				offList.add(offer);
				oppOfferListMap.put(offer.Opportunity__c, offList);
			}
		}
	}
	for (ID opptyID: oppOfferListMap.KeySet()) {
		for (Offer__c off: oppOfferListMap.get(opptyID)) {
			Opportunity opp = opptyMap.get(opptyID);
			if (opp.G4_Approval_Date__c != Null && opptyOldMap.get(opp.id).G4_Approval_Date__c != opp.G4_Approval_Date__c) {
				off.G4_Approval_Date__c = date.newinstance(opp.G4_Approval_Date__c.year(), opp.G4_Approval_Date__c.month(), opp.G4_Approval_Date__c.day());
				offerToUpdate.add(off);
			}
			//Requirement : 3545, Comment Logic to transfer G5 Approval date from Oppty to Active Offer & Delete field from Offer. Logic is deleted from here.
		}
	}
	if(offerToUpdate.size() > 0)
	{
		database.Update(offerToUpdate);
		GlobalConstants.OPPORTUNITYTRIGGER_HELPER_UPDATE_G4_G5 = true;
	}
			} catch (Exception ex) {
	ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATE_G4_G5_APROVALDATE_FUNCTION);
			}
		}
	}


	//Sales Process: Requirement 855
	/*****************************
*Method Name: restrictOpptyCreationByOTMFromDiffrentTerritory
*Description: Checks the current user territory and account territory if maps allows opportunity Creation
*Parameters: Opportunity List
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void restrictOpptyCreationByOTMFromDiffrentTerritory(List<Opportunity> newOpptyList) {
		Map<Id, ObjectTerritory2Association> accountIdsAndOTMap = new Map<Id, ObjectTerritory2Association>();
		Set<Id> terriIds = new Set<Id>();
		Set<Id> accountIDs = new Set<Id>();
		Set<ID> objIDterriHerirachySet = new Set<ID>();
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_RESTRICT_OPPTY_CREATION == False && !FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser)) {
	List<UserTerritory2Association> myList = [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association WHERE UserId = :userinfo.getuserid() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (UserTerritory2Association terr: myList) {
		terriIds.add(terr.Territory2Id);
	}

	Map<Id, Territory2> idToTerritoryMap = new Map<Id, Territory2>([SELECT Id, Name, ParentTerritory2Id
					FROM Territory2
					WHERE Id IN: terriIds
					LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	Map<Id, Territory2> allTerritory = new Map<Id, Territory2>([SELECT Id, Name, DeveloperName, ParentTerritory2Id
							FROM Territory2
							WHERE Territory2Model.state = :GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE
							LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);

	for (Opportunity opp: newOpptyList) {
		accountIDs.add(opp.AccountID);
	}
	List<ObjectTerritory2Association> oTList = [SELECT Id, ObjectId, Territory2Id FROM ObjectTerritory2Association WHERE ObjectId IN: accountIDs LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (ObjectTerritory2Association ot: oTList) {
		if (ot.ObjectId != null) {
			accountIdsAndOTMap.put(ot.ObjectId, ot);
		}
	}
	for (Opportunity opp: newOpptyList) {
		if (opp.AccountID != null) {
			ObjectTerritory2Association objectTerr = accountIdsAndOTMap.get(opp.AccountID);
			if (allTerritory.get(objectTerr.Territory2Id) != null) {
				Territory2 terr = allTerritory.get(objectTerr.Territory2Id);
				objIDterriHerirachySet.add(terr.Id);
				ID territoryParentID = terr.ParentTerritory2Id;
				for (Integer i = 0; territoryParentID != null; i++) {
		objIDterriHerirachySet.add(territoryParentID);
		if (allTerritory.get(territoryParentID).ParentTerritory2Id != null) {
			territoryParentID = allTerritory.get(territoryParentID).ParentTerritory2Id;
		} else {
			territoryParentID = null;
		}
				}
			}
		}
		Integer size = 0;
		for (ID terrID: objIDterriHerirachySet) {
			if (idToTerritoryMap.KeySet().contains(terrID)) {
				Size++;
			}
		}
		if (size<1) {
			opp.addError(GlobalConstants.ACCOUNT_TERRITORY_IS_DIFFRENT_FROM_OPPORTUNITY_CREATOR_TERRITORY);
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_RESTRICT_OPPTY_CREATION = True;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.RESTRICTOPPTYCREATIONBYOTMFROMDIFFRENTTERRITORY);
		}
	}

	/*****************************
*Method Name: UpdateUserinformation
*Description: Update the Lastmodifieduser filed as per the Lastmodied custom data.
*Parameters: Opportunity List
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void UpdateUserinformation(List<Opportunity> newOpptyList) {
		//collecting the Lastmodified custom data information
		List<LastModified__c> customdata = LastModified__c.getall().values();
		Map<Id, String> customid = new Map<ID, String>();

		//collecting the custom data User ID
		for(LastModified__c custominfo:customdata)
			customid.put(custominfo.User_ID__c, custominfo.User_ID__c);
		try{
			for(Opportunity Opplist:newOpptyList) {
	if(Opplist.Modified_User__c <>(customid.get(Opplist.Modified_User__c)))
		Opplist.Last_User_Modified__c = System.now();
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATE_USER_INFORMATION);
		}
	}

	//Sales Process: Sprint 5 : D-1512 Pupulate End Customer with Account and End customer LE with Account LE`
	/*****************************
*Method Name: populateDefaultEndCustomerAndEndCustomerLegalEntity when record type is Direct
*Description: this method used to populate default legalEntities on opportunity
*Parameters: Opportunity List
*Change Log : 1.1 D-1645 Sprint 5 Hypercare Fixes(Sales Process)
*******************************/
	public void populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(List<Opportunity> opportunityList, Map<ID, Opportunity> opportunityOldMap) {
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_END_CUSTOMER == false) {
	Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	for (Opportunity opp: opportunityList) {
		if (opp.RecordTypeId == oppDirectRecordTypeId && opp.Lead_type__c == Null && opp.PartnerAvailable__c != GlobalConstants.PICKLIST_VALUE_YES) {

			// commented below for SF Ticket 01219748 (along with sonarcube adjustment) 25-01-2021
			/*if (!opportunityOldMap.isEmpty() && opportunityOldMap.get(opp.Id).End_Customer__c != opp.End_Customer__c) {
opp.End_Customer__c = opp.AccountId;
if (opp.Legal_Entity__c != NULL) {
opp.End_Customer_LE__c = opp.Legal_Entity__c;
}
} else {
opp.End_Customer__c = opp.AccountId;
if (opp.Legal_Entity__c != NULL) {
opp.End_Customer_LE__c = opp.Legal_Entity__c;
}
}*/
			// Added below for SF Ticket 01219748 (along with sonarcube adjustment) 25-01-2021
			opp.End_Customer__c = opp.AccountId;
			if (opp.Legal_Entity__c != NULL) {
				opp.End_Customer_LE__c = opp.Legal_Entity__c;
			}
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_END_CUSTOMER = True;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.POPULATEENDCUSTOMERANDENDCUSTOMERLEGALENTITYFORDIRECTRECORDTYPE);
		}
	}

	//Sales Process: Sprint 6 : Req-758 send Email
	/*****************************
*Method Name: sendEmail
*Description: On update of phase status send mail to HSSE risk countries.
*Parameters: Id optyId, List<string> sendToList
*******************************/
	@TestVisible
	private void sendEmail(Id optyId, List<String> sendToList, String country) {
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_SEND_EMAIL == False) {
	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	String projectExeOwnerNameEmail = NULL;
	Date dt;
	String formattedDate;
	Opportunity opty = [SELECT G3_Approval_Date__c, End_Customer__c, OwnerId, Opportunity_ID__c, Lead_BG__c, End_Customer__r.Name, End_Customer__r.L7Name__c   FROM Opportunity WHERE Id  = :optyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
	List<User> optyOwner = [SELECT name, Email FROM user WHERE Id = :opty.OwnerId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	List<OpportunityTeamMember> optyTeamMemberList = new List<OpportunityTeamMember>();
	optyTeamMemberList = [SELECT Name, UserId  FROM OpportunityTeamMember WHERE TeamMemberRole = :GlobalConstants.PROJECTEXECUTIONOWNER AND OpportunityId = :optyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	if(opty.G3_Approval_Date__c != null) {
		dt = Date.valueOf(opty.G3_Approval_Date__c);
		formattedDate = dt.format();
	}
	if(!optyTeamMemberList.isEmpty()) {
		List<user> cmdUser = [SELECT name, Email FROM user WHERE id  = :optyTeamMemberList[0].UserId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		projectExeOwnerNameEmail = GlobalConstants.COLON + GlobalConstants.BOLD + cmdUser[0].Name + GlobalConstants.ENDBOLD + GlobalConstants.BODY9 + GlobalConstants.COLON + cmdUser[0].Email;
	}
	else{
		projectExeOwnerNameEmail = GlobalConstants.COLON + GlobalConstants.BOLD + GlobalConstants.BODY10 + GlobalConstants.ENDBOLD;
	}
	String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
	String emailBody = GlobalConstants.BODY1;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY2 + GlobalConstants.LINK1 + sfdcBaseURL + GlobalConstants.LINK2 + optyId + GlobalConstants.URLPART6 + opty.Opportunity_ID__c + GlobalConstants.LINK3 + GlobalConstants.BODY3 + formattedDate;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY4;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY5 + GlobalConstants.COLON + GlobalConstants.BOLD + country + GlobalConstants.ENDBOLD;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY6 + GlobalConstants.COLON + GlobalConstants.BOLD + optyOwner[0].name + GlobalConstants.ENDBOLD + GlobalConstants.BODY7 + GlobalConstants.COLON + optyOwner[0].Email;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY8 + projectExeOwnerNameEmail;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY11 + GlobalConstants.COLON + GlobalConstants.BOLD + opty.Lead_BG__c + GlobalConstants.ENDBOLD;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY12 + GlobalConstants.COLON + GlobalConstants.BOLD + opty.End_Customer__r.Name + GlobalConstants.ENDBOLD;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.BODY13 + GlobalConstants.COLON + GlobalConstants.BOLD + opty.End_Customer__r.L7Name__c + GlobalConstants.ENDBOLD;
	emailBody += GlobalConstants.LINEBREAK + GlobalConstants.LINEBREAK + GlobalConstants.DISCLAIMER1 + GlobalConstants.LINEBREAK + GlobalConstants.DISCLAIMER2 + GlobalConstants.LINEBREAK + GlobalConstants.DISCLAIMER3;

	Id docId, docId1;
	String[] queryList = new String[]{GlobalConstants.HEADER, GlobalConstants.FOOTER};
		for(document doc : [SELECT Id, Name FROM document WHERE Name IN:queryList])
	{
		if(doc.Name == GlobalConstants.HEADER && String.isNotBlank(doc.Name))
			docId = doc.Id;
		if(doc.Name == GlobalConstants.FOOTER && String.isNotBlank(doc.Name))
			docId1 = doc.Id;
	}

	Id orgID = UserInfo.getOrganizationId();
	mail.setWhatId(optyId);
	mail.setToAddresses(sendToList);
	mail.setSubject(GlobalConstants.EMAILSUBJECT);
	mail.setHtmlBody(GlobalConstants.URLPART1 + GlobalConstants.URLPART2 + sfdcBaseURL + GlobalConstants.URLPART3 + GlobalConstants.URLPART4 + docId + GlobalConstants.URLPART5 + orgID + GlobalConstants.URLPART6 + GlobalConstants.URLPART7 + GlobalConstants.URLPART8 + emailBody + GlobalConstants.URLPART9 + GlobalConstants.URLPART10 + GlobalConstants.URLPART11 + sfdcBaseURL + GlobalConstants.URLPART3 + GlobalConstants.URLPART4 + docId1 + GlobalConstants.URLPART5 + orgID + GlobalConstants.URLPART6 + GlobalConstants.URLPART12);
	mails.add(mail);
	if(!Test.isRunningTest())
		Messaging.sendEmail(mails);
			}
			GlobalConstants.OPPORTUNITYTRIGGER_SEND_EMAIL = True;
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.SENDEMAIL);
		}
	}

	/***************************************************************************
*Method Name: validateRefOpptyAndPTASigned
*Description: This will serve as method for validation for No LOA and PTA Signed
*Parameters: Opportunity Map
*******************************************************************************/
/*	public void validateRefOpptyAndPTASigned(Map<ID, Opportunity> opptyMap, Map<ID, Opportunity> opptyOldMap) {
		Offer__c offerObj = new Offer__c();
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_VALIDATE ==  False) {
	List<Opportunity> opptyList = [SELECT id, TotalOfferCount__c, Reference_Opportunity__c, PTA_Signed__c, StageName, Phase_Status__c, (SELECT id, ActiveOffer__c, LOA_Bypass__c FROM Offers__r WHERE ActiveOffer__c = true LIMIT 1) FROM opportunity WHERE Id IN: opptyMap.keySet()];
	//SF Ticket 00003242: If 'LoA Bypass offer condition' is No LoA and Active Offer, Reference Opportunity cannot be changed or cannot be blank
	for(opportunity oppty : opptyList) {
		if(Oppty.TotalOfferCount__c > 0 && Oppty.Offers__r.size() > 0)
			offerObj = Oppty.Offers__r;
		if(offerObj != Null) {
			If(oppty.Reference_Opportunity__c == NULL && OfferObj.LOA_Bypass__c == GlobalConstants.NO_LOA && oppty.SWx_Upsell_Proposal__c == Null) {
				opptyMap.get(oppty.id).addError(GlobalConstants.REFERENCE_OPPTY_ERROR);
			}
			//Adding condition to check Opportunity's PTA Signed Gate_6_Bypass_No_Execute_needed__c is true at the same time
			//Requiremet 2381
			if(oppty.PTA_Signed__c == TRUE && oppty.Gate_6_Bypass_No_Execute_needed__c == TRUE) {
				opptyMap.get(oppty.id).addError(label.PtaProduct_OnlyOfferAreNotSame);
			}
			//Either 'PTA Signed' or 'Product/Software Only' should be checked before G6 approval
			if(oppty.PTA_Signed__c == FALSE && (oppty.StageName.equalsignorecase(GlobalConstants.EXECUTE_OPPTY) && opptyOldMap.get(oppty.Id).StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY)) && oppty.Gate_6_Bypass_No_Execute_needed__c == FALSE) {
				opptyMap.get(oppty.id).addError(label.PTAOrProductOnlyOfferShouldBeChecked);
			}
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_VALIDATE = True;
		}Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.Validate_Ref_Oppty_And_PTA_Signed);
		}
	}	*/

	/*Helper method to get optylist based on presales recordtype*/
	public Map<Id, Opportunity> getIsApplicableForSalesNewMap(Map<Id, Opportunity> opptyMap) {
		Map<Id, Opportunity> salesOptyMap = new Map<Id, Opportunity>();
		try{
			for(Opportunity opty : opptyMap.values()) {
	if(opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId) {
		salesOptyMap.put(opty.Id, opty);
	}
			}
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.GETISAPPLICABLEFORPRESALESLIST);
		}
		return salesOptyMap;
	}

	/*****************************
*Method Name: checkLEIsEmpty
*Description: This method will check whether Legal Entity is Empty
*Parameters: Opportunity opptyList
*******************************/
	public void checkLEIsEmpty(List<Opportunity> opportunityList, Map<ID, Opportunity> optyOldMap, Map<Id,Account> accountsInfo) {
		try{
	for (Opportunity opp: opportunityList) {
	 if( opp.RecordTypeId == inDirectRecordTypeId || opp.RecordTypeId == directRecordTypeId){
		 Boolean existLegalEntity = false;
		 if(accountsInfo.containsKey(opp.AccountId) && accountsInfo.get(opp.AccountId).ChildAccounts.size() > 0){ //ChildAccounts refers to LE having the Account as parent
			 existLegalEntity = true;
		 }
		 if(opp.Legal_Entity__c != optyOldMap.get(opp.Id).Legal_Entity__c && opp.Legal_Entity__c == null && existLegalEntity) {
			opp.addError(label.Legal_Entity_Cannot_be_Empty);
		 }
		 Boolean existECLegalEntity = false;
		 if(accountsInfo.containsKey(opp.End_Customer__c) && accountsInfo.get(opp.End_Customer__c).ChildAccounts.size() > 0){ //ChildAccounts refers to EC LE having the End Customer as parent
			 existECLegalEntity = true;
		 }
		 if(opp.End_Customer_LE__c != optyOldMap.get(opp.Id).End_Customer_LE__c && opp.End_Customer_LE__c == null && existECLegalEntity) {
			opp.addError(label.Legal_Entity_Cannot_be_Empty);
		 }

	 }
	}


			/*
			Map<Id, List<Opportunity>> accountIdwithOpportunityMap = new Map<Id, List<Opportunity>>();
			Map<Id, List<Opportunity>> endCustomerIdwithOpportunityMap = new Map<Id, List<Opportunity>>();
			List<opportunity> optyList = new List<opportunity>();
			List<opportunity> endCustomeroptyList = new List<opportunity>();
			for (Opportunity opp: opportunityList) {
	if(((opp.Legal_Entity__c != optyOldMap.get(opp.Id).Legal_Entity__c) || (opp.End_Customer_LE__c != optyOldMap.get(opp.Id).End_Customer_LE__c)) && (opp.RecordTypeId == inDirectRecordTypeId || opp.RecordTypeId == directRecordTypeId))
	{
		if(accountIdwithOpportunityMap.containsKey(opp.AccountId)) {
			optyList = accountIdwithOpportunityMap.get(opp.AccountId);
			optyList.add(opp);
			accountIdwithOpportunityMap.put(opp.AccountId, optyList);
		}
		else{
			optyList = new List<opportunity>();
			optyList.add(opp);
			accountIdwithOpportunityMap.put(opp.AccountId, optyList);
		}
		If(endCustomerIdwithOpportunityMap.containsKey(opp.End_Customer__c)) {
			endCustomeroptyList = endCustomerIdwithOpportunityMap.get(opp.End_Customer__c);
			endCustomeroptyList.add(opp);
			endCustomerIdwithOpportunityMap.put(opp.End_Customer__c, endCustomeroptyList);
		}
		else{
			endCustomeroptyList = new List<opportunity>();
			endCustomeroptyList.add(opp);
			endCustomerIdwithOpportunityMap.put(opp.End_Customer__c, endCustomeroptyList);
		}
	}
			}

			//------------------------------------- NEW CODE -----------------------------------------------------
			if(!accountIdwithOpportunityMap.isEmpty() || !endCustomerIdwithOpportunityMap.isEmpty())
			{
	Set<Id> lstOppAccIds = new Set<Id>();
	lstOppAccIds.addAll(accountIdwithOpportunityMap.keyset());
	lstOppAccIds.addAll(endCustomerIdwithOpportunityMap.keyset());

	List<AggregateResult> resultList = [SELECT count(Id), ParentId
				FROM Account
				WHERE recordtype.name = : GlobalConstants.LEGAL_ENTITY
				GROUP BY parentId HAVING count(id) > 0
				AND ParentId in: lstOppAccIds
				LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];

	boolean breakFlag = false;
	for (AggregateResult result : resultList)
	{
		//For Account
		List<Opportunity> lstOpty = (accountIdwithOpportunityMap.containsKey(String.valueOf(result.get('ParentId'))))? accountIdwithOpportunityMap.get(String.valueOf(result.get('ParentId'))) : null;
		if(lstOpty != null)
		{
			for(Opportunity opp : lstOpty)
			{
				if (optyOldMap.get(opp.Id).Legal_Entity__c != Null && opp.Legal_Entity__c == NULL)
				{
		opp.addError(label.Legal_Entity_Cannot_be_Empty);
		breakFlag = true;
		break;
				}
			}
		}

		//For Endcustomer
		lstOpty = (endCustomerIdwithOpportunityMap.containsKey(String.valueOf(result.get('ParentId'))))? endCustomerIdwithOpportunityMap.get(String.valueOf(result.get('ParentId'))) : null;
		if(lstOpty != null)
		{
			for(Opportunity opp : lstOpty)
			{
				if (optyOldMap.get(opp.Id).End_Customer_LE__c  != Null && opp.End_Customer_LE__c == NULL)
				{
		opp.addError(label.Legal_Entity_Cannot_be_Empty);
		breakFlag = true;
		break;
				}
			}
		}

		if(breakFlag)
			break;
	}
			}
			//---------------------------------------- END NEW CODE -------------------------------------------------
			*/
		}Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.METHOD_CHECK_LE_ISEMPTY);
		}
	}

	/*****************************
*Method Name: offerPriceChange
*Description: This method will update offer Price
*Parameters: Opportunity opptyList, opportunity od map
*******************************/
	public void offerPriceChange(List<opportunity> opptyList, Map<Id, opportunity> opptyOldMap) {
		Map<Id, Offer__c> optyActiveOfferMap = new Map<Id, Offer__c>();
		List<Offer__c> activeOfferList = new List<Offer__c>();
		List<Offer__c> offerList = new List<Offer__c>();
		Set<Id> idSet = new Set<Id>();
		for(Opportunity opty : opptyList) {
			idSet.add(opty.Id);
		}
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE == False) {
	activeOfferList = [SELECT Opportunity__c, Id, Price__c, ActiveOffer__c FROM Offer__c WHERE ActiveOffer__c = true and Opportunity__c in :idSet];
	if(!activeOfferList.isEmpty()) {
		for(Offer__c offerObj : activeOfferList) {
			optyActiveOfferMap.put(offerObj.Opportunity__c, offerObj);
		}
		for (Opportunity opp: opptyList) {
			if((opp.RecordTypeId == inDirectRecordTypeId || opp.RecordTypeId == directRecordTypeId) &&
		 opp.Apttus_Approval__Approval_Status__c != 'Pending Approval' &&
		 opp.Amount != opp.Active_Offer_Price__c && opp.Amount != opptyOldMap.get(opp.Id).Amount &&
		 opp.Amount != NULL && optyActiveOfferMap.get(opp.Id).Price__c != opp.Amount &&
		 optyActiveOfferMap.get(opp.Id).ActiveOffer__c == true) {
		  optyActiveOfferMap.get(opp.Id).Price__c = opp.Unweighted_Amount_Opportunity_Currency__c;
		  offerList.add(optyActiveOfferMap.get(opp.Id));
		 }
		}
	}
	if (!offerList.isEmpty()) {
		Database.update(offerList, false);
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE = True;
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.METHOD_OFFER_PRICE_CHANGE);
		}
	}

	/*****************************
*Method Name: DeleteAllocationLine
*Description: Delete the Allocation lines as per the CSE flad
*Parameters: Opptyid
*******************************/
	public void DeleteAllocationLine(Set<ID> opptyid) {
		List<Order_Intake_Forecast__c > oifRecDelete = New List<Order_Intake_Forecast__c>();
		try{
			if(GlobalConstants.OPPORTUNITY_DELETE_ALLOCATION == false) {
	//Colleting the Clone Reocrds
	for(Order_Intake_Forecast__c OIFinfo: [SELECT id, name, Update_Status__c FROM Order_Intake_Forecast__c WHERE Allocation__c = TRUE AND Opportunity__c = :opptyid Limit:Limits.getLimitQueryRows()])
	{
		oifRecDelete.add(OIFinfo);
	}
	if(oifRecDelete.size() > 0)
	{
		Database.delete(oifRecDelete);
	}
	GlobalConstants.OPPORTUNITY_DELETE_ALLOCATION = true;
			}
		}
		catch(Exception Ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.DELETE_ALLOCATION_LINES);
		}
	}

	/*****************************
*Method Name: populateG5ContractApprovalDate
*Description: Req-3062 G5 Process: Date Fields
*Parameters: Trigger.new, Trigger.oldMap
*******************************/
	public void populateG5ContractApprovalDate(List<opportunity> opptyList, Map<Id, opportunity> opptyOldMap) {
		System.debug('test enter populateG5ContractApprovalDate');
		try{
			if(GlobalConstants.G5_CONTRACT_APPROVAL == false) {
	for(Opportunity opp: opptyList) {
		if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) && opp.StageName == GlobalConstants.HANDOVER_OPPTY  && opptyOldMap.get(opp.id).StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE  && opptyOldMap.get(opp.id).Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION ) {
			opp.G5_Contract_Approval_Date__c = System.now();
			System.debug('test assign populateG5ContractApprovalDate' + opp.G5_Contract_Approval_Date__c);
		}
	}
	GlobalConstants.G5_CONTRACT_APPROVAL = true;
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.populateG5ContractApprovalDate);
		}
	}

	//Sales process: Sprint 9: requirement 3158, AP Release 5546
	/******************************
*Method Name: chatterPostToAccountManager
*Description: This method is used inform Account Manager when G4/G5 approved
Opportunity  and OIF BG's deviate through chatter.
*Parameters:  OpptyNewMap, OpptyOldMap
********************************/
	public void chatterPostToAccountManager(Map<Id, Opportunity > opptyMap, Map<Id, Opportunity > oldOpptyMap) {
		//Oppty BG's set
		Set<String> opportunityBGs = new Set<String>();
		//OIF BG's set
		Set<String> oifBGs = new Set<String>();
		//AccountId set
		Set<Id> accountIds = new Set<Id>();
		Set<Id> opptyIdSet = new Set<Id>();
		List<Opportunity> opptyList = new List<Opportunity>();
		//ConnecAPI For chatter Post
		ConnectApi.FeedItemInput feedItemInput;
		ConnectApi.MessageBodyInput messageBodyInput;
		ConnectApi.TextSegmentInput textSegmentInput;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment1;
		ConnectApi.MarkupEndSegmentInput markupEndSegment1;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment2;
		ConnectApi.MarkupEndSegmentInput markupEndSegment2;
		ConnectApi.MentionSegmentInput mentionSegmentInput;
		List<Order_Intake_Forecast__c> oifList;
		//Account Map
		Map<Id, Account> accountMap;
		//map of oppty and related OIF's
		Map<Id, list<Order_Intake_Forecast__c>> oifMap = new Map<Id, List<Order_Intake_Forecast__c>>();
		try {
			for(opportunity opptyObj : opptyMap.values()) {
	if((opptyObj.StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE && oldOpptyMap.get(opptyObj.Id).StageName == GlobalConstants.CREATE_OFFER)
	   || (opptyObj.StageName == GlobalConstants.HANDOVER_OPPTY && oldOpptyMap.get(opptyObj.Id).StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE)
	   && (opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId)) {
		opptyIdSet.add(opptyObj.id);
		opptyList.add(opptyObj);
	   }
			}
			if (GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG == false && opptyIdSet.size() > 0) {
	//Loop to add oppty and related OIF's in map
	for (Order_Intake_Forecast__c orderIntakeForecast: [SELECT id, Business_Group__c, Business_Unit__c, Opportunity__c, Allocation__c FROM Order_Intake_Forecast__c WHERE Opportunity__c in :opptyIdSet and Allocation__c = False and Forecast_Category__c != : GlobalConstants.CANCEL and Forecast_Category__c != : GlobalConstants.Lost LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		if (oifMap.containsKey(orderIntakeForecast.Opportunity__c)) {
			oifList = new List<Order_Intake_Forecast__c>();
			oifList = oifMap.get(orderIntakeForecast.Opportunity__c);
			oifList.add(orderIntakeForecast);
			oifMap.put(orderIntakeForecast.Opportunity__c, oifList);
		} else {
			oifList = new List<Order_Intake_Forecast__c>();
			oifList.add(orderIntakeForecast);
			oifMap.put(orderIntakeForecast.Opportunity__c, oifList);
		}
	}
	//Loop to get All account Ids in set
	for (Opportunity oppty: opptyList) {
		accountIds.add(oppty.AccountId);
	}
	//Getting name of account
	if(accountIds.size() > 0) {
		accountMap = new Map<Id, Account >([SELECT Id, Name FROM Account WHERE id in :accountIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	}
	//loop on all oppty's which qualify conditions for chatter
	for (Opportunity oppty: opptyList) {
		//checking flag for recurssion
		if (GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG == false && opptyIdSet.size() > 0) {
			//Adding Oppty BG's in Set
			if (String.isNotBlank(oppty.Lead_BG__c) && !String.isEmpty(oppty.Lead_BG__c)) {
				opportunityBGs.add(oppty.Lead_BG__c);
			}
			//Adding Supporting BGs in Set
			if (oppty.Supporting_BGs_BUs__c != null && oppty.Supporting_BGs_BUs__c != '') {
				List<String> bgBuList = new List<String>();
				bgBuList.addAll(oppty.Supporting_BGs_BUs__c.split(';'));
				for(String bgBuValue : bgBuList) {
		opportunityBGs.add(bgBuValue.split(' ')[0]);
				}
			}
			//Looping over OIF map to add OIF BG's in set
			for (Order_Intake_Forecast__c OIF: oifMap.get(oppty.Id)) {
				if (String.isNotBlank(OIF.Business_Group__c) && !String.isEmpty(OIF.Business_Group__c)) {
		oifBGs.add(OIF.Business_Group__c);
				}
			}
			//checking condition if BG's deviate
			if (!opportunityBGs.equals(oifBGs) && !opportunityBGs.containsAll(oifBGs) && !oifBGs.isEmpty()) {
				//ConnecAPI For chatter Post
				feedItemInput = new ConnectApi.FeedItemInput();
				messageBodyInput = new ConnectApi.MessageBodyInput();
				mentionSegmentInput = new ConnectApi.MentionSegmentInput();
				mentionSegmentInput.id = oppty.ownerId;
				messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
				messageBodyInput.messageSegments.add(mentionSegmentInput);

				markupBeginSegment1 = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegment1.markupType = ConnectApi.MarkupType.Bold;
				messageBodyInput.messageSegments.add(markupBeginSegment1);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + GlobalConstants.HYPHEN;
				textSegmentInput.text += GlobalConstants.SPACE + System.Label.Chatter_Message;
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegment1 = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegment1.markupType = ConnectApi.MarkupType.Bold;
				messageBodyInput.messageSegments.add(markupEndSegment1);

				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + GlobalConstants.For_Oppty;
				messageBodyInput.messageSegments.add(textSegmentInput);

				markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupBeginSegment2);
				markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegment2);

				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = oppty.Opportunity_ID__c + GlobalConstants.SPACE;
				textSegmentInput.text += GlobalConstants.HYPHEN + GlobalConstants.SPACE + oppty.Name;
				textSegmentInput.text += GlobalConstants.SPACE + GlobalConstants.HYPHEN;
				textSegmentInput.text += GlobalConstants.SPACE + accountMap.get(oppty.AccountId).name;
				messageBodyInput.messageSegments.add(textSegmentInput);

				messageBodyInput.messageSegments.add(markupBeginSegment2);
				messageBodyInput.messageSegments.add(markupEndSegment2);

				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.Check_And_Update;
				messageBodyInput.messageSegments.add(textSegmentInput);

				messageBodyInput.messageSegments.add(markupBeginSegment2);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.New_Black_Space;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegment2);

				String oppty_BGs = '' + opportunityBGs;
				oppty_BGs = oppty_BGs.remove(GlobalConstants.Curly_Braces_Start);
				oppty_BGs = oppty_BGs.remove(GlobalConstants.Curly_Braces_End);
				opportunityBGs.remove(oppty.Lead_BG__c);
				String supporting_BGs = '' + opportunityBGs;
				supporting_BGs = supporting_BGs.remove(GlobalConstants.Curly_Braces_Start);
				supporting_BGs = supporting_BGs.remove(GlobalConstants.Curly_Braces_End);
				String oif_BGs = '' + oifBGs;
				oif_BGs = oif_BGs.remove(GlobalConstants.Curly_Braces_Start);
				oif_BGs = oif_BGs.remove(GlobalConstants.Curly_Braces_End);

				messageBodyInput.messageSegments.add(markupBeginSegment1);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.Lead_BG + GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegment1);

				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = oppty.Lead_BG__c;
				messageBodyInput.messageSegments.add(textSegmentInput);

				if (!opportunityBGs.isEmpty()) {
		messageBodyInput.messageSegments.add(markupBeginSegment1);
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.SPACE + GlobalConstants.Supporting_BGs + GlobalConstants.SPACE;
		messageBodyInput.messageSegments.add(textSegmentInput);
		messageBodyInput.messageSegments.add(markupEndSegment1);

		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.SPACE + supporting_BGs;
		messageBodyInput.messageSegments.add(textSegmentInput);
				}
				messageBodyInput.messageSegments.add(markupBeginSegment2);
				messageBodyInput.messageSegments.add(markupEndSegment2);

				messageBodyInput.messageSegments.add(markupBeginSegment1);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.oif_BGs + GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegment1);

				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE + oif_BGs;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupBeginSegment2);
				messageBodyInput.messageSegments.add(markupEndSegment2);

				feedItemInput.body = messageBodyInput;
				feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
				feedItemInput.subjectId = Oppty.Id;
				if (!test.isRunningTest()) {
		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
				}
			}
		}
	}
	GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG = true;
			}
		} catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER);
		}
	}

	/*****************************
*Method Name: populateSalesOutcome
*Description: This method will populate Sales Outcome and Opportunity Sales Phase Tracking on Opportunity
*Parameters: List<Opportunity>, Map<ID, Opportunity> opptyOldMap
*******************************/
	public void populateSalesOutcome(List<Opportunity> opptyList, Map<ID, Opportunity> opptyOldMap) {
		Id readOnlyDirect = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
		Id readOnlyIndirect = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();
		Map<String, Stage_Sales_Outcome__c> openPhases = new Map<String, Stage_Sales_Outcome__c>();
		Map<String, Stage_Sales_Outcome__c> wonPhases = new Map<String, Stage_Sales_Outcome__c>();
		Map<String, Stage_Sales_Outcome__c> lostPhases = new Map<String, Stage_Sales_Outcome__c>();
		Set<Id> oppRecordTypes = new Set<Id> {directRecordTypeId, inDirectRecordTypeId, readOnlyDirect, readOnlyIndirect};
			Set<String> profileBypass = new Set<String> {Label.System_Admin_Profile, Label.Global_Process_Admin_Profile, Label.Accenture_Admin, Label.Nokia_Admin_Profile, Label.SDC_Admin};
	Set<Id> roRecordTypes = new Set<Id> {readOnlyDirect, readOnlyIndirect};
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME == false) {
				List<Stage_Sales_Outcome__c> salesOutcomeValues = Stage_Sales_Outcome__c.getAll().values();
				List<Profile> currentProfile = [SELECT id, Name FROM profile WHERE Id  = :UserInfo.getProfileId()];
				AllowReopenOpptyAndAccountChange__c userBypass = AllowReopenOpptyAndAccountChange__c.getInstance(UserInfo.getUserId());
				for(Stage_Sales_Outcome__c csObj: salesOutcomeValues) {
		if(csObj.Stage_Type__c.equalsignorecase(GlobalConstants.ClosedLost)) {
			lostPhases.put(csObj.Name, csObj);
		} else if(csObj.Stage_Type__c.equalsignorecase(GlobalConstants.ClosedWon)) {
			wonPhases.put(csObj.Name, csObj);
		} else if(csObj.Stage_Type__c.equalsignorecase(GlobalConstants.Open)) {
			openPhases.put(csObj.Name, csObj);
		}
				}
				for(Opportunity opp: opptyList) {
		if(!oppRecordTypes.contains(opp.RecordTypeId) || opp.StageName.equalsignorecase(opptyOldMap.get(opp.id).StageName)) {
			continue;
		}
		if(openPhases.containsKey(opp.StageName)) {
			//For a re-opened Oppty, clear Sales Outcome and populate Phase Status
			if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c == opp.StageName) {
				opp.Sales_Outcome__c = openPhases.get(opp.StageName).Related_Sales_Outcome__c;
				opp.Phase_Status__c = openPhases.get(opp.StageName).Related_Phase_Status__c;
				opp.Opportunity_Sales_Phase_Tracking__c = GlobalConstants.BLANK_VALUE;
				opp.Probability = GlobalConstants.DEFAULT_PROBABILITY;
			}
			//Navigating through Sales Phases
			else if(openPhases.containsKey(opptyOldMap.get(opp.id).StageName) || wonPhases.containsKey(opptyOldMap.get(opp.id).StageName)) {
				opp.Phase_Status__c = openPhases.get(opp.StageName).Related_Phase_Status__c;
			}
			//When user re-opens Oppty with a different Sales Phase, throw error
			else if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c != opp.StageName) {
				//Edit not allowed for non-admin profiles
				if(roRecordTypes.contains(opp.RecordTypeId) && !profileBypass.contains(currentProfile[0].Name) && UserInfo.getUserEmail() != userBypass.Email__c && userBypass.Allow_Reopening_of_Closed_opportunity__c == false) {
					opp.addError(Label.FreezeOppError);
					break;
				}
				opp.addError(Label.Sales_Phase_Error + GlobalConstants.DOUBLE_STARTQUOTE + opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c + GlobalConstants.DOUBLE_ENDQUOTE);
			}
		}
		//Set Sales Outcome as appropriate FROM Custom Setting when Sales Phase is Closed
		else if(lostPhases.containsKey(opp.StageName)) {
			if(roRecordTypes.contains(opp.RecordTypeId) && lostPhases.containsKey(opptyOldMap.get(opp.id).StageName)) {
				opp.addError(Label.ClosedOpportunityError);
				break;
			}
			opp.Opportunity_Sales_Phase_Tracking__c = opptyOldMap.get(opp.id).StageName;
			opp.Sales_Outcome__c = lostPhases.get(opp.StageName).Related_Sales_Outcome__c;
			opp.Phase_Status__c = lostPhases.get(opp.StageName).Related_Phase_Status__c;
			if(String.isNotBlank(lostPhases.get(opp.StageName).Default_Main_Reason__c)) {
				opp.Sales_Outcome_Reason__c = lostPhases.get(opp.StageName).Default_Main_Reason__c;
				opp.Second_Reason__c = GlobalConstants.BLANK_VALUE;
				opp.Third_Reason__c = GlobalConstants.BLANK_VALUE;
			}
		} else if(wonPhases.containsKey(opp.StageName)) {
			//Re-opening with Won Phase
			if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && roRecordTypes.contains(opp.RecordTypeId) && !profileBypass.contains(currentProfile[0].Name) && UserInfo.getUserEmail() != userBypass.Email__c && userBypass.Allow_Reopening_of_Closed_opportunity__c == false) {
				opp.addError(Label.FreezeOppError);
				break;
			} else if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c != opp.StageName && (profileBypass.contains(currentProfile[0].Name) || (UserInfo.getUserEmail() == userBypass.Email__c && userBypass.Allow_Reopening_of_Closed_opportunity__c == True))) {
				opp.addError(Label.Sales_Phase_Error + GlobalConstants.DOUBLE_STARTQUOTE + opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c + GlobalConstants.DOUBLE_ENDQUOTE);
				break;
			}
			opp.Sales_Outcome__c = wonPhases.get(opp.StageName).Related_Sales_Outcome__c;
			opp.Phase_Status__c = wonPhases.get(opp.StageName).Related_Phase_Status__c;
		}
				}
				GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = true;
			}
			if(Test.isRunningTest()) {
				CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
				throw testingCatch;
			}
		} catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.populateSalesOutcome);
		}
	}

	/*****************************
*Method Name: populatePhaseStatusOnInsert
*Description: This method will populate Phase Status on new Opportunity
*Parameters: List<Opportunity>
*******************************/
	public void populatePhaseStatusOnInsert(List<Opportunity> opptyList) {
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_PHASESTATUS == false) {
	Stage_Sales_Outcome__c phaseStatusValue = Stage_Sales_Outcome__c.getValues(GlobalConstants.IDENTIFY_OPPORTUNITY);
	Set<Id> oppRecordTypes = new Set<Id> {directRecordTypeId, inDirectRecordTypeId};
		for(Opportunity opp: opptyList) {
			// added by-pass for Upsell Opportunity.
			if(oppRecordTypes.contains(opp.RecordTypeId) && opp.SWx_Upsell_Proposal__c == Null && (opp.Business_Type__c != GlobalConstants.COMMITTED_UPSELL || opp.Is_Auto_Upsell__c != True) && opp.Business_Type__c != GlobalConstants.FAST_TRACK_OPP_TYPE) {
				opp.StageName = phaseStatusValue.Name;
				opp.Phase_Status__c = phaseStatusValue.Related_Phase_Status__c;
				//Sales process Req#3791
				opp.Probability = GlobalConstants.DEFAULT_PROBABILITY;
			}
		}
	GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_PHASESTATUS = true;
			}
			if(Test.isRunningTest()) {
	CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
	throw testingCatch;
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.populatePhaseStatusOnInsert);
		}
	}

	/*****************************
*Method Name: populateReasons
*Description: This method will populate the win/loss reasons.
*Parameters:Opportunity List, Opportunity Map
*Requirement : 3217
*******************************/
	public void populateReasons( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
		Map<Id, Offer__c> opptyOfferMap = new Map<Id, Offer__C>();
		set<String> loaBypassSet = new set<String>();
		String unweighted_Amount = System.Label.Unweighted_Amount_For_Sales_Outcome;
		Offer__C objOpptyOffer = null;

		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId)
		&&((opptyObj.OIF_Amount_EUR__c == 0 && opptyObj.Amount >= Decimal.valueOf(unweighted_Amount)) || opptyObj.OIF_Amount_EUR__c >= Decimal.valueOf(unweighted_Amount)) &&
		(opptyObj.StageName == GlobalConstants.CANCELLED_BY_CUSTOMER || opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR || opptyObj.StageName == GlobalConstants.WITH_DRAW_BY_NOKIA)
		&& opptyObj.Apttus_Approval__Approval_Status__c != GlobalConstants.APPROVED && opptyObj.Apttus_Approval__Approval_Status__c != GlobalConstants.PENDING_APPROVAL)
	{
		opptyMap.put(opptyObj.Id, opptyObj);
	}
			}
			if(!opptyMap.isEmpty()) {
	for(Offer__c offerObj : [SELECT id, ActiveOffer__c, Opportunity__c, LOA_Bypass__c FROM Offer__c WHERE Opportunity__c IN: opptyMap.KeySet() AND ActiveOffer__c = True LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		opptyOfferMap.put(offerObj.Opportunity__c, offerObj);
	}

	for(Opportunity opptyObj: opptyMap.values()) {
		objOpptyOffer = null;
		if(opptyObj.count_offer__c > 0) {
			objOpptyOffer = opptyOfferMap.get(opptyObj.id);
			List<String> loaBypassList = System.label.LoA_Bypass_Offer_Condition.Split(GlobalConstants.COMMA);
			loaBypassSet.addAll(loaBypassList);
			if(objOpptyOffer != null && !loaBypassSet.contains(objOpptyOffer.LOA_Bypass__c) && (opptyObj.Sales_Outcome_Reason__c == null || opptyObj.Second_Reason__c == null || opptyObj.Third_Reason__c == null)) {
				opptyObj.addError(System.label.PopulateReasonsOnOppty);
			}
		} else if(opptyObj.count_offer__c == 0 && (opptyObj.Sales_Outcome_Reason__c == null || opptyObj.Second_Reason__c == null || opptyObj.Third_Reason__c == null)) {
			opptyObj.addError(System.label.PopulateReasonsOnOppty);
		}
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.Populate_Reasons);
		}
	}

	//Requirement 3775: End customer autopopulate Logic
	/*****************************
*Method Name: populateEnd Customer
*Description: this method used to populate End Customer on opportunity
*Parameters: Opportunity List
*******************************/
	public void populateEndCustomer(List<Opportunity> opportunityList, Map<ID, Opportunity> optyOldMap, Map<Id,Account> accountsInfo) {
		List<Opportunity> validCustomerChanges = new List<Opportunity>();
		for (Opportunity opp: opportunityList) {
			if (optyOldMap.size() > 0) {
	if (opp.End_Customer_LE__c != optyOldMap.get(opp.Id).End_Customer_LE__c) {
		validCustomerChanges.add(opp);
	}
			} else if (opp.End_Customer_LE__c != NULL) {
		validCustomerChanges.add(opp);
			}
		}
		for (Opportunity opp: validCustomerChanges) {
			if(accountsInfo.containsKey(opp.End_Customer_LE__c))
	opp.End_Customer__c = accountsInfo.get(opp.End_Customer_LE__c).parentId;
			else
	opp.End_Customer__c = NULL;
		}
	}

	/*****************************
*Method Name: deleteOpenTasks
*Description: This method will populate the win/loss reasons.
*Parameters:Opportunity Set, Task Map
*Requirement : 4313
*******************************/
	public void deleteOpenTasks(Map<Id, Opportunity> opptyNewMap, Map<Id, Opportunity> opptyOldMap) {
		Set<Id> opptyIdSet = new Set<Id>();
		List<Task> taskList = new List<Task>();
		try{
			for(Opportunity opp : opptyNewMap.values()) {
	if(opp.StageName <> null && opptyNewMap.get(opp.id).StageName <> null && (opp.StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER)) || (opp.StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA)) ||
	   (opp.StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR)) || (opp.StageName.equalsIgnoreCase(GlobalConstants.OBSOLETE))) {
		opptyIdSet.add(opp.Id);
	   }
			}
			if(!opptyIdSet.isEmpty()) {
	List<Task> taskRecList = [SELECT Id, Status, WhatId FROM Task WHERE WhatID = :opptyIdSet and Status = :GlobalConstants.Open Limit:Limits.getLimitQueryRows()];
	for(Task taskRec :taskRecList) {
		taskRec.Open_Task_At_Closure__c = GlobalConstants.VALUE_TRUE;
		taskRec.Task_Creation_By_Pass_Check__c = GlobalConstants.VALUE_TRUE;
		taskList.add(taskRec);
	}
			}
			if(!taskList.isEmpty()) {
	Database.update(taskList);
			}
			GlobalConstants.DeleteOpenTaskFlag = True;
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.DELETE_OPEN_TASK);
		}
	}

	/*****************************
*Method Name: removeG3Facilitator
*Description: this method work for removing G3 Facilitator at roll back oppty.
*Support Ticket:11982
*Parameters: Opportunity List, Opportunity Map
*******************************/
	public void removeG3Facilitator(List<Opportunity> opptyList, Map<ID, Opportunity> opptyOldMap) {
		for(Opportunity currentOppty:opptyList) {
			if(currentOppty.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY || (currentOppty.StageName == GlobalConstants.DEVELOP_OPPORTUNITY &&  opptyOldMap.get(currentOppty.Id).StageName != GlobalConstants.DEVELOP_OPPORTUNITY)) {
	currentOppty.NF_Facilitator_Notified__c = false;
	currentOppty.NF_Facilitator_User__c = null;
	currentOppty.Facilitator_Delegate_1__c = null;
	currentOppty.Facilitator_Delegate_2__c = null;
	currentOppty.Facilitator_Delegate_3__c = null;
	currentOppty.Queue_Id__c = null;
			}
		}
	}

	/*****************************
*Method Name: updateMultiBG
*Description: update the isMultiBg field on opportunity.
*Parameters: Opportunity List
*******************************/
	public void updateMultiBG(List<Opportunity> opptyList)
	{
		for(Opportunity opp: opptyList)
		{
			opp.isMultiBG__c = checkMultiBG(opp);
		}
	}

	private Boolean checkMultiBG(Opportunity opp)
	{
		Boolean isMultiBG = false;
		if(opp.Supporting_BGs_BUs__c != '' && opp.Supporting_BGs_BUs__c != null)
		{
			List<String> supporingBGsBUsList = opp.Supporting_BGs_BUs__c.split(';');
			for(String suppBgBuVal : supporingBGsBUsList)
			{
	if(!opp.Lead_BG__c.equals(suppBgBuVal.split(' - ')[0]))
	{
		isMultiBG = true;
		break;
	}
			}
		}
		return isMultiBG;
	}

	/*****************************
*Description: This method will make G4 Planned Date mandatory after G3 Facilitator notification and selection of G3 Bypass.
*Parameters:Opportunity List, Opportunity Map
*Requirement : 4879
*******************************/
	public void g4PlannedDateMandatory( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.G4_Planned_Date__c != opptyOldMap.get(opptyObj.id).G4_Planned_Date__c && opptyObj.G4_Planned_Date__c == null) {
		opptyMap.put(opptyObj.Id, opptyObj);
	}
	if(opptyOldMap.get(opptyObj.id).Gate_3_Bypass_no_offer_support__c == true && opptyObj.Gate_3_Bypass_no_offer_support__c == false) {
		opptyObj.No_Offer_Support_Decision_Maker__c = null;
	}
	if(opptyOldMap.get(opptyObj.id).Gate_3_Bypass_no_offer_support__c == false && opptyObj.Gate_3_Bypass_no_offer_support__c == true) {
		opptyObj.No_Offer_Support_Decision_Maker__c = UserInfo.getName();
	}
	/*if(opptyOldMap.get(opptyObj.id).Gate_6_Bypass_No_Execute_needed__c == false && opptyObj.Gate_6_Bypass_No_Execute_needed__c == true) {
opptyObj.No_execute_Decision_maker__c = UserInfo.getName();
}
if(opptyOldMap.get(opptyObj.id).Gate_6_Bypass_No_Execute_needed__c == true && opptyObj.Gate_6_Bypass_No_Execute_needed__c == false) {
opptyObj.No_execute_Decision_maker__c = null;
}*/
			}
			if(!opptyMap.isEmpty()) {
	for(Opportunity opptyObj: opptyMap.values()) {
		if(opptyObj.NF_Facilitator_Notified__c || opptyObj.Gate_3_Bypass_no_offer_support__c) {
			opptyObj.addError(System.label.G4_Planned_Date_Mandatory);
		}
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.G4_Planned_Date_Mandatory);
		}
	}

	/*****************************
*Method Name: resetG3BypassFlag
*Description: This method will prevent currentloggeduser with Role CO Sales Operations Market Head, closing committed upsell opty
*Requirement: 4999
*Parameters: opportunityNewMap, opportunityOldMap
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void resetG3BypassFlag( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if(opptyOldMap.get(opptyObj.id).StageName != opptyObj.StageName && (opptyOldMap.get(opptyObj.id).StageName != GlobalConstants.DEVELOP_OPPORTUNITY && opptyOldMap.get(opptyObj.id).StageName != GlobalConstants.IDENTIFY_OPPORTUNITY) && (opptyObj.StageName == GlobalConstants.DEVELOP_OPPORTUNITY || opptyObj.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY)){
		opptyObj.Gate_3_Bypass_no_offer_support__c = false;
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.EXPECTED_LOA_LEVEL_G3_BYPASS);
		}
	}

	/*****************************
*Method Name: updateG2BypassFlag
*Description: This method will update the Gate_2_Bypass_no_complex_offer__c when criteria is met at UPDATE
*Requirement: ft-299
*******************************/
	public void updateG2BypassFlag( List<Opportunity> optyList, Map<ID, Opportunity> opptyOldMap)
	{
		try {
			Map<ID, Opportunity> opptyNewMap = new map<Id, Opportunity>(optyList);
			for (Opportunity opptyObj: opptyNewMap.values())
			{
	if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsignorecase(opptyObj.StageName))
	{
		if((String.isBlank(opptyObj.No_Complex_Offer_Decision_Maker__c)) &&
		(opptyOldMap.get(opptyObj.id).Gate_2_Bypass_no_complex_offer__c == opptyObj.Gate_2_Bypass_no_complex_offer__c) &&
		(opptyOldMap.get(opptyObj.id).Unweighted_Amount_EUR__c != opptyObj.Unweighted_Amount_EUR__c || opptyOldMap.get(opptyObj.id).isMultiBG__c != opptyObj.isMultiBG__c || opptyOldMap.get(opptyObj.id).CLM_Contract_Request_Type__c != opptyObj.CLM_Contract_Request_Type__c) )
		{
			if(opptyObj.Unweighted_Amount_EUR__c > GlobalConstants.MINUNWEIGHTEDVALUE_G2APPROVAL && opptyObj.isMultiBG__c && opptyObj.CLM_Contract_Request_Type__c != GlobalConstants.RENEWAL_OF_CONTACT)
			{
				opptyObj.Gate_2_Bypass_no_complex_offer__c = false;
			}
			else
			{
				opptyObj.Gate_2_Bypass_no_complex_offer__c = true;
			}
			GlobalConstants.SKIP_NO_COMPLEX_OFFER_DM_ASSIGNMENT = true;
		}
		else if( (opptyOldMap.get(opptyObj.id).Gate_2_Bypass_no_complex_offer__c != opptyObj.Gate_2_Bypass_no_complex_offer__c) &&
				(!GlobalConstants.SKIP_NO_COMPLEX_OFFER_DM_ASSIGNMENT) )
		{
			opptyObj.No_Complex_Offer_Decision_Maker__c = System.UserInfo.getName();
		}
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, ex.getMessage());
		}
	}

	/*****************************
*Method Name: setG2BypassFlag
*Description: This method will update the Gate_2_Bypass_no_complex_offer__c when criteria is met at INSERT
*Requirement: ft-299
*******************************/
	public void setG2BypassFlag(List<Opportunity> optyList)
	{
		for (Opportunity opptyObj: optyList)
		{
			if(opptyObj.Gate_2_Bypass_no_complex_offer__c == false)
			{
	if(opptyObj.Unweighted_Amount_EUR__c > GlobalConstants.MINUNWEIGHTEDVALUE_G2APPROVAL && opptyObj.isMultiBG__c && opptyObj.CLM_Contract_Request_Type__c != GlobalConstants.RENEWAL_OF_CONTACT)
	{
		opptyObj.Gate_2_Bypass_no_complex_offer__c = false;
	}
	else
	{
		opptyObj.Gate_2_Bypass_no_complex_offer__c = true;
	}
			}
			else
			{
	opptyObj.No_Complex_Offer_Decision_Maker__c = System.UserInfo.getName();
			}
		}
	}

	/*****************************
*Method Name: checkG2G6Approval
*Description: This method will check if G2 or G6 was approved to fill out the approver name
*Parameters: opportunityNewMap, opportunitiesoldMap
*******************************/
	public void checkG2G6Approval(Map<Id, Opportunity> opportunitiesNewMap, Map<Id, Opportunity> opportunitiesoldMap ) {

		String approver = null;
		Set<id> opptyid = new Set<id>();
		for (Opportunity newOpportunity : opportunitiesNewMap.values()) {
			for(Opportunity oldOpportunity : opportunitiesoldMap.values()) {
	if(newOpportunity.id.equals(oldOpportunity.id) && oldOpportunity.Phase_Status__c <> null && GlobalConstants.SUBMITTED_FOR_G2_APPROVAL.equalsIgnoreCase(oldOpportunity.Phase_Status__c) && GlobalConstants.DEVELOP_OPPORTUNITY.equalsIgnoreCase(newOpportunity.StageName)) {
		opptyid.add(newOpportunity.id);
		approver = 'g2';
	}
			}
		}
		if(!opptyid.isEmpty() && !GlobalConstants.RUNFLAG && !System.isFuture()) {
			fillGateApprovers(opptyid, approver);
			opptyid.clear();
			GlobalConstants.RUNFLAG = true;
		}
	}

	@future
	public static void fillGateApprovers(Set<Id> opptyIds, string approver)
	{
		try	{
			List<Opportunity> updateList = new List<Opportunity>();
			List<Opportunity> listOpportunity = [select id, G2_Approver__c, G6_Approver__c from Opportunity where id in :opptyIds];
			for(apttus_approval__approval_Request__c apttus : [select id, Apttus_Approval__ActualApproverName__c, Apttus_Approval__Related_Opportunity__c  from apttus_approval__approval_Request__c where Apttus_Approval__Related_Opportunity__c in:opptyIds]) {
	for(Opportunity oppty : listOpportunity) {
		if(oppty.id.equals(apttus.Apttus_Approval__Related_Opportunity__c) && apttus.Apttus_Approval__ActualApproverName__c <> null) {
			if(approver.equalsIgnoreCase('g2')) {
				oppty.G2_Approver__c = apttus.Apttus_Approval__ActualApproverName__c;
			}
			updateList.add(oppty);
		}
	}
			}
			if(!updateList.isEmpty()) {
	Database.update(updateList);
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, 'fillGateApprovers');
		}
	}

	public void rollBackFieldsApprovers( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	Opportunity oldOppty = opptyOldMap.get(opptyObj.id);
	if(!( opptyObj.StageName != oldOppty.StageName ||(oldOppty.Phase_status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION && opptyObj.Phase_status__c == GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL)))
		continue;

	if(oldOppty.StageName == 'Execute (Start Delivery)' && opptyObj.stageName != 'Completed') {
		opptyObj.G6_Approver__c = null;

		/*rollback G5 trigger / Comments for G5 preparation / G5 Approver / G6 Approver*/
	} if(((oldOppty.StageName == 'Win the Case (Negotiate)' && oldOppty.Phase_status__c == 'Pending Win/Loss Declaration') || oldOppty.StageName == 'Handover (Prepare for Delivery)')
		 && opptyObj.stageName != 'Handover (Prepare for Delivery)' && opptyObj.stageName != 'Execute (Start Delivery)' && opptyObj.stageName != 'Completed') {
			 opptyObj.G5_Trigger__c = null;
			 opptyObj.G5_Approver__c = null;
			 opptyObj.G6_Approver__c = null;
			 /*rollback G4 approver*/
		 }if((oldOppty.stageName != 'Create Offer (Bid)' && oldOppty.stageName != 'Develop Opportunity' && oldOppty.stageName != 'Identify Opportunity')
			 && (opptyObj.stageName == 'Create Offer (Bid)' || opptyObj.stageName == 'Develop Opportunity' || opptyObj.stageName == 'Identify Opportunity')) {
		opptyObj.G4_Approver__c = null;
		opptyObj.G5_Trigger__c = null;
			 }
	/*rollback G3 approver*/
	if(oldOppty.stageName != 'Develop Opportunity' && oldOppty.stageName != 'Identify Opportunity' && (opptyObj.stageName == 'Develop Opportunity' || opptyObj.stageName == 'Identify Opportunity')) {
		opptyObj.G3_Approver__c = null;
	}
	/*rollback G2 approver*/
	if(oldOppty.stageName != 'Identify Opportunity' && opptyObj.stageName == 'Identify Opportunity') {
		opptyObj.G2_Approver__c = null;
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, 'rollBackFieldsApprovers');
		}
	}

	/*****************************
*Method Name: committedUpsellOptyClosureValidation
*Description: This method will prevent currentloggeduser with Role CO Sales Operations Market Head, closing committed upsell opty
*Requirement: 4999
*Parameters: opportunityNewMap, opportunityOldMap
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void committedUpsellOptyClosureValidation(List<Opportunity> optyList, Map<Id, Opportunity> opportunityOldMap) {
		Map<Id, Opportunity> opportunityAddErrorMap = new Map<Id, Opportunity>();
		List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
		try {
			for(Opportunity opty : optyList)	{
	if(opty.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && opportunityOldMap.get(opty.id).Phase_Status__c != opty.Phase_Status__c  && opty.Phase_Status__c == GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON) {
		opportunityAddErrorMap.put(opty.Id, opty);
	}
			}

			if(!opportunityAddErrorMap.isEmpty()) {
	salesRoleList = [SELECT id, Role_Code__c, Role_Name__c, User__c FROM Sales_Role__c WHERE User__c = :UserInfo.getUserId() AND (Role_Name__c like:GlobalConstants.WILDCARD_SEARCH + Label.CO_Sales_Operations_Market_Head AND Active__c = :GlobalConstants.VALUE_TRUE) LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	if(salesRoleList.isEmpty()) {
		for(Opportunity optyToShowError : opportunityAddErrorMap.values()) {
			optyToShowError.addError(Label.AvoidClosingCommitedUpsellByCoSalesOpMarketHead);
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.AVOIDCLOSINGCOMMITTEDUPSELLBYCOSALESOPMARKETHEAD);
		}
	}

	/*****************************
*Method Name: updateUnweightedValueofOpptyGroup
*Description: This method will update unweighted value of its related deal opportunity grouping objects.
*Parameters:Opportunity List, Opportunity Map
*Requirement : 4943
*******************************/
	public void updateUnweightedValueofOpptyGroup( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		set<Id> opptyIdSet = new set<Id>();
		List<Opportunity_Group__c> opptyGroupList = new List<Opportunity_Group__c>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Unweighted_Amount_EUR__c != opptyOldMap.get(opptyObj.id).Unweighted_Amount_EUR__c) {
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(opptyIdSet.size() > 0) {
	List<Opportunity_Group__c> opptyGroupObjList = [SELECT id, Opportunity__c, Unweighted_Value_in_EUR__c FROM Opportunity_Group__c WHERE Opportunity__c IN: opptyIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for(Opportunity_Group__c opptyGroupObj:opptyGroupObjList) {
		opptyGroupObj.Unweighted_Value_in_EUR__c = opptyNewMap.get(opptyGroupObj.Opportunity__c).Unweighted_Amount_EUR__c;
		opptyGroupList.add(opptyGroupObj);
	}
			}
			if(!opptyGroupList.isEmpty())
	database.update(opptyGroupList);
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.updateUnweightedValueofOpptyGroup);
		}
	}

	/*****************************
*Method Name: associateUpsellOpptyWithUpsellDeal
*Description: This method will check if upsell oppty is related with upsell deal.
*Parameters:Opportunity List, Opportunity Map
*Requirement : 5151
*******************************/
	public void associateUpsellOpptyWithUpsellDeal( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
	{
		Set<Id> opptyIdSet = new Set<Id>();
		Set<Id> opptyIdHavingUpsellDealsSet = new Set<Id>();
		Set<Id> opptyIdNotHavingUpsellDealSet = new Set<Id>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && opptyOldMap.get(opptyObj.id).Business_Type__c != GlobalConstants.STANDARDOPPORTUNITY && opptyOldMap.get(opptyObj.id).HighestOfferNumber__c == opptyObj.HighestOfferNumber__c) {
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(opptyIdSet.size() > 0) {
	List<Opportunity_Group__c> opptyGroupObjList = [SELECT id, Opportunity__c, Deal__r.RecordType.Name FROM Opportunity_Group__c WHERE Opportunity__c IN: opptyIdSet and Deal__r.RecordType.Name = :GlobalConstants.UPSELL_DEAL LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for(Opportunity_Group__c opptyGroupObj:opptyGroupObjList) {
		opptyIdHavingUpsellDealsSet.add(opptyGroupObj.Opportunity__c);
	}

	for(Id opptyId: opptyIdSet) {
		if(!opptyIdHavingUpsellDealsSet.contains(opptyId))
			opptyIdNotHavingUpsellDealSet.add(opptyId);
	}
	if(opptyIdNotHavingUpsellDealSet.size() > 0)   {
		for(Id opptyId : opptyIdNotHavingUpsellDealSet)
			opptyNewMap.get(opptyId).addError(System.Label.AssociateUpsellDealToUpsellOppty_Error);
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.associateUpsellOpptyWithUpsellDeal);
		}
	}

	/*****************************
*Method Name: updateProbabilityOfPSROAsSalesOptyAfterUpdate
*Description: This method will update probability of 'Sales opty' on 'PSRO' opty exlculding 'closed', 'cancelled' psro opty
*Requirement: 5072
*Parameters: opportunityNewMap, opportunityOldMap
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void updateProbabilityOfPSROAsSalesOptyAfterUpdate(Map<Id, Opportunity> optyNewMap, Map<Id, Opportunity> optyOldMap) {
		Set<Id> salesOptyIdsSet = new Set<Id>();
		try {
			for(Opportunity opp: optyNewMap.values()) {
	if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) && opp.Probability != optyOldMap.get(opp.Id).Probability) {
		salesOptyIdsSet.add(opp.Id);
	}
			}
			if(!salesOptyIdsSet.isEmpty()) {
	//call future method
	updateProbabilityOfPSROInFuture(salesOptyIdsSet);
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEPROBABILITYOFPSROASSALESOPTYAFTERUPDATE);
		}
	}

	/*****************************
*Method Name: validateSubstituteOptyWithSameUpsellDeal
*Description: This method will check, Committed upsell opportunities deal is same as Substitute opportunityies deal of type upsell deal
*Parameters:Opportunity List, Opportunity Map
*Requirement : 5001
*******************************/
	public void validateSubstituteOptyWithSameUpsellDeal( List<Opportunity> opptyList, Map<ID, Opportunity> opptyOldMap)
	{
		Map<Id, Id> salesOpIdAndSubstituteOpIdMap = new Map<Id, Id>();
		Map<Id, Id> salesOpIdAndDealIdMap = new Map<Id, Id>();
		Map<Id, Id> substituteOpIdAndDealIdMap = new Map<Id, Id>();

		try {
			for (Opportunity opptyObj: opptyList) {
	if((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && (opptyObj.Substitute_Opportunity__c != null && opptyObj.Substitute_Opportunity__c != opptyOldMap.get(opptyObj.Id).Substitute_Opportunity__c)) {
		salesOpIdAndSubstituteOpIdMap.put(opptyObj.Id, opptyObj.Substitute_Opportunity__c);
	}
			}
			if(!salesOpIdAndSubstituteOpIdMap.isEmpty())
			{
	for(Opportunity_Group__c opptyGroupObj: [SELECT id, Opportunity__c, Deal__r.RecordType.Name
					 FROM Opportunity_Group__c
					 WHERE Opportunity__c IN: salesOpIdAndSubstituteOpIdMap.keySet()
					 AND Deal__r.RecordType.Name = :GlobalConstants.UPSELL_DEAL
					 AND Opportunity_Relation__c = :GlobalConstants.SUBORDINATE
					 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())
					]) {
						if(opptyGroupObj.Deal__c != null)
				salesOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, opptyGroupObj.Deal__c);
						else
				salesOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, null);
					}
	for(Opportunity_Group__c opptyGroupObj: [SELECT id, Opportunity__c, Deal__r.RecordType.Name
					 FROM Opportunity_Group__c
					 WHERE Opportunity__c IN: salesOpIdAndSubstituteOpIdMap.values()
					 AND Deal__r.RecordType.Name = :GlobalConstants.UPSELL_DEAL
					 AND Opportunity_Relation__c = :GlobalConstants.SUBORDINATE
					 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
				if(opptyGroupObj.Deal__c != null)
				 substituteOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, opptyGroupObj.Deal__c);
				else
				 substituteOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, null);
					 }

	for( Opportunity opp : opptyList) {
		if(salesOpIdAndDealIdMap.containsKey(opp.Id) && substituteOpIdAndDealIdMap.containsKey(salesOpIdAndSubstituteOpIdMap.get(opp.Id))) {
			//get deal
			if(salesOpIdAndDealIdMap.get(opp.Id) != substituteOpIdAndDealIdMap.get(salesOpIdAndSubstituteOpIdMap.get(opp.Id))) {
				opp.addError(Label.UpsellOpportunityDealErrorMessage);
			}
		} else if(salesOpIdAndDealIdMap.containsKey(opp.Id) && substituteOpIdAndDealIdMap.isEmpty()) {
			opp.addError(Label.UpsellOpportunityDealErrorMessage);
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.VALIDATESUBSTITUTEOPTYWITHSAMEUPSELLDEAL);
		}
	}

	/*****************************
*Method Name: restrictOpptyTypeChange
*Description: This method will check if oppty is associated as master oppty on changing opportunity type FROM standard to committed upsell.
*Parameters:Opportunity List, Opportunity Map
*Requirement : 5150
******************************
public void restrictOpptyTypeChange( Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> opptyOldMap)
{
Set<Id> opptyIdSet = new Set<Id>();
Set<Id> masterOpptyIdSet = new Set<Id>();
try {
for (Opportunity opptyObj: opptyNewMap.values()) {
if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && opptyOldMap.get(opptyObj.id).Business_Type__c == GlobalConstants.STANDARDOPPORTUNITY) {
opptyIdSet.add(opptyObj.id);
}
}
if(opptyIdSet.size() > 0) {
List<Opportunity_Group__c> opptyGroupObjList = [SELECT id, Opportunity__c, Opportunity_Relation__c FROM Opportunity_Group__c WHERE Opportunity__c IN: opptyIdSet and Opportunity_Relation__c = :GlobalConstants.MASTER LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
for(Opportunity_Group__c opptyGroupObj:opptyGroupObjList) {
masterOpptyIdSet.add(opptyGroupObj.Opportunity__c);
}
if(masterOpptyIdSet.size() > 0) {
for(Id opptyId: masterOpptyIdSet) {
opptyNewMap.get(opptyId).addError(System.label.ErrorOnChangingOpptyType);
}
}
}
}
catch (Exception ex) {
ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.restrictOpptyTypeChange);
}
}*/

	/*****************************
*Method Name: ClosedOpptyStatustoTeam
*Description:  Chatter Post to Oppty and Offer Team members to inform about to Opportunity Closed Status info
Req:5077 - chatter post on oppty close(positive and negative)
*Parameters: opportunitiesMap
*******************************/
	public void OpportunityClosure(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap) {
		Set<Id> chatterOpptyInfo = new Set<Id>();
		try{
			for(Opportunity opptyData:newMap.values()) {
	if(opptyData.StageName != Null && opptyData.StageName != oldMap.get(opptyData.id).StageName &&
	   (opptyData.StageName.equalsignorecase(GlobalConstants.COMPLETED_OPPTY) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.CANCELLED_BY_CUSTOMER) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.LOST_TO_COMPETITOR) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.WITH_DRAW_BY_NOKIA) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.OBSOLETE)) &&
	   (opptyData.RecordTypeId == directRecordTypeId || opptyData.RecordTypeId == inDirectRecordTypeId ||
		opptyData.RecordTypeId == readOnlyDirectRecordTypeId || opptyData.RecordTypeId == readOnlyIndirectRecordTypeId)) {
			chatterOpptyInfo.add(opptyData.ID);
		}
			}
			if(!ChatterOpptyinfo.isEmpty()) {
	OpportunityTriggerHelper.ClosedOpptyStatustoTeam(ChatterOpptyinfo);
	GlobalConstants.OPPORTUNITY_CLOSE_CHECK = True;
	OpportunityTriggerHandler.flagForChatter = True;
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CLOSED_OPPTY_POST);
		}
	}

	/*****************************
*Method Name: opportunityTypeChangeRestriction
*Description: This method will prevent currentloggeduser with Role other than CO Sales Operations Market Head,
changing opportunity type after Identify stage.
*Requirement: 5003
*Parameters: opportunityNewMap, opportunityOldMap
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public void opportunityTypeChangeRestriction(List<Opportunity> optyList, Map<Id, Opportunity> opportunityOldMap) {
		Boolean notAllowed = ([SELECT Id FROM Sales_Role__c WHERE User__c = :UserInfo.getUserId() AND (Role_Name__c like:GlobalConstants.WILDCARD_SEARCH + Label.CO_Sales_Operations_Market_Head AND Active__c = :GlobalConstants.VALUE_TRUE) LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]).isEmpty();
		List<String> lockedPhases = new List<String>{GlobalConstants.COMPLETED_OPPTY, GlobalConstants.CANCELLED_BY_CUSTOMER, GlobalConstants.LOST_TO_COMPETITOR, GlobalConstants.WITH_DRAW_BY_NOKIA, GlobalConstants.OBSOLETE, GlobalConstants.SUBMITTED_FOR_G2_APPROVAL,GlobalConstants.SUBMITTED_FOR_G3_APPROVAL , GlobalConstants.SUBMITTED_FOR_G4_APPROVAL, GlobalConstants.SUBMITTED_FOR_G5_APPROVAL, GlobalConstants.SUBMITTED_FOR_G6_APPROVAL   };
			try {
	for(Opportunity opty : optyList){
		if(opty.Business_Type__c != opportunityOldMap.get(opty.id).Business_Type__c &&
		(opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId || opty.RecordTypeId == readOnlyDirectRecordTypeId || opty.RecordTypeId == readOnlyIndirectRecordTypeId) ){
		 if ( lockedPhases.contains(opty.StageName) || lockedPhases.contains(opty.Phase_Status__c) ) {
		  opty.addError('Business_Type__c',System.Label.OpptyTypeChnage_whenOpptyLockedclosed);
		 } else if( !GlobalConstants.BYPASS_OPPTYPECHANGE && (opty.Business_Type__c == GlobalConstants.FAST_TRACK_OPP_TYPE || opportunityOldMap.get(opty.id).Business_Type__c == GlobalConstants.FAST_TRACK_OPP_TYPE) ){
		  opty.addError('Business_Type__c',GlobalConstants.FASTTRACKTYPE_CANNOTCHANGE);
		 } else if( notAllowed &&  opty.StageName != GlobalConstants.IDENTIFY_OPPORTUNITY  && !(opty.Business_Type__c == GlobalConstants.FAST_TRACK_OPP_TYPE || opportunityOldMap.get(opty.id).Business_Type__c == GlobalConstants.FAST_TRACK_OPP_TYPE)) {
		  opty.addError('Business_Type__c',System.Label.Opportunity_Type_Change);
		 }
		}
	}
			} catch (Exception ex) {
	ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
			}
	}

	/*****************************
*Method Name: upsellDeltaDifference
*Description: calculate Committed Upsell Deviation
*Parameters: List<Opportunity>, Map<ID, Opportunity>
*Requirement : 5107
*******************************/
	public void upsellDeltaDifference(List<Opportunity> lstOppty, Map<ID, Opportunity> opptyOldMap)
	{
		try {
			for(opportunity objOppty : lstOppty) {
	if(objOppty.Business_Type__c == Globalconstants.COMMITTED_UPSELL && objOppty.Unweighted_Amount_EUR__c != opptyOldMap.get(objOppty.id).Unweighted_Amount_EUR__c && objOppty.Committed_Unweighted_Value_in_EUR__c != 0) {
		objOppty.Upsell_Delta__c = objOppty.Unweighted_Amount_EUR__c - objOppty.Committed_Unweighted_Value_in_EUR__c;
		if( ( string.isBlank(objOppty.Upsell_Change_Explanation__c) && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id) )
		&& ( (objOppty.Lead_BG__c == Globalconstants.LEAD_BG_MN  && objOppty.Upsell_Delta__c <= integer.valueof(Label.Lead_MN_UpsellDeltaValue))
		 || (objOppty.Lead_BG__c == Globalconstants.LEAD_BG_NI || objOppty.Lead_BG__c == Globalconstants.LEAD_BG_CNS) && objOppty.Upsell_Delta__c <= integer.valueof(Label.Lead_NI_CNS_UpsellDeltaValue) ) )
		{
			objOppty.adderror(Label.UpsellDelta_ErrorMsg);
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
*Method Name: committedUnweightedValue
*Description: calculate Committed Unweighted Value of Upsell Opportunity
*Parameters: List<Opportunity>, Map<ID, Opportunity>
*Requirement : 5114
*******************************/
	public void committedUnweightedValue(List<Opportunity> lstOppty, Map<ID, Opportunity> opptyOldMap)
	{
		set<id> setOpptyId = new set<id>();
		set<id> setDealId = new set<id>();
		set<id> setCommittedOppty = new set<id>();
		list<opportunity> lstUpsellOppty = new list<opportunity>();
		list<opportunity> lstUpsellOpptyToUpdate = new list<opportunity>();
		string strStageName = GlobalConstants.OPPTYSALESPHASE;
		try
		{
			for(opportunity objOppty : lstOppty)
			{
	if(objOppty.Phase_Status__c != opptyOldMap.get(objOppty.id).Phase_Status__c && (objOppty.Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION || objOppty.Phase_Status__c == GlobalConstants.OFFERSUBMITTEDTOCUSTOMER))
	{
		setOpptyId.add(objOppty.id);
	}
			}

			if(setOpptyId.size() > 0)
			{
	List<Opportunity_Group__c> objDealGrouplist = [SELECT id, Opportunity__c, Deal__c
				  FROM Opportunity_Group__c
				  WHERE Opportunity__c in : setOpptyId
				  AND Opportunity_Relation__c = :globalconstants.MASTER ];

	for(Opportunity_Group__c objDealGroup : objDealGrouplist) {
		setDealId.add(objDealGroup.Deal__c);
	}

	if(setDealId.size() > 0)
	{
		for(Opportunity_Group__c objDealGroup : [SELECT id, Opportunity__c, Deal__c
				FROM Opportunity_Group__c
				WHERE Deal__c in : setDealId
				AND Opportunity_Relation__c = :globalconstants.SUBORDINATE ]) {
				 setCommittedOppty.add(objDealGroup.Opportunity__c);
				}

		if(setCommittedOppty.size() > 0)
		{
			lstUpsellOpptyToUpdate = getCommittedUpsellOpptyList(setCommittedOppty);
			for(opportunity objUpsellOptty : lstUpsellOpptyToUpdate)
			{
				if(objUpsellOptty.Is_Auto_Upsell__c == false)
				{
		objUpsellOptty.Committed_Unweighted_Value_in_EUR__c = calculateTotalSalesYear(objUpsellOptty.Opportunity_ID__c);
		objUpsellOptty.Upsell_Delta__c = 0;
		lstUpsellOppty.add(objUpsellOptty);
				}
			}
		}
	}
			}
			update lstUpsellOppty;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
*Method Name: calculateTotalSalesYear
*Description: To get the comitted Upsell Opportunity
*Parameters: list<opportunity>
*Requirement : 5008
*******************************/
	public decimal calculateTotalSalesYear(string strOpptyNumber)
	{
		decimal dTotalSales = 0.0;
		list<Upsell_Container__c> lstUpsellContainer = new List<Upsell_Container__c>();
		lstUpsellContainer.clear();

		//---------------------------------------- NEW CODE -----------------------------------------------------
		List<string> lstTemplates = new List<String> {Globalconstants.TEMPLATEIDENTIFIER_G4, Globalconstants.TEMPLATEIDENTIFIER_G5};
			list<Upsell_Container__c> lstUpsell_G45 = [SELECT Upsell_Opportunity_Number__c, Template_Identifier__c, Total_Year_Sales__c, Quarter1_Period_Value__c,
				Quarter2_Period_Value__c, Quarter3_Period_Value__c, Quarter4_Period_Value__c
				FROM Upsell_Container__c
				WHERE Template_Identifier__c IN :lstTemplates
				AND Upsell_Opportunity_Number__c = :strOpptyNumber];
		for(Upsell_Container__c UC:lstUpsell_G45)
		{
			if(UC.Template_Identifier__c == Globalconstants.TEMPLATEIDENTIFIER_G5) {
	lstUpsellContainer.addAll(lstUpsell_G45);
	break;
			}
			if(UC.Template_Identifier__c == Globalconstants.TEMPLATEIDENTIFIER_G4) {
	lstUpsellContainer.addAll(lstUpsell_G45);
	break;
			}
		}
		//---------------------------------------- END NEW CODE -------------------------------------------------

		try {
			if(lstUpsellContainer.size() > 0) {
	for(Upsell_Container__c objUpsell : lstUpsellContainer) {
		if(String.valueOf(objUpsell.Upsell_Opportunity_Number__c.escapeUnicode()).replace(GlobalConstants.SPECIAL_CHARACTER, GlobalConstants.BLANK_VALUE).Equals(String.valueOf(strOpptyNumber.escapeUnicode()).replace(GlobalConstants.SPECIAL_CHARACTER, GlobalConstants.BLANK_VALUE))) {
			dTotalSales = dTotalSales + objUpsell.Total_Year_Sales__c;
		}
	}
	return dTotalSales.setScale(2);
			}
			return 0.0;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
			return null;
		}
	}

	/*****************************
*Method Name: getCommittedUpsellOpptyList
*Description: To get the comitted Upsell Opportunity
*Parameters: set<id>
*Requirement : 5008
*******************************/
	public list<Opportunity> getCommittedUpsellOpptyList(set<id> setCommittedOppty)
	{
		try {
			list<opportunity> lstUpsellOppty = [SELECT id, Is_Auto_Upsell__c, Opportunity_ID__c, Unweighted_Amount_EUR__c, Committed_Unweighted_Value_in_EUR__c FROM opportunity WHERE id in :setCommittedOppty ];
			return lstUpsellOppty;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
			return null;
		}
	}

	/*****************************
*Method Name: upsellDeltaDifference
*Description: Restrict sign-off of Committed Upsell changes
*Parameters: List<Opportunity>, Map<ID, Opportunity>
*Requirement : 5008
*******************************/
	public void upsellChangeAccepted(List<Opportunity> lstOppty, Map<ID, Opportunity> opptyOldMap)
	{
		set<string> setRoleName = new set<string>();
		Map<String, Set<String>> mapLeadSalesRole = new Map<String, Set<String>>();
		List<Opportunity> lstNewOppty = new list<opportunity>();
		try {
			for(opportunity oOppty : lstOppty) {
	if(oOppty.Upsell_Change_Accepted__c == true && opptyOldMap.get(oOppty.id).Upsell_Change_Accepted__c != oOppty.Upsell_Change_Accepted__c) {
		lstNewOppty.add(oOppty);
	}else if(oOppty.Upsell_Change_Accepted__c == false && opptyOldMap.get(oOppty.id).Upsell_Change_Accepted__c != oOppty.Upsell_Change_Accepted__c) {
		lstNewOppty.add(oOppty);
	}
			}
			if(lstNewOppty.size() > 0) {
	List<Committed_Upsell_Configuration__mdt> objUpsellConfigList = [SELECT Lead_BG__c, Sales_Role_Code__c FROM Committed_Upsell_Configuration__mdt];
	for(Committed_Upsell_Configuration__mdt objUpsellConfig : objUpsellConfigList) {
		if(mapLeadSalesRole.containsKey(objUpsellConfig.Lead_BG__c)) {
			Set<String> salesRoleVal=mapLeadSalesRole.get(objUpsellConfig.Lead_BG__c);
			salesRoleVal.add(objUpsellConfig.Sales_Role_Code__c);
			mapLeadSalesRole.put(objUpsellConfig.Lead_BG__c,salesRoleVal);
		} else {
			mapLeadSalesRole.put(objUpsellConfig.Lead_BG__c, new Set<String> {objUpsellConfig.Sales_Role_Code__c });
		}
	}

	List<Sales_Role__c> objRoleNameList = [SELECT id, Role_Code__c, Role_Name__c, User__c FROM Sales_Role__c WHERE User__c = :UserInfo.getUserId()];
	for(Sales_Role__c objRoleName : objRoleNameList) {
		list<string> lstStageName = objRoleName.Role_Code__c.split(', ');
		setRoleName.addall(lstStageName);
	}

	string strStageName = GlobalConstants.STAGENAME;
	list<string> lstStageName = strStageName.split(', ');
	Set<String> setStageName = new Set<String>(lstStageName);
	string username = [SELECT name FROM user WHERE id = : UserInfo.getUserId() ].name;
	for(opportunity objOppty : lstNewOppty) {
		if(objOppty.Upsell_Change_Accepted__c == true && opptyOldMap.get(objOppty.id).Upsell_Change_Accepted__c != objOppty.Upsell_Change_Accepted__c) {
			if(!setStageName.contains(objOppty.RecordType.DeveloperName) && !setStageName.contains(objOppty.Phase_Status__c)) {
				if(setRoleName.size() > 0 || (UserInfo.getProfileId().equalsIgnoreCase(system.Label.Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Admin))) {

		Set<String> checkIntersection = new Set<String>(setRoleName);
		checkIntersection.retainAll(mapLeadSalesRole.get(objOppty.Lead_BG__c));

		if((checkIntersection.size()>0) || (UserInfo.getProfileId().equalsIgnoreCase(system.Label.Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Admin))) {
			objOppty.Upsell_Change_Approved_by__c = username + globalconstants.SPACE + globalconstants.COMMA + globalconstants.SPACE + system.Now();
		}else{
			objOppty.addError(label.Upsell_Change_Accepted_Checked);
		}
				} else{
		objOppty.addError(label.Upsell_Change_Accepted_Checked);
				}
			}else
				objOppty.addError(GlobalConstants.ERROR_MESSAGE_OPPTY);
		}else if(objOppty.Upsell_Change_Accepted__c == false && opptyOldMap.get(objOppty.id).Upsell_Change_Accepted__c != objOppty.Upsell_Change_Accepted__c) {
			if(!setStageName.contains(objOppty.RecordType.DeveloperName) && !setStageName.contains(objOppty.Phase_Status__c)) {
				if((UserInfo.getProfileId().equalsIgnoreCase(system.Label.Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Admin))) {
		objOppty.Upsell_Change_Approved_by__c = '';
				}
			}else
				objOppty.addError(GlobalConstants.ERROR_MESSAGE_OPPTY);
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
*Method Name: populate_G4ApprovalCycleTimeOnOffer
*Description: This method will populate G4 Approval Cycle Time on offer when opportunity is submitted for g4 approval or g4 approved.
*Parameters:Opportunity List, Opportunity Map
*Requirement : 4422, Req 5470
*******************************/
	public void populate_G4ApprovalCycleTimeOnOffer(Map<ID, Opportunity> opptyMap, Map<ID, Opportunity> opptyOldMap)
	{
		Map<Id, Offer__c> opptyOfferMap = new Map<Id, Offer__c>();
		List<Offer__c> offerList = new List<Offer__c>();
		Set<id> opptyIdSet = new Set<id>();
		try{
			for(Opportunity oppty: opptyMap.values()) {
	if(oppty.TotalOfferCount__c > 0 && ((oppty.G4_Submission_Date__c != null && oppty.G4_Submission_Date__c != opptyOldMap.get(oppty.id).G4_Submission_Date__c) || (oppty.G4_Approval_Date__c != null && oppty.G4_Approval_Date__c != opptyOldMap.get(oppty.id).G4_Approval_Date__c))) {
		opptyIdSet.add(oppty.id);
	}
			}
			if(!opptyIdSet.isEmpty() && opptyIdSet.size() > 0) {
	for(Offer__c offer : [SELECT id, ActiveOffer__c, Opportunity__c, G4_Approval_Cycle_Time__c FROM Offer__c WHERE Opportunity__c IN: opptyIdSet AND ActiveOffer__c = True LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		opptyOfferMap.put(offer.Opportunity__c, offer);
	}
	if(!opptyOfferMap.isEmpty()) {
		for(Id opptyId: opptyOfferMap.keySet()) {
			if(opptyMap.get(opptyId).G4_Submission_Date__c != null) {
				if(opptyMap.get(opptyId).G4_Approval_Date__c != null) {
		if((opptyMap.get(opptyId).G4_Approval_Date__c).date() >= opptyMap.get(opptyId).G4_Submission_Date__c)
			opptyOfferMap.get(opptyId).G4_Approval_Cycle_Time__c = opptyMap.get(opptyId).G4_Submission_Date__c.daysBetween(opptyMap.get(opptyId).G4_Approval_Date__c.date());
				} else  {
		if(System.today() >= opptyMap.get(opptyId).G4_Submission_Date__c) {
			opptyOfferMap.get(opptyId).G4_Approval_Cycle_Time__c = opptyMap.get(opptyId).G4_Submission_Date__c.daysBetween(System.today());
		}
				}
			}
			offerList.add(opptyOfferMap.get(opptyId));
		}
	}
	if(!offerList.isEmpty())
		database.update(offerList);
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.POPULATE_G4APPROVALCYCLETIMEONOFFER);
		}
	}

	/*****************************
*Method Name: createCompetitorWhenOpportunityClosedNegatively
*Description: this method creates competitor when opportunity is closed not won
*Parameters: Opportunity List, Opportunity Map
*Req: 5073
*******************************/
	public void createCompetitorWhenOpportunityClosedNegatively(List<Opportunity> opportunityList, Map<ID, Opportunity> optyOldMap)
	{
		List<Competitor__c> competitorsListOld = new List<Competitor__c>();
		List<Competitor__c> updateList = new List<Competitor__c>();
		Set<String> compSet = new Set<String>();
		Set<String> compSetOld = new Set<String>();
		Set<String> compSetOldFinal = new Set<String>();
		Map<Id, Set<String>> opptyCompMap = new Map<Id, Set<String>>();
		Competitor__c compVar;
		String[] compList = new List<String>();
		Map<String, Competitor__c> updateMap;
		Map<Id, List<Competitor__c>> opptyIdAndCompetitorsMapOld = new Map<Id, List<Competitor__c>>();
		try{
			for (Opportunity opptyObj: opportunityList) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName && opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR && opptyObj.Winning_Competitor__c != GlobalConstants.SALES_EMPTY) {
			compList.clear();
			compList = opptyObj.Winning_Competitor__c.split(GlobalConstants.SEMICOLON);
			compSet.addAll(compList);
			opptyCompMap.put(opptyObj.id, compSet);
		}
			}
			if(!opptyCompMap.isEmpty()) {
	for (Competitor__c compObject: [SELECT id, Opportunity__c, Competitor_New__c, Opportunity_Won__c FROM Competitor__c WHERE Opportunity__c in: opptyCompMap.keyset() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		if(opptyIdAndCompetitorsMapOld.containsKey(compObject.Opportunity__c)) {
			competitorsListOld = opptyIdAndCompetitorsMapOld.get(compObject.Opportunity__c);
			competitorsListOld.add(compObject);
			opptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c, competitorsListOld);
		}  else  {
			competitorsListOld.clear();
			competitorsListOld.add(compObject);
			opptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c, competitorsListOld);
		}
	}
	for(Id oppId : opptyCompMap.keyset()) {
		updateMap = new Map<String, Competitor__c>();
		if(opptyIdAndCompetitorsMapOld.containsKey(oppId)) {
			for(Competitor__c comp : opptyIdAndCompetitorsMapOld.get(oppId)) {
				compSetOld.add(comp.Competitor_New__c);
				updateMap.put(comp.Competitor_New__c, comp);
			}
		}
		for(String str: opptyCompMap.get(oppId)) {
			if(compSetOld.contains(str))
				compSetOldFinal.add(str);
		}
		if(compSetOldFinal.size() > 0) {
			for(String str : compSetOldFinal) {
				if(updateMap.get(str).Opportunity_Won__c != true) {
		updateMap.get(str).Opportunity_Won__c = true;
		updateList.add(updateMap.get(str));
				}
			}
		}
		opptyCompMap.get(oppId).removeAll(compSetOldFinal);
		if(opptyCompMap.get(oppId).size() > 0) {
			for(String str : opptyCompMap.get(oppId)) {
				compVar = new Competitor__c();
				compVar.Competitor_New__c = str;
				compVar.Opportunity__c = oppId;
				compVar.Opportunity_Won__c = true;
				updateList.add(compVar);
			}
		}
	}
			}
			if(!updateList.isEmpty()) {
	Database.upsert(updateList);
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CREATECOMPETITORWHENOPPORTUNITYCLOSEDNEGATIVELY);
		}
	}

	/*****************************
*Method Name: createUnknownCompetitorRecord
*Description: this method creates 'Unknown' competitor when no competitor is selected while opportunity closure
*Parameters: Opportunity List, Opportunity Map
*Req: 5073
*******************************/
	public void createUnknownCompetitorRecord(List<Opportunity> opportunityList, Map<ID, Opportunity> optyOldMap)
	{
		List<Competitor__c> updateList = new List<Competitor__c>();
		Set<Id> opptyIdSet = new Set<Id>();
		Competitor__c compVar;
		Map<Id, Competitor__c> opptyIdAndCompetitorMap = new Map<Id, Competitor__c>();
		try{
			for (Opportunity opptyObj: opportunityList) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName && opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR && opptyObj.Winning_Competitor__c == GlobalConstants.SALES_EMPTY) {
			opptyIdSet.add(opptyObj.id);
		}
			}
			if(opptyIdSet.size() > 0) {
	List<Competitor__c> compObjectList = [SELECT id, Opportunity__c, Competitor_New__c, Opportunity_Won__c FROM Competitor__c WHERE Opportunity__c in: opptyIdSet AND Competitor_New__c = :GlobalConstants.UNKNOWN LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (Competitor__c compObject: compObjectList) {
		opptyIdAndCompetitorMap.put(compObject.Opportunity__c, compObject);
	}
	for(Id oppId : opptyIdSet) {
		if(opptyIdAndCompetitorMap.containsKey(oppId)) {
			opptyIdAndCompetitorMap.get(oppId).Opportunity_Won__c = true;
			updateList.add(opptyIdAndCompetitorMap.get(oppId));
		} else  {
			compVar = new Competitor__c();
			compVar.Competitor_New__c = GlobalConstants.UNKNOWN;
			compVar.Opportunity__c = oppId;
			compVar.Opportunity_Won__c = true;
			updateList.add(compVar);
		}
	}
			}
			if(!updateList.isEmpty()) {
	Database.upsert(updateList);
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CREATEUNKNOWNCOMPETITORRECORD);
		}
	}

	/*****************************
*Method Name: updateWinningCompOnOppty
*Description: this method updates Winning Competitor to 'unknown' when no competitor is selected.
*Parameters: Opportunity Map
*Req: 5073
*******************************/
	public void updateWinningCompOnOppty(Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> optyOldMap)
	{

	}

	/*****************************
*Method Name: insertOwnerInOpptyTeam
*Description: Insert Oppty owner in Oppty Team
*Parameters: List<Opportunity>
*Requirement : 5468
*******************************/
	public void insertOwnerInOpptyTeam(List<Opportunity> opptyList)
	{
		List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
		List<opportunity> opptyListNew = New List<Opportunity>();
		OpportunityTeamMember opptyTeamMemberVar;
		try{
			if(!opptyList.isEmpty()) {
	for(Opportunity opp : opptyList) {
		if(opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) {
			opptyListNew.add(opp);
		}
	}
			}
			if(!opptyListNew.isEmpty()) {
	for(Opportunity opp : opptyListNew) {
		opptyTeamMemberVar = new OpportunityTeamMember();
		opptyTeamMemberVar.OpportunityId = opp.Id;
		opptyTeamMemberVar.UserId = opp.OwnerId;
		opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
		opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
		opptyTeamMemberList.add(opptyTeamMemberVar);
	}
			}
			if(!opptyTeamMemberList.isEmpty()) {
	Database.insert(opptyTeamMemberList, false);
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.INSERT_OWNER_IN_OPPTY_TEAM);
		}
	}

	/*****************************
*Method Name: updateOwnerInOpptyTeam
*Description: Update Oppty owner in Oppty Team
*Parameters: List<Opportunity>, Map<Id, Opportunity>
*Requirement : 5468
*******************************/
	public void updateOwnerInOpptyTeam(List<Opportunity> opptyList, Map<Id, Opportunity> opptyOldMap)
	{
		List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
		List<OpportunityTeamMember> opptyTeamMemberListDelete = new List<OpportunityTeamMember>();
		Map<Id, OpportunityTeamMember> opptyTeamMemberMap = new Map<Id, OpportunityTeamMember>();
		OpportunityTeamMember opptyTeamMemberVar;
		Map<Id, Id> opptyOldOwnerIdSet = new Map<Id, Id>();
		List<opportunity> opptyNewList = new List<Opportunity>();
		try{
			if(!opptyList.isEmpty()) {
	for(Opportunity opp : opptyList) {
		System.debug(opp.RecordTypeId + ' '+ opp.OwnerId + ' '+opptyOldMap.get(opp.Id).OwnerId);
		if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) && opp.OwnerId != opptyOldMap.get(opp.Id).OwnerId)
		{
			opptyOldOwnerIdSet.put(opp.Id, opptyOldMap.get(opp.Id).OwnerId);
			opptyNewList.add(opp);
		}
	}
	if(opptyOldOwnerIdSet.size() > 0) {
		for(OpportunityTeamMember oppTeamMem : [SELECT Id, UserId, OpportunityId, TeamMemberRole, OpportunityAccessLevel, Additional_Team_Role__c FROM OpportunityTeamMember WHERE UserId in : opptyOldOwnerIdSet.values() and OpportunityId in : opptyOldOwnerIdSet.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
			if(oppTeamMem.TeamMemberRole == System.Label.ACC_MANAGER_TRICON_SCO) {
				opptyTeamMemberMap.put(oppTeamMem.OpportunityId, oppTeamMem);
			}
		}
	}
	if(!opptyNewList.isEmpty()) {
		for(Opportunity opp : opptyNewList) {
			if(opptyTeamMemberMap.containsKey(opp.Id)) {
				opptyTeamMemberListDelete.add(opptyTeamMemberMap.get(opp.Id));
				opptyTeamMemberVar = new OpportunityTeamMember();
				opptyTeamMemberVar.OpportunityId = opp.Id;
				opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
				opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
				opptyTeamMemberVar.UserId = opp.OwnerId;
				opptyTeamMemberList.add(opptyTeamMemberVar);
			}else{
				opptyTeamMemberVar = new OpportunityTeamMember();
				opptyTeamMemberVar.OpportunityId = opp.Id;
				opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
				opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
				opptyTeamMemberVar.UserId = opp.OwnerId;
				opptyTeamMemberList.add(opptyTeamMemberVar);
			}
		}
	}
			}
			if(!opptyTeamMemberList.isEmpty()) {
	Database.insert(opptyTeamMemberList, false);
			}
			if(!opptyTeamMemberListDelete.isEmpty()) {
	Database.delete(opptyTeamMemberListDelete);
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATE_OWNER_IN_OPPTY_TEAM);
		}
	}

	/*****************************
*Method Name: insertOwnerInTeamOnReopening
*Description: Insert Oppty owner in Oppty Team
*Parameters: List<Opportunity>
*Requirement : 5468
*******************************/
	public void insertOwnerInTeamOnReopening(List<Opportunity> opptyList, Map<Id, Opportunity> opptyOldMap)
	{
		List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
		List<Opportunity> opptyNewList = new List<Opportunity>();
		Map<Id, Id> opptyOwnerOldMap = new Map<Id, Id>();
		Map<Id, Id> opptyOwnerIdMap = new Map<Id, Id>();
		OpportunityTeamMember opptyTeamMemberVar;
		try{
			for(Opportunity opty : opptyList) {
	if((opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId || opty.RecordTypeId == readOnlyDirectRecordTypeId || opty.RecordTypeId == readOnlyIndirectRecordTypeId) &&
	   ((opty.StageName == Globalconstants.EXECUTE_OPPTY && opptyOldMap.get(opty.Id).StageName == Globalconstants.COMPLETED_OPPTY) ||
		((opptyOldMap.get(opty.Id).StageName == GlobalConstants.CANCELLED_BY_CUSTOMER || opptyOldMap.get(opty.Id).StageName == GlobalConstants.LOST_TO_COMPETITOR  ||
		  opptyOldMap.get(opty.Id).StageName == GlobalConstants.WITH_DRAW_BY_NOKIA || opptyOldMap.get(opty.Id).StageName == GlobalConstants.OBSOLETE)&&
		 (opty.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY || opty.StageName == Globalconstants.DEVELOP_OPPORTUNITY ||
		  opty.StageName == GlobalConstants.CREATE_OFFER || opty.StageName == GlobalConstants.WIN_THE_CASE))))
	{
		opptyNewList.add(opty);
		opptyOwnerIdMap.put(opty.Id, opty.OwnerId);
	}
			}
			if(!opptyNewList.isEmpty()) {
	for(OpportunityTeammember opptyTeamMember : [SELECT Id, UserId, OpportunityId FROM OpportunityTeamMember WHERE UserId in : opptyOwnerIdMap.values() and OpportunityId in : opptyOwnerIdMap.keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ]) {
		opptyOwnerOldMap.put(opptyTeamMember.OpportunityId, opptyTeamMember.UserId);
	}
	for(Opportunity opp : opptyNewList) {
		if(!opptyOwnerOldMap.containsKey(opp.Id)) {
			opptyTeamMemberVar = new OpportunityTeamMember();
			opptyTeamMemberVar.OpportunityId = opp.Id;
			opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
			opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
			opptyTeamMemberVar.UserId = opp.OwnerId;
			opptyTeamMemberList.add(opptyTeamMemberVar);
		}
	}
			}
			if(!opptyTeamMemberList.isEmpty()) {
	Database.insert(opptyTeamMemberList, false);
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.INSERT_OWNER_IN_OPPTY_TEAM_REOPENING);
		}
	}

	/*****************************
*Method Name: updateCustomerOfferDueDate
*Description: this method updates Customer Offer Due Date to 'G4 Planned Date + 2 Days' for the active offers.
*Parameters: Opportunity Map
*Req: 5669
*******************************/
	public void updateCustomerOfferDueDate(Map<ID, Opportunity> opptyNewMap)
	{
		List<Offer__c> offerListToUpdate = new List<Offer__c>();
		Map<Opportunity, Offer__c> g4DateToOffer = new Map<Opportunity, Offer__c>();
		try{
			List<Offer__c> offerInstList = [SELECT id, ActiveOffer__c, Opportunity__r.G4_Planned_Date__c, Customer_Offer_Due_Date__c, Opportunity__r.RecordTypeId, Opportunity__r.StageName, Opportunity__r.Phase_Status__c FROM Offer__c WHERE ActiveOffer__c = :true AND G4_passed__c = false AND Opportunity__c IN: opptyNewMap.keySet()];
			for(Offer__c offerInst : offerInstList) {
	g4DateToOffer.put(opptyNewMap.get(offerInst.Opportunity__c), offerInst);
			}
			if(g4DateToOffer.size() > 0) {
	for (Offer__c objOffer: g4DateToOffer.values()) {
		if ((objOffer.Opportunity__r.RecordTypeId == directRecordTypeId || objOffer.Opportunity__r.RecordTypeId == inDirectRecordTypeId|| objOffer.Opportunity__r.RecordTypeId == readOnlyDirectRecordTypeId || objOffer.Opportunity__r.RecordTypeId == readOnlyIndirectRecordTypeId)
			&& (objOffer.Opportunity__r.StageName == GlobalConstants.CREATE_OFFER || objOffer.Opportunity__r.StageName == GlobalConstants.DEVELOP_OPPORTUNITY || objOffer.Opportunity__r.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY)
			&& objOffer.Opportunity__r.G4_Planned_Date__c != null) {
				objOffer.Customer_Offer_Due_Date__c = objOffer.Opportunity__r.G4_Planned_Date__c + 2;
			}
		offerListToUpdate.add(objOffer);
	}
	database.update(offerListToUpdate, false);
			}
		}
		catch(Exception e) {
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, 'updateCustomerOfferDueDate');
		}
	}

	/*****************************
*Method Name: UpdateOffer
*Description: Update Offer Field
*Parameters: List<Opportunity>, Map<ID, Opportunity>
*Requirement : 5669
*******************************/
	public void UpdateOffer(List<Opportunity> lstOppty, map<Id, Opportunity> opportunitiesoldMap)
	{
		set<id> setOpptyUpdate = new set<id>();
		list<Offer__c> lstOffer = new list<offer__c>();
		try
		{
			for(opportunity objOppUpdate : lstOppty) {
	if(objOppUpdate.StageName != opportunitiesoldMap.get(objOppUpdate.id).StageName &&(objOppUpdate.StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE &&   opportunitiesoldMap.get(objOppUpdate.id).StageName == GlobalConstants.CREATE_OFFER)) {
		setOpptyUpdate.add(objOppUpdate.id);
	}
			}
			if(setOpptyUpdate.size() > 0) {
	List<offer__c> objOfferlist = [SELECT id, ActiveOffer__c, G4_passed__c FROM offer__c WHERE Opportunity__c in :setOpptyUpdate and ActiveOffer__c = true];
	for(offer__c  objOffer : objOfferlist) {
		if(objOffer.G4_passed__c == false) {
			objOffer.G4_passed__c = true;
			lstOffer.add(objOffer);
		}
	}
			}
			if(lstOffer.size() > 0)
	update lstOffer;
		}
		catch(Exception e) {
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, 'UpdateOffer');
		}
	}

	/*****************************
*Method Name: validateWonShareAllocationSum
*Description: this method will check total won share of all winning competitors and show error if sum is greater than 100
*Parameters: Opportunity Map, Opportunity Map
*Req: 5783 Sales Process
*******************************/
	public void validateWonShareAllocationSum(Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> optyOldMap)
	{
		List<Competitor__c> competitorsListOld = new List<Competitor__c>();
		Set<Id> opptyIdSet = new Set<Id>();
		Set<String> allCompetitors;
		String str = '';
		Map<Id, List<Competitor__c>> opptyIdAndCompetitorsMapOld = new Map<Id, List<Competitor__c>>();
		try{
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName && opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR && opptyObj.Winning_Competitor__c != GlobalConstants.SALES_EMPTY) {
			opptyIdSet.add(opptyObj.id);
		}
			}
			if(!opptyIdSet.isEmpty()) {
	List<Competitor__c> compObjectList = [SELECT id, Opportunity__c, Competitor_New__c, Opportunity_Won__c, Won_Share_Allocation_in__c FROM Competitor__c WHERE Opportunity__c in: opptyIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (Competitor__c compObject: compObjectList) {
		if(opptyIdAndCompetitorsMapOld.containsKey(compObject.Opportunity__c)) {
			competitorsListOld = opptyIdAndCompetitorsMapOld.get(compObject.Opportunity__c);
			competitorsListOld.add(compObject);
			opptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c, competitorsListOld);
		}  else {
			competitorsListOld.clear();
			competitorsListOld.add(compObject);
			opptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c, competitorsListOld);
		}
	}
	for(Id oppId : opptyIdSet) {
		if(opptyIdAndCompetitorsMapOld.containsKey(oppId)) {
			Decimal sum = 0;
			for(Competitor__c comp : opptyIdAndCompetitorsMapOld.get(oppId)) {
				str = opptyNewMap.get(oppId).Winning_Competitor__c;
				allCompetitors = new Set<String>(str.split(GlobalConstants.SEMICOLON));
				if((allCompetitors.contains(comp.Competitor_New__c) || comp.Opportunity_Won__c == true) && comp.Won_Share_Allocation_in__c > 0)
		sum += comp.Won_Share_Allocation_in__c;
			}
			if(sum > decimal.valueOf(System.Label.Hundred))
				opptyNewMap.get(oppId).addError(System.Label.Won_Share_Sum_Validation);
		}
	}
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.VALIDATEWONSHAREALLOCATIONSUM);
		}
	}

	/*****************************
*Method Name: BatchCurrenychangeDL
*Description: Update unweighted amount for dataloaderuser
*Parameters: Oppty ID
*********************************/
	public void BatchCurrenychangeDL(Set<ID> opptyid) {
		List<Opportunity> updateOppty = new List<Opportunity>();
		try {
			List<Opportunity> newoppList = [SELECT id, Positive_OIF_EUR__c, OIF_Value_Won_USD__c, Sales_Outcome__c, OIF_Value_Cancel_USD__c, Positive_OIF__c, Negative_OIF_EUR__c, Negative_OIF__c FROM Opportunity WHERE id = :opptyid Limit:opptyid.size()];
			for (Opportunity newopp:newoppList) {
	if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
		newopp.amount = newopp.Positive_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Won_USD__c.setScale(2);
	} else if ((newopp.Sales_Outcome__c <> GlobalConstants.WON)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
		newopp.amount = newopp.Negative_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Cancel_USD__c.setScale(2);
	}
	updateOppty.add(newopp);
			}
			if(!updateOppty.isEmpty()) {
	List<Database.saveResult> srs = Database.update(updateOppty, false);
	ExceptionHandler.addExceptionForOIFBtach(updateOppty, srs);
	GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE = TRUE;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.BATCH_CURRENCY_CHANGE);
		}
	}

	/*****************************
*Method Name: oppTeamPrMValidation
*Description: Prevent oppty creation, If user have wrong pricing manager or pricing manager(lead) in their default opportunity team
*Added by HCL Team
*********************************/
	public void oppTeamPrMValidation(List<OpportunityTeamMember> oppTeamlst)
	{
		set<Id> oppIdSet = new set<Id>();
		set<String> orgL2 = new set<String>();
		set<String> orgL3 = new set<String>();
		set<String> orgL4 = new set<String>();
		set<String> orgL5 = new set<String>();
		set<String> orgL6 = new set<String>();
		set<String> orgL7 = new set<String>();
		String slashForErrorMsg = '';
		String additionalTeamRole = '';
		Map<String, String> sRmap = new Map<String, String>();
		System.debug('Calling PrM validation Oppty team');
		try
		{
			for(OpportunityTeamMember oppteam : oppTeamlst)
			{
	if((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole == System.Label.NF_PricingManagerLead)
	   || (oppTeam.Additional_Team_Role__c != null
		&& (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManagerLead))))
	{
		oppIdSet.add(oppteam.OpportunityId);
	}
			}
			System.debug('oppIdSet::> ' + oppIdSet);
			if(!oppIdSet.isEmpty())
			{
	for(Opportunity opp : [SELECT Id, Org_L2__c, Org_L3__c, Org_L4__c, Org_L5__c, Org_L6__c, Org_L7__c FROM Opportunity WHERE Id IN :oppIdSet ])
	{
		orgL2.add(opp.Org_L2__c);
		orgL3.add(opp.Org_L3__c);
		orgL4.add(opp.Org_L4__c);
		orgL5.add(opp.Org_L5__c);
		orgL6.add(opp.Org_L7__c);
		orgL7.add(opp.Org_L7__c);
	}
	List<Sales_Role__c> sRList = [SELECT User__c, Organisation__c FROM Sales_Role__c WHERE Role_Code__c LIKE :System.Label.NF_PrM_Role AND (Organisation__c IN: orgL2 OR Organisation__c IN: orgL3 OR Organisation__c IN: orgL4 OR Organisation__c IN: orgL5 OR Organisation__c IN: orgL6 OR Organisation__c IN: orgL7)];
	for(Sales_Role__c sR : sRList)
	{
		sRmap.put(sR.User__c, sR.Organisation__c);
	}
			}
			for(OpportunityTeamMember oppTeam : oppTeamlst)
			{
	if(((!sRmap.isEmpty() && !sRmap.containsKey(oppTeam.UserId)) || sRmap.isEmpty()) &&
	   ((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole == System.Label.NF_PricingManagerLead)
		|| (oppTeam.Additional_Team_Role__c != null && (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManagerLead)))
	   )) {
		System.debug('Error for PrM');
		if(oppTeam.Additional_Team_Role__c != null && oppTeam.Additional_Team_Role__c != '') {
		 slashForErrorMsg = '/';
		 additionalTeamRole = oppTeam.Additional_Team_Role__c;
		}
		Trigger.NewMap.get(oppTeam.Opportunityid).addError('You have a user named: ' + oppTeam.User.Name + ' having role ' + oppTeam.TeamMemberRole + slashForErrorMsg + additionalTeamRole + ' in your default opportunity team, which does not belongs to them. Please remove the user or change the role to proceed further.');
	   }
			}
		}
		Catch (Exception ex)
		{
			system.debug('ex' + ex);
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITY_TEAM_HELPER, GlobalConstants.METHOD_OPPORTUNITYTEAM_PrMVALIDATION);
		}
	}

	/*****************************
*Method Name: checkEnterpriseOpportunity
*Description: Distinguish between CSP versus Enterprise opportunities - at insert and update (Re-using field Opportunity.Type)
*Parameters: Map<Id, Opportunity> oldOpptyMap , Map<Id,Opportunity> newOpptyList
*********************************/
	public void checkEnterpriseOpportunity(Map<Id, Opportunity> oldOpptyMap , List<Opportunity> newOpptyList ){
		Set<Id> recordTypes = new Set<Id>{directRecordTypeId , inDirectRecordTypeId , readOnlyDirectRecordTypeId , readOnlyIndirectRecordTypeId };
			Set<String> custAccountRoleNE = new Set<String>(System.Label.Enterprise_Customer_Account_Roles.split(';'));
		Set<String> activitySectorsNE = new Set<String>();
		for(Activity_Sector_Name__c sector : Activity_Sector_Name__c.getAll().values()){
			activitySectorsNE.add(sector.Activity_Sector_Name__c);
		}
		for(Opportunity newOppty : newOpptyList){
			if(!recordTypes.contains(newOppty.RecordTypeId)) continue;
			Opportunity oldOppty = oldOpptyMap.containskey(newOppty.Id) ? oldOpptyMap.get(newOppty.Id) : null;
			String activitySectorField = getActivitySectorField(newOppty);
			if(checkEnterpriseParamChanged(oldOppty, newOppty,activitySectorField)){
	List<Opportunity> recalculatedOppty = new List<Opportunity>{newOppty.clone(true,true,true)};
		Formula.recalculateFormulas(recalculatedOppty);
	Boolean isEnterprise = custAccountRoleNE.contains(newOppty.Account_Role__c) || activitySectorsNE.contains((String)recalculatedOppty[0].get(activitySectorField));
	if(isEnterprise) {
		newOppty.Type = GlobalConstants.OPPTYSEGMENT_ENTERPRISE;
	} else {
		newOppty.Type = null;
	}
			}
		}
	}
	/*****************************
*Method Name: checkEnterpriseParamChanged
*Description: Verify if any param that could identify an oppty as NE or CSP has changed
*Parameters: Opportunity oldOppty, Opportunity newOppty, String activitySectorField
*********************************/
	public Boolean checkEnterpriseParamChanged(Opportunity oldOppty, Opportunity newOppty, String activitySectorField){
		return oldOppty == null || oldOppty.Account_Role__c != newOppty.Account_Role__c || (String)oldOppty.get(activitySectorField) != (String)newOppty.get(activitySectorField);
	}
	/*****************************
*Method Name: getActivitySectorField
*Description: Verify which field from Activity Sector should be used according to the record type
*Parameters: Opportunity oppty
*********************************/
	public String getActivitySectorField(Opportunity oppty){
		if(oppty.RecordTypeId == inDirectRecordTypeId || oppty.RecordTypeId == readOnlyIndirectRecordTypeId){
			if(oppty.End_Customer_Information__c == GlobalConstants.EC_INFO_KNWON)
	return 'End_Customer_Activity_Sector__c';
			else
	return 'Multiple_or_Unknown_EC_Activity_Sector__c';
		}
		return 'Account_Activity_Sector__c';
	}
	/*
* @description  	CRM - When an Activity Sector change on a Legal Entity it's necessary to identify if the related opportunities are still NE or CSP - (Re-using field Opportunity.Type)
* @param	Map<Id,Account> oldAccountMap, Map<Id,Account> newAccountMap
* @return
*/
	public void checkActivitySectorChanges(Map<Id,Account> oldAccountMap, Map<Id,Account> newAccountMap){
		Set<Id> changedLegalEntitiesId = new Set<Id>();
		for(Account newAccount : newAccountMap.values()){
			Account oldAccount = oldAccountMap.get(newAccount.Id);
			if(oldAccount.Activity_Sector_Name__c != newAccount.Activity_Sector_Name__c){
	changedLegalEntitiesId.add(newAccount.Id);
			}
		}
		if(!changedLegalEntitiesId.isEmpty()){
			OpportunityTriggerHelper oppTrHelper = new OpportunityTriggerHelper();
			Set<Id> recordTypes = new Set<Id>{oppTrHelper.directRecordTypeId , oppTrHelper.inDirectRecordTypeId , oppTrHelper.readOnlyDirectRecordTypeId , oppTrHelper.readOnlyIndirectRecordTypeId };
	List<Opportunity> opptyASChanged = [SELECT Id,RecordTypeId,End_Customer_Information__c,End_Customer_Activity_Sector__c,Multiple_or_Unknown_EC_Activity_Sector__c,Account_Activity_Sector__c,Account_Role__c,Type
				FROM Opportunity WHERE (Legal_Entity__c IN :changedLegalEntitiesId OR End_Customer_LE__c IN :changedLegalEntitiesId) AND
				RecordTypeId IN :recordTypes];
			try{
	oppTrHelper.checkEnterpriseOpportunity(new Map<Id,Opportunity>(), opptyASChanged);
	Database.update(opptyASChanged, false);
			} catch(Exception e){
	System.debug('Error on checkActivitySectorChanges');
	System.debug(e.getMessage());
			}
		}
	}

	/*
* @description  	CRM - When a opp is created or its phase is changed to developer opportunity, a NOKIA competitor record is created for Win Plan
* @param	Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity> optyOldMapp
* @return
*/

	public void createNokiaCompetitorRecord(List<Opportunity> oppList, Map<Id, Opportunity> optyOldMap)
	{
		Boolean isCreate = optyOldMap == null;
		List<Competitor__c> newNokiaCompetitorList = new List<Competitor__c>();

		Set<Id> oppIdSet = new Set<Id>();
		for(Opportunity newOpp : oppList)
		{
			oppIdSet.add(newOpp.Id);
		}
		List<Competitor__c> currentNokiaCompetitorList = [SELECT Id, Competitor_New__c, Opportunity__c FROM Competitor__c WHERE Opportunity__c in :oppIdSet AND Competitor_New__c = :Label.CRM_Nokia_Competitor_Name];
		for(Opportunity newOpp : oppList)
		{
			if( (newOpp.RecordTypeId == directRecordTypeId || newOpp.RecordTypeId == inDirectRecordTypeId)
	  && (isCreate || optyOldMap.get(newOpp.Id) == null || ((newOpp.StageName != optyOldMap.get(newOpp.Id).StageName) && newOpp.StageName.equals(GlobalConstants.DEVELOP_OPPORTUNITY)))
	  && !existingNokiaCompetitor(newOpp.Id, currentNokiaCompetitorList))
			{
	Competitor__c nokiaCompetitor = new Competitor__c();
	nokiaCompetitor.Competitor_New__c = Label.CRM_Nokia_Competitor_Name;
	nokiaCompetitor.Opportunity__c = newOpp.Id;
	newNokiaCompetitorList.add(nokiaCompetitor);
			}
		}
		insert newNokiaCompetitorList;
	}

	private Boolean existingNokiaCompetitor(Id  oppId, List<Competitor__c> currentNokiaCompetitorList)
	{
		Boolean existingNokiaComp = false;
		for(Competitor__c comp : currentNokiaCompetitorList)
		{
			if(comp.Opportunity__c == oppId)
			{
	existingNokiaComp = true;
	break;
			}
		}
		return existingNokiaComp;
	}

	public void validatePhaseStatusComment( List<Opportunity> newOptyLst){
		for(Opportunity oppty : newOptyLst){
			if( oppty.RecordTypeId == directRecordTypeId || oppty.RecordTypeId == inDirectRecordTypeId ){
	if(oppty.StageName == GlobalConstants.DEVELOP_OPPORTUNITY && oppty.NF_Facilitator_Notified__c ){
		oppty.Phase_Status_Comment__c = GlobalConstants.G3FACILITATORNOTIFIED;
	} else if(oppty.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && oppty.Phase_Status__c != GlobalConstants.PENDING_WIN_LOSS_DECLARATION && oppty.G5_Trigger__c != null ){
		oppty.Phase_Status_Comment__c = GlobalConstants.G5PREPINITIATED;
	} else {
		oppty.Phase_Status_Comment__c = null;
	}
			}
		}
	}

	public void validateAccountChange(List<Opportunity> optyList, Map<Id, Opportunity> optyOldMap)
	{
		Set<Id> oppsToCheckRevRec = new Set<Id>();
		for (Opportunity opp: optyList)
		{
			if (opp.AccountId != optyOldMap.get(opp.Id).AccountId
	&& CRM_Account_to_Bypass_Allocation__c.getValues(opp.Account_Information__c.split(';')[0]) == null
	&& GlobalConstants.Const_NAM.contains(opp.Org_L4__c)
	&& CRM_Account_to_Bypass_Allocation__c.getValues(optyOldMap.get(opp.Id).Account_Information__c.split(';')[0]) != null
	&& ! GlobalConstants.Const_NAM.contains(optyOldMap.get(opp.Id).Org_L4__c) )
			{
	opp.addError(GlobalConstants.OPP_ACCID_ALLOCATION_ERROR);
			}
		}
	}

	/* @description  	If the oppty is Direct/Indirect and does not have Oppty Type defined at creation, it defaults to Standard Opportunity
* @param	List<Opportunity> oppty list
* @return */
	public void validateOpportunityType(List<Opportunity> opptyList){
		for(Opportunity oppty : opptyList){
			if( (oppty.RecordTypeId == directRecordTypeId || oppty.RecordTypeId == indirectRecordTypeId ) && oppty.Business_Type__c == null){
	oppty.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			}
		}
	}


	public Map<Id, Account> getAccountsInfo(List<Opportunity> opptyList, Map<Id,Opportunity> oldMapOppty){
		Set<Id> accIds = new Set<Id>();

		for(Opportunity oppty : opptyList){
			Opportunity oldOppty = oldMapOppty.containsKey(oppty.Id) ? oldMapOppty.get(oppty.Id) : null;
			if(oldOppty == null || oldOppty.AccountId != oppty.AccountId){
	accIds.add(oppty.AccountId);
			}
			if(oldOppty == null || oldOppty.Legal_Entity__c != oppty.Legal_Entity__c){
	accIds.add(oppty.AccountId);
			}
			if( oppty.End_Customer__c != null && ( oldOppty == null || oldOppty.End_Customer__c != oppty.End_Customer__c ) ) {
	accIds.add(oppty.End_Customer__c);
			}
			if (oppty.End_Customer_LE__c != NULL && ( oldOppty == null || oldOppty.End_Customer_LE__c != oppty.End_Customer_LE__c ) ) {
	accIds.add(oppty.End_Customer_LE__c);
			}
		}
		if(accIds.size()>0){
			return new Map<Id,Account>([SELECT Id, ParentId, (SELECT Id, Name, accountNumber FROM ChildAccounts WHERE RecordType.name = 'Legal Entity' AND Default_Legal_Entity__c = true)
	FROM Account WHERE Id IN :accIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]);
		}
		return new Map<Id,Account>();

	}
}