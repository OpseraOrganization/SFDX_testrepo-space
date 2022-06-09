public with sharing class QTO_TestDataFactory {
	
	public static Opportunity OpportunityCreation(Account acc) {
		
			Opportunity opty = new Opportunity();
			opty.Name = 'Test Opportunity';
			opty.CloseDate = system.today();
			opty.StageName = 'Identify Opportunity';
			//opty.StageName = 'Win the Case (Negotiate)';
			opty.AccountId = acc.id;
			//opty.Account = 'Test Customer';
			opty.End_Customer__c = acc.id;
			opty.Contract_Signing_Entity__c = 'fALU';
			//opty.Phase_Status__c = 'Submitted for G5 Approval';
			opty.Phase_Status__c = 'Planned';
			//opty.Sales_Outcome__c= 'Won';
			opty.Apttus_Approval__Approval_Status__c = 'Approved';
			opty.CurrencyIsoCode = 'USD';
			opty.Business_Type__c = 'Standard Opportunity';
			opty.Amount = 300;
			opty.Sales_Outcome_Reason__c = 'Commercial';
			opty.Unweighted_Amount_EUR__c = 0;
			opty.Lead_BG__c = 'MN';
			//opty.Start_Contract_Date__c = system.today();
			//opty.Contract_End_Close_Date__c = system.today();
			opty.G2_Planned_Date__c = system.today();
			opty.G3_Planned_Date__c = system.today() + 1;
			opty.G4_Planned_Date__c = system.today() + 2;
			opty.G5_Planned_Date__c = system.today() + 3;
			opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		return opty;
	}
	
//Quote/Proposal Creation
	public static List<Apttus_Proposal__Proposal__c> createProposal(Integer size,Id oppId) {
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
			proposalObj.NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
			proposalObj.NokiaCPQ_Portfolio__c = 'Optics';
			proposalObj.NokiaCPQ_Existing_FN_Maint_Contract__c = 'No';
			proposalObj.NokiaCPQ_FN_Maintenance_Type__c = 'Gold';
		//  proposalObj.NokiaCPQ_SSP_Level__c = 'Unlimited';
			proposalObj.NokiaCPQ_SRS_Level__c = 'Unlimited';
			proposalObj.CurrencyIsoCode = 'EUR';
			proposalObj.Apttus_Proposal__Opportunity__c =oppId;
			proposalObj.Proposal_Recommendation_Type__c = 'SW Recommendation';
			proposalObj.Apttus_Proposal__Approval_Stage__c = 'Approved';
			proposalObj.Creation_Date__c = system.today();
			proposalObj.LOA_Status__c='Approved';
			proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test Quote';
			 proposalObj.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();
		//  proposalObj.Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			proposalList.add(proposalObj);
		}
		return proposalList;
	}
	
	public static Customer_Document__c createCustomerDocument() {
		Customer_Document__c cd =new Customer_Document__c();
		Account acc= createAccount(1)[0];
		insert acc;
		cd.Customer__c = acc.id;
		return cd;
	}
	
	 public static Customer_Document_Line_Items__c createCustomerDocumentLineItem(Customer_Document__c cd) {
		Customer_Document_Line_Items__c cdLines =new Customer_Document_Line_Items__c();
		cdLines.Customer_Document__c = cd.id;
		cdLines.Site__c ='2350200 PARIS(NORD)';
		cdLines.High_level_Product__c ='916876';
		return cdLines;
	}
	
	 public static Apttus__APTS_Agreement__c createAgreement(Account acc) {
		Apttus__APTS_Agreement__c agr =new Apttus__APTS_Agreement__c();
		agr.name = 'Test';
		agr.Apttus__Account__c =acc.id;
		return agr;
	}
	
	public static Apttus__APTS_Agreement__c createAgreement(Account acc, Opportunity opp, Account legalEntity) {
		Apttus__APTS_Agreement__c agr =new Apttus__APTS_Agreement__c();
		agr.name = 'Test';
		agr.Apttus__Account__c =acc.id;
		agr.Agreement_External_Contract_Number__c = '1234';
		agr.Nokia_Legal_Entity_lookup__c = legalEntity.Id;
		agr.End_Customer__c = acc.Id;		
		agr.Apttus__Related_Opportunity__c = opp.Id;
		agr.Lead_BG__c = 'MN';
		agr.Sales_Mode__c = 'Direct Export';
		agr.CLM_Product_Categories__c = 'Others';
		agr.Apttus__Contract_End_Date__c = System.today()+10;
		agr.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('General').getRecordTypeId();		
		return agr;
	}	
	
	public static Customer_facing_Attribute__c createCFA(Id quoteId,Id proposalLineItem) {
		Customer_facing_Attribute__c cfA =new Customer_facing_Attribute__c();
		cfA.Attribute_Label__c = 'G2R site';
		cfA.Attribute_Value__c = '2350200';
		cfA.Attribute_Visibility__c = 'Yes';
		cfA.Attribute_Indicator__c = 'Item';
		cfA.Quote_Line_Item__c =proposalLineItem;
		cfA.Quote__c =  quoteId;  
		return cfA;
	}
	
	public static Apttus_Proposal__Proposal_Line_Item__c proposalLineItemCreation(Id QuoteId,Apttus_Config2__PriceListItem__c plline) {
		Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
		proposalLineItem.Apttus_QPConfig__ItemSequence__c = 2;
		proposalLineItem.Apttus_QPConfig__LineNumber__c = 4;
		proposalLineItem.Apttus_Proposal__Proposal__c = QuoteId;
	 //   proposalLineItem.External_Reference__c ='916876';
		proposalLineItem.Apttus_QPConfig__PriceListItemId__c =  plline.id;
		return proposalLineItem;
	}
	
	public static list<Account> createAccount(integer size) {
		list<Account> accList = new list<Account>();
		for (integer i = 0; i < size; i++) {
			Account acc = new Account();
			acc.Name = 'Test Account -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			acc.BillingStreet = '1660 International Dr';
			acc.BillingCity = 'McLean';
			acc.BillingState = 'maharashtra';
			acc.BillingPostalCode = '22102';
			acc.BillingCountry = 'india';
			acc.AccountStatusInCRMOM__c = 'Active';
			acc.Industry = 'Enterprise';
			acc.Market__c = 'Market India';
			acc.Country__c = 'India';
			//acc.Customer_Compliance__c='US_Govern';
			acc.Acc_No__c = '101994456' + Utils.generateRandomInteger(4) + Utils.generateRandomString(4);
			//acc.CBT_CT_Code__c='NAM US Regionals';
			//acc.Customer_Compliance__c = 'unassigned';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();			
			acc.AccountNumber = '301030871';
			
			if(size > 1 && i == size-1) //Make the last account a Legal Entity
				acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();			

			accList.add(acc);
		}
		return accList;
	}
	
	public static Apttus_Config2__PriceList__c priceList() {
		 Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
		 return priceListObj;
	}
	public static Apttus_Config2__PriceListItem__c createPriceListItem( Apttus_Config2__PriceList__c priceListObj) {
			Apttus_Config2__PriceListItem__c priceListItemObj = new Apttus_Config2__PriceListItem__c();
			priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj.id;
			priceListItemObj.Apttus_Config2__ContractItemNumber__c ='916876';
		return priceListItemObj;
	}

}