/****************************************
 * Class Name : Batch_EDPPortfolioItemsToProductTest
 * Created Date: 27 June 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product master data from edp to salesforce 
*****************************************/

@isTest
public class Batch_EDPPortfolioItemsToProductTest {

	@isTest static void  Batch_EDPPortfolioItemsToProductMock(){
		
		string source_type = 'Product_Portfolio_Item__c';
		
		List<sObject> objList = new List<sObject>();
		
		NokiaCPQ_PMDI_Parameter__c l_paras = new NokiaCPQ_PMDI_Parameter__c();
		l_paras.Name='PMDI_Product2';
		l_paras.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras.NokiaCPQ_ParaFrom__c='Description__c';
		l_paras.NokiaCPQ_ParaTo__c='NAME';
		l_paras.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras.NokiaCPQ_ReqMap__c=true;
		l_paras.NokiaCPQ_Active__c=true;
		
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
		l_paras2.Name='PMDI_Product2';
		l_paras2.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras2.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras2.NokiaCPQ_ParaFrom__c='Bundle';
		l_paras2.NokiaCPQ_ParaTo__c='APTTUS_CONFIG2__CONFIGURATIONTYPE__C';
		l_paras2.NokiaCPQ_ParaType__c='DIRECT_VALUE';
		l_paras2.NokiaCPQ_ReqMap__c=false;
		l_paras2.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_paras3 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras3.Name='PMDI_Product2';
		l_paras3.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras3.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras3.NokiaCPQ_ParaFrom__c='ItemId__c';
		l_paras3.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		l_paras3.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras3.NokiaCPQ_ReqMap__c=false;
		l_paras3.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_paras4 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras4.Name='PMDI_Product2';
		l_paras4.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras4.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras4.NokiaCPQ_ParaFrom__c='	Lifecyclestatus__c';
		l_paras4.NokiaCPQ_ParaTo__c='NOKIACPQ_STATE__C';
		l_paras4.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras4.NokiaCPQ_ReqMap__c=true;
		l_paras4.NokiaCPQ_Active__c=true;
		
		Product_Portfolio_Item__c ppi=new Product_Portfolio_Item__c();
		ppi.ItemId__c='133-001041';
		ppi.Description__c = 'Portfolio Description';
		ppi.NSNLegacyCode__c='133-001041';
		ppi.Is_Processed__c=false;
		
		Product_Portfolio_Item__c ppi1 = new Product_Portfolio_Item__c();
		ppi1.ItemId__c='133-001042';
		ppi1.Description__c = 'Portfolio Description 1';
		ppi1.NSNLegacyCode__c='133-001042';
		ppi1.Is_Processed__c=false;
		
		Product_Portfolio_Item__c ppi2 = new Product_Portfolio_Item__c();
		ppi2.ItemId__c='';
		ppi2.Description__c = 'Portfolio Description';
		ppi2.NSNLegacyCode__c='';
		ppi2.Is_Processed__c=false;
		
		Product_Portfolio_Item__c ppi3 = new Product_Portfolio_Item__c();
		ppi3.ItemId__c='133-001043';
		ppi3.Description__c = 'Portfolio Descriptions';
		ppi3.NSNLegacyCode__c='133-001043';
		ppi3.Is_Processed__c=false;
		ppi3.Lifecyclestatus__c = 'Create';
		
		List<Product_Portfolio_Item__c> portfolioItems=new List<Product_Portfolio_Item__c>();
		
		portfolioItems.add(ppi);  
		portfolioItems.add(ppi1); 
		portfolioItems.add(ppi2); 
		portfolioItems.add(ppi3); 
		
		List<Product2> ProdList = new List<Product2>();
		Product2 Prod=new Product2();
		Prod.APTS_Ext_ID__c='133-001041';
		Prod.Productcode='133-001041';
		Prod.Name = 'Portfolio product';
		ProdList.add(Prod);
		
		Product2 Prod2=new Product2();
		Prod2.APTS_Ext_ID__c='133-001041IP Routing';
		Prod2.Productcode='133-001041';
		Prod2.Name = 'Portfolio product';
		Prod2.Portfolio__c = 'IP Routing';
		ProdList.add(Prod2);
		
		Product2 Prod3=new Product2();
		Prod3.APTS_Ext_ID__c='133-001043IP Routing';
		Prod3.Productcode='133-001043';
		Prod3.Name = 'Portfolio product';
		Prod3.Portfolio__c = 'IP Routing';
		ProdList.add(Prod3);
		insert ProdList;
		
		objList.add(l_paras);
		objList.add(l_paras2);
		objList.add(l_paras3);
		objList.add(l_paras4);
		objList.add(l_trans);
		objList.add(l_trans2);
		objList.addAll(portfolioItems);
		objList.sort();
		insert objList;			
		
		Test.startTest();
		
		SchedulableContext SC = null;
		//Batch_EDPPortfolioItemsToProduct ts=new Batch_EDPPortfolioItemsToProduct();
		//ts.execute(SC);
		Batch_EDPPortfolioItemsToProduct  batch= new Batch_EDPPortfolioItemsToProduct();
		Database.BatchableContext BC;
		//Database.executebatch(batch,2000);
		
		//Actual query result from start method
		Database.QueryLocator actualqueryresults = batch.start(BC);
		System.debug('actualqueryresults:'+actualqueryresults);
		
		//Expected query result
		String s_query = 'SELECT Id,ItemId__c, Lifecyclestatus__c, NSNLegacyCode__c FROM Product_Portfolio_Item__c WHERE Is_Processed__c = false and NSNCode__c != NULL';
		Database.QueryLocator expectedqueryresults = database.getQueryLocator(s_query);
		System.debug('expectedqueryresults:'+expectedqueryresults);
		
		System.assert(expectedqueryresults!=actualqueryresults,'Start did not return a valid result');
		
		
		batch.execute(BC, portfolioItems);
		List<Product_Portfolio_Item__c> portfolioItem = [Select Id,NSNLegacyCode__c,Is_Processed__c 
													 from Product_Portfolio_Item__c
												  order by NSNCode__c];
		System.debug(portfolioItem);
		system.assert(portfolioItem[1].Is_Processed__c != ppi.Is_Processed__c,'PPI Item was not processed correctly');
		system.assert(portfolioItem[2].Is_Processed__c == ppi1.Is_Processed__c,'PPI Item was not processed correctly');
		batch.finish(BC);
		
		Test.stopTest();
		
		
			
	}
}