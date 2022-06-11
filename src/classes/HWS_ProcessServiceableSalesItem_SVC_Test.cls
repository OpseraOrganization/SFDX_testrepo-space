/****************************************
 * Class Name : HWS_ProcessServiceableSalesItem_SVC_Test
 * Created Date: 22 Mar 2019
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for HWS_ProcessServiceableSalesItem_SVC
*****************************************/

@isTest
private class HWS_ProcessServiceableSalesItem_SVC_Test {
	
	@isTest static void HWS_ProcessServiceableSalesItemSVCTest(){
		Test.startTest();
		
		List<product2> prodlist =new List<product2>();
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='ProductCode';
		pr2.IsActive = true;
		pr2.Description='ProductCode';
		pr2.ProductCode = 'ProductCode';
		pr2.HWS_NSNPartCode__c='PN1';
		pr2.HWS_Source__c='PUMA1';
		insert pr2;
		 
		List<HWS_Product_Serviceable_Sales_Item__c> lst=new List<HWS_Product_Serviceable_Sales_Item__c>();
		HWS_Product_Serviceable_Sales_Item__c hs=new HWS_Product_Serviceable_Sales_Item__c();
		hs.HWS_NSNCode__c='NSNS1';
		hs.HWS_Part_Number__c='PN1';
		hs.HWS_Source__c='PUMA1';
		lst.add(hs);
		insert lst;
		
		List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
		//Parmeters for pricelist mapping
		NokiaCPQ_PMDI_Parameter__c lp1= new NokiaCPQ_PMDI_Parameter__c();
		lp1.Name='Currency Update';
		lp1.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Sales_Item__c';
		lp1.NokiaCPQ_ObjNameTrg__c='Product2';
		lp1.NokiaCPQ_ParaFrom__c='HWS_Source__c';
		lp1.NokiaCPQ_ParaTo__c='HWS_Source__c';
		lp1.NokiaCPQ_ParaType__c='MAPPING RULE';
		lp1.NokiaCPQ_ReqMap__c=  false;
		
		
		lparas.add(lp1);   
		
		NokiaCPQ_PMDI_Parameter__c lp= new NokiaCPQ_PMDI_Parameter__c();
		lp.Name='Currency Update';
		lp.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Sales_Item__c';
		lp.NokiaCPQ_ObjNameTrg__c='Product2';
		lp.NokiaCPQ_ParaFrom__c='HWS_Part_Number__c';
		lp.NokiaCPQ_ParaTo__c='HWS_NSNPartCode__c';
		lp.NokiaCPQ_ParaType__c='MAPPING RULE';
		lp.NokiaCPQ_ReqMap__c=  false;
		lparas.add(lp);	  
	  
	 
		insert lparas; 
		
		Map<String, String> productMap = new Map<String, String>();
		productMap.put('PN1',pr2.id);
			
		String ptobject = 'Product2';
		HWS_ProcessServiceableSalesItem_SVC.updateTarget(lst, productMap, ptobject, lparas);
		
		Test.stopTest();		
	} 
   
}