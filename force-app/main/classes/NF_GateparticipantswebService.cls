/************************************************************************************************************
Name : NF_ApprovalController
Created Date: FEB Release 2019
Created by: Accenture
Description :IWA Approval Stakeholder Feature - Controller class of NF_Approvalpreview AurA bundle
***************************************************************************************************/
@RestResource(urlMapping='/Gateparticipants/V1/*')
Global with sharing  class NF_GateparticipantswebService {
	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	private static final Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();
	Public static string SALESVAL_MSG='please Fill the Sales value';
	Public static string COSTVAL_MSG='please Fill the Cost value';
	Public static string NOAPPROVAL_MSG='No Approvals needed at this time';
	Public static string IN_EXECUTION='In Execution';
	Public static string SUBMITTED='Submitted';
	Public static string CREATE_OFFERMSG='Please Create an Offer';
	Public static string VALIDLOA_MSG='Please select valid LoA Level';
	Public static string VALIDEX_LOA_MSG='Please select valid Expected LoA Level';
	Public static string G3BYPASS_LOA='Gate 3 Bypass (No offer support)';
	Public static string G6BYPASS_LOA='Gate 6 Bypass (No Execute needed)';
	Public static string G4BYPASS_LOA='G4 Bypass: ';
	Public static string G5BYPASS_LOA='G5 Bypass: ';
	Public static string PTA_FIELDMSG='PTA signed field need to be checked';
	Public static string BYPASS_MSG=' offer condition activated: Approval Stakeholders Preview is empty';
	Public static string G2BYPASS_MSG=' : Approval Stakeholders Preview is empty';
	Public static string GATE_2='Bypass GATE 2';
	Public static string GATE_3='Bypass GATE 3';
	Public static string GATE_4='Bypass GATE 4';
	Public static string GATE_5='Bypass GATE 5';
	Public static string GATE_6='Bypass GATE 6';
	public static boolean gate_bypass=false;
	public static Boolean Onlyquery=false;

	/*****************************************************
	*Method Name: myoppApproval_relatedlist
	*Parameter: Opportunity
	*Description: returns current Opportunity Gate Participants
	************************************************************/
	@Httpget
	global static GAteParticipantsPageseparation myoppApprovalrelatedlist()
	{
		RestRequest request = RestContext.request;
		// grab the recordId from the end of the URL
		String RecordId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
		List<GAteParticipantsPage> GAteParticipantsPagelistv1=new List<GAteParticipantsPage> ();
		GAteParticipantsPageseparation GppSeparation = new GAteParticipantsPageseparation();
		GppSeparation= myoppApproval_relatedlist(RecordId,'Opportunity');

		system.debug('###RecordId-->'+RecordId);
		system.debug('###GAteParticipantsPagelistv1-->'+GAteParticipantsPagelistv1);

		return GppSeparation;
	}

	global static GAteParticipantsPageseparation myoppApproval_relatedlist(string currentRecordId,String Objecttype)
	{

		List<GAteParticipantsPage> GAteParticipantsPagelist=new List<GAteParticipantsPage> ();
		List<Apttus_Approval__Approval_Request__c> approvalRequestList=new List<Apttus_Approval__Approval_Request__c>();
		List<String> USerInApprovals=new List<String>();
		set<String> AV_InApprovals=new set<String>();
		Map<id,User> usernameidMap = new Map<id,User>();
		GAteParticipantsPageseparation GppSeparation = new GAteParticipantsPageseparation();

		string sH_Emailids='';
		string AV_Emailids='';
		string Gateuser_msgval='';
		string Bypass_msgval='';
		boolean Nogate_bypass=false;
		Boolean Ispresales=false;
		Boolean Isexpectedloalevel=false;
		Opportunity currentOpp = [SELECT Id,
	Name,
	StageName,
	Phase_Status__c,
	Opportunity_ID__c,
	LOA_Level__c,
	OwnerId,
	NF_LoA_Bypass__c,
	Business_Type__c,
	OIF_Lines__c,
	Blanket_Approval_Condition__c,
	Gate_3_Bypass_no_offer_support__c,
	Gate_6_Bypass_No_Execute_needed__c,
	PSR_Total_Cost_In_Euro__c,
	PSR_Total_Sales_Value_in_Local_Currency__c,
	PTA_Signed__c,
	Apttus_Approval__Approval_Status__c,
	PSR_LoA_Level__c,
	RecordTypeId,
	(Select Id,LOA_Bypass__c,LoA_Approval_Level__c from Offers__r where ActiveOffer__c = true)
	FROM Opportunity
	WHERE Opportunity_ID__c =: currentRecordId Limit : limitRows];//JOTATR

		system.debug('currentOpp-->'+currentOpp);
		try{
			//check if presales
			if ((currentOpp.RecordTypeId == PSR_ReadOnlyRecordTypeID || currentOpp.RecordTypeId == PSR_EditRecordTypeID))
			{
	Ispresales=true;
	if((currentOpp.StageName.contains(SUBMITTED)))
		Onlyquery=true;
	if(currentOpp.PSR_Total_Cost_In_Euro__c==0)
	{
		Nogate_bypass=true;
		gate_bypass=true;
		Gateuser_msgval=COSTVAL_MSG;
	}
	if(currentOpp.PSR_Total_Sales_Value_in_Local_Currency__c==0)
	{
		Nogate_bypass=true;
		gate_bypass=true;
		Gateuser_msgval=SALESVAL_MSG;
	}

	if(currentOpp.StageName.contains(IN_EXECUTION) || currentOpp.StageName.contains(GlobalConstants.COMPLETED_OPPTY))
	{
		gate_bypass=true;
		Gateuser_msgval=NOAPPROVAL_MSG;
	}
			}

			//check if direct indirect opportunity
			if ((currentOpp.RecordTypeId == directRecordTypeId || currentOpp.RecordTypeId == inDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyIndirectRecordTypeId || !Ispresales))
			{
	system.debug('currentOpp.RecordTypeId-->'+currentOpp.RecordTypeId);
	if(!Ispresales&&(currentOpp.Phase_Status__c.contains(SUBMITTED) &&!currentOpp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL)))
		Onlyquery=true;

	if(currentOpp.StageName.equalsignorecase(GlobalConstants.IDENTIFY_OPPORTUNITY)){
		gate_bypass=true;
		Gateuser_msgval=GATE_2+G2BYPASS_MSG;
	}
	if(currentOpp.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) && currentOpp.Gate_3_Bypass_no_offer_support__c ){
		gate_bypass=true;
		Gateuser_msgval=GATE_3+BYPASS_MSG;
		Bypass_msgval=G3BYPASS_LOA;
	}
	if(currentOpp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE )){
		if(currentOpp.Blanket_Approval_Condition__c != null){
			gate_bypass=true;
			Gateuser_msgval=GATE_5+BYPASS_MSG;
		}
		if( currentOpp.Blanket_Approval_Condition__c != null || ( !currentOpp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION  ) && currentOpp.NF_LoA_Bypass__c>0 && currentOpp.Blanket_Approval_Condition__c == null))
			Bypass_msgval=G5BYPASS_LOA+currentOpp.Offers__r[0].LOA_Bypass__c;
	}
	if(currentOpp.StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY ) && (currentOpp.Gate_6_Bypass_No_Execute_needed__c == true || currentOpp.Blanket_Approval_Condition__c != null ))
	{
		gate_bypass=true;
		Gateuser_msgval=GATE_6+BYPASS_MSG;
		Bypass_msgval=G6BYPASS_LOA;
	}

	if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.EXECUTE_OPPTY) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.COMPLETED_OPPTY) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR))
	{
		gate_bypass=true;
		Gateuser_msgval=NOAPPROVAL_MSG;
	}

	if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER)){

		if(currentOpp.Offers__r.isEmpty()){
			Nogate_bypass=true;
			gate_bypass=true;
			Gateuser_msgval=CREATE_OFFERMSG;
		}
		if(!currentOpp.Offers__r.isEmpty()&& currentOpp.NF_LOA_Bypass__c>0){
			gate_bypass=true;
			Gateuser_msgval=GATE_4+BYPASS_MSG;
			Bypass_msgval=G4BYPASS_LOA+currentOpp.Offers__r[0].LOA_Bypass__c;
		}
		if(!currentOpp.Offers__r.isEmpty()&&!gate_bypass&&GlobalConstants.LOA_BYPASS_LEVEL.equalsignorecase(currentOpp.LOA_Level__c))
		{
			Nogate_bypass=true;
			gate_bypass=true;
			Gateuser_msgval=VALIDLOA_MSG;
		}
	}

	//check or Fill PTA_Signed__c Automatically for Handover (Prepare for Delivery)
	if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.HANDOVER_OPPTY)&&currentOpp.PTA_Signed__c == false&&!currentOpp.Phase_Status__c.contains(SUBMITTED)){
		gate_bypass=true;
		Gateuser_msgval=PTA_FIELDMSG;
	}
			}

			if (!gate_bypass)
			{
	approvalRequestList=validatedApprovalReqlist(currentOpp.Id,Objecttype,Onlyquery);
	if(approvalRequestList==null ||approvalRequestList.isempty())
	{
		Nogate_bypass=true;
		gate_bypass=true;
		Gateuser_msgval=NOAPPROVAL_MSG;
	}
			}

			if  (!gate_bypass)
			{
	for(Apttus_Approval__Approval_Request__c ApprovalReq: approvalRequestList)
	{
		if(!ApprovalReq.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION))
			AV_InApprovals.add(ApprovalReq.Apttus_Approval__Assigned_To_Id__c);

		USerInApprovals.add(ApprovalReq.Apttus_Approval__Assigned_To_Id__c);
		if (ApprovalReq.Apttus_Approval__DelegateApproverIds__c != null) {
			String[] delegateApproverIds = ApprovalReq.Apttus_Approval__DelegateApproverIds__c.split(',');
			for (string delegateapproverId: delegateApproverIds) {
	USerInApprovals.add(delegateapproverId);
	if(!ApprovalReq.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION) )
		AV_InApprovals.add(delegateapproverId);


			}
		}
	}

	for(user userrecord : [Select Id ,Email,FirstName,Name,LastName,IsActive,Nokia_ID__c from User Where id IN: USerInApprovals Limit : limitRows])
	{
		usernameidMap.put(userrecord.Id, userrecord);
		if(!sH_Emailids.contains(userrecord.Email)&&!AV_InApprovals.contains(userrecord.id))
			sH_Emailids=sH_Emailids+userrecord.Email+' ; ';
		if(!AV_Emailids.contains(userrecord.Email)&&AV_InApprovals.contains(userrecord.id))
			AV_Emailids=AV_Emailids+userrecord.Email+' ; ';
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
	String[] delegateApproverIds = ApprovalReqval.Apttus_Approval__DelegateApproverIds__c.split(',');
	for (string delegateapproverId: delegateApproverIds) {
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
			GppSeparation.ApprovalrequestsandUsers=GAteParticipantsPagelist;
			GppSeparation.Gateuser_msg=Gateuser_msgval;
			GppSeparation.Nogatebypass=Nogate_bypass;
			GppSeparation.Bypass_msg=Bypass_msgval;
			GppSeparation.Isexpectedloalevel=Isexpectedloalevel;
			GppSeparation.opportunity=currentOpp;
			GppSeparation.StakeHolder_Emails =sH_Emailids.removeEnd(';');
			GppSeparation.ApproverValidator_Emails =AV_Emailids.removeEnd(';');
		}
		catch(Exception Ex)
		{
			system.debug('###Exception in myoppApproval_relatedlist-->'+Ex.getMessage());
		}

		return GppSeparation;

	}
	global  class GAteParticipantsPage {
		global Apttus_Approval__Approval_Request__c ApprovalRequest {get;set;}
		global User User {get;set;}
		global String DelegateUsers {get;set;}
		global String DelegateUserEmails {get;set;}

	}
	global   class GAteParticipantsPageseparation {
		global List<GAteParticipantsPage> ApprovalrequestsandUsers {get;set;}
		global String Gateuser_msg {get;set;}
		global String Bypass_msg {get;set;}
		global boolean Nogatebypass {get;set;}
		global Opportunity opportunity {get;set;}
		global String StakeHolder_Emails {get;set;}
		global String ApproverValidator_Emails {get;set;}
		global Boolean Isexpectedloalevel {get;set;}
	}

	/*****************************************************
	*Method Name: validatedApprovalReqlist
	*Parameter: Apttus_Approval__Approval_Request__c
	*Description: returns current Opportunity ApprovalRequests
	*****************************************************/
	private  static List<Apttus_Approval__Approval_Request__c> validatedApprovalReqlist(Id currentRecordId,String Objecttype,boolean onlyquery)
	{
		try{
			if(!onlyquery)
	Apttus_Approval.ApprovalsWebService.previewApprovals(Objecttype,currentRecordId);

			List<Apttus_Approval__Approval_Request__c> approvalRequestListval=new List<Apttus_Approval__Approval_Request__c>();
			string WhereClause='Apttus_Approval__Object_Id__c = :currentRecordId And Apttus_Approval__Object_Type__c = :Objecttype AND Apttus_Approval__Assigned_To_Id__c!= null order by Name';
			String soqlQuery ='SELECT Id,NF_Role_Name__c,NF_Assignee_Type__c,NF_BG_Attribute__c,NF_Organization_Level__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__DelegateApproverIds__c FROM Apttus_Approval__Approval_Request__c WHERE ' + whereClause;
			approvalRequestListval = Database.query(soqlQuery);


			return approvalRequestListval;
		}
		catch (Exception ex)
		{
			system.debug('exception++>'+Ex.getMessage());
			return null;
		}
	}



}