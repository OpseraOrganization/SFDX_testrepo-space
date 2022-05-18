@isTest
public class HWS_UpdateReturnDeliveryAddress_Test {  
	@testSetup static void testDataSetup(){ 
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
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);	   
		cli.PricebookEntryId = pbety.id; 
		cli.CH_ServiceClassification__c = 'HWS Service';
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(legalAcc,prod1);	   
		ast.RecordTypeId = assetRecordType;			 
		insert ast; 
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';	 
		insert hwsv;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = legalAcc.id;
		parentCase.HWS_ReturnAddressReceivedFromSOO__c = false;
		insert parentCase;
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		parentCase.AccountId = legalAcc.id;
		childCase.ParentId = parentCase.Id;
		insert childCase;
		
		string faultyEmail='testemai@gmail.com';
		List<HWS_BulkUpload__c> bulkToInsertLst = new List<HWS_BulkUpload__c>();
		
		Account acc2=HWS_DataFactory_TEST.createLogisticAccount();
		insert acc2;
		
		HWS_BulkUpload__c bulkupl = new HWS_BulkUpload__c();
		bulkupl.Part_Code_Part_Revision__c = parentCase.Id;
		bulkupl.Faulty_Serial_number__c='12345';
		bulkupl.Fault_Detection__c= HWS_Constants.REBOOT_MODULE;
		bulkupl.Fault_Description__c=HWS_Constants.NoTXPOWER;
		bulkupl.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bulkupl.Fault_Detection_Date__c=startDate;
		bulkupl.HWS_Part_Code__c='5ABTEST';
		bulkupl.HWS_Part_Revision__c='V1232019';
		bulkupl.HWS_Ship_to_Address__c=acc2.id;
		bulkupl.Fault_Reported_by_Email__c=faultyEmail;
		bulkupl.Fault_Reported_by_Phone__c='85698958';
		bulkupl.HWS_ServiceType__c=HWS_Constants.IR;
		bulkupl.HWS_Service_Contract_Number__c ='';
		bulkupl.HWS_LSPResponse__c ='{"ParentCaseId":"'+parentCase.Id+'","ChildCases":[ {"LogisticNode":"US-DC","LogisticNodeName":"DC US P20","ReturnAddressNode":"RLC-CA P20","SRMServiceItemID":"'+childCase.Id+'"}] ,"DeliveryAddress":[ {"AddressType":"Return Location","City":"Mississauga","Country":"CA","Name":"RLC-CA","PostalCode":"L5S 1W3","Region":"NAR","ReturnAddressNode":"RLC-CA P20","State":"Ontario","Street":"Nokia c/o UPS SCS"}] ,"SupplierNodes":[ {"LogisticNode":"US-DC","LogisticNodeName":"DC US P20","pxObjClass":"NSN-Data-SRM-ChildCase"}] }';
		bulkupl.ParentCaseId__c = parentCase.Id; 
		bulkToInsertLst.add(bulkupl);
		
		insert bulkToInsertLst;
		
	}
	static testMethod void updateCaseWithReturnDeliveryAddressTest() {  
		List<Case> listCase = [Select Id,Recordtype.DeveloperName from Case];
		String parentCaseRecId;
		String childCaseRecId;
		for(Case cs : listCase){
			System.debug('cs:**'+cs);
			if(cs.Recordtype.DeveloperName == 'HWS_Parent_Case'){
			   parentCaseRecId=cs.Id; 
			}
			if(cs.Recordtype.DeveloperName == 'HWS_Advance_Exchange_In_Days'){
			   childCaseRecId=cs.Id; 
			}
		}
		 String JsonMsg = '{"ParentCaseId": "'+parentCaseRecId+'","SupplierNodes": [{"LogisticNode": "N11111","LogisticNodeName": "DHL","ReferralInstruction":"PGh0bWw"}],"DeliveryAddress": [{"ReturnAddressNode": "D1111","AddressLine3": "Nokiacs.Batta@Cevalogistics.com -","AddressLine2": "Faulty Inbound RLC / Iparos u. 4. DC2","State": "","DeliveryNote": "","Country": "HU","PostalCode": "2440","Region": "EMEA","Street": "Nokia OY  c/o Ceva Contract Logistics Kft","City": "Szazhalombatta","AddressType": "Return Location","Name": "RLC-EMEA"}],"ChildCases": [{"SRMServiceItemID": "'+childCaseRecId+'","LogisticNode": "N11111","LogisticNodeName": "DHL","ReturnAddressNode": "D1111"}]}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/LSPInstructions/';
		req.httpMethod = 'POST';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();		
		HWS_UpdateReturnDeliveryAddressOnCase.updateCaseWithReturnDeliveryAddress();
		HWS_UpdateReturnDeliveryAddressOnCase.createInterfaceLogError('test', 20);
		Case pCase = new Case(Id=parentCaseRecId,HWS_ReturnAddressReceivedFromSOO__c = true);
		update pCase;
		HWS_UpdateReturnDeliveryAddress.updateReturnDeliveryAddressOnChildCase(new Set<Id>{childCaseRecId},parentCaseRecId);
		HWS_UpdateReturnDeliveryAddress.createInterfaceLogError('Test',12);
		Test.stopTest();
	}
	static testMethod void updateCaseWithReturnDeliveryAddressTest2() {  
		List<Case> listCase = [Select Id,Recordtype.DeveloperName from Case];
		String parentCaseRecId;
		String childCaseRecId;
		for(Case cs : listCase){
			System.debug('cs:**'+cs);
			if(cs.Recordtype.DeveloperName == 'HWS_Parent_Case'){
			   parentCaseRecId=cs.Id; 
			}
			if(cs.Recordtype.DeveloperName == 'HWS_Advance_Exchange_In_Days'){
			   childCaseRecId=cs.Id; 
			}
		}
		String JsonMsg = '{"ParentCaseId": "'+parentCaseRecId+'","SupplierNodes": [],"DeliveryAddress": [{"ReturnAddressNode": "D1111","AddressLine3": "Nokiacs.Batta@Cevalogistics.com -","AddressLine2": "Faulty Inbound RLC / Iparos u. 4. DC2","State": "","DeliveryNote": "","Country": "HU","PostalCode": "2440","Region": "EMEA","Street": "Nokia OY  c/o Ceva Contract Logistics Kft","City": "Szazhalombatta","AddressType": "Return Location","Name": "RLC-EMEA"}],"ChildCases": [{"SRMServiceItemID": "'+childCaseRecId+'","LogisticNode": "N11111","LogisticNodeName": "DHL","ReturnAddressNode": "D1111"}]}'; 
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/LSPInstructions/';
		req.httpMethod = 'POST';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();		
		HWS_UpdateReturnDeliveryAddressOnCase.updateCaseWithReturnDeliveryAddress();
		HWS_UpdateReturnDeliveryAddressOnCase.createInterfaceLogError('test', 20);
		
		Test.stopTest();
	}
}