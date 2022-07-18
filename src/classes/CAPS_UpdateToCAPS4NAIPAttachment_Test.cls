@isTest
public class CAPS_UpdateToCAPS4NAIPAttachment_Test {
	
	@testSetup
	public static void setup()
	{
		
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.Description__c = 'test custom settings';
		cstObj.SettingValue__c = '3';
		cstObj.Name = 'SpecificTimeForOnhold';
		insert cstObj;
		
		Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
			
		   User dataLoaderUser = new User(
				Lastname='DataLoad' ,
				Firstname='USER',
				Alias = 'DL-OWNER',
				ProfileId = profile.Id,
				Username = System.now().millisecond() + 'DL-OWNER@test.com',
				Email= System.now().millisecond() + 'test2@test.com',
				EmailEncodingKey='UTF-8',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago',
				Nokia_ID__c = 'CHTEST100'
			);
		
		
		
		
		
		integer j = 1;
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		System.runAs(dataLoaderUser){
		insert AccountListNL;
		}
		
		List <Account> AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		System.runAs(dataLoaderUser){
		insert AccountListLE;
		}
		
		List <Contact> ConatctList = new List<Contact>();
		ConatctList = CH_EntitlementTestData.createContactRecord(j,AccountListNL);
		System.runAs(dataLoaderUser){
		insert ConatctList;
		}
		
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(j);
		System.runAs(dataLoaderUser){
		insert productlist;
		}
		
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
		System.runAs(dataLoaderUser){
		insert pricebook;
		}
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List<PricebookEntry> pricebook1 =new List <PricebookEntry>();
		pricebook1 = CH_EntitlementTestData.createCustomPricebookEntryRecord(1, productlist,customPB1.Id);
		System.runAs(dataLoaderUser){
		insert pricebook1;
		}
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
		System.runAs(dataLoaderUser){
		insert ServiceContractlist;	 
		}
		
		List<Asset> assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				  
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = productlist[i].id;
			assetObj.AccountId = AccountListLE[i].id;
			assetObjList.add(assetObj);
		}
		System.runAs(dataLoaderUser){
		insert assetObjList;
			}
		
		ContractLineItem contLine = new ContractLineItem();
		contLine.PricebookEntryId = pricebook1[0].id;
		contLine.Quantity = 55;
		contLine.UnitPrice = 55;
		contLine.ServiceContractId = ServiceContractlist[0].id;
		ContLine.CH_ServiceOffering__c = 'Test';
		contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
		contLine.CH_CDB_EntitlementId__c = '1test';
		contLine.AssetId = assetObjList[0].id;
		System.runAs(dataLoaderUser){
		insert contLine;
		}
		
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = AccountListLE[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test'+ i;
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = contLine.id;
			entiObj.AssetId = assetObjList[i].id;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
			entitlementlist.add(entiObj);
		}
		System.runAs(dataLoaderUser){
		insert entitlementlist;
		}
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entitlementlist[0].id;
		entcon.ContactId = ConatctList[0].id; 
		System.runAs(dataLoaderUser){
		insert entcon;
		}
		
		CH_ProductRelease__c testProductRelease = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productlist[0].Id);
		System.runAs(dataLoaderUser){
		insert testProductRelease;
		}
		
		List<Case> caseObjList = new List<Case>();
		Case caseObj = new Case();
		caseObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaStandardCase').Id;
		caseObj.AccountId =  AccountListLE[0].id;
		caseObj.ProductId = productlist[0].Id;
		caseObj.CH_Product_Release__c = testProductRelease.Id;
		caseObj.Subject = 'Test Case';
		caseObj.Description = 'Test Case';
		caseObj.CH_CAPS_AttachmentMetadatafromNAIP__c='TEST1234';
		caseObj.ContactId = ConatctList[0].id;
		caseObj.Severity__c =  'Minor';
		caseObj.Priority='Low';
		caseObj.Type='Incident';
		caseObj.CH_InitialDiagnosis__c = 'testt';
		caseobj.CH_Outage__c = 'No';
		caseobj.CH_IssueOccurenceDate__c =system.now().addMinutes(-1440);
		caseobj.Origin = 'S2S';
		caseobj.CH_CaseOriginSystem__c ='ptf_fi';
		caseObj.AssetId = assetObjList[0].id;
		caseObj.EntitlementId = entitlementlist[0].id;
		caseObj.ownerId = Userinfo.getUserId();
		caseobj.Reference_Number__c = 'Reference123';
		System.runAs(dataLoaderUser){
		insert caseObj;
		}
		
		List<CH_Attachment__c> attach = CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',caseObj.Id);
		insert attach;
		map<string, List<object>> caseAttacmapToSerialize = new map<string, List<object>>();
		//add you subtype like this
		caseAttacmapToSerialize.put('attachments', attach);
		string jsonstring = JSON.serialize(caseAttacmapToSerialize);
		system.debug('jsonstring####'+jsonstring);
		caseObj.CH_CAPS_AttachmentMetadatafromNAIP__c=jsonstring;
		caseObj.Status = 'Created';
		System.runAs(dataLoaderUser){
		update caseObj;
		}
		system.debug('caseObj####'+caseObj);
		caseObjList.add(caseObj);
		
	}
	
	@isTest
	public static void test() {
		
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.Description__c = 'test custom settings';
		cstObj.SettingValue__c = '3';
		cstObj.Name = 'SpecificTimeForOnhold';
		
		
		CH_Settings__c SendAtt = new CH_Settings__c();
		SendAtt.Name = 'SendAttachmentUpdateToCAPS ';
		SendAtt.SettingValue__c   = 'Yes';
		insert SendAtt;
		
		CH_Settings__c UserInteg = new CH_Settings__c();
		UserInteg.Name = 'UseIntegrtionCusSetUser4MetadataUpdate ';
		UserInteg.SettingValue__c   = 'Yes';
		insert UserInteg;
		
		CH_Settings__c capsSecret = new CH_Settings__c();
		capsSecret.Name = 'CAPSSecret';
		capsSecret.SettingValue__c   = 'MzExMjgwNzk7NGI0NGRiMTk5YjE3ZWtwN2I0MzMxODc=';
		insert capsSecret;
		
		CH_Integration__c Integ = new CH_Integration__c();
		Integ.EnableIntegration__c = true;
		insert Integ;
		Test.startTest();
		Map<Id,Case> OldCaseMap = new Map<Id,Case>();
		 List<case> caseObjList = [SELECT id,CaseNumber,AccountId,Origin,ProductId,CH_Product_Release__c,Subject,Description,CH_CAPS_AttachmentMetadatafromNAIP__c,
					   ContactId,Severity__c,CH_Outage__c,AssetId,EntitlementId,CH_Defect__c,
							  ownerId from case];
		
		
		case casRec = [SELECT id,CaseNumber,AccountId,ProductId,CH_Product_Release__c,Subject,Description,CH_CAPS_AttachmentMetadatafromNAIP__c,
					   ContactId,Severity__c,CH_Outage__c,AssetId,EntitlementId,CH_Defect__c,
					   ownerId from case where Id=:caseObjList[0].Id];
		OldCaseMap.put(casRec.Id,casRec);
		//Code to convert Account to JSON string
		String CaseJsonString = JSON.serialize(casRec);
		string caseJson = '['+CaseJsonString+']';
		system.debug('case Json####'+caseJson);
		
		
		Test.setMock(HttpCalloutMock.class, new Caps_updateNAIPAttachmentcallout_Test(true,caseJson));
		CAPS_UpdateToCAPS4NAIPAttachment.processCAPSAttachment(caseJson,True);
		CAPS_UpdateToCAPS4NAIPAttachment.processProntoAttachments(caseJson,True);
		CAPS_UpdateToCAPS4NAIPAttachment.decideToCallOrNot();
		
		Test.stopTest();
		   
	}
	
}