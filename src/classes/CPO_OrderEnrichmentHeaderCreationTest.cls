/*********************************************************************
* Class Name : CPO_OrderEnrichmentHeaderCreationTest
* Test Class for : CPO_OrderEnrichmentHeaderCreation
* Created Date: 17 Jun 2021
* Created By : Harsha Gobburi
*******************************************************************/
@IsTest 
public class CPO_OrderEnrichmentHeaderCreationTest {
	@isTest
	private static void positiveTest() {
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Customer_Document_Id__c = '672338872039';
		
		insert cd;
		
		cd.Status__c = QTO_Constants.CD_STATUS_LEGACY;
		
		update cd;
		
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpo =
			[SELECT Id, Legacy_CPO__c, Apttus_Config2__Status__c
			 FROM Apttus_Config2__CustomerPurchaseOrder__c LIMIT 1];
		
		if (!cpo.isEmpty()) {
			cpo[0].Apttus_Config2__Status__c = CSWXGlobalConstant.ReadyforExecution;
			cpo[0].Legacy_CPO__c = true;
			update cpo[0];
			
			Map<Id, Apttus_Config2__CustomerPurchaseOrder__c> cpoOldmap =
					new Map<Id, Apttus_Config2__CustomerPurchaseOrder__c>();
			cpoOldmap.put(cpo[0].Id, cpo[0]);
			List<Customer_Document__c> cdList=new List<Customer_Document__c>();
			cdList.add(cd);
			CPO_OrderEnrichmentHeaderCreation.createEnrichment(cdList);
			CPOTriggerHandler.checkEnrichment(cpo, cpoOldmap);
		}
	}
	
}