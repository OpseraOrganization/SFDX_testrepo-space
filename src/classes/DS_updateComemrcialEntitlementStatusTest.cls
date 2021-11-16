/*******************************
Class Name: DS_updateComemrcialEntitlementStatusTest

Description: Test class for DS_updateComemrcialEntitlementStatus
*******************************/

@isTest
public class DS_updateComemrcialEntitlementStatusTest {
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
	public static testmethod void DS_Test(){
		
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		accountCreationDP.L4Name__c = 'TESTTerritory'; 
		database.insert(accountCreationDP);
		
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		accLegalEntity.ParentId = accountCreationDP.Id;
		database.insert(accLegalEntity);
		
		
		
		Apttus__APTS_Agreement__c agree = new Apttus__APTS_Agreement__c();
		agree.Apttus__Account__c = accLegalEntity.id;
		insert agree;
		
		SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c();
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
		database.insert(upsellProposal_SWX);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		database.insert(oppty);
	   
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
		quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
		database.insert(quoteProposal2);
		
		Apttus_Proposal__Proposal_Line_Item__c QuoteLI = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI.Apttus_QPConfig__ItemSequence__c = 1;
		QuoteLI.Apttus_QPConfig__LineNumber__c =1;
		insert QuoteLI;
		
		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = accLegalEntity.id;
		cpoRecord.Apttus_Config2__BillToAccountId__c = accLegalEntity.id;
		cpoRecord.Apttus_Config2__ShipToAccountId__c = accLegalEntity.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;
		cpoRecord.Payer__c = accLegalEntity.id;
		cpoRecord.Sales_Org__c = 'Test';
		cpoRecord.Sales_Office__c = 'Test';
		cpoRecord.Sales_Group__c = 'Test';
		cpoRecord.Distribution_Channel__c = 'Test';
		cpoRecord.Division__c = 'Test';
		cpoRecord.PO_number__c = '12564';
		cpoRecord.Apttus_Config2__PODate__c =system.today();
		cpoRecord.Comments__c = 'test';
		cpoRecord.Contract_Type_Name__c ='Contract';
		cpoRecord.Business_category__c = '2G';
		cpoRecord.Reporting__c ='Excl contr from OBL';
		cpoRecord.Master_contract__c = 'NA';
		cpoRecord.Apttus_Config2__AccountId__c = accountCreationDP.id;
		database.insert(cpoRecord);
		
		Product2 product = TestDataFactory.productCreation(1)[0];
		product.ProductCode = '151421';
		database.insert(product);
		Product2 product1 = TestDataFactory.productCreation(1)[0];
		product1.ProductCode = '151424';
		database.insert(product1);
		
		Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem.Apttus_Config2__ProductId__c  = product.id;
		cpoItem.Apttus_Config2__StartDate__c=Date.today()+5;
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem);
		
		Apttus_Config2__CustomerPOItem__c cpoItem1 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem1.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem1.Apttus_Config2__ProductId__c  = product1.id;
		cpoItem1.Apttus_Config2__StartDate__c=Date.today()+5;
		cpoItem1.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem1);
		
		Apttus_Config2__CustomerPOItem__c cpoItem2 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem2.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem2.Apttus_Config2__ProductId__c  = product1.id;
		cpoItem2.Apttus_Config2__StartDate__c=Date.today()+5;
		cpoItem2.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem2);
		
	  //  cpoRecord.Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoRecord); 
					   
		Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
		commercialEntitlement.Parent_Account__c = accountCreationDP.Id;
		commercialEntitlement.Sold_To_Party__c = accLegalEntity.id;
		commercialEntitlement.Authorised_Quantity__c = 5;
		commercialEntitlement.Product_Name__c = product.id;
		database.insert(commercialEntitlement);
		
		Commercial_Entitlement__c commercialEntitlement1 = new Commercial_Entitlement__c();
		commercialEntitlement1.Parent_Account__c = accountCreationDP.Id;
		commercialEntitlement1.Sold_To_Party__c = accLegalEntity.id;
		commercialEntitlement1.Authorised_Quantity__c = 5;
		commercialEntitlement1.Product_Name__c = product1.id;
		database.insert(commercialEntitlement1);
		
		Set<Id> cpoLI = new Set<Id>();
		Set<Id> toBeExpired = new Set<Id>();
		Set<Id> toBeExpired2 = new Set<Id>();
		
		cpoLI.add(cpoItem.id);
		cpoItem1.Commercial_Entitlement_Status__c = 'Expired';
		database.update(cpoItem1);
		cpoLI.add(cpoItem1.id);
		
		cpoItem2.Commercial_Entitlement_Status__c = 'Entitled';
		database.update(cpoItem2);
		cpoLI.add(cpoItem2.id);
		
		toBeExpired.add(cpoItem1.id);
				
		Test.startTest();   
			DS_updateComemrcialEntitlementStatus c1 = new DS_updateComemrcialEntitlementStatus(cpoLI,toBeExpired);
			//cpoItem1.Commercial_Entitlement_Status__c = 'Expired';
			//database.update(cpoItem1);
			//toBeExpired2.add(cpoItem1.id);
			//DS_updateComemrcialEntitlementStatus c2 = new DS_updateComemrcialEntitlementStatus(cpoLI,toBeExpired2);
		Test.stopTest();
	}
}