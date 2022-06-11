@isTest
public class PRM_SAML_ERRORtest{

@isTest static void testPRM_SAML_ERROR(){
	User sysAdminUser = TestDataFactory.createSystemAdminUser();
	sysAdminUser.Nokia_ID__c = '1233444';
	System.runAs(sysAdminUser){
			test.startTest();
			List<User> testuser = TestDataFactory.userCreation(1,'System Administrator');
			insert testuser[0]; 
			PageReference pageRef = Page.PRM_SAML_ERROR;
			
			pageRef.getParameters().put('id',testuser[0].id);
			pageRef.getParameters().put('ErrorCode','aa');
			pageRef.getParameters().put('Headline','aa');
			pageRef.getParameters().put('Explanation','aa');
			pageRef.getParameters().put('TrainingOnlyUser','true');
			pageRef.getParameters().put('ErrorDescription',' Execution error,');
			pageRef.getParameters().put('ErrorDetails','ApexPRMCommunityJITHandler:PRMCommunityJITHandler.JitException: Single Sign On Error: You do not have access to the Nokia Partner Portal For assistance, contact: portal.support @nokia.com {"CustomerName":"Independent Contractor","nsnPrimaryAccountFlag":"true","Relationship":"Customer","FederationID":"B11037164","State":"Maharashtra","SSOPID":"1500809361","ALCR":"0","Street":"Hinjewadi","PostalCode":"2541888","Phone":"+1245648","Lname":"tim","P20":"100000","emailID":"pruitt.tim@radiodale.com","HorizontalFlag":"0","CountryCode":"IN","ApprovalStatus":"Pending","City":"Aurangabad","PersonalID":"B11037164","Fname":"pruitt","Country":"India","MappingId":"B11037164"}');
			pageRef.getParameters().put('ErrorMessage','aa');
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController sc = new ApexPages.StandardController(testuser[0]);
			PRM_SAML_ERROR_COM prmsaml = new PRM_SAML_ERROR_COM(sc);
			PageReference result = prmsaml.displaySAMLError();
			System.assertEquals(null, result);
			test.stopTest();
			
	}
	
	}
}