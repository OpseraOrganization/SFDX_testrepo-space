/****************************************
 * Class Name : Batch_EDPConfigurationItemsToProductTest
 * Created Date: 27 June 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product master data from edp to salesforce 
*****************************************/


@isTest
public class Batch_EDPConfigurationItemsToProductTest {
	
	@isTest static void Batch_EDPConfigurationItemsToProductMock(){

		List<sObject> objList = new List<sObject>();
		List<sObject> confItems=new List<sObject>();			   
		List<Product2> productList = new List<Product2>();
	 
		NokiaCPQ_PMDI_Parameter__c m_p = new NokiaCPQ_PMDI_Parameter__c();
		m_p.Name='DESCRIPTION';
		m_p.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		m_p.NokiaCPQ_ObjNameTrg__c='Product2';
		m_p.NokiaCPQ_ParaFrom__c='Description__c';
		m_p.NokiaCPQ_ParaTo__c='DESCRIPTION';
		m_p.NokiaCPQ_ParaType__c='MAPPING RULE';
		m_p.NokiaCPQ_ReqMap__c=false;
		m_p.NokiaCPQ_Active__c=true;
	   
		
		NokiaCPQ_PMDI_Parameter__c l_paras = new NokiaCPQ_PMDI_Parameter__c();
		l_paras.Name='NAME';
		l_paras.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		l_paras.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras.NokiaCPQ_ParaFrom__c='ObjectName__c';
		l_paras.NokiaCPQ_ParaTo__c='NAME';
		l_paras.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras.NokiaCPQ_ReqMap__c=FALSE;
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
		l_paras2.Name='APTTUS_CONFIG2__CONFIGURATIONTYPE__C';
		l_paras2.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		l_paras2.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras2.NokiaCPQ_ParaFrom__c='Bundle';
		l_paras2.NokiaCPQ_ParaTo__c='APTTUS_CONFIG2__CONFIGURATIONTYPE__C';
		l_paras2.NokiaCPQ_ParaType__c='DIRECT_VALUE';
		l_paras2.NokiaCPQ_ReqMap__c=false;
		l_paras2.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_paras3 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras3.Name='PRODUCTCODE';
		l_paras3.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		l_paras3.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras3.NokiaCPQ_ParaFrom__c='NSNCode__c';
		l_paras3.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		l_paras3.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras3.NokiaCPQ_ReqMap__c=false;
		l_paras3.NokiaCPQ_Active__c=true;
		
		NokiaCPQ_PMDI_Parameter__c l_paras4 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras4.Name='NOKIACPQ_STATE__C';
		l_paras4.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		l_paras4.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras4.NokiaCPQ_ParaFrom__c='	CurrentStatus__c';
		l_paras4.NokiaCPQ_ParaTo__c='NOKIACPQ_STATE__C';
		l_paras4.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras4.NokiaCPQ_ReqMap__c=true;
		l_paras4.NokiaCPQ_Active__c=true;
		
		objList.add(m_p);
		objList.add(l_paras);
		objList.add(l_trans);
		objList.add(l_trans2);
		objList.add(l_paras2);
		objList.add(l_paras3);
		objList.add(l_paras4);
		
		Product_Configuration_Item__c pci=new Product_Configuration_Item__c();
		pci.ConfId__c='00000320_';
		pci.NSNCode__c='00000320_';
		pci.Is_Processed__c = false;
		pci.ObjectName__c = 'Product Configuration Item1';
		pci.Description__c = 'Product description1';
		pci.CurrentStatus__c = 'Create';
		
		Product_Configuration_Item__c pci2=new Product_Configuration_Item__c();
		pci2.ConfId__c='00000321_';
		pci2.NSNCode__c='00000321_';
		pci2.Is_Processed__c = false;
		pci2.ObjectName__c = 'Product Configuration Item2';
		pci2.Description__c = 'Product description2';
		
	  /*  Product_Configuration_Item__c pci3=new Product_Configuration_Item__c();
		pci3.ConfId__c='';
		pci3.NSNCode__c='';
		pci3.Is_Processed__c = false;
		pci3.ObjectName__c = 'Product Configuration Item1';
		pci3.Description__c = 'Product description1';*/
		
		Product_Configuration_Item__c pci4=new Product_Configuration_Item__c();
		pci4.ConfId__c='00000322_';
		pci4.NSNCode__c='00000322_';
		pci4.Is_Processed__c = false;
		pci4.ObjectName__c = 'Product Configuration Item1';
		pci4.Description__c = 'Product description1';
		pci4.CurrentStatus__c = 'Create';
		
		confItems.add(pci);
		confItems.add(pci2);
		//confItems.add(pci3);
		confItems.add(pci4);
		
		objList.addAll(confItems);

		Product2 Prod=new Product2();
		Prod.APTS_Ext_ID__c='00000320_';
		Prod.Productcode='00000320_';
		Prod.Name = 'Portfolio product';
		productList.add(Prod);
		
		Product2 Prod2=new Product2();
		Prod2.APTS_Ext_ID__c='00000320_ Routing';
		Prod2.Productcode='00000320_';
		Prod2.Name = 'Portfolio product';
		Prod2.Portfolio__c = 'IP Routing';
		productList.add(Prod2);
		
		objList.addAll(productList);
		objList.sort();
		
		insert objList;

		
	Test.startTest();
		
	SchedulableContext SC = null;
	//Batch_EDPConfigurationItemsToProduct tsc=new Batch_EDPConfigurationItemsToProduct();
	//tsc.execute(SC);
	Batch_EDPConfigurationItemsToProduct  batch= new Batch_EDPConfigurationItemsToProduct();
	Database.BatchableContext BC;   
	 
	//Actual query result from start method
	Database.QueryLocator actualqueryresults = batch.start(BC);
		System.debug('actualqueryresults:'+actualqueryresults);
		
	//Expected query result
	String s_query = 'SELECT Id,Description__c, ObjectName__c, CurrentStatus__c, NSNCode__c,ConfId__c FROM Product_Configuration_Item__c WHERE Is_Processed__c = false and NSNCode__c != NULL';
	Database.QueryLocator expectedqueryresults = database.getQueryLocator(s_query);
	System.debug('expectedqueryresults:'+expectedqueryresults);
		
   
		
	System.assert(expectedqueryresults!=actualqueryresults,'Start did not return a valid result');
		
	batch.execute(BC,confItems);
	List<Product_Configuration_Item__c> pciItem = [Select Id,NSNCode__c,Is_Processed__c 
													 from Product_Configuration_Item__c
												  order by NSNCode__c];
		System.debug(pciItem);
	system.assertEquals(pciItem[0].Is_Processed__c,false,'PCI Item was not processed correctly');
	system.assertEquals(pciItem[1].Is_Processed__c,true,'PCI Item was not processed correctly');
		
	batch.finish(BC);
				  
	}
}