/*****************************************************************
Description: Wrapper class to store Child Case attributes that are being sent to SOO
History									
DATE			AUTHOR	CHANGE
11/11/2018	  Shiv Maila	  Created
20/12/2018	  Vinod Ch		Updated
*****************************************************************/
Public without sharing Class HWS_ChildCases_WRAPPER{
	Public String SRMServiceItemID;
	Public String RMA;
	Public String Status;
	Public String CustomerRequestedDeliveryDate;
	Public String PlannedDeliveryDate;
	Public string ServiceAgreementId;
	Public String ServiceType ;
	Public String SalesOrg;
	Public String ContractLineNumber;
	Public String LegacyErpInfo;
	Public String InvoicingMethod;
	Public String IncotermsType;
	Public String IncotermsCity;
	Public String CostCollector;
	Public String CostCollectorType;
	Public String SLAValue;
	Public String SLAType;
	Public String CustomerPO ;
	Public String PartMaterialCode;
	Public String PartRevisionMaterialCode;
	Public String CustomerReferenceNumber;
	Public String FailureDetectionDate ;
	Public String FailureOccurence;
	Public String FailureDetection;
	Public String FailureDescription;
	Public String FaultySerialNumber;
	Public String AdditionalFailureInformation;
	Public String ReportedByName;
	Public String ReportedByPhone;
	Public String ReportedByEmail;
	Public String SiteID;
	Public String SiteInformation;
	Public Decimal Quantity;
	Public String ReplacementUnitSerialNum;
	Public String SerialNumberTraced;
	Public String ObjectiveType;
	Public String SeparateOrderFlag;
	Public String SAPLineNumber;
	Public String BillToID;
	Public String HighLevelProduct;
	Public String CurrencyType;
	Public String UnitOfMeasure;
	Public String DesignResponsibility;
	Public Boolean isRCAFMARequested;
	public static final String RFREPAIR = 'Return for Repair or Replacement';
	public static final String SPS = 'Spare Part Sales';
	public static final String AEDAYS = 'Advanced Exchange in Days';
	
	Public HWS_ChildCases_WRAPPER(Case childcase) {
		this.SRMServiceItemID=childcase.id;
		if(childcase.HWS_Contract_Line_Item__r.CH_ServiceType__c== SPS){
			this.RMA = childcase.HWS_SPS_Order_No__c;
		}
		else{
			this.RMA = childcase.HWS_RMA_Number__c;
		}
		this.Status=childcase.Status;
		this.CustomerReferenceNumber=childcase.HWS_Customer_Reference_Number__c;
		this.CustomerRequestedDeliveryDate=HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormatGMT(childcase.HWS_Requested_Delivery_Date_Time__c);
		this.PlannedDeliveryDate=HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormatGMT(childcase.HWS_Planned_Delivery_Date__c);
		this.SalesOrg=childcase.NCP_Service_Contract__r.HWS_SalesOrganisation__c;
		//NOKIASC-36797
		if(childcase.NCP_Service_Contract__r.HWS_Combined_Ordering__c)
		{
			this.SalesOrg = childcase.HWS_Contract_Line_Item__r.HWS_SalesOrg__c;
		}
		this.BillToID=childcase.NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c;
		this.CurrencyType=childcase.NCP_Service_Contract__r.HWS_Currency__c;
		this.LegacyErpInfo=childcase.NCP_Service_Contract__r.CH_ERPSystem__c;
		//NOKIASC-36797
		if(childcase.NCP_Service_Contract__r.HWS_Combined_Ordering__c){
			this.LegacyErpInfo=childcase.HWS_Contract_Line_Item__r.HWS_ERPSystem__c;
		}
		//US 27245 begin	  
		//pass this to custom setting --analyze option
		this.ServiceType = childcase.HWS_Contract_Line_Item__r.CH_ServiceItemCode__c;
		//US 27245 end
		this.InvoicingMethod=childcase.HWS_Contract_Line_Item__r.HWS_InvoicingTypeCode__c;//Updated to invoicing type code as per US HWST-3434
		this.ContractLineNumber=childcase.HWS_Contract_Line_Item__r.HWS_SAPP20LineItem__c;
		this.IncotermsType=childcase.HWS_Contract_Line_Item__r.HWS_IncotermType__c;
		this.IncotermsCity=childcase.HWS_Contract_Line_Item__r.HWS_IncotermCity__c;
		this.CostCollector=childcase.HWS_Contract_Line_Item__r.CH_CostObject__c;
		this.CostCollectorType=childcase.HWS_Contract_Line_Item__r.CH_CostObjectType__c;
		this.ObjectiveType=childcase.HWS_Contract_Line_Item__r.HWS_LeadTimeType__c;
		this.SeparateOrderFlag=childcase.HWS_Contract_Line_Item__r.HWS_SeparateOrderPerPart__c;
		this.SAPLineNumber=childcase.HWS_Contract_Line_Item__r.HWS_SAPP20LineItem__c;
		this.HighLevelProduct=childcase.HWS_Contract_Line_Item__r.Product2.Productcode;
		this.CustomerPO =childcase.Parent.HWS_Customer_PO__c;
		this.SLAValue=childcase.Asset.HWS_ContractLeadTimeDuration__c;
		this.SLAType=childcase.Asset.HWS_ContractLeadTimeUnit__c;
		this.PartMaterialCode=childcase.HWS_Sellable_Product__r.ProductCode;
		this.DesignResponsibility=childcase.Asset.HWS_DesignResponsibility__c;
		this.PartRevisionMaterialCode=childcase.HWS_Stockable_Product__r.HWS_Version_Code__c;
		this.FailureDetectionDate=HWS_ParentCase_WRAPPER.convetDate(childcase.HWS_Failure_Detection_Date__c);
		//NOKIASC-36797
		if(childcase.NCP_Service_Contract__r.CH_ERPSystem__c=='P20' || (childcase.NCP_Service_Contract__r.HWS_Combined_Ordering__c && childcase.HWS_Contract_Line_Item__r.HWS_ERPSystem__c =='SAP P20')){
			this.PartMaterialCode=childcase.HWS_Sellable_Product__r.ProductCode;
			this.PartRevisionMaterialCode=childcase.HWS_Stockable_Product__r.HWS_Version_Code__c;  
			system.debug('-P20--'+this.PartRevisionMaterialCode);
		}
		else{
			this.PartMaterialCode=childcase.HWS_Stockable_Product__r.RES_ID__c;
			if(childcase.HWS_Stockable_Product__r.HWS_Version_Code__c=='ANY'){
	//HWST_4188
	if(childcase.HWS_Customer_Part_Revision__c != null && childcase.HWS_Customer_Part_Revision__c !=''){
		this.PartRevisionMaterialCode=childcase.HWS_Stockable_Product__r.RES_ID__c+childcase.HWS_Customer_Part_Revision__c;	
	}
	else{		this.PartRevisionMaterialCode=childcase.HWS_Stockable_Product__r.RES_ID__c;		
		}
			}
			else{
	this.PartRevisionMaterialCode=childcase.HWS_Stockable_Product__r.RES_ID__c+childcase.HWS_Stockable_Product__r.HWS_Version_Code__c;  
			}
		}
		//NOKIASC-36797
		if(childcase.NCP_Service_Contract__r.CH_ERPSystem__c=='P20' || (childcase.NCP_Service_Contract__r.HWS_Combined_Ordering__c && childcase.HWS_Contract_Line_Item__r.HWS_ERPSystem__c =='SAP P20')){
			this.ServiceAgreementId=childcase.NCP_Service_Contract__r.CH_SAP_ContractNumber__c;
			if(childcase.HWS_Failure_Occurance__c=='In normal use'){
	this.FailureOccurence='1';	
			}else if(childcase.HWS_Failure_Occurance__c=='Permanent'){
	this.FailureOccurence='2';	
			}else if(childcase.HWS_Failure_Occurance__c=='During installation / commissioning / Dead On Arrival'){
	this.FailureOccurence='3';	
			}else if(childcase.HWS_Failure_Occurance__c=='During or after lightning / severe weather conditions'){
	this.FailureOccurence='4';	
			}else if(childcase.HWS_Failure_Occurance__c=='During or after SW or HW upgrade / modifications'){
	this.FailureOccurence='5';	
			}else if(childcase.HWS_Failure_Occurance__c=='During preventive maintenance'){
	this.FailureOccurence='6';	
			}else if(childcase.HWS_Failure_Occurance__c=='During high traffic load'){
	this.FailureOccurence='7';	
			}
			if(childcase.HWS_Failure_Detection__c=='Start reset loop'){
	this.FailureDetection='1';	
			}else if(childcase.HWS_Failure_Detection__c=='Reboot module'){
	this.FailureDetection='2';	
			}else if(childcase.HWS_Failure_Detection__c=='Fails on diagnostics'){
	this.FailureDetection='3';	
			}else if(childcase.HWS_Failure_Detection__c=='Other'){
	this.FailureDetection='4';	
			}else if(childcase.HWS_Failure_Detection__c=='Non-reproducible'){
	this.FailureDetection='5';	
			}
			if(childcase.HWS_Failure_Description__c=='Unit/module not recognized'){
	this.FailureDescription='1';	
			}if(childcase.HWS_Failure_Description__c=='No TX power'){
	this.FailureDescription='2';	
			}if(childcase.HWS_Failure_Description__c=='Fan defect'){
	this.FailureDescription='3';	
			}if(childcase.HWS_Failure_Description__c=='LED indicates alarm'){
	this.FailureDescription='4';	
			}if(childcase.HWS_Failure_Description__c=='Unit alarm'){
	this.FailureDescription='5';	
			}if(childcase.HWS_Failure_Description__c=='SW download failure'){
	this.FailureDescription='6';	
			}if(childcase.HWS_Failure_Description__c=='Feature Activation effect'){
	this.FailureDescription='7';	
			}if(childcase.HWS_Failure_Description__c=='Advise for exchange from others'){
	this.FailureDescription='8';	
			}
		}else{
			this.ServiceAgreementId=childcase.NCP_Service_Contract__r.CH_CARES_ServiceAgreement__c;
			this.FailureOccurence=childcase.HWS_Failure_Occurance__c;
			this.FailureDescription=childcase.HWS_Failure_Description__c;
			this.FailureDetection=childcase.HWS_Failure_Detection__c;
		}
		if(childcase.HWS_Faulty_Serial_Number__c!=Null && childcase.HWS_Faulty_Serial_Number__c !=''){
			this.FaultySerialNumber=(childcase.HWS_Faulty_Serial_Number__c).toUpperCase();
		}
		this.ReportedByName=childcase.HWS_Fault_Reported_By_Name__c;
		this.ReportedByPhone=childcase.HWS_Fault_Reported_By_Phone__c;
		this.ReportedByEmail=childcase.HWS_Fault_Reported_By_Email__c;
		this.ReplacementUnitSerialNum=childcase.HWS_Replacement_Unit_Serial_Number__c;
		this.AdditionalFailureInformation=childcase.HWS_Failure_Description_Server_ID__c;
		this.SiteID=childcase.HWS_Site_ID__c;
		this.SiteInformation=childcase.HWS_Site_Information__c;
		this.SerialNumberTraced=childcase.HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c;
		this.Quantity=childcase.HWS_Quantity__c;
		this.UnitOfMeasure=childcase.HWS_Sellable_Product__r.HWS_Unit_of_Measure__c;
		this.isRCAFMARequested=childcase.HWS_RequestHWRCAFMA__c; //NOKAISC-31187
	}
}