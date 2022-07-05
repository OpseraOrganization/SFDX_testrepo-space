/**
 * Created by vturan on 17/10/2018.
 *
 *
 * Update History
 * --------------

  Updated date: 10 17 2018 - VTURAN, initial version
  Updated date: 1st April 2021 - KM, updated Explanation variable to show the Error in a aesthetic manner.

 */

public with sharing class NCP_SAML_ERROR_COM {

  private static final String INTERFACE_LOG_TYPE_CUSTOMER_SSO_JIT = 'Customers SSO JIT';

  public String ErrorCode { get; set; }
  public String Headline { get; set; }
  public String Explanation { get; set; }
  public String ErrorDescription { get; set; }
  public String ErrorDetails { get; set; }
  private final sObject obj;
  public static boolean IsTrainingUser { get; set; }
  public Map<String, String> attributes {get;set;}

  public NCP_SAML_ERROR_COM(ApexPages.StandardController stdController) {
	obj = (User) stdController.getRecord();
  }
  public PageReference displaySAMLError() {
	Headline = 'Single Sign On Error';
	ErrorCode = ApexPages.currentPage().getParameters().get('ErrorCode');
	ErrorDescription = ApexPages.currentPage().getParameters().get('ErrorDescription');
	ErrorDetails = ApexPages.currentPage().getParameters().get('ErrorDetails');

	String error;
	try {
	  Integer paramsIndex = ErrorDetails.indexOf('{');
	  String paramString = ErrorDetails.substring(paramsIndex);
	  Map<String, Object> err = (Map<String, Object>) JSON.deserializeUntyped(paramString);
	  
	  String userName = (String) err.get('UserName');
	  String errorMessage = (String) err.get('ErrorMessage');
	  Map<String, Object> attributes = (Map<String, Object>) err.get('Attributes');
	  //system.debug('NCP_SAML_ERROR_COM - attributes: '+attributes);
	  
		if (attributes.containsKey('TrainingOnlyUser') && attributes.get('TrainingOnlyUser')=='true')
		{
			IsTrainingUser = TRUE;		 
		}
			
	  Explanation = 'ErrorDescription: ' + ErrorDescription?.escapeHtml4() + ' \n ErrorDetails: ' + errorMessage?.escapeHtml4() + '\n Attributes: ' + '\n  FederationID : ' + attributes.get('FederationID') +
		'\n  Email : ' + attributes.get('emailID') + '\n  Relationship : ' + attributes.get('Relationship');
	
	  NCP_InterfaceLog.insertInterfaceLog(INTERFACE_LOG_TYPE_CUSTOMER_SSO_JIT, 'Inbound', 'Upsert'
	, 'Username: '+userName, 'Failure', errorMessage, Explanation);
	} catch (Exception e) {
	  Explanation = 'ErrorDetails :: ' + ErrorDetails + ' >>> ' + e.getMessage();
	}

	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Single Sign On Error: ' + 'ErrorCode= ' + ErrorCode + ', ErrorDescription: ' + ErrorDescription + ', ErrorDetails: ' + ErrorDetails);
	ApexPages.addMessage(myMsg);

	return null;
  }
}