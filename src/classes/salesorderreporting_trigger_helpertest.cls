/*******************************
Class Name: salesorderreporting_trigger_helpertest
Modified by: HCL
Modofied Date: 7th Jan 2021
Description: This class will handle the test code coverage for salesorderreporting_trigger and dependent classes
*******************************/
@isTest
public class salesorderreporting_trigger_helpertest {
	@testSetup
	static void Testdatacreation(){
		user userCreation = TestDataFactory.userCreation(1,'Data Loader Profile')[0];
		insert userCreation;
		System.debug('user is: '+userCreation);
		System.RunAs(userCreation){
			
			Account[] acc = TestDataFactory.createAccount(1);
			database.insert(acc);
			
			Id terrid1 = TestDataFactory.getL7TerritoryId();
			Id terrid2 = TestDataFactory.getAnotherL7TerritoryId();
			system.debug('terrid1: '+terrid1);
			system.debug('terrid2: '+terrid2);
			//system.debug('acct territory: '+ [select id, objectId,territory2Id from ObjectTerritory2Association where objectId = :acc[0].Id]);
			ObjectTerritory2Association objterr = TestDataFactory.assigningAccountToTerritory(1,acc[0],terrid1)[0];
			database.insert(objterr);
			//system.debug('acct territory: '+ [select id, objectId,territory2Id from ObjectTerritory2Association where objectId = :acc[0].Id]);
			database.insert(TestDataFactory.assigningUserToTerritory(1,userCreation,terrid1));
			//system.debug('grps: '+  [SELECT Id,RelatedId,Type FROM Group WHERE Type = 'territory']);
			Opportunity[] oppties = new Opportunity[]{};
	
	Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc[0])[0];
			opp1.StageName='Create Offer (Bid)';
			opp1.Phase_Status__c = 'Offer in Progress';
			oppties.add(opp1);
			
			Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc[0])[0];
			opp2.StageName='Create Offer (Bid)';
			opp2.Phase_Status__c = 'Offer in Progress';
			oppties.add(opp2);
			
			
			database.insert(oppties);
			system.debug('oppties: '+oppties);
			
			CQ_Sync_Quote_EAI__c cqs = new CQ_Sync_Quote_EAI__c(name = Globalconstants.CQ_MAX_SIZE, Size__c = 25);
			database.insert(cqs);
			CQ_Sync_Quote_EAI__c cqs1 = new CQ_Sync_Quote_EAI__c(name = Globalconstants.CQ_SYNCOFFER_INSERT, sync__c = True);
			database.insert(cqs1);
			CQ_Sync_Quote_EAI__c cqs2 = new CQ_Sync_Quote_EAI__c(name = Globalconstants.CQ_SYNCOFFER_UPDATE, sync__c = True);
			database.insert(cqs2);
			CQ_Sync_Quote_EAI__c cqs3 = new CQ_Sync_Quote_EAI__c(name = Globalconstants.CQ_OFFER_REQUIRED_INFO_MISSING, Message__c = 'Required information is missing. Please ensure you have Account Number and Opportunity Reference Number.');
			database.insert(cqs3);
			CQ_Sync_Quote_EAI__c cqs4 = new CQ_Sync_Quote_EAI__c(name = 'MAX_BULK_SIZE_ERROR', Message__c = 'Maximum batch size for bulk operations exceeded');
			database.insert(cqs4);
			
			system.debug('CQ_Sync_Quote_EAI__c'+ cqs);
			
			Opportunity opp_1 = [select id, opportunity_id__c from opportunity where id = :opp1.id];
			Offer__c off =  TestDataFactory.OfferCreation(1,opp_1)[0];
			
			database.insert(off);
			
			
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			
			Dated_Exchange_Rates__c ExchangeRate_usd = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate_usd.DER_Period__c=nokiaFinCal.id;
			ExchangeRate_usd.CurrencyIsoCode ='USD';
			
			Dated_Exchange_Rates__c ExchangeRate_eur = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate_eur.DER_Period__c=nokiaFinCal.id;
			ExchangeRate_eur.CurrencyIsoCode ='EUR';
			
			Dated_Exchange_Rates__c ExchangeRate_inr = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate_inr.DER_Period__c=nokiaFinCal.id;
			ExchangeRate_inr.CurrencyIsoCode ='INR';
			
			
			Dated_Exchange_Rates__c[] ExchangeRate = new Dated_Exchange_Rates__c[]{};
	ExchangeRate.add(ExchangeRate_usd);
			ExchangeRate.add(ExchangeRate_eur);
			ExchangeRate.add(ExchangeRate_inr);
			database.insert(ExchangeRate);
		}
	}
	@istest
	static void datacreation(){
		
		user userCreation = TestDataFactory.userCreation(1,'Integration API Only Profile')[0];
		insert userCreation;
		System.RunAs(userCreation){
			Account[] acc = [select Id, AccountNumber from Account];
			Opportunity[] Oppty = [select id, Opportunity_Id__c from opportunity];
			Opportunity opp1 = Oppty[0];
			Opportunity opp2 = oppty[1];
			
			
			
			Dated_Exchange_Rates__c ExchangeRate_usd = [select Exchange_Rate__c from Dated_Exchange_Rates__c where currencyisocode = 'USD'];
			Dated_Exchange_Rates__c ExchangeRate_EUR = [select Exchange_Rate__c from Dated_Exchange_Rates__c where currencyisocode = 'EUR'];
			Dated_Exchange_Rates__c ExchangeRate_inr = [select Exchange_Rate__c from Dated_Exchange_Rates__c where currencyisocode = 'INR'];
			
			Apttus_Proposal__Proposal__c cq1 = TestDataFactory.createCQ(1,acc[0],opp1)[0];
			cq1.NokiaCPQ_Proposal_Id__c= 'cq1234';
			cq1.cq_value__c = 100;
			cq1.Submitted_Date__c = system.today();
			
			
			Apttus_Proposal__Proposal__c cq2 = TestDataFactory.createCQ(1,acc[0],opp2)[0];
			cq2.NokiaCPQ_Proposal_Id__c= 'cq1235';
			cq2.cq_value__c = 100;
			cq2.Submitted_Date__c = system.today();
			
			try{
	Apttus_Proposal__Proposal__c[] cq = new Apttus_Proposal__Proposal__c[]{};
		cq.add(cq1);
	cq.add(cq2);
	database.insert(cq);
	Apttus_Proposal__Proposal__c[] CQ_ins = [select id, NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c];
	system.debug('CQ_ins: '+CQ_ins);
	system.debug('cq1: '+cq1);
	system.debug('cq2: '+cq2);
	system.debug('opp1: '+opp1);
	system.debug('opp2: '+opp2);
	
	
	
	Test.startTest();
	Surround_CQ_Reporting__c cq_rep = new Surround_CQ_Reporting__c();
	cq_rep.Account_Name__c = acc[0].id;
	cq_rep.CQ_Number__c = cq1.NokiaCPQ_Proposal_Id__c;
	database.insert(cq_rep);
	
	
	
	Sales_Order_Reporting__c so_usd =TestDataFactory.createSalesOrder(1,CQ_ins[0],acc[0])[0];
	so_usd.PO_Amount__c = 1000;
	so_usd.CurrencyIsoCode = 'USD';
	so_usd.Order__c = [select offer_number__c from offer__c].offer_number__c;
	so_usd.Contracted_Quote__c = cq1.id;
	
	
	Sales_Order_Reporting__c so_eur =TestDataFactory.createSalesOrder(1,CQ_ins[0],acc[0])[0];
	so_eur.PO_Amount__c = 1000;
	so_eur.CurrencyIsoCode = 'EUR';
	so_eur.ALU_Order_Number__c= '100011';
	so_eur.Contracted_Quote__c = cq2.id;
	
	Sales_Order_Reporting__c so_inr =TestDataFactory.createSalesOrder(1,CQ_ins[0],acc[0])[0];
	so_inr.PO_Amount__c = 1000;
	so_inr.CurrencyIsoCode = 'INR';
	so_inr.ALU_Order_Number__c= '100012';
	
	
	Sales_Order_Reporting__c[] so = new  Sales_Order_Reporting__c[]{};
		so.add(so_usd);
	so.add(so_eur);
	so.add(so_inr);
	System.debug('Before sales order reporting save in test class');
	database.saveresult[] so_sav = database.insert(so);
	system.debug('so_sav: '+ so_sav);
	system.debug('so_eur: '+so_eur);
	system.debug('cq'+cq1);
	map<id,Sales_Order_Reporting__c> so_ins = new map<id,Sales_Order_Reporting__c>([select id,Contracted_Quote__c,PO_Amount_EUR__c,PO_Amount_USD__c,PO_Amount__c,order__c from Sales_Order_Reporting__c]);
	system.debug('so_ins'+so_ins);
	
	
	//USD currency
	decimal sousd_eur = (so_ins.get(so_usd.id).PO_Amount__c/ExchangeRate_usd.Exchange_Rate__c).setscale(2);
	system.debug('sousd_eur '+sousd_eur);
	
	system.assertequals(sousd_eur,so_ins.get(so_usd.id).PO_Amount_EUR__c);
	system.assertequals(so_usd.PO_Amount__c,so_ins.get(so_usd.id).PO_Amount_USD__c);
	//system.assertEquals(cq1.id, so_ins.get(so_usd.id).Contracted_Quote__c);
	
	//EUR Currency
	decimal soeur_eur = so_eur.PO_Amount__c;
	decimal soeur_usd = (so_eur.PO_Amount__c*ExchangeRate_usd.Exchange_Rate__c).setscale(2);
	system.debug('soeur'+soeur_eur+', '+soeur_usd);
	
	system.assertequals(soeur_eur,so_ins.get(so_eur.id).PO_Amount_EUR__c);
	system.assertequals(soeur_usd,so_ins.get(so_eur.id).PO_Amount_USD__c);
	
	//INR CUrrency
	decimal soinr_eur = (so_inr.PO_Amount__c/ExchangeRate_inr.Exchange_Rate__c).setscale(2);
	decimal soinr_usd = ((so_inr.PO_Amount__c/ExchangeRate_inr.Exchange_Rate__c)*ExchangeRate_usd.Exchange_Rate__c).setscale(2);
	system.debug('soinr'+soinr_eur+', '+soinr_usd);
	
	
	system.assertequals(soinr_eur,so_ins.get(so_inr.id).PO_Amount_EUR__c);
	system.assertequals(soinr_usd,so_ins.get(so_inr.id).PO_Amount_USD__c);
	
	/// Update tests
	
	Sales_Order_Reporting__c so_upd1 = so_ins.get(so_inr.id);
	so_upd1.po_amount__c = 2000;
	so_upd1.Order__c=CQ_ins[1].NokiaCPQ_Proposal_Id__c;
	System.debug('before update in Salesorder reporting');
	database.update(so_upd1);
			}
			catch(Exception ex){
	System.debug('Exception ::> '+ex.getMessage());
			}
		}
		
	}
	static testmethod void singleSOCreation(){
		user userCreation = TestDataFactory.userCreation(1,'Integration API Only Profile')[0];
		insert userCreation;
		System.RunAs(userCreation){
			Account[] acc = [select Id, AccountNumber from Account];
			opportunity[] opptys = [select id, stagename,opportunity_id__c from opportunity];
			opportunity oppty1 = opptys[0];
			opportunity oppty2 = opptys[1];
			Apttus_Proposal__Proposal__c cq1 = TestDataFactory.createCQ(1,acc[0],oppty1)[0];
			cq1.NokiaCPQ_Proposal_Id__c= 'cq1234';
			cq1.CQ_Value__c = 100;
			
			Apttus_Proposal__Proposal__c cq2 = TestDataFactory.createCQ(1,acc[0],oppty2)[0];
			cq2.NokiaCPQ_Proposal_Id__c= 'cq1235';
			cq2.CQ_Value__c = 100;
			
			Apttus_Proposal__Proposal__c[] cq = new Apttus_Proposal__Proposal__c[]{};
	cq.add(cq1);
			cq.add(cq2);
			
			try{
	database.insert(cq);
	Apttus_Proposal__Proposal__c[] CQ_ins = [select id, NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c];
	system.debug('CQ_ins: '+CQ_ins);
	system.debug('cq1: '+cq1);
	system.debug('cq2: '+cq2);
	system.debug('opp1: '+oppty1);
	system.debug('opp2: '+oppty2);
	
	Surround_CQ_Reporting__c cq_rep = new Surround_CQ_Reporting__c();
	cq_rep.Account_Name__c = acc[0].id;
	cq_rep.CQ_Number__c = cq1.NokiaCPQ_Proposal_Id__c;
	database.insert(cq_rep);
	
	
	Test.startTest();
	Sales_Order_Reporting__c so_usd =TestDataFactory.createSalesOrder(1,CQ_ins[0],acc[0])[0];
	so_usd.PO_Amount__c = 1000;
	so_usd.CurrencyIsoCode = 'USD';
	//so_usd.Contracted_Quote__c = cq2.id;
	Sales_Order_Reporting__c[] so = new  Sales_Order_Reporting__c[]{};
		so.add(so_usd);
	database.saveresult[] so_sav = database.insert(so);
	system.debug('so_sav: '+ so_sav);
	
	Sales_Order_Reporting__c so_eur =TestDataFactory.createSalesOrder(1,CQ_ins[0],acc[0])[0];
	so_eur.PO_Amount__c = 1000;
	so_eur.CurrencyIsoCode = 'EUR';
	insert(so_eur);
	system.debug('so_eur: '+ so_eur);
	
	system.debug('cq'+cq1);
	map<id,Sales_Order_Reporting__c> so_ins = new map<id,Sales_Order_Reporting__c>([select id,Contracted_Quote__c,PO_Amount_EUR__c,PO_Amount_USD__c,PO_Amount__c,order__c,currencyisocode from Sales_Order_Reporting__c]);
	system.debug('so_ins'+so_ins);
	system.debug('so_usd'+so_usd);
	system.debug('so_ins_euramt: '+ so_ins.values()[0].PO_Amount_EUR__c );
	system.debug('so_ins.get eur: '+ so_ins.get(so_usd.id).PO_Amount_EUR__c);
	system.debug('so_ins.get usd: '+ so_ins.get(so_usd.id).PO_Amount_USD__c);
	
	Dated_Exchange_Rates__c ExchangeRate_usd = [select Exchange_Rate__c from Dated_Exchange_Rates__c where currencyisocode = 'USD'];
	
	//USD currency
	decimal sousd_eur = (so_ins.get(so_usd.id).PO_Amount__c/ExchangeRate_usd.Exchange_Rate__c).setscale(2);
	system.debug('sousd_eur '+sousd_eur);
	
	system.assertequals(sousd_eur,so_ins.get(so_usd.id).PO_Amount_EUR__c);
	system.assertequals(so_usd.PO_Amount__c,so_ins.get(so_usd.id).PO_Amount_USD__c);
	
	delete so_eur;
	Test.stopTest();
			}
			catch(Exception ex){
	System.debug('Exception::> '+ex.getMessage());
			}
		}
	}
}