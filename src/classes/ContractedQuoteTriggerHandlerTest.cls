@isTest
private class ContractedQuoteTriggerHandlerTest 
{
	private static Id usrID {get; set;}
	
	static testmethod void RunTest()
	{
		test.startTest();
		user usr = TestDataFactory.userCreation(1, 'System Administrator')[0];
		INSERT usr;
				
		System.RunAs(usr)
		{
			Account[] acc = TestDataFactory.createAccount(1);
			Database.INSERT(acc);
			
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc[0])[0];
			opp1.StageName='Create Offer (Bid)';
			opp1.Phase_Status__c = 'Offer in Progress';
			opp1.Opportunity_ID__c= '19..857057'; 
			Database.INSERT(opp1);
			
			//CREATING QUOTE/PROPOSAL RECORD
			List<Apttus_Proposal__Proposal__c> lstAptus = new List<Apttus_Proposal__Proposal__c>();
			Apttus_Proposal__Proposal__c qto = TestDataFactory.createCQ(1,acc[0],opp1)[0];
			qto.NokiaCPQ_Proposal_Id__c = '19..857057';//Quote Number
			INSERT qto;
			lstAptus.add(qto);
						
			//CREATING Surround CQ RECORD
			List<Contracted_Quote__c> cqList = new List<Contracted_Quote__c>();
			Contracted_Quote__c cq = new Contracted_Quote__c();
			cq.CQ_Number__c ='19..857057.null';
			cq.CQ_Value__c = 123.00;
			cq.CurrencyIsoCode = 'USD';
			cq.Initial_Pricing_Date__c = system.today();
			cq.Ready_for_Submission__c = system.today() + 1;
			cq.Expiration_Date__c = system.today() + 2;
			cq.Surround_Master_Quote__c = true;
			cq.Surround_QTC_Code__c = '7000987';
			INSERT cq; 
			cqList.add(cq);
			
			Contracted_Quote__c cqUpdate = new Contracted_Quote__c();
			cqUpdate.Id = cq.Id;
			cqUpdate.CQ_Value__c = 125.00;
			UPDATE cqUpdate;
			
			Map<Id, Contracted_Quote__c> cqOldMap = new Map<Id, Contracted_Quote__c>();
			cqOldMap.put(cqList[0].Id, cqList[0]);
			Map<String, Apttus_Proposal__Proposal__c> quoteMap = new Map<String, Apttus_Proposal__Proposal__c>();
			quoteMap.put(string.valueOf(cqList[0].CQ_Number__c), qto);
			
			String interfaceType = 'Surround Files';
			String logName = 'Testclass';
			String interfaceReqSent = 'Testclass';
			String comment = 'Testclass';
			String messageType1 = 'CQ UpdateQuote/Status';
			String messageType2 = 'CQ UpdateQuote/Pricing';
			
			ContractedQuoteTriggerHandler obj = new ContractedQuoteTriggerHandler();
			obj.CheckSurroundCQ(cqList, cqOldMap);
			obj.CreateErrorInterfaceLogs(interfaceType, logName, interfaceReqSent, comment);
			obj.CreateSuccessInterfaceLogs(interfaceType, logName, interfaceReqSent);
			obj.UpdateQuoteinQP(lstAptus, messageType1);
			obj.UpdateQuoteinQP(lstAptus, messageType2);
			obj.UpdateQuotePricing(cqList[0], quoteMap);
			obj.UpdateQuoteStatus(cqList[0], quoteMap);
		}
		test.stopTest();
	}
}