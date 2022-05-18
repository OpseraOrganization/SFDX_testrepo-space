/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Case Object Utility Class.
 * @TestClass		: CH_CaseUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 12 03 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class CH_CaseUtils {
	public static DML_SObject DM_Case = new DML_SObject(Case.sObjectType);
	
	/**
	 * @description : Get the Standard Case Record Type Id - NOKIASC-#####
	 * @return	  : RecordType Id
	**/
	public static Id getStandardCaseRecordTypeId() {
		return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
	}
	
	/**
	 * @description : Get Virtual Portal Attendant to Set as the owner in the portal case creation - NOKIASC-#####
	 * @return	  : User Id
	**/
	public static Id getVirtualPortalAttendantId(){
		List<User> oUserList = DML_SObject.doQuery('SELECT Id FROM User WHERE Username LIKE "virtual_portal_attendant@%" LIMIT 1');
		return oUserList.get(0).Id;
	}
	
	public static Boolean isOwnerOrTeamMember(Id caseId, Id userId) {
		userId = userId == null ? UserInfo.getUserId() : userId;
		List<CaseTeamMember> oUserCaseTeams = DML_SObject.doQuery('SELECT Id FROM CaseTeamMember WHERE ParentId = "' + caseId + '" AND Member.Id = "' + userId + '"', true);
		List<Case> oCaseOwner = DML_SObject.doQuery('SELECT Id FROM Case WHERE Id = "' + caseId + '" AND OwnerId = "' + userId + '"', true);
		return (!oUserCaseTeams.isEmpty() || !oCaseOwner.isEmpty());
	}
	
	/**
	 * @description : Get a specific Case - NOKIASC-#####
	 * @param	: Id Case
	 * @return	  : Case
	**/
	public static Case getCase(Id caseId) {
		try{
			List<Case> oCase = DM_Case.doSelect(
				'Id, CaseNumber,Status, Subject, Account.Name, Contact.Name, Contact.CH_ContactType__c, Asset.Name, Entitlement.Name, CH_Problem__c, CH_Problem__r.Subject, ' +
				'CH_NetworkElementAsset__r.Name, ProductId, Product.Name, Product.NCP_Nokia_Product_Id__c, product.ProductCode, Country__c, ' +
				'CH_Product_Release__c, CH_Product_Release__r.Name, CH_Product_Release__r.CH_NSNLegacyCode__c, ' +
				'CH_Solution__c, CH_Solution__r.Name, CH_Solution__r.NCP_Nokia_Product_Id__c, ' +
				'CH_Product_Module__c, CH_Product_Module__r.Name, CH_Product_Module__r.NCP_Nokia_Product_Id__c, ' +
				'CH_ProductVariant__c, CH_ProductVariant__r.Name, CH_ProductVariant__r.NCP_Nokia_Product_Id__c, ' +
				'CH_SW_Component__c, CH_SW_Release__c, CH_SW_Module__c, CH_SW_Build__c, CH_HW_Component__c, ' +
				'CH_Tag__r.CH_Product__c, CH_Tag__r.CH_IssueType__c, CH_Tag__r.CH_IssueDetails__c, ' +
				'CH_Tag__r.CH_AdditionalDetails__c, CH_ServiceType__c, BusinessHours.Name, CH_Site__c, CH_CustomerDescription__c'
			).doWhere('Id = "' + caseId + '"').setOptions('LIMIT 1').doQuery();
			return oCase.get(0);
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	
	/**
	 * @description : Do Case DML operations from the Lightning Components - NOKIASC-#####
	 * @param	: String operationType
	 * @param	: Case oCase
	 * @return	  : Id
	**/
	public static Id database(String operationType, Case oCase, Boolean withoutSharing) {
		try {
			if(operationType.equals('insert')) DML_SObject.doInsert(oCase, withoutSharing);
			else if(operationType.equals('update')) DML_SObject.doUpdate(oCase, withoutSharing);
			else if(operationType.equals('delete')) DML_SObject.doDelete(oCase, withoutSharing);
			return operationType.equals('delete')?null:oCase.Id;
		} catch (Exception e) {
			system.debug('###Exception:' + e.getMessage());
			throw new AuraHandledException('Something went wrong! '+ e.getMessage());
		}
	}
	
	/**
	* @description : Get a specific Case - NOKIASC-36145
	* @param	: Id Case
	* @return	  : Case
	**/
	public static Case getCaseData(Id caseId) {
		try{
			Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get('Case').getDescribe().Fields.getMap();
			list<string> selectFields = new list<string>();
			String fields = '';
			if (fMap != null){
				for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
					Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
					selectFields.add(fd.getName());
				}
				if (!selectFields.isEmpty()){
					for (string s:selectFields){
						fields += s + ',';
					}
					if (fields.endsWith(',')){fields = fields.substring(0,fields.lastIndexOf(','));}
				} 
			}
			List<Case> oCase = DM_Case.doSelect(fields+', Product.Name, CH_Solution__r.Name, CH_Product_Release__r.Name, CH_ProductVariant__r.Name, CH_Product_Module__r.Name, CH_SW_Release__r.Name, CH_NetworkElementAsset__r.Name, CH_Problem__r.CH_Root_Cause_Description__c,CH_Problem__r.Steps_to_Reproduce_Issue__c,CH_Problem__r.CH_SummaryofAnalysis__c,CH_Problem__r.CH_ActionTaken__c,CH_Problem__r.CH_PreventiveActions__c,CH_Problem__r.CH_CorrectiveActions__c, Account.Name, Owner.Name, Owner.Phone, Owner.Email, Contact.Name, Contact.Phone, Contact.Email, Entitlement.ServiceContract.Owner.Name, Entitlement.ServiceContract.Owner.Phone, Entitlement.ServiceContract.Owner.Email, (SELECT Id, CH_AttributableParty__c, CH_OutageDurationCause__c, CH_UnitsAffected1__c,CH_UnitsTotal1__c, CH_DurationClassification__c, CH_DurationStartDate__c, CH_DurationEndDate__c, CH_OutageDuration__c from Outage_Durations__r), (Select Id, Name from CH_Attachment__r)'
											   ).doWhere('Id = "' + caseId + '"').setOptions('LIMIT 1').doQuery();
			return oCase.get(0);
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	/****************************************
	* Name : getMilestoneDetails
	* Description : get Target and Completion Date
	* Parameters: caseId
	* Returns : List<CaseMilestone> 
	*****************************************/
	public static List<CaseMilestone> getMilestoneDetails(String caseId) {
		Set<string> MILESTONE_TYPE = new Set<string>{'System Restored','Solution Provided (non-defect)','Solution Provided (defect)','Solution Provided (deferred)'};	
		List<CaseMilestone> csMilestoneLst = new List<CaseMilestone>();
		csMilestoneLst = [SELECT Id,MilestoneType.Name,TargetDate,CompletionDate,MilestoneTypeId FROM CaseMilestone 
											  WHERE CaseId =: caseId AND MilestoneType.name IN : MILESTONE_TYPE
											 AND Case.RecordType.DeveloperName != 'CH_Problem'];
		return csMilestoneLst;
	}
}