@isTest
public class RebidDirectControllerTest{
	Public String uid= UserInfo.getUserId();
	Public String Name='Test Surinder Quote';
	Public String OppId;
	Public String recordType  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();  
	Public String Portfolio = 'IP Routing';	
	Public String Description = 'Test Shashi Description';
	Public Boolean quoteQWM = True;	
 
		  
	static testMethod void createQuoteRecord(){  
			
		//Create a Customer Account 
		Account acc=new Account();
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.name='Test Account';
		acc.AccountNumber ='101234569';
		acc.Acc_No__c ='101234569';
		acc.CurrencyIsoCode ='USD';
		acc.Active__c=true;
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.GEOLevel1ID__c ='RG_NAM';
		acc.AccountLifecycleStatus__c='Opportunity';
		insert acc;		
		//Create a Legal Entity Account 
		Account accLegalEntity = new Account();
		accLegalEntity.Name = 'Test Account Legal Entity';
		accLegalEntity.AccountNumber='101234570';
		accLegalEntity.Acc_No__c = '101234570';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.Active__c = true;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accLegalEntity;		
		//Create an Opportunity Record
		Opportunity opp = new Opportunity();
		opp.Name='Test Opportunity';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opp.AccountId=acc.Id;
		opp.CurrencyIsoCode='USD';
		opp.Phase_Status__c = 'Opportunity in Progress';
		opp.Lead_BG__c='MN';
		opp.Lead_BU__c='MN';
		opp.Account_Role__c='Alliance Partner';
		opp.StageName='Develop Opportunity';
		opp.CloseDate=System.today();
		insert opp;
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = acc.Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opp.Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].isFirstRebidQuote__c=false;
		proposals[0].NokiaCPQ_Proposal_Id__c='21.US.952731 Q 1 C';
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals;
		proposals[0].isFirstRebidQuote__c=false;
		update proposals;
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		  Name = 'Commercial Price List', 
		  Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		 //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	  Name = 'APTTUS Test Config', 
	  Apttus_Config2__AccountId__c = acc.Id, 
	  Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
	  Apttus_QPConfig__Proposald__c = proposals[0].Id, 
	  Apttus_Config2__Status__c = 'Saved', 
	  Apttus_Config2__VersionNumber__c = 1, 
	  Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
	  Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
	  Apttus_Config2__BusinessObjectType__c = 'Proposal',
	  NokiaCPQ_Quote_Type__c='Direct CPQ',
	   XAE_Flag__c = 'sPRM'
	  
	);
	insert ProdConfig;
	 
	   Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  //Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	);
	insert pLI1;
	list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
	  Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	  Apttus_Config2__ItemSequence__c = 1,
	  Apttus_Config2__LineNumber__c = 1,
	  //Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
	  Apttus_Config2__LineStatus__c='New',
	  Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
	  //Apttus_Config2__ChargeType__c = 'Standard Type',
	  Apttus_Config2__ChargeType__c = 'Standard Price', 
	  Apttus_Config2__LineType__c = 'Product/Service',
	  //Apttus_Config2__ProductId__c = prod1.Id,
	  Apttus_Config2__PriceListItemId__c = pLI1.id,
	  Apttus_Config2__PriceMethod__c = 'Per Unit',
	  Apttus_Config2__Frequency__c = 'One Time',
	  Apttus_Config2__AdjustmentAmount__c = 10,
	  Apttus_Config2__ListPrice__c = 100,
	  Apttus_Config2__Quantity__c = 1,
	  
	  Apttus_Config2__PrimaryLineNumber__c = 1,
	  Apttus_Config2__ShipToAccountId__c = acc.Id,	 
	  Apttus_Config2__AddedBy__c = 'added by code'
	);
	  insert LineItem1; 
		CPQ_Site_Phase_and_Quantity__c obj = new CPQ_Site_Phase_and_Quantity__c(Line_Item__c=LineItem1.id);
		insert obj;
		test.startTest();
		RebidDirectController.rebidQuote(proposals[0].id);
		test.stopTest();
	}  
	static testMethod void createQuoteRecord1(){		
		//Create a Customer Account 
		Account acc=new Account();
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.name='Test Account';
		acc.AccountNumber ='101234569';
		acc.Acc_No__c ='101234569';
		acc.CurrencyIsoCode ='USD';
		acc.Active__c=true;
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.GEOLevel1ID__c ='RG_NAM';
		acc.AccountLifecycleStatus__c='Opportunity';
		insert acc;		
		//Create a Legal Entity Account 
		Account accLegalEntity = new Account();
		accLegalEntity.Name = 'Test Account Legal Entity';
		accLegalEntity.AccountNumber='101234570';
		accLegalEntity.Acc_No__c = '101234570';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.Active__c = true;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accLegalEntity;		
		//Create an Opportunity Record
		Opportunity opp = new Opportunity();
		opp.Name='Test Opportunity';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opp.AccountId=acc.Id;
		opp.CurrencyIsoCode='USD';
		opp.Phase_Status__c = 'Opportunity in Progress';
		opp.Lead_BG__c='MN';
		opp.Lead_BU__c='MN';
		opp.Account_Role__c='Alliance Partner';
		opp.StageName='Develop Opportunity';
		opp.CloseDate=System.today();
		insert opp;
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = acc.Id;
	   
		proposals[0].Apttus_Proposal__Opportunity__c = opp.Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].isFirstRebidQuote__c=false;
		proposals[0].Apttus_Proposal__Approval_Stage__c='Draft';
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals;
		RebidDirectController.rebidQuote(proposals[0].id);
		
		
		
		
		
	}  
   
	
}