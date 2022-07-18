@istest
public class HWS_EDP_PVItoVersionItem_BATCH_Test {
	public static final String NokiaCPQ_ParaType = 'MAPPING RULE'; 
	@istest
	public static  void getTestMethods(){
		
		Test.startTest();	
		
		HWS_Product_Serviceable_Version_Item__c PrdSerVitem = new HWS_Product_Serviceable_Version_Item__c();
		
		PrdSerVitem.HWS_EDP_ActiveStatus__c = true ;
		PrdSerVitem.HWS_EDP_DeletedAtSource__c = true ;		
		PrdSerVitem.HWS_FITRate__c = 'test';
		PrdSerVitem.HWS_PartNumber__c ='test';
		PrdSerVitem.HWS_MaterialType__c = 'test';
		PrdSerVitem.HWS_PartRevision__c = 'test';
		PrdSerVitem.HWS_NSNCode__c = 'HWS_NSNCode__c';
		PrdSerVitem.HWS_Source__c = 'Puma1';
		
		List<HWS_Product_Serviceable_Version_Item__c> pslst = new List<HWS_Product_Serviceable_Version_Item__c>();
		pslst.add(PrdSerVitem);
		insert pslst;
	
		NokiaCPQ_PMDI_Parameter__c l_p= new NokiaCPQ_PMDI_Parameter__c();
		l_p.Name='Currency Update';
		l_p.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		l_p.NokiaCPQ_ObjNameTrg__c='HWS_Product_Version_Item__c';
		l_p.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		l_p.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		l_p.NokiaCPQ_ParaType__c=NokiaCPQ_ParaType;		
		l_p.NokiaCPQ_ReqMap__c=  false;
		l_p.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c l_p1 = new NokiaCPQ_PMDI_Parameter__c();
		l_p1.Name='Currency Update';
		l_p1.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Version_Item__c';
		l_p1.NokiaCPQ_ObjNameTrg__c='HWS_Product_Serviceable_Version_Item__c';
		l_p1.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		l_p1.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		l_p1.NokiaCPQ_ParaType__c=NokiaCPQ_ParaType;	
		l_p1.NokiaCPQ_ReqMap__c=  false;
		l_p1.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c l_p2 = new NokiaCPQ_PMDI_Parameter__c();
		l_p2.Name='Currency Update';
		l_p2.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Sales_Item__c';
		l_p2.NokiaCPQ_ObjNameTrg__c='HWS_Product_Serviceable_Sales_Item__c';
		l_p2.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		l_p2.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		l_p2.NokiaCPQ_ParaType__c=NokiaCPQ_ParaType;	
		l_p2.NokiaCPQ_ReqMap__c=  false;
		l_p2.NokiaCPQ_Active__c = true;
		
		NokiaCPQ_PMDI_Parameter__c l_p3 = new NokiaCPQ_PMDI_Parameter__c();
		l_p3.Name='Currency Update';
		l_p3.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		l_p3.NokiaCPQ_ObjNameTrg__c='HWS_VersionItem__c';
		l_p3.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		l_p3.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		l_p3.NokiaCPQ_ParaType__c=NokiaCPQ_ParaType;	
		l_p3.NokiaCPQ_ReqMap__c=  false;
		l_p3.NokiaCPQ_Active__c = true;
		List<NokiaCPQ_PMDI_Parameter__c> l_paras = new List<NokiaCPQ_PMDI_Parameter__c>();
		l_paras.add(l_p);
		l_paras.add(l_p1);  
		l_paras.add(l_p2);
		l_paras.add(l_p3);
		insert l_paras; 
		
		HWS_Settings__c hwsSetSVI = new HWS_Settings__c();
		hwsSetSVI.Name = 'SSI_SVI Batch Size';
		hwsSetSVI.SettingValue__c = 2000;
		hwsSetSVI.Description__c = 'test';	  
		insert hwsSetSVI;
		
		HWS_Settings__c hwsSetSSVI = new HWS_Settings__c();
		hwsSetSSVI.Name = 'SSI Batch Size';
		hwsSetSSVI.SettingValue__c = 2000;
		hwsSetSSVI.Description__c = 'test';	  
		insert hwsSetSSVI;
		
		HWS_Settings__c hwsSetPVI = new HWS_Settings__c();
		hwsSetPVI.Name = 'PVI Batch Size';
		hwsSetPVI.SettingValue__c = 2000;
		hwsSetPVI.Description__c = 'test';	  
		insert hwsSetPVI;
		
		HWS_VersionItem__c versionItem=new HWS_VersionItem__c();
		versionItem.HWS_NSNCode__c='HWS_NSNCode__c';
		versionItem.HWS_Source__c='Puma1';
		insert versionItem;
		
		HWS_Product_Version_Item__c prdtVersionItem =new HWS_Product_Version_Item__c();
		prdtVersionItem.HWS_NSNCode__c='HWS_NSNCode__c';
		insert prdtVersionItem;
		
		List<HWS_VersionItem__c> vi = HWS_ProcessServiceableVersionItem_SVC.updateTarget(pslst, l_paras);
		
		HWS_EDP_PVItoVersionItem_BATCH pvibatch = new HWS_EDP_PVItoVersionItem_BATCH();
		Database.BatchableContext BC;
		SchedulableContext SC;
		
		pvibatch.getFields();
		pvibatch.start(BC);	
		pvibatch.execute(BC,pslst);		
		pvibatch.finish(BC);
		pvibatch.execute(SC);
		Test.stopTest();
	}
}