/****************************************
* Name : DS_SWCatalogueTest
* Author : Accenture

*****************************************/
@isTest
public class DS_SWCatalogueTest{

static testmethod void DS_SWCatalogueTest_1(){
		   Id territoryId = TestDataFactory.getTerritoryId(); 
		   User sysAdminUser = TestDataFactory.createSystemAdminUser();
		   
			System.runAs(sysAdminUser){
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
			
			Account acc = new Account();
			acc.Name='Legal Entinty Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreationDP .Id;
			acc.AccountNumber = '100006843';
			database.insert(acc);
			
			List<ObjectTerritory2Association> objTerr2Association = TestDataFactory.assigningAccountToTerritory(1,accountCreationDP,territoryId);
			insert objTerr2Association;
			
			List<UserTerritory2Association> userToTerritory = TestDataFactory.assigningUserToTerritory(1,sysAdminUser,territoryId);
			insert userToTerritory;
			
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
			//agreement.Apttus__Account__c = accountCreationDP.Id;
			agreement.Name='Test Agreement'; 
			agreement.Apttus__Account__c=acc.Id;
			insert agreement;

			Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
			cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
				cpoTest.Legacy_CPO__c = true;
			insert cpoTest;   
			 
			Product2 prod = TestDataFactory.productCreation(1)[0];
			prod.ProductCode = '1514211';
			insert prod;
			
			Product_Feature_Junction__c prodFeature = new Product_Feature_Junction__c();
			prodFeature.Product__c = prod.id;
			insert prodFeature;
			 
			
				
			SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal.Analytics_Source__c=CSWXGlobalConstant.SourceID_RMP  ;
			upsellProposal.Proposal_Status__c=CSWXGlobalConstant.ACTIVE; 
			upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForReview ;
			upsellProposal.RecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('DS SWMP Proposals').getRecordTypeId();
			upsellProposal.Proposal_Recommendation_Type__c='renewal';
			upsellProposal.P20_Id__c=215616;
			upsellProposal.CurrencyIsoCode=CSWXGlobalConstant.EUR ;
			upsellProposal.Unweighted_Value__c=429052.07;
			upsellProposal.Account_ID__c=accountCreationDP.id;
			upsellProposal.PO__c = cpoTest.id;
			upsellProposal.Sold_To_Party__c = acc.Id;
			upsellProposal.Technology__c=CSWXGlobalConstant.Technology ;
			upsellProposal.Use_Case__c=CSWXGlobalConstant.Usecase ;
			upsellProposal.Frame_Contract__c = agreement.ID;
			
			upsellProposal.DS_Show_In_Portal__c=true;
			upsellProposal.Ready_to_Convert__c = true;
			database.insert(UpsellProposal);
			
			SWx_Upsell_Items__c SWXLineItem = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
			SWXLineItem.Quantity__c = 5;
			SWXLineItem.Feature_ID__c = '89763';
			SWXLineItem.SWx_Product_Code__c = '1514211';
			insert SWXLineItem;  

			test.starttest();
				Apttus__APTS_Agreement__c agreement_1 = [Select Apttus__FF_Agreement_Number__c, Name from Apttus__APTS_Agreement__c where id=: agreement.Id ];
				String agreementNameandNumber=agreement.Name + '-' + agreement.Apttus__FF_Agreement_Number__c;
				String agreementNameandNumber1=agreement_1.Name + '-' + agreement_1.Apttus__FF_Agreement_Number__c;
				Apttus_Config2__CustomerPurchaseOrder__c cpoTest_1 = [Select Name from Apttus_Config2__CustomerPurchaseOrder__c where id=: cpoTest.Id ];
				DS_SWCatalogue.getFrameContractReference();
				DS_SWCatalogue.getPO();
			   //DS_SWCatalogue.getDependentMap(upsellProposal, CSWXGlobalConstant.TECHNOLOGY_API , CSWXGlobalConstant.USE_CASE_API );
				DS_SWCatalogue.getfeature(agreementNameandNumber, cpoTest.Name, CSWXGlobalConstant.Technology, CSWXGlobalConstant.Usecase, 'OFF');
				DS_SWCatalogue.getfeature(agreementNameandNumber1, cpoTest_1.Name, CSWXGlobalConstant.Technology, CSWXGlobalConstant.Usecase, 'OFF');

			test.stoptest();
	}
}
static testmethod void DS_SWCatalogueTest_2(){
		   Id territoryId = TestDataFactory.getTerritoryId(); 
		   User sysAdminUser = TestDataFactory.createSystemAdminUser();
		   
			System.runAs(sysAdminUser){
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
			
			 Account acc = new Account();
			acc.Name='Legal Entity Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreationDP .Id;
			acc.AccountNumber = '100006843';
			database.insert(acc);
			
			List<ObjectTerritory2Association> objTerr2Association = TestDataFactory.assigningAccountToTerritory(1,accountCreationDP,territoryId);
			insert objTerr2Association;
			
			List<UserTerritory2Association> userToTerritory = TestDataFactory.assigningUserToTerritory(1,sysAdminUser,territoryId);
			insert userToTerritory;
			
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
			//agreement.Apttus__Account__c = accountCreationDP.Id;
			agreement.Name='Test Agreement 1';   
			agreement.Apttus__Account__c=acc.Id;
			insert agreement;

			Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
			cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
				cpoTest.Legacy_CPO__c = true;
			insert cpoTest;   
			 
			Product2 prod = TestDataFactory.productCreation(1)[0];
			prod.ProductCode = '151421';
			insert prod;
			
			Product_Feature_Junction__c prodFeature = new Product_Feature_Junction__c();
			prodFeature.Product__c = prod.id;
			insert prodFeature;
				
				
			SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal.Analytics_Source__c=CSWXGlobalConstant.SourceID_RMP  ;
			upsellProposal.Proposal_Status__c=CSWXGlobalConstant.ACTIVE; 
			upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForReview ;
			upsellProposal.RecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('DS SWMP Proposals').getRecordTypeId();
			upsellProposal.Proposal_Recommendation_Type__c='renewal';
			upsellProposal.P20_Id__c=215616;
			upsellProposal.CurrencyIsoCode=CSWXGlobalConstant.EUR ;
			upsellProposal.Unweighted_Value__c=429052.07;
			upsellProposal.Account_ID__c=accountCreationDP.id;
			upsellProposal.PO__c = cpoTest.id;
			upsellProposal.Account_ID__c=accountCreationDP.id;
			upsellProposal.Technology__c=CSWXGlobalConstant.Technology ;
			upsellProposal.Use_Case__c=CSWXGlobalConstant.Usecase ;
			upsellProposal.Frame_Contract__c = agreement.ID;
			upsellProposal.Sold_To_Party__c = acc.Id;
			
			upsellProposal.DS_Show_In_Portal__c=true;
			upsellProposal.Ready_to_Convert__c = true;
			database.insert(UpsellProposal);
			
			SWx_Upsell_Items__c SWXLineItem = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
			SWXLineItem.Quantity__c = 5;
			SWXLineItem.Feature_ID__c = '89763';
			SWXLineItem.SWx_Product_Code__c = '1514211';
			insert SWXLineItem; 
			
			String agreementNameandNumber=agreement.Name + '-' + agreement.Apttus__FF_Agreement_Number__c;
			test.starttest();
				DS_SWCatalogue.getFrameContractReference();
				DS_SWCatalogue.getPO();
				//DS_SWCatalogue.getDependentMap(upsellProposal, CSWXGlobalConstant.TECHNOLOGY_API , CSWXGlobalConstant.USE_CASE_API );
				DS_SWCatalogue.getfeature(agreementNameandNumber, cpoTest.Name, CSWXGlobalConstant.Technology, CSWXGlobalConstant.Usecase, 'ON');
				

			test.stoptest();
	}
}
	static testmethod void testgetTechnologies()
	{
		list<string> values = DS_SWCatalogue.getTechnologies();
	}
	static testmethod void testgetUseCaseOnTechnology()
	{
		list<string> values = DS_SWCatalogue.getUseCaseOnTechnology('---None---');
		list<string> values1 = DS_SWCatalogue.getUseCaseOnTechnology('TDD LTE');
	 }
	
}