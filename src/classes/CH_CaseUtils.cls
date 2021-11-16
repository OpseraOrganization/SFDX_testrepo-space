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
public class CH_CaseUtils {
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
	
	/**
	 * @description : Get a specific Case - NOKIASC-#####
	 * @param	: Id Case
	 * @return	  : Case
	**/
	public static Case getCase(Id caseId) {
		try{
			List<Case> oCase = DM_Case.doSelect(
	'Id, Account.Name, Contact.Name, Contact.CH_ContactType__c, Asset.Name, Entitlement.Name, CH_Problem__c, CH_Problem__r.Subject, ' +
	'CH_NetworkElementAsset__r.Name, ProductId, Product.Name, Product.NCP_Nokia_Product_Id__c, Country__c, ' +
	'CH_Product_Release__c, CH_Product_Release__r.Name, CH_Product_Release__r.CH_NSNLegacyCode__c, ' +
	'CH_Solution__c, CH_Solution__r.Name, CH_Solution__r.NCP_Nokia_Product_Id__c, ' +
	'CH_Product_Module__c, CH_Product_Module__r.Name, CH_Product_Module__r.NCP_Nokia_Product_Id__c, ' +
	'CH_ProductVariant__c, CH_ProductVariant__r.Name, CH_ProductVariant__r.NCP_Nokia_Product_Id__c, ' +
	'CH_SW_Component__c, CH_SW_Release__c, CH_SW_Module__c, CH_SW_Build__c, CH_HW_Component__c, ' +
	'CH_Tag__r.CH_Product__c, CH_Tag__r.CH_IssueType__c, CH_Tag__r.CH_IssueDetails__c, ' +
	'CH_Tag__r.CH_AdditionalDetails__c, CH_ServiceType__c, BusinessHours.Name'
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
}