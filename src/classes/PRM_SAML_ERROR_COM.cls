/**
 * Created by Priyanka on 26/12/2018.
 *
 *
 * Update History
 * --------------

Updated date: 10 17 2018 - Priyanka , initial version
Updated date: 10 01 2018 - Anukriti

 */

public without sharing class PRM_SAML_ERROR_COM {

	private static final String INTERFACE_LOG_TYPE_Partner_SSO_JIT = 'PRM Partners SSO JIT';

	public String ErrorCode { get; set; }
	public String Headline { get; set; }
	public String Explanation { get; set; }
	public String ErrorDescription { get; set; }
	public String ErrorDetails { get; set; }
	public String ErrorMessage { get; set; }
	private final sObject obj;
	Public static Boolean IsTrainingUser {get;set;}
	
	 /**********************************************************************************************************************
	* Description: Constructor
	**********************************************************************************************************************/ 
	public PRM_SAML_ERROR_COM(ApexPages.StandardController stdController) {
		obj = (User) stdController.getRecord();
	}
	
	/**********************************************************************************************************************
	* author	: Accenture
	* Date	  : Novemember 2018
	* Param	 : 
	* Return	: none
	* Description: Method to display and store Saml Error
	**********************************************************************************************************************/ 
	public PageReference displaySAMLError() {
		Headline = PRMGlobalConstants.Single_Sign_On_Error;
		ErrorCode = ApexPages.currentPage().getParameters().get(PRMGlobalConstants.ErrorCode);
		ErrorDescription = ApexPages.currentPage().getParameters().get(PRMGlobalConstants.ErrorDescription);
		ErrorDetails = ApexPages.currentPage().getParameters().get(PRMGlobalConstants.ErrorDetails);
		Explanation = PRMGlobalConstants.ErrorDescription+': ' + ErrorDescription + ', '+PRMGlobalConstants.ErrorDetails+': ' + ErrorDetails;
		Integer braceIndex = ErrorDetails.LastindexOf('{');
		Integer braceIndex1 = Explanation.LastindexOf('{');
		Integer eIndex = Explanation.indexOf('E');
		String comment = ErrorDetails.substring(braceIndex);
		String InterfaceRequestSent = Explanation.substring(eIndex,braceIndex1);
		Interface_Log__c log =  New Interface_Log__c();
		Map<String, Object> err = (Map<String, Object>) JSON.deserializeUntyped(comment);
		String federationID = (String) err.get(PRMGlobalConstants.FederationID);
		Map<String, Object> attributes = (Map<String, Object>) err.get('Attributes');
		String trainingOnlyvalue='';
		IsTrainingUser=ErrorDetails.contains('UserDoNotAllowedTrainingPurpose');

	   /* try {
		if (attributes.containsKey('TrainingOnlyUser'))
		{
				IsTrainingUser = true;			   
		}
			else{
				IsTrainingUser = false;
			}
		}
		catch (Exception e){
			
		} */
		system.debug('prm attibuty value'+attributes);
		system.debug('prm trianigh value'+IsTrainingUser);
		
		try {
			log.name = PRMGlobalConstants.PRM_Partner_FederationID+federationID;  
			log.Comment__c = comment;
			log.Interface_Type__c = INTERFACE_LOG_TYPE_PARTNER_SSO_JIT;
			log.Message_Type__c = PRMGlobalConstants.Inbound;
			log.Operation_Type__c = PRMGlobalConstants.Upsert_Val;
			log.Status__c = PRMGlobalConstants.Failure;
			log.Interface_Request_Sent__c = InterfaceRequestSent;
			system.debug('log created :'+log);
			Database.insert(log);
		} catch (Exception e) {
			Explanation = PRMGlobalConstants.ErrorDetails+' :: ' + ErrorDetails + ' >>> ' + e.getMessage();
		}

		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,InterfaceRequestSent);
		ApexPages.addMessage(myMsg);

		return null;
	}
}