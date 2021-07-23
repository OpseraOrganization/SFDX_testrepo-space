@isTest
public class HWS_OrderConfirmationNotificationTest {
	@isTest
	static void testOrderConfirmationNotification(){
		
		Test.startTest();
			Id parentCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
			Id exchangeInHours = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_HOURS);
			Id childCaseReadonly=HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_CHILD_CASE_READ_ONLY);
			Id parentCaseReadOnly = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE_READ_ONLY);
			Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
			//Customer Account
			Account acc = HWS_DataFactory_TEST.createAccountRec();			
			acc.Customer_Compliance__c = 'US_AT&T';	
			acc.Acc_No__c = '2345';
			acc.P20_Logistic_ID__c = '12340';
			acc.name='test';	 
			acc.HWS_Address_Status__c = 'Permanent Address';
			acc.BillingCountry = 'India';
			acc.BillingStreet = 'Test';
			acc.BillingCity ='Test';
			acc.BillingPostalCode = '1234';
			acc.Email_Send_Check__c = 'Order Confirmation';
			insert acc;
			
			System.assertEquals(acc.BillingPostalCode, '1234');
			
			//Logistic Account
			Account logAcc = HWS_DataFactory_TEST.createLogisticAccount(); 
			logAcc.Acc_No__c = '23456123';
			logAcc.P20_Logistic_ID__c = '12345';
			logAcc.name='test';	 
			logAcc.HWS_Address_Status__c = 'Permanent Address';
			logAcc.BillingCountry = 'India';
			logAcc.BillingStreet = 'Test';
			logAcc.BillingCity ='Test';
			logAcc.BillingPostalCode = '1234';
			logAcc.Email_Send_Check__c = 'Order Confirmation';
			insert logAcc; 
			
			
			
			//Legal Account
			Account legalAcc = HWS_DataFactory_TEST.insertAccount();
			legalAcc.ParentId = acc.Id;
			legalAcc.Acc_No__c = '234561200';			
			legalAcc.BillingCountry = 'India';
			legalAcc.BillingStreet = 'Test';
			legalAcc.BillingCity ='Test';
			legalAcc.BillingPostalCode = '1234';
			legalAcc.Email_Send_Check__c = 'Order Confirmation';
			insert legalAcc; 
			
			Contact con = HWS_DataFactory_TEST.createContactRec(acc);
			insert con;
			
			Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByName().get('Sales Product').getRecordTypeId();
			Product2 prod = HWS_DataFactory_TEST.creteProduct(rtId);
			prod.ProductCode = 'xyz4567878';
			insert prod;
			
			Asset ast = HWS_DataFactory_TEST.insertAsset(legalAcc,prod);		
			ast.RecordTypeId = assetRecordType;
			ast.HWS_SourceSystem__c  = 'Puma1';
			ast.AccountId=legalAcc.Id;
			insert ast;
			
			Case parentCas=HWS_DataFactory_TEST.insertParentCase();
			parentCas.HWS_ReturnAddressReceivedFromSOO__c=True;
			parentCas.HWS_OrderConfirmationSent__c=true;
			parentCas.HWS_ShipTopartyId__c=null;
			parentCas.HWS_FaultyUnitReceivedDate__c = System.Today();
			parentCas.AccountId = legalAcc.Id;
			parentCas.ContactId = con.Id;
			parentCas.HWS_Communication_Contact__c = con.Id;
			parentCas.Origin = 'web';
			insert  parentCas;
			
			List<Case> childCaseList= new List<Case>();
			Case caserec = new Case();
			caserec.AccountId = legalAcc.Id;
			caserec.AssetId=ast.Id;
			caserec.RecordTypeId =childCaseReadonly;
			caserec.Status='Ordered';
			caserec.ParentId=parentCas.Id;
			caserec.HWS_RMA_Number__c='00019309-001';
			caserec.HWS_Customer_Reference_Number__c='232584';
			caserec.HWS_Faulty_Serial_Number__c='21234556';
			//caserec.HWS_ShipTopartyId__c='1234566';
			caserec.Hws_Ship_to_Party_Address__c=logAcc.Id;
			caserec.HWS_ShipTopartyId__c=null;
			caserec.HWS_FaultyUnitReceivedDate__c = System.Today();
			caserec.HWS_Sellable_Product__c = prod.Id;
			caserec.ContactId = con.Id;
			// caserec.HWS_OrderConfirmationSent__c=true;
			childCaseList.add(caserec);
			insert childCaseList;
			Set<Id> caseIdSet = new Set<Id>();
			for(Case c :childCaseList){
	caseIdSet.add(c.Id);
			}
	
			HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(caseIdSet);

		Test.stopTest();	
	}
}