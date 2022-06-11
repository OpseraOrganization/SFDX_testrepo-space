/***************************************
* Class Name : HWS_BulkUploadTriggerTest 
* Created Date: 14 June 2019
* Created By : TCS - HWS Team
* Description : Test class for HWS_BulkUploadTrigger trigger and HWS_BulkUploadhandler Class
* Last Modified by: 
* Last Modified Date: 
*****************************************/
@isTest
public class HWS_BulkUploadTriggerTest {
	
	@testSetup static void testDataSetup(){
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		insert acc1;
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();		
		insert prod;
		
		Id pricebookId = Test.getStandardPricebookId();
		PriceBookEntry pbe = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pricebookId);	
		insert pbe;
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();	
		insert pb;   
		
		PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pb.Id);		
		pbety.CurrencyIsoCode='EUR';	
		insert pbety;  
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc1);		
		sc.Pricebook2Id = pb.Id;
		sc.NCP_External_Status__c  ='Active';
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);		
		cli.PricebookEntryId = pbety.id;   
		cli.CH_ServiceClassification__c = 'HWS Service';
		cli.NCP_External_Status__c ='Active';
		cli.CH_ServiceType__c ='Advanced Exchange in Days';
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);		
		ast.RecordTypeId = assetRecordType;	 
		ast.HWS_ExternalStatus__c='Active';
		
		ast.HWS_ContractLineItem__c = cli.id;
		
		insert ast; 
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';		
		insert hwsv;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
		
	}	  
	
	@isTest public static void bulkUploadTest(){
		
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		insert acc1;
		
		List<Product2> prodsToInsertLst = new List<Product2>();		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode='3HQ14903AAAA';
		prodsToInsertLst.add(prod);
		
		Product2 prodPuma2 = HWS_DataFactory_TEST.insertproduct2();
		prodPuma2.CARE_PartCode__c='5ABTEST';
		prodsToInsertLst.add(prodPuma2);
		
		insert prodsToInsertLst;
		
		List<Asset> lstast = new List<Asset>();
		
		ContractLineItem cli =[select id from ContractLineItem limit 1];
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prodsToInsertLst[0]);		
		ast.RecordTypeId = assetRecordType;	 
		ast.HWS_ExternalStatus__c='Active';
		ast.HWS_ContractLineItem__c = cli.id;
		
		lstast.add(ast);
		
		Asset ast1 = HWS_DataFactory_TEST.insertAsset(acc1,prodsToInsertLst[1]);		
		ast1.RecordTypeId = assetRecordType;	 
		ast1.HWS_ExternalStatus__c='Active';
		ast1.HWS_ContractLineItem__c = cli.id;
		
		lstast.add(ast1);
		
		Asset ast2 = HWS_DataFactory_TEST.insertAsset(acc1,prodsToInsertLst[1]);		
		ast2.RecordTypeId = assetRecordType;	 
		ast2.HWS_ExternalStatus__c='Active';
		ast2.HWS_ContractLineItem__c = cli.id;
		
		lstast.add(ast2);
		
		Asset ast3 = HWS_DataFactory_TEST.insertAsset(acc1,prodsToInsertLst[0]);		
		ast3.RecordTypeId = assetRecordType;	 
		ast3.HWS_ExternalStatus__c='Active';
		ast3.HWS_ContractLineItem__c = cli.id;
		
		lstast.add(ast3);
		
		insert lstast; 
		
		
		List<HWS_versionitem__c> viToInsertLst = new List<HWS_versionitem__c>();
		HWS_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Hardware_Sellable_Item__c = prod.Id;
		hwsv.HWS_Source__c = 'PUMA1';
		hwsv.HWS_Version_Code__c='V1232019';
		viToInsertLst.add(hwsv);
		
		HWS_versionitem__c hwsv1 = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv1.HWS_Hardware_Sellable_Item__c = prodPuma2.Id;
		hwsv1.HWS_Source__c = 'PUMA1';
		hwsv1.HWS_Version_Code__c='V1232019';
		viToInsertLst.add(hwsv1);
		
		HWS_versionitem__c hwsvPuma2 = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsvPuma2.HWS_Hardware_Sellable_Item__c = prodPuma2.Id;
		hwsvPuma2.HWS_Source__c = 'PUMA2';
		hwsvPuma2.HWS_Version_Code__c='V1232019';
		viToInsertLst.add(hwsvPuma2);
		
		HWS_versionitem__c hwsvPuma21 = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsvPuma21.HWS_Hardware_Sellable_Item__c = prodPuma2.Id;
		hwsvPuma21.HWS_Source__c = 'PUMA2';
		hwsvPuma21.HWS_Version_Code__c='ANY';
		viToInsertLst.add(hwsvPuma21);
		
		HWS_versionitem__c hwsvPuma212 = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsvPuma212.HWS_Hardware_Sellable_Item__c = prodPuma2.Id;
		hwsvPuma212.HWS_Source__c = 'PUMA2';
		hwsvPuma212.HWS_Version_Code__c='5ABTEST';
		viToInsertLst.add(hwsvPuma212);
		
		insert viToInsertLst;
		Test.startTest();
		List<HWS_BulkUpload__c> buToInsertLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Part_Code_Part_Revision__c = '3HQ14903AAAAV1232019';
		bu.HWS_AccountId__c  = acc1.Id;
		bu.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu);
		
		HWS_BulkUpload__c bu1 = new HWS_BulkUpload__c();
		bu1.Part_Code_Part_Revision__c = '5ABTEST#V1232019';
		bu1.HWS_AccountId__c  = acc1.Id;
		bu1.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu1);
		
		HWS_BulkUpload__c bu2 = new HWS_BulkUpload__c();
		bu2.Part_Code_Part_Revision__c = '3HQ14903AAAA';
		bu2.HWS_AccountId__c  = acc1.Id;
		bu2.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu2);
		
		HWS_BulkUpload__c bu3 = new HWS_BulkUpload__c();
		bu3.Part_Code_Part_Revision__c = '5ABTESTv99';
		bu3.HWS_AccountId__c  = acc1.Id;
		bu3.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu3);
		
		HWS_BulkUpload__c bu4 = new HWS_BulkUpload__c();
		bu4.Part_Code_Part_Revision__c = '3HQ14903AAAAV1232019';
		bu4.HWS_AccountId__c  = acc1.Id;
		bu4.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu4);
		
		HWS_BulkUpload__c bu5 = new HWS_BulkUpload__c();
		bu5.Part_Code_Part_Revision__c = '5ABTEST';
		bu5.HWS_AccountId__c  = acc1.Id;
		bu5.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu5);
		
		insert buToInsertLst;
		System.assertEquals(buToInsertLst[1].Part_Code_Part_Revision__c ,'5ABTEST#V1232019');
		bu1.Part_Code_Part_Revision__c = '5ABTESTV123-201';
		
		update bu1;
		Test.stopTest();
	}
}