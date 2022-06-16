@isTest
public class CPQ_SSFUploadControllerTest{
	@isTest
	public static void test_SSF(){
		//Apttus_Config2__ProductConfiguration__c config = [Select Id from Apttus_Config2__ProductConfiguration__c LIMIT 1];
		
		Demo__c dm = new Demo__c(Name='Test');
		insert dm;
		
		String csv ='Tool|Version\nTSS|1\n#Header|resellername|transtype|custtype|purchaseorder\n#Header|CDW|Initial|Service Provider|AR124375\n#Services|groupid|quantity|serviceoi|tss_productoi|tss_productname|servicedesc|tss_productOIDescription|tss_productManufacturer|start|end|term|tss_unitRate|extunitrate|tss_oneTimeCharge|extonetimecharge|unitdisc|tss_discUnitRate|extdiscunitrate|onetimedisc|disconetimecharge|extdisconetimecharge|adjusttype|priceclass\n#Services|3|1|3FE30935AA|Product OI GP3|"Product" Name Gp3|1 Year Term QTY 1 Fixed Discount|Prod Description Gp3\\|Mfg Gp3|||1|1200|1200||0|0.8333|200|200|0|0|0|SVCS|V';

		
		  Blob b = Blob.valueOf(csv);
		  Attachment attachment = new Attachment();
		  attachment.ParentId = dm.Id;
		  attachment.Name = 'Test Attachment for Parent';
		  attachment.Body = b;
		  insert attachment;
		
		Test.startTest();
		CPQ_SSFUploadController.WrapperData wrapper = new CPQ_SSFUploadController.WrapperData();
		wrapper = CPQ_SSFUploadController.uploadSSF(EncodingUtil.base64Encode(attachment.Body), 'a6803000000GXLjAAO');
		List<CPQ_QTC_CartServices.ProductData> csvDataRows = wrapper.csvData;
		Test.stopTest();
		
		System.assertNotEquals(null, csvDataRows, 'CSV read successfully');
		//CPQ_SSFUploadController.handleCommaInCSV(csv);
		//CPQ_SSFUploadController.addProductsToCartSSF(csvDataRows,config.Id);
		//CPQ_SSFUploadController.repriceCart(config.Id);
	}
}