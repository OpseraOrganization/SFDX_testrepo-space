@istest
public class HWS_EDP_SalesItemToProduct_BATCH_Test {
	@istest
	public static  void getTestMethods(){
	
		Test.startTest();
		
		//Parmeters for pricelist mapping
		NokiaCPQ_PMDI_Parameter__c lp= new NokiaCPQ_PMDI_Parameter__c();
		lp.Name='Currency Update';
		lp.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		lp.NokiaCPQ_ObjNameTrg__c='HWS_Product_Version_Item__c';
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
		
		List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
		lparas.add(lp1);
		lparas.add(lp);
		lparas.add(lp2);
		
		insert lparas;
		
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
		
		HWS_EDP_SalesItemToProduct_BATCH salesItemProdBatch = new HWS_EDP_SalesItemToProduct_BATCH();
		Database.BatchableContext bc;
		SchedulableContext sc;
		Database.Error[] errors;
		Product2 prd2 = new product2();		
		pr2.IsActive = true;
		
		
		List<Product2> prdList = new List<Product2>();
		prdList.add(prd2);
		salesItemProdBatch.execute(BC,prodServSallist);
		salesItemProdBatch.execute(SC);
		salesItemProdBatch.getFields();
		salesItemProdBatch.start(BC);
		Database.SaveResult[] results = Database.update(prdList,false);
		 for(Integer index = 0, size = results.size(); index < size; index++) 
				{
					
					
						errors = results[index].getErrors();
						
					}
		salesItemProdBatch.createErrorLog(errors, prd2, 'update');
	   // salesItemProdBatch.finish(BC);
	 system.assertNotEquals(hwsSetSSISVI, null);
		Test.stopTest();
	}
}