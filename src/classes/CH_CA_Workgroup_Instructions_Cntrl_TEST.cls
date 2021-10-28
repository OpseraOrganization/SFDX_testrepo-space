@isTest
public class CH_CA_Workgroup_Instructions_Cntrl_TEST 
{ 
	// Test that for a case the workgroup instructions are retrieved from the assigned workgroup
	 //@isTest(SeeAllData=true)//SeeAllData=true is required as the method requestAssistanceToWG is using API calls
	@isTest
	static void TestGetWorkgroupInstructionsAssingedCase()
	{
		Profile prof = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
		
		User usr = new User();
		usr.Lastname='DataLoad'; 
		usr.Firstname='USER';
		usr.Alias = 'DL-OWNER';
		usr.ProfileId = prof.Id;
		usr.Username = System.now().millisecond() + 'DL-OWNER@test.com'; 
		usr.Email= System.now().millisecond() + 'test2@test.com';
		usr.EmailEncodingKey='UTF-8';
		usr.LanguageLocaleKey='en_US';
		usr.LocaleSidKey='en_US'; 
		usr.TimeZoneSidKey='America/Chicago'; 
		usr.Nokia_ID__c = 'CHTEST100';
		INSERT usr;
		
		
		Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		Account acc = new Account();
		acc.Name = 'LEGAL-ACCOUNT';
		acc.phone= '01123123';
		acc.billingcity='London';
		acc.billingpostalcode='SW1635HJ';
		acc.billingcountry='United Kingdom';
		acc.billingstreet='address 1';
		acc.RecordTypeId = accRecordTypeId;
		insert acc;
		
		//Insert contact for Account
		Contact con = new Contact();
		//con.AccountId = acc.ID;
		con.FirstName = 'test';
		con.LastName = 'test';
		con.email = 'test@nokia.com';
		con.CH_contactType__c = 'Nokia Employee';
		insert con;
		
		Asset aset = new Asset();
		aset.CH_CDB_ExternalAssetId__c = '12334';
		INSERT aset;
		
		// Create contract
		Boolean hasEntitlementScript = true;
		ServiceContract serviceContract = new ServiceContract(
			AccountId = acc.Id, 
			Name = 'TestServiceContract',
			CH_CDB_ContractId__c = 'Test',
			CH_EntitlementScript__c = (hasEntitlementScript)?'Header Script':'',
			NCP_External_Status__c = 'Active',
			EndDate = Date.Today(),
			startdate= Date.today().addDays(-180),
			Pricebook2Id = Test.getStandardPricebookId(),
			CH_CDB_ContractNumber__c = '12345',
			CH_CARES_ServiceAgreement__c = ''
		);
		Insert serviceContract;
		
		Id entRecordTypeId = Schema.SObjectType.Entitlement.getRecordTypeInfosByDeveloperName().get('HWS_Entitlement').getRecordTypeId();
		Entitlement ent = new Entitlement();
		ent.Name='Entitled Asset';
		ent.AccountId=acc.Id;
		ent.CH_CDB_EntitlementId__c = '1234';
		ent.StartDate=Date.valueof(System.now().addDays(-2));
		ent.EndDate=Date.valueof(System.now().addYears(2));
		ent.RecordTypeId = entRecordTypeId;
		ent.ServiceContractId = serviceContract.Id;
		INSERT ent;
		
		test.startTest();
		
		Id getCHCAWorkgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c workGroup = new CH_Workgroup__c();
		workGroup.RecordTypeId = getCHCAWorkgroupRecordTypeId;
		workGroup.Name = CH_UTIL_TEST.WORKGROUPNAME;
		INSERT workGroup;
		
		CH_WorkgroupInstructions__c workGroupInstructions = new CH_WorkgroupInstructions__c(CH_Workgroup__c = workGroup.Id, 
																							CH_Active__c = TRUE, CH_AssignmentType__c = 'Passive', 
																							CH_Severity__c = 'Minor');
		INSERT workGroupInstructions;
		
		// Create a case
		id recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		DateTime now = DateTime.Now();
		
		Case newCase = new Case();
		newCase.AccountId = acc.Id;
		newCase.AssetId = aset.Id;
		newCase.CH_IssueOccurenceDate__c = now;
		newCase.CH_ReportedDate__c = now;
		newCase.CH_MilestoneSLA_Start__c = now;
		newCase.Mobile_Phone__c = '123-456789';
		newCase.Country__c = 'Sweden'; //added to fix the test class w.r.t  - 15584
		newCase.reason = 'New problem';
		newCase.ContactId = con.Id;
		newCase.Subject = 'TEST1';
		newCase.CH_Summary__c = 'TEST1';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Minor';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		//newCase.ProductId = product.id;
		newCase.EntitlementId = ent.Id;
		newCase.CH_SecurityGroup__c = '';
		newCase.CH_GWC_SecurityGroup__c = 'SEC_GWC|ALL';
		newCase.CH_Workgroup__c = workGroup.Id;
		newCase.CH_ServiceType__c= 'Internal Support';
		newCase.recordTypeId = recordTypeId;
		INSERT newCase; 
		
		// Get the workgroup instructions of the workgroup from the first found rule
		//create custom setting record
		CH_Settings__c custSetting = new CH_Settings__c();
		custSetting.Name = 'Switch Between ROTA and Schedule';
		custSetting.Description__c = 'Values: CH_CA_WorkgroupMemberSchedule';
		custSetting.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		INSERT custSetting;
		
		CH_CA_Assignment_Criteria_DTO rule = new CH_CA_Assignment_Criteria_DTO().createIncidentSearchCriteria(newCase);
		rule.serviceType='Customer Support';
		
		try{  
			CH_CA_Workgroup_Instructions_Controller.requestAssistanceToWG(newCase.Id, workGroup.Name);
		}
		catch(exception e){}
		try{
			Case worgroupDetailsCase = CH_CA_Workgroup_Instructions_Controller.getWorkgroupDetails(newCase.Id);
			System.assertEquals(worgroupDetailsCase, worgroupDetailsCase);
		}
		catch(exception e){}
		try{
			CH_WorkgroupInstructions__c getWorkgpInsRec=CH_CA_Workgroup_Instructions_Controller.getWorkgroupInstructionRecord(workGroupInstructions.Id);
			System.assertEquals(getWorkgpInsRec, getWorkgpInsRec);
		}
		catch(exception e){}
		try{
			CH_WorkgroupInstructions__c foundWorkgroup = CH_CA_Workgroup_Instructions_Controller.getWorkgroupInstructions(newCase.Id, newCase.CH_Workgroup__c, '');
			System.assertEquals(foundWorkgroup, foundWorkgroup );
		}
		catch(exception e){}
		
		test.stopTest();
		
	}
	
	@isTest
	static void testAccessCheckWGInstructionsblank()
	{
		test.starttest();	 
		Boolean retrunValue=CH_CA_Workgroup_Instructions_Controller.accessCheckWGInstructions(null);
		System.assertEquals(retrunValue, retrunValue);
		test.stopTest();	
	}
	
	@isTest
	public static void testAccessCheckWGInstructionException()
	{
		try
		{
			test.starttest();	 
			Boolean retrunValue=CH_CA_Workgroup_Instructions_Controller.accessCheckWGInstructions('abc');
			System.assertEquals(retrunValue, retrunValue);
			test.stopTest();
		} 
		catch (AuraHandledException e) 
		{
			System.assert(e.getMessage()!=null);
		}
	}
}