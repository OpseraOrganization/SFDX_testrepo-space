/****************************************************************
* Class Name : CH_CA_DTO 
* Created Date: 
* Created By: TCS
* Description : This Class is used as wrapper class for WG assignment
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
public class CH_CA_DTO {
	
	public class SearchCriteriaDTO{
		@AuraEnabled public String severity {get;set;}
		@AuraEnabled public List<String> levelOfSupports{get;set;}
		@AuraEnabled public String contract{get;set;}
		@AuraEnabled public String customerId {get;set;}		
		@AuraEnabled public String productId {get;set;}		
		@AuraEnabled public String region {get;set;}
		@AuraEnabled public String customerGroupId {get;set;}		
		@AuraEnabled public String productGroupId {get;set;}		
		@AuraEnabled public String country {get;set;}
		@AuraEnabled public String outage {get;set;}
		@AuraEnabled public List<String> workgroupTypes {get;set;}
		@AuraEnabled public String serviceType {get;set;}
		@AuraEnabled public Boolean schedule {get;set;}
		@AuraEnabled public Boolean activeRules {get;set;}
		@AuraEnabled public String productModule {get;set;}
		@AuraEnabled public String productVariant {get;set;}
		@AuraEnabled public String productRelease {get;set;}
		@AuraEnabled public String solution {get;set;}
		@AuraEnabled public String recordTypeName {get;set;}
		@AuraEnabled public String contractType {get;set;}
		//NOKIASC-34641-variable added to check HWS or SWS case
		@AuraEnabled public Boolean HWSRecordTypeCheck {get;set;}
		@AuraEnabled public String serviceQuoteId {get;set;}
		public SearchCriteriaDTO(){
			schedule = false;
			activeRules = true;
			workgroupTypes = new List<string>();
			levelOfSupports = new List<string>();
			//NOKIASC-34641-Initialize default value for SWS case
			HWSRecordTypeCheck=false;
		}
		
		public List<string> getProductIds(){
			List<string> productIds = new List<string>();
			if (!String.isBlank(productId)){
				productIds.add(productId);
			}
			if (!String.isBlank(productModule)){
				productIds.add(productModule);
			}
			if (!String.isBlank(productVariant)){
				productIds.add(productVariant);
			}
			if (!String.isBlank(productRelease)){
				productIds.add(productRelease);
			}
	   
			return productIds;		
		}
	}
	
	public class WorkgroupMemberDTO {
		@AuraEnabled public Id id {get;set;} 
		@AuraEnabled public String userId {get;set;}
		@AuraEnabled public String name {get;set;}
		@AuraEnabled public String scheduleType{get;set;}
		@AuraEnabled public String role {get;set;}
		@AuraEnabled public String type {get;set;}
		@AuraEnabled public String queueName {get;set;}
		@AuraEnabled public String phone {get;set;}
		@AuraEnabled public String workgroupId {get;set;}
		@AuraEnabled public String workgroupName {get;set;}
		@AuraEnabled public Decimal ruleOrderNumber {get;set;}
		@AuraEnabled public String levelOfSupport {get;set;}
		@AuraEnabled public DateTime lastCaseAssigned {get;set;}
		@AuraEnabled public DateTime lastEngagement {get;set;}
		@AuraEnabled public String email {get;set;}
		@AuraEnabled public String queueEmail {get;set;}
		@AuraEnabled public Decimal roleOrderNumber {get;set;}
		@AuraEnabled public Decimal scheduleTypeOrderNumber {get;set;}
		 
	}
}