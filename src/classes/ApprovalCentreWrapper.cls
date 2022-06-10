/****************************************
 * Class Name : ApprovalCentreWrapper
 * Created Date: November 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: April 2018
 * Description : This Class is used in Approval Center class for list of wrppaer class
 *****************************************/
public class ApprovalCentreWrapper {
	@AuraEnabled
	public Boolean notAllowToCreateTask { get; set;}
	@AuraEnabled
	public String gateStep { get; set; }
	@AuraEnabled
	public Object approvalReqDate { get; set; }	
	@AuraEnabled
	public String opportunityName { get; set; }
	@AuraEnabled
	public String opportunityId { get; set; }
	@AuraEnabled
	public String customer { get; set; }
	@AuraEnabled
	public String marketOrCountry { get; set; }
	//BP - F-1961
	@AuraEnabled
	public String WinTheDealLink {get;set;}
	@AuraEnabled
	public String offerNumber { get; set; }
	@AuraEnabled
	public String leadBG { get; set; }
	@AuraEnabled
	public String leadBU { get; set; }
	@AuraEnabled
	public String offerDSO { get; set; }
	@AuraEnabled
	public String offerIRD { get; set; }
	
	@AuraEnabled
	public String supportingBGsBUs { get; set; }
	@AuraEnabled
	public String loaApprovalLevel { get; set; }	
	@AuraEnabled
	public String loaApprovalLevelBeforeSTA { get; set; }
	@AuraEnabled
	public String  approvalRequester { get; set; }
	@AuraEnabled
	public String  approvalRequestId { get; set; }
	@AuraEnabled
	public Boolean  isApprovalRequested { get; set; }
	@AuraEnabled
	public String taskid   { get; set; }
	//approval Informations
	@AuraEnabled
	public String approvalRecommendation { get; set; }
	@AuraEnabled
	public String approvalScope { get; set; }
	@AuraEnabled
	public String offerDescription { get; set; }
	@AuraEnabled
	public String type{ get; set;}
	@AuraEnabled
	public List<Apttus_Approval__Approval_Request__c> approverRecList { get; set; }
	@AuraEnabled
	public List<Apttus_Approval__Approval_Request__c> validatorRecList { get; set; }
	@AuraEnabled
	public String approverPhotoURL { get; set; }
	@AuraEnabled
	public Boolean validatorOrApprover { get; set; }
	@AuraEnabled
	public Boolean validatorEligibilityExpired { get; set;} 
	@AuraEnabled
	public Boolean ValidatonCompletion { get; set;}	
}