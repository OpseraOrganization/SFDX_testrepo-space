/**********
 * Test class: NF_EmailTemplateAttachementsCtrlTest
 * *********/
public class Agreement_ApprovalNotification_Comp{
	
	@TestVisible private Opportunity Opp {get; set;}
	@TestVisible private Offer__c Off {get; set;}
	@TestVisible private String CTname {get; set;}
	public String OppId {get; set;}

	public Agreement_ApprovalNotification_Comp(){
	
	}
	
	public Opportunity  getOpp() {
	List<Opportunity> Opp_Lst = new List<Opportunity>([Select Id,
	Opportunity_ID__c,
	Name,
	AccountId,
	Account.Name,
	Country__c,
	End_Customer__c,
	End_Customer__r.Name,
	Supporting_BGs_BUs__c,
	Lead_BG__c,
	Lead_BU__c,
	Unweighted_Amount_Opportunity_Currency__c,
	CurrencyIsoCode,
	Unweighted_Amount_EUR__c,
	Amount
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
	LoA_Level_Before_Trigger_Approval__c
		 From Offer__c  
		 Where Opportunity__c =: OppId
		 And ActiveOffer__c =: true ]);
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
	Apttus_Approval__ActualApproverName__c
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

}