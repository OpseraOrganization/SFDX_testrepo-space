/****************************************
* Name : SWxUpsellProposalTriggerHelperTest
* Author : Accenture
* Description : Test class SWxUpsellProposalTriggerHelper
*****************************************/
@IsTest
private with sharing class SWxUpsellProposalTriggerHelperTest{
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
	/******************************
*Method Name: updateProposalStageToCloseValidatedTest
*Description: Test Method to cover updateProposalStageToCloseValidated method
********************************/
	static testmethod void updateProposalStageToCloseValidated(){
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '8896';
		
		Account accountCreation = TestDataFactory.createAccount(2)[0];
		database.insert(accountCreation);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(1,accountCreation);
		Database.insert(opp);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		Set<Id> duplicateDPId = new Set<Id>();
		test.startTest();
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(3,accountCreation);
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		upsellObj[0].Technology__c = CSWXGlobalConstant.Technology;
		upsellObj[0].Use_Case__c=CSWXGlobalConstant.Usecase ;
		upsellObj[0].Upsell_Status__c = 'Convert';
		upsellObj[0].Analytics_Source__c = 'CXM';
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Expected_LoA_Level__c = 'LoA Bypass';
		upsellObj[0].Ready_to_Convert__c = true;
		upsellObj[0].Business_Rules_Check__c='Red';
		upsellObj[0].RecordTypeId = ccreRecordTypeId ;
		upsellObj[0].Proposal_Status__c='Close-Validated';
		upsellObj[0].DS_Show_In_Portal__c = true;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObj[0].SWX_Reference_Opportunity__c=opp[0].id;
		upsellObjList.add(upsellObj[0]);
		
		upsellObj[1].Upsell_Status__c = 'Convert';
		upsellObj[1].Analytics_Source__c = 'CXM';
		upsellObj[1].Account_ID__c = accountCreation.id;
		upsellObj[1].Expected_LoA_Level__c = 'LoA Bypass';
		upsellObj[1].Ready_to_Convert__c = true;
		upsellObj[1].Business_Rules_Check__c='Red';
		upsellObj[1].RecordTypeId = ccreRecordTypeId ;
		upsellObj[1].Proposal_Status__c=CSWXGlobalConstant.VALIDATED;
		upsellObj[1].DS_Show_In_Portal__c = false;
		upsellObj[1].Sold_To_Party__c = acc.Id;
		upsellObj[1].Technology__c = CSWXGlobalConstant.Technology;
		upsellObj[1].Use_Case__c=CSWXGlobalConstant.Usecase ;
		upsellObj[1].SWX_Reference_Opportunity__c=opp[0].id;
		upsellObjList.add(upsellObj[1]);
		
		upsellObj[2].Upsell_Status__c = CSWXGlobalConstant.Approval_stage_Reject;
		upsellObj[2].Analytics_Source__c = 'CXM';
		upsellObj[2].Account_ID__c = accountCreation.id;
		upsellObj[2].Expected_LoA_Level__c = 'LoA Bypass';
		upsellObj[2].Ready_to_Convert__c = true;
		upsellObj[2].Business_Rules_Check__c='Red';
		upsellObj[2].RecordTypeId = ccreRecordTypeId ;
		upsellObj[2].Proposal_Status__c=CSWXGlobalConstant.Approval_stage_Reject;
		upsellObj[2].DS_Show_In_Portal__c = false;
		upsellObj[2].Sold_To_Party__c = acc.Id;
		upsellObj[2].Technology__c = CSWXGlobalConstant.Technology;
		upsellObj[2].Use_Case__c=CSWXGlobalConstant.Usecase ;		
		upsellObjList.add(upsellObj[2]);
		database.insert(upsellObjList);
		
		List<SWx_Upsell_Proposal__c> duplicateDP = TestDataFactory.upsellList(1,accountCreation);
		List<SWx_Upsell_Proposal__c> duplicateDPList = new List<SWx_Upsell_Proposal__c>();
		duplicateDP[0].Upsell_Status__c = 'readyForReview ';
		duplicateDP[0].Analytics_Source__c = 'CXM';
		duplicateDP[0].Account_ID__c = accountCreation.id;
		duplicateDP[0].Expected_LoA_Level__c = 'LoA Bypass';
		duplicateDP[0].Ready_to_Convert__c = true;
		duplicateDP[0].Business_Rules_Check__c='Red';
		duplicateDP[0].RecordTypeId = ccreRecordTypeId ;
		duplicateDP[0].Proposal_Status__c=CSWXGlobalConstant.ACTIVE;
		duplicateDP[0].DS_Show_In_Portal__c = true;
		duplicateDP[0].Sold_To_Party__c = acc.Id;
		duplicateDP[0].Technology__c = CSWXGlobalConstant.Technology;
		duplicateDP[0].Use_Case__c=CSWXGlobalConstant.Usecase ;
		duplicateDPList.add(duplicateDP[0]);
		
		List<product2> productObj = TestDataFactory.productCreation(2);
		productObj[0].ProductCode = 'Test';
		productObj[1].ProductCode = 'Test123';
		database.insert(productObj);
		
		List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem.Bundle_ID__c = productObj[0].id;
		upsellItem.Sales_Item_Code__c = productObj[0].id;
		upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems.add(upsellItem);
		database.insert(insertItems);
		
		Map<String,SWx_Upsell_Proposal__c> dpIdTodpObjectMap = new Map<String,SWx_Upsell_Proposal__c>();
		dpIdTodpObjectMap.put(upsellObj[0].id,upsellObj[0]);
		Set<String> productCode = new Set<String>();
		productCode.add(productObj[0].id);
		String accountId =  accountCreation.id;
		Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap = new  Map<Id,List<SWx_Upsell_Items__c>>();
		dpTolineItemMap.put(upsellObj[0].Id,insertItems);
		
		
		
		List<Apttus_Config2__ProductOptionComponent__c>  ProductOptionComponentList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.CreateproductOptionComponent(productObj[0].id,1)[0];
		productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj[0].id;
		productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
		//productOptionComponentObj.BundledProduct_Code__c = 'Test';
		ProductOptionComponentList.add(productOptionComponentObj);
		 
		database.insert(ProductOptionComponentList);   
		// upsellObj[0].Upsell_Status__c = 'Convert';
		
		// update upsellObjList;
		
		SWxUpsellProposalTriggerHelper.updateProposalStageToCloseValidated(upsellObjList);
		SWxUpsellProposalTriggerHelper.updateProposalStageToCloseValidated(null);
		SWxUpsellProposalTriggerHelper.updateProposalStageToCloseValidated(duplicateDPList);
		SWxUpsellProposalTriggerHelper.getbundleToOptionMap(ProductOptionComponentList);
		SWxUpsellProposalTriggerHelper.getbundleToOptionMap(null);
			test.stopTest();
		
	}
	
	
	
	/******************************
*Method Name: createOpptyTest
*Description: Test Method to cover createOppty method
********************************/
   static testmethod void createOpptyTest(){
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '8896';
		
		Set<Id> accId = new Set<Id>();
		Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
		
		Test.startTest();
		List<Account> accountCreation = TestDataFactory.createAccount(2);
		accountCreation[0].AccountNumber = '3011234';
		accountCreation[1].AccountNumber = '3011235';
		database.insert(accountCreation);
		accId.add(accountCreation[0].Id);
		accId.add(accountCreation[1].Id);
		
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(1,accountCreation[0]);
		Database.insert(opp);
		
		List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(3,accountCreation[0]);
																										
		upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellProposalList[0].RecordTypeID=swxRecordTypeId;
		upsellProposalList[0].Sold_To_Party__c = acc.Id;		
		upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
		upsellProposalList[0].Account_ID__c = accountCreation[0].id;
		upsellProposalList[0].Business_Rules_Check__c='Green';
		upsellProposalList[0].Upsell_Status__c='Convert';
		upsellProposalList[0].Unweighted_Value__c=10;
		upsellProposalList[0].CurrencyIsoCode='EUR';
		upsellProposalList[0].Quote_ID__c=null;
		upsellProposalList[0].SWX_Reference_Opportunity__c=opp[0].id;
		upsellProposalList[0].Expected_LoA_Level__c='A';
		upsellProposalList[0].Technology__c = CSWXGlobalConstant.Technology;
		upsellProposalList[0].Use_Case__c=CSWXGlobalConstant.Usecase ;
		
		upsellProposalList[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellProposalList[1].RecordTypeID=swxRecordTypeId;
		upsellProposalList[1].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
		upsellProposalList[1].Sold_To_Party__c = acc.Id;
		upsellProposalList[1].Account_ID__c = accountCreation[0].id;
		upsellProposalList[1].Business_Rules_Check__c='Green';
		upsellProposalList[1].Upsell_Status__c='Convert';
		upsellProposalList[1].Unweighted_Value__c=10;
		upsellProposalList[1].CurrencyIsoCode='EUR';
		upsellProposalList[1].Quote_ID__c=null;
		upsellProposalList[1].SWX_Reference_Opportunity__c=opp[0].id;
		upsellProposalList[1].Expected_LoA_Level__c='A';
		upsellProposalList[1].Technology__c = CSWXGlobalConstant.Technology;
		upsellProposalList[1].Use_Case__c=CSWXGlobalConstant.Usecase ;
		
		upsellProposalList[2].Analytics_Source__c = 'CXM';
		upsellProposalList[2].RecordTypeID=ccreRecordTypeId;
		upsellProposalList[2].Account_ID__c = accountCreation[0].id;
		upsellProposalList[2].Sold_To_Party__c = acc.Id;
		upsellProposalList[2].Business_Rules_Check__c='Green';
		upsellProposalList[2].Upsell_Status__c='Convert';
		upsellProposalList[2].Unweighted_Value__c=10;
		upsellProposalList[2].CurrencyIsoCode='EUR';
		upsellProposalList[2].Quote_ID__c=null;
		upsellProposalList[2].SWX_Reference_Opportunity__c=opp[0].id;
		upsellProposalList[2].Expected_LoA_Level__c='A';
		upsellProposalList[2].Technology__c = CSWXGlobalConstant.Technology;
		upsellProposalList[2].Use_Case__c=CSWXGlobalConstant.Usecase ;
		database.insert(upsellProposalList);
		//
		Apttus_Config2__PriceList__c plist = new Apttus_Config2__PriceList__c();
		plist.Name='Ooredoo Myanmar Net Prices';
		plist.CurrencyIsoCode='USD';
		plist.Apttus_Config2__AccountId__c=accountCreation[0].id;
		insert plist;
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		//price list Item
		List<Apttus_Config2__PriceListItem__c> litsOfplItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c plitem = new Apttus_Config2__PriceListItem__c();
		plitem.Apttus_Config2__PriceListId__c=plist.Id;  
		plitem.Apttus_Config2__ProductId__c=productObj2[0].Id;
		Apttus_Config2__PriceListItem__c plitem1 = new Apttus_Config2__PriceListItem__c();
		plitem1.Apttus_Config2__PriceListId__c=plist.Id;  
		plitem1.Apttus_Config2__ProductId__c=productObj2[1].Id;
		litsOfplItems.add(plitem);
		litsOfplItems.add(plitem1);
		insert litsOfplItems;
		
		SWxUpsellProposalTriggerHelper.getpriceListItem(litsOfplItems);
	   SWxUpsellProposalTriggerHelper.getpriceListItem(null);
		SWxUpsellProposalTriggerHelper.createOppty(upsellProposalList);
	   //SWxUpsellProposalTriggerHelper.createOppty(null);
		Test.stopTest();
	}
	
	/******************************
*Method Name: InsertFileTest
*Description: Test Method to cover insertfile method
********************************/
	static testmethod void InsertFileTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '21514';
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(2,accountCreation);
		List<SWx_Upsell_Proposal__c> upsellObjInsertList = new List<SWx_Upsell_Proposal__c>();
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		Test.startTest();
		upsellObj[0].Technology__c = CSWXGlobalConstant.Technology;
		upsellObj[0].Use_Case__c=CSWXGlobalConstant.Usecase ;
		upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.VALIDATED;
		upsellObj[0].Proposal_Status__c = CSWXGlobalConstant.proposalCloseValidate;
		//upsellObj[0].Proposal_Status__c  = CSWXGlobalConstant.CLOSE_REJECT;
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObjInsertList.add(upsellObj[0]);
		database.insert(upsellObjInsertList);
		SWxUpsellProposalTriggerHelper.InsertFile(upsellObjInsertList);
		//SWxUpsellProposalTriggerHelper.InsertFile(null);
		Test.stopTest();
	}
	
	/******************************
*Method Name: checkStatusTest
*Description: Test Method to cover checkStetus method
********************************/
	
 /*   static testmethod void checkStatusTest(){
User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
userCreation.Nokia_ID__c = '8896';

Account accountCreation = TestDataFactory.createAccount(1)[0];
database.insert(accountCreation);
List<SWx_Upsell_Proposal__c> TempupsellObjList = new List<SWx_Upsell_Proposal__c>();
List<SWx_Upsell_Proposal__c> insertTempupsellObjList = new List<SWx_Upsell_Proposal__c>();
List<SWx_Upsell_Proposal__c> TempupsellObjListToUpdate = new List<SWx_Upsell_Proposal__c>();
Account acc = new Account();
acc.Name='Legal Entinty Account For Test';
acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
acc.ParentId = accountCreation.Id;
acc.AccountNumber = '100006843';
database.insert(acc);

Test.StartTest();	
SWx_Upsell_Proposal__c DigiObj1 = new SWx_Upsell_Proposal__c();
DigiObj1.Upsell_Status__c = CSWXGlobalConstant.draft;
DigiObj1.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
DigiObj1.Analytics_File_Refer_ID__c = '6753287163A';
DigiObj1.Analytics_Source__c = 'CXM';
DigiObj1.RecordTypeId = swxRecordTypeId ;
DigiObj1.Account_ID__c = accountCreation.id;
DigiObj1.Sold_To_Party__c = acc.Id;
DigiObj1.Expected_LoA_Level__c = 'LoA Bypass';
DigiObj1.Ready_to_Convert__c = true;
TempupsellObjList.add(DigiObj1);

SWx_Upsell_Proposal__c DigiObj2 = new SWx_Upsell_Proposal__c();
DigiObj2.Upsell_Status__c = CSWXGlobalConstant.convert;
DigiObj2.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
DigiObj2.Analytics_File_Refer_ID__c = '6753287163A';
DigiObj2.Analytics_Source__c = 'CCRE';
DigiObj2.RecordTypeId = ccreRecordTypeId ;
DigiObj2.Account_ID__c = accountCreation.id;
DigiObj2.Sold_To_Party__c = acc.Id;
DigiObj2.Expected_LoA_Level__c = 'LoA Bypass';
DigiObj2.Ready_to_Convert__c = true;
TempupsellObjList.add(DigiObj2);

SWx_Upsell_Proposal__c DigiObj = new SWx_Upsell_Proposal__c();
DigiObj.Upsell_Status__c = CSWXGlobalConstant.draft;
DigiObj.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
DigiObj.Analytics_File_Refer_ID__c = '6753287163A';
DigiObj.Analytics_Source__c = 'CCRE';
DigiObj.RecordTypeId = ccreRecordTypeId ;
DigiObj.Account_ID__c = accountCreation.id;
DigiObj.Sold_To_Party__c = acc.Id;
DigiObj.Expected_LoA_Level__c = 'LoA Bypass';
DigiObj.Ready_to_Convert__c = true;
TempupsellObjList.add(DigiObj);

insert TempupsellObjList;

for(SWx_Upsell_Proposal__c updateProp:TempupsellObjList){
updateProp.Upsell_Status__c=CSWXGlobalConstant.readyForReview;
TempupsellObjListToUpdate.add(updateProp);
}

if(!TempupsellObjListToUpdate.isEmpty()){
try{
update TempupsellObjListToUpdate;
}
catch(Exception e){
System.debug('--Success !!!-- ');
}
}
SWxUpsellProposalTriggerHelper.checkStatus(TempupsellObjListToUpdate,new Map<Id,SWx_Upsell_Proposal__c>{DigiObj1.Id=>DigiObj});
Test.StopTest();


}*/
	
	
	
	/******************************
*Method Name: checkStatusTest
*Description: Test Method to cover checkStetus method
********************************/
	
	static testmethod void checkStatusTest1(){
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '8896';
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		List<SWx_Upsell_Proposal__c> TempupsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> insertTempupsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> TempupsellObjListToUpdate = new List<SWx_Upsell_Proposal__c>();
		Map<Id,SWx_Upsell_Proposal__c> oldMap = new Map<Id,SWx_Upsell_Proposal__c>();
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		Test.StartTest();	
		SWx_Upsell_Proposal__c DigiObj1 = new SWx_Upsell_Proposal__c();
		DigiObj1.Upsell_Status__c = CSWXGlobalConstant.draft;
		DigiObj1.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
		DigiObj1.Sold_To_Party__c = acc.Id;
		DigiObj1.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj1.Analytics_Source__c = 'CXM';
		DigiObj1.RecordTypeId = swxRecordTypeId ;
		DigiObj1.Account_ID__c = accountCreation.id;
		DigiObj1.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj1.Ready_to_Convert__c = true;
		DigiObj1.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj1.Use_Case__c='Energy Efficiency';
		TempupsellObjList.add(DigiObj1);
		
		SWx_Upsell_Proposal__c DigiObj2 = new SWx_Upsell_Proposal__c();
		DigiObj2.Upsell_Status__c = CSWXGlobalConstant.readyForReview;
		DigiObj2.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
		DigiObj2.Sold_To_Party__c = acc.Id;
		DigiObj2.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj2.Analytics_Source__c = 'CXM';
		DigiObj2.RecordTypeId = ccreRecordTypeId ;
		DigiObj2.Account_ID__c = accountCreation.id;
		DigiObj2.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj2.Ready_to_Convert__c = true;
		DigiObj2.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj2.Use_Case__c='Energy Efficiency';
	   
		//DS_Staging__c stagingObj2 = new DS_Staging__c();
		//stagingObj2.DP_Status__c = 'Success';
		//stagingObj2.Json_Uploader__c = 'Text';
		//insert stagingObj2;
		//DigiObj2.DS_Staging__c = stagingObj2.Id;
		TempupsellObjListToUpdate.add(DigiObj2);
		
		SWx_Upsell_Proposal__c DigiObj3 = new SWx_Upsell_Proposal__c();
		DigiObj3.Upsell_Status__c = CSWXGlobalConstant.readyForReview;
		DigiObj3.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
		DigiObj3.Sold_To_Party__c = acc.Id;
		DigiObj3.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj3.Analytics_Source__c = 'CXM';
		DigiObj3.RecordTypeId = ccreRecordTypeId ;
		DigiObj3.Account_ID__c = accountCreation.id;
		DigiObj3.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj3.Ready_to_Convert__c = true;
		DigiObj3.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj3.Use_Case__c='Energy Efficiency';
		TempupsellObjListToUpdate.add(DigiObj3);
		
		
		SWx_Upsell_Proposal__c DigiObj4 = new SWx_Upsell_Proposal__c();
		
		DigiObj4.Upsell_Status__c = CSWXGlobalConstant.draft;
		DigiObj4.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
		DigiObj4.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj4.Analytics_Source__c = 'CXM';
		DigiObj4.RecordTypeId = ccreRecordTypeId ;
		DigiObj4.Account_ID__c = accountCreation.id;
		DigiObj4.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj4.Ready_to_Convert__c = true;  
		DigiObj4.Sold_To_Party__c = acc.Id;
		DigiObj4.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj4.Use_Case__c= 'Energy Efficiency';
		
		DS_Staging__c stagingObj1 = new DS_Staging__c();
		stagingObj1.DP_Status__c = 'Success';
		stagingObj1.Json_Uploader__c = 'Text';
		insert stagingObj1;
		DigiObj4.DS_Staging__c = stagingObj1.Id;
		//TempupsellObjList.add(DigiObj4);
		insert DigiObj4;
		insert TempupsellObjList;
		insert TempupsellObjListToUpdate;
				
		DS_Staging__c stagingObj = new DS_Staging__c();
		stagingObj.DP_Status__c = 'Success';
		stagingObj.Json_Uploader__c = 'Text';
		insert stagingObj;
		
		System.debug('XXX');
		DigiObj1.Upsell_Status__c=CSWXGlobalConstant.readyForReview;
		DigiObj1.DS_Staging__c  = stagingObj.Id;
		update DigiObj1;
		
		Map<Id,SWx_Upsell_Proposal__c> oldProposalMap = new Map<Id,SWx_Upsell_Proposal__c>();
		oldProposalMap.put(DigiObj1.Id,DigiObj4);
		System.debug('DigiObj1'+DigiObj1);
		System.debug('oldProposalMap'+oldProposalMap);
		System.debug('XXXXXXXXXX');
 
		SWxUpsellProposalTriggerHelper.checkStatus(TempupsellObjList,oldProposalMap);
		DigiObj2.Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		DigiObj3.Upsell_Status__c = CSWXGlobalConstant.Approval_stage_Reject;
		DigiObj3.Proposal_Status__c = CSWXGlobalConstant.CLOSE_REJECT;
		update TempupsellObjListToUpdate;
		SWxUpsellProposalTriggerHelper.checkStatus(TempupsellObjList,oldProposalMap);
		SWxUpsellProposalTriggerHelper.checkStatus(null,oldProposalMap);
		Test.StopTest();
		
		
	}
	
	
	/******************************
*Method Name: checkStatusTest
*Description: Test Method to cover checkStetus method
********************************/
	static testmethod void checkStatusTest2(){
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '8896';
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		List<SWx_Upsell_Proposal__c> TempupsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> insertTempupsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> TempupsellObjListToUpdate = new List<SWx_Upsell_Proposal__c>();
		Map<Id,SWx_Upsell_Proposal__c> oldMap = new Map<Id,SWx_Upsell_Proposal__c>();
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		Test.StartTest();	
		SWx_Upsell_Proposal__c DigiObj1 = new SWx_Upsell_Proposal__c();
		DigiObj1.Upsell_Status__c = CSWXGlobalConstant.draft;
		DigiObj1.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
		DigiObj1.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj1.Analytics_Source__c = 'CXM';
		DigiObj1.RecordTypeId = swxRecordTypeId ;
		DigiObj1.Sold_To_Party__c = acc.Id;
		DigiObj1.Account_ID__c = accountCreation.id;
		DigiObj1.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj1.Ready_to_Convert__c = true;
		DigiObj1.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj1.Use_Case__c=CSWXGlobalConstant.Usecase ;
		TempupsellObjList.add(DigiObj1);
		
		SWx_Upsell_Proposal__c DigiObj2 = new SWx_Upsell_Proposal__c();
		DigiObj2.Upsell_Status__c = 'Reject';
		DigiObj2.Proposal_Status__c = 'Close-Reject';
		DigiObj2.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj2.Analytics_Source__c = 'CXM';
		DigiObj2.RecordTypeId = ccreRecordTypeId ;
		DigiObj2.Sold_To_Party__c = acc.Id;
		DigiObj2.DS_Show_In_Portal__c = false;
		DigiObj2.Account_ID__c = accountCreation.id;
		DigiObj2.Business_Rules_Check__c='Green';
		DigiObj2.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj2.Ready_to_Convert__c = true;
		DigiObj2.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj2.Use_Case__c=CSWXGlobalConstant.Usecase ;
		insert DigiObj2;
		
		SWx_Upsell_Proposal__c DigiObj4 = new SWx_Upsell_Proposal__c();
		
		DigiObj4.Upsell_Status__c = CSWXGlobalConstant.draft;
		DigiObj4.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
		DigiObj4.Analytics_File_Refer_ID__c = '6753287163A';
		DigiObj4.Analytics_Source__c = 'CXM';
		DigiObj4.RecordTypeId = ccreRecordTypeId ;
		DigiObj4.Account_ID__c = accountCreation.id;
		DigiObj4.Expected_LoA_Level__c = 'LoA Bypass';
		DigiObj4.Ready_to_Convert__c = true;
		DigiObj4.Sold_To_Party__c = acc.Id;
		DigiObj4.Technology__c = CSWXGlobalConstant.Technology;
		DigiObj4.Use_Case__c=CSWXGlobalConstant.Usecase ;
		insert TempupsellObjList;
		
		oldMap.put(DigiObj1.Id,DigiObj1);
		for(SWx_Upsell_Proposal__c updateProp:TempupsellObjList){
			updateProp.Upsell_Status__c=CSWXGlobalConstant.readyForReview;
			TempupsellObjListToUpdate.add(updateProp);
		}
		
		if(!TempupsellObjListToUpdate.isEmpty()){
				update TempupsellObjListToUpdate;
		}
		
		
		SWxUpsellProposalTriggerHelper.checkStatus(TempupsellObjListToUpdate,new Map<Id,SWx_Upsell_Proposal__c>{DigiObj1.Id=>DigiObj4});
		Test.StopTest();
		
		
	}
	
	/******************************
*Method Name: errorOnUpdate
*Description: This method is used to show error when any business validation fails
*Parameters:  UpsellProposal List
********************************/
	
	static testmethod void errorOnUpdate(){
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '8896';
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(1,accountCreation);
		Database.insert(opp);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(1,accountCreation);
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		
		test.startTest();
		upsellObj[0].Error_Message__c = 'This is an error message!!';
		upsellObj[0].Upsell_Status__c = 'Convert';
		upsellObj[0].Business_Rules_Check__c  = 'RED';
		string str = upsellObj[0].Error_Message__c;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Technology__c = CSWXGlobalConstant.Technology;
		upsellObj[0].Use_Case__c=CSWXGlobalConstant.Usecase ;
		upsellObj[0].SWX_Reference_Opportunity__c=opp[0].id;
		upsellObj[0].addError(str);
		upsellObjList.add(upsellObj[0]);
		database.insert(upsellObjList);
		test.stopTest();
	}
	
  /******************************
*Method Name: dpConsumptionOnValidateTest
*Description: This method is cover dpConsumptionOnValidate method of SWxUpsellProposalTriggerHelper class
*Parameters:  None
********************************/

	static testmethod void dpConsumptionOnValidateTest()
	{
	 
		 Test.startTest();
	  
	  
		//Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		
		List<Account> acclist = TestDataFactory.createAccount(2);
		Account accObj = acclist[0];
		database.insert(accObj);
		Account obj2 = acclist[1];
		obj2.Name='Legal Entinty Account For';
		obj2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		obj2.ParentId = accObj.Id;
		obj2.AccountNumber = '100006843';
		insert obj2;
	   
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='CXM000001-SmokeTest1irty';
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
	   
	  
		upsellProposal.Sold_To_Party__c=Obj2.Id;
		upsellProposal.Entitlement_Info__c=CSWXGlobalConstant.CanBeEntitled;
		upsellProposal.Upsell_Status__c='Validated';
		database.insert(UpsellProposal);
		
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		upsellItem2.Entitlement_Status__c= CSWXGlobalConstant.CanBeEntitled;
		upsellItem2.SWx_Product_Code__c= productObj2[0].ProductCode;
		upsellItem2.Quantity__c=50;
		insert upsellItem2;
		
		Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
		commercialEntitlement.Parent_Account__c = accObj.Id;
		commercialEntitlement.Product_Name__c = productObj2[0].id;
		commercialEntitlement.Sold_To_Party__c = obj2.Id;
		database.insert(commercialEntitlement);
		
		
		Apttus_Config2__CustomerPurchaseOrder__c cporecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cporecord.Apttus_Config2__Status__c ='Draft';
		cporecord.Apttus_Config2__AccountId__c = accObj.id;
		cporecord.Sold_to_party__c=Obj2.Id;
		cporecord.Delivery_System__c	='Other';
		//cporecord.Delivery_System__c='SWMP';
		cpoRecord.Legacy_CPO__c=true;
		database.insert(cporecord);
			
		
		Apttus_Config2__CustomerPOItem__c cpoItem= new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Authorised_Quantity__c=100;			
		cpoItem.Commercial_Entitlement__c=commercialEntitlement.Id;
		cpoItem.Commercial_Entitlement_Status__c='Entitled';
		cpoItem.Consumed_Quantity__c=0;
		cpoItem.Apttus_Config2__EndDate__c=date.today()+1;
		cpoItem.Non_Consumed_Quantity__c=0;
		cpoItem.Pending_Quantity__c=0;
		cpoItem.Quantity_Batch_Update__c=null;
		cpoItem.Apttus_Config2__StartDate__c=date.today();
	   
		cpoItem.Apttus_Config2__ProductId__c=productObj2[0].Id;
		cpoItem.Apttus_Config2__PurchaseOrderId__c = cporecord.Id;
		Database.insert(cpoItem);
		
		List<SWx_Upsell_Proposal__c>dpList = new List<SWx_Upsell_Proposal__c>();
		dpList.add(UpsellProposal);
		SWxUpsellProposalTriggerHelper.dpConsumptionOnValidate(dpList);
		
		/*	 upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForConversion;
		upsellProposal.Entitlement_Info__c='Quote Needed';
		database.update(upsellProposal); */
		upsellItem2.Quantity__c=150;
		database.update(upsellItem2);
		//   List<SWx_Upsell_Proposal__c>dpList2 = new List<SWx_Upsell_Proposal__c>();
		//  dpList2.add(UpsellProposal);
		SWxUpsellProposalTriggerHelper.dpConsumptionOnValidate(dpList);  
		Test.stopTest();
	}

/******************************
*Method Name: dpConsumptionOnValidateTest2
*Description: This method is cover dpConsumptionOnValidate method of SWxUpsellProposalTriggerHelper class
*Parameters:  None
********************************/

	static testmethod void dpConsumptionOnValidateTest2()
	{
	 
		 Test.startTest();
	  
		List<Account> acclist = TestDataFactory.createAccount(2);
		Account accObj = acclist[0];
		database.insert(accObj);
		Account obj2 = acclist[1];
		obj2.Name='Legal Entinty Account For';
		obj2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		obj2.ParentId = accObj.Id;
		obj2.AccountNumber = '100006843';
		insert obj2;
	   
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='CXM000001-SmokeTest1irty';
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.Sold_To_Party__c=Obj2.Id;
		upsellProposal.Entitlement_Info__c=CSWXGlobalConstant.QuoteNeeded;
		upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForConversion;
		database.insert(UpsellProposal);
		
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2); 
		
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellProposal.id;
		upsellItem2.Entitlement_Status__c= CSWXGlobalConstant.CanBeEntitled;
		upsellItem2.SWx_Product_Code__c= productObj2[0].ProductCode;
		upsellItem2.Quantity__c=50;
		insert upsellItem2;
		
		List<SWx_Upsell_Proposal__c>dpList = new List<SWx_Upsell_Proposal__c>();
		dpList.add(UpsellProposal);
		SWxUpsellProposalTriggerHelper.dpConsumptionOnValidate(dpList);
		
		 upsellProposal.Upsell_Status__c=CSWXGlobalConstant.Approval_stage_Reject;
		database.update(upsellProposal);
		 List<SWx_Upsell_Proposal__c>dpList2 = new List<SWx_Upsell_Proposal__c>();
		dpList2.add(upsellProposal);
		SWxUpsellProposalTriggerHelper.dpConsumptionOnValidate(dpList2);
		Test.stopTest();
	}




	
}