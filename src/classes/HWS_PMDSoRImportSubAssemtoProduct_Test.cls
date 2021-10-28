@isTest
public class HWS_PMDSoRImportSubAssemtoProduct_Test {
	@isTest
	Static Void updateVerItemToProduct(){
		List<NokiaCPQ_PMDI_Parameter__c> nppList= new List<NokiaCPQ_PMDI_Parameter__c>();
		NokiaCPQ_PMDI_Parameter__c Npp1= new NokiaCPQ_PMDI_Parameter__c();
		Npp1.Name='Currency Update';
		Npp1.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		Npp1.NokiaCPQ_ObjNameTrg__c='Product2';
		Npp1.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		Npp1.NokiaCPQ_ParaTo__c='HWS_NSNPartCode__c';
		Npp1.NokiaCPQ_ParaType__c='MAPPING RULE';		
		Npp1.NokiaCPQ_ReqMap__c=  false;
		Npp1.NokiaCPQ_Active__c = true;
		
		nppList.add(Npp1);
		
		NokiaCPQ_PMDI_Parameter__c Npp2 = new NokiaCPQ_PMDI_Parameter__c();
		Npp2.Name='Currency Update';
		Npp2.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		Npp2.NokiaCPQ_ObjNameTrg__c='Product2';
		Npp2.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		Npp2.NokiaCPQ_ParaTo__c='HWS_NSNPartCode__c';
		Npp2.NokiaCPQ_ParaType__c='MAPPING RULE';	
		Npp2.NokiaCPQ_ReqMap__c=  false;
		Npp2.NokiaCPQ_Active__c = true;
		nppList.add(Npp2);
		
		insert nppList;
		
		List<product2> prodlist =new List<product2>();
		product2 pr1 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr1.RecordTypeId =rtId;
		pr1.Name ='ProductCode';
		pr1.IsActive = true;
		pr1.Description='ProductCode';
		pr1.ProductCode = 'NSNCode1';
		pr1.HWS_NSNPartCode__c = 'NSNCode1';
		prodlist.add(pr1);
		insert prodlist;
		
		List <HWS_Product_Version_Item__c> versionItemList = new List <HWS_Product_Version_Item__c>();
		HWS_Product_Version_Item__c versionItem1 = new HWS_Product_Version_Item__c();
		versionItem1.HWS_NSNCode__c = 'NSNCode1';
		versionItemList.add(versionItem1);
		insert versionItemList;
		
		product2 pr2 = new product2();
		Test.startTest();
		HWS_PMDSoR_ImportSubAssembliestoProduct importSubBatch = new HWS_PMDSoR_ImportSubAssembliestoProduct();
		Database.BatchableContext BC;
		importSubBatch.getFields();
		importSubBatch.Start(BC);
		importSubBatch.execute(BC, versionItemList);
		importSubBatch.finish(BC);
		importSubBatch.updateVersionToProduct2(versionItemList, nppList);
		Database.UpsertResult[] srList = Database.upsert(prodlist, false);
		Database.Error[] errors;
		for(Integer index = 0, size = srList.size(); index < size; index++) 
		{
			errors = srList[index].getErrors();
		}
		importSubBatch.createErrorLog(errors, pr2, 'Update');
		Test.stopTest();
	}
	
}