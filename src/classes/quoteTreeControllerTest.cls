@isTest
public class quoteTreeControllerTest {
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
		proposals[0].NokiaCPQ_Proposal_Id__c='21.US.952731 Q 1 C';
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals;
		quoteTreeController.fetchQuote(opp.id);		
		
	}  
	
}