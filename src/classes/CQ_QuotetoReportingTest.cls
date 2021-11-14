@isTest
public class CQ_QuotetoReportingTest {
	Private static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	Private static final Id CQ_Read_Only_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CQ_Read_Only').getRecordTypeId();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
	
	public Static List<Apttus_Proposal__Proposal__c> Quotes=new List<Apttus_Proposal__Proposal__c>();
	public Static List<Surround_CQ_Reporting__c> Report=new List<Surround_CQ_Reporting__c>();
	
	static testmethod void QuoteToReporting(){
		
		 user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
			
		//Account accountNoNvzw = NF_TestDataFactory.createAccount('1TestNONVZW0000');
		Account accountVZW = NF_TestDataFactory.createAccount('1TestVZW00000');
		accountVZW.Qtc_sold_to__c=system.Label.VzW_Number;		
		accountVZW.RecordTypeId=custRecordTypeId;
		
		List<Account> accounts=new List<Account>();
		
		accounts.add(accountVZW);	   
		Database.insert(accounts);
		system.debug('accounts--->>'+accounts);
		system.debug('accounts'+accounts[0].Acc_No__c);
		
		Account accountVZW_LegalEnt = NF_TestDataFactory.createAccount('103087199999KDDKD');   
		accountVZW_LegalEnt.Recordtypeid=LERecordTypeId;   
		accountVZW_LegalEnt.Accountnumber='1493593549i';
		//accountVZW_LegalEnt.Accountnumber='1493593549i';
		accountVZW_LegalEnt.ParentId=accounts[0].Id;
		accountVZW_LegalEnt.Default_Legal_Entity__c = true;
		accountVZW_LegalEnt.Partner_Program__c=null;	
		accountVZW_LegalEnt.Qtc_sold_to__c=system.Label.VzW_Number;
		
		
		accounts.add(accountVZW_LegalEnt);	   
		Database.upsert(accounts); 
		system.debug('accounts+LE--->>'+accounts);
		system.debug('accounts+LE'+accounts[1].Acc_No__c);
		
		
		Opportunity OpportunityVZW = NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		OpportunityVZW.Lead_BG__c='NSW';
		OpportunityVZW.RecordTypeId = oppDirectRecordTypeId;
		OpportunityVZW.Business_Type__c = 'Standard Opportunity';
		
		List<opportunity> opportunities=new List<opportunity>();
		
		opportunities.add(OpportunityVZW);
		Database.insert(opportunities);
		system.debug('opportunities---->>'+opportunities);
		
		Test.startTest(); 
		
		
		Apttus_Proposal__Proposal__c Quote_ObjVZW = new Apttus_Proposal__Proposal__c(
			RecordtypeId=Contracted_Quote_RecId,
			CQ_Value__c=100,
			Apttus_Proposal__Proposal_Expiration_Date__c=system.today(),
			Apttus_Proposal__Proposal_Name__c = 'quote',
			Apttus_Proposal__Approval_Stage__c = 'Approved',
			Apttus_Proposal__Account__c = accounts[0].Id,
			Account_Legal_Entity__c=accounts[1].Id,
			CQ_eQuote_Status__c='failure',
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			isCQ__C=true,
			CQ_Due_Date__c  =system.Today()+10,
			CQ_Documents_Attached__c=true,
			CQ_Customer_Organization_Segment__c='VERIZON WIRELESS INC.'
		);
		
		
		
		Quotes.add(Quote_ObjVZW);
		Database.insert(Quotes);	
		
		system.debug('Quotes_queue-->'+Quotes);
		map<id,Apttus_Proposal__Proposal__c> Quote_map = new map<id,Apttus_Proposal__Proposal__c>();
		Quote_map.putAll(Quotes);		
		list<Apttus_Proposal__Proposal__c> cq_number=[select id,NokiaCPQ_Proposal_Id__c from Apttus_Proposal__Proposal__c where id =:Quote_ObjVZW.Id limit 1 ];
		
		
		
		Surround_CQ_Reporting__c cq_report =new Surround_CQ_Reporting__c();
		cq_report.CQ_Number__c=cq_number[0].NokiaCPQ_Proposal_Id__c;
		cq_report.Account_Name__c= accounts[0].Id;
		cq_report.Account_Legal_Entity__c=accounts[1].Id;
		cq_report.CQ_Due_Date__c=system.today()+10;
		cq_report.Opportunity__c=opportunities[0].Id;
		cq_report.Quote_Name__c='quote';
		cq_report.CQ_Status__c='Approved';
		cq_report.Customer_Organization_Segment__c='VERIZON WIRELESS INC.';
		
		Report.add(cq_report);
		//database.insert(Report);		
		database.SaveResult[] cq_report_sav = database.insert(Report);
		system.debug('Report--->>##'+Report);
		GlobalConstants.IS_CQREPORTINGINSERT_FIRSTRUN=false;
		
		map<String,Surround_CQ_Reporting__c> Reporting_map = new  map<String,Surround_CQ_Reporting__c>();
		Reporting_map.put(cq_report.CQ_Number__c, cq_report);
		system.debug('Reporting_map-->>++'+Reporting_map);
		list<CQ_FieldMapping__c> FieldMapping = new list<CQ_FieldMapping__c>();
		CQ_FieldMapping__c CqNumbermap1 = new CQ_FieldMapping__c(Name='1',
																 Field_to_Map__c='CQ_Number__c',
																 Field__c='NokiaCPQ_Proposal_Id__c',
																 IsCQ_toQuoteReporting__c=true);
		CQ_FieldMapping__c CqNumbermap2 = new CQ_FieldMapping__c(Name='2',
																 Field_to_Map__c='CQ_Due_Date__c',
																 Field__c='CQ_Due_Date__c',
																 IsCQ_toQuoteReporting__c=true); 
		CQ_FieldMapping__c CqNumbermap3 = new CQ_FieldMapping__c(Name='3',
																 Field_to_Map__c='Name',
																 Field__c='Apttus_Proposal__Proposal_Name__c',
																 IsCQ_toQuoteReporting__c=true);
		CQ_FieldMapping__c CqNumbermap4 = new CQ_FieldMapping__c(Name='4',
																 Field_to_Map__c='Customer_Organization_Segment__c',
																 Field__c='CQ_Customer_Organization_Segment__c',
																 IsCQ_toQuoteReporting__c=true);
		CQ_FieldMapping__c CqNumbermap5 = new CQ_FieldMapping__c(Name='5',
																 Field_to_Map__c='CQ_Status__c',
																 Field__c='Apttus_Proposal__Approval_Stage__c',
																 IsCQ_toQuoteReporting__c=true);
		CQ_FieldMapping__c CqNumbermap6 = new CQ_FieldMapping__c(Name='6',
																 Field_to_Map__c='Account_Name__c',
																 Field__c='Apttus_Proposal__Account__c',
																 IsCQ_toQuoteReporting__c=true);
		
		FieldMapping.add(CqNumbermap1);
		FieldMapping.add(CqNumbermap2);
		FieldMapping.add(CqNumbermap3);
		FieldMapping.add(CqNumbermap4);
		FieldMapping.add(CqNumbermap5);
		FieldMapping.add(CqNumbermap6);
		
		database.insert(FieldMapping);
		
		list<Apttus_Proposal__Proposal__c> cq_check = new list<Apttus_Proposal__Proposal__c>();
		cq_check = [select id,NokiaCPQ_Proposal_Id__c,CQ_Due_Date__c,Apttus_Proposal__Proposal_Name__c,
					CQ_Customer_Organization_Segment__c,Apttus_Proposal__Approval_Stage__c
					from Apttus_Proposal__Proposal__c where id =:Quotes[0].id];
		
		list<Surround_CQ_Reporting__c> cqreport_check = new list<Surround_CQ_Reporting__c>();
		cqreport_check = [select id,CQ_Number__c,CQ_Due_Date__c,Quote_Name__c,
						  Customer_Organization_Segment__c,CQ_Status__c
						  from Surround_CQ_Reporting__c where id =:Report[0].id];
		
		system.assertEquals(cqreport_check[0].CQ_Number__c,cq_check[0].NokiaCPQ_Proposal_Id__c); 
		system.assertEquals(cqreport_check[0].CQ_Status__c,cq_check[0].Apttus_Proposal__Approval_Stage__c);
		system.assertEquals(cqreport_check[0].CQ_Due_Date__c,cq_check[0].CQ_Due_Date__c);
		system.assertEquals(cqreport_check[0].Quote_Name__c,cq_check[0].Apttus_Proposal__Proposal_Name__c); 
		system.assertEquals(cqreport_check[0].Customer_Organization_Segment__c,cq_check[0].CQ_Customer_Organization_Segment__c);
		
		map<string,string> mapping_field = new map<string,string>();
		mapping_field.put(FieldMapping[0].Field__c,FieldMapping[0].Field_to_Map__c); 
		
		Apttus_Proposal__Proposal__c Quote_ObjVZW_update = new Apttus_Proposal__Proposal__c(
			RecordtypeId=Contracted_Quote_RecId,
			CQ_Value__c=100,
			Apttus_Proposal__Proposal_Expiration_Date__c=system.today()+10,
			Apttus_Proposal__Proposal_Name__c = 'quote_updated',
			Apttus_Proposal__Approval_Stage__c = 'Approved',
			Apttus_Proposal__Account__c = accounts[0].Id,
			Account_Legal_Entity__c=accounts[1].Id,
			CQ_eQuote_Status__c='failure',
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			isCQ__C=true,
			CQ_Due_Date__c  =system.Today()+40  ,
			CQ_Documents_Attached__c=true,
			CQ_Customer_Organization_Segment__c='VERIZON WIRELESS INC.'
		);
		
		
		if(Quote_ObjVZW_update.id==Quote_ObjVZW.Id){
			Quotes.add(Quote_ObjVZW_update);
			Database.update(Quotes);
			
		}
		//map<id,Apttus_Proposal__Proposal__c> Quote_map_update = new map<id,Apttus_Proposal__Proposal__c>();
		
		CQ_QuotetoReporting.GetObjectFields('Apttus_Proposal__Proposal__c');
		CQ_QuotetoReporting.GetObjectFields('Surround_CQ_Reporting__c');		
		CQ_QuotetoReporting.GetDynamic_fields();
		CQ_QuotetoReporting.CQ_ReportFieldmapping(Quotes,mapping_field,Reporting_map);	   
		CQ_QuotetoReporting.CQ_Report_Insert(Quote_map);
		CQ_QuotetoReporting.CQ_Report_Update(Quotes);
		CQ_QuotetoReporting.CQ_Report_Delete(Quotes);		
		GlobalConstants.IS_CQREPORTINGINSERT_FIRSTRUN=true;
		Test.stopTest();
		
		
		}	   
	}
}