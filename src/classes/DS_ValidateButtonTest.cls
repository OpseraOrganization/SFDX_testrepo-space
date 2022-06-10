/****************************************
* Name : DS_ValidateButton
* Author : Accenture
* Description : Test class DS_ValidateButton
*****************************************/

@IsTest
private class DS_ValidateButtonTest {
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id rmpRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	
	static testmethod void ValidateTest(){
		Test.startTest();
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//Create Digital Proposal
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.Sold_To_Party__c=accObj.Id;
		upsellProposal.RecordTypeID=swxRecordTypeId;
		database.insert(UpsellProposal);
		DS_ValidateButton.initialLoad(UpsellProposal.id);
		DS_ValidateButton.getDigitalProposal(UpsellProposal.Id);
		DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,'Ready for conversion','Validated','Test Reason');
		
		
		Test.stopTest();
	}
	
	
	static testmethod void ValidateRMPTest(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//Create Digital Proposal
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='RMP';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.RecordTypeID=rmpRecordTypeId;
		upsellProposal.Sold_To_Party__c = accObj.Id;
		database.insert(UpsellProposal);
		
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		
		insert upsellItem2;
		
		Interface_Log__c InterfaceLog = new Interface_Log__c();
		InterfaceLog.Message_Type__c = 'Outbound';
		InterfaceLog.Interface_Type__c = 'DS Southbound';  
		InterfaceLog.Status__c = 'Success';
		InterfaceLog.Operation_Type__c = 'Update';
		InterfaceLog.Status__c ='Failure';
		
		database.insert(InterfaceLog);
		
		DS_Eccenca_Integration__c dsCS =  new DS_Eccenca_Integration__c();
		dsCS.baseURL__c = 'https://idsprodkubeu4.eccenca.com/dataplatform/oauth/token';
		dsCS.endpointURL__c = 'https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload';
		dsCS.grant_type__c  = 'password';
		dsCS.client_id__c = 'eldsClient';
		dsCS.client_secret__c  = 'secret';
		dsCS.username__c  = 'userB';
		dsCS.password__c = 'userB';
		dsCS.failure_code__c ='400,401';
		dsCS.Name= 'APIDetail';
		insert dsCS;
		
		DS_ValidateButton.initialLoad(UpsellProposal.id);
		DS_ValidateButton.getDigitalProposal(UpsellProposal.Id);
		DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,'Validated','Validated','Test Reason');
		//DS_ValidateButton.CallingRESTAPI(UpsellProposal.Id);  
		ID jobID = System.enqueueJob(new SWMPCalloutClass(UpsellProposal.Id));	  
		DS_ValidateButton.InsertFile(UpsellProposal.id);
		//DS_ValidateButton.UploadFile(UpsellProposal.id,);
		
		
		//delete upsellProposal;
		//DS_ValidateButton.initialLoad(UpsellProposal.id);
		Test.stopTest();
	}
	
	
	static testmethod void ValidateRMPTestNegative(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//Create Digital Proposal
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='RMP';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.RecordTypeID=rmpRecordTypeId;
		upsellProposal.Sold_To_Party__c=accObj.Id;
		database.insert(UpsellProposal);
		
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		
		insert upsellItem2;
		
		Interface_Log__c InterfaceLog = new Interface_Log__c();
		InterfaceLog.Message_Type__c = 'Outbound';
		InterfaceLog.Interface_Type__c = 'DS Southbound';  
		InterfaceLog.Status__c = 'Success';
		InterfaceLog.Operation_Type__c = 'Update';
		InterfaceLog.Status__c ='Failure';
		
		database.insert(InterfaceLog);
		
		DS_Eccenca_Integration__c dsCS =  new DS_Eccenca_Integration__c();
		dsCS.baseURL__c = 'https://idsprodkubeu4.eccenca.com/dataplatform/oauth/token';
		dsCS.endpointURL__c = 'https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload';
		dsCS.grant_type__c  = 'password';
		dsCS.client_id__c = 'eldsClient';
		dsCS.client_secret__c  = 'secret';
		dsCS.username__c  = 'userB';
		dsCS.failure_code__c ='400,401';
		dsCS.password__c = 'userB';
		dsCS.Name= 'APIDetail';
		insert dsCS;
		
		DS_ValidateButton.initialLoad(UpsellProposal.id);
		DS_ValidateButton.getDigitalProposal(UpsellProposal.Id);
		DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,'Reject','Close-Reject','Test Reason');
		//DS_ValidateButton.CallingRESTAPI(UpsellProposal.Id);
		ID jobID = System.enqueueJob(new SWMPCalloutClass(UpsellProposal.Id));
		
		
		
		//delete upsellProposal;
		//DS_ValidateButton.initialLoad(UpsellProposal.id);
		Test.stopTest();
	}
	
	@isTest static void testCallout() {
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGeneratorForSuccess());
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		Id rmpRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
		
		//Create Digital Proposal
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(2,accObj)[0];
		UpsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		UpsellProposal.Analytics_Source__c='RMP';
		UpsellProposal.Proposal_Recommendation_Type__c='renewal';
		UpsellProposal.P20_Id__c=215616;
		UpsellProposal.CurrencyIsoCode='EUR';
		UpsellProposal.Unweighted_Value__c=429052.07;
		UpsellProposal.Account_ID__c=accObj.Id;
		UpsellProposal.RecordTypeID=rmpRecordTypeId;
		UpsellProposal.Sold_To_Party__c=accObj.Id;
		database.insert(UpsellProposal);
		
		SWx_Upsell_Proposal__c UpsellProposal1=TestDataFactory.upsellList(1,accObj)[0];
		UpsellProposal1.Analytics_File_Refer_ID__c='GBR-61940-82356';
		UpsellProposal1.Analytics_Source__c='RMP';
	   UpsellProposal1.Proposal_Recommendation_Type__c='renewal';
	   UpsellProposal1.P20_Id__c=215616;
		UpsellProposal1.CurrencyIsoCode='EUR';
		UpsellProposal1.Unweighted_Value__c=429052.07;
		UpsellProposal1.Account_ID__c=accObj.Id;
		UpsellProposal1.RecordTypeID=rmpRecordTypeId;
		UpsellProposal1.Sold_To_Party__c=accObj.Id;
		database.insert(UpsellProposal1);
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'Test55';
		productObj2[1].ProductCode = 'Test3333355';
		database.insert(productObj2);
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		insert upsellItem2;
		
		SWx_Upsell_Items__c upsellItem3 = TestDataFactory.createUpsellItem(1,UpsellProposal1)[0];		
		upsellItem3.Sales_Item_Code__c = productObj2[1].id;
		upsellItem3.SWx_Upsell_Proposal__c = UpsellProposal1.id;
		
		insert upsellItem3;
		//creating interface log object
		
		Interface_Log__c InterfaceLog = new Interface_Log__c();
		InterfaceLog.Message_Type__c = 'Outbound';
		InterfaceLog.Interface_Type__c = 'DS Southbound';  
		InterfaceLog.Status__c = 'Success';
		InterfaceLog.Operation_Type__c = 'Update';
		InterfaceLog.Status__c ='Failure';
		
		database.insert(InterfaceLog);		
		
		DS_Eccenca_Integration__c dsCS =  new DS_Eccenca_Integration__c();
		dsCS.baseURL__c = 'https://idsprodkubeu4.eccenca.com/dataplatform/oauth/token';
		dsCS.endpointURL__c = 'https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload';
		dsCS.grant_type__c  = 'password';
		dsCS.client_id__c = 'eldsClient';
		dsCS.client_secret__c  = 'secret';
		dsCS.username__c  = 'userB';
		dsCS.password__c = 'userB';
		dsCS.failure_code__c ='400,401';
		dsCS.Name= 'APIDetail';
		dsCS.successcode__c = '200';
		insert dsCS;
		test.startTest();
		DS_ValidateButton.initialLoad(UpsellProposal.id);
		DS_ValidateButton.getDigitalProposal(UpsellProposal.Id);
		DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,'Validated','Validated','Test Reason');
		SWMPCalloutClass.httpRequestGenerator('POST','https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload','test','Test');
		//DS_ValidateButton.CallingRESTAPI(UpsellProposal.Id);
		//DS_ValidateButton.CallingRESTAPI(null);	  
		ID jobID = System.enqueueJob(new SWMPCalloutClass(UpsellProposal.Id));
		ID jobID2 = System.enqueueJob(new SWMPCalloutClass(UpsellProposal1.Id));
		ID jobID1 = System.enqueueJob(new SWMPCalloutClass(null));	  
		test.stopTest();
	}
	
	
	
	@isTest static void testCalloutWithException() {
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGeneratorForSuccess());
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		Id rmpRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
		
		//Create Digital Proposal
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='RMP';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.RecordTypeID=rmpRecordTypeId;
		upsellProposal.Sold_To_Party__c=accObj.Id;
		database.insert(UpsellProposal);
		
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		
		insert upsellItem2;
		//creating interface log object
		
		Interface_Log__c InterfaceLog = new Interface_Log__c();
		InterfaceLog.Message_Type__c = 'Outbound';
		InterfaceLog.Interface_Type__c = 'DS Southbound';  
		InterfaceLog.Status__c = 'Success';
		InterfaceLog.Operation_Type__c = 'Update';
		InterfaceLog.Status__c ='Failure';
		
		database.insert(InterfaceLog);		
		
		DS_Eccenca_Integration__c dsCS =  new DS_Eccenca_Integration__c();
		//dsCS.baseURL__c = 'https://idsprodkubeu4.eccenca.com/dataplatform/oauth/token';
		//dsCS.endpointURL__c = 'https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload';
		dsCS.grant_type__c  = 'password';
		dsCS.client_id__c = 'eldsClient';
		dsCS.client_secret__c  = 'secret';
		dsCS.username__c  = 'userB';
		dsCS.password__c = 'userB';
		dsCS.failure_code__c ='400,401';
		dsCS.Name= 'APIDetail';
		//dsCS.successcode__c = 200;
		//insert dsCS;
		test.startTest();
		DS_ValidateButton.initialLoad(UpsellProposal.id);
		DS_ValidateButton.getDigitalProposal(UpsellProposal.Id);
		DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,'Validated','Validated','Test Reason');
		SWMPCalloutClass.httpRequestGenerator('POST','https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload','test','Test');
		//SWMPCalloutClass.(UpsellProposal.Id);
		//SWMPCalloutClass(null);   
		ID jobID = System.enqueueJob(new SWMPCalloutClass(UpsellProposal.Id));
		ID jobID1 = System.enqueueJob(new SWMPCalloutClass(null));
		test.stopTest();
	}
	
	/*   @isTest
static void updateEntitlementStatusTest()
{
DS_ValidateButton.initialLoad(null);
Test.startTest();
Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());

Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
//Create Digital Proposal
List<Account> acclist = TestDataFactory.createAccount(2);
Account accObj = acclist[0];
database.insert(accObj);
Account obj2 = acclist[1];
obj2.Name='Legal Entinty Account For';
obj2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
obj2.ParentId = accObj.Id;
obj2.AccountNumber = '100006843';
insert obj2;
System.debug('*************sold to party*******************'+obj2);

SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
upsellProposal.Analytics_File_Refer_ID__c='CXM000001-SmokeTest1irty';
upsellProposal.Analytics_Source__c='RMP';
upsellProposal.Proposal_Recommendation_Type__c='renewal';
upsellProposal.P20_Id__c=215616;
upsellProposal.CurrencyIsoCode='EUR';
upsellProposal.Unweighted_Value__c=429052.07;
upsellProposal.Account_ID__c=accObj.Id;
upsellProposal.RecordTypeID=rmpRecordTypeId;
upsellProposal.Sold_To_Party__c=Obj2.Id;
upsellProposal.Entitlement_Info__c=CSWXGlobalConstant.CanBeEntitled;
database.insert(UpsellProposal);

List<product2> productObj2 = TestDataFactory.productCreation(1);
productObj2[0].ProductCode = 'Test55';
database.insert(productObj2);

SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
upsellItem2.Bundle_ID__c = productObj2[0].id;
upsellItem2.Sales_Item_Code__c = productObj2[0].id;
upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
upsellItem2.Entitlement_Status__c= CSWXGlobalConstant.CanBeEntitled;

insert upsellItem2;

Interface_Log__c InterfaceLog = new Interface_Log__c();
InterfaceLog.Message_Type__c = 'Outbound';
InterfaceLog.Interface_Type__c = 'DS Southbound';  
InterfaceLog.Status__c = 'Success';
InterfaceLog.Operation_Type__c = 'Update';
InterfaceLog.Status__c ='Failure';

database.insert(InterfaceLog);

DS_Eccenca_Integration__c dsCS =  new DS_Eccenca_Integration__c();
dsCS.baseURL__c = 'https://idsprodkubeu4.eccenca.com/dataplatform/oauth/token';
dsCS.endpointURL__c = 'https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload';
dsCS.grant_type__c  = 'password';
dsCS.client_id__c = 'eldsClient';
dsCS.client_secret__c  = 'secret';
dsCS.username__c  = 'userB';
dsCS.password__c = 'userB';
dsCS.Name= 'APIDetail';
insert dsCS;

Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
commercialEntitlement.Parent_Account__c = accObj.Id;
commercialEntitlement.Product_Name__c = productObj2[0].id;
commercialEntitlement.Sold_To_Party__c = obj2.Id;
database.insert(commercialEntitlement);

DS_ValidateButton.updateEntitlementStatus(UpsellProposal.Id);
//DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,CSWXGlobalConstant.VALIDATED,null,'Test Reason');
Test.stopTest();
}*/
	
	@isTest
	static void getUpdateStatusValidateTest()
	{
		DS_ValidateButton.initialLoad(null);
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//Create Digital Proposal
		List<Account> acclist = TestDataFactory.createAccount(2);
		Account accObj = acclist[0];
		database.insert(accObj);
		Account obj2 = acclist[1];
		obj2.Name='Legal Entinty Account For';
		obj2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		obj2.ParentId = accObj.Id;
		obj2.AccountNumber = '100006843';
		insert obj2;
		System.debug('****************************sold to party parent******************************************************* '+obj2.Parent);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='CXM000001-SmokeTest1irty';
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.RecordTypeID=swxRecordTypeId;
		upsellProposal.Sold_To_Party__c=obj2.Id;
		upsellProposal.Entitlement_Info__c=CSWXGlobalConstant.CanBeEntitled;
		database.insert(UpsellProposal);
		
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		upsellItem2.Quantity__c=20;
		
		insert upsellItem2;
		
		DS_Eccenca_Integration__c dsCS =  new DS_Eccenca_Integration__c();
		dsCS.baseURL__c = 'https://idsprodkubeu4.eccenca.com/dataplatform/oauth/token';
		dsCS.endpointURL__c = 'https://idsprodkubeu4.eccenca.com/dataintegration/workflow/workflows/cmem/notify_subscription2/executeOnPayload';
		dsCS.grant_type__c  = 'password';
		dsCS.client_id__c = 'eldsClient';
		dsCS.client_secret__c  = 'secret';
		dsCS.username__c  = 'userB';
		dsCS.password__c = 'userB';
		dsCS.failure_code__c ='400,401';
		dsCS.Name= 'APIDetail';
		insert dsCS;
		
		Opportunity oppty;
		oppty = TestDataFactory.OpportunityCreation(1,accObj)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord1.Sold_to_party__c = obj2.id;
		cpoRecord1.Payer__c = obj2.id;
		cpoRecord1.Contract_start_date__c = system.today();
		cpoRecord1.Contract_end_date__c=system.today()+365;
		cpoRecord1.Terms__c = 12;
		cpoRecord1.WBS__c='Test_WBS';
		cpoRecord1.Apttus_Config2__BillToAccountId__c = obj2.id;
		cpoRecord1.Apttus_Config2__ShipToAccountId__c = obj2.id;
		cpoRecord1.Sales_Org__c = 'Test';
		cpoRecord1.Sales_Office__c = 'Test';
		cpoRecord1.Sales_Group__c = 'Test';
		cpoRecord1.Distribution_Channel__c = 'Test';
		cpoRecord1.Division__c = 'Test';
		//  cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		//cpoRecord1.Grand_Total__c = 230;
		cpoRecord1.CurrencyIsoCode ='EUR';
		//cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
		cpoRecord1.PO_number__c = '12564';
		cpoRecord1.Apttus_Config2__PODate__c =system.today();
		cpoRecord1.Comments__c = 'test';
		cpoRecord1.Contract_Type_Name__c ='Contract';
		cpoRecord1.Business_category__c = '2G';
		cpoRecord1.Reporting__c ='Excl contr from OBL';
		cpoRecord1.Master_contract__c = 'NA';
		cpoRecord1.ERP__c = 'P20';		
		cpoRecord1.Opportunity__c =oppty.id;
		cpoRecord1.Legacy_CPO__c = true;
		database.insert(cpoRecord1);
		
		Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		cpoItem.Apttus_Config2__StartDate__c=system.today();
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365; 
		cpoItem.Apttus_Config2__Quantity__c = 1000;
		//cpoItem.Consumed_Quantity__c = 2000;
		cpoItem.Consumed_Quantity__c = 200;
		database.insert(cpoItem);
		update cpoItem;
		
		cpoRecord1.Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoRecord1);
		
		Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
		commercialEntitlement.Parent_Account__c = accObj.Id;
		commercialEntitlement.Product_Name__c = productObj2[0].id;
		commercialEntitlement.Sold_To_Party__c = obj2.Id;
		
		database.insert(commercialEntitlement);	 
		
		DS_ValidateButton.getStatusUpdate(UpsellProposal.Id,CSWXGlobalConstant.VALIDATED,null,'Test Reason');
		Test.stopTest();
		
	}
	
	
}