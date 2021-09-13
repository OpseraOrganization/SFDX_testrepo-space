@istest()
public class IRTermsClassTest
{
	 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}
	  private static testmethod void Test_IRTermsClass()
	 {

			Multi_Language_Terms__c ML1 = new Multi_Language_Terms__c();
			ML1.Name = 'Multi-Language';
			insert ML1;
			PageReference pageRef = Page.IRTandC;
			pageRef.getParameters().put('Language','English' );
			Test.setCurrentPage(pageRef);  
			IRTermsClass controller = new IRTermsClass();
			IRTermsClass.getLanguageTerm('English');
 
	 }

   
}