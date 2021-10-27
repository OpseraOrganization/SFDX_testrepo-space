@isTest
public class HWS_SubAssembliesToProductBatch_TEST {
	@isTest
	public Static Void updateProductveriosn(){
		List<HWS_Product_Serviceable_Sales_Item__c> prodSerSaleItem = new List<HWS_Product_Serviceable_Sales_Item__c>();
		Map<String,String> nsnPartNameMap = new Map<String, String>();
		HWS_Product_Serviceable_Sales_Item__c hPSSI = new HWS_Product_Serviceable_Sales_Item__c();
		hPSSI.HWS_NSNCode__c='NSNCode1';
		hPSSI.HWS_Part_Number__c='NSNCode1';
		hPSSI.HWS_Is_Assembly_Processed__c = false;
		prodSerSaleItem.add(hPSSI);
		
		HWS_Product_Serviceable_Sales_Item__c hPSSI2 = new HWS_Product_Serviceable_Sales_Item__c();
		hPSSI2.HWS_NSNCode__c='NSNCode12';
		hPSSI.HWS_Part_Number__c='NSNCode12';
		hPSSI2.HWS_Is_Assembly_Processed__c = false;
		prodSerSaleItem.add(hPSSI2);
		
		insert prodSerSaleItem;
		Set<String> nsncodes = new Set<String>();
		for(HWS_Product_Serviceable_Sales_Item__c pssi: prodSerSaleItem){
			nsncodes.add(pssi.HWS_Part_Number__c);
			nsnPartNameMap.put(pssi.HWS_Part_Number__c,pssi.HWS_Part_name__c);
		}
		List<HWS_Product_Version_Item__c> prodVerItems = new List<HWS_Product_Version_Item__c>();
		HWS_Product_Version_Item__c hPVI = new HWS_Product_Version_Item__c();
		hPVI.HWS_NSNCode__c = 'NSNCode1';
		prodVerItems.add(hPVI);
		HWS_Product_Version_Item__c hPI = new HWS_Product_Version_Item__c();
		hPI.HWS_NSNCode__c = 'NSNCode12';
		prodVerItems.add(hPI);
		insert prodVerItems;
		test.startTest();
		HWS_SubAssembliesToProductVersionBatch Pvb = new HWS_SubAssembliesToProductVersionBatch();
		Database.BatchableContext BC;
		Pvb.updateProductVersionField(nsncodes,nsnPartNameMap);
		Pvb.start(BC);
		Pvb.execute(BC, prodSerSaleItem);
		Pvb.finish(BC);
		Database.Error[] errorlist = new Database.Error[]{};
		Pvb.createErrorLog(errorlist, hPVI, 'Insert');
		test.stopTest();
	}
}