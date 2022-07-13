public with sharing class CH_csvDownloadCtrl {   
	@AuraEnabled
	public static list <case> fetchCase(){
		
		List <Case> returnCaseList = new List < Case > ();
		
		list<user> cid=[Select contactId from user where id=: userinfo.getUserId()];
		string cid1 = cid[0].contactId;
		for(case cas: [SELECT CaseNumber,Subject, Status,Severity__c,CreatedDate,CH_Product_Name__c,CH_Reported_Date__c,ContactId  From Case where contactId=:cid1 LIMIT 1000 ]) {
			returnCaseList.add(cas);
		}
		return returnCaseList;
	}
	@AuraEnabled 
	public static String getExcelFileAsBase64String(String type, String startDate, String endDate, String status) {
		PageReference excelPage = Page.excelfilepage;
		excelPage.getParameters().put('rtType', type);
		excelPage.getParameters().put('startDate',startDate);
		excelPage.getParameters().put('endDate',endDate);
		excelPage.getParameters().put('status',status);
		Blob excelBlob;
		if(Test.isRunningTest()) { 
			excelBlob = blob.valueOf('Unit.Test');
		} else {
			excelBlob = excelPage.getContent();
		}
		String base64Excel = EncodingUtil.base64Encode(excelBlob);
		return base64Excel;  
	}  
	
	@AuraEnabled
	public Static List<Case> getCaseInfoForDownload(String type, Date startDate, Date endDate, String status) {
		
		List<Case> caseList = new List<Case>();
		Set<String> closedStatusSet = new Set<String> {'Closed', 'Completed','Cancelled'};
			// Created a method getRecordTypeIds in CH_Casequery class to remove duplicate code as per NOKIASC-31960
			List<String> HWSRecordTypeIdSet = new List<String>();
		List<String> SWSRecordTypeIdSet = new List<String>();
		HWSRecordTypeIdSet = CH_Casequery.getRecordTypeIds().get('HWS');
		SWSRecordTypeIdSet = CH_Casequery.getRecordTypeIds().get('SWS');
		
		String query;
		String whereCondition = ' WHERE ParentId!=null';
		
		if(type == 'HWS'){
			
			query = 'SELECT Id,HWS_Service_Offering__c,NCP_Product_Name__c,HWS_Part_Name__c,Parent.CH_ReportedDate__c,HWS_SupportTicketReference__c,ClosedDate,HWS_Contract_Line_Item__r.CH_ServiceOffering__c,HWS_Requested_Delivery_Date_Time__c,Contact.Account.Name,Account.Name,Parent.HWS_Address_Name__c,Parent.POSTAL_CODE_CHQ__c,Parent.City__c,Parent.State__c,Parent.HWS_Shipment_Recipient_Name__c,Parent.Street_Address_1__c,Parent.Street_Address_2__c,Parent.Street_Address_3__c,Parent.Country__c,HWS_Sellable_Product__r.Name,Product.Name,parent.HWS_Customer_Reference_Number__c,HWS_ReplacementUnitMaterialCode__c,CaseNumber,Subject, Status,HWS_ShippedQuantity__c, DateTime.Format(HWS_Shippeddate__c),HWS_Failure_Description__c, HWS_Part_Code__c, CreatedDate, Contact.Name, HWS_Customer_Reference_Number__c,HWS_Stockable_Product__c, HWS_Stockable_Product__r.Name, HWS_RMA_Number__c, HWS_Planned_Delivery_Date__c,CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__c, CH_ReportedDate__c, HWS_ServiceType__c,CH_ServiceContractNumber__c, HWS_RequestedDateShipment__c,HWS_Shipment_Recipient_Name__c,HWS_Shipment_Recipient_Phone__c,HWS_PlannedDeliveryDateShipment__c,HWS_FaultyUnitMaterialCode__c,HWS_FaultyUnitReceivedDate__c,HWS_Faulty_Serial_Number__c,HWS_AWBNumber__c,HWS_LSP_Courier_Name__c,HWS_ProofDeliveryDate__c,HWS_Replacement_Unit_Serial_Number__c,NCP_Service_Contract__c';
			whereCondition = whereCondition + ' AND RecordTypeId IN :HWSRecordTypeIdSet ';
		} else {
			// Updated on 12-April-2021 | NOKIASC-35326 | replaced CH_Reported_Date__c with  CH_ReportedDate__c
			// Updated the Query to replace HWS_Customer_Reference_Number__c with Reference_Number__c for NOKIASC-35556
			query = 'SELECT Id,parentId, CaseNumber,Subject, Status, Severity__c, CreatedDate, CH_Product_Name__c, Contact.Name,Reference_Number__c,Product.Name,CH_ProductVariant__c,CH_Product_Release__c,CH_Solution_Name__c,CH_SW_Release_Name__c,CH_SW_Build_Name__c,CH_NetworkElementAsset__r.Name,Account.name,Contact.Account.Name,Parent.Hws_Ship_to_Party_Address__r.Country__c,Country__c,CH_ReportedDate__c,CH_InitialResponse__c,CH_SystemRestored__c,CH_SolutionProvided__c,ClosedDate,CH_LastCustomerInteraction__c,CH_Summary__c,CH_TemporarySolutionProvided__c,CH_InvitationLink__c';
			whereCondition = ' WHERE RecordTypeId IN :SWSRecordTypeIdSet ';  
		}
		if (startDate != null ) {
			whereCondition  = whereCondition  + ' AND createdDate >=:startDate';
		}
		if (endDate != null ) {
			endDate= endDate.addDays(1);
			whereCondition  = whereCondition  + ' AND createdDate <=:endDate';
		}
		
		if (status == 'Closed') {
			whereCondition = whereCondition + ' AND Status IN :closedStatusSet';   
		}  else if(status == 'Open') {
			whereCondition = whereCondition + ' AND Status NOT IN :closedStatusSet';
		}
		//  else {
		// whereCondition = whereCondition ;  
		//  }
		
		String limitQuery = ' LIMIT 10000';
		String fromQuery = ' FROM Case';
		String finalQuery = query + fromQuery + whereCondition+ + limitQuery;
		caseList = Database.query(finalQuery);
		return caseList;
	} 
	
	//NOKIASC-35092 | 06/April/2021 | Added
	@AuraEnabled(cacheable=true)
	public static HWS_GenericSettings__c getHWS_GenericSettings(){
		return HWS_GenericSettings__c.getOrgDefaults();
	}
	
	@AuraEnabled
	public static Boolean showManageServiceQuote(){
		List<HWS_Service_Quote__c> sQuotesList = [SELECT Id FROM HWS_Service_Quote__c WITH SECURITY_ENFORCED LIMIT 1];
		if(sQuotesList != null && sQuotesList.size() > 0) {
			return true;
		}
		return false;
	}
	
}