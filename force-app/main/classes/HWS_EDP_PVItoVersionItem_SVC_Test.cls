@isTest
public class HWS_EDP_PVItoVersionItem_SVC_Test {
	
	public testmethod static void updateTargetTest(){
		//Parmeters for pricelist mapping
		List<NokiaCPQ_PMDI_Parameter__c> mapping = new List<NokiaCPQ_PMDI_Parameter__c>();
		NokiaCPQ_PMDI_Parameter__c l_p= new NokiaCPQ_PMDI_Parameter__c();
		l_p.Name='Currency Update';
		l_p.NokiaCPQ_ObjNameSrc__c='HWS_Product_Version_Item__c';
		l_p.NokiaCPQ_ObjNameTrg__c='HWS_Product_Version_Item__c';
		l_p.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		l_p.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		l_p.NokiaCPQ_ParaType__c='MAPPING RULE';		
		l_p.NokiaCPQ_ReqMap__c=  false;
		l_p.NokiaCPQ_Active__c = true;
		mapping.add(l_p);
		insert mapping;
		
		List<HWS_Product_Version_Item__c> VerItemList = new List<HWS_Product_Version_Item__c>();
		HWS_Product_Version_Item__c VerItem = new HWS_Product_Version_Item__c();
		VerItem.HWS_Is_Processed__c = false;
		VerItem.HWS_NSNCode__c = '12345';
		VerItemList.add(VerItem);
		insert VerItemList;
		
		product2 pr2 = HWS_DataFactory_TEST.insertproduct2();	   
		insert pr2;
		
		HWS_VersionItem__c vi=HWS_DataFactory_TEST.createVerionsItems(pr2.id);
		insert vi;
		
		string nsccode='12345';
		List<string> str = new List<string>();
		str.add(vi.id);
		
		Map<String, List<String>> productMap = new Map<String, List<String>>();
		productMap.put(nsccode,str);
		test.startTest();
		HWS_EDP_PVItoVersionItem_SVC.updateTarget(VerItemList,productMap,mapping);
		test.stopTest();
		
	}
}