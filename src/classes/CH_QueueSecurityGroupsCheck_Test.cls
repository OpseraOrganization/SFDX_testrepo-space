@isTest(seeAllData = false)
public class CH_QueueSecurityGroupsCheck_Test {
	
	@TestSetup
	public static void testDataFactory(){	
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsActive = true AND IsDefault = true];
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		
		Map<String, Id> accRecordTypes = new Map<String, Id>(); 
		for (RecordType accrt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :'Account']) { 
			accRecordTypes.put(accrt.Name, accrt.Id); 
		}
		Id RecTypeIdacc = accRecordTypes.get('Legal Entity');
		Id RecTypeIdCussacc = accRecordTypes.get('Customer'); 
		Id RecTypeIdProsacc = accRecordTypes.get('Prospect');	
		
		Map<String, Id> CaseRecordTypes = new Map<String, Id>();
		for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :'Case']) { 
			CaseRecordTypes.put(rt.Name, rt.Id); 
		}
		Id RecTypeIdStandard = CaseRecordTypes.get('Nokia Standard Case');
		Id RecTypeIdProblem = CaseRecordTypes.get('Problem');
		Id RecTypeIdIncidentRest = CaseRecordTypes.get('Nokia Incident with Restoration');
		Id RecTypeIdInfoRequest = CaseRecordTypes.get('Nokia Information Request');
		
		
		List<Account> testAccs = new List<Account>();
		List<Case> testCases = new List<Case>();
		List<Asset> testAsts = new List<Asset>();
		List<Contact> testCons = new List<Contact>();
		List<Entitlement> testEntls = new List<Entitlement>();
		List<Product2> prodRecds = new List<Product2>();  
		List<CH_Workgroup__c> WgrpRecds = new List<CH_Workgroup__c>();
		
		
		Account testacc = new Account(Name = 'AccTesting');
		testacc.Country__c = 'India';
		testacc.CountryCode__c = 'IN'; 
		testacc.recordtypeid = RecTypeIdacc;
		testAccs.add(testacc);
		insert testAccs;
		
		Product2 prodRc = new Product2();
		prodRc.Name = 'Par Prod';
		prodRc.DataUsage__c = 'CARES';
		prodRc.PMD_Portfolio_Classification__c = 'Solution';
		prodRc.ProductCode = '1234';
		insert prodRc;
		
		Product2 prodRec = new Product2();
		prodRec.Name = 'Test Prod';
		prodRec.DataUsage__c = 'CARES';
		prodRec.PMD_Portfolio_Classification__c = 'Product';
		prodRec.CH_ParentProductId__c = prodRc.id;
		prodRec.ProductCode = '12345';
		prodRecds.add(prodRec);
		insert prodRecds;
		
		Account testProcacc = new Account(Name = 'Testing');
		testProcacc.Country__c = 'India';
		testProcacc.CountryCode__c = 'IN'; 
		testProcacc.ShippingCountry = 'India';
		testProcacc.ShippingCity = 'HYD';
		testProcacc.ShippingCountryCode = 'IN';
		testProcacc.ShippingState = 'Telangana';
		testProcacc.ShippingPostalCode = '5000032';
		testProcacc.ShippingStreet = 'DLF';
		testProcacc.BillingCity = 'Hyderabad';
		testProcacc.BillingStreet = 'DLF';
		testProcacc.BillingCountry = 'India';
		testProcacc.RecordTypeId = RecTypeIdProsacc;
		insert testProcacc;
		
		Contact testcon = new Contact();
		testcon.LastName = 'Mickey';
		testcon.FirstName = 'Mouse';
		testcon.Phone = '955';
		testcon.Email = 'Testing@tcs.com';
		testcon.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
		testcon.CH_PreferredMtdOfServiceCommunication__c = 'Email';
		testcon.accountId = testProcacc.Id;
		testcon.CH_Legal_Entity_Name__c = 'test';
		testCons.add(testcon);
		insert testCons; 
		
		List<Product2> productlist =new List<Product2>();
		Product2 prodObj = new Product2();
		prodObj.Name ='Test';
		prodObj.ProductCode ='133-047489_0';
		prodObj.DataUsage__c = 'CARES';
		prodObj.PMD_Portfolio_Classification__c = 'Product';
		prodObj.NCP_CAREACTIVATE__c ='Test';
		prodObj.DataUsage__c='CARES';
		prodObj.NCP_CAREACTIVATE__c='Test';
		prodObj.CH_ParentProductId__c=prodObj.Id;
		//prodObj.CH_Valid__c =True;
		productlist.add(prodObj);
		insert productlist;
		
		Id pricebook2Id = Test.getStandardPricebookId();
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		PricebookEntry standardPrice = new PricebookEntry();
		standardPrice.Pricebook2Id= pricebook2id;
		standardPrice.Product2Id= productlist[0].id;
		standardPrice.UnitPrice = 10000;
		standardPrice.IsActive = true;
		pricebook.add(standardPrice);
		insert pricebook;
		
		Pricebook2 customPB = new Pricebook2();
		customPB.Name = 'Nokia CARE Price Book';  
		customPB.IsActive = true;
		insert customPB;
		
		List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
		
		PricebookEntry customPrice = new PricebookEntry();
		customPrice.Pricebook2Id= customPB.id;
		customPrice.Product2Id= productlist[0].id;
		customPrice.UnitPrice = 10000;
		customPrice.IsActive = true;
		Custompricebook.add(customPrice);
		insert Custompricebook;
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		
		ServiceContract serContract =new ServiceContract();
		//	  serContract.RecordTypeId = RecTypeIdser;
		serContract.AccountId = testacc.id;
		serContract.Name = 'TCS Service Contract TestData';
		serContract.CurrencyIsoCode='EUR';
		serContract.CH_CDB_ContractId__c = '123456test';
		serContract.CH_CDB_PreviousContractId__c = '123456test';
		serContract.StartDate = system.today();
		serContract.EndDate = system.today()+10;
		serContract.Pricebook2Id = customPB.id;
		ServiceContractlist.add(serContract);
		insert ServiceContractlist;
		
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		
		ContractLineItem contLine = new ContractLineItem();
		// contLine.CH_BusinessHourName__c = stdBusinessHours.Id;
		contLine.PricebookEntryId = Custompricebook[0].id;
		contLine.Quantity = 55;
		contLine.UnitPrice = 55;
		contLine.ServiceContractId = ServiceContractlist[0].id;
		ContLine.CH_ServiceOffering__c = 'Test';
		contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
		contLine.CH_CDB_EntitlementId__c = '1test';
		ContractLineItemList.add(contLine);   
		
		insert ContractLineItemList;
		
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
		Asset testAst = new Asset();
		testAst.Name = 'Test Asset' ;
		testAst.RecordTypeId = assetRecordTypeId;
		testAst.ContactId = testcon.Id;
		testAst.AccountId = testacc.Id;
		testAst.CH_CDB_ExternalAssetId__c = 'ExtId Test';
		testAsts.add(testAst);
		insert testAsts;
		
		Entitlement tstEntle = new Entitlement();
		tstEntle.Name= 'Test Entitlement';
		tstEntle.AssetId = testAst.id;
		tstEntle.accountId = testProcacc.Id;
		tstEntle.CH_CDB_EntitlementId__c = 'Test';
		tstEntle.ContractLineItemId = ContractLineItemList[0].id;
		tstEntle.ServiceContractId = ServiceContractlist[0].id;
		tstEntle.StartDate = System.today();
		tstEntle.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
		testEntls.add(tstEntle);
		insert testEntls;		
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = tstEntle.id;
		entcon.ContactId = testcon.id;
		insert entcon;
		Group testGroup = new Group();
		testGroup.Name = 'GWC';
		testGroup.type = 'queue';
		insert testGroup; 
		/*Group gwcRec = [select name from Group where name = 'GWC'];
System.debug('GWC id val'+gwcRec.Id);
string gwcQueue = gwcRec.Id;
*/
		CH_Workgroup__c workGrp = new CH_Workgroup__c();
		workGrp.Name = 'Test';
		WgrpRecds.add(workGrp);
		insert WgrpRecds;
		test.startTest();
		Case tstCase = new Case();
		tstCase.recordtypeid = RecTypeIdProblem;
		tstCase.AccountId = testacc.id;
		tstCase.AssetId = testAst.id;
		tstCase.Subject = 'Case Testing';
		tstCase.Description = 'Case Testing';
		tstCase.Severity__c = 'Major';
		tstCase.CH_InitialDiagnosis__c = 'testt';
		tstCase.CH_Solution__c = prodRc.id;
		tstCase.Country__c = 'India';
		tstCase.CH_CurrentWorkGroup__c = workGrp.id;
		tstCase.CH_Outage__c = 'No';
		tstCase.CH_ServiceType__c = 'Customer Support';
		tstCase.Status = 'Draft';
		// tstCase.CH_Stage__c = 'Register';
		tstCase.EntitlementId = tstEntle.id;
		tstCase.ProductId = prodRec.id;
		tstCase.ContactId = testcon.Id;
		tstCase.CH_IssueOccurenceDate__c = system.today(); 
		testCases.add(tstCase);
		insert testCases;
		//case owner as queue
		
		
		List<CH_BlacklistRecords__c> listRecds = New List<CH_BlacklistRecords__c>();
		
		CH_BlacklistRecords__c blkRecord = new CH_BlacklistRecords__c();
		blkRecord.name = 'Sales_Targets_Schedule_Trigger_1';
		blkRecord.CH_AccountNames__c = 'Nokia GDC Chennai';
		blkRecord.CH_ProductCodes__c = '833-002636';
		listRecds.add(blkRecord);
		insert listRecds;	
		test.stopTest();
	}
	
	@isTest
	public static void testmethod1(){
		
		Map<id, Case> oldMap = new Map<id, Case>();
		Map<id, String> userNames = new Map<id, String>();
		Map<id, List<String>> pubgrpMap = new Map<id, List<String>>();
		List<Case> lstCase = new List<Case>();
		Set<id> lstusr = new Set<Id>();
		List<User> lstusrRec = new List<User>();
		List<Case> caseList ;
		List<String> userPgList = new  List<String>(); 
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		
		User u = new User(firstname = 'Future', lastname = 'User',
						  alias = 'future', defaultgroupnotificationfrequency = 'N',
						  digestfrequency = 'N', email = 'test@test.org',
						  emailencodingkey = 'UTF-8', languagelocalekey='en_US', 
						  localesidkey='en_US', profileid = p.Id, 
						  timezonesidkey = 'America/Los_Angeles',
						  username = 'testSecuser@test.org',
						  userpermissionsmarketinguser = false,
						  userpermissionsofflineuser = false);
		lstusr.add(u.id);
		lstusrRec.add(u);
		insert(u);
		//user 2
		
		userNames.put(u.id, u.name);
		List<string> GList = new List<string>();
		List<String> GMList = new List<String>();
		System.runAs(u) {
			
			Group testGroup = new Group();
			testGroup.Name = 'SEC_Default';
			testGroup.DeveloperName = 'ABC2';
			GList.add(testGroup.name);
			INSERT testGroup;
			
			
			
			GroupMember GM = new GroupMember();
			GM.GroupId = testGroup.id;
			GM.UserOrGroupId = U.Id;
			// GMList.add(GM);
			insert GM; 
			
			
			//pubgrpMap.put(u.Id, GMList); 
			caseList = [select id, ownerId, CH_securityGroup__c,recordtype.name,CH_GWC_securityGroup__c , recordType.DeveloperName from Case where Subject = 'Case Testing'];		
			system.debug('caseList  values '+caseList );
			if(caseList != null){
				for(Case cs:caseList){
					cs.OwnerId = u.id;
					lstCase.add(cs);
				}
			}
		}	
		update lstCase;
		
		
		for(Case cas:lstCase){			
			oldMap.put(cas.id, cas);			
		}
		system.debug('oldMap  values '+oldMap);
		CH_CaseTriggerHelper.queueSecurityGroupsCheck(caseList, oldMap);
	}
	
	@isTest
	public static void testmethod2(){   
		Map<id, List<String>> pubgrpMap = new Map<id, List<String>>();
		List<Case> lstCase = new List<Case>();
		Map<id, Case> oldMap = new Map<id, Case>();
		Set<string> queueIds = new Set<string>();
		List<string> GList = new List<string>();
		List<String> GMList = new List<String>();
		List<Case> caseList;
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User u2 = new User(firstname = 'Future', lastname = 'User',
						   alias = 'future', defaultgroupnotificationfrequency = 'N',
						   digestfrequency = 'N', email = 'test@test.org',
						   emailencodingkey = 'UTF-8', languagelocalekey='en_US', 
						   localesidkey='en_US', profileid = p.Id, 
						   timezonesidkey = 'America/Los_Angeles',
						   username = 'testSecuser1@test.org',
						   userpermissionsmarketinguser = false,
						   userpermissionsofflineuser = false);
		insert(u2);
		
		System.runAs(u2) {  
			//queue insert
			Group testGroup2 = new Group();
			testGroup2.Name = 'GWC';
			testGroup2.type = 'queue';
			testGroup2.DeveloperName = 'GWC12';
			INSERT testGroup2;
			system.debug('GWC queue det'+testGroup2);
			//public group insert
			Group testGroup = new Group();
			testGroup.Name = 'SEC_GWC|ALL';
			testGroup.type ='Regular';
			testGroup.DeveloperName = 'ABC4';
			INSERT testGroup;
			Group testGroup3 = new Group();
			testGroup3.Name = 'SEC_Default';
			testGroup3.type ='Regular';
			testGroup3.DeveloperName = 'ABC12';
			INSERT testGroup3;
			
			//user public group assignment
			GroupMember GM2 = new GroupMember();
			GM2.GroupId = testGroup.id;
			GM2.UserOrGroupId = u2.Id;
			insert GM2; 
			GroupMember GM4 = new GroupMember();
			GM4.GroupId = testGroup3.Id;
			GM4.UserOrGroupId = u2.Id;
			insert GM4;
			//user queue assignment 
			GroupMember GM3 = new GroupMember();
			GM3.GroupId = testGroup2.id;
			GM3.UserOrGroupId = u2.Id;
			insert GM3; 
			
			system.debug('GM2 public groupdet'+GM2);
			//pubgrpMap.put(u2.Id, GList);
			List<groupmember> grp =[select UserOrGroupId,group.name from groupmember ];
			system.debug('user realted public groups'+grp);
			caseList = [select id, owner.name, CH_securityGroup__c, CH_GWC_securityGroup__c from Case where Subject = 'Case Testing']; 
			system.debug('caseList  values'+caseList );
			system.debug('caseList  values testGroup2'+testGroup2.name+':'+testGroup2.type+':'+testGroup2.id);	
			if(caseList != null){
				for(Case cs:caseList){
					cs.OwnerId = testGroup2.Id;
					lstCase.add(cs);
				}
			}
		}
		system.debug('lstCase fdsgdsdg'+lstCase);
		
		try{
			if(lstCase.size()>0){
				update lstCase;
			}
			system.debug('lstCase After'+lstCase);
			for(Case cas:caseList){			
				oldMap.put(cas.id, cas);			
			}
			system.debug('oldMap test'+oldMap);
			CH_CaseTriggerHelper.queueSecurityGroupsCheck(caseList, oldMap);
		}
		catch ( Exception ex) {
			
			System.debug(ex.getMessage() ); 
			System.debug(ex.getStackTraceString() );
		}
		system.debug('oldMap test'+oldMap);
		//CH_CaseTriggerHelper.queueSecurityGroupsCheck(caseList, oldMap);
		
	} 
	
}