/****************************************
 * Class Name : HWS_ShippedCaseEmailNotification_Test
 * Created Date: 09 Apr 2019
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for the classes HWS_ShippedCaseEmailNotification
 * HWST-1376
*****************************************/

@isTest
private class HWS_ShippedCaseEmailNotification_Test {
   // public static String EmailCheck = 'Shipment confirmation'; 
	@isTest static void hwsShippedCaseEmailNotificationTest(){
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		HWS_BypassStatusChangeValidation__c byp = new HWS_BypassStatusChangeValidation__c();
		byp.HWS_BypassCaseStatusValidation__c = true;	   
		insert byp;
		
		Test.startTest();					
		Account acc1 = HWS_DataFactory_TEST.createAccountRec();			
		acc1.Email_Send_Check__c='Shipment confirmation';
		acc1.Customer_Compliance__c = 'US_AT&T';
		insert acc1;
		
		Account legalAcc = HWS_DataFactory_TEST.insertAccount();
		legalAcc.ParentId=acc1.Id;
		legalAcc.Email_Send_Check__c='Shipment confirmation';
		insert legalAcc;
		
		Account acc2 = HWS_DataFactory_TEST.createLogisticAccount(); 
		acc2.BillingState='Andhra Pradesh';
		insert acc2;
		
		Contact contCase = HWS_DataFactory_TEST.insertContact ();
		contCase.AccountId = acc1.id;
		contCase.Email = 'Test@g.com';
		insert contCase;
		
		product2 prdtest=HWS_DataFactory_TEST.insertproduct2();
		insert prdtest;
		
		Asset ast = new Asset();
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		ast.RecordTypeId = assetRecordType;
		ast.Name = 'Test Asset';
		ast.AccountId = legalAcc.id; 
		ast.Product2Id = prdtest.Id;
		ast.HWS_SourceSystem__c = 'Puma1';
		ast.HWS_Price__c = '10';
		insert ast;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = legalAcc.id;
		parentCase.ContactId = contCase.Id;
		parentCase.Hws_Ship_to_Party_Address__c = acc2.Id;
		parentCase.HWS_ShipmentRecipientEmailId__c = 'Test@g.com';
		parentCase.HWS_Communication_Contact__c = contCase.Id;
		insert parentCase;
		
		List<Case> caseList = new List<Case>();
		Map <Id, Case> oldCaseMap = new Map <Id, Case>();
		
		
		Case childCase1 = new Case();			
		childCase1.ParentId=parentCase.Id;
		childCase1.AccountId = legalAcc.id;
		parentCase.ContactId = contCase.Id;
		childCase1.ContactId = contCase.Id;
		childCase1.AssetId = ast.Id;
		childCase1.HWS_AWBNumber__c = '123456';
		childCase1.Status = 'Draft';
		childCase1.HWS_Shippeddate__c= System.Today();  
		childCase1.RecordtypeId=exchangeInDays;
		insert childCase1;
		oldCaseMap.put(childCase1.Id, childCase1);
		
		Case newCase = new case(Id=childCase1.Id);
		newCase.Status = 'Shipped';
		newCase.Origin='Web';
		update newCase;
		caseList.add(newCase);
		
		//HWS_ShippedCaseEmailNotification.sendEmailNotification(oldCaseMap, caseList);			
		Test.stopTest();
	}  
	
	@isTest static void hwsShippedCaseEmailNotificationSPSTest(){
		HWS_BypassStatusChangeValidation__c byp = new HWS_BypassStatusChangeValidation__c();
		byp.HWS_BypassCaseStatusValidation__c = true;
		insert byp;
		
		Test.startTest();					
		Account acc1 = HWS_DataFactory_TEST.createAccountRec();	 
		acc1.Email_Send_Check__c='Shipment confirmation';
		acc1.Customer_Compliance__c = 'US_AT&T';
		insert acc1;
		
		Account legalAcc = HWS_DataFactory_TEST.insertAccount();
		legalAcc.ParentId=acc1.Id;
		legalAcc.Email_Send_Check__c='Shipment confirmation';
		insert legalAcc;
		
		Account acc2 = HWS_DataFactory_TEST.createLogisticAccount(); 
		acc2.BillingState='Andhra Pradesh';
		insert acc2;
		
		Contact contCase = HWS_DataFactory_TEST.insertContact ();
		contCase.AccountId = acc1.id;
		contCase.Email = 'Test@g.com';
		insert contCase;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		Id spsCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
		Id spsCaseChild = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES_READ_ONLY);
		parentCase.AccountId = legalAcc.id;
		parentCase.ContactId = contCase.Id;
		parentCase.Hws_Ship_to_Party_Address__c = acc2.Id;
		//parentCase.HWS_ShipmentRecipientEmailId__c = 'Test@g.com';
		parentCase.HWS_Communication_Contact__c = contCase.Id;
		insert parentCase;
		
		List<Case> caseList = new List<Case>();
		Map <Id, Case> oldCaseMap = new Map <Id, Case>();
		
		product2 prdtest=HWS_DataFactory_TEST.insertproduct2();
		insert prdtest;
		
		Asset ast = new Asset();
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		ast.RecordTypeId = assetRecordType;
		ast.Name = 'Test Asset';
		ast.AccountId = legalAcc.id; 
		ast.Product2Id = prdtest.Id;
		ast.HWS_SourceSystem__c = 'Puma1';
		ast.HWS_Price__c = '10';
		insert ast;
		
		Case childCase1 = new Case();			
		childCase1.ParentId=parentCase.Id;
		childcase1.AccountId = legalAcc.id;
		childCase1.ContactId = contCase.Id;
		childCase1.AssetId = ast.Id;
		childCase1.RecordTypeId=spsCase;
		childCase1.HWS_AWBNumber__c = '123456';
		childcase1.HWS_Quantity__c=10;
		childCase1.Status = 'Draft';
		childcase1.HWS_Sellable_Product__c=prdtest.Id;
		childCase1.HWS_Shippeddate__c= System.Today();  
		insert childCase1;
		oldCaseMap.put(childCase1.Id, childCase1);
		
		Case newCase = new case(Id=childCase1.Id);
		newCase.Status = 'Partially Shipped';
		newCase.HWS_AWBNumber__c = '12345';
		newCase.RecordTypeId =spsCaseChild;
		update newCase;
		caseList.add(newCase);
		
		//HWS_ShippedCaseEmailNotification.sendEmailNotification(oldCaseMap, caseList);			
		Test.stopTest();
	} 
}