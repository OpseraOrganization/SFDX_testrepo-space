/****************************************
 * Class Name : Batch_EDPSalesItemsToProductTest
 * Created Date: 27 June 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product master data from edp to salesforce 
*****************************************/

@isTest
private class Batch_EDPSalesItemsToProductTest {
	
	@isTest static void EDPSalesItemsToProductMock(){
		
		string source_type = 'Product_Sales_Item__c';
		
		List<sObject> objList = new List<sObject>();
		
		NokiaCPQ_PMDI_Parameter__c l_p= new NokiaCPQ_PMDI_Parameter__c();
		l_p.Name='Description';
		l_p.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		l_p.NokiaCPQ_ObjNameTrg__c='Product2';
		l_p.NokiaCPQ_ParaFrom__c='NSNSummary__c';
		l_p.NokiaCPQ_ParaTo__c='Description';
		l_p.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_p.NokiaCPQ_ReqMap__c=false;
		l_p.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c m_p= new NokiaCPQ_PMDI_Parameter__c();
		m_p.Name='ProductCode';
		m_p.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		m_p.NokiaCPQ_ObjNameTrg__c='Product2';
		m_p.NokiaCPQ_ParaFrom__c='NSNCode__c';
		m_p.NokiaCPQ_ParaTo__c='ProductCode';
		m_p.NokiaCPQ_ParaType__c='MAPPING RULE';
		m_p.NokiaCPQ_ReqMap__c=false;
		m_p.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_p1= new NokiaCPQ_PMDI_Parameter__c();
		l_p1.Name='NOKIACPQ_STATE__C';
		l_p1.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		l_p1.NokiaCPQ_ObjNameTrg__c='Product2';
		l_p1.NokiaCPQ_ParaFrom__c='Lifecycle_Status__c';
		l_p1.NokiaCPQ_ParaTo__c='NOKIACPQ_STATE__C';
		l_p1.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_p1.NokiaCPQ_ReqMap__c=true;
		l_p1.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_trans= new NokiaCPQ_PMDI_Parameter__c();
		l_trans.NokiaCPQ_ParaFrom__c='NSN Software SI';
		l_trans.NokiaCPQ_ParaTo__c='Software';
		l_trans.NokiaCPQ_ParaType__c='MAPPING_VALUE';
		l_trans.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_trans2= new NokiaCPQ_PMDI_Parameter__c();
		l_trans2.NokiaCPQ_ParaFrom__c='Create';
		l_trans2.NokiaCPQ_ParaTo__c='Created';
		l_trans2.NokiaCPQ_ParaType__c='MAPPING_VALUE';
		l_trans2.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_paras2 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras2.Name='APTTUS_CONFIG2__CONFIGURATIONTYPE__C';
		l_paras2.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras2.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras2.NokiaCPQ_ParaFrom__c='Bundle';
		l_paras2.NokiaCPQ_ParaTo__c='APTTUS_CONFIG2__CONFIGURATIONTYPE__C';
		l_paras2.NokiaCPQ_ParaType__c='DIRECT_VALUE';
		l_paras2.NokiaCPQ_ReqMap__c=false;
		l_paras2.NokiaCPQ_Active__c=true;
				
		List<NokiaCPQ_PMDI_Parameter__c> l_paras = new List<NokiaCPQ_PMDI_Parameter__c>();
		l_paras.add(l_p);
		l_paras.add(m_p);
		l_paras.add(l_p1);
		l_paras.add(l_trans);
		l_paras.add(l_trans2);	
		l_paras.add(l_paras2);
		insert l_paras;
		 
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
		
		List<Product2> ProdList = new List<Product2>();
		Product2 Prod1=new Product2();
		Prod1.Name='Product1';
		Prod1.Productcode='106742596';
		Prod1.APTS_Ext_ID__c = '106742596';
		ProdList.add(prod1);
		
		Product2 Prod2=new Product2();
		Prod2.Name='Product1';
		Prod2.Productcode='106742596';
		Prod2.APTS_Ext_ID__c = '106742596IP Routing';
		Prod2.Portfolio__c = 'IP Routing';
		ProdList.add(prod2);
		
		insert ProdList;					 
		
		Test.startTest();
		
		SchedulableContext SC = null;
		//Batch_EDPSalesItemsToProduct tsc=new Batch_EDPSalesItemsToProduct();
		//tsc.execute(SC);
		Batch_EDPSalesItemsToProduct  batch= new Batch_EDPSalesItemsToProduct();
		Database.BatchableContext BC;
		
		 //Actual query result from start method
		Database.QueryLocator actualqueryresults = batch.start(BC);
		System.debug('actualqueryresults:'+actualqueryresults);
		
		//Expected query result
		String s_query = 'SELECT Id,Description__c, Lifecycle_Status__c, NSNCode__c FROM Product_Sales_Item__c WHERE Is_Processed__c = false and NSNCode__c != NULL';
		Database.QueryLocator expectedqueryresults = database.getQueryLocator(s_query);
		System.debug('expectedqueryresults:'+expectedqueryresults);
		
		//System.assert(expectedqueryresults!=actualqueryresults,'Start did not return a valid result');
		
		
		batch.execute(BC, salesItems);
		List<Product_Sales_Item__c> salesItem = [Select Id,NSNCode__c,Is_Processed__c 
													 from Product_Sales_Item__c
												  order by NSNCode__c];
		System.debug(salesItem);
		//system.assertEquals(salesItem[0].Is_Processed__c,true,'PSI Item was not processed correctly');
		//system.assertEquals(salesItem[1].Is_Processed__c,false,'PSI Item was not processed correctly');
		batch.finish(BC);
		
		Test.stopTest();
		
	}

}