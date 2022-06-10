/****************************************
 * Class Name : DS_StagingHelper
 * Created Date: 20 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Insert SWX Upsell Proposal and SWX Contract Items from input Json request
*/
global with sharing class DS_StagingHelper
{
	public static Boolean createRecords;
	public static Boolean isCXMService = false;
	
	public static RestResponse res;
	public static Map<String, Object> reqMap;
	public static String responseErrorMessage;


	/*****************************
	*Method Name: insertInterfaceLog
	*Description: This method will insert a record in interface obj on json upload from robot
	*Parameters: String reqmsg,String statusmsg,String jsontext
	 *******************************/  
	public static Id insertInterfaceLog(String reqmsg,String statusmsg,String jsontext){
	   try{
		   
	   Interface_Log__c log = new Interface_Log__c();
		  if(!String.isBlank(reqmsg)){ 
		 }
		log.Message_Type__c =CSWXGlobalConstant.messgaeType ;
		log.Interface_Type__c = CSWXGlobalConstant.DS;
		if(!String.isBlank(statusmsg)){
					log.Status__c = statusmsg;
		 }
		 if(!String.isBlank(jsontext)){
					log.DS_Payload__c=jsontext;
		 }
		 log.Operation_Type__c = CSWXGlobalConstant.optionType;
		 insert log;
		 return log.id;
				
		 }catch(Exception e){
				ExceptionHandler.addException(e, CSWXGlobalConstant.createDSStagingHelper,CSWXGlobalConstant.insertInterfaceLog);
				return null;
		  }
	}
		
	/*****************************
	*Method Name: insertDSStaging
	 *Description: This method will insert json struct in staging obj coming from robot.
	 *******************************/  
	public static DS_Staging__c  insertDSStaging(String jsontext , String statusmsg, Id logId){
		try{
		   DS_Staging__c dsstag = new DS_Staging__c();
		   if(!String.isBlank(jsontext)){ 
					dsstag.DS_Payload__c=jsontext ;
			}
		   if(!String.isBlank(statusmsg)){ 
			   dsstag.Payload_Status__c=statusmsg;
			}
			if(logId !=null){
				dsstag.Interface_Log__c = logId;
			 }
			 insert dsstag;
			 return dsstag;
			}catch(Exception e){
				ExceptionHandler.addException(e, CSWXGlobalConstant.createDSStagingHelper,CSWXGlobalConstant.insertDSStaging);
					return null;
			 }

	 }
	/*****************************
	 *Method Name: UpsertProposal
	 *Description: This method will process the SWx JSON Upload
	 *Parameters: RestRequest
	 *******************************/   
	global static void UpsertSWXDSStaging(){
		//Customer Account record type id in order to avoid accountNumber blank value
		Id customerAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.LEGAL_ENTITY).getRecordTypeId();
		createRecords = true;
		//Id SWxUpsellRecordType = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.SWX_RecordType).getRecordTypeId();
		isCXMService = true;
		//SWx_Upsell_Proposal__c headerObj = new SWx_Upsell_Proposal__c();
		// instance to get Request Body
			RestRequest req = RestContext.request; 
		 res = RestContext.response;
		 DS_Staging__c  dsstag;
		//DS_Staging__c  dsstagtoUpdate;
		id logId;
		//List<SWx_Upsell_Items__c> insertLines = new List<SWx_Upsell_Items__c>();
		Savepoint sp = Database.setSavepoint();
		try{
			
			Inbound_Request requestObj = (Inbound_Request)JSON.deserialize(req.requestBody.tostring(), Inbound_Request.class);
			System.debug('requestObj --->'+requestObj);
			reqMap = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.tostring());
			Map<String, Object> headerMap = (Map<String, Object>) reqMap.get(CSWXGlobalConstant.header);
			
			System.debug('headerMap --->'+headerMap);
			
			responseErrorMessage = checkForErrors(headerMap, CSWXGlobalConstant.swx_headerJsonTags, true ,true);
			if(createRecords){
				responseErrorMessage = checkForErrorsInLine(CSWXGlobalConstant.line_items , CSWXGlobalConstant.swx_Lines_JsonTags);
			}
			
			//json syntax error  
			if(responseErrorMessage != null){
				
		   
			  logId = insertInterfaceLog(responseErrorMessage,CSWXGlobalConstant.Failure ,req.requestBody.tostring());
			  if(logId != null){
				  dsstag = insertDSStaging(req.requestBody.tostring(),CSWXGlobalConstant.Failure,logId);
			  }
				res.responseBody = Blob.valueOf(responseErrorMessage); 
				res.StatusCode = 400;
			}
	   
			List<LineItems> reqLines = requestObj.line_items;
		 
			String accountNumber = requestObj.header.account_id;
		  
			List<Account> accList = [select id,ParentId,OwnerId,recordtype.id,AccountNumber from Account where AccountNumber =: accountNumber and recordtype.id =: customerAccId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			//Account related error
			if(accList.isEmpty() && createRecords == true){
		   
				 res.responseBody = Blob.valueOf(CSWXGlobalConstant.unsuccessfulUpload + CSWXGlobalConstant.accNotValid1+accountNumber+CSWXGlobalConstant.accNotValid2); 
				 res.StatusCode = 400; 
				 createRecords = false;

				
				logId = insertInterfaceLog(CSWXGlobalConstant.unsuccessfulUpload + CSWXGlobalConstant.accNotValid1+accountNumber+CSWXGlobalConstant.accNotValid2,CSWXGlobalConstant.Failure,req.requestBody.tostring());
				if(logId != null){
					dsstag = insertDSStaging(req.requestBody.tostring(),CSWXGlobalConstant.Failure,logId);
				}
				
			}
			
			//Success full upload
			if(createRecords){
			 logId = insertInterfaceLog(CSWXGlobalConstant.successfulUpload,CSWXGlobalConstant.Success ,req.requestBody.tostring());
			  if(logId != null){
				   dsstag = insertDSStaging(req.requestBody.tostring(),CSWXGlobalConstant.Success,logId);
			   }
			  if(dsstag.Payload_Status__c ==CSWXGlobalConstant.Success){
				 DS_StagingObjParsing updateJob = new DS_StagingObjParsing(req.requestBody.tostring(), dsstag,accList[0].id,accList[0].ParentId);
				
				 ID jobID = System.enqueueJob(updateJob); 
				 res.responseBody = Blob.valueOf(CSWXGlobalConstant.successfulUpload+ dsstag.id);
				 res.statusCode = 201;
			   }
			}
		}
		catch(Exception e){
			   Database.rollback(sp);
				String errorMsg= e.getMessage();  
				String interfaceLogMsg ;
				if(errorMsg.contains(CSWXGlobalConstant.jsonError)){ 
					interfaceLogMsg = CSWXGlobalConstant.unsuccessfulUpload + e.getMessage() ;
					
					res.responseBody = Blob.valueOf(CSWXGlobalConstant.unsuccessfulUpload + e.getMessage());
					res.statusCode = 400;
				}
				else{
					 interfaceLogMsg = CSWXGlobalConstant.unsuccessfulUpload +e.getMessage() ;
					 res.responseBody = Blob.valueOf(CSWXGlobalConstant.unsuccessfulUpload +CSWXGlobalConstant.quantityMsg +e.getMessage());
					 res.statusCode = 400;			
				} 
				
				logId = insertInterfaceLog(interfaceLogMsg  + e.getMessage(),CSWXGlobalConstant.Failure,req.requestBody.tostring());
				if(logId != null){
					dsstag = insertDSStaging(req.requestBody.tostring(),CSWXGlobalConstant.Failure,logId);		   
				}
			   
				ExceptionHandler.addException(e, CSWXGlobalConstant.SWX_CreateUpsellProposal , CSWXGlobalConstant.UpsertProposal) ;
		   
		  }
	}
	
	
	 Static Set<String> useCase1 = new set<String>();
	 static String []sourceId;
/*****************************
	*Method Name: checkForErrors
	*Description: This method will check for errors against the defined JSON tags when values are required
	*Parameters: Map<String, Object> , Set<String> , Boolean
	*******************************/  
	public static String checkForErrors(Map<String, Object> jsonMap, Set<String> jsonTags, Boolean isRequired,Boolean isHeader){
		
		String errorMsg;
		Boolean reqdTag;
		
		Set<String> useCasepickListValuesList= new Set<String>();
		Set<String> TechpickListValuesList= new Set<String>();
		
		useCasepickListValuesList.add(CSWXGlobalConstant.Blank);
		TechpickListValuesList.add(CSWXGlobalConstant.Blank);
		
		Schema.DescribeFieldResult fieldResult = SWx_Upsell_Proposal__c.Use_Case__c.getDescribe();
		Schema.DescribeFieldResult fieldResult2 = SWx_Upsell_Proposal__c.Technology__c.getDescribe();
		
		List<Schema.PicklistEntry> UseCaseValues = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickVal : UseCaseValues){
			useCasepickListValuesList.add(pickVal.getLabel());
		}
		   System.debug('>>>>>>>.'+useCasepickListValuesList);
		
		List<Schema.PicklistEntry> TechnologyValues = fieldResult2.getPicklistValues();
		for( Schema.PicklistEntry pickVal : TechnologyValues){
			TechpickListValuesList.add(pickVal.getLabel());
		}
		   System.debug('>>>>>>>.'+TechpickListValuesList);   
		   
		   
		
		try{
		
		for(String valueCheck: jsonMap.keyset()){
			reqdTag = isRequired;
			if(createRecords){
				//Error handling for correct JSON tags
				if(!jsonTags.contains(valueCheck)){
					errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+ CSWXGlobalConstant.invalidJsonTag;  
					createRecords = false;
					break;
				}
				//logic for May Release - Standalone Products
				if(valueCheck.equals(CSWXGlobalConstant.bundle_id)){
					reqdTag = false;
				}
			   
				 if(valueCheck.equals(CSWXGlobalConstant.use_case)){
				 
					reqdTag = false;
				 }
				
				 if(valueCheck.equals(CSWXGlobalConstant.category_Type) && !String.isBlank(jsonMap.get(CSWXGlobalConstant.category_Type).toString()) && isHeader== true){
					 if(!CSWXGlobalConstant.category_TypeSet.contains(jsonMap.get(CSWXGlobalConstant.category_Type).toString())){
						 errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+CSWXGlobalConstant.restrictedPicklist ; 
						 createRecords = false;
						 break;
					 }else{
						  if(String.isBlank(jsonMap.get(CSWXGlobalConstant.category_Type).toString()) ){
						  errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+ CSWXGlobalConstant.reqdField ; 
						  createRecords = false;
						  break;
						  }
					}
				 
				 }

				 
				//Error handling for blank values in mandatory fields
				if((jsonMap.get(valueCheck) == null|| jsonMap.get(valueCheck) == CSWXGlobalConstant.Blank || String.isBlank(String.valueOf(jsonMap.get(valueCheck)))) &&  reqdTag == true){
					errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+ CSWXGlobalConstant.reqdField ; 
					createRecords = false;
					break;
				}
			   
				if(valueCheck.equals(CSWXGlobalConstant.sourceId) && jsonMap.containsKey(valueCheck) && isCXMService == true){
					String str = String.valueOf(jsonMap.get(valueCheck));
					// source id should start with cxm OR RMP
					if((!str.startsWith(CSWXGlobalConstant.AnalyticsSource)) && (!str.startsWith(CSWXGlobalConstant.SourceID_RMP))){
						errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+ CSWXGlobalConstant.startWithCXM ; 
						createRecords = false;
						break;
					}
					
					if((str.startsWith(CSWXGlobalConstant.AnalyticsSource) || str.startsWith(CSWXGlobalConstant.SourceID_RMP)) && isHeader == true){
						sourceId =str.split(CSWXGlobalConstant.dash);
						//Technology should be correct
					 
						if((sourceId.size()>=3 && !TechpickListValuesList.contains(sourceId[1]))  ){
							errorMsg = CSWXGlobalConstant.TechTest+CSWXGlobalConstant.techError; 
							createRecords = false;
							break;
						 }
						 
					}
				}
			   
			   
				  /*   //technology and usecase combination
					if(valueCheck.equals(CSWXGlobalConstant.use_case) && jsonMap.containsKey(CSWXGlobalConstant.use_case) &&  isCXMService == true){
						useCase1.add(jsonMap.get(CSWXGlobalConstant.use_case).toString());
						
						if(useCasepickListValuesList.contains(jsonMap.get(CSWXGlobalConstant.use_case).toString())){
				   
						   if(useCase1.contains(CSWXGlobalConstant.Blank)){
							   useCase1.remove(CSWXGlobalConstant.Blank);
						   }

						   
						 if((String.isBlank(sourceId[1]) && useCase1.size()>0) || (useCase1.size()>0 && sourceId.size()==2) ){
							errorMsg = CSWXGlobalConstant.unsuccessfulUpload+ CSWXGlobalConstant.techusecasecombination;
							createRecords = CSWXGlobalConstant.FalseVal;
							break;
						 }
						  String str = String.valueOf(jsonMap.get(valueCheck));
						
						  if(sourceId.size()==2 && str.right(1)== CSWXGlobalConstant.dash && !TechpickListValuesList.contains(sourceId[1]) && useCase1.size()>0) {
						 
							 errorMsg = CSWXGlobalConstant.unsuccessfulUpload+ CSWXGlobalConstant.techusecasecombination;
							createRecords = CSWXGlobalConstant.FalseVal;
							break;
						 
						 }
						  
						 
						 }
						 else{
				  
					  errorMsg = CSWXGlobalConstant.unsuccessfulUpload + valueCheck+ CSWXGlobalConstant.usecaseError; 
							createRecords = false;
							break;
				  }	 
					  }  */
			}
		}
		}
		catch(Exception e){
			ExceptionHandler.addException(e, CSWXGlobalConstant.CCRE_CreateUpsellProposalHelper,CSWXGlobalConstant.checkForErrors);
		}
		return errorMsg;
	}
	
	/*****************************
	*Method Name: checkForErrorsInLine
	*Description: This method will check for errors for each line item List from Untyped JSON parse
	*Parameters: String , Set<String> 
	*******************************/  
	public static String checkForErrorsInLine(String getKeyList, Set<String> jsonTags){
	
		Boolean RequiredLineItems = true; 
		if(getKeyList == CSWXGlobalConstant.Product_Info_line_items || getKeyList == CSWXGlobalConstant.Service_Invoice_Info_line_items){
			RequiredLineItems = false;
		}
		String errorMsg;
		try{
		List<Object> lineItems = (List<Object>) reqMap.get(getKeyList);
				Map<String, Object> lineItemMap = new Map<String, Object>();
				for(Object lineObj: lineItems){
					lineItemMap = (Map<String, Object>)lineObj;
					errorMsg = checkForErrors(lineItemMap, jsonTags, RequiredLineItems,false);
					lineItemMap=null;
					if(errorMsg != null){
						createRecords = false;
						break;
					}
				}
		}
		catch(Exception e){
			ExceptionHandler.addException(e, CSWXGlobalConstant.CCRE_CreateUpsellProposalHelper,CSWXGlobalConstant.checkForErrorsInLine);
		}
		return errorMsg;
	}
	
	/*****************************
	*Class Name: InboundRequest
	*Description: This class will process the SWx line items
	*******************************/  
	global without sharing class InboundRequest
	{
		SWx_Upsell_Proposal header;
		public List<Sales_line_items> sales_line_items;
		
	}
	
	/*****************************
	*Class Name: SWx_Upsell_Proposal
	*Description: This class will process the tags of the header Json file
	*******************************/
	global without sharing class SWx_Upsell_Proposal{
		public String source_id;
		public String file_reference_id;
		public String account_id;
		Public String strcreation_date;
		public String creation_date;
		public String category_Type;
		public Integer P20_ID;
		public String dolCurrency;
		public Decimal Unweighted_Value;
		//DSI-985
		public Integer cell_quantity;
		Public Integer scope;
	}
		   
	/*****************************
	*Class Name: Sales_line_items
	*Description: This class will process the tags of the sales line items
	*******************************/
	global without sharing class Sales_line_items {
		public String bundle_id;
		public String sales_item_code;
		public string use_case;
	}
	/*****************************
	*Class Name: Inbound_Request
	*Description: This class will process the header & line items
	*******************************/
	 global without sharing class Inbound_Request{
		public SWxUpsellProposal header{get;set;}
		public List<LineItems> line_items;
	}
	
	/*****************************
	*Class Name: SWxUpsellProposal
	*Description: This class will process the header tags
	*******************************/
	global without sharing class SWxUpsellProposal{
		public String source_id;
		public String category_Type;
		public String account_id {get;set;}
		public String file_reference_id;
		public String creation_date;
		public String start_date;
		public String end_date; 
		//DSI-985
		public Integer cell_quantity;
		Public Integer scope;
	} 
		  
	/*****************************
	*Class Name: LineItems
	*Description: This class will process the line item tags
	*******************************/
	global without sharing class LineItems{
		//CXM Lines
		public String bundle_id; 
		public String sales_item_code;
		public string use_case;
		public Integer quantity;
		
	}	
}