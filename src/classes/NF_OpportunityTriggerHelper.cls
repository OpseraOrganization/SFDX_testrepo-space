/*************************************************************
@Name: NF_OpportunityTriggerHelper
@Author:  Siva
@CreateDate:2nd Oct 2017
@Description: Controller class for Chatter and Emial functions
******************************************************************/
public inherited sharing class NF_OpportunityTriggerHelper{
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();

	/*****************************
*Method Name: method_calls
*Description:  Common method calling
*Parameters: opportunitiesMap
*******************************/
	public static void Common_method_calls(map<Id,Opportunity> opportunitiesNewMap,map<Id,Opportunity> opportunitiesoldMap)
	{
		Map<Id,Opportunity> OldMap=new  Map<Id,Opportunity>();
		Map<Id,Opportunity> NewMap=new  Map<Id,Opportunity>();
		OldMap=opportunitiesoldMap;
		NewMap=opportunitiesNewMap;
		Map<Id,Opportunity> Recall_PSR_Opptyinfo= new Map<Id,Opportunity>();
		Map<Id,Opportunity> Approval_PSR_Opptyinfo= new Map<Id,Opportunity>();

		for(Opportunity Opptydatas:NewMap.values())
		{

			if((Opptydatas.RecordTypeId==PSR_EditRecordTypeID || Opptydatas.RecordTypeId==PSR_ReadOnlyRecordTypeID) && Opptydatas.Apttus_Approval__Approval_Status__c<>Null && OldMap.get(Opptydatas.id).Apttus_Approval__Approval_Status__c<>Null && Opptydatas.Apttus_Approval__Approval_Status__c<>OldMap.get(Opptydatas.id).Apttus_Approval__Approval_Status__c && OldMap.get(Opptydatas.id).Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL)&&Opptydatas.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.STATUS_NOT_SUBMITTED) )
			{
	Recall_PSR_Opptyinfo.put(Opptydatas.ID,OldMap.get(Opptydatas.ID));
			}
			if((Opptydatas.RecordTypeId==PSR_EditRecordTypeID || Opptydatas.RecordTypeId==PSR_ReadOnlyRecordTypeID) && Opptydatas.StageName.equalsignorecase(globalconstants.SUBMITTED_FOR_APPROVAL) && Opptydatas.Apttus_Approval__Approval_Status__c<>Null&&Opptydatas.Apttus_Approval__Approval_Status__c<>OldMap.get(Opptydatas.id).Apttus_Approval__Approval_Status__c   && Opptydatas.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) )
			{
	Approval_PSR_Opptyinfo.put(Opptydatas.ID,OldMap.get(Opptydatas.ID));
			}
		}
		if(!Recall_PSR_Opptyinfo.isEmpty() && !GlobalConstants.OPPORTUNITY_PSR_RECALL_CHECK)
		{
			Recall_Presales_Notification(Recall_PSR_Opptyinfo);
		}
		if(!Approval_PSR_Opptyinfo.isEmpty() && !GlobalConstants.OPPORTUNITY_PSR_stakeHolder_CHECK)
		{
			ChatterPostToStakeHolders(Approval_PSR_Opptyinfo,true);
		}
	}

	/*****************************
*Method Name: Recall_Presales_Notification
*Description:  Chatter Post For Presales Recall to Inform
*Parameters: opportunitiesMap
*******************************/
	public static void Recall_Presales_Notification(map<Id, Opportunity>opportunitiesMap) {

		map<ID, Set<ID>>mapOppIdRelatedUsers = new map<ID, Set<ID>>();
		Map<ID,Apttus_Approval__Approval_Request__c> ApproverInfo =new Map<ID,Apttus_Approval__Approval_Request__c>();
		String Account='';
		String lead_BG_PSR='';
		boolean Rejected=false;

		try{
			GlobalConstants.OPPORTUNITY_PSR_RECALL_CHECK=True;
			for(Opportunity opptyInfo:opportunitiesMap.values())
			{
	if((opptyInfo.RecordTypeId==PSR_EditRecordTypeID || opptyInfo.RecordTypeId==PSR_ReadOnlyRecordTypeID) && opptyInfo.Lead_BG__c <>Null)
		lead_BG_PSR=opptyInfo.Lead_BG__c;

	if(opptyInfo.Account_Name__c<>Null)
		Account=opptyInfo.Account_Name__c;
			}

			// fill the mapOppIdRelatedUsers map by opportunity Owners
			for (Opportunity opp: opportunitiesMap.values()) {
	if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
		mapOppIdRelatedUsers.put(opp.Id, new Set<ID>());
	}
	mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
			}

			// fill the map by opportunity team members
			for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId
				  FROM OpportunityTeamMember
				  WHERE TeamMemberRole!=:GlobalConstants.TEAM_ROLE AND  OpportunityId IN: opportunitiesMap.keySet()
				 ])
			{

	if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
		mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, new Set<ID>());
	}
	if(mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId))
		mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
			}


			//collecting the Approver records
			for (Apttus_Approval__Approval_Request__c approvalrequest: [SELECT ID,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Backup_From_User__c, Apttus_Approval__DateApproved__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Step_Name__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
						FROM Apttus_Approval__Approval_Request__c
						WHERE Apttus_Approval__Assigned_To_Id__c<>Null AND Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet()
					])
			{
	if( approvalrequest.NF_Assignee_Type__c<>Null  && approvalrequest.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.cancel) )
		ApproverInfo.put(approvalrequest.id,approvalrequest);

	if(approvalrequest.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.APPROVED) ||approvalrequest.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.Rejected))
		Rejected=true;
			}
			// fill the mapOppIdRelatedUsers map by opportunity validators and contributors
			for (Apttus_Approval__Approval_Request__c approvalrequest: ApproverInfo.Values()) {

	if (!mapOppIdRelatedUsers.containsKey(approvalrequest.Apttus_Approval__Object_Id__c)) {
		mapOppIdRelatedUsers.put(approvalrequest.Apttus_Approval__Object_Id__c, new Set<ID>());
	}

	if(approvalrequest.Apttus_Approval__Assigned_To_Type__c<>Null && approvalrequest.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.USER))
		mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(approvalrequest.Apttus_Approval__Assigned_To_Id__c);

	if(approvalrequest.Apttus_Approval__Assigned_To_Type__c<>Null && approvalrequest.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.QUEUE))
	{
		for(ID QueueID:getQueueMembers(approvalrequest.Apttus_Approval__Assigned_To_Id__c))
		{
			if(QueueID<>NUll)
				mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(QueueID);
		}
	}
	if (approvalrequest.Apttus_Approval__DelegateApproverIds__c != null) {
		String[] delegateApproverIds = approvalrequest.Apttus_Approval__DelegateApproverIds__c.split(',');
		for (string delegateapproverId: delegateApproverIds) {
			mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(delegateapproverId);
		}
	}
			}
			if(Rejected)
	mapOppIdRelatedUsers.clear();

			for (ID oppId: opportunitiesMap.keySet()) {
	if (mapOppIdRelatedUsers.get(OppId) != null) {
		integer NumberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / 24).round(System.RoundingMode.UP);
		integer StartLoop = 0;
		for (integer i = 0; i<NumberOfPost; i++) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput ;

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			list<Id>lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));

			for (integer j = StartLoop; j<StartLoop + 24; j++) {
				if (lstIds.size()>j) {
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = lstIds[j];
		messageBodyInput.messageSegments.add(mentionSegmentInput);
				}
			}
			StartLoop += 24;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentBold;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentBold;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentItalic;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentItalic;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentcode;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentcode;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentlist;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentlist;

			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentSpace;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentSpace;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentParagraph;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentParagraph;

			//Tag for Bold
			markupBeginSegmentBold = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			markupEndSegmentBold = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentBold.markupType = ConnectApi.MarkupType.Bold;

			//tag for code
			markupBeginSegmentcode = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentcode.markupType = ConnectApi.MarkupType.code;
			markupEndSegmentcode = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentcode.markupType = ConnectApi.MarkupType.code;
			//tag for list
			markupBeginSegmentlist = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentlist.markupType = ConnectApi.MarkupType.ListItem;
			markupEndSegmentlist = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentlist.markupType = ConnectApi.MarkupType.ListItem;

			//tag For Italic
			markupBeginSegmentItalic = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentItalic.markupType = ConnectApi.MarkupType.Italic;
			markupEndSegmentItalic = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentItalic.markupType = ConnectApi.MarkupType.Italic;

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			String Gateinfo1='';
			String Gateinfo2='';
			System.debug('opportunitiesMap.get(oppId).Phase_Status__c'+opportunitiesMap.get(oppId).Phase_Status__c);

			Gateinfo1='The approval request for ';
			Gateinfo2= ' has been recalled/cancelled.';

			//new Paragraph

			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//first line of chatter info

			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =Gateinfo1+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =opportunitiesMap.get(oppId).Name+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =Gateinfo2;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// opportunity ID
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Pre-sales Opportunity Number:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Opportunity_ID__c;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			//opportunity Name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Pre-sales Opportunity Name:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Name;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			// Customer name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Customer:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+Account;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);
			// lead bg name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Lead BG Pre-sales:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+lead_BG_PSR;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);
			//New Paragraph

			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//regards scrm
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Regards'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);

			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Nokia Salesforce CRM'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			string vallink= URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppId;

			// Opportunity Link
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Opportunity Link:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			ConnectApi.LinkSegmentinput linksegment = new ConnectApi.LinkSegmentinput();
			linksegment.url = vallink;
			messageBodyInput.messageSegments.add(linksegment);

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
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.RECALL_PSR_NOTIFICATION);
		}
	}

	/*
* @desc the method will be used to notify validators and contributors and opportunity team member
* @param   opportunities: the map of opportunities which are approved or rejected
*/
	@future
	public static void NotifyOpportunityRelatedUsers(Set<ID> OpptyID) {

		map<Id, Opportunity> opportunitiesMap;
		map<Id,ID> GateParticipents= new  map<Id,ID>();
		Map<ID,ID> Teamid= new Map<ID,ID>();
		Set<ID> Userid= new Set<ID>();
		String EmailTemplate;
		String Stepname;
		Map<ID,Apttus_Approval__Approval_Request__c> ApproverInfo =new Map<ID,Apttus_Approval__Approval_Request__c>();
		Boolean G5Check=false;
		try{
			opportunitiesMap= new Map<Id,Opportunity>([select id,StageName,NF_Facilitator_User__c,Approvals_Current_Status__c,Phase_Status__c,Facilitator_Delegate_1__c,Facilitator_Delegate_2__c,Facilitator_Delegate_3__c,PSR_Pre_Sales_Risk_Opportunity_Type__c,Ownerid from Opportunity where id=:OpptyID]);
			System.debug('Oppty Info ####'+opportunitiesMap);
			// collecting the Oppty team
			for(OpportunityTeamMember OpptyTeam :[SELECT UserId, OpportunityId FROM OpportunityTeamMember WHERE TeamMemberRole!=:GlobalConstants.TEAM_ROLE AND  OpportunityId IN: opportunitiesMap.keySet()])
	Teamid.put(OpptyTeam.UserId,OpptyTeam.UserId);

			// collecting the active offer
			Map<Id,Offer__c> Offerinfo = new Map<Id,Offer__c>([select id,name,Opportunity__c,ActiveOffer__c from Offer__c where ActiveOffer__c=true AND  Opportunity__c=:opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() ]);
			System.debug(Offerinfo);

			//fill the mapOppIdRelatedUsers map by Offer Team
			for(Offer_Team__c OfferTeamMembers: [select id,Offer__c ,Name__c,Offer__r.Opportunity__c from Offer_Team__c where Team_Member_Role__c!=:GlobalConstants.TEAM_ROLE AND Offer__c=:Offerinfo.keySet() LIMIT: Limits.getLimitQueryRows()  ])
	Teamid.put(OfferTeamMembers.Name__c,OfferTeamMembers.Name__c);

			// collecting the G3 Motified Users
			for(Opportunity Opptyinfo:opportunitiesMap.values())
			{
	if(Opptyinfo.StageName<>Null && Opptyinfo.Approvals_Current_Status__c<>Null
	   && ((Opptyinfo.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) && Opptyinfo.Approvals_Current_Status__c.equalsignorecase('Rejected G3'))
		|| (Opptyinfo.StageName.equalsignorecase(GlobalConstants.CREATE_OFFER) &&  Opptyinfo.Approvals_Current_Status__c.equalsignorecase('Approved G3'))
		  ))
	{
		System.debug('G3 Approval Info--->');
		if(Opptyinfo.NF_Facilitator_User__c<>Null)
			Teamid.put(Opptyinfo.NF_Facilitator_User__c,Opptyinfo.NF_Facilitator_User__c);

		if(Opptyinfo.Facilitator_Delegate_1__c<>Null)
			Teamid.put(Opptyinfo.Facilitator_Delegate_1__c,Opptyinfo.Facilitator_Delegate_1__c);

		if(Opptyinfo.Facilitator_Delegate_2__c<>Null)
			Teamid.put(Opptyinfo.Facilitator_Delegate_2__c,Opptyinfo.Facilitator_Delegate_2__c);


		if(Opptyinfo.Facilitator_Delegate_3__c<>Null)
			Teamid.put(Opptyinfo.Facilitator_Delegate_3__c,Opptyinfo.Facilitator_Delegate_3__c);

		if(Opptyinfo.PSR_Pre_Sales_Risk_Opportunity_Type__c<>null && !Teamid.containsKey(Opptyinfo.OwnerID))
		{
			Teamid.put(Opptyinfo.OwnerID, Opptyinfo.OwnerID);
		}
	}
	System.debug(Teamid.keyset());
			}

			//collecting the Approver records
			for (Apttus_Approval__Approval_Request__c approvalrequest: [SELECT ID, Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__DateApproved__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Step_Name__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
						FROM Apttus_Approval__Approval_Request__c
						WHERE Apttus_Approval__Step_Name__c!=Null AND Apttus_Approval__Assigned_To_Id__c!=Null AND Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet()
					])
			{
	if( approvalrequest.NF_Assignee_Type__c<>Null && approvalrequest.Apttus_Approval__DateApproved__c==Null && approvalrequest.Apttus_Approval__Step_Name__c<>Null && approvalrequest.NF_Assignee_Type__c.equalsignorecase(GlobalConstants.APPROVER) && approvalrequest.Apttus_Approval__Step_Name__c.equalsignorecase(Label.G5_CT_Head_Check) && !approvalrequest.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.APPROVED) )
	{
		ApproverInfo.clear();
		System.debug('-->approvalrequest.Apttus_Approval__Step_Name__c'+approvalrequest.Apttus_Approval__Step_Name__c+approvalrequest.Apttus_Approval__Approval_Status__c);
		System.debug(approvalrequest.id);
		ApproverInfo.put(approvalrequest.id,approvalrequest);
		G5Check=true;
	}
	if(G5Check==false)
		ApproverInfo.put(approvalrequest.id,approvalrequest);

			}
			System.debug('Gate Participents Records'+ApproverInfo.keyset());

			//Apttus_Approval__Approval_Status__c
			for(Apttus_Approval__Approval_Request__c ReqInfo:ApproverInfo.Values())

			{
	if(!ReqInfo.Apttus_Approval__Step_Name__c.contains('Bypass')){
		Stepname=ReqInfo.Apttus_Approval__Step_Name__c;

		if(ReqInfo.Apttus_Approval__Assigned_To_Type__c<>Null && ReqInfo.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.USER))
			GateParticipents.put(ReqInfo.Apttus_Approval__Assigned_To_Id__c,ReqInfo.id);

		if(ReqInfo.Apttus_Approval__Assigned_To_Type__c<>Null && ReqInfo.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.QUEUE))
		{
			for(ID QueueID:getQueueMembers(ReqInfo.Apttus_Approval__Assigned_To_Id__c))
			{
				if(QueueID<>NUll)
		GateParticipents.put(QueueID,ReqInfo.id);
			}
		}

		//adding the Oppty Owner
		GateParticipents.put(opportunitiesMap.get(ReqInfo.Apttus_Approval__Object_Id__c).Ownerid,ReqInfo.id);

		if (ReqInfo.Apttus_Approval__DelegateApproverIds__c != null) {
			String[] delegateApproverIds = ReqInfo.Apttus_Approval__DelegateApproverIds__c.split(',');
			for (string delegateapproverId: delegateApproverIds) {
				GateParticipents.put(delegateapproverId,ReqInfo.id);
				System.debug('Delegate ====='+delegateapproverId);
			}
		}
		for(Id Team:Teamid.Keyset())
			GateParticipents.put(Team,ReqInfo.id);
	}
			}

			System.debug('Gate Participents info'+GateParticipents);

			// fill add the oppty owner and approval status
			for (Opportunity opplist:opportunitiesMap.values()) {

	System.debug('Loop OpportunityMap inside'+opportunitiesMap.values());

	//G2 Reject
	if(opplist.StageName<>NULL &&opplist.Approvals_Current_Status__c<>Null && opplist.StageName.equalsignorecase(GlobalConstants.IDENTIFY_OPPORTUNITY ) && (opplist.Approvals_Current_Status__c.equalsignorecase('Rejected G2')))
		EmailTemplate=Label.NF_G2_Email_Template;

	//G2 Approved
	if(opplist.StageName<>NULL && opplist.Approvals_Current_Status__c<>Null && opplist.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) && (opplist.Approvals_Current_Status__c.equalsignorecase('Approved G2')))
		EmailTemplate=Label.NF_G2_Email_Template;

	else if(opplist.PSR_Pre_Sales_Risk_Opportunity_Type__c<>null)
		EmailTemplate=Label.NF_NF_PSR_Approval_Completion;

	System.debug('Loop EmailTemplate '+EmailTemplate);
			}

			System.debug('Out of loop'+EmailTemplate+Stepname);
			//  Opportunity Approval/Reject Status to all Aprover User
			if(EmailTemplate<>null && Stepname<>null){

	EmailTemplate et=[SELECT id FROM EmailTemplate WHERE developerName =:EmailTemplate  LIMIT 1];

	List<Messaging.SingleEmailMessage> mail = new List<Messaging.SingleEmailMessage>();

	//  Opportunity Approval/Reject Status to Opportunity User
	System.debug('size of the object'+GateParticipents.size());

	//collect the delegate users info and sent the email
	for(id GateParticipentsinfo:GateParticipents.Keyset())
	{
		Messaging.SingleEmailMessage GateparticipentsEmail = new Messaging.SingleEmailMessage();
		System.debug('Loop Gate participents Object id'+ GateParticipents.get(GateParticipentsinfo));
		GateparticipentsEmail.setWhatId(GateParticipents.get(GateParticipentsinfo));
		System.debug('Loop Gateparticipents.Id'+GateParticipentsinfo);
		GateparticipentsEmail.setTargetObjectId(GateParticipentsinfo);
		GateparticipentsEmail.setTemplateId(et.id);
		GateparticipentsEmail.setSaveAsActivity(false);
		mail.add(GateparticipentsEmail);
	}

	if(!mail.isEmpty()){
		GlobalConstants.OPPORTUNITY_APPROVAL=TRUE;
		Messaging.SendEmailResult[] results=Messaging.sendEmail(mail);
		System.debug('Email Result--->'+results);
	}
			}
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.NOTIFY_TO_USER_APPROVAL);
		}
	}

	/*****************************
*Method Name: ChatterPostToStakeHolders
*Description:  Chatter Post to All Stakeholders to Inform about Gate Submissions
*Parameters: Oppty
*******************************/
	public static void ChatterPostToStakeHolders(Map<ID,Opportunity> Oppty, Boolean IsPresales){
		//Is Presales VAr is used to check opportunity is presales or not
		List<Apttus_Approval__Approval_Request__c> Remupdate= new  List<Apttus_Approval__Approval_Request__c>();
		Map<ID,Set<ID>> mapStakeHolderId= new Map<ID,Set<ID>>();
		try{
			String LOALevel='';
			String LoALevelbeforeSTA='';
			String LeadBG='';
			String LeadBU='';
			String SupportingBGsBUs='';
			String OferDescription='';
			String ApprovalScope='';
			String Account='';
			String Country='';
			String lead_BG_PSR='';
			String wtd_Class='';

			if(IsPresales)
	GlobalConstants.OPPORTUNITY_PSR_stakeHolder_CHECK=true;

			if(!IsPresales){
	GlobalConstants.OPPORTUNITY_CHATTER_CHECK=True;
	for(Offer__c Offerinf:[select id,name,Opportunity__c,Offer_Description__c,LoA_Level_Before_Trigger_Approval__c,Approval_Scope__c,  WTD_Case__c from Offer__c where ActiveOffer__c=true and Opportunity__c=:Oppty.keySet() LIMIT: Limits.getLimitQueryRows() ])
	{
		system.debug('NF_OpportunityTriggerHelper Avn:'+Offerinf.Approval_Scope__c);
		if(Offerinf.Offer_Description__c<>Null)
			OferDescription=Offerinf.Offer_Description__c;

		if(Offerinf.Approval_Scope__c<>Null)
			ApprovalScope=Offerinf.Approval_Scope__c;

		if(Offerinf.LoA_Level_Before_Trigger_Approval__c<>Null)
			LoALevelbeforeSTA=Offerinf.LoA_Level_Before_Trigger_Approval__c;

		if(Offerinf.WTD_Case__c<>Null)
			wtd_Class=Offerinf.WTD_Case__c;
	}
			}
			for(Opportunity opptyInfo:Oppty.values())
			{
	if(opptyInfo.Country__c<>Null)
		Country=opptyInfo.Country__c;

	if((opptyInfo.RecordTypeId==PSR_EditRecordTypeID || opptyInfo.RecordTypeId==PSR_ReadOnlyRecordTypeID) && opptyInfo.Lead_BG__c <>Null)
		lead_BG_PSR=opptyInfo.Lead_BG__c;

	if(opptyInfo.Account_Name__c<>Null)
		Account=opptyInfo.Account_Name__c;

	if(opptyInfo.Lead_BG__c<>Null)
		LeadBG=opptyInfo.Lead_BG__c;

	if(opptyInfo.Lead_BU__c<>Null)
		LeadBU=opptyInfo.Lead_BU__c;

	if(opptyInfo.Supporting_BGs_BUs__c <> Null && opptyInfo.Supporting_BGs_BUs__c <> '')
	{
		SupportingBGsBUs = opptyInfo.Supporting_BGs_BUs__c.replaceAll(';',', ');
	}

	if(opptyInfo.LOA_Level__c<>Null)
		LOALevel=opptyInfo.LOA_Level__c;

	if(!IsPresales){
		if (!mapStakeHolderId.containsKey(opptyInfo.ID)) {
			mapStakeHolderId.put(opptyInfo.ID, new Set<ID>());
		}
		mapStakeHolderId.get(opptyInfo.ID).add(opptyInfo.OwnerID);
	}

			}

			for(Apttus_Approval__Approval_Request__c Appupdate:[Select id,Apttus_Approval__Step_Name__c,Apttus_Approval__StepLabel__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__Object_Id__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Assigned_To_Id__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c  from Apttus_Approval__Approval_Request__c where Apttus_Approval__Object_Id__c=:Oppty.KeySet() and NF_Assignee_Type__c<>Null  ])
			{
	System.debug('------Assignee type'+Appupdate.NF_Assignee_Type__c);

	// Collecting the StakeHodler Records and updating the stakeholder status.
	if(Appupdate.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION) && !Appupdate.Apttus_Approval__Step_Name__c.contains('Bypass') && !Appupdate.Apttus_Approval__StepLabel__c.contains('Bypass'))
	{
		System.debug('------ Inside Loop Assignee type'+Appupdate.NF_Assignee_Type__c);
		Appupdate.Apttus_Approval__Approval_Status__c ='Notified';
		//Appupdate.Apttus_Approval__Notify_Only__c=True;
		Remupdate.add(Appupdate);

		if (!mapStakeHolderId.containsKey(Appupdate.Apttus_Approval__Object_Id__c)) {

			mapStakeHolderId.put(Appupdate.Apttus_Approval__Object_Id__c, new Set<ID>());
		}

		if(mapStakeHolderId.containsKey(Appupdate.Apttus_Approval__Object_Id__c))
		{
			if(Appupdate.Apttus_Approval__Assigned_To_Type__c<>Null && Appupdate.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.USER))
				mapStakeHolderId.get(Appupdate.Apttus_Approval__Object_Id__c).add(Appupdate.Apttus_Approval__Assigned_To_Id__c);


			if(Appupdate.Apttus_Approval__Assigned_To_Type__c<>Null && Appupdate.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.QUEUE))
			{
				for(ID QueueID:getQueueMembers(Appupdate.Apttus_Approval__Assigned_To_Id__c))
				{
		if(QueueID<>NUll)
			mapStakeHolderId.get(Appupdate.Apttus_Approval__Object_Id__c).add(QueueID);
				}
			}
		}
	}
			}

			System.debug('StakeHolder Update-->'+Remupdate);
			for (ID oppId: mapStakeHolderId.keySet()) {
	if (mapStakeHolderId.get(OppId) != null) {
		integer NumberOfPost = (integer)((decimal) mapStakeHolderId.get(OppId).size() / 24).round(System.RoundingMode.UP);
		integer StartLoop = 0;
		for (integer i = 0; i<NumberOfPost; i++) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			list<Id>lstIds = new list<Id>(mapStakeHolderId.get(oppId));

			for (integer j = StartLoop; j<StartLoop + 24; j++) {
				if (lstIds.size()>j) {
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = lstIds[j];
		messageBodyInput.messageSegments.add(mentionSegmentInput);
				}
			}
			StartLoop += 24;
			String Gateinfo='';
			StartLoop += 24;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentBold;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentBold;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentlist;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentlist;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentSpace;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentSpace;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentParagraph;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentParagraph;

			//Tag for Bold
			markupBeginSegmentBold = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			markupEndSegmentBold = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			//tag for list
			markupBeginSegmentlist = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentlist.markupType = ConnectApi.MarkupType.ListItem;
			markupEndSegmentlist = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentlist.markupType = ConnectApi.MarkupType.ListItem;

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;

			if(Oppty.get(oppId).Phase_Status__c<>Null && Oppty.get(oppId).Phase_Status__c.contains('G2') )
				Gateinfo='Gate 2 has been launched for approval.';

			if(IsPresales)
				Gateinfo='has been submitted for approval.';
			//first line of chatter info
			if(!IsPresales){
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =Gateinfo;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			}
			if(IsPresales){
				markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = '&nbsp;';
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE+Oppty.get(oppId).Name+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =Gateinfo+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			}
			//new Paragraph

			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			if(IsPresales){
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentlist);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Pre-sales Opportunity Number:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+Oppty.get(oppId).Opportunity_ID__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentlist);

				//opportunity Name
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentlist);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Pre-sales Opportunity Name:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+Oppty.get(oppId).Name;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentlist);

				// Customer name
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentlist);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Customer:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE+Account;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentlist);
				// lead bg name
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentlist);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Lead BG Pre-sales:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE+lead_BG_PSR;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentlist);
				//New Paragraph

				markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = '&nbsp;';
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

				//regards scrm
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Regards'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);

				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Nokia Salesforce CRM'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				//New Paragraph
				markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = '&nbsp;';
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

				string vallink= URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppId;
				// Opportunity Link
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Opportunity Link:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				ConnectApi.LinkSegmentinput linksegment = new ConnectApi.LinkSegmentinput();
				linksegment.url = vallink;
				messageBodyInput.messageSegments.add(linksegment);
			}
			// opportunity name
			if(!IsPresales){
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();

				textSegmentInput.text ='Opportunity Name:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+Oppty.get(oppId).Name;
				messageBodyInput.messageSegments.add(textSegmentInput);

				// Customer name
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Customer:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE+Account;
				messageBodyInput.messageSegments.add(textSegmentInput);

				// Country name
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Country:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE+Country;
				messageBodyInput.messageSegments.add(textSegmentInput);

				// Unweighted Amount
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Unweighted amount:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+Oppty.get(oppId).CurrencyIsoCode+''+Oppty.get(oppId).Amount;
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
				textSegmentInput.text = '&nbsp;';
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

				// Oppty ID
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Opportunity Number:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+Oppty.get(oppId).Opportunity_ID__c;
				messageBodyInput.messageSegments.add(textSegmentInput);

				// LOA Level
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Approval Level:'+GlobalConstants.SPACE; // Label Changed - SF Ticket 00956787
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+LOALevel;
				messageBodyInput.messageSegments.add(textSegmentInput);

				// LoA Level before STA
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Approval Level before STA:'+GlobalConstants.SPACE; // Label Changed - SF Ticket 00956787
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+LoALevelbeforeSTA;
				messageBodyInput.messageSegments.add(textSegmentInput);

				//Lead BG
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Lead BG:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text =GlobalConstants.SPACE+ LeadBG;
				messageBodyInput.messageSegments.add(textSegmentInput);

				//Lead BU
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Lead BU:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+LeadBU;
				messageBodyInput.messageSegments.add(textSegmentInput);

				//Supporting BGs/BUs
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Supporting BGs/BUs:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+SupportingBGsBUs;
				messageBodyInput.messageSegments.add(textSegmentInput);

				//WTD Case
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='WTD Case:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				ConnectApi.LinkSegmentinput linksegment = new ConnectApi.LinkSegmentinput();
				if(wtd_Class != ''){
		linksegment.url = wtd_Class;
		messageBodyInput.messageSegments.add(linksegment);
				}

				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);

				//New Paragraph
				markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = '&nbsp;';
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

				//Offer Description
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Offer Description:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+OferDescription;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);

				//New Paragraph
				markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = '&nbsp;';
				messageBodyInput.messageSegments.add(textSegmentInput);
				markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
				markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
				messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

				// Approval Scope
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
				messageBodyInput.messageSegments.add(markupBeginSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text ='Approval Scope:'+GlobalConstants.SPACE;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupEndSegmentBold);
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = GlobalConstants.SPACE+ApprovalScope;
				messageBodyInput.messageSegments.add(textSegmentInput);
				messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
				messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			}

			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = oppId;
			if (!test.isRunningTest()) {
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
			}
		}
	}
			}
			System.debug('Stakeholder info -->'+Remupdate);
		}
		Catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CHATTER_POST_TO_STAKEHOLDER);
		}
	}

	/*
* @desc Chatter post to the Gate participents ,team members inform about the win declation
* @param   opportunities: the map of opportunities which are approved
*/
	public static void WindeclarationNotification(map<Id, Opportunity>opportunitiesMap) {

		Map<ID,Set<ID>> Userinfo= new Map<ID,Set<ID>>();
		String Customer='';
		String Country='';
		try{

			for(Opportunity oppty:opportunitiesMap.values())
			{
	if(oppty.Country__c<>Null)
		Country=oppty.Country__c;

	if(oppty.Account_Name__c<>Null)
		Customer=oppty.Account_Name__c;

	if (!Userinfo.containsKey(oppty.ID)) {
		Userinfo.put(oppty.ID, new Set<ID>());
	}
	Userinfo.get(oppty.ID).add(oppty.OwnerID);
			}

			//oppty team controller
			for(OpportunityTeamMember OpptyTeam:[SELECT Id,UserId,TeamMemberRole,OpportunityId FROM OpportunityTeamMember WHERE TeamMemberRole!=:GlobalConstants.TEAM_ROLE AND OpportunityId=:opportunitiesMap.keyset()])
			{
	if (!Userinfo.containsKey(OpptyTeam.OpportunityId)) {
		Userinfo.put(OpptyTeam.OpportunityId, new Set<ID>());
	}
	Userinfo.get(OpptyTeam.OpportunityId).add(OpptyTeam.UserId);
			}

			// collecting the active offer
			Map<Id,Offer__c> Offerinfo = new Map<Id,Offer__c>([select id,name,Opportunity__c from Offer__c where ActiveOffer__c=True AND Opportunity__c=:opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() ]);
			System.debug(Offerinfo);

			//offer team controller
			for(Offer_Team__c OfferTeam:[SELECT id,Name__c,Offer__c,Team_Member_Role__c FROM Offer_Team__c WHERE Team_Member_Role__c!=:GlobalConstants.TEAM_ROLE AND  Offer__c=:OfferInfo.Keyset()])
			{
	if (!Userinfo.containsKey(OfferInfo.get(OfferTeam.Offer__c).Opportunity__c)) {
		Userinfo.put(OfferInfo.get(OfferTeam.Offer__c).Opportunity__c, new Set<ID>());
	}
	Userinfo.get(OfferInfo.get(OfferTeam.Offer__c).Opportunity__c).add(OfferTeam.Name__c);
			}

			for (Apttus_Approval__Approval_Request__c approvalrequest: [SELECT ID,Apttus_Approval__Assigned_To_Type__c, Apttus_Approval__DateApproved__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Step_Name__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
						FROM Apttus_Approval__Approval_Request__c
						WHERE Apttus_Approval__Step_Name__c!=Null AND Apttus_Approval__Assigned_To_Id__c!=Null AND Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet()
					])
			{
	if (!Userinfo.containsKey(approvalrequest.Apttus_Approval__Object_Id__c)) {
		Userinfo.put(approvalrequest.Apttus_Approval__Object_Id__c, new Set<ID>());
	}

	if(approvalrequest.Apttus_Approval__Assigned_To_Type__c<>Null && approvalrequest.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.USER))
		Userinfo.get(approvalrequest.Apttus_Approval__Object_Id__c).add(approvalrequest.Apttus_Approval__Assigned_To_Id__c);

	if(approvalrequest.Apttus_Approval__Assigned_To_Type__c<>Null && approvalrequest.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.QUEUE))
	{
		for(ID QueueID:getQueueMembers(approvalrequest.Apttus_Approval__Assigned_To_Id__c))
		{
			if(QueueID<>NUll)
				Userinfo.get(approvalrequest.Apttus_Approval__Object_Id__c).add(QueueID);
		}
	}

	//delegates assignment
	if (approvalrequest.Apttus_Approval__DelegateApproverIds__c != null) {
		String[] delegateApproverIds = approvalrequest.Apttus_Approval__DelegateApproverIds__c.split(',');
		for (string delegateapproverId: delegateApproverIds) {
			if (!Userinfo.containsKey(approvalrequest.Apttus_Approval__Object_Id__c)) {
				Userinfo.put(approvalrequest.Apttus_Approval__Object_Id__c, new Set<ID>());
			}
			Userinfo.get(approvalrequest.Apttus_Approval__Object_Id__c).add(delegateapproverId);
		}
	}
			}

			for (ID oppId: Userinfo.keySet()) {
	if (Userinfo.get(OppId) != null) {
		integer NumberOfPost = (integer)((decimal) Userinfo.get(OppId).size() / 24).round(System.RoundingMode.UP);
		integer StartLoop = 0;
		for (integer i = 0; i<NumberOfPost; i++) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			list<Id>lstIds = new list<Id>(Userinfo.get(oppId));

			for (integer j = StartLoop; j<StartLoop + 24; j++) {
				if (lstIds.size()>j) {
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = lstIds[j];
		messageBodyInput.messageSegments.add(mentionSegmentInput);
				}
			}
			StartLoop += 24;
			StartLoop += 24;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentBold;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentBold;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentSpace;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentSpace;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentParagraph;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentParagraph;

			//Tag for Bold
			markupBeginSegmentBold = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			markupEndSegmentBold = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentBold.markupType = ConnectApi.MarkupType.Bold;

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;

			//first line of chatter info
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Win Declaration.';
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// opportunity number
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();

			textSegmentInput.text ='Opportunity Number:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Opportunity_ID__c;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// opportunity name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();

			textSegmentInput.text ='Opportunity Name:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Name;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// Customer name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Customer:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+Customer;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// Country name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Country:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+Country;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// Unweighted Amount
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Unweighted amount:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).CurrencyIsoCode+''+opportunitiesMap.get(oppId).Amount;
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
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Line1
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE1;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
 
			//Line2 //02288601
			textSegmentInput = new ConnectApi.TextSegmentInput();
		   // textSegmentInput.text =GlobalConstants.WIN_POST_LINE2+'\n'+GlobalConstants.WIN_POST_LINE3+'\n\n\n'; //02288601
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE2+'\n';
			messageBodyInput.messageSegments.add(textSegmentInput);
			
			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			
			/*Line3 02288601
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.WIN_POST_LINE3+'\n'; 
			messageBodyInput.messageSegments.add(textSegmentInput);*/
			
			//Line3 //02288601
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);			
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE3;
			messageBodyInput.messageSegments.add(textSegmentInput);			
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//Tag for Next Line //02288601
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE4+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+opportunitiesMap.get(oppId).Gate_6_Bypass_No_Execute_needed__c+'\n\n';
			messageBodyInput.messageSegments.add(textSegmentInput);
			
			//Tag for Next Line //02288601
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			
			//Tag for Next Line //02288601
			/*textSegmentInput = new ConnectApi.TextSegmentInput();		   
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE5; 
			messageBodyInput.messageSegments.add(textSegmentInput);*/
			
			//Line4 //02288601
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);			
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE5;
			messageBodyInput.messageSegments.add(textSegmentInput);			
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			
			//Tag for Next Line //02288601
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			
			//Line 5 //02288601
			/*textSegmentInput = new ConnectApi.TextSegmentInput();		   
			textSegmentInput.text = GlobalConstants.WIN_POST_LINE6; 
			messageBodyInput.messageSegments.add(textSegmentInput);*/
			
			//Line5 //02288601
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);			
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.WIN_POST_LINE6;
			messageBodyInput.messageSegments.add(textSegmentInput);			
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;

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
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER,GlobalConstants.WIN_DECLARATION_NOTIFICATION );
		}
	}

	/*****************************
*Method Name: RecallNotification
*Description:  Chatter Post to All gate Participents and team members to inform about Gate Recall notification
*Parameters: opportunitiesMap
*******************************/
	public static void RecallNotification(map<Id, Opportunity>opportunitiesMap) {

		map<ID, Set<ID>>mapOppIdRelatedUsers = new map<ID, Set<ID>>();
		Map<ID,Apttus_Approval__Approval_Request__c> ApproverInfo =new Map<ID,Apttus_Approval__Approval_Request__c>();
		Boolean G5Check=false;
		String LOALevel='';
		String LoALevelbeforeSTA='';
		String LeadBG='';
		String LeadBU='';
		String SupportingBGsBUs='';
		String Account='';
		String Country='';
		String RecallComments='';
		String wtd_Class='';

		try{
			GlobalConstants.OPPORTUNITY_RECALL_CHECK=True;
			for(Opportunity opptyInfo:opportunitiesMap.values())
			{
	if(opptyInfo.Country__c<>Null)
		Country=opptyInfo.Country__c;

	if(opptyInfo.Approval_Cancel_Info__c<>Null)
		RecallComments=opptyInfo.Approval_Cancel_Info__c;

	if(opptyInfo.Account_Name__c<>Null)
		Account=opptyInfo.Account_Name__c;

	if(opptyInfo.Lead_BG__c<>Null)
		LeadBG=opptyInfo.Lead_BG__c;

	if(opptyInfo.Lead_BU__c<>Null)
		LeadBU=opptyInfo.Lead_BU__c;

	if(opptyInfo.Supporting_BGs_BUs__c <> Null && opptyInfo.Supporting_BGs_BUs__c <> '')
	{
		SupportingBGsBUs = opptyInfo.Supporting_BGs_BUs__c.replaceAll(';',', ');
	}

	if(opptyInfo.LOA_Level__c<>Null)
		LOALevel=opptyInfo.LOA_Level__c;
			}

			Map<Id,Offer__c> Offerinfo = new Map<Id,Offer__c>([select id,name,Opportunity__c,LoA_Level_Before_Trigger_Approval__c, WTD_Case__c  from Offer__c where ActiveOffer__c=True AND Opportunity__c=:opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() ]);
			System.debug(Offerinfo);

			for(Offer__c Offerdata:Offerinfo.values())
			{
	if(Offerdata.LoA_Level_Before_Trigger_Approval__c<>Null)
		LoALevelbeforeSTA=Offerdata.LoA_Level_Before_Trigger_Approval__c;

	if(Offerdata.WTD_Case__c<>Null)
		wtd_Class=Offerdata.WTD_Case__c;
			}

			System.debug('Recall----->');
			// fill the mapOppIdRelatedUsers map by opportunity Owners
			for (Opportunity opp: opportunitiesMap.values()) {
	if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
		mapOppIdRelatedUsers.put(opp.Id, new Set<ID>());
	}
	mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
			}

			// fill the map by opportunity team members
			for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId
				  FROM OpportunityTeamMember
				  WHERE TeamMemberRole!=:GlobalConstants.TEAM_ROLE AND  OpportunityId IN: opportunitiesMap.keySet()
				 ])
			{
	if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
		mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, new Set<ID>());
	}
	if(mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId))
		mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
			}


			//fill the mapOppIdRelatedUsers map by Offer Team
			for(Offer_Team__c OfferTeamMembers: [select id,Offer__c ,Name__c,Offer__r.Opportunity__c from Offer_Team__c where Team_Member_Role__c!=:GlobalConstants.TEAM_ROLE AND  Offer__c=:Offerinfo.keySet() LIMIT: Limits.getLimitQueryRows()  ])

			{
	if (!mapOppIdRelatedUsers.containsKey(OfferTeamMembers.Offer__r.Opportunity__c) && OfferTeamMembers.Name__c<>Null ) {
		mapOppIdRelatedUsers.put(OfferTeamMembers.Offer__r.Opportunity__c, new Set<ID>());
	}
	if(mapOppIdRelatedUsers.containsKey(OfferTeamMembers.Offer__r.Opportunity__c) && OfferTeamMembers.Name__c<>Null )
		mapOppIdRelatedUsers.get(OfferTeamMembers.Offer__r.Opportunity__c).add(OfferTeamMembers.Name__c);
			}

			//collecting the Approver records
			for (Apttus_Approval__Approval_Request__c approvalrequest: [SELECT ID,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Backup_From_User__c, Apttus_Approval__DateApproved__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Step_Name__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
						FROM Apttus_Approval__Approval_Request__c
						WHERE Apttus_Approval__Assigned_To_Id__c<>Null AND Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet()
					])
			{
	if( approvalrequest.NF_Assignee_Type__c<>Null && approvalrequest.Apttus_Approval__DateApproved__c==Null && approvalrequest.Apttus_Approval__Step_Name__c<>Null && approvalrequest.NF_Assignee_Type__c.equalsignorecase(GlobalConstants.APPROVER) && approvalrequest.Apttus_Approval__Step_Name__c.equalsignorecase(Label.G5_CT_Head_Check) && !approvalrequest.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.APPROVED) )
	{
		ApproverInfo.clear();
		System.debug('-->approvalrequest.Apttus_Approval__Step_Name__c'+approvalrequest.Apttus_Approval__Step_Name__c+approvalrequest.Apttus_Approval__Approval_Status__c);
		System.debug(approvalrequest.id);
		ApproverInfo.put(approvalrequest.id,approvalrequest);
		G5Check=true;
	}
	if(G5Check==false)
		ApproverInfo.put(approvalrequest.id,approvalrequest);

			}

			System.debug('Gate Participents Records'+ApproverInfo.keyset());
			// fill the mapOppIdRelatedUsers map by opportunity validators and contributors
			for (Apttus_Approval__Approval_Request__c approvalrequest: ApproverInfo.Values()) {

	if (!mapOppIdRelatedUsers.containsKey(approvalrequest.Apttus_Approval__Object_Id__c)) {
		mapOppIdRelatedUsers.put(approvalrequest.Apttus_Approval__Object_Id__c, new Set<ID>());
	}

	if(approvalrequest.Apttus_Approval__Assigned_To_Type__c<>Null && approvalrequest.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.USER))
		mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(approvalrequest.Apttus_Approval__Assigned_To_Id__c);

	if(approvalrequest.Apttus_Approval__Assigned_To_Type__c<>Null && approvalrequest.Apttus_Approval__Assigned_To_Type__c.contains(GlobalConstants.QUEUE))
	{
		for(ID QueueID:getQueueMembers(approvalrequest.Apttus_Approval__Assigned_To_Id__c))
		{
			if(QueueID<>NUll)
				mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(QueueID);
		}
	}

	if (approvalrequest.Apttus_Approval__DelegateApproverIds__c != null) {
		String[] delegateApproverIds = approvalrequest.Apttus_Approval__DelegateApproverIds__c.split(',');
		for (string delegateapproverId: delegateApproverIds) {
			mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(delegateapproverId);
		}
	}
	if (approvalrequest.Apttus_Approval__Backup_From_User__c != null) {
		mapOppIdRelatedUsers.get(approvalrequest.Apttus_Approval__Object_Id__c).add(approvalrequest.Apttus_Approval__Backup_From_User__c);
	}
			}

			for (ID oppId: opportunitiesMap.keySet()) {
	if (mapOppIdRelatedUsers.get(OppId) != null) {
		integer NumberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / 24).round(System.RoundingMode.UP);
		integer StartLoop = 0;
		for (integer i = 0; i<NumberOfPost; i++) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput ;
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			list<Id>lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));

			for (integer j = StartLoop; j<StartLoop + 24; j++) {
				if (lstIds.size()>j) {
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = lstIds[j];
		messageBodyInput.messageSegments.add(mentionSegmentInput);
				}
			}
			StartLoop += 24;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentBold;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentBold;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentlist;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentlist;

			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentSpace;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentSpace;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentParagraph;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentParagraph;

			//Tag for Bold
			markupBeginSegmentBold = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			markupEndSegmentBold = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentBold.markupType = ConnectApi.MarkupType.Bold;

			//tag for list
			markupBeginSegmentlist = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentlist.markupType = ConnectApi.MarkupType.ListItem;
			markupEndSegmentlist = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentlist.markupType = ConnectApi.MarkupType.ListItem;

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;

			String OfferData='';
			string  Gateinfo1='The approval request for ';
			string  Gateinfo2= ' has been recalled/cancelled';
			//new para graph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//first line of chatter info
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =Gateinfo1+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =opportunitiesMap.get(oppId).Name+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =Gateinfo2;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//salesphase
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Sales Phase:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+opportunitiesMap.get(oppId).StageName;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);
			// New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// Oppty ID
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Opportunity Number:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Opportunity_ID__c;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			// opportunity name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Opportunity Name:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Name;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			// Customer name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Customer:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+Account;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			// Country name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Country:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+Country;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			// Unweighted Amount
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Unweighted value:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).CurrencyIsoCode+''+opportunitiesMap.get(oppId).Amount;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			// New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// LOA Level
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Approval Level:'+GlobalConstants.SPACE; // Label Changed - SF Ticket 00956787
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+LOALevel;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			// LoA Level before STA
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Approval Level before STA:'+GlobalConstants.SPACE; // Label Changed - SF Ticket 00956787
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+LoALevelbeforeSTA;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			//Lead BG
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Lead BG:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE+ LeadBG;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			//Lead BU
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Lead BU:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+LeadBU;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			//Supporting BGs
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Supporting BGs/BUs:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+SupportingBGsBUs;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);

			//WTD Case
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='WTD Case:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			ConnectApi.LinkSegmentinput linksegmentIn = new ConnectApi.LinkSegmentinput();
			if(wtd_Class != ''){
				linksegmentIn.url = wtd_Class;
				messageBodyInput.messageSegments.add(linksegmentIn);
			}
			messageBodyInput.messageSegments.add(markupEndSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Comments
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentlist);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Comments:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+RecallComments;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentlist);
			//New Paragraph

			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//regards scrm
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Regards'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);

			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Nokia Salesforce CRM'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = '&nbsp;';
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			string vallink= URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppId;
			// Opportunity Link
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text ='Opportunity Link:'+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			ConnectApi.LinkSegmentinput linksegment = new ConnectApi.LinkSegmentinput();
			linksegment.url = vallink;
			messageBodyInput.messageSegments.add(linksegment);

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
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.RECALL_NOTIFICATION);
		}
	}

	/*
* @desc the method will be used to sent one copty to OfferController's.
* @param   opportunities: the map of opportunities which are Submitted for G4 or G5 gate
*/
	public static void NotifyOfferController(map<Id, Opportunity>opportunitiesMap) {

		map<Id,ID> GateParticipents= new  map<Id,ID>();
		Map<ID,ID> Teamid= new Map<ID,ID>();
		Set<ID> Userid= new Set<ID>();
		String EmailTemplate;
		String Stepname;
		Map<Id,Offer__c> Offerinfo = new Map<Id,Offer__c>();
		try{
			// collecting the active offer LOA Level information
			for(Offer__c Offerdata:[select id,name,LoA_Approval_Level__c,Opportunity__c,ActiveOffer__c from Offer__c where ActiveOffer__c=true AND Opportunity__c=:opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() ])
			{
	if(opportunitiesMap.get(Offerdata.Opportunity__c).Phase_Status__c<>NULL && opportunitiesMap.get(Offerdata.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G4_APPROVAL))
	{
		if(Offerdata.LoA_Approval_Level__c<>NUll &&(Offerdata.LoA_Approval_Level__c.equalsignorecase('A') || Offerdata.LoA_Approval_Level__c.equalsignorecase('C')  || Offerdata.LoA_Approval_Level__c.equalsignorecase('D') ))
		{
			EmailTemplate=Label.NF_G4_Assignment_Template;
			Offerinfo.put(Offerdata.id,Offerdata);
		}
	}
	else if( ( opportunitiesMap.get(Offerdata.Opportunity__c).Phase_Status__c<>NULL && opportunitiesMap.get(Offerdata.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G5_APPROVAL) ) &&
			(Offerdata.LoA_Approval_Level__c<>NUll && Offerdata.LoA_Approval_Level__c.equalsignorecase('A')) ) {
				EmailTemplate=Label.NF_G5_Assignment_Template;
				Offerinfo.put(Offerdata.id,Offerdata);
			}
			}
			System.debug('>>>>'+EmailTemplate);

			if(!Offerinfo.isEmpty()){
	// collecting the Oppty team
	for(OpportunityTeamMember OpptyTeam :[SELECT UserId, OpportunityId FROM OpportunityTeamMember WHERE TeamMemberRole=:GlobalConstants.OFFER_CONTROL AND OpportunityId=: opportunitiesMap.keySet()])
		Teamid.put(OpptyTeam.UserId,OpptyTeam.UserId);

	//fill the mapOppIdRelatedUsers map by Offer Team
	for(Offer_Team__c OfferTeamMembers: [select id,Offer__c ,Name__c,Offer__r.Opportunity__c from Offer_Team__c where  Team_Member_Role__c=:GlobalConstants.OFFER_CONTROL AND  Offer__c=:Offerinfo.keySet() LIMIT: Limits.getLimitQueryRows()  ])
		Teamid.put(OfferTeamMembers.Name__c,OfferTeamMembers.Name__c);

	//Apttus_Approval__Approval_Status__c
	for(Apttus_Approval__Approval_Request__c ReqInfo:[SELECT ID, Apttus_Approval__DateApproved__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Step_Name__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
				  FROM Apttus_Approval__Approval_Request__c
				  WHERE Apttus_Approval__Step_Name__c!=Null AND Apttus_Approval__Assigned_To_Id__c=Null AND Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet()
				 ])
	{
		if(!ReqInfo.Apttus_Approval__Step_Name__c.contains('Bypass')){
			Stepname=ReqInfo.Apttus_Approval__Step_Name__c;
			for(Id Team:Teamid.Keyset())
				GateParticipents.put(Team,ReqInfo.id);
		}
	}
	System.debug('Gate Participents info'+GateParticipents);
			}

			//  Opportunity Approval/Reject Status to all Aprover User
			if(EmailTemplate<>null && Stepname<>null && !GateParticipents.isEmpty()){

	EmailTemplate et=[SELECT id FROM EmailTemplate WHERE developerName =:EmailTemplate  LIMIT 1];
	List<Messaging.SingleEmailMessage> mail = new List<Messaging.SingleEmailMessage>();
	//collect the delegate users info and sent the email
	for(id GateParticipentsinfo:GateParticipents.Keyset())
	{
		Messaging.SingleEmailMessage GateparticipentsEmail = new Messaging.SingleEmailMessage();
		System.debug('Loop Gate participents Object id'+ GateParticipents.get(GateParticipentsinfo));
		GateparticipentsEmail.setWhatId(GateParticipents.get(GateParticipentsinfo));
		System.debug('Loop Gateparticipents.Id'+GateParticipentsinfo);
		GateparticipentsEmail.setTargetObjectId(GateParticipentsinfo);
		GateparticipentsEmail.setTemplateId(et.id);
		GateparticipentsEmail.setSaveAsActivity(false);
		mail.add(GateparticipentsEmail);
	}

	if(!mail.isEmpty()){
		Messaging.SendEmailResult[] results=Messaging.sendEmail(mail);
		GlobalConstants.OFFER_BOOLEAN_CHECK=True;
		System.debug('Email Result'+results);
	}
			}
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.NOTIFY_OFFER_CONTROLER);
		}
	}

	/*****************************
*Method Name: QueueRecords
*Description:  Get the Que members
*Parameters: ID
*******************************/
	public static List<ID> getQueueMembers(ID QueueID) {
		List<ID> GroupMemberID =new List<ID>();
		try{
			for (GroupMember QueueMemberId: [Select UserOrGroupId From GroupMember where GroupId =:QueueID])
	GroupMemberID.add(QueueMemberId.UserOrGroupId);

			System.debug('Que Members ID ####'+GroupMemberID);
			return GroupMemberID;
		}
		catch(Exception E)
		{
			System.debug('QueueRecords ******'+E.getMessage());
			return GroupMemberID;
		}
	}

	/*
* @desc the method will be used Close the all open task related to the G4 Submission
* @param   opportunities: the map of opportunities
*/
	public static void CloseTheG4SubmissionTask(map<Id, Opportunity>OpptyID) {

		List<Task> TaskClose= new List<Task>();
		try{

			for(Task TaskRec:[SELECT iD,Status,WhatId FROM Task where WhatID=:OpptyID.KeySet() and Subject=:GlobalConstants.MISSING_G4_SUBMISSION and Status=:GlobalConstants.Open Limit:Limits.getLimitQueryRows()])
			{
	TaskRec.Status=GlobalConstants.COMPLETED_OPPTY;
	TaskClose.add(TaskRec);
			}
			System.debug('Task Info'+TaskClose);
			if(!TaskClose.isEmpty())
	Database.update(TaskClose,false);
		}
		catch (Exception ex)
		{  ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CLOSE_THE_G4_SUBMISSION_TASK);

		}
	}

}