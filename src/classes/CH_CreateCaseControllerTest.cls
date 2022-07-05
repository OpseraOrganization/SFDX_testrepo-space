@isTest
public class CH_CreateCaseControllerTest {
	public static final String contName = 'TCS Data';
	public static final String MarketNme = 'Market India';
	public static final String CustSuppt = 'Customer Support';
	public static testMethod void test1() {
		try{
			Profile p = [SELECT Id FROM Profile WHERE Name='CH_Case Handler'];
			UserRole r = [SELECT Id FROM UserRole WHERE Name = 'Engineers'];
			User u = new User();
			u.Alias = 'chcas';
			u.Email = 'chcasehandler1222@testorg.com';
			u.EmailEncodingKey = 'UTF-8';
			u.LastName = 'chcasehandler';
			u.FirstName = 'chcasehandlerestrf';
			u.LanguageLocaleKey='en_US';
			u.localeSidKey='en_US';
			u.ProfileId = p.Id;
			u.UserRoleId = r.id;
			u.TimeZoneSidKey='America/Los_Angeles';  
			u.UserName='chtesdfgfgrgggdsfftuser@testorg.com';
			insert u;
			
			System.runAs(u) {
	CH_EntitlementTestData.createCustomSettingData();
	//Customer RT Account.
	Account accObjCut = new Account();
	accObjCut.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Customer').Id;	 
	accObjCut.Name ='testCut';
	insert accObjCut;
	System.assertNotEquals(accObjCut.Id, null);
	
	//Legal Entity RT Account
	Account accObjLE = new Account();
	accObjLE.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Legal_Entity').Id;	
	accObjLE.Name ='testLE';
	accObjLE.ParentId = accObjCut.id;
	insert accObjLE;
	System.assertNotEquals(accObjLE.Id, null);
	
	//Contact Data with Legal Entity, Mobile , Phone & Status Active
	Contact contObj = new contact();
	contObj.AccountId = accObjCut.id;
	contObj.FirstName = 'Test';
	contObj.LastName = contName;
	contObj.Email = 'chcasehandler1222@testorg.com';
	contObj.Market__c = MarketNme;
	contObj.CH_ContactType__c = 'customer';
	contObj.CurrencyIsoCode = 'EUR';
	ContObj.MobilePhone = '12333';
	ContObj.Contact_Status__c = 'Active';
	Contobj.CH_ContactType__c = 'Customer';
	insert contObj;
	System.assertNotEquals(contObj.Id, null);
	
	//Creating Account Contact Relationship
	AccountContactRelation acr = new AccountContactRelation();
	acr.AccountId = accObjLE.Id;
	acr.ContactId = contObj.Id;
	acr.NCP_Entitlement_Relationship__c = true;
	insert acr;
	System.assertNotEquals(acr.Id, null);
	
	//ELSE Part ----False Data testing
	//Contact Data with Legal Entity, Mobile , Phone & Status Active ---Nokia Employee
	Contact contObj1 = new contact();
	contObj1.AccountId = accObjCut.id;
	contObj1.FirstName = 'Test1';
	contObj1.LastName = contName;
	contObj1.Email = 'testaccount@nokia.com';
	contObj1.Market__c = MarketNme;
	contObj1.CurrencyIsoCode = 'EUR';
	contObj1.MobilePhone = '12333';	
	contObj1.CH_ContactType__c = 'Nokia Employee';
	insert contObj1;
	System.assertNotEquals(contObj1.Id, null);
	
	//Creating Account Contact Relationship
	AccountContactRelation acr1 = new AccountContactRelation();
	acr1.AccountId = accObjLE.Id;
	acr1.ContactId = contObj1.Id;
	acr1.NCP_Entitlement_Relationship__c = true;
	insert acr1;
	System.assertNotEquals(acr1.Id, null);
	
	//Contact Data with Legal Entity, Mobile , Phone & Status Active
	Contact contObj2 = new contact();
	contObj2.AccountId = accObjCut.id;
	contObj2.FirstName = 'Test';
	contObj2.LastName = contName;
	contObj2.Email = 'testaccount1222@aometh.com';
	contObj2.Market__c = MarketNme;
	contObj2.CH_ContactType__c = 'customer';
	contObj2.CurrencyIsoCode = 'EUR';
	contObj2.Contact_Status__c = 'Inactive';
	insert contObj2;
	System.assertNotEquals(contObj2.Id, null);
	
	//Contact Data with Legal Entity, Mobile , Phone & Status Active
	Contact contObj3 = new contact();
	contObj3.AccountId = accObjCut.id;
	contObj3.FirstName = 'Test';
	contObj3.LastName = contName;
	contObj3.Email = 'testaccount1dfg222@aometh.com';
	contObj3.Market__c = MarketNme;
	contObj3.CurrencyIsoCode = 'EUR';
	contObj3.CH_ContactType__c = 'No Relationship';
	insert contObj3;
	System.assertNotEquals(contObj3.Id, null);
	
	test.startTest();
	CH_CreateCaseController.getPickListValuesBasedOnContactType(contObj3.id);
	CH_CreateCaseController.getPickListValuesBasedOnContactType(contObj1.id);
	CH_CreateCaseController.getPickListValuesBasedOnContactType(contObj2.id);
	CH_CreateCaseController.checkRecordLevelAccess(contObj2.id);
	CH_CreateCaseController.checkCreateCaseButtonVisibility(contObj.id);
	CH_CreateCaseController.redirectToCreateCaseFlow(contObj1.id, 'Internal Support');
	CH_CreateCaseController.redirectToCreateCaseFlow(contObj2.id, CustSuppt);
	CH_CreateCaseController.redirectToCreateCaseFlow(contObj.id, CustSuppt);
	CH_CreateCaseController.getPickListValuesBasedOnContactType(contObj.id);
	CH_CreateCaseController.redirectBasedOnServiceType('Internal Support',contObj1.id );
	CH_CreateCaseController.redirectBasedOnServiceType(CustSuppt,contObj.id );
	CH_CreateCaseController.redirectBasedOnServiceType(null,contObj.id );
	CH_CreateCaseController.redirectBasedOnServiceType('Hardware Services',contObj.id );
	CH_CreateCaseController.updateContactDetails('12233', '2556', contObj.id);			
	CH_CreateCaseController.checkFieldAccess('Contact', new Map < String, String > {'Contact_Status__c' => 'Read' ,'CH_Legal_Entity_Name__c' => 'Read', 'MobilePhone' => 'Read', 'Phone' => 'Read' });
	CH_CreateCaseController.redirectToCreateCaseFlow(Null, Null);
	test.stopTest();
			} 
		}catch(Exception e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
	}   
}