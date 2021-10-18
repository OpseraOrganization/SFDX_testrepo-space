@isTest
private class EDP_ProductSchedulableClassTest {
	
	static testmethod void testScheduledJob() 
	{
		
		Test.startTest();
		
		// Schedule the test job
		Datetime dt = Datetime.now().addMinutes(1);
		String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
		String jobId = System.schedule('EDP Product schedule Test',CRON_EXP,new EDP_ProductSchedulableClass());
		
		SchedulableContext SC;
		EDP_ProductSchedulableClass esc = new EDP_ProductSchedulableClass();
		esc.execute(SC); 
		
		Database.executebatch(new Batch_EDPSalesItemsToProduct(),2000);				
		Database.executebatch(new Batch_EDPConfigurationItemsToProduct(),2000);			
		Database.executebatch(new Batch_EDPPortfolioItemsToProduct(),2000);		  
		esc.execute(SC);
		
		Test.stopTest();
		
		// Now that the scheduled job has executed,
		//Use System.assertEquals to confirm test success
	}

	static testMethod void scheduleMethodTest()
	{	   
		EDP_ProductSchedulableClass esc = new EDP_ProductSchedulableClass();
	  
	}
	
	static testMethod void countTest()
	{	   
		
		Test.startTest();
		Database.executebatch(new Batch_EDPSalesItemsToProduct(),2000);				
		Database.executebatch(new Batch_EDPConfigurationItemsToProduct(),2000); 
		EDP_ProductSchedulableClass esc = new EDP_ProductSchedulableClass();
		SchedulableContext SC;
		esc.execute(SC);
		 
		Test.stopTest();
	}
	
	static testMethod void unscheduleMethodTest()
	{
		Test.startTest();
		
		EDP_ProductSchedulableClass esc = new EDP_ProductSchedulableClass();
	   
		
		Test.stopTest();
	}
	
	@testSetup
	static void setData()
	{
		NokiaCPQ_PMDI_Parameter__c m_p1= new NokiaCPQ_PMDI_Parameter__c();
		m_p1.Name='ProductCode';
		m_p1.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		m_p1.NokiaCPQ_ObjNameTrg__c='Product2';
		m_p1.NokiaCPQ_ParaFrom__c='NSNCode__c';
		m_p1.NokiaCPQ_ParaTo__c='ProductCode';
		m_p1.NokiaCPQ_ParaType__c='MAPPING RULE';
		m_p1.NokiaCPQ_ReqMap__c=false;
		m_p1.NokiaCPQ_Active__c=true;
		insert m_p1;
		
		NokiaCPQ_PMDI_Parameter__c l_paras3 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras3.Name='PRODUCTCODE';
		l_paras3.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		l_paras3.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras3.NokiaCPQ_ParaFrom__c='ConfId__c';
		l_paras3.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		l_paras3.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras3.NokiaCPQ_ReqMap__c=false;
		l_paras3.NokiaCPQ_Active__c=true;
		insert l_paras3;
		
		NokiaCPQ_PMDI_Parameter__c l_paras4 = new NokiaCPQ_PMDI_Parameter__c();
		l_paras4.Name='PMDI_Product2';
		l_paras4.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras4.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras4.NokiaCPQ_ParaFrom__c='NSNLegacyCode__c';
		l_paras4.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		l_paras4.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras4.NokiaCPQ_ReqMap__c=false;
		l_paras4.NokiaCPQ_Active__c=true;
		insert l_paras4;
		
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
		l_paras2.Name='PMDI_Product2';
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
	}

}