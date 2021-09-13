/****************************************
* Name : DS_SWxActionButtonTest
* Author : Accenture

*****************************************/
@isTest
Private class DS_SWxActionButtonTest{
	
	
	public testmethod static void DS_SWxActionButtonTest_1(){
		
			User sysAdminUser = TestDataFactory.createSystemAdminUser();
			   
		   
				System.runAs(sysAdminUser){
				Account accountCreationDP = TestDataFactory.createAccount(1)[0];
				database.insert(accountCreationDP);
				
			   /* Account accountCreationDP = TestDataFactory.createAccount(1)[0];
				accountCreationDP.L4Name__c = 'TESTTerritory'; 
				database.insert(accountCreationDP);*/
				
				Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
				agreement.Apttus__Account__c = accountCreationDP.Id;
				insert agreement;

			   /* Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
				cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
				cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
				insert cpoTest;  
				
						   */
				
				SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
				upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
				upsellProposal.Analytics_Source__c=CSWXGlobalConstant.SourceID_RMP  ;
				upsellProposal.Proposal_Status__c=CSWXGlobalConstant.ACTIVE; 
				upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForReview ;
				upsellProposal.RecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
				upsellProposal.Proposal_Recommendation_Type__c='renewal';
				upsellProposal.P20_Id__c=215616;
				upsellProposal.CurrencyIsoCode=CSWXGlobalConstant.EUR;
				upsellProposal.Unweighted_Value__c=429052.07;
				upsellProposal.Account_ID__c=accountCreationDP.id;
				//upsellProposal.PO__c = cpoTest.id;
				upsellProposal.Technology__c=CSWXGlobalConstant.Technology ;
				upsellProposal.Use_Case__c=CSWXGlobalConstant.Usecase ;
				upsellProposal.Frame_Contract__c = agreement.ID;
				
				upsellProposal.DS_Show_In_Portal__c=true;
				upsellProposal.Ready_to_Convert__c = true;
				upsellProposal.Sold_To_Party__c = accountCreationDP.id;
				database.insert(UpsellProposal);
				
				SWx_Upsell_Items__c SWXLineItem = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
				SWXLineItem.Quantity__c = 5;
				SWXLineItem.Feature_ID__c = '89763';
				SWXLineItem.SWx_Product_Code__c = '151421';
				insert SWXLineItem;
				system.debug('Before userDS run');				
				
				
				Test.startTest();
					upsellProposal.Proposal_Status__c=CSWXGlobalConstant.proposalCloseValidate; 
					upsellProposal.Upsell_Status__c=CSWXGlobalConstant.VALIDATED;
					update upsellProposal;
					User user2 = DS_SWxActionButton.getCurrentUserData();
					String DPtype = DS_SWxActionButton.getDPType(upsellProposal.Id);
					String profile = DS_SWxActionButton.getCurrentUserProfile();
					DS_SWxActionButton.getFeature(upsellProposal.Id);
					DS_SWxActionButton.updateAcceptanceOfDeliveryStatus('151421', upsellProposal.Id);
					DS_SWxActionButton.updateDeliveryExecutionStatus('151421', upsellProposal.Id); 
					DS_SWxActionButton.updateStatusInNetwork1('151421', upsellProposal.Id); 
					DS_SWxActionButton.updateStatusInNetwork1(null, upsellProposal.Id); 
					
				Test.stopTest();
				}
	}
	 public testmethod static void DS_SWxActionButtonTest_2(){
		
			User sysAdminUser = TestDataFactory.createSystemAdminUser();
		   
				System.runAs(sysAdminUser){
				Account accountCreationDP = TestDataFactory.createAccount(1)[0];
				database.insert(accountCreationDP);
				
				Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
				agreement.Apttus__Account__c = accountCreationDP.Id;
				insert agreement;

				/*Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
				cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
				cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
				insert cpoTest;  */ 
				 
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
				upsellProposal.RecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
				upsellProposal.Proposal_Recommendation_Type__c='renewal';
				upsellProposal.P20_Id__c=215616;
				upsellProposal.CurrencyIsoCode=CSWXGlobalConstant.EUR ;
				upsellProposal.Unweighted_Value__c=429052.07;
				upsellProposal.Account_ID__c=accountCreationDP.id;
				//upsellProposal.PO__c = cpoTest.id;
				upsellProposal.Technology__c=CSWXGlobalConstant.Technology ;
				upsellProposal.Use_Case__c=CSWXGlobalConstant.Usecase ;
				upsellProposal.Frame_Contract__c = agreement.ID;
				
				upsellProposal.DS_Show_In_Portal__c=true;
				upsellProposal.Ready_to_Convert__c = true;
				upsellProposal.Sold_To_Party__c = accountCreationDP.id;
				database.insert(UpsellProposal);
				
				SWx_Upsell_Items__c SWXLineItem = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
				SWXLineItem.Quantity__c = 5;
				SWXLineItem.Feature_ID__c = '89763';
				SWXLineItem.SWx_Product_Code__c = '1514211';
				insert SWXLineItem;
				
				Test.startTest();								
					upsellProposal.Proposal_Status__c=CSWXGlobalConstant.proposalCloseValidate; 
					upsellProposal.Upsell_Status__c=CSWXGlobalConstant.VALIDATED ;
					update upsellProposal;
					User user2 = DS_SWxActionButton.getCurrentUserData();
					String DPtype = DS_SWxActionButton.getDPType(upsellProposal.Id);
					String profile = DS_SWxActionButton.getCurrentUserProfile();
					DS_SWxActionButton.updateAcceptanceOfDeliveryStatus('1514211', upsellProposal.Id);
					DS_SWxActionButton.updateDeliveryExecutionStatus('1514211', upsellProposal.Id); 
					DS_SWxActionButton.updateStatusInNetwork1('1514211', upsellProposal.Id);
					DS_SWxActionButton.getFeature(upsellProposal.Id);   
				Test.stopTest(); 

				}  
	} 
}