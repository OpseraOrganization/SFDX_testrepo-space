@isTest(SeeAllData=False)
public class CPQ_ProductStatusCheckController_Test {
	 static testmethod void testmethod1()
	 {
		
		  //create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		   
		 
		  //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;  
		 
		 Offer__c offer = TestDataFactory.OfferCreation(1, opportunities[0])[0];
		 insert offer;
		
		NokiaCPQ_Product_Status__c nps = new NokiaCPQ_Product_Status__c();
		 nps.Name = 'Release';
		nps.Error_Message__c = 'Test';
		insert nps;

		//create Accreditation
	   /*ist<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations; */
		 
	   Test.startTest();
			 
		 Apttus_Proposal__Proposal__c proposal =new Apttus_Proposal__Proposal__c(
		 Apttus_Proposal__Account__c = accounts[0].Id,  
		 Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		 NokiaCPQ_Portfolio__c  = 'IP Routing',
		 NokiaCPQ_No_of_Years__c	= '1',
		 NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Repair)',
		 Offer__c = offer.id,   
		 Quote_Status__c='Price',
			 NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true,
		 //Offer__c= offer.id,
		 Submitted_Date__c = System.today(),
		 RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()//direct draft quote
		 );
		 insert proposal;
		 
		 /*
		  Apttus_Proposal__Proposal__c proposal1 =new Apttus_Proposal__Proposal__c(
		 Apttus_Proposal__Account__c = accounts[0].Id,  
		 Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		 NokiaCPQ_Portfolio__c  = 'IP Routing',
		 NokiaCPQ_No_of_Years__c	= '1',
		 NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Repair)',
		 Quote_Status__c='Price',
		 Submitted_Date__c = System.today(),
		 RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()//direct draft quote
		 ); 
		 insert proposal1; */
		 /*
		 NokiaCPQ_Product_Status__c nps = new NokiaCPQ_Product_Status__c();
		 nps.Name = 'Obsolete';
		 insert nps; */
		 
		 
		 Quote_Delivery_Sales_Item__c qds = new Quote_Delivery_Sales_Item__c();
		 qds.Proposal__c = proposal.id;
		 qds.Name = 'Test';
		 qds.Product_Code__c = 'A123';
		 qds.PCI_Code__c = 'H478';
		 
		 insert qds;
		Product2 proinstance = new Product2();
		proinstance.Name = 'Test';
		proinstance.Family = 'Hardware';
		proinstance.NokiaCPQ_State__c  = 'Release'; 
		proinstance.IsActive = true;
		proinstance.NCP_Origin__c = 'OLCS';
		
		proinstance.ProductCode = 'A123';
		insert proinstance;
		 Apttus_Proposal__Proposal_Line_Item__c pli = new Apttus_Proposal__Proposal_Line_Item__c();
		 pli.Apttus_Proposal__Proposal__c = proposal.id;
		 pli.Apttus_QPConfig__LineType__c = Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES;
		 pli.Apttus_Proposal__Product__c = proinstance.id;
		 pli.Apttus_QPConfig__OptionId__c = proinstance.id;
		 //pli.Apttus_Proposal__Product__r.NokiaCPQ_State__c = 'Test';
		 //pli.Apttus_QPConfig__ParentBundleNumber__c = null;
		 insert pli;
		 
		 Apttus_Proposal__Proposal_Line_Item__c pli2 = new Apttus_Proposal__Proposal_Line_Item__c(); 
		 pli2.Apttus_Proposal__Proposal__c = proposal.id;
		 pli2.Apttus_QPConfig__OptionId__c = proinstance.id;
		 pli2.Apttus_QPConfig__LineType__c = Nokia_CPQ_Constants.OPTION;
		 insert pli2; 
		 
		 CPQ_ProductStatusCheckController.getProductStatusResult(proposal.id);
		 Test.stopTest();
	 }
		
	
}