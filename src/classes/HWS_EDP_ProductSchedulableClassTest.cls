@isTest
public class HWS_EDP_ProductSchedulableClassTest {
	
	static testmethod void testScheduledJob() 
	{		
		Test.startTest();
		
		//Parmeters for pricelist mapping
		NokiaCPQ_PMDI_Parameter__c lp= new NokiaCPQ_PMDI_Parameter__c();
		lp.Name='Currency Update';
		lp.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		lp.NokiaCPQ_ObjNameTrg__c='HWS_VersionItem__c';
		lp.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lp.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		lp.NokiaCPQ_ParaType__c='MAPPING RULE';		
		lp.NokiaCPQ_ReqMap__c=  false;
		lp.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c lp2 = new NokiaCPQ_PMDI_Parameter__c();
		lp2.Name='Currency Update';
		lp2.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Version_Item__c';
		lp2.NokiaCPQ_ObjNameTrg__c='HWS_Product_Serviceable_Version_Item__c';
		lp2.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lp2.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		lp2.NokiaCPQ_ParaType__c='MAPPING RULE';	
		lp2.NokiaCPQ_ReqMap__c=  false;
		lp2.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c lp1 = new NokiaCPQ_PMDI_Parameter__c();
		lp1.Name='Currency Update';
		lp1.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Sales_Item__c';
		lp1.NokiaCPQ_ObjNameTrg__c='HWS_Product_Serviceable_Sales_Item__c';
		lp1.NokiaCPQ_ParaFrom__c='HWS_Part_Number__c';
		lp1.NokiaCPQ_ParaTo__c='ProductCode';
		lp1.NokiaCPQ_ParaType__c='MAPPING RULE';	
		lp1.NokiaCPQ_ReqMap__c=  false;
		lp1.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c lp3= new NokiaCPQ_PMDI_Parameter__c();
		lp3.Name='Currency Update';
		lp3.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		lp3.NokiaCPQ_ObjNameTrg__c='Product2';
		lp3.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lp3.NokiaCPQ_ParaTo__c='HWS_NSNPartCode__c';
		lp3.NokiaCPQ_ParaType__c='MAPPING RULE';		
		lp3.NokiaCPQ_ReqMap__c=  false;
		lp3.NokiaCPQ_Active__c = true;
		
		List<NokiaCPQ_PMDI_Parameter__c> lpar = new List<NokiaCPQ_PMDI_Parameter__c>();
		lpar.add(lp1);
		lpar.add(lp);
		lpar.add(lp2);
		lpar.add(lp3);
		
		insert lpar;
		System.assertEquals(lpar[0].Name,'Currency Update');
		List<product2> prodlist =new List<product2>();
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='ProductCode';
		pr2.IsActive = true;
		pr2.Description='ProductCode';
		pr2.ProductCode = 'HWS_NSNCode__c';
		insert pr2;
		
	List<HWS_Product_Serviceable_Sales_Item__c> prodServSallist =new List<HWS_Product_Serviceable_Sales_Item__c>();
		HWS_Product_Serviceable_Sales_Item__c prodServSal = new HWS_Product_Serviceable_Sales_Item__c();
		prodServSal.HWS_NSNCode__c = 'HWS_NSNCode__c';
		prodServSal.HWS_Part_Number__c = 'HWS_NSNCode__c';
		prodServSallist.add(prodServSal);
		
		insert prodServSallist; 
		
		HWS_EDP_SalesItemToProduct_BATCH salesItemProdBatch = new HWS_EDP_SalesItemToProduct_BATCH();
		Database.BatchableContext bc;
		SchedulableContext sc;
		Database.Error[] errors;
		Product2 prd2 = new product2();		
		pr2.IsActive = true;
		
		
		List<Product2> prdList = new List<Product2>();
		prdList.add(prd2);
		salesItemProdBatch.execute(bc,prodServSallist);
		salesItemProdBatch.execute(sc);
		salesItemProdBatch.getFields();
		salesItemProdBatch.start(bc);
		Database.SaveResult[] results = Database.update(prdList,false);
		for(Integer index = 0, size = results.size(); index < size; index++) 
		{
			
			
			errors = results[index].getErrors();
			
		}
		salesItemProdBatch.createErrorLog(errors, prd2, 'update');
		// salesItemProdBatch.finish(bc);
		
		String jobId = System.schedule('EDP Test','0 0 * * * ?',new HWS_EDP_ProductSchedulableClass());
		
		Test.stopTest();
		
		// Now that the scheduled job has executed,
		//Use System.assertEquals to confirm test success
	}
	static testMethod void scheduleMethodTest()
	{	
		HWS_EDP_ProductSchedulableClass esc = new HWS_EDP_ProductSchedulableClass();
		
	}
	 static testMethod void countTest2()
	{	
		
		Database.executebatch(new Batch_EDPSalesItemsToProduct(),2000);	
		Database.executebatch(new Batch_EDPConfigurationItemsToProduct(),2000); 
		HWS_EDP_ProductSchedulableClass esc = new HWS_EDP_ProductSchedulableClass();
		SchedulableContext sc;
		esc.execute(sc);	
		
	}
	
	static testMethod void countTest3()
	{	
		
		Database.executebatch(new Batch_EDPSalesItemsToProduct(),2000);	
		Database.executebatch(new Batch_EDPConfigurationItemsToProduct(),2000); 
		Database.executebatch(new Batch_EDPPortfolioItemsToProduct(),2000);
		HWS_EDP_ProductSchedulableClass esc = new HWS_EDP_ProductSchedulableClass();
		SchedulableContext sc;
		esc.execute(sc);	
		
	}
	@testSetup
	static void setData()
	{
		NokiaCPQ_PMDI_Parameter__c mp1= new NokiaCPQ_PMDI_Parameter__c();
		mp1.Name='ProductCode';
		mp1.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		mp1.NokiaCPQ_ObjNameTrg__c='Product2';
		mp1.NokiaCPQ_ParaFrom__c='NSNCode__c';
		mp1.NokiaCPQ_ParaTo__c='ProductCode';
		mp1.NokiaCPQ_ParaType__c='MAPPING RULE';
		mp1.NokiaCPQ_ReqMap__c=false;
		mp1.NokiaCPQ_Active__c=true;
		insert mp1;
		
		NokiaCPQ_PMDI_Parameter__c lparas3 = new NokiaCPQ_PMDI_Parameter__c();
		lparas3.Name='PRODUCTCODE';
		lparas3.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		lparas3.NokiaCPQ_ObjNameTrg__c='Product2';
		lparas3.NokiaCPQ_ParaFrom__c='ConfId__c';
		lparas3.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		lparas3.NokiaCPQ_ParaType__c='MAPPING RULE';
		lparas3.NokiaCPQ_ReqMap__c=false;
		lparas3.NokiaCPQ_Active__c=true;
		insert lparas3;
		
		NokiaCPQ_PMDI_Parameter__c lparas4 = new NokiaCPQ_PMDI_Parameter__c();
		lparas4.Name='PMDI_Product2';
		lparas4.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		lparas4.NokiaCPQ_ObjNameTrg__c='Product2';
		lparas4.NokiaCPQ_ParaFrom__c='NSNLegacyCode__c';
		lparas4.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		lparas4.NokiaCPQ_ParaType__c='MAPPING RULE';
		lparas4.NokiaCPQ_ReqMap__c=false;
		lparas4.NokiaCPQ_Active__c=true;
		insert lparas4;
		
		List<sObject> objList = new List<sObject>();
		
		NokiaCPQ_PMDI_Parameter__c lp= new NokiaCPQ_PMDI_Parameter__c();
		lp.Name='Description';
		lp.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		lp.NokiaCPQ_ObjNameTrg__c='Product2';
		lp.NokiaCPQ_ParaFrom__c='NSNSummary__c';
		lp.NokiaCPQ_ParaTo__c='Description';
		lp.NokiaCPQ_ParaType__c='MAPPING RULE';
		lp.NokiaCPQ_ReqMap__c=false;
		lp.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c mp= new NokiaCPQ_PMDI_Parameter__c();
		mp.Name='ProductCode';
		mp.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		mp.NokiaCPQ_ObjNameTrg__c='Product2';
		mp.NokiaCPQ_ParaFrom__c='NSNCode__c';
		mp.NokiaCPQ_ParaTo__c='ProductCode';
		mp.NokiaCPQ_ParaType__c='MAPPING RULE';
		mp.NokiaCPQ_ReqMap__c=false;
		mp.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c lp1= new NokiaCPQ_PMDI_Parameter__c();
		lp1.Name='NOKIACPQ_STATE__C';
		lp1.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		lp1.NokiaCPQ_ObjNameTrg__c='Product2';
		lp1.NokiaCPQ_ParaFrom__c='Lifecycle_Status__c';
		lp1.NokiaCPQ_ParaTo__c='NOKIACPQ_STATE__C';
		lp1.NokiaCPQ_ParaType__c='MAPPING RULE';
		lp1.NokiaCPQ_ReqMap__c=true;
		lp1.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c ltrans= new NokiaCPQ_PMDI_Parameter__c();
		ltrans.NokiaCPQ_ParaFrom__c='NSN Software SI';
		ltrans.NokiaCPQ_ParaTo__c='Software';
		ltrans.NokiaCPQ_ParaType__c='MAPPING_VALUE';
		ltrans.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c ltrans2= new NokiaCPQ_PMDI_Parameter__c();
		ltrans2.NokiaCPQ_ParaFrom__c='Create';
		ltrans2.NokiaCPQ_ParaTo__c='Created';
		ltrans2.NokiaCPQ_ParaType__c='MAPPING_VALUE';
		ltrans2.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c lparas2 = new NokiaCPQ_PMDI_Parameter__c();
		lparas2.Name='PMDI_Product2';
		lparas2.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		lparas2.NokiaCPQ_ObjNameTrg__c='Product2';
		lparas2.NokiaCPQ_ParaFrom__c='Bundle';
		lparas2.NokiaCPQ_ParaTo__c='APTTUS_CONFIG2__CONFIGURATIONTYPE__C';
		lparas2.NokiaCPQ_ParaType__c='DIRECT_VALUE';
		lparas2.NokiaCPQ_ReqMap__c=false;
		lparas2.NokiaCPQ_Active__c=true;
	
		List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
		lparas.add(lp);
		lparas.add(mp);
		lparas.add(lp1);
		lparas.add(ltrans);
		lparas.add(ltrans2);	
		lparas.add(lparas2);
		insert lparas;
		 
		Product_Sales_Item__c psi=new Product_Sales_Item__c();
		psi.NSNCode__c='106742596';
		psi.Description__c = 'PSI';
		psi.Is_Processed__c = false;
		
		Product_Sales_Item__c psi2=new Product_Sales_Item__c();
		psi2.NSNCode__c='106742597';
		psi2.Description__c = 'PSI';
		psi2.Is_Processed__c = false;
		
		Product_Sales_Item__c psi3=new Product_Sales_Item__c();
		psi3.NSNCode__c='106742598';
		psi3.Description__c = 'PSI';
		psi3.Is_Processed__c = false;
		psi3.Lifecycle_Status__c = 'Create';
 
		List<sObject> salesItems=new List<sObject>();		
		salesItems.add(psi);
		salesItems.add(psi2);
		salesItems.add(psi3);	  
		insert salesItems;
		
		List<Product2> prodList1 = new List<Product2>();
		Product2 Prod1=new Product2();
		prod1.Name='Product1';
		prod1.Productcode='106742596';
		prod1.APTS_Ext_ID__c = '106742596';
		prodList1.add(prod1);
		
		Product2 prod2=new Product2();
		prod2.Name='Product1';
		prod2.Productcode='106742596';
		prod2.APTS_Ext_ID__c = '106742596IP Routing';
		prod2.Portfolio__c = 'IP Routing';
		prodList1.add(prod2);
		
		insert prodList1;
		
		
		
		//Parmeters for pricelist mapping
		NokiaCPQ_PMDI_Parameter__c lpp= new NokiaCPQ_PMDI_Parameter__c();
		lpp.Name='Currency Update';
		lpp.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		lpp.NokiaCPQ_ObjNameTrg__c='Product2';
		lpp.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lpp.NokiaCPQ_ParaTo__c='HWS_NSNPartCode__c';
		lpp.NokiaCPQ_ParaType__c='MAPPING RULE';		
		lpp.NokiaCPQ_ReqMap__c=  false;
		lpp.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c lp2 = new NokiaCPQ_PMDI_Parameter__c();
		lp2.Name='Currency Update';
		lp2.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Version_Item__c';
		lp2.NokiaCPQ_ObjNameTrg__c='HWS_Product_Serviceable_Version_Item__c';
		lp2.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lp2.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		lp2.NokiaCPQ_ParaType__c='MAPPING RULE';	
		lp2.NokiaCPQ_ReqMap__c=  false;
		lp2.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c lpp1 = new NokiaCPQ_PMDI_Parameter__c();
		lpp1.Name='Currency Update';
		lpp1.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Sales_Item__c';
		lpp1.NokiaCPQ_ObjNameTrg__c='HWS_Product_Serviceable_Sales_Item__c';
		lpp1.NokiaCPQ_ParaFrom__c='HWS_Part_Number__c';
		lpp1.NokiaCPQ_ParaTo__c='ProductCode';
		lpp1.NokiaCPQ_ParaType__c='MAPPING RULE';	
		lpp1.NokiaCPQ_ReqMap__c=  false;
		lpp1.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c lpp3= new NokiaCPQ_PMDI_Parameter__c();
		lpp3.Name='Currency Update';
		lpp3.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		lpp3.NokiaCPQ_ObjNameTrg__c='HWS_VersionItem__c';
		lpp3.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lpp3.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		lpp3.NokiaCPQ_ParaType__c='MAPPING RULE';		
		lpp3.NokiaCPQ_ReqMap__c=  false;
		lpp3.NokiaCPQ_Active__c = true;
		
		List<NokiaCPQ_PMDI_Parameter__c> lparas1 = new List<NokiaCPQ_PMDI_Parameter__c>();
		lparas1.add(lpp1);
		lparas1.add(lpp);
		lparas1.add(lp2);
		lparas1.add(lpp3);
		
		insert lparas1;
		
		List<product2> prodlist2 =new List<product2>();
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='ProductCode';
		pr2.IsActive = true;
		pr2.Description='ProductCode';
		pr2.ProductCode = 'HWS_NSNCode__c';
		insert pr2;
		
	/* List<HWS_Product_Serviceable_Sales_Item__c> prodServSallist =new List<HWS_Product_Serviceable_Sales_Item__c>();
		HWS_Product_Serviceable_Sales_Item__c prodServSal = new HWS_Product_Serviceable_Sales_Item__c();
		prodServSal.HWS_NSNCode__c = 'HWS_NSNCode__c';
		prodServSal.HWS_Part_Number__c = 'HWS_NSNCode__c';
		prodServSallist.add(prodServSal);
		
		insert prodServSallist; */
		
		HWS_Settings__c hwsSetSSI = new HWS_Settings__c();
		hwsSetSSI.Name = 'SSI Batch Size';
		hwsSetSSI.SettingValue__c = 2000;
		hwsSetSSI.Description__c = 'test';	  
		insert hwsSetSSI;
		
		HWS_Settings__c hwsSetPVI = new HWS_Settings__c();
		hwsSetPVI.Name = 'PVI Batch Size';
		hwsSetPVI.SettingValue__c = 2000;
		hwsSetPVI.Description__c = 'test';	  
		insert hwsSetPVI;
		
		HWS_Settings__c hwsSetSSISVI = new HWS_Settings__c();
		hwsSetSSISVI.Name = 'SSI_SVI Batch Size';
		hwsSetSSISVI.SettingValue__c = 2000;
		hwsSetSSISVI.Description__c = 'test';	  
		insert hwsSetSSISVI;
		
		 HWS_Settings__c hwsSetSVI = new HWS_Settings__c();
		hwsSetSVI.Name = 'SVI Batch Size';
		hwsSetSVI.SettingValue__c = 2000;
		hwsSetSVI.Description__c = 'test';	  
		insert hwsSetSVI;
		
		HWS_Settings__c hwsSubAssembly = new HWS_Settings__c();
		hwsSubAssembly.Name = 'Sub Assembly Batch Size';
		hwsSubAssembly.SettingValue__c = 2000;
		hwsSubAssembly.Description__c = 'test';	  
		insert hwsSubAssembly;
		
	}
	
}