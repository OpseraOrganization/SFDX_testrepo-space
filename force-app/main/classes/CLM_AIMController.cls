/**
 * About
 * -----
 * @Description	  : This class contains all the needed functions to handle Agreement Invoicing Milestones in Agreement Related List View
 * @TestClass		: CLM_AIMControllerTest.
 * @Project		  : CLM QTO
 * @Modification Log :
 *  Created  : 2020 11 23 – gyorgyi.kovacs@nokia.com
 *  Modified :
 * -----
**/

public with sharing class CLM_AIMController {

	/**
	* @description: Method to fetch Agreement Invoicing Milestone records for the given Agreement
	* @param: Id of the Agreement record
	* @return: List<CLM_Agreement_Invoicing_Milestone__c> list of AIM records for the given Agreement
	*/
	@AuraEnabled
	public static String getAgreementInvoicingMilestones(Id agreementId) { /* DSI-1857 */
		List<CLM_Agreement_Invoicing_Milestone__c> aims = new List<CLM_Agreement_Invoicing_Milestone__c>();
		try {
			aims = [SELECT Category__c, DP__c, Delivery__c, PAC__c, FAC__c
	FROM CLM_Agreement_Invoicing_Milestone__c
	WHERE Agreement__c = :agreementId
	WITH SECURITY_ENFORCED
	ORDER BY Id ASC];
		} catch (Exception e) {
			//throw new AuraHandledException(e.getMessage());
			ExceptionHandler.addException(e, 'CLM_AIMController', 'getAgreementInvoicingMilestones');
		}
		CLM_AIMWrapper result = new CLM_AIMWrapper(aims, isAgreementUpdateable(), isAIMUpdateable());
		return System.JSON.serialize(result);
	}

	private static Boolean isAgreementUpdateable() { /* DSI-1857 */
		return Schema.sObjectType.Apttus__APTS_Agreement__c.fields.Completion_date_PAC__c.isUpdateable() &&
			Schema.sObjectType.Apttus__APTS_Agreement__c.fields.Completion_date_FAC__c.isUpdateable();
	}

	private static Boolean isAIMUpdateable() { /* DSI-1857 */
		return Schema.sObjectType.CLM_Agreement_Invoicing_Milestone__c.fields.DP__c.isUpdateable() &&
			Schema.sObjectType.CLM_Agreement_Invoicing_Milestone__c.fields.Delivery__c.isUpdateable() &&
			Schema.sObjectType.CLM_Agreement_Invoicing_Milestone__c.fields.PAC__c.isUpdateable() &&
			Schema.sObjectType.CLM_Agreement_Invoicing_Milestone__c.fields.FAC__c.isUpdateable();
	}

	public class CLM_AIMWrapper { /* DSI-1857 */
		public List<CLM_Agreement_Invoicing_Milestone__c> aims;
		public Boolean isAgreementUpdateable;
		public Boolean isAIMUpdateable;

		public CLM_AIMWrapper(List<CLM_Agreement_Invoicing_Milestone__c> pAims, Boolean pIsAgreementUpdateable, Boolean pIsAIMUpdateable) {
			aims = pAims;
			isAgreementUpdateable = pIsAgreementUpdateable;
			isAIMUpdateable = pIsAIMUpdateable;
		}
	}

}