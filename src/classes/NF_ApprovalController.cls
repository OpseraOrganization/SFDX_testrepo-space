/************************************************************************************************************
Name : NF_ApprovalController
Created Date: FEB Release 2019
Created by: Accenture
Description :IWA Approval Stakeholder Feature - Controller class of NF_Approvalpreview AurA bundle
***************************************************************************************************/
public without sharing  class NF_ApprovalController {
	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	private static final Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();
	private static final String profileName = [Select Id,Name from Profile where Id=:UserInfo.getProfileId()].Name;

	public static boolean gate_bypass=false;
	public static Boolean Onlyquery=false;
	public static Boolean hiddenEmailbutton=false;

	public static string sH_Emailids='';
	public static string AV_Emailids='';
	public static string Gateuser_msgval='';
	public static string Bypass_msgval='';
	public static boolean Nogate_bypass=false;
	public static Boolean Ispresales=false;
	public static Boolean Isexpectedloalevel=false;

	/*****************************************************
	*Method Name: myoppApproval_relatedlist
	*Parameter: Opportunity
	*Description: returns current Opportunity Gate Participants
	************************************************************/
	@AuraEnabled
	public static  GAteParticipantsPageseparation myoppApproval_relatedlist(Id currentRecordId,String Objecttype,boolean needtorefresh)
	{
		List<GAteParticipantsPage> GAteParticipantsPagelist=new List<GAteParticipantsPage> ();
		List<Apttus_Approval__Approval_Request__c> approvalRequestList=new List<Apttus_Approval__Approval_Request__c>();
		List<String> userInApprovals =new List<String>();
		set<String> av_InApprovals =new set<String>();
		Set<String> USerEmailinApprovals=new Set<String>();
		Map<id,User> usernameidMap = new Map<id,User>();
		GAteParticipantsPageseparation GppSeparation = new GAteParticipantsPageseparation();
		List<String> submittedPhases = new List<String>{GlobalConstants.SUBMITTED_FOR_G2_APPROVAL, GlobalConstants.SUBMITTED_FOR_G6_APPROVAL};

		Opportunity currentOpp = [SELECT
		  Name,
		  Lead_BG__c, Lead_BU__c,
		  StageName,
		  Phase_Status__c,
		  Sales_Outcome__c,
		  Opportunity_ID__c,
		  LOA_Level__c,
		  Account.RecordType.Name,
		  NF_Facilitator_Notified__c,
		  NF_Facilitator_User__c,
		  Facilitator_Delegate_1__c,
		  Facilitator_Delegate_2__c,
		  Facilitator_Delegate_3__c,
		  Facilitator_Backup__c,
		  Queue_Id__c,
		  Queue_Name__c,
		  OwnerId,
		  NF_LoA_Bypass__c,
		  Business_Type__c,
		  OIF_Lines__c,
		  Blanket_Approval_Condition__c,
	Gate_3_Bypass_no_offer_support__c,
		  PSR_GateClass__c,
		  Gate_6_Bypass_No_Execute_needed__c,
		  PSR_Total_Cost_In_Euro__c,
		  PSR_Total_Sales_Value_in_Local_Currency__c,
		  PTA_Signed__c,
		  Account.AccountNumber,
		  probability,
		  Apttus_Approval__Approval_Status__c,
		  PSR_LoA_Level__c,
		  RecordTypeId,
		  CurrencyIsoCode,
		  PSR_Reference_Opportunity__c,
		  PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c,
		  PSR_Pre_Sales_Risk_Opportunity_Type__c,
		  PSR_Cost_BU_NI_FN__c , PSR_Cost_BU_NI_IPRTG__c , PSR_Cost_BU_NI_OPTICS__c , PSR_Cost_BG_MN__c , PSR_Cost_BG_CNS__c, PSR_Cost_BG_NI__c,
		  org_l4__c, Org_L3__c, org_l5__c,
		  SWx_Upsell_Proposal__c, AccountId, Account.Market__c,
		  Unweighted_Amount_EUR__c,


								  Gate_2_Bypass_no_complex_offer__c,
		  isMultiBG__c,
		  (SELECT UserId FROM OpportunityTeamMembers WHERE TeamMemberRole=:GlobalConstants.OFFER_CONTROL),
		  (Select Id,toLabel(LOA_Bypass__c),LoA_Approval_Level__c from Offers__r where ActiveOffer__c = true)
		  FROM Opportunity
		  WHERE Id =: currentRecordId Limit : limitRows];

		Offer__c currentOffer = currentOpp.Offers__r.isEmpty() ? null : currentOpp.Offers__r[0];

		try{
			//check if presales
			if (currentOpp.RecordTypeId == PSR_ReadOnlyRecordTypeID || currentOpp.RecordTypeId == PSR_EditRecordTypeID)
			{
	Ispresales=true;
	String calculatedLoA = currentOpp.PSR_LoA_Level__c;
	List<Opportunity> psroLoACalculated = new List<Opportunity>{currentopp};
	OpportunityTriggerHelper_PreSales.calculatePSROApprovalLevel(psroLoACalculated, new Set<Id>{currentopp.PSR_Reference_Opportunity__c}, null);
	if(calculatedLoA != psroLoACalculated[0].PSR_LoA_Level__c)
	update psroLoACalculated;
	if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.SUBMITTED_FOR_APPROVAL)){
		Onlyquery=true;
	}
	if(currentOpp.PSR_Total_Cost_In_Euro__c==0)
	{
		setBypassParameters(GlobalConstants.FILL_COSTS_INFO_PSRO_MSG, '', true, true);
	}
	if(currentOpp.PSR_Total_Sales_Value_in_Local_Currency__c==0)
	{
		setBypassParameters(GlobalConstants.FILL_SALES_INFO_PSRO_MSG,'', true, true);	}

		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.IN_EXECUTION) || currentOpp.StageName.contains(GlobalConstants.COMPLETED_OPPTY))
		{
			setBypassParameters(GlobalConstants.NO_APPROVALS_NEEDED_MSG,'', false, true);
		}
	}

	//check if direct indirect opportunity
	if (currentOpp.RecordTypeId == directRecordTypeId || currentOpp.RecordTypeId == inDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyIndirectRecordTypeId )
	{
		if( submittedPhases.contains(currentOpp.Phase_Status__c) ){
			Onlyquery=true;
		}
		//Bypass only when not parcial approval

		if(currentOpp.Gate_2_Bypass_no_complex_offer__c){
			setBypassParameters(GlobalConstants.BYPASS_GATE_2_MSG + GlobalConstants.STAKEHOLDERS_PREVIEW_EMPTY_MSG,'', false, true);
		}
		if(currentOpp.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) && currentOpp.Gate_3_Bypass_no_offer_support__c	){
			setBypassParameters(GlobalConstants.BYPASS_GATE_3_MSG + GlobalConstants.BYPASS_STAKEHOLDERS_PREVIEW_EMPTY_MSG,GlobalConstants.G3BYPASS_LOA_MSG, false, true);
		}
		if(currentOpp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE )){
			if(currentOpp.Blanket_Approval_Condition__c != null){
	setBypassParameters(GlobalConstants.BYPASS_GATE_5_MSG + GlobalConstants.BYPASS_STAKEHOLDERS_PREVIEW_EMPTY_MSG,GlobalConstants.G5BYPASS_LOA_MSG + currentOffer.LOA_Bypass__c, false, true);
			} else if( !currentOpp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION ) && currentOpp.NF_LoA_Bypass__c>0 && currentOpp.Blanket_Approval_Condition__c == null){
	Bypass_msgval=GlobalConstants.G5BYPASS_LOA_MSG + currentOffer.LOA_Bypass__c;
			} else if(!currentOpp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION ) && currentOpp.NF_LoA_Bypass__c==0 && currentOpp.Blanket_Approval_Condition__c == null) {
	setBypassParameters(GlobalConstants.GATE_MANAGEMENT_WTD_ERROR,'', true, true);
			}
		}
		if(currentOpp.StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY ) && (currentOpp.Gate_6_Bypass_No_Execute_needed__c == true || currentOpp.Blanket_Approval_Condition__c != null ))
		{
			setBypassParameters(GlobalConstants.BYPASS_GATE_6_MSG + GlobalConstants.BYPASS_STAKEHOLDERS_PREVIEW_EMPTY_MSG,GlobalConstants.G6BYPASS_LOA_MSG, false, true);
		}

		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.EXECUTE_OPPTY) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.COMPLETED_OPPTY) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR))
		{
			setBypassParameters(GlobalConstants.NO_APPROVALS_NEEDED_MSG,'', false, true);
		}
		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER)){
			if(currentOffer == null){
	setBypassParameters(GlobalConstants.CREATE_OFFER_MSG,'', true, true);
			}
			if(currentOffer != null && currentOpp.NF_LOA_Bypass__c>0){
	setBypassParameters(GlobalConstants.BYPASS_GATE_4_MSG + GlobalConstants.BYPASS_STAKEHOLDERS_PREVIEW_EMPTY_MSG,GlobalConstants.G4BYPASS_LOA_MSG + currentOffer.LOA_Bypass__c, false, true);
			}
			if(currentOffer != null && !gate_bypass && GlobalConstants.LOA_BYPASS_LEVEL.equalsignorecase(currentOpp.LOA_Level__c))
			{
	setBypassParameters(GlobalConstants.SELECT_VALID_LOA_LEVEL_MSG,'', true, true);
			}
			if(currentOffer != null && !gate_bypass){
	setBypassParameters(GlobalConstants.GATE_MANAGEMENT_WTD_ERROR,'', true, true);
			}
		}
		//check or Fill PTA_Signed__c Automatically for Handover (Prepare for Delivery)
		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.HANDOVER_OPPTY) && !currentOpp.PTA_Signed__c && !currentOpp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.SUBMITTED_FOR_G6_APPROVAL)){
			setBypassParameters(GlobalConstants.PTA_FIELD_MISSING_MSG,'', false, true);
		}

	}

	if (!gate_bypass)
	{
		approvalRequestList = validatedApprovalReqlist(currentRecordId,Objecttype,Onlyquery);
		if(approvalRequestList == null || approvalRequestList.isempty())
		{
			setBypassParameters(GlobalConstants.NO_APPROVALS_NEEDED_MSG,'', true, true);
		}
		else
		{
			hiddenEmailbutton = showEmailButton(currentOpp, currentOffer);
			for(Apttus_Approval__Approval_Request__c ApprovalReq : approvalRequestList)
			{
	if(!ApprovalReq.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION))
	av_InApprovals.add(ApprovalReq.Apttus_Approval__Assigned_To_Id__c);

	userInApprovals.add(ApprovalReq.Apttus_Approval__Assigned_To_Id__c);
	if (ApprovalReq.Apttus_Approval__DelegateApproverIds__c != null) {
		for (string delegateapproverId: ApprovalReq.Apttus_Approval__DelegateApproverIds__c.split(',')) {
			userInApprovals.add(delegateapproverId);
			if(!ApprovalReq.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION) )
			av_InApprovals.add(delegateapproverId);
		}
	}
			}

			for(user userrecord : [Select Id ,Email,FirstName,Name,LastName,IsActive from User Where id IN: USerInApprovals Limit : limitRows])
			{
	usernameidMap.put(userrecord.Id, userrecord);
	USerEmailinApprovals.add(userrecord.Email);

	if(!sH_Emailids.contains(userrecord.Email)&&!AV_InApprovals.contains(userrecord.id))
	sH_Emailids+=userrecord.Email+' ; ';

	if(!AV_Emailids.contains(userrecord.Email)&&AV_InApprovals.contains(userrecord.id))
	AV_Emailids+=userrecord.Email+' ; ';
			}

			for(Apttus_Approval__Approval_Request__c ApprovalReqval: approvalRequestList)
			{
	string DelegateUserEmails='';
	string DelegateuseNames='';
	if(ApprovalReqval.Apttus_Approval__Assigned_To_Id__c!=null){
		GAteParticipantsPage Gppw = new GAteParticipantsPage();
		Gppw.ApprovalRequest=ApprovalReqval;
		Gppw.User=usernameidMap.get(ApprovalReqval.Apttus_Approval__Assigned_To_Id__c);

		if (ApprovalReqval.Apttus_Approval__DelegateApproverIds__c != null) {
			for (string delegateapproverId: ApprovalReqval.Apttus_Approval__DelegateApproverIds__c.split(',')) {
	USer Userval=usernameidMap.get(delegateapproverId);
	DelegateuseNames=DelegateuseNames+Userval.Name+' / ';
	DelegateUserEmails=DelegateUserEmails+Userval.Email+' / ';
			}
			Gppw.DelegateUsers=DelegateuseNames.removeEnd(' / ');
			Gppw.DelegateUserEmails=DelegateUserEmails.removeEnd(' / ');
		}

		GAteParticipantsPagelist.add(Gppw);
	}
			}
		}
	}

	GppSeparation.GAteParticipantsPageWrapper=GAteParticipantsPagelist;
	GppSeparation.EmailForUsers=USerEmailinApprovals;
	GppSeparation.Gateuser_msgval=Gateuser_msgval;
	GppSeparation.Nogatebypass=Nogate_bypass;
	GppSeparation.HiddenEmailbutton=hiddenEmailbutton;
	GppSeparation.Bypass_msgval=Bypass_msgval;
	GppSeparation.currentopp=currentOpp;
	GppSeparation.sH_Emailids =sH_Emailids.removeEnd(';');
	GppSeparation.AV_Emailids =AV_Emailids.removeEnd(';');
			}
			catch(Exception Ex)
			{
	system.debug('###Exception in myoppApproval_relatedlist-->'+Ex.getMessage());
			}
			return GppSeparation;
		}

		private static void setBypassParameters(String userMsg, String bypassMsg,Boolean noGateBypass, Boolean gateBypass){
			Nogate_bypass=noGateBypass;
			gate_bypass=gateBypass;
			Gateuser_msgval=userMsg;
			Bypass_msgval = bypassMsg;
		}

		public without sharing  class GAteParticipantsPage {
			@AuraEnabled public Apttus_Approval__Approval_Request__c ApprovalRequest {get;set;}
			@AuraEnabled public User User {get;set;}
			@AuraEnabled public String DelegateUsers {get;set;}
			@AuraEnabled public String DelegateUserEmails {get;set;}

		}
		public without sharing  class GAteParticipantsPageseparation {
			@AuraEnabled public List<GAteParticipantsPage> GAteParticipantsPageWrapper {get;set;}
			@AuraEnabled public set<String> EmailForUsers {get;set;}
			@AuraEnabled public String Gateuser_msgval {get;set;}
			@AuraEnabled public String Bypass_msgval {get;set;}
			@AuraEnabled public boolean Nogatebypass {get;set;}
			@AuraEnabled public Opportunity currentopp {get;set;}
			@AuraEnabled public String sH_Emailids {get;set;}
			@AuraEnabled public String AV_Emailids {get;set;}
			@AuraEnabled public Boolean HiddenEmailbutton {get;set;}
		}


		/*****************************************************
		*Method Name: validatedApprovalReqlist
		*Parameter: Apttus_Approval__Approval_Request__c
		*Description: returns current Opportunity ApprovalRequests
		*****************************************************/
		@AuraEnabled
		public static  List<Apttus_Approval__Approval_Request__c> validatedApprovalReqlist(Id currentRecordId,String Objecttype,boolean onlyquery)
		{
			try{
	if(!onlyquery)
	Apttus_Approval.ApprovalsWebService.previewApprovals(Objecttype,currentRecordId);

	String soqlQuery = getAllFieldsSOQL('Apttus_Approval__Approval_Request__c','Apttus_Approval__Object_Id__c = :currentRecordId And Apttus_Approval__Object_Type__c = :Objecttype AND Apttus_Approval__Assigned_To_Id__c!= null order by Name');
	return Database.query(soqlQuery);
			}
			catch (Exception ex)
			{
	system.debug('exception++>'+Ex.getMessage());
	return null;
			}
		}

		/*****************************************************
		*Method Name: Showemailbutton
		*Parameter: Opportunity
		*Description: returns current USer need to have access Send Email button
		*****************************************************/
		@AuraEnabled
		public static  boolean showEmailButton(Opportunity currentOpp, Offer__c currentOffer)
		{
			Id currentUserID = UserInfo.getUserId();
			Set<Id> userSet;
			Boolean checkUser = false;

			try{
	if(GlobalConstants.DEVELOP_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName)){
		checkUser = true;
		userSet = new Set<Id>{currentOpp.Facilitator_Delegate_1__c, currentOpp.Facilitator_Delegate_2__c, currentOpp.Facilitator_Delegate_3__c,currentOpp.Facilitator_Backup__c,currentOpp.OwnerId };
		for(GroupMember members : [Select UserOrGroupId From GroupMember where GroupId =:currentOpp.Queue_Id__c Limit : limitRows]){
			userSet.add(members.UserOrGroupId);
		}
	}
	else if((GlobalConstants.CREATE_OFFER.equalsIgnoreCase(currentOpp.StageName)||GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName))
	&& (GlobalConstants.LOA_Level_A_Plus.equalsIgnoreCase(currentOpp.LOA_Level__c) || GlobalConstants.LOA_Level.equalsIgnoreCase(currentOpp.LOA_Level__c)))
	{
		checkUser = true;
		Set<Id> offerControllersG4 = new set<Id>();
		for (OpportunityTeamMember opportunityTeamMember: currentOpp.OpportunityTeamMembers)
		{
			offerControllersG4.add(opportunityTeamMember.UserId);
		}
		if(currentOffer != null){
			for (Offer_Team__c OfferTeamMembers: [select id,Offer__c ,Name__c,Offer__r.Opportunity__c from Offer_Team__c where Team_Member_Role__c=:GlobalConstants.OFFER_CONTROL AND Offer__c=:currentOffer.Id Limit : limitRows  ])
			{
	offerControllersG4.add(OfferTeamMembers.Name__c);
			}
		}
		if(!offerControllersG4.isEmpty())
		userSet.addAll(getDelegateusers(offerControllersG4));
	}

	if(checkUser){
		if(userSet.contains(currentUserID)|| profileName.equalsIgnoreCase(GlobalConstants.GLOBAL_PROCESS_ADMIN_PROFILE)||profileName.equalsIgnoreCase(GlobalConstants.SYSTEM_AdMINISTRATOR) || profileName.equalsIgnoreCase(GlobalConstants.NOKIA_ADMIN_PROFILE) )
		return true;
		else
		return false;
	}
			}
			catch(Exception Ex)
			{
	system.debug('###Exception in showemailbutton-->'+Ex.getMessage());
			}
			return true;
		}

		/*****************************************************
		*Method Name: getDelegateusers
		*Parameter: Apttus_Approval__Backup_Approver__c
		*Description: returns  USers Backup and Delegate users
		*****************************************************/
		public static set<Id> getDelegateusers(Set<Id> offerControllersG4){
			set<Id> delegatesG4 = new set<Id>();
			try{
	for (Apttus_Approval__Backup_Approver__c delegateInfo:[select id,Apttus_Approval__Current_User__c,Delegate_Approver1__c,Delegate_Approver2__c,Delegate_Approver3__c,Apttus_Approval__Backup_User__c from Apttus_Approval__Backup_Approver__c where Apttus_Approval__IsActive__c=true and Apttus_Approval__InEffect__c=true and
	Apttus_Approval__Current_User__c IN :offerControllersG4 Limit : limitRows])
	{
		delegatesG4 = new set<Id>{delegateInfo.Delegate_Approver1__c,delegateInfo.Delegate_Approver2__c,delegateInfo.Delegate_Approver3__c,delegateInfo.Apttus_Approval__Backup_User__c};
	}
	delegatesG4.addAll(offerControllersG4);
			}
			catch(Exception Ex)
			{
	system.debug('###Exception in getDelegateusers-->'+Ex.getMessage());
			}
			return delegatesG4;
		}
		/*****************************************************
		*Method Name: getAllFieldsSOQL
		*Parameter: objectName,whereClause
		*Description: returns Object fields and values
		*****************************************************/
		public static String getAllFieldsSOQL(String objectName, String whereClause){
			Set<String> approvalFieldSet = new Set<String>();
			String selects = '';
			try{
	if (whereClause == null || whereClause == ''){ return null; }

	// Get a map of field name and field token
	Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
	list<string> selectFields = new list<string>();
	if (fMap != null){
		for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
			Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
			selectFields.add(fd.getName());

			if(fd.getName().containsIgnoreCase('Approval_Status__c')){
	approvalFieldSet.add(fd.getName());
			}
		}
	}
	if (!selectFields.isEmpty()){
		for (string s:selectFields){
			selects += s + ',';
		}
		if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}

	}
			}
			catch(Exception Ex)
			{
	system.debug('###Exception in getAllFieldsSOQL-->'+Ex.getMessage());
			}
			return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
		}

		/*****************************************************
		*Method Name: sendInvite
		*Parameter: tomailids
		*Description: This method is used to send a mail to gate participants
		*****************************************************/
		@AuraEnabled
		public static string sendInvite(string tomailids,string mailbody,string subject,datetime startdate,datetime Enddate,string Location,string ccmailids,string Mailto,boolean SendAttachment) {

			string InviteMethod='REQUEST';
			string Exceptionval;

			list< String> toAddresses=new  list< String>();
			list< String> CCAddresses=new  list< String>();
			string CurrentuserEmail=UserInfo.getUserEmail();
			set< String> Emailaddressset=new  set<String>();

			try{
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	if(tomailids!=null&&tomailids!=''){
		Emailaddressset.clear();
		Emailaddressset.addAll(tomailids.split(';'));
		toAddresses.addAll(Emailaddressset);
		mail.setToAddresses(toAddresses);
	}
	if(ccmailids!=null&&ccmailids!=''){
		Emailaddressset.clear();
		Emailaddressset.addAll(ccmailids.split(';'));
		CCAddresses.addAll(Emailaddressset);
		mail.setCcAddresses(CCAddresses);
	}
	if(Mailto!=null)
	mail.setReplyTo(Mailto);

	if(subject!=null)
	mail.setSubject(subject);

	mail.setBccSender(false);
	mail.setHtmlBody(mailbody);
	if(SendAttachment){
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		attach.filename = 'meeting.ics';
		attach.ContentType = 'text/calendar; charset=utf-8; method=REQUEST';
		attach.inline = true;
		attach.body = invite(Startdate,Enddate,Location,subject,InviteMethod,toAddresses,CCAddresses,Mailto,CurrentuserEmail);
		mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
	}

	if(!test.isRunningTest())
	Messaging.sendEmail(new Messaging.Email[] {mail});

	return 'success';
			}
			catch (Exception ex) {
	system.debug('Exception message-->'+ex.getMessage());
	Exceptionval=ex.getMessage();
	return Exceptionval;
			}
		}

		/*****************************************************
		*Method Name: invite
		*Parameter: startdate,enddate
		*Description: This method is used to return a Calendar for the invite mail
		*****************************************************/
		Public static Blob invite(datetime startdate, datetime enddate,string Location,string subject,string InviteMethod,list<string> tomailids,list<string> ccmailids,string Mailto,string CurrentuserEmail) {
			String txtInvite = '';
			try{

	Integer start_offset = UserInfo.getTimezone().getOffset(startdate);
	Integer End_offset = UserInfo.getTimezone().getOffset(enddate);
	startdate=startdate.addSeconds(-start_offset/1000);
	enddate=enddate.addSeconds(-End_offset/1000);

	string start_date=string.valueOf(startdate);
	string end_date=string.valueOf(enddate);

	start_date=start_date.remove('-');
	start_date=start_date.remove(':');
	string[] start_dates=start_date.split(' ');
	end_date=end_date.remove('-');
	end_date=end_date.remove(':');
	string[] end_dates=end_date.split(' ');

	txtInvite += 'BEGIN:VCALENDAR\n';
	txtInvite += 'PRODID:-//Microsoft Corporation//Outlook 12.0 MIMEDIR//EN\n';
	txtInvite += 'VERSION:2.0\n';
	txtInvite += 'METHOD:REQUEST\n';
	txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
	txtInvite += 'BEGIN:VEVENT\n';
	txtInvite += 'CLASS:PUBLIC\n';
	txtInvite += 'UID:'+CurrentuserEmail+end_dates+start_dates+tomailids+ccmailids+'\n';
	txtInvite += 'SEQUENCE:0\n';
	txtInvite += 'ORGANIZER:'+CurrentuserEmail+'\n';
	txtInvite += 'DTSTAMP:20190114T120000Z\n';
	txtInvite += 'CREATED:20190114T100000Z\n';
	txtInvite += 'DTSTART:'+start_dates[0]+'T'+start_dates[1]+'Z\n';
	txtInvite += 'DTEND:'+end_dates[0]+'T'+end_dates[1]+'Z\n';
	for(String toadd : tomailids){
		txtInvite += 'ATTENDEE;ROLE=REQ-PARTICIPANT:MAILTO:'+toadd+'\n';
	}
	for(String ccadd : ccmailids){
		txtInvite += 'ATTENDEE;ROLE=OPT-PARTICIPANT:MAILTO:'+ccadd+'\n';
	}

	txtInvite += 'LOCATION:'+Location+'\n';
	txtInvite += 'PRIORITY:5\n';
	txtInvite += 'SUMMARY;';
	txtInvite += 'LANGUAGE=en-us:Meeting\n';
	txtInvite += 'TRANSP:OPAQUE\n';
	txtInvite += 'X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server version 08.00.0681.000"><TITLE></TITLE></HEAD><BODY><!-- Converted from text/plain format --></BODY></HTML>\n';
	txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
	txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:1\n';
	txtInvite += 'END:VEVENT\n';
	txtInvite += 'END:VCALENDAR';
			}
			catch(Exception Ex)
			{
	system.debug('###Exception in invite-->'+Ex.getMessage());
			}
			return Blob.valueOf(txtInvite);
		}

	}