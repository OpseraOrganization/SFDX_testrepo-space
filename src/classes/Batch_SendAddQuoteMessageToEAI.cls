/******************************************************************************************************
Name : Batch_SendAddQuoteMessageToEAI
Created Date: 20 August 2019
Created by: Accenture
Description : This class is for sending callouts to EAI for each Quote staging record created
*********************************************************************************************************/
global class Batch_SendAddQuoteMessageToEAI implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful,Schedulable{
	
	Set<String> quoteNumberSet = new Set<String>();
	Map<String,QTC_ADDQuoteSettings__c> qtcsetting = new Map<String,QTC_ADDQuoteSettings__c>();
	String QTEHEADER_Generic;
	/****************************************
* Name : start
* Description : prepares the data 
* Parameters: Database.BatchableContext
* Returns : List of urls for each staging object
*****************************************/
	public Batch_SendAddQuoteMessageToEAI(Set<String> quoteNumbers)
	{
		quoteNumberSet = quoteNumbers;
	}
	
	 /****************************************
* Name : execute
* Description : schedules the batch class by calling execute Method
* Parameters: SchedulableContext
*****************************************/
	global void execute(SchedulableContext SC)	  
	{
	   // Batch_SendAddQuoteMessageToEAI batch = new Batch_SendAddQuoteMessageToEAI();
	   // Database.executebatch(batch,1);
	}
	
	/****************************************
* Name : start
* Description : prepares the data 
* Parameters: Database.BatchableContext
* Returns : List of urls for each staging object
*****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		try{
			Staticresource sr = [select id,body from Staticresource where name = :GlobalConstants.QTC_ADDQUOTEADD_GENERICHEADER limit 1];
			QTEHEADER_Generic = sr.body.tostring();  
			List<String> xml_RequestArray = new List<String>();
			
			Dom.Document doc = new Dom.Document();
			doc.load(QTEHEADER_Generic);
			Dom.XmlNode rootElement = doc.getRootElement();
			
			DateTime dateValue = system.now();
			//If the field is a date field, then prepare xml structure of DATETIME
			createDateXMLStructure(rootElement,dateValue, 'CREATION');
			QTEHEADER_Generic = doc.toXmlString();
			
			//Get the soap callout details from custom setting
			qtcsetting = QTC_ADDQuoteSettings__c.getAll();
			
			return Database.getQueryLocator([Select id,Quote_Number__c,Request_Data__c,QTEID__c,TASK__c 
											 from Quote_Staging__c 
											 where Quote_Number__c IN:quoteNumberSet 
											 and Type__c=:GlobalConstants.QTE_HEADER]);
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.SendAddQuoteMessage,GlobalConstants.STARTMETHOD);
			return null;
		}
	}
	
	/****************************************
* Name : execute
* Description : Retrieves the data from sales item staging object
* Parameters: Database.BatchableContext, List of Product sales item
* Returns : 
*****************************************/	
	global void execute(Database.BatchableContext BC, List<Quote_Staging__c> QuoteStaging_List)
	{  
		Http http = new Http();
		HttpResponse response;
		HttpRequest soapRequest = new HttpRequest();
		Boolean RETRY_1 = false;
		String xml_Request = '';
		Quote_Staging__c quoteHeader = QuoteStaging_List[0];
		try{
			String xmlReq = QTEHEADER_Generic;
			system.debug(QTEHEADER_Generic);
			xmlReq = xmlReq.replace('<TASK></TASK>', '<TASK>'+quoteHeader.Task__c+'</TASK>');
			xmlReq = xmlReq.replace('<TASK />', '<TASK>'+quoteHeader.Task__c+'</TASK>');
			//xmlReq = xmlReq.replace('<REFERENCEID></REFERENCEID>','<REFERENCEID>'+'a3k56000000QYdC'+'</REFERENCEID>');
			//xmlReq = xmlReq.replace('<REFERENCEID />','<REFERENCEID>'+'a3k56000000QYdC'+'</REFERENCEID>');
			
			
			xml_Request = qtcsetting.get(GlobalConstants.ADDQUOTE003STARTTAG).Value__c + xmlReq + 
				qtcsetting.get(GlobalConstants.ADDQUOTEDATAAREASTARTTAG).Value__c+quoteHeader.Request_Data__c;
			
			//add a loop to iterate through all line items for the quote
			for(Quote_Staging__c quoteLineItem : [select id,Quote_Number__c,Request_Data__c,QTEID__c,DOCUMENTID__c 
												  from Quote_Staging__c
												  Where Type__c != :GlobalConstants.QTE_HEADER
												  And Quote_Number__c = :quoteHeader.Quote_Number__c 
												 order by QTELINENUM__c asc])
			{
				xml_Request = xml_Request + quoteLineItem.Request_Data__c;   
				//find the document id and replace it
		   // xmlReq = xmlReq.replace('<DOCUMENTID></DOCUMENTID>', '<DOCUMENTID>'+quoteLineItem.DOCUMENTID__c+'</DOCUMENTID>');
			//xmlReq = xmlReq.replace('<DOCUMENTID />', '<DOCUMENTID>'+quoteLineItem.DOCUMENTID__c+'</DOCUMENTID>');
			}
			//xml_RequestArray.add(xml_Request);
			xml_Request  = xml_Request.remove(qtcsetting.get(GlobalConstants.XMLTOREMOVE).Value__c);
			xml_Request = xml_Request + qtcsetting.get(GlobalConstants.ADDQUOTEDATAAREAENDTAG).Value__c+qtcsetting.get(GlobalConstants.ADDQUOTE003ENDTAG).Value__c;
			xml_Request = qtcsetting.get(GlobalConstants.SOAPHEADER).Value__c
				+qtcsetting.get(GlobalConstants.SOAPBODYSTARTTAG).Value__c+
				+xml_Request+qtcsetting.get(GlobalConstants.SOAPBODYENDTAG).Value__c;
			
			//Prepare the soap Http Request
			soapRequest.setMethod(qtcsetting.get(GlobalConstants.METHOD).Value__c);
			soapRequest.setEndpoint(system.label.QTC_Order_EAI_Label);
			soapRequest.setHeader(GlobalConstants.SOAPACTION, qtcsetting.get(GlobalConstants.SOAPACTION).Value__c);
			soapRequest.setHeader(GlobalConstants.CONTENTYPE, qtcsetting.get(GlobalConstants.CONTENTYPE).Value__c);
			soapRequest.setHeader(GlobalConstants.ACCEPTENCODING, qtcsetting.get(GlobalConstants.ACCEPTENCODING).Value__c);
			soapRequest.setTimeout(120000); // two-minute time-out
			soapRequest.setClientCertificateName(qtcsetting.get(GlobalConstants.CERTIFICATENAME).Value__c);
			soapRequest.setBody(xml_Request);
			system.debug('soapRequest'+xml_Request);
			
			//send the Http Request
			response = http.send(soapRequest);
			system.debug(response);
			
			String statusMessage;Integer statusCode;
			if(response <> null && response.getStatusCode() == 200)
			{
				statusMessage = 'Status: '+response.getStatusCode()+'\n Message: '+response.getbody();
				createSuccessInterfaceLog(quoteHeader.Quote_Number__c,xml_Request,statusMessage,quoteHeader.Task__c);
				
			}
			else if(response==null || (response!=null && response.getStatusCode() <> 200))
			{
				statusMessage = (response == null ? 'Failed without Response' : response.getbody());
				if(response <> null) statusCode = response.getStatusCode();
				handleExceptionLogs(statusMessage,xml_Request,quoteHeader.Quote_Number__c,quoteHeader.Task__c);
			}
	}catch(Exception ex){
		if(ex.getMessage() == 'Read timed out' && !RETRY_1){
			 RETRY_1 = TRUE;
			//send the Http Request again
			try{
			 response = http.send(soapRequest);
			
			if(response <> null && response.getStatusCode() == 200)
				createSuccessInterfaceLog(quoteHeader.Quote_Number__c,xml_Request,'Status: '+response.getStatusCode()+'\n Message: '+response.getbody(),quoteHeader.Task__c);
				}
			catch(Exception exc){
				handleExceptionLogs(exc.getMessage(),xml_Request,quoteHeader.Quote_Number__c,quoteHeader.Task__c);
			}
				
			}
		else{
			ExceptionHandler.addException(ex,GlobalConstants.SendAddQuoteMessage,GlobalConstants.EXECUTEMETHOD+'AT LINE NUMBER' +EX.getLineNumber());
			handleExceptionLogs(ex.getMessage(),xml_Request,quoteHeader.Quote_Number__c,quoteHeader.Task__c);
		}
	
}
}
	
	
  
	/****************************************
* Name : createSuccessInterfaceLog
* Description : create the inferface log for success response
* Parameters: 
* Returns : 
*****************************************/ 
public static void createSuccessInterfaceLog(String quoteNumber,String xml_Request,String statusMessage,String task)
{
	Interface_Log__c iLog = new Interface_Log__c(Interface_Type__c=GlobalConstants.QTC_Add_Quote_Sync, //create interface type
												 Message_Type__c= GlobalConstants.OUTBOUND,
												 Number_of_Record_Processed__c=1,
												 status__c= GlobalConstants.EQUOTE_STATUS_SUCCESS,
												 Number_of_Records_Success__c = 1,
												 Number_of_Records_Errored__c= 0,
												 Operation_Type__c = GlobalConstants.UPDATE_VALUE,
												 Name='Add Quote '+task+' Message Success for '+ quoteNumber,
												 Interface_Request_Sent__c = xml_Request.length() > 32768 ? xml_Request.subString(0, 32768) : xml_Request,
												 Comment__c= statusMessage.length() > 32768 ? statusMessage.subString(0, 32768) : statusMessage);
	
	Database.insert(iLog,false);
}
	
/****************************************
* Name : createDateXMLStructure
* Description : create the xml structure for Date Element
* Parameters: 
* Returns : 
*****************************************/ 
public static void createDateXMLStructure(Dom.XmlNode rootElement,DateTime dateValue, String targetField)
{
	if(rootElement.getChildElement(Globalconstants.DATETIME_String,null) <> null){
		for(Dom.XmlNode xmlNode : rootElement.getChildElements()){
			if(xmlNode.getName() ==  Globalconstants.DATETIME_String && xmlNode.getAttributeCount() > 0){
				String attValue = xmlNode.getAttributeValue(xmlNode.getAttributeKeyAt(0),null);
				if(attValue == targetField.remove(Globalconstants.UNDERSCORE_C)){
					xmlNode.getChildElement(Globalconstants.YEAR,null).addTextNode(String.valueOf(dateValue.year()));
					xmlNode.getChildElement(Globalconstants.MONTH,null).addTextNode(String.valueOf(dateValue.month()));
					xmlNode.getChildElement(Globalconstants.DAY,null).addTextNode(String.valueOf(dateValue.day()));
					xmlNode.getChildElement(Globalconstants.HOUR,null).addTextNode(String.valueOf(dateValue.hour()));
					xmlNode.getChildElement(Globalconstants.MINUTE,null).addTextNode(String.valueOf(dateValue.minute()));
					xmlNode.getChildElement(Globalconstants.SECOND,null).addTextNode(String.valueOf(dateValue.second()));
					xmlNode.getChildElement(Globalconstants.SUBSECOND,null).addTextNode(String.valueOf(dateValue.millisecond()));
					xmlNode.getChildElement(Globalconstants.TIMEZONE,null).addTextNode(Globalconstants.TRIPLEZERO);
				}
			}
		}
	}
}

/****************************************
* Name : handleExceptionLogs
* Description : method to create interface logs for exceptions
* Parameters: 
* Returns : 
*****************************************/ 
private static void handleExceptionLogs(String message,String interfaceReqSent,String quoteNumber,String task)
{
	try{
		Interface_Log__c iLog = new Interface_Log__c(Interface_Type__c=GlobalConstants.QTC_Add_Quote_Sync, 
													 Message_Type__c=GlobalConstants.OUTBOUND,
													 Number_of_Record_Processed__c=1,
													 status__c=GlobalConstants.FAILURE,
													 Number_of_Records_Success__c = 0,
													 Number_of_Records_Errored__c= 1,
													 Name='Add Quote '+task+' Message Failed for '+quoteNumber,
													 Operation_type__c = Globalconstants.UPDATE_VALUE,
													 Interface_Request_Sent__c = interfaceReqSent.length() > 32768 ? interfaceReqSent.subString(0, 32768) : interfaceReqSent,
													 Comment__c= message);
		
		Database.SaveResult result = Database.insert(iLog,false);
		
	}Catch(Exception ex){
		ExceptionHandler.addException(ex,GlobalConstants.SendAddQuoteMessage,GlobalConstants.HANDLE_EXCEPTIONLOGS);
	}
	
}


/****************************************
* Name : finish
* Description : finish method of batch class 
* Parameters: Database.BatchableContext
* Returns : 
*****************************************/ 
global void finish(Database.BatchableContext BC)
{
	
}
}