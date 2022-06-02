/****************************************
 * Class Name : HWS_ProcessServiceableVersionItem_SVC_Test
 * Created Date: 22 Mar 2019
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading HWS_VersionItem__c list
*****************************************/

@isTest
private class HWS_ProcessServiceableVersionItemSVCTest {
	
	@isTest static void hwsProcessServiceableVersionItemTest(){
		Test.startTest();
		 HWS_Product_Serviceable_Version_Item__c prdSerVitem = new HWS_Product_Serviceable_Version_Item__c();
		 
		 prdSerVitem.HWS_EDP_ActiveStatus__c = true ;
		 prdSerVitem.HWS_EDP_DeletedAtSource__c = true ;
		// prdSerVitem.LastModifiedDate = System.TODAY();  HWS_NSNCode__c
		 prdSerVitem.HWS_FITRate__c = 'test';
		 prdSerVitem.HWS_MaterialType__c = 'test';
		 prdSerVitem.HWS_PartRevision__c = 'test';
		 prdSerVitem.HWS_NSNCode__c = 'HWS_NSNCode__c';
		 
		 List<HWS_Product_Serviceable_Version_Item__c> pslst = new List<HWS_Product_Serviceable_Version_Item__c>();
		 pslst.add(prdSerVitem);
		 insert pslst;
		
		System.assertEquals(pslst[0].HWS_FITRate__c, 'test');
		
		//Parmeters for pricelist mapping
		NokiaCPQ_PMDI_Parameter__c lp= new NokiaCPQ_PMDI_Parameter__c();
		lp.Name='Currency Update';
		lp.NokiaCPQ_ObjNameSrc__c='HWS_Product_Serviceable_Version_Item__c';
		//lp.NokiaCPQ_ObjNameTrg__c='Apttus_Config2__PriceListItem__c';
		lp.NokiaCPQ_ParaFrom__c='HWS_NSNCode__c';
		lp.NokiaCPQ_ParaTo__c='HWS_NSNCode__c';
		lp.NokiaCPQ_ParaType__c='MAPPING RULE';
		lp.NokiaCPQ_ReqMap__c=  false;			
			   
		List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
		lparas.add(lp);	   
		insert lparas;		
		
		List<HWS_VersionItem__c> vi = HWS_ProcessServiceableVersionItem_SVC.updateTarget(pslst, lparas);
		
		Test.stopTest();		
	}
}