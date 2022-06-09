@isTest
public class HWS_EDP_BuildRelation_SSI_SVI_Test {

	@isTest
	static void testEdpBuildRelelation(){
		
	   List<HWS_Product_Serviceable_Version_Item__c> parameter=new List<HWS_Product_Serviceable_Version_Item__c>();
		HWS_Product_Serviceable_Version_Item__c param=new HWS_Product_Serviceable_Version_Item__c();
		param.HWS_NSNCode__c='NSN123';
		param.HWS_NSNCodeRelation__c='00057457PUMA1';
		param.HWS_Source__c='PUMA1';
		param.HWS_IsRelation_Processed__c=false;
		parameter.add(param);
		insert parameter;
		List<HWS_Product_Serviceable_Relations__c> serRelation=new List<HWS_Product_Serviceable_Relations__c>();
		HWS_Product_Serviceable_Relations__c sr1=new HWS_Product_Serviceable_Relations__c();
		sr1.HWS_HWSSIPartNumber__c='C109204';
	   // sr1.HWS_HWSVIPartNumber__c='C109204.B01PUMA1';
		sr1.HWS_HWSVIPartNumber__c='00057457PUMA1';
		serRelation.add(sr1);
		insert serRelation;
		HWS_VersionItem__c verItem =new HWS_VersionItem__c();
		verItem.HWS_NSNCode__c='NSN123';
		verItem.HWS_NSNCodeRelation__c='00057457PUMA1';
		insert verItem;
		product2 pr2 = new product2();
		pr2.Name ='test';
		pr2.IsActive = true;
		pr2.Description='test';
		pr2.ProductCode='C109204';
		insert pr2;
		List<Product2> prdList = new List<Product2>();
		Product2 prd2 = new product2();		
		pr2.IsActive = true;
		prdList.add(prd2);
		Database.Error[] errors;
		Database.SaveResult[] results = Database.update(prdList,false);
		 for(Integer index = 0, size = results.size(); index < size; index++) 
				{
					
					
						errors = results[index].getErrors();
						
					}
		//HWS_Product_Serviceable_Version_Item__c item=[SELECT Id, HWS_NSNCode__c ,HWS_Source__c, HWS_IsRelation_Processed__c FROM HWS_Product_Serviceable_Version_Item__c WHERE HWS_IsRelation_Processed__c = false];
	   // system.assertEquals(item.HWS_NSNCode__c, 'NSN123');
		HWS_EDP_BuildRelation_SSI_SVI batch=new HWS_EDP_BuildRelation_SSI_SVI();
		Database.BatchableContext bc;
		SchedulableContext sc;
		Test.startTest();
		batch.start(bc);
		batch.execute(bc,parameter);
		batch.execute(sc);
		batch.finish(bc);
		batch.createErrorLog(errors, verItem, 'update');
		Test.stopTest();
	}
}