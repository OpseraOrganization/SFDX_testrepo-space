/*****************************************************************
Description: Wrapper class to store Parent Case attributes that are being sent to SOO
History																														
DATE			AUTHOR		  CHANGE
11/11/2018	  Shiv Maila	  Created
20/12/2018	  Vinod Ch		Updated
10/03/2019	Harikishore	Updated
*****************************************************************/
Public class HWS_ParentCase_WRAPPER {
	Public String SRMRequestID;
	Public String CaseNumber;
	Public String RequestOrigin;
	Public String DateCreated;
	Public String Status;
	Public String CreatedBy;
	Public String SoldToID;
	Public String AccountName;
	Public String RequestorType;
	Public String CustomerReferenceNumber;
	Public String ShipmentRecipientName;
	Public String ShipmentRecipientPhone;
	Public String ShipmentRecipientEmail;
	Public String ShipToAddressID;
	Public String DeliveryNote;
	Public String PostalCode;
	Public String Street;
	Public String AddressLine2;
	Public String AddressLine3;
	Public String State;
	Public String Country;
	Public String City;
	Public String Region;
	Public String CustomerCompliance;
	Public String AddressType;
	Public String PickupLocation=System.Label.Account_ID_of_Global_Warehouse_Addresses;
	Public List<HWS_ChildCases_WRAPPER> Requestitems;	   
	
	Public HWS_ParentCase_WRAPPER(Case ParentCase,String erpSystem,String serviceType) {
		this.SRMRequestID = ParentCase.id;
		this.CaseNumber = ParentCase.CaseNumber;
		this.RequestOrigin= ParentCase.Origin;
		//this.RequestorType='Sample Type';//HardCoded as we do not have field in SRM
	// Added the code to send Delivery TimeZone of Contact
	if(ParentCase.HWS_Delivery_TimeZone__c!=null && ParentCase.HWS_Delivery_TimeZone__c!=''){
	  this.RequestorType=ParentCase.HWS_Delivery_TimeZone__c.substring(1,10);
	}
	// End code to send Delivery TimeZone of Contact
		this.DateCreated=convetDateTimetoSOOFormatGMT(ParentCase.CreatedDate);
		this.CustomerReferenceNumber=ParentCase.HWS_Customer_Reference_Number__c;
		this.CreatedBy= ParentCase.CreatedBy.Name;
		this.CustomerCompliance=ParentCase.Account.LE_Customer_Compliance__c;
		this.Status = ParentCase.Status;
		if(erpSystem=='P20'){
			this.SoldToID=ParentCase.Account.NCP_P20_ID__c;
		}else{
			this.SoldToID=ParentCase.Account.AccountNumber;
		}
		//52130 code indicates the service type is Advanced Exchange in Hours-- Added as part of HWST-3435
		if(serviceType=='Advanced Exchange in Hours' && ((PickupLocation!=Null || PickupLocation!='')&& PickupLocation==ParentCase.Hws_Ship_to_Party_Address__r.ParentId)){
			this.AddressType='Pickup';
		}else{
			this.AddressType='Delivery';
		}
		this.AccountName=ParentCase.Account.Name;
		this.ShipmentRecipientName=ParentCase.HWS_Shipment_Recipient_Name__c;
		this.ShipmentRecipientPhone=ParentCase.HWS_Shipment_Recipient_Phone__c;
		this.ShipmentRecipientEmail=ParentCase.HWS_ShipmentRecipientEmailId__c;
		this.ShipToAddressID = ParentCase.Hws_Ship_to_Party_Address__r.P20_Logistic_ID__c;
		this.DeliveryNote=ParentCase.HWS_Delivery_Additional_Information__c;
		this.PostalCode =ParentCase.Hws_Ship_to_Party_Address__r.BillingPostalCode;
		this.Street=ParentCase.Hws_Ship_to_Party_Address__r.Hws_Address_Line_1__c;
		this.AddressLine2=ParentCase.Hws_Ship_to_Party_Address__r.Hws_Address_Line_2__c;
		this.AddressLine3=ParentCase.Hws_Ship_to_Party_Address__r.Hws_Address_Line_3__c;
		if(ParentCase.Hws_Ship_to_Party_Address__r.BillingState!='- - -'){
			this.State=ParentCase.Hws_Ship_to_Party_Address__r.BillingStateCode;
		}else{
			this.State='';
		}
		this.Country=ParentCase.Hws_Ship_to_Party_Address__r.BillingCountryCode;
		this.City=ParentCase.Hws_Ship_to_Party_Address__r.BillingCity;
		this.Region=ParentCase.Hws_Ship_to_Party_Address__r.Region__c;
	  
		this.Requestitems= new List<HWS_ChildCases_WRAPPER>();	
	}
	/*****************************************************************
	Description: Method to Convert DateTime field value to 'yyyymmdd' format
	*****************************************************************/
	Public Static String convetDateTime(DateTime dT){
		String dateString;
		if(dT!=null){
			String Year= String.valueof(dT.year());
			String Month;
			String Day;
			Month=(String.valueof(dT.month())).length()==1?'0'+String.valueof(dT.month()):String.valueof(dT.month());
			Day=String.valueof(dT.day()).length()==1?'0'+String.valueof(dT.day()):String.valueof(dT.day());
			dateString=Year + Month + Day;
		}
		return dateString;
	}
	/*****************************************************************
	Description: Method to Convert Date field value to 'yyyymmdd' format
	*****************************************************************/
	Public Static String convetDate(Date dT){
		String dateString;
		if(dT!=null){
			String Year= String.valueof(dT.year());
			String Month=(String.valueof(dT.month())).length()==1?'0'+String.valueof(dT.month()):String.valueof(dT.month());
			String Day=String.valueof(dT.day()).length()==1?'0'+String.valueof(dT.day()):String.valueof(dT.day());
			dateString=Year + Month + Day;
		}
		return dateString;
	}
	/*****************************************************************
	Description: Method to Convert DateTime field value to 'yyyymmddhhmmss.ms' format
	*****************************************************************/
	Public Static String convetDateTimetoSOOFormat(DateTime dT){
		String dateString;
		if(dT!=null){
			String Year= String.valueof(dT.year());
			String hour=(String.valueOf(dT.hour()).length()==1?'0'+String.valueOf(dT.hour()):String.valueOf(dT.hour()));
			String minute=(String.valueOf(dT.minute()).length()==1?'0'+String.valueOf(dT.minute()):String.valueOf(dT.minute()));
			String Second=(String.valueOf(dT.second()).length()==1?'0'+String.valueOf(dT.second()):String.valueOf(dT.second()));
			String MilliSecond=(String.valueOf(dT.millisecond()).length()==3?String.valueOf(dT.millisecond()):String.valueOf(dT.millisecond()).length()==2?'0'+String.valueOf(dT.millisecond()):'00'+String.valueOf(dT.millisecond()));
			String Month=(String.valueof(dT.month())).length()==1?'0'+String.valueof(dT.month()):String.valueof(dT.month());
			String Day=String.valueof(dT.day()).length()==1?'0'+String.valueof(dT.day()):String.valueof(dT.day());
			dateString=Year + Month + Day +'T'+ hour + minute + Second +'.'+ MilliSecond+' GMT';
		}
		return dateString;
	}
   /*****************************************************************
	Description: Method to Convert DateTime field value to GMT 'yyyymmddhhmmss.ms' format
	*****************************************************************/
	Public Static String convetDateTimetoSOOFormatGMT(DateTime dT){
		String dateString;
		if(dT!=null){
			
			Integer InYear= Integer.valueof(dT.yearGmt());
			Integer Inhour=Integer.valueOf(dT.hourGmt());
			Integer Inminute=Integer.valueOf(dT.minuteGmt());
			Integer InSecond= Integer.valueOf(dT.secondGmt());
			Integer InMilliSecond= Integer.valueOf(dT.millisecondGmt());
			Integer InMonth= Integer.valueof(dT.monthGMT());
			Integer InDay= Integer.valueof(dT.dayGmt());
			system.debug('--Year-'+InYear+'-month-'+InMonth+'-day-'+InDay+'-h-'+Inhour+'-min-'+Inminute+'-sec-'+InSecond);
			DateTime dtGm = DateTime.newInstanceGMT(InYear, InMonth, InDay, Inhour,Inminute,InSecond);
			system.debug('-----dt-'+dtGm);
			String Year= String.valueof(InYear);
			String Month=(String.valueof(InMonth)).length()==1?'0'+String.valueof(InMonth):String.valueof(InMonth);
			String Day=String.valueof(InDay).length()==1?'0'+String.valueof(InDay):String.valueof(InDay);
			String hour=(String.valueOf(Inhour).length()==1?'0'+String.valueOf(Inhour):String.valueOf(Inhour));
			String minute=(String.valueOf(Inminute).length()==1?'0'+String.valueOf(Inminute):String.valueOf(Inminute));
			String Second=(String.valueOf(InSecond).length()==1?'0'+String.valueOf(InSecond):String.valueOf(InSecond));
			String MilliSecond=(String.valueOf(InMilliSecond).length()==3?String.valueOf(InMilliSecond):String.valueOf(InMilliSecond).length()==2?'0'+String.valueOf(InMilliSecond):'00'+String.valueOf(InMilliSecond));
			dateString=Year + Month + Day +'T'+ hour + minute + Second +'.'+ MilliSecond+' GMT';
			system.debug('--dateString-'+dateString);
		}
		return dateString;
	}
}