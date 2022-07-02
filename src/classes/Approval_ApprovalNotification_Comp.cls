/**
* @name  Approval_ApprovalNotification_Comp
* @author
* @since   July 08, 2017
* @desc  This class helps in Approval emails data
* @history
*/


public inherited sharing class Approval_ApprovalNotification_Comp{
  @TestVisible private Opportunity Opp {get; set;}
  @TestVisible private Offer__c Off {get; set;}
  @TestVisible private String CTname {get; set;}
  public String OppId {get; set;}
  public Static String OffId = null;
  @TestVisible private ContentVersion doc {get; set;}
  public Static String LoA_G5 = 'LoA G5 Template';
  public Static String LoA_G4 = 'LoA G4 Template';
  public static List<ContentVersion> g4Doc = null;
  public static List<ContentVersion> g5Doc = null;
  @TestVisible private Opportunity_Group__c OppName {get; set;}
  public Static String deal_Id = null;

  public Approval_ApprovalNotification_Comp(){

  }

  public Opportunity  getOpp() {
	List<Opportunity> Opp_Lst = new List<Opportunity>([Select Id,
		 Opportunity_ID__c,
		 Name,
		 AccountId,
		 Account.Name,
		 // Account.CMD_Credit_Limit__c, 
		 Account.CreditRating__c,
		 Account.CMD_Credit_Limit_Expiry_Date__c,
		 Country__c,
		 End_Customer__c,
		 End_Customer__r.Name,
		 Supporting_BGs_BUs__c,
		 Lead_BG__c,
		 Lead_BU__c,
		 Unweighted_Amount_Opportunity_Currency__c,
		 CurrencyIsoCode,
		 Unweighted_Amount_EUR__c,
		 Amount,
		 Business_Type__c,
		 Description,
		 G4_Planned_Date__c,
		 Probability_to_Win__c,
		 LOA_Level__c,
		 LoA_Level_before_STA__c,
		 Org_L7__c,
		 L7_Name__c,
		 Probability,
		 Opportunity_Gate_Class__c,
		 StageName,
		 Substitute_Opportunity__c,
		 Substitute_Opportunity__r.Name,
		 Committed_Unweighted_Value_in_EUR__c,
		 Upsell_Change_Explanation__c,
		 Upsell_Delta__c,
		 Notes_Comments__c,
		 StrategicContextCompetitiveSituation__c,
		 Likelyhood_to_Win__c
		 From Opportunity
		 Where Id =: OppId ]);
	if( Opp_Lst != null && Opp_Lst.size() > 0){
	  return Opp_Lst[0] ;
	}else{
	  return null;
	}
  }

  public Offer__c getOff() {
	List<Offer__c > Off_Lst = new List<Offer__c >([Select Id,
		Offer_ID__c,
		Offer_Number__c,
		Name,
		Offer_Description__c,
		Price__c,
		CurrencyIsoCode,
		LoA_Approval_Level__c,
		LoA_Level_Before_Trigger_Approval__c,
		Total_Price_At_Approval_Net_Sale__c,
		LoA_Level_Before_STA_G4__c,
		LoA_Level_Before_STA_G5__c,
		LoA_Approval_Level_G4__c,
		Top_5_trigger_1_Name__c,
		Top_5_trigger_1_Level__c,
		Top_5_trigger_1_Category__c,
		Top_5_trigger_2_Category__c,
		Top_5_trigger_2_Level__c,
		Top_5_trigger_2_Name__c,
		Top_5_trigger_3_Category__c,
		Top_5_trigger_3_Level__c,
		Top_5_trigger_3_Name__c,
		Top_5_trigger_4_Category__c,
		Net_Sales_LoA_Base_Case__c,
		Total_LoA_Customer_Net_Price_CNP__c,
		Top_5_trigger_4_Level__c,
		Top_5_trigger_4_Name__c,
		Top_5_trigger_5_Category__c,
		Top_5_trigger_5_Level__c,
		Top_5_trigger_5_Name__c,
		Approval_Scope__c,
		Customer_and_Competitive_Situation__c,
		Customer_Offer_Due_Date__c,
		LoA_Currency__c,
		WTD_Case__c /*BP-FT-1961*/
		From Offer__c
		Where Opportunity__c =: OppId
		And ActiveOffer__c =: true ]);
	System.debug('Loop-->'+ Off_Lst );

	if( Off_Lst != null && Off_Lst.size() > 0){
	  return Off_Lst[0] ;
	}else{
	  return null;
	}

  }

  public String  getCTname() {
	System.debug('xxx OPPID >> '+ OppId );
	List<OpportunityTeamMember> lstOTM = new List<OpportunityTeamMember>([SELECT Id, UserId, OpportunityId, User.Name ,Name
	 FROM OpportunityTeamMember
	 WHERE OpportunityId= : oppId
	 AND TeamMemberRole =:'CT Head']);

	if( lstOTM != null && lstOTM.size() > 0){
   return  lstOTM[0].name != null ? lstOTM[0].name : '' ;
	}else{
	  return null;
	}
  }

  //Construct List of approvalRequests to be shown in a table.
  public List<Apttus_Approval__Approval_Request__c> oppApprovalRequests {
	get{
	  if(String.isNotBlank(oppId)){
  oppApprovalRequests =[
	SELECT
	Apttus_Approval__Step_Name__c,
	Apttus_Approval__Approval_Status__c,
	Apttus_Approval__Date__c,
	Apttus_Approval__Assigned_To_Name__c,
	NF_Assignee_Type__c,
	Apttus_Approval__Actual_Approver__c,
	Apttus_Approval__Approver_Comments__c,
	NF_Role_Name__c,
	NF_Organization_Level__c,
	Apttus_Approval__ActualApproverName__c,
	Apttus_Approval__DelegateApprover__c,
	Delegate_Approvers__c,
	Validator_Status__c,
	Apttus_Approval__DateApproved__c,
	Apttus_Approval__SubmissionComment1__c,
	NF_BG_Attribute__c

	FROM
	Apttus_Approval__Approval_Request__c
	WHERE
	Apttus_Approval__Related_Opportunity__c = :oppId
	AND
	Apttus_Approval__Approval_Status__c != 'Not Submitted'
  ];
	  }
	  return oppApprovalRequests;
	}
	set;
  }

  public ContentVersion getDoc(){

	List<Offer__c> offer_list = new List<Offer__c>([SELECT Id FROM Offer__c
	Where Opportunity__c =: OppId
	And ActiveOffer__c =: true ]);

	if(offer_list != null && offer_list.size() > 0){
	  OffId = offer_list[0].Id;
	}
	System.debug('Offer::> '+OffId);
	Set<String> cdocid_set = new Set<String>();

	if(OffId <> null)
	{
	  for(ContentDocumentLink cdl :[SELECT ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId = :OffId])
	  {
  cdocid_set.add(cdl.ContentDocumentId);
	  }

	  g5Doc = [SELECT ContentDocumentId,Document_Type_POC__c,Id,IsLatest,IsMajorVersion,Title,VersionNumber FROM ContentVersion
	 WHERE Document_Type_POC__c =: LoA_G5 AND ContentDocumentId IN :cdocid_set
	 ORDER BY VersionNumber DESC LIMIT 1];

	  g4Doc = [SELECT ContentDocumentId,Document_Type_POC__c,Id,IsLatest,IsMajorVersion,Title,VersionNumber FROM ContentVersion
	 WHERE Document_Type_POC__c =: LoA_G4 AND ContentDocumentId IN :cdocid_set
	 ORDER BY VersionNumber DESC LIMIT 1];

	  System.debug('loa file::> '+g5Doc);
	  System.debug('loa file::> '+g4Doc);
	}
	if(g5Doc != null && g5Doc.size() > 0)
	{
	  return g5Doc[0];
	}
	else if(g4Doc != null && g4Doc.size() > 0)
	{
	  return g4Doc[0];
	}
	else
	{
	  return null;
	}
  }


  public Opportunity_Group__c getOppName() {

	List<Opportunity_Group__c> oppty_grp = [Select Deal__c
	  FROM Opportunity_Group__c where  Opportunity__c =: OppId
	  and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL LIMIT 1];

	if(oppty_grp != NULL && oppty_grp.size() > 0){

	  deal_Id = oppty_grp[0].Deal__c;
	  System.debug('deal_Id::> '+deal_Id);
	}

	List<Opportunity_Group__c> opp_Grp = [Select Name,Opportunity__c,
	Opportunity__r.Name,
	Opportunity__r.Opportunity_ID__c
	from Opportunity_Group__c where Deal__c=: deal_Id
	and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL
	and Opportunity_Relation__c=: GlobalConstants.MASTER LIMIT 1];

	if(opp_Grp != NULL && opp_Grp.size() > 0)
	{
	  return opp_Grp[0];
	}
	else{
	  return null;
	}
  }

}