/****************************************
 * Class Name : Batch_EDPPriceListItemTest
 * Created Date: 27 June 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading price lists from sales item custom object 
*****************************************/

@isTest
private class Batch_EDPPriceListItemTest {
	
	@isTest static void PriceListItemTest(){
	 
		//Parmeters for pricelist mapping
		NokiaCPQ_PMDI_Parameter__c l_p= new NokiaCPQ_PMDI_Parameter__c();
		l_p.Name='Currency Update';
		l_p.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		l_p.NokiaCPQ_ObjNameTrg__c='Apttus_Config2__PriceListItem__c';
		l_p.NokiaCPQ_ParaFrom__c='IP Routing';
		l_p.NokiaCPQ_ParaTo__c='1.1778';
		l_p.NokiaCPQ_ParaType__c='FX_RATE_USD';
		l_p.NokiaCPQ_ReqMap__c=	false;   
		
		NokiaCPQ_PMDI_Parameter__c l_p1= new NokiaCPQ_PMDI_Parameter__c();
		l_p1.Name='Currency Update';
		l_p1.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		l_p1.NokiaCPQ_ObjNameTrg__c='Apttus_Config2__PriceListItem__c';
		l_p1.NokiaCPQ_ParaFrom__c='IP Routing';
		l_p1.NokiaCPQ_ParaTo__c='0.814';
		l_p1.NokiaCPQ_ParaType__c='FX_RATE_EUR';
		l_p1.NokiaCPQ_ReqMap__c=	false;

		NokiaCPQ_PMDI_Parameter__c l_p2= new NokiaCPQ_PMDI_Parameter__c();
		l_p1.Name='Currency Update';
		l_p1.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		l_p1.NokiaCPQ_ObjNameTrg__c='Apttus_Config2__PriceListItem__c';
		l_p1.NokiaCPQ_ParaFrom__c='Fixed Access FBA';
		l_p1.NokiaCPQ_ParaTo__c='0.6';
		l_p1.NokiaCPQ_ParaType__c='FX_RATE_EUR';
		l_p1.NokiaCPQ_ReqMap__c=	false;
		

	 
		List<NokiaCPQ_PMDI_Parameter__c> l_paras = new List<NokiaCPQ_PMDI_Parameter__c>();
		l_paras.add(l_p);
		l_paras.add(l_p1);
	// l_paras.add(l_p2);
		insert l_paras;
		
	Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
		database.insert(nokiaFinCal);
		
		Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
		ExchangeRate.DER_Period__c=nokiaFinCal.id;
		ExchangeRate.CurrencyIsoCode ='USD';
		database.insert(ExchangeRate);
		
		Dated_Exchange_Rates__c ExchangeRate1 = TestDataFactory.datedExchnageRateCreation(1)[0];
		ExchangeRate1.DER_Period__c=nokiaFinCal.id;
		ExchangeRate1.CurrencyIsoCode ='EUR';
		ExchangeRate1.Exchange_Rate__c = 0.8;
		database.insert(ExchangeRate1);
		
		Product_Sales_Item__c psi=new Product_Sales_Item__c();
		psi.NSNCode__c='106742596';
		psi.IRP_Price__c = 182.00;
		psi.CurrencyIsoCode = 'EUR';
		psi.Is_Processed__c = true;
		
		Product_Sales_Item__c psi1=new Product_Sales_Item__c();
			psi1.NSNCode__c='106742591';
		psi1.IRP_Price__c = 182.00;
		psi1.CurrencyIsoCode = 'USD';
		psi1.Is_Processed__c = true;
	  
		List<sObject> salesItems=new List<sObject>();
		salesItems.add(psi);
		salesItems.add(psi1);
		insert salesItems;
		
		Product2 Product=new Product2();
 		Product.Productcode = '106742596';
		Product.Portfolio__c = 'IP Routing';
		Product.Name = 'Product1';
		Product.APTS_Ext_ID__c = '106742596IP Routing';
		
		Product2 Product1=new Product2();
 		Product1.Productcode = '106742591';
		Product1.Name = 'Product2';
		Product1.APTS_Ext_ID__c = '106742591IP Routing';
		Product1.Portfolio__c = 'IP Routing';
		
		Product2 Product2=new Product2();
 		Product2.Productcode = '106742596';
		Product2.Name = 'Product1';
		Product2.APTS_Ext_ID__c = '106742596';
		
		Product2 Product3=new Product2();
 		Product3.Productcode = '106742591';
		Product3.Name = 'Product2';
		Product3.APTS_Ext_ID__c = '106742591Fixed Access FBA';
		Product3.Portfolio__c = 'Fixed Access FBA';
		
		List<Product2> productList = new List<Product2>();
		productList.add(Product);
		productList.add(Product1);
		productList.add(Product2);
		productList.add(Product3);
		insert productList;  

		Apttus_Config2__PriceList__c pli = new Apttus_Config2__PriceList__c();
		pli.CurrencyIsoCode = 'USD';
		pli.Name = 'Global Price List (USD)';
		
		Apttus_Config2__PriceList__c pli1 = new Apttus_Config2__PriceList__c();
		pli1.CurrencyIsoCode = 'EUR';
		pli1.Name = 'Global Price List (EUR)';
		
		List<Apttus_Config2__PriceList__c> priceList = new List<Apttus_Config2__PriceList__c>();
		priceList.add(pli);
		priceList.add(pli1);
		insert priceList;
		
		Apttus_Config2__PriceListItem__c plitem = new Apttus_Config2__PriceListItem__c();
		plitem.Apttus_Config2__PriceListId__r = new Apttus_Config2__PriceList__c(Name = 'Global Price List (USD)');
		plitem.Apttus_Config2__ProductId__r = new Product2(APTS_Ext_ID__c = '106742596');
		plitem.Apttus_Config2__ListPrice__c = 100.00;
		plitem.Master_Currency__c = true;
		plitem.CurrencyIsoCode = 'USD';	
		
		Apttus_Config2__PriceListItem__c plitem1 = new Apttus_Config2__PriceListItem__c();
		plitem1.Apttus_Config2__PriceListId__r = new Apttus_Config2__PriceList__c(Name = 'Global Price List (EUR)');
		plitem1.Apttus_Config2__ProductId__r = new Product2(APTS_Ext_ID__c = '106742596');
		plitem1.Apttus_Config2__ListPrice__c = 101.00;
		plitem1.Master_Currency__c = false;
		plitem1.CurrencyIsoCode = 'EUR';
		
	 
		Apttus_Config2__PriceListItem__c plitem3 = new Apttus_Config2__PriceListItem__c();
		plitem3.Apttus_Config2__PriceListId__r = new Apttus_Config2__PriceList__c(Name = 'Global Price List (EUR)');
		plitem3.Apttus_Config2__ProductId__r = new Product2(APTS_Ext_ID__c = '106742591IP Routing');
		plitem3.Apttus_Config2__ListPrice__c = 101.00;
		plitem3.Master_Currency__c = true;
		plitem3.CurrencyIsoCode = 'EUR';

		Apttus_Config2__PriceListItem__c plitem2 = new Apttus_Config2__PriceListItem__c();
		plitem2.Apttus_Config2__PriceListId__r = new Apttus_Config2__PriceList__c(Name = 'Global Price List (EUR)');
		plitem2.Apttus_Config2__ProductId__r = new Product2(APTS_Ext_ID__c = '106742596IP Routing');
		plitem2.Apttus_Config2__ListPrice__c = 101.00;
		plitem2.Master_Currency__c = true;
		plitem2.CurrencyIsoCode = 'EUR';

		Apttus_Config2__PriceListItem__c plitem4 = new Apttus_Config2__PriceListItem__c();
		plitem4.Apttus_Config2__PriceListId__r = new Apttus_Config2__PriceList__c(Name = 'Global Price List (EUR)');
		plitem4.Apttus_Config2__ProductId__r = new Product2(APTS_Ext_ID__c = '106742591Fixed Access FBA');
		plitem4.Apttus_Config2__ListPrice__c = 101.00;
		plitem4.Master_Currency__c = true;
		plitem4.CurrencyIsoCode = 'EUR';
		
		List<Apttus_Config2__PriceListItem__c> priceItemList = new List<Apttus_Config2__PriceListItem__c>();
		List<Apttus_Config2__PriceListItem__c> PLI_forassert_list = new List<Apttus_Config2__PriceListItem__c>();
		priceItemList.add(plitem);
		priceItemList.add(plitem1);
		priceItemList.add(plitem3);
		priceItemList.add(plitem2);
		priceItemList.add(plitem4);
		insert priceItemList;
		
		PMDI_PriceList_Filter__c pmdifilter = new PMDI_PriceList_Filter__c();
		pmdifilter.Filter__c = 'Fixed Access FBA';
		pmdifilter.Name = 'Portfolio';
		insert pmdifilter;
		
		List<Apttus_Config2__PriceListItem__c> plitem1_forassert = new List<Apttus_Config2__PriceListItem__c>();
		
		for (Apttus_Config2__PriceListItem__c pli_item : [select Apttus_Config2__ProductId__r.APTS_Ext_ID__c,
				Apttus_Config2__ListPrice__c,
				Master_Currency__c,
				CurrencyIsoCode from Apttus_Config2__PriceListItem__c]){
			
	if( pli_item.Apttus_Config2__ProductId__r.APTS_Ext_ID__c == '106742596IP Routing' && pli_item.CurrencyIsoCode == 'EUR')
	 pli_item.Apttus_Config2__ListPrice__c = 82.21;
	
	if( pli_item.Apttus_Config2__ProductId__r.APTS_Ext_ID__c == '106742591IP Routing' && pli_item.CurrencyIsoCode == 'EUR')
	 pli_item.Apttus_Config2__ListPrice__c = 82.21;
			
	 if( pli_item.Apttus_Config2__ProductId__r.APTS_Ext_ID__c == '106742596' && pli_item.CurrencyIsoCode == 'EUR')
	 pli_item.Apttus_Config2__ListPrice__c = 80.8;
	
	if( pli_item.Apttus_Config2__ProductId__r.APTS_Ext_ID__c == '106742596' && pli_item.CurrencyIsoCode == 'USD')
	 pli_item.Apttus_Config2__ListPrice__c = 138;

	if( pli_item.Apttus_Config2__ProductId__r.APTS_Ext_ID__c == '106742591Fixed Access FBA' && pli_item.CurrencyIsoCode == 'EUR')
	 pli_item.Apttus_Config2__ListPrice__c = 101;
	
	 plitem1_forassert.add(pli_item);
		
		}
			
		Test.startTest();
		
		SchedulableContext SC = null;
		Batch_EDPPriceListItem tsc = new Batch_EDPPriceListItem();
		tsc.execute(SC);
		Batch_EDPPriceListItem batch = new Batch_EDPPriceListItem();
		Database.BatchableContext BC;
		Database.executebatch(batch,2000);
		
		batch.start(BC);
		batch.execute(BC, salesItems);
		batch.finish(BC);
	
		Test.stopTest();

		List<Apttus_Config2__PriceListItem__c> pli_item_list = [select Apttus_Config2__ProductId__r.APTS_Ext_ID__c,
				Apttus_Config2__ListPrice__c,
				Master_Currency__c,
				CurrencyIsoCode from Apttus_Config2__PriceListItem__c];
	system.debug('Before update list: '+ plitem1_forassert);   
	system.debug('After update list: '+ pli_item_list);
	//system.assert(pli_item_list == plitem1_forassert,'Assert test is successful');
	}
	

}