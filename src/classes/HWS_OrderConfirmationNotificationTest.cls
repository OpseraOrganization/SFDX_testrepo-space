/**********************************************************************************
* Name : HWS_OrderConfirmationNotificationTest
* Description : Test class for HWS_OrderConfirmationNotification
********************************************************************************/ 
@isTest
public class HWS_OrderConfirmationNotificationTest {  
	@isTest
	static void testOrderConfirmationNotification(){ 
		Map<String, String> fieldsMap = new Map<String, String>() ;
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT, CNTCT, Product, Asset, Case, SVCNTRT,cli') ;
		List<Account> parentAccountList= HWS_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity');
		fieldsMap.put('AccountId', parentAccountList[0].ParentId); 
		parentAccountList[0].Email_Send_Check__c = 'Order Confirmation';
		update parentAccountList;
		List<Contact> contactList = HWS_TestFactoryDefaults.createContact(true, 1, null, fieldsMap) ;
		fieldsMap.put('contactId', contactList[0].Id);
		List<Servicecontract>  newServiceContract = HWS_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id)  ;
		String productId = HWS_TestFactoryDefaults.createProductDataSetUp( true,  1, fieldsMap)[0].Id;
		fieldsMap.put('Product2Id',productId);
		string pricebookEntryId = HWS_TestFactoryDefaults.createPriceBookEntry(  true, fieldsMap)[0].Id;
		fieldsMap.put('pricebookEntryId',pricebookEntryId);
		List<ContractLineItem> cli = HWS_TestFactoryDefaults.createContractLineItemData(true,1,fieldsMap );
		fieldsMap.put('ContractLineItemid',cli[0].Id);
		List<Asset> astList =  HWS_TestFactoryDefaults.createAssetData(true, 1,'HWS_Covered_Part', fieldsMap);
		fieldsMap.put('AssetId',astList[0].id);
		List<HWS_VersionItem__c> version = HWS_TestFactoryDefaults.createVerionsItems(true, 1, fieldsMap);
		fieldsMap.put('versionItemId',version[0].id);
		Case ParentCase= HWS_TestFactoryDefaults.insertParentCase(false, fieldsMap);
		ParentCase.Status = 'Draft';
		ParentCase.HWS_ReturnAddressReceivedFromSOO__c = true;
		insert ParentCase;
		fieldsMap.put('ParentCase', ParentCase.Id);
	List<Case>  ChildCase= HWS_TestFactoryDefaults.insertChildCase(true,1,'HWS_Advance_Exchange_In_Hours', fieldsMap);
		fieldsMap.put('childcaseId', ChildCase[0].Id);  
		List<Case> caseToUpdate = new List<Case>();
		ParentCase.AccountId = parentAccountList[0].Id;
		ParentCase.ContactId = contactList[0].Id;
		ParentCase.HWS_Communication_Contact__c = contactList[0].Id;
		ParentCase.Origin = 'Web';
		caseToUpdate.add(ParentCase);		
		ChildCase[0].Status='Ordered';
		caseToUpdate.add(ChildCase[0]);		
		update caseToUpdate;
		List<HWS_BulkUpload__c> bulkToInsertLst = new List<HWS_BulkUpload__c>();
		set<id> casid =new set<id>();
		casid.add(ChildCase[0].Id);
		HWS_BulkUpload__c bulkupl = new HWS_BulkUpload__c();
		bulkupl.Part_Code_Part_Revision__c = parentCase.Id;
		bulkupl.Faulty_Serial_number__c='12345';
		bulkupl.Fault_Detection__c= HWS_Constants.REBOOT_MODULE;
		bulkupl.Fault_Description__c=HWS_Constants.NoTXPOWER;
		bulkupl.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bulkupl.Fault_Detection_Date__c=startDate;
		bulkupl.HWS_Service_Contract_Number__c ='';
		bulkupl.HWS_LSPResponse__c ='{"ParentCaseId":"'+ParentCase.Id+'","ChildCases":[ {"LogisticNode":"US-DC","LogisticNodeName":"DC US P20","ReturnAddressNode":"RLC-CA P20","SRMServiceItemID":"'+ChildCase[0].Id+'"}] ,"DeliveryAddress":[ {"AddressType":"Return Location","City":"Mississauga","Country":"CA","Name":"RLC-CA","PostalCode":"L5S 1W3","Region":"NAR","ReturnAddressNode":"RLC-CA P20","State":"Ontario","Street":"Nokia c/o UPS SCS"}] ,"SupplierNodes":[ {"LogisticNode":"US-DC","LogisticNodeName":"DC US P20","pxObjClass":"NSN-Data-SRM-ChildCase"}] }';
		bulkToInsertLst.add(bulkupl);
		
		insert bulkToInsertLst;
		Test.startTest();
		HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(casid);
		HWS_OrderConfirmationNotification.sendPdf(ParentCase);
		HWS_OrderConfirmationNotification.getCases();
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		Test.stopTest();	
	}
	
	@isTest
	static void testOrderConfirmationNotification1(){
		
		Map<String, String> fieldsMap = new Map<String, String>();
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT, CNTCT, Product, Asset, Case, SVCNTRT,cli');
	
		List<Account> parentAccountList= HWS_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity');
		fieldsMap.put('AccountId', parentAccountList[0].ParentId); 
		parentAccountList[0].Email_Send_Check__c = 'Order Confirmation';
		update parentAccountList;
		List<Contact> contactList = HWS_TestFactoryDefaults.createContact(true, 1, null, fieldsMap);
		fieldsMap.put('contactId', contactList[0].Id);
		List<Servicecontract>  newServiceContract = HWS_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		String productId = HWS_TestFactoryDefaults.createProductDataSetUp( true,  1, fieldsMap)[0].Id;
		fieldsMap.put('Product2Id',productId);
		string pricebookEntryId = HWS_TestFactoryDefaults.createPriceBookEntry(  true, fieldsMap)[0].Id;
		fieldsMap.put('pricebookEntryId',pricebookEntryId);
		List<ContractLineItem> cli = HWS_TestFactoryDefaults.createContractLineItemData(true,1,fieldsMap );
		fieldsMap.put('ContractLineItemid',cli[0].Id);
		List<Asset> astList =  HWS_TestFactoryDefaults.createAssetData(true, 1,'HWS_Covered_Part', fieldsMap);
		fieldsMap.put('AssetId',astList[0].id);
		List<HWS_VersionItem__c> version = HWS_TestFactoryDefaults.createVerionsItems(true, 1, fieldsMap);
		fieldsMap.put('versionItemId',version[0].id);
		Case ParentCase= HWS_TestFactoryDefaults.insertParentCase(true, fieldsMap);
		fieldsMap.put('ParentCase', ParentCase.Id);
		List<Case>  ChildCase= HWS_TestFactoryDefaults.insertChildCase(true,1,'HWS_Advance_Exchange_In_Hours', fieldsMap);
		fieldsMap.put('childcaseId', ChildCase[0].Id);  
		List<Case> caseToUpdate = new List<Case>();
		ParentCase.AccountId = parentAccountList[0].Id;
		ParentCase.ContactId = contactList[0].Id;
		ParentCase.HWS_Communication_Contact__c = contactList[0].Id;
		ParentCase.Origin = 'Web';
		ParentCase.HWS_ReturnAddressReceivedFromSOO__c = true;
		caseToUpdate.add(ParentCase);		
		ChildCase[0].Status='Cancelled';
		caseToUpdate.add(ChildCase[0]);
		update caseToUpdate;
		//added to increase coverage -- START
		PageReference pageRef = Page.HWS_OrderConfirmationNotificationVFPage; 
		Test.setCurrentPage(pageRef); 
		ApexPages.StandardSetController sc = new ApexPages.StandardSetController(caseToUpdate);
	 	HWS_OrderConfirmationNotification testOrderCnf = new HWS_OrderConfirmationNotification(sc);
	 	Id childId = HWS_OrderConfirmationNotification.childCaseReadOnly;
	 	//added to increase coverage -- END
		List<HWS_BulkUpload__c> bulkToInsertLst = new List<HWS_BulkUpload__c>();
		set<id> casid =new set<id>();
		casid.add(ChildCase[0].Id);
		HWS_BulkUpload__c bulkupl = new HWS_BulkUpload__c();
		bulkupl.Part_Code_Part_Revision__c = parentCase.Id;
		bulkupl.Faulty_Serial_number__c='12345';
		bulkupl.Fault_Detection__c= HWS_Constants.REBOOT_MODULE;
		bulkupl.Fault_Description__c=HWS_Constants.NoTXPOWER;
		bulkupl.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bulkupl.Fault_Detection_Date__c=startDate;
		bulkupl.HWS_Service_Contract_Number__c ='';
		bulkupl.HWS_LSPResponse__c ='{"ParentCaseId":"'+ParentCase.Id+'","ChildCases":[ {"LogisticNode":"US-DC","LogisticNodeName":"DC US P20","ReturnAddressNode":"RLC-CA P20","SRMServiceItemID":"'+ChildCase[0].Id+'"}] ,"DeliveryAddress":[ {"AddressType":"Return Location","City":"Mississauga","Country":"CA","Name":"RLC-CA","PostalCode":"L5S 1W3","Region":"NAR","ReturnAddressNode":"RLC-CA P20","State":"Ontario","Street":"Nokia c/o UPS SCS"}] ,"SupplierNodes":[ {"LogisticNode":"US-DC","LogisticNodeName":"DC US P20","pxObjClass":"NSN-Data-SRM-ChildCase"}] }';
		bulkToInsertLst.add(bulkupl);
		
		insert bulkToInsertLst;
		Test.startTest();
		HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(casid);
		HWS_OrderConfirmationNotification.sendPdf(ParentCase);
		ApexPages.currentPage().getParameters().put('id',ParentCase.Id);
		HWS_OrderConfirmationNotification.getCases();
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		ChildCase[0].CH_EntitlementException__c = HWS_Constants.IWPOMissing;
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatus(ChildCase[0]);
		ChildCase[0].CH_EntitlementException__c = HWS_Constants.OWPOMissing;
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatus(ChildCase[0]);
		ChildCase[0].CH_EntitlementException__c = HWS_Constants.UWStatus;
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatus(ChildCase[0]);
		ChildCase[0].CH_EntitlementException__c = HWS_Constants.WStatusCheckFailed;
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatus(ChildCase[0]);
		ChildCase[0].CH_EntitlementException__c = 'No Exception';
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(ChildCase[0]);
		HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatus(ChildCase[0]);
		Test.stopTest();	
	}
}