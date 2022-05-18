/**
 * Created by tweinberger on 2019-08-12.
 **/
@isTest
public with sharing class NCP_SAML_ERROR_COM_Test {

	@isTest static void testSamlError() {

		User internalUser = NCP_TestFactory.createInternalUser('internal test', 'test1@nokia.com.dev');
		insert internalUser;

		ApexPages.StandardController sc = new ApexPages.StandardController(internalUser);
		NCP_SAML_ERROR_COM testNCPSANL = new NCP_SAML_ERROR_COM(sc);
		NCP_SAML_ERROR_COM.IsTrainingUser = false ;
		PageReference pageRef = Page.NCP_SAML_ERROR;
		Test.setCurrentPage(pageRef);
		String json = '{"values" : { "UserName":"test","ErrorMessage":"test1","ErrorDescription":"Execution error", "ErrorDetails": "Test Error"} }';
		testNCPSANL.ErrorDetails = json;
		pageRef.getParameters().put('ErrorDetails', json);
		pageRef = testNCPSANL.displaySAMLError();

		system.assertEquals(pageRef,null);

	}
}