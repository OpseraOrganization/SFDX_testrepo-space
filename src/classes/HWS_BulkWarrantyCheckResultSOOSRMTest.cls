@isTest
public class HWS_BulkWarrantyCheckResultSOOSRMTest{

		@testSetup static void testDataSetup()
		{
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		Id coveredProductRecordType = HWS_Utilty.getRecordTypeByName('Asset','CH_CoveredProduct');	
		List<ISO_Country_Codes__c> countryCodeList = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c cc = new ISO_Country_Codes__c();
		cc.Name = 'IN';
		cc.Country_Name__c = 'India';
	
		cc.Market__c='Market India';
		countryCodeList.add(cc);
		ISO_Country_Codes__c cc1 = new ISO_Country_Codes__c();
		cc1.Name = 'AG';
		cc1.Country_Name__c = 'Antigua And Barbuda';
		cc1.Market__c='Market Latin America';
		countryCodeList.add(cc1);
		insert countryCodeList;
		Account custAcc = HWS_DataFactory_TEST.insertAccount();
		custAcc.RecordTypeId =  customerAccountType;
		custAcc.Customer_Compliance__c = 'US_AT&T';
		insert custAcc;
	   
		Account legalAcc = HWS_DataFactory_TEST.insertAccount();
		legalAcc.RecordTypeId =  legalEntityAccountType;
		legalAcc.ParentId = custAcc.Id;
		legalAcc.Name = 'TestLE';
		insert legalAcc;
	   
	   
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = custAcc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
	   
		Product2 prod1 = HWS_DataFactory_TEST.insertproduct2();  
		insert prod1;
	   
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();
		insert pb;  
	   
		PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod1.id, pb.Id);	
		pbety.CurrencyIsoCode='EUR';
		pbety.UseStandardPrice = false;
		pbety.Pricebook2Id = Test.getStandardPricebookId();
		insert pbety;
	   
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(legalAcc);
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.NCP_External_Status__c = 'Active';
		sc.CurrencyIsoCode = 'EUR';
		insert sc;
	   
		Asset covProdAsset = new Asset();
		covProdAsset.RecordTypeId = coveredProductRecordType;
		covProdAsset.AccountId = legalAcc.Id;
		covProdAsset.Product2Id = prod1.Id;
		insert covProdAsset;
	   
	 ContractLineItem cli = new ContractLineItem();
 
		cli.ServiceContractId =sc.Id;
		cli.UnitPrice=0;
		cli.Quantity=1;
		cli.CH_ServiceClassification__c = 'HWS Service';
		cli.PricebookEntryId=pbety.Id;
		cli.HWS_WarrantyVerificationRequired__c='Yes';
		cli.HWS_QuotationRequiredFlag__c='Never';
		cli.HWS_InvoicingType__c='No';
		insert cli;  
   
	   
	   
		Asset ast = HWS_DataFactory_TEST.insertAsset(legalAcc,prod1);  
		ast.RecordTypeId = assetRecordType;
		insert ast;
	   
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';  
		insert hwsv;
	   
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode = 'ABCDEFGH';
		insert prod;  
		   
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = legalAcc.id;
		insert parentCase;
		List<Case> lstCase = new List<case>();
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		parentCase.AccountId = legalAcc.id;
		childCase.ParentId = parentCase.Id;
		childCase.Status='Draft';
		childCase.Subject='test'+1;
		childCase.Description='test' +1;
		childCase.HWS_Faulty_Serial_Number__c= 'test1234';
		childCase.HWS_ShipTopartyId__c='1234566';
	   
		childCase.ContactId = con.Id;
	 
		childCase.HWS_ServiceType__c = 'Advance Exchange in Days';  
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.HWS_WarrantyStatus__c  ='Failed to determine Warranty';
		childCase.HWS_Contract_Line_Item__c = cli.Id;
		lstCase.add(childCase);
		Case childCase2 = HWS_DataFactory_TEST.insertChildCase();
		parentCase.AccountId = legalAcc.id;
		childCase2.ParentId = parentCase.Id;
		childCase2.Status='Draft';
		childCase2.Subject='test'+2;
		childCase2.Description='test' +2;
		childCase2.HWS_Faulty_Serial_Number__c= 'test12dd34';
		childCase2.HWS_ShipTopartyId__c='1234566';
	 
		childCase2.ContactId = con.Id;
	 
		childCase2.HWS_ServiceType__c = 'Advance Exchange in Days';  
		childCase2.HWS_Sellable_Product__c = prod.Id;
		childCase2.HWS_WarrantyStatus__c  ='Out of Warranty';
	   // childCase2.CH_EntitlementException__c = 'Out of Warranty';
		childCase2.HWS_Contract_Line_Item__c = cli.Id;
		lstCase.add(childCase2);
		Case childCase3 = HWS_DataFactory_TEST.insertChildCase();
		parentCase.AccountId = legalAcc.id;
		childCase3.ParentId = parentCase.Id;
		childCase3.Status='Draft';
		childCase3.Subject='test'+3;
		childCase3.Description='test' +3;
		childCase3.HWS_Faulty_Serial_Number__c= 'testwdqwe1234';
		childCase3.HWS_ShipTopartyId__c='1234566';
   
		childCase3.ContactId = con.Id;
	   
		childCase3.HWS_ServiceType__c = 'Advance Exchange in Days';  
		childCase3.HWS_Sellable_Product__c = prod.Id;
		childCase3.HWS_WarrantyStatus__c  ='In Warranty';
		//childCase3.CH_EntitlementException__c = 'Out of Warranty';
		childCase3.HWS_Contract_Line_Item__c = cli.Id;
		lstCase.add(childCase3);
		insert lstCase;
	   
	}
	static testMethod void updateCaseWithReturnDeliveryAddressTest() {  
		List<Case> listCase = [Select Id,Recordtype.DeveloperName,HWS_WarrantyStatus__c from Case];
		String parentCaseRecId;
		String childCaseRecId,childCaseRecId2,childCaseRecId3;
		for(Case cs : listCase){
			System.debug('cs:**'+cs);
			if(cs.Recordtype.DeveloperName == 'HWS_Parent_Case'){
	  parentCaseRecId=cs.Id;
			}
			if(cs.Recordtype.DeveloperName == 'HWS_Advance_Exchange_In_Days' && cs.HWS_WarrantyStatus__c=='Failed to determine Warranty' ){
	  childCaseRecId=cs.Id;
			}
			if(cs.Recordtype.DeveloperName == 'HWS_Advance_Exchange_In_Days' && cs.HWS_WarrantyStatus__c=='Out of Warranty'){
	  childCaseRecId2=cs.Id;
			}
			if(cs.Recordtype.DeveloperName == 'HWS_Advance_Exchange_In_Days' && cs.HWS_WarrantyStatus__c=='In Warranty'){
	  childCaseRecId3=cs.Id;
			}
		}
		System.debug('parentCaseRecId:'+parentCaseRecId+' childCaseRecId:'+childCaseRecId);
	  String JsonMsg2 = '{"BulkReferenceid": "12345","RequestType":"Bulk","Requestitems": [{ "CustomerNumber": "1000323232","ParentRefid": "AAAAAAAAAAAAAAA",  "ChildRefId":"'+childCaseRecId+'","SerialNumber": "12121212","MaterialCode": "23232", "SourceSystem": "P20", "WarrantyStatus": "Under Warranty", "CaseID": "WC-42191"},{ "CustomerNumber": "1000323232","ParentRefid": "BBBBBBBBBBBBBBB", "ChildRefId":"'+childCaseRecId2+'", "SerialNumber": "32323232","MaterialCode": "88787778", "SourceSystem": "P20", "WarrantyStatus": "Out of Warranty", "CaseID": "WC-42192"}, { "CustomerNumber": "1000323232","ParentRefid": "BBBBBBBBBBBBBBB", "ChildRefId":"'+childCaseRecId3+'", "SerialNumber": "323235232","MaterialCode": "88787778", "SourceSystem": "P20", "WarrantyStatus":"Unknown", "CaseID": "WC-42193"}]}';
	   
				RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();	  
		req.requestURI = '/services/apexrest/api/BulkWarrantyResults/';
		req.httpMethod = 'POST';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg2);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_BulkWarrantyCheck_Result_SOO_to_SRM.doPost();
		HWS_BulkWarrantyCheck_Result_SOO_to_SRM.createInterfaceLogError('test', 20);
		HWS_BulkWarrantyCheck_Result_SOO_to_SRM.ResponseWarrantyFailure rwf=new HWS_BulkWarrantyCheck_Result_SOO_to_SRM.ResponseWarrantyFailure('Test',1,'Test');
		HWS_BulkWarrantyCheck_Result_SOO_to_SRM.WarrantyWrapper ww=new HWS_BulkWarrantyCheck_Result_SOO_to_SRM.WarrantyWrapper('a','b','c','d','e','f','g','h');
		HWS_BulkWarrantyCheck_Result_SOO_to_SRM.WBodyWrapper bw =new HWS_BulkWarrantyCheck_Result_SOO_to_SRM.WBodyWrapper();
		bw.BulkReferenceid = null;
		bw.RequestType = null;
		try{
	  HWS_BulkWarrantyCheck_Result_SOO_to_SRM.passiveAssignmentHWSParentCase(new Set<Id>{parentCaseRecId});
		 // HWS_BulkWarrantyCheck_Result_SOO_to_SRM.cloneCases(parentCaseRecId);
		}catch(Exception e){
			System.debug('Error is'+e.getLineNumber()+''+e.getMessage()+''+e.getCause()+''+e.getTypeName());
	  //Added empty line  
		}
		try{
					   List<Id> parentCaseIds =new List<Id>();
			parentCaseIds.add(parentCaseRecId);
						HWS_BulkWarrantyCheck_Result_SOO_to_SRM.bulkWarrantyUpdateandClone(parentCaseIds);
		}catch(Exception e){
	 //Added empty line  
		}
		Test.stopTest();
	}
   
	static testMethod void updateEntitlementDefaults(){
		List<Case> childCaseList= [SELECT ID,HWS_Contract_Line_Item__c,HWS_WarrantyStatus__c, Status from case where ParentId != null and  HWS_WarrantyStatus__c ='Failed to determine Warranty' limit 1];
		Map<String, String> clItemWQCondition = new Map<String, String>();
		List<ContractLineItem> clItemList = new List<ContractLineItem>();
		List<Id> clIds = new List<Id>();
		for(Case caseRec : childCaseList){
			if(caseRec.HWS_Contract_Line_Item__c != null && caseRec.HWS_WarrantyStatus__c != null && caseRec.HWS_WarrantyStatus__c != ''){
	clIds.add(caseRec.HWS_Contract_Line_Item__c);
			}
		}
		if(!clIds.isEmpty()){
			clItemList = [Select Id,HWS_W_AND_Q_CONDITION__c from ContractLineItem where Id IN: clIds];
			for(ContractLineItem clItem : clItemList){
	clItemWQCondition.put(clItem.Id, clItem.HWS_W_AND_Q_CONDITION__c);
			}
			Test.startTest();  
			HWS_BulkWarrantyCheck_Result_SOO_to_SRM.setEntitlementDefaultValues(clItemWQCondition,childCaseList);
			Test.stopTest();
		}
	   
	}
   
	static testMethod void updateEntitlementDefaults2(){
		List<Case> childCaseList= [SELECT ID,HWS_Contract_Line_Item__c,HWS_WarrantyStatus__c,CH_EntitlementException__c, Status from case where ParentId != null and  HWS_WarrantyStatus__c ='Out of Warranty'  limit 1];
		Map<String, String> clItemWQCondition = new Map<String, String>();
		List<ContractLineItem> clItemList = new List<ContractLineItem>();
		List<Id> clIds = new List<Id>();
		for(Case caseRec : childCaseList){
			if(caseRec.HWS_Contract_Line_Item__c != null && caseRec.HWS_WarrantyStatus__c != null && caseRec.HWS_WarrantyStatus__c != ''){
	clIds.add(caseRec.HWS_Contract_Line_Item__c);
			}
		}
		if(!clIds.isEmpty()){
			clItemList = [Select Id,HWS_W_AND_Q_CONDITION__c from ContractLineItem where Id IN: clIds];
			for(ContractLineItem clItem : clItemList){
	clItemWQCondition.put(clItem.Id, HWS_Constants.UC2B);
			}
			Test.startTest();  
			HWS_BulkWarrantyCheck_Result_SOO_to_SRM.setEntitlementDefaultValues(clItemWQCondition,childCaseList);
			Test.stopTest();
		}
	   
	}
   
	static testMethod void updateEntitlementDefaults3(){
		List<Case> childCaseList= [SELECT ID,HWS_Contract_Line_Item__c,HWS_WarrantyStatus__c,CH_EntitlementException__c, Status from case where ParentId != null and  HWS_WarrantyStatus__c ='In Warranty'  limit 1];
		Map<String, String> clItemWQCondition = new Map<String, String>();
		List<ContractLineItem> clItemList = new List<ContractLineItem>();
		List<Id> clIds = new List<Id>();
		for(Case caseRec : childCaseList){
			if(caseRec.HWS_Contract_Line_Item__c != null && caseRec.HWS_WarrantyStatus__c != null && caseRec.HWS_WarrantyStatus__c != ''){
	clIds.add(caseRec.HWS_Contract_Line_Item__c);
			}
		}
		if(!clIds.isEmpty()){
			clItemList = [Select Id,HWS_W_AND_Q_CONDITION__c from ContractLineItem where Id IN: clIds];
			for(ContractLineItem clItem : clItemList){
	clItemWQCondition.put(clItem.Id, HWS_Constants.UC1);
			}
			Test.startTest();  
			HWS_BulkWarrantyCheck_Result_SOO_to_SRM.setEntitlementDefaultValues(clItemWQCondition,childCaseList);
			Test.stopTest();
		}
	   
	}

}