/*****************************************************************
Description: Wrapper class to store Parent Case attributes that are being sent to SOO while Cancel from SRM

DATE			AUTHOR	CHANGE
12/04/2019	  Vinod T		 Created
*****************************************************************/
Public without sharing class HWS_CancelParentCase_WRAPPER {
	Public String Status;
	Public String SRMRequestID;
	Public String DateCreated;
	Public String CreatedBy;
	Public String CaseNumber;
	Public String SoldToID;
	Public String Action;
	Public String LogisticNode;
	Public List<HWS_CancelChildCases_WRAPPER> Requestitems;	
	
	Public HWS_CancelParentCase_WRAPPER(Case ParentCase,String actionName) {
		this.SRMRequestID = ParentCase.id;
		this.CaseNumber = ParentCase.CaseNumber;
		this.DateCreated=HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormat(ParentCase.CreatedDate);
		this.CreatedBy= ParentCase.CreatedBy.Name;
		this.Status = ParentCase.Status;		
		//NOKIASC-31236:Added Action parameter,and LogisticNode for SOO Call		
		this.Action=actionName;  
		this.LogisticNode=ParentCase.HWS_LogisticNodeCode__c; 
		//End
		/* if(erpSystem=='P20'){
this.SoldToID=ParentCase.Account.NCP_P20_ID__c;
}else{
this.SoldToID=ParentCase.Account.AccountNumber;
}*/
		this.Requestitems= new List<HWS_CancelChildCases_WRAPPER>();	
	}
	/*****************************************************************
Description: Method to Convert DateTime field value to 'yyyymmddhhmmss.ms' format
****************************************************************
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
*/
}