/****************************************
 * Name : CancelCollaborationHandlerTest
 * Author : Accenture
 * Description : Test class for CancelCollaborationHandler class,cancell collaboration notification for previous assigned user.
 *****************************************/
@istest(SeeAllData=False)
public class CancelCollaborationHandlerTest{
  
   static testmethod void cancelCollaborationNotification(){
	
	  User sysAdminUser = TestDataFactory.createSystemAdminUser();
	  sysAdminUser.Nokia_ID__c = '54673854729';
	  
	  System.runAs(sysAdminUser){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
	  
		//create opportunity
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Account_Role__c = 'Alliance Partner';
		  opportunities[0].End_Customer_LE__c = accounts[1].id;
				insert opportunities;  
	  
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		
		Test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].Reprice_In_Progress__c = false;
		insert proposals;
	  
		system.debug('proposals[0].Id;--->'+proposals[0].Id);
	
	   
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Global Price List (EUR)', Apttus_Config2__Active__c = True);
		insert priceList;
	  
	   
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Collaboration Request';
		insert prodConfigs;
	  
		//get a IP Routing Product
		//Product2 productInst = new Product2();
		List<Product2> productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	  
		// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
				if(productInst.size() > 0)
				lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
		insert lineItems;
		
		Test.stopTest();
		
		List<Apttus_Config2__CollaborationRequest__c > canCollReqList = new List<Apttus_Config2__CollaborationRequest__c>();

		Apttus_Config2__CollaborationRequest__c  accred = new Apttus_Config2__CollaborationRequest__c (
		//Owner ='Akrati Mattoo',
		Apttus_Config2__ParentConfigurationId__c = prodConfigs[0].Id,
		Apttus_Config2__Status__c = 'Submitted',
		Apttus_Config2__CollaborationType__c='Peer-To-Peer');
		
		canCollReqList.add(accred);
		 
		Apttus_Config2__CollaborationRequest__c  coll2= new Apttus_Config2__CollaborationRequest__c (
		//Owner ='Akrati Mattoo',
		Apttus_Config2__ParentConfigurationId__c = prodConfigs[0].Id,
		Apttus_Config2__Status__c = 'Submitted',
		Apttus_Config2__CollaborationType__c='Peer-To-Peer');
		canCollReqList.add(coll2);
		insert canCollReqList;

		delete canCollReqList[0];
	
		prodConfigs[0].Apttus_Config2__CollaborationRequestId__c = canCollReqList[1].Id;
		
		update prodConfigs;
		
		delete canCollReqList[1];
	  }
   
  }
  
	  
}