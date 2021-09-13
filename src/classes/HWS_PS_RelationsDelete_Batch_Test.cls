@isTest
public class HWS_PS_RelationsDelete_Batch_Test {

	static testmethod void insertTask(){
		List<HWS_GenericSettings__c> gsList = new List<HWS_GenericSettings__c>();
		HWS_GenericSettings__c gs = new HWS_GenericSettings__c();
		gs.Name = 'HWS_PS_RelationsDelete';
		gs.HWS_Field1__c = 'true';
		gsList.add(gs);
		HWS_GenericSettings__c gs1 = new HWS_GenericSettings__c();
		gs1.Name = 'HWS_PS_SalesDelete';
		gs1.HWS_Field1__c = 'true';
		gsList.add(gs1);
		HWS_GenericSettings__c gs2 = new HWS_GenericSettings__c();
		gs2.Name = 'HWS_PS_VersionDelete';
		gs2.HWS_Field1__c = 'true';
		gsList.add(gs2);
		HWS_GenericSettings__c gs3 = new HWS_GenericSettings__c();
		gs3.Name = 'HWS_BulkUploadDelete';
		gs3.HWS_Field1__c = 'true';
		gsList.add(gs3);
		insert gsList;
		Datetime myDateTime = Datetime.newInstance(2021, 2, 17);
		DateTime dt = myDateTime;
		HWS_Product_Serviceable_Relations__c psr = new HWS_Product_Serviceable_Relations__c();
		psr.HWS_Is_Processed__c =   true;
		psr.HWS_ProductCode__c = '123';
		psr.CreatedDate = dt;
		insert psr;
		
		HWS_Product_Serviceable_Sales_Item__c pssi = new HWS_Product_Serviceable_Sales_Item__c();
		pssi.HWS_Is_Processed__c = true;
		pssi.HWS_Part_Name__c = 'test';
		pssi.HWS_NSNCode__c = '123456';
		pssi.CreatedDate = dt;
		insert pssi;
		HWS_Product_Serviceable_Version_Item__c psvi = new HWS_Product_Serviceable_Version_Item__c();
		psvi.HWS_Is_Processed__c = true;
		psvi.HWS_IsRelation_Processed__c = true;
		psvi.HWS_FITRate__c = 'test';
		psvi.HWS_NSNCode__c= '12345';
		psvi.CreatedDate = dt;
		insert psvi;
		HWS_BulkUpload__c bulkupload = new HWS_BulkUpload__c();
		bulkupload.ParentCaseId__c = '123';
		bulkupload.Part_Code_Part_Revision__c = '123';
		bulkupload.CreatedDate = dt;
		insert bulkupload;
		Test.startTest();
		HWS_PS_RelationsDelete_Batch c = new HWS_PS_RelationsDelete_Batch();
		Database.executeBatch(c, 200);
		Test.stopTest();
	}
}