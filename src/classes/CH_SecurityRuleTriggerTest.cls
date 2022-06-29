/** 
 * About 
 * ----- 
 * @Description	  : Case Handling SecurityRule Trigger Test Class.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 11 18 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest
public class CH_SecurityRuleTriggerTest {
	private static ServiceContract oServiceContract;
	private static String AccountNumber = 'LE123';
	public static final string ThirdpartySG1='SEC||TEST1||';
	public static final string ThirdpartySG2='SEC||TEST2||';
	
	private static void setupData() {
		//create user
		User adminUser = CH_TestDataFactory.createUser('System Administrator', 'CH_KnowledgeHandler_TL' + 1);
		insert adminUser;
		//Assign Permission set CH_KB_Workgroup_Admin to created user
		PermissionSet oPermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'CH_KB_Workgroup_Admin'];
		system.assert(oPermissionSet !=null);
		system.runAs(adminUser){
			Boolean hasEntitlementScript = true;
			Account oCustomerParentAccount = new Account();
			Id accountRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			oCustomerParentAccount.Name = 'Customer Parent Account';
			oCustomerParentAccount.RecordTypeId = accountRecordType1;
			oCustomerParentAccount.Customer_Compliance__c = 'US_Company';
			insert oCustomerParentAccount; 
			
			// Creation of Account
			Account oAccount = new Account();
			Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			oAccount.Name = 'Parent Account';
			oAccount.RecordTypeId = accountCustomerRecordType;
			oAccount.ParentId = oCustomerParentAccount.id;
			oAccount.AccountNumber = AccountNumber;
			insert oAccount; 
			
			List<Product2> oProductList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
			insert oProductList;
			
			PriceBookEntry oPriceBookEntry = new PriceBookEntry(
	Pricebook2Id = Test.getStandardPricebookId(),
	Product2Id = oProductList[0].id,
	UnitPrice = 0,
	CurrencyIsoCode = 'EUR',
	IsActive = true
			);
			insert oPriceBookEntry;
			
			// Create contract
			oServiceContract = new ServiceContract(
	AccountId = oAccount.Id, 
	Name = 'TestServiceContract',
	CH_CDB_ContractId__c = 'Test',
	CH_EntitlementScript__c = (hasEntitlementScript)?'Header Script':'',
	Pricebook2Id = Test.getStandardPricebookId(),
	NCP_External_Status__c = 'Active'
			);
			insert oServiceContract;
			System.debug('#####'+oServiceContract);
			
			// Create contract
			List<Group> oGroupList = new List<Group>{
	new Group(
		Name = ThirdpartySG1,
		DeveloperName = 'SEC_TEST1',
		Type  = 'Regular'
	),
	new Group(
		Name = ThirdpartySG2,
		DeveloperName = 'SEC_TEST2',
		Type  = 'Regular'
	)
			};
			insert oGroupList;
		}
	}
	
	public testMethod static void testMethod1() {
		setupData() ;
		Test.StartTest();
		List<CH_SecurityRule__c> oSecurityRuleList = new List<CH_SecurityRule__c>();
		oSecurityRuleList.add(new CH_SecurityRule__c(
			CH_OrderofExecution__c = 5000,
			CH_3rdPartySecurityGroup__c = ThirdpartySG1,
			CH_ContractNumber__c = [SELECT Id, ContractNumber FROM ServiceContract WHERE Id = :oServiceContract.Id LIMIT 1].ContractNumber,
			CH_Active__c = true
		));
		oSecurityRuleList.add(new CH_SecurityRule__c(
			CH_OrderofExecution__c = 5001,
			CH_3rdPartySecurityGroup__c = ThirdpartySG1,
			CH_ParentAccountNumber__c = AccountNumber,
			CH_Active__c = true
		));
		insert oSecurityRuleList;
		oSecurityRuleList.get(0).CH_3rdPartySecurityGroup__c = ThirdpartySG2;
		oSecurityRuleList.get(1).CH_3rdPartySecurityGroup__c = ThirdpartySG2;
		update oSecurityRuleList;
		delete oSecurityRuleList;
		Test.StopTest();		 
	}
}