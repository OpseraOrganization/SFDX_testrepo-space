/*****************************************************************
Description:	This class returns json string of requested case
History									
DATE			AUTHOR	CHANGE
11/11/2018	  Shiv Maila	  Created
20/12/2018	  Vinod Ch		Updated
*****************************************************************/
Public without sharing Class HWS_CreateSRRequest
{
	/*****************************************************************
Description:	Returns the string json of the requested case object 
Parameters: parentCaseId
Returns:  JSON String
Throws [Exceptions]: [optional]	
History						
DATE			AUTHOR	CHANGE
11/11/2018	  Shiv Maila	  Created
20/12/2018	  Vinod Ch		Updated
10/03/2019	  Harikishore	 Updated
*****************************************************************/
	Public SOORequestBody createSRRequest(Id parentCaseId){
		Case caserec = [SELECT id,Account.Name,Account.AccountNumber,Account.NCP_P20_ID__c, Account.LE_Customer_Compliance__c,CreatedBy.Name,Status,CreatedDate,HWS_Customer_Reference_Number__c,
			Hws_Ship_to_Party_Address__r.BillingCountryCode,Hws_Ship_to_Party_Address__r.BillingStateCode,CaseNumber,Origin,HWS_Shipment_Recipient_Name__c,Hws_Ship_to_Party_Address__r.ParentId,
			HWS_Shipment_Recipient_Phone__c,HWS_Delivery_Additional_Information__c,Hws_Ship_to_Party_Address__r.BillingPostalCode,HWS_ShipmentRecipientEmailId__c,
			Hws_Ship_to_Party_Address__r.Hws_Address_Line_1__c,Hws_Ship_to_Party_Address__r.Hws_Address_Line_2__c,Hws_Ship_to_Party_Address__r.Hws_Address_Line_3__c,
			Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.P20_Logistic_ID__c,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.Region__c,HWS_Delivery_TimeZone__c,
			(SELECT id,HWS_Stockable_Product__r.RES_ID__c,HWS_RMA_Number__c,Status,NCP_Service_Contract__r.CH_SAP_ContractNumber__c,NCP_Service_Contract__r.CH_CARES_ServiceAgreement__c,HWS_Customer_Reference_Number__c,
			 HWS_Planned_Delivery_Date__c,NCP_Service_Contract__r.HWS_SalesOrganisation__c,NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c,HWS_Requested_Delivery_Date_Time__c,
			 NCP_Service_Contract__r.HWS_Currency__c,NCP_Service_Contract__r.CH_ERPSystem__c,HWS_Contract_Line_Item__r.CH_ServiceItemCode__c,HWS_Contract_Line_Item__r.HWS_InvoicingTypeCode__c,
			 HWS_Contract_Line_Item__r.CH_CDB_ContractId__c,HWS_Contract_Line_Item__r.HWS_IncotermType__c,HWS_Contract_Line_Item__r.HWS_IncotermCity__c,HWS_Contract_Line_Item__r.CH_CostObject__c,
			 HWS_Contract_Line_Item__r.CH_CostObjectType__c,HWS_Contract_Line_Item__r.HWS_LeadTimeType__c,HWS_Contract_Line_Item__r.HWS_SeparateOrderPerPart__c,HWS_Contract_Line_Item__r.HWS_SAPP20LineItem__c,
			 HWS_Contract_Line_Item__r.Product2.Productcode,HWS_Contract_Line_Item__r.CH_ServiceTypeCode__c,Parent.HWS_Customer_PO__c,Asset.HWS_ContractLeadTimeDuration__c,Asset.HWS_ContractLeadTimeUnit__c,
			 HWS_Sellable_Product__r.ProductCode,HWS_Sellable_Product__r.HWS_Unit_of_Measure__c,HWS_Stockable_Product__r.Material_Code__c,HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Failure_Detection_Date__c,
			 HWS_Failure_Occurance__c,HWS_Failure_Detection__c,HWS_Failure_Description__c,HWS_Faulty_Serial_Number__c,HWS_Fault_Reported_By_Name__c,HWS_Fault_Reported_By_Phone__c,HWS_Fault_Reported_By_Email__c,
			 HWS_Replacement_Unit_Serial_Number__c,HWS_Customer_Part_Revision__c,HWS_Site_ID__c,HWS_Failure_Description_Server_ID__c,HWS_Site_Information__c,HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c,HWS_Quantity__c,RecordTypeId,
			 HWS_SPS_Order_No__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,HWS_Delivery_TimeZone__c, HWS_ServiceType__c
			 FROM Cases
			 WHERE Status!='Cancelled')
			FROM Case
			WHERE id = :parentCaseId];
		HWS_ParentCase_WRAPPER parentCase ;
		if(caserec.Cases.size() > 0)
		{
			parentCase = new HWS_ParentCase_WRAPPER(caserec,caserec.Cases[0].NCP_Service_Contract__r.CH_ERPSystem__c,caserec.Cases[0].HWS_Contract_Line_Item__r.CH_ServiceType__c);
			for(Case childCaseRec: caserec.Cases){
	parentCase.Requestitems.add(new HWS_ChildCases_WRAPPER(childCaseRec));
			}
		}	
		String jsonString = JSON.serialize(parentCase,true);
		SOORequestBody obj=new SOORequestBody();
		obj.jsonPayload=jsonString;
		obj.caseNumber=caserec.CaseNumber;
		return obj;
	}
	public class SOORequestBody{
		public String jsonPayload;
		public String caseNumber;	 
	}
}