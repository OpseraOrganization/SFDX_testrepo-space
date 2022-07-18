/****************************************************************
* Class Name : HWS_DamagedPartServiceRequest  (/api/exclusionPartServiceQuoteRequest/ )
* Created Date: 11-11-2021
* Created By:	Eashwar Alluri
* Description : This Class to insert Service Quote and Quote Lineitem .
* Modification Log:
Modified By	 Modified For US#	Modified Date

******************************************************************/
@RestResource(urlMapping='/api/exclusionPartServiceQuoteRequest/*') 
global without sharing class  HWS_DamagedPartServiceRequest {
/*******************************************************
* Method Name : damagedPartRequest 
* Description : returns ResponseBodyWrapper with quote id if success and for failure failure reason
*********************************************************/
@HttpPut
global static ResponseBodyWrapper damagedPartRequest() {
	Savepoint sp; 
	List<HWS_Service_Quote_Line_Item__c> qliList=new  List<HWS_Service_Quote_Line_Item__c>();
	try{		 String requestBody = RestContext.request.requestBody.toString();
	QuoteBodyWrapper kList2 =(QuoteBodyWrapper) System.JSON.deserialize(requestBody,QuoteBodyWrapper.class);
	RequestInfo kList= kList2.RequestInfo; 
	try{
	if(String.isBlank(kList.Action) || String.isBlank(kList.Type) || String.isBlank(kList.RMANumber) || String.isBlank(kList.TransactionId) || (kList.Action!='Create'&&kList.Action!='Modify') || (kList.Type!=HWS_Constants.DPQ && kList.Type!=HWS_Constants.UPQ) ){
	HWS_DamagedPartServiceRequest.createInterfaceLog(kList.Action,HWS_Constants.InvalidMsg1,kList.toString());
	ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'SFQuoteId',HWS_Constants.Failure,HWS_Constants.InvalidMsg1,HWS_Constants.SRM402));
	return rbw;
	}
	List<HWS_Service_Quote__c> sqdata=[select id,HWS_Support_Ticket__c,HWS_Quote_Sent_Date__c,HWS_Quote_Status__c,HWS_Is_Quotable__c,RecordType.DeveloperName from HWS_Service_Quote__c where HWS_RMA_Number__c=:kList.RMANumber limit 1];	   
	if(!sqdata.isEmpty() && kList.Action=='Create'){
	HWS_DamagedPartServiceRequest.createInterfaceLog(kList.Action ,sqdata[0].RecordType.DeveloperName+HWS_Constants.rmaExists,kList.toString());	
	ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,sqdata[0].Id,HWS_Constants.Failure,sqdata[0].RecordType.DeveloperName.replaceAll('_+', ' ')+HWS_Constants.rmaExists,HWS_Constants.SRM402));
	return rbw;					
	}
	sp = Database.setSavepoint();
	List<Case> caseListData=[Select id,Product.ProductCode,Product.Description,HWS_Part_Code__c,HWS_Faulty_Serial_Number__c from Case where HWS_RMA_Number__c=:kList.RMANumber];   
		 if(caseListData.size()>0){
	switch on kList.Type {
	when 'Damaged Part Quote' {		
		switch on kList.Action {
			  when 'Create' {
				if(String.isBlank(kList.SourceSystem)) {
				HWS_DamagedPartServiceRequest.createInterfaceLog(kList.Action ,HWS_Constants.MissingData,kList.toString());		
	  	ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'SFQuoteId',HWS_Constants.Failure,HWS_Constants.MissingData,HWS_Constants.SRM402) );
				return rbw; 
				}
				else {
				HWS_Service_Quote__c squote=createQuote(kList.RMANumber,kList.SourceSystem,kList.ImageReferenceInfo,kList.PartReceivedDate,kList.SerialNumber,kList.PartNumberDescription,kList.TransactionId,kList.PartNumberReceived,kList.Type);
				insert squote;
				for(ExclusionCategories ss:kList.ExclusionCategories){
					 if(String.isBlank(ss.ExclusionCategory) || String.isBlank(ss.RepairableFlag) ){
								Database.RollBack(sp); 
								ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'SFQuoteId',HWS_Constants.Failure,'Atleast one Quote Line Item should Exist',HWS_Constants.SRM402));
					return rbw; 
					
							}
				  HWS_Service_Quote_Line_Item__c qlitem= createServiceQuoteLineItem(ss.ExclusionCategory,ss.RepairableFlag,ss.ExlusionCategoryCode,'',squote.Id);
				qliList.add(qlitem);
				}
				if(!qliList.isEmpty()){		 insert qliList;			 System.debug('Event invoke code');List<Id> quotSet=new List<Id>(); quotSet.add(squote.Id);
			 	CH_Events__e ob = new CH_Events__e(Application_Type__c = 'HWS',sObject_API_Name__c='HWS_Service_Quote__c',sObject_Id__c=String.valueOf(squote.Id) );
	EventBus.publish(ob);					
				ResponseBodyWrapper rbw3=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,squote.Id,HWS_Constants.Success,HWS_Constants.QuoteInserted,HWS_Constants.SRM200));
				return rbw3; 
				}  }  }
				when 'Modify'{
				 ResponseBodyWrapper rbw2=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'SFQuoteId2',HWS_Constants.Failure,HWS_Constants.UpdateNotAllowed,HWS_Constants.SRM402));
				 return rbw2; }
				when else{ //Never executed but added as syntax requirement
				  }}}	
		when 'UnReturned Part Quote' {	
			switch on kList.Action {		
				when 'Create' {
				   if( String.isBlank(kList.SourceSystem)|| String.isBlank(kList.OPTOnProcessStatus) ) {
					HWS_DamagedPartServiceRequest.createInterfaceLog(kList.Action,HWS_Constants.MissingData,kList.toString());		
				ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'SFQuoteId',HWS_Constants.Failure,HWS_Constants.MissingData,HWS_Constants.SRM402));
					return rbw; 
					}
					else {
					   HWS_Service_Quote__c squote=createQuote(kList.RMANumber,kList.SourceSystem,'',kList.PartReceivedDate,'','',kList.TransactionId,'',kList.Type);
					   HWS_Service_Quote_OPT_Status_Mapping__mdt qq=[select id,Label, Is_Suspension_Eligible__c, Is_Quote_Eligible__c,DeveloperName  from HWS_Service_Quote_OPT_Status_Mapping__mdt where Label=:kList.OPTOnProcessStatus];
					   String quotElig=qq.Is_Quote_Eligible__c;
						squote.HWS_OPT_OnProcess_Status__c=qq.DeveloperName;//added for UAT fix
						if(quotElig==HWS_Constants.NO ){  squote.HWS_Is_Quotable__c=HWS_Constants.NO; }//HWSDDP-67
						 insert squote;
						for(ExclusionCategories ss:kList.ExclusionCategories){
							if(String.isBlank(ss.ExclusionCategory) || String.isBlank(ss.RepairableFlag) ){
								Database.RollBack(sp); 
								ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'SFQuoteId',HWS_Constants.Failure,'Atleast one Quote Line Item should Exist',HWS_Constants.SRM402));
					return rbw; 
					
							}
									 HWS_Service_Quote_Line_Item__c qlitem= createServiceQuoteLineItem(ss.ExclusionCategory,ss.RepairableFlag,ss.ExlusionCategoryCode,'',squote.Id);
						qliList.add(qlitem);
					}
					if(!qliList.isEmpty()){		 insert qliList;			 System.debug('Event invoke code');
						CH_Events__e ob = new CH_Events__e(Application_Type__c = 'HWS',sObject_API_Name__c='HWS_Service_Quote__c',sObject_Id__c=String.valueOf(squote.Id));
					EventBus.publish(ob);
					  ResponseWrapper rst3=new ResponseWrapper(kList.TransactionId,kList.RMANumber,squote.Id,HWS_Constants.Success,HWS_Constants.QuoteInserted,HWS_Constants.SRM200);
					  ResponseBodyWrapper rbw3=new ResponseBodyWrapper(rst3);
					  return rbw3; 
					}  } }
								  when 'Modify'{
									 HWS_Service_Quote_OPT_Status_Mapping__mdt qq=[select id,Label, Is_Suspension_Eligible__c, Is_Quote_Eligible__c,DeveloperName  from HWS_Service_Quote_OPT_Status_Mapping__mdt where Label=:kList.OPTOnProcessStatus];
									String quotElig=qq.Is_Quote_Eligible__c;
									  if(sqdata[0].HWS_Quote_Status__c==HWS_Constants.SQ_STATUS_CANCELLED||sqdata[0].HWS_Quote_Status__c==HWS_Constants.SQ_STATUS_COMPLETED || sqdata[0].HWS_Quote_Sent_Date__c!=null) {
						ResponseBodyWrapper rbw2=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,sqdata[0].Id,HWS_Constants.Failure,HWS_Constants.FUNA,HWS_Constants.SRM402));
							return rbw2;
						}
					else if( quotElig==HWS_Constants.YES ||quotElig==HWS_Constants.NO ){
											List<HWS_Service_Quote__c> quotList=new List<HWS_Service_Quote__c>();
						sqdata[0].HWS_Is_Quotable__c=quotElig;
											sqdata[0].HWS_OPT_OnProcess_Status__c=qq.DeveloperName;//added for UATFix 
							quotList.add(sqdata[0]);
								update quotList;
											ResponseBodyWrapper rbw24=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,sqdata[0].Id,HWS_Constants.Success,HWS_Constants.updateSuccess,HWS_Constants.SRM201));
							return rbw24;
					}
					  }
								   when else{ }  }  }when else {	}}
		}
		else
		{
			HWS_DamagedPartServiceRequest.createInterfaceLog(kList.Action,HWS_Constants.invalidRMA,kList.toString());		
	ResponseBodyWrapper rbw=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'QuoteId',HWS_Constants.Failure,HWS_Constants.invalidRMA,HWS_Constants.SRM402));
	return rbw;   
		}
		
		ResponseBodyWrapper rbw24=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'QuoteId',HWS_Constants.Failure,'No Action performed',HWS_Constants.SRM402));
			return rbw24;
		}
			catch(Exception ex){
				Database.RollBack(sp);
			 HWS_DamagedPartServiceRequest.createInterfaceLog(kList.Action ,ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause(),kList.toString());		
			ResponseBodyWrapper rbw4=new ResponseBodyWrapper(new ResponseWrapper(kList.TransactionId,kList.RMANumber,'QuoteId',HWS_Constants.Failure,ex.getLineNumber()+''+ex.getMessage()+''+ex.getCause(),HWS_Constants.SRM402));
			return rbw4; 
		}		}
		catch(Exception ex){
			HWS_DamagedPartServiceRequest.createInterfaceLog('Insert',ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause(),'Deserialization Exception');		
			ResponseBodyWrapper rbw5=new ResponseBodyWrapper(new ResponseWrapper('TransactionId','RMANumber','QuoteId',HWS_Constants.Failure,ex.getLineNumber()+''+ex.getMessage()+''+ex.getCause(),HWS_Constants.SRM402));
			return rbw5;
		}	}
/*******************************************************
* Method Name : createQuote 
* Description : Quote creation common logic returns Quote  
*********************************************************/
public static HWS_Service_Quote__c createQuote(String RMANumber,String SourceSystem,String ImageReferenceInfo,DateTime PartReceivedDate,String SerialNumber,String PartNumberDescription,String TransactionId,String PartNumberReceived,String Type){
			List<Case> caseList=[Select id,Product.ProductCode,Product.Description,HWS_Part_Code__c,HWS_Faulty_Serial_Number__c from Case where HWS_RMA_Number__c=:RMANumber and ParentId!=null];   
			 HWS_Service_Quote__c qs=new HWS_Service_Quote__c(HWS_RMA_Number__c =RMANumber,HWS_Part_Number_Reported__c=caseList[0].HWS_Part_Code__c,HWS_LSP_PartNumber_Received__c =PartNumberReceived,HWS_LSP_Part_Number_Received_Description__c =PartNumberDescription,HWS_LSP_Serial_Number_Received__c =SerialNumber,HWS_LSP_Part_Received_Date__c = PartReceivedDate,HWS_TransactionId__c = TransactionId,HWS_SourceSystem__c = SourceSystem,HWS_ImageReferenceInfo__c = ImageReferenceInfo,
														 CurrencyIsoCode='USD',HWS_Quote_Status__c='Draft');
			String recTypeDevName='';
			if(Type==HWS_Constants.UPQ){
				recTypeDevName = HWS_Constants.HUPQRType;
				qs.HWS_LSP_Serial_Number_Received__c=caseList[0].HWS_Faulty_Serial_Number__c;//adding serial number from case for Unreturned
				qs.HWS_Is_Quotable__c=HWS_Constants.YES;
			}
			else if(Type==HWS_Constants.DPQ){
				recTypeDevName = HWS_Constants.HDPQRType;
			}
			qs.RecordTypeId= Schema.SObjectType.HWS_Service_Quote__c.getRecordTypeInfosByDeveloperName().get(recTypeDevName).getRecordTypeId();
		 qs.HWS_Support_Ticket__c=caseList[0].id;
		 return qs;
		}
/*******************************************************
* Method Name : createServiceQuoteLineItem 
* Description : For QuoteLine Item creation common logic returns QuoteLine Item  
*********************************************************/
public static HWS_Service_Quote_Line_Item__c createServiceQuoteLineItem(String ExclusionCategory,String RepairableFlag,String ExlusionCategoryCode,String Attribute_1,Id parentId){
		HWS_Service_Quote_Line_Item__c qli=new HWS_Service_Quote_Line_Item__c(HWS_Exclusion_Category__c  = ExclusionCategory,HWS_Repairable__c = RepairableFlag,HWS_Exlcusion_Category_Code__c=ExlusionCategoryCode,HWS_Attribute_1__c =Attribute_1,Service_Quote__c = parentId,HWS_Fee_Inclusion__c=true,CurrencyIsoCode='USD' );
			return qli;
}
/*******************************************************
* Method Name : createInterfaceLog 
* Description : For creating interface log during exceptions  
*********************************************************/
public static void createInterfaceLog(String OperationType,String Comment,String DsPayload)
{
		 Interface_Log__c ilog=new Interface_Log__c();
		 ilog.Name='DataHub Log';
		 ilog.Interface_Type__c='DataHub';
		 ilog.Message_Type__c='Inbound';
		 ilog.Operation_Type__c=(OperationType=='Create')?'Insert':'Update';
		 ilog.Status__c='Post Processing Error';
		 ilog.Comment__c=Comment;
		 ilog.DS_Payload__c=DsPayload;
		 insert ilog;
}
global class QuoteBodyWrapper{ RequestInfo RequestInfo{get;set;} }
public RequestInfo RequestInfo;
public List<ExclusionCategories> qlw;
global class RequestInfo{
		String RMANumber {get; set;}
		String PartNumberReceived {get; set;}
		String PartNumberDescription {get; set;}
		String SerialNumber {get; set;}
		DateTime PartReceivedDate {get; set;}
		String Type {get; set;}
		String ImageReferenceInfo {get; set;}
		String TransactionId {get; set;}
		String SourceSystem {get; set;}
		String Action {get; set;}
		String OPTOnProcessStatus{get; set;}
		String OrderCode{get; set;}
		String LSPComments{get; set;}
		public List<ExclusionCategories> ExclusionCategories;
	public RequestInfo(String RMANumber,String PartNumberReceived,String PartNumberDescription,String SerialNumber,DateTime PartReceivedDate,String Type,String TransactionId,String ImageReferenceInfo,String SourceSystem,String Action,String OPTOnProcessStatus,String OrderCode,String LSPComments,List<ExclusionCategories> qlw){
			this.RMANumber=RMANumber;
			this.PartNumberReceived=PartNumberReceived;
			this.PartNumberDescription=PartNumberDescription;
			this.SerialNumber=SerialNumber;
			this.PartReceivedDate=PartReceivedDate;
			this.Type=Type;
			this.TransactionId=TransactionId;
			this.ImageReferenceInfo=ImageReferenceInfo;  
			this.SourceSystem=SourceSystem; 
			this.Action=Action;
			this.OPTOnProcessStatus=OPTOnProcessStatus;
			this.OrderCode=OrderCode;
			this.LSPComments=LSPComments;}	}
global class ExclusionCategories{
		String ExclusionCategory {get; set;}
		String RepairableFlag {get; set;}
		String Attribute_1{get; set;}
		String ExlusionCategoryCode{get; set;}	  
}
global class ResponseBodyWrapper{
		ResponseWrapper response{get; set;}
		public ResponseBodyWrapper(ResponseWrapper response){
			this.response=response;
}  }
global class ResponseWrapper{
		String TransactionId {get; set;}
		String RMANumber {get; set;}
		String SFQuoteId {get; set;}
		String TransactionStatus {get; set;}
		List<SuccessOrErrorWrap> SuccessOrError{get;set;}
		String ErrorMessage {get;set;}
		String ErrorCode{get;set;}
		public ResponseWrapper(String TransactionId,String RMANumber,String SFQuoteId,String Success,String ErrorMessage,String ErrorCode){
			this.TransactionId=TransactionId;
			this.RMANumber=RMANumber;
			this.SFQuoteId=SFQuoteId;
			this.TransactionStatus=Success;
			this.ErrorMessage=ErrorMessage;
			this.ErrorCode=ErrorCode;
			SuccessOrErrorWrap se=new SuccessOrErrorWrap();
			se.Message=ErrorMessage;
			se.Code=ErrorCode;
			List<SuccessOrErrorWrap> SEList=new List<SuccessOrErrorWrap>();
			SEList.add(se);
			this.SuccessOrError=SEList;
		}	}
		global class SuccessOrErrorWrap{
		 String Message {get;set;}
		String Code{get;set;}
	   
	}
}