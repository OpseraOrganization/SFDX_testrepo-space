public with sharing class CH_Casequery{
	public List<Case> cs{get; set;}
	public Boolean isHardWare { get; set;}
	public string currentTime {get;set;}
	public CH_Casequery() {
		//Added on 04-April-2021 | NOKIASC-35092 | Start
		Datetime dt = (DateTime)System.now();
		currentTime = string.valueof(dt.format('EEE')+' '+ dt.format('MMM')+' '+dt.format('dd')+' '+dt.format('YYYY')+' '+dt.format('HH')+'_'+dt.format('mm')+'_'+dt.format('ss')+' '+UserInfo.getTimeZone());
		//Added on 04-April-2021 | NOKIASC-35092 | End
		String rtType = ApexPages.currentPage().getParameters().get('rtType');
		isHardWare = false;
		Date startDate = null;
		Date endDate = null;
		
		String startString = ApexPages.currentPage().getParameters().get('startDate');
		if (String.isNotBlank(startString)) {
			startDate = Date.valueOf(startString.escapeHtml4());
		} 
		String endString = ApexPages.currentPage().getParameters().get('endDate');
		if (String.isNotBlank(endString)) {
			endDate = Date.valueOf(endString.escapeHtml4());
		}
	   
		String status = ApexPages.currentPage().getParameters().get('status');
		cs = new List<Case>();
	Set<String> closedStatusSet = new Set<String> {'Closed', 'Completed','Cancelled'};
		// Moved the code to getRecordTypeIds method as per NOKIASC-31960
		
	String query;
	String whereCondition = ' WHERE ParentId!=null';
		
		 if(rtType == 'HWS'){
	//Updated on 04-April-2021 | NOKIASC-35092 | Start
			 List<String> HWSRecordTypeIdSet = new List<String>();
			 HWSRecordTypeIdSet = CH_Casequery.getRecordTypeIds().get('HWS');
			isHardWare = true;	
			//Updated on 12-April-2021 | NOKIASC-35326 | added Parent.CH_ReportedDate__c 
			query = 'SELECT Parent.CH_ReportedDate__c,HWS_Service_Offering__c,NCP_Product_Name__c,HWS_Part_Name__c,HWS_SupportTicketReference__c,ClosedDate,HWS_Requested_Delivery_Date_Time__c,Contact.Account.Name,Account.Name,Parent.HWS_Address_Name__c,Parent.POSTAL_CODE_CHQ__c,Parent.City__c,Parent.State__c,Parent.HWS_Shipment_Recipient_Name__c,Parent.Street_Address_1__c,Parent.Street_Address_2__c,Parent.Street_Address_3__c,Parent.HWS_Requested_Delivery_Date_Time__c,Parent.Country__c,parent.HWS_Customer_Reference_Number__c,HWS_ReplacementUnitMaterialCode__c, Status,HWS_ShippedQuantity__c,HWS_Shippeddate__c,HWS_Failure_Description__c, HWS_Part_Code__c, CreatedDate, Contact.Name, HWS_Customer_Reference_Number__c,HWS_Stockable_Product__c, CH_NetworkElementAsset__c, HWS_ServiceType__c,CH_ServiceContractNumber__c, HWS_RequestedDateShipment__c,HWS_Shipment_Recipient_Name__c,HWS_PlannedDeliveryDateShipment__c,HWS_FaultyUnitMaterialCode__c,HWS_FaultyUnitReceivedDate__c,HWS_Faulty_Serial_Number__c,HWS_AWBNumber__c,HWS_LSP_Courier_Name__c,HWS_ProofDeliveryDate__c,HWS_Replacement_Unit_Serial_Number__c,HWS_Planned_Delivery_Date__c';
			whereCondition = whereCondition + ' AND RecordTypeId IN :HWSRecordTypeIdSet ';
			//Updated on 04-April-2021 | NOKIASC-35092 | End
		} else {
			//Updated on 04-April-2021 | NOKIASC-35092 | Start
			List<String> SWSRecordTypeIdSet = new List<String>();
			SWSRecordTypeIdSet = CH_Casequery.getRecordTypeIds().get('SWS');
			//Updated on 04-April-2021 | NOKIASC-35092 | End
			isHardWare = false;
			//Updated on 12-April-2021 | NOKIASC-35326 | removed CH_Reported_Date__c
			query = 'SELECT Id,CH_ProductVariant__r.Name,CH_Product_Release__r.Name,CH_ReportedDate__c,CH_ServiceContractNumber__c,Country__c,ProductId,CH_Solution__c,CH_SW_Release__c,CH_SW_Build__c,parentId, CaseNumber,Subject, Status, Severity__c, CreatedDate, CH_Product_Name__c, Contact.Name,HWS_Customer_Reference_Number__c,Product.Name,CH_ProductVariant__c,CH_Product_Release__c,CH_Solution_Name__c,CH_SW_Release_Name__c,CH_SW_Build_Name__c,CH_NetworkElementAsset__r.Name,AccountId,Account.Name,Entitlement.Servicecontract.Name,Contact.Account.Name,Parent.Hws_Ship_to_Party_Address__r.Country__c,CH_InitialResponse__c,CH_SystemRestored__c,CH_SolutionProvided__c,ClosedDate,CH_LastCustomerInteraction__c,CH_Summary__c,CH_TemporarySolutionProvided__c,CH_InvitationLink__c';
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
			whereCondition = whereCondition +' AND Status IN :closedStatusSet';  
		} else if(status == 'Open') {
			whereCondition = whereCondition + ' AND Status NOT IN :closedStatusSet';
		}
	//  else {
	//  whereCondition = whereCondition ;  
	//  }
		
		String limitQuery = ' LIMIT 10000';
		String fromQuery = ' FROM Case';
		String finalQuery = query + fromQuery + whereCondition + limitQuery;
		cs = Database.query(finalQuery);
		}
	 // Create this method as per NOKIASC-31960
	public static Map<String,List<String>> getRecordTypeIds()
	{
		Map<String,List<String>> rtMapId=new Map<String,List<String>>();
		List<String> HWSRecordTypeId = new List<String>();
		List<String> SWSRecordTypeId = new List<String>();
		Set<String> HWSRecTypeSet = new Set<String> {'HWS_Advance_Exchange_In_Days','HWS_Advance_Exchange_In_Hours', 'HWS_Child_Case_Read_Only','HWS_Parent_Case','HWS_Parent_Case_Ready_Only','HWS_Return_For_Repair','HWS_Spare_Part_Sales', 'HWS_Spare_Part_Sales_Read_only'};
		Set<String> SWSRecTypeSet = new Set<String> {'CH_NokiaStandardCase','CH_NokiaInformationRequest'};
		Set<String> HwsSwsSet=new Set<String>();
		HwsSwsSet.addAll(HWSRecTypeSet);
		HwsSwsSet.addAll(SWSRecTypeSet);
		for (RecordType rt : [SELECT Id, SobjectType, DeveloperName 
		FROM RecordType 
		WHERE SobjectType='Case'
		AND DeveloperName IN :HwsSwsSet]) 
		{
			if(HWSRecTypeSet.contains(rt.DeveloperName))
			{
				HWSRecordTypeId.add(rt.Id);
			}
			else if(SWSRecTypeSet.contains(rt.DeveloperName))
			{
				SWSRecordTypeId.add(rt.Id); 
			}
	
		}
		rtMapId.put('HWS',HWSRecordTypeId);
		rtMapId.put('SWS',SWSRecordTypeId);
		return rtMapId;
	}
}