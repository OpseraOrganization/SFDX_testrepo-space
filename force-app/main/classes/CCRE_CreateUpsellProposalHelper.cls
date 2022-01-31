/****************************************
 * Class Name : CCRE_CreateUpsellProposalHelper
 * Created Date: 2 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Insert CCRE Upsell Proposal and CCRE Contract Items from input Json request
			  
 *****************************************/
global with sharing class CCRE_CreateUpsellProposalHelper
{
	public static Boolean createRecords;
	public static Boolean isCXMService = false;
	public static RestResponse res;
	public static Map<String, Object> reqMap;
	public static String responseErrorMessage;
	
	/*****************************
	*Method Name: CCRE_UpsertNewProposal
	*Description: This method will process the CCRE JSON Upload
	*Parameters: RestRequest
	*******************************/   
	global static void CCRE_UpsertNewProposal()
	{
	 createRecords = true;
	 
	 Id customerAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.CUSTOMER).getRecordTypeId();
	 Id CCREUpsellRecordType = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.CCRE_RecordType).getRecordTypeId();
	 
	 res = RestContext.response;
	 
	 //Mapping fields on header
			RestRequest req = RestContext.request; // instance to get Request Body
			List<Account> accList;
			
			Savepoint sp = Database.setSavepoint();
		   try{
			InboundRequest requestObj = (InboundRequest)JSON.deserialize(req.requestBody.tostring(), InboundRequest.class);
			
			//ERROR HANDLING
			reqMap = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.tostring());
		   
			Map<String, Object> headerMap = (Map<String, Object>) reqMap.get(CSWXGlobalConstant.header);
		   
			responseErrorMessage = checkForErrors(headerMap, CSWXGlobalConstant.ccre_headerJsonTags, true);
			if(createRecords){
				responseErrorMessage = checkForErrorsInLine(CSWXGlobalConstant.Sales_line_items , CSWXGlobalConstant.ccre_SIJsonTags );
			}  
			if(createRecords){
				responseErrorMessage = checkForErrorsInLine(CSWXGlobalConstant.Product_Info_line_items , CSWXGlobalConstant.ccre_PIJsonTags );
			}  
			if(createRecords){
				responseErrorMessage = checkForErrorsInLine(CSWXGlobalConstant.Service_Invoice_Info_line_items, CSWXGlobalConstant.ccre_SIIJsonTags);
			}
			
			String accountNumber = requestObj.header.account_id;
			if(!String.isBlank(accountNumber) && createRecords == true){
				accList = [select id,recordtype.id,AccountNumber from Account where AccountNumber =: accountNumber and recordtype.id =: customerAccId];		   
			  
				if(accList.isEmpty()){
						responseErrorMessage = CSWXGlobalConstant.unsuccessfulUpload + CSWXGlobalConstant.accNotValid1+accountNumber+CSWXGlobalConstant.accNotValid2; 
						createRecords = false;
				}
			}
			if(responseErrorMessage != null){
				res.responseBody = Blob.valueOf(responseErrorMessage); 
				res.StatusCode = 400;
			}
			
			if(createRecords){
				SWx_Upsell_Proposal__c headerObj = new SWx_Upsell_Proposal__c();
				Date createDate = Date.valueOf(requestObj.header.creation_date);
				//headerObj.Unique_Id__c = requestObj.header.source_id + requestObj.header.file_reference_id;
				headerObj.Analytics_Source__c = requestObj.header.source_id;			
				headerObj.Analytics_File_Refer_ID__c = requestObj.header.file_reference_id;
				headerObj.Proposal_Recommendation_Type__c = requestObj.header.category_Type;
				headerObj.Creation_Date__c = createDate;
				headerObj.P20_Id__c = requestObj.header.P20_ID;
				headerObj.RecordTypeId = CCREUpsellRecordType;
				headerObj.Unweighted_Value__c = requestObj.header.Unweighted_Value;
				headerObj.Sold_To_Party__c = accList[0].id;
			   
				
				if(!accList.isEmpty()){
					headerObj.Account_ID__c = accList[0].id;
				}
		
				if(requestObj.header.dolCurrency !=null){
					headerObj.CurrencyIsoCode = requestObj.header.dolCurrency;
				}
				else{
					headerObj.CurrencyIsoCode = CSWXGlobalConstant.EUR;
				}  
			   
				Database.insert(headerObj);
				
				/*Insert Line Items*/
				List<CCRE_UpSell_LineItem__c> lineItemInstanceList = new list<CCRE_UpSell_LineItem__c>();
				CCRE_UpSell_LineItem__c lineItemInstance = new CCRE_UpSell_LineItem__c();
				
				
				if(requestObj.Sales_line_items != null)
				{
				for(Sales_line_items saleslineItemObj: requestObj.Sales_line_items)
					{ 
							lineItemInstance = new CCRE_UpSell_LineItem__c();
							lineItemInstance.Line_Item_Type__c =CSWXGlobalConstant.salesLineItems;
							lineItemInstance.Service_PCI__c = saleslineItemObj.bundle_id;
							lineItemInstance.Sales_Item_Code__c = saleslineItemObj.sales_item_code;
							lineItemInstance.Upsell_Proposal__c = headerObj.id;
							lineItemInstanceList.add(lineItemInstance);
					}
				}
				   
				if(requestObj.Product_Info_line_items != null)
				{   
				for(Product_Info_line_items prodlineItemObj: requestObj.Product_Info_line_items)
					{
					
					Date m7Date = (prodlineItemObj.M7_date_for_product != null? Date.valueOf(prodlineItemObj.M7_date_for_product): null);
					Date c8Date = (prodlineItemObj.C8_date_for_product_release != null? Date.valueOf(prodlineItemObj.C8_date_for_product_release): null);
					Date c10Date = (prodlineItemObj.C10_date_for_product_release != null? Date.valueOf(prodlineItemObj.C10_date_for_product_release): null);
					
					lineItemInstance = new CCRE_UpSell_LineItem__c();
					
					lineItemInstance.Line_Item_Type__c = CSWXGlobalConstant.Product_Info_line_items;
					lineItemInstance.Info_Type__c = prodlineItemObj.Info_Type;
					lineItemInstance.Product_Family__c = prodlineItemObj.Product_Family;
					lineItemInstance.Product_group__c = prodlineItemObj.Product_group;
				  
					lineItemInstance.Product__c = prodlineItemObj.Product;
					
					lineItemInstance.M7_Date_For_Product__c = m7Date;
					lineItemInstance.C8_Date_For_Product_Release__c = c8Date;
					lineItemInstance.C10_Date_For_Product_Release__c = c10Date;
			   
					lineItemInstance.Product_Release__c = prodlineItemObj.Product_Release;
					lineItemInstance.Contracted_NEs_per_customer__c = prodlineItemObj.Contracted_NEs_per_customer;
					lineItemInstance.Contracted_NEs_Per_Contract__c = prodlineItemObj.Contracted_NEs_per_contract;
					lineItemInstance.Upsell_Proposal__c = headerObj.id;
					lineItemInstanceList.add(lineItemInstance);
					}
				}
				
				if(requestObj.Service_Invoice_Info_line_items != null)
				{
					for(Service_Invoice_Info_line_items srvInvlineItemObj: requestObj.Service_Invoice_Info_line_items)
					{
					lineItemInstance = new CCRE_UpSell_LineItem__c();
					
					lineItemInstance.Line_Item_Type__c = CSWXGlobalConstant.Service_Invoice_Info_line_items;
					lineItemInstance.Attribute_Label__c = srvInvlineItemObj.Attribute_Label;
					lineItemInstance.Attribute_Value__c = srvInvlineItemObj.Attribute_Value;
					lineItemInstance.Attribute_Type__c = srvInvlineItemObj.Attribute_Type;
					lineItemInstance.Attribute_for_customer__c = srvInvlineItemObj.Attribute_for_customer;		  
					lineItemInstance.Upsell_Proposal__c = headerObj.id;
					lineItemInstanceList.add(lineItemInstance);
					}
				 } 
			 
				if(headerObj.id != NULL && !lineItemInstanceList.isEmpty() && lineItemInstanceList!=null){ 
				
					Database.insert(lineItemInstanceList);			  
					res.responseBody = Blob.valueOf(CSWXGlobalConstant.successfulUpload+headerObj.id);
					res.statusCode = 201;
					
				 }
			   }
		   }
			catch(Exception e){
			
				Database.rollback(sp);
				res.responseBody = Blob.valueOf(e.getMessage());
				String errorMsg= e.getMessage();			
			   
				if(errorMsg.contains(CSWXGlobalConstant.jsonError)){ 
					res.responseBody = Blob.valueOf(CSWXGlobalConstant.successfulUpload+e.getMessage());
					res.statusCode = 400;
				}
				else if(errorMsg.contains(CSWXGlobalConstant.uniqueId)){
						res.responseBody = Blob.valueOf(CSWXGlobalConstant.uniqueIdError);
						res.statusCode = 406;
				}
				else{
					res.responseBody = Blob.valueOf(CSWXGlobalConstant.unsuccessfulUpload+e.getMessage());
					res.statusCode = 400;			
				}			
			
	 }
	 
	 }
		   

	
	/*****************************
	*Method Name: checkForErrors
	*Description: This method will check for errors against the defined JSON tags when values are required
	*Parameters: Map<String, Object> , Set<String> , Boolean
	*******************************/  
	public static String checkForErrors(Map<String, Object> jsonMap, Set<String> jsonTags, Boolean isRequired){
		
		String errorMsg;
		Boolean reqdTag;
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
				//Error handling for blank values in mandatory fields
				if((jsonMap.get(valueCheck) == null || String.isBlank(String.valueOf(jsonMap.get(valueCheck)))) &&  reqdTag == true){
					errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+ CSWXGlobalConstant.reqdField ; 
					createRecords = false;
					break;
				}
				if(valueCheck.equals(CSWXGlobalConstant.sourceId) && jsonMap.containsKey(valueCheck) && isCXMService == true){
					String str = String.valueOf(jsonMap.get(valueCheck));
					if(!str.startsWith(CSWXGlobalConstant.AnalyticsSource)){
						errorMsg = CSWXGlobalConstant.unsuccessfulUpload +valueCheck+ CSWXGlobalConstant.startWithCXM ; 
						createRecords = false;
						break;
					}
				}
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
					errorMsg = checkForErrors(lineItemMap, jsonTags, RequiredLineItems);
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
		public List<Product_Info_line_items> Product_Info_line_items;
		public List<Service_Invoice_Info_line_items> Service_Invoice_Info_line_items;
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
	}	   
	/*****************************
	*Class Name: Sales_line_items
	*Description: This class will process the tags of the sales line items
	*******************************/
	global without sharing class Sales_line_items {
		public String bundle_id;
		public String sales_item_code;
	}
	/*****************************
	*Class Name: Product_Info_line_items
	*Description: This class will process the tags of the product info line items
	*******************************/
	global without sharing class Product_Info_line_items {
		public String Info_Type;
		public String Product_Family;
		public String Product_group;
		public String Product;
		public String M7_date_for_product;
		public String C8_date_for_product_release;
		public String C10_date_for_product_release;
		public String Product_Release;
		public Integer Contracted_NEs_per_customer;
		public Integer Contracted_NEs_per_contract;
	}
	/*****************************
	*Class Name: Service_Invoice_Info_line_items
	*Description: This class will process the tags of the service invoise info line items
	*******************************/
	global without sharing class Service_Invoice_Info_line_items {
		public String Attribute_Label;
		public String Attribute_Value;
		public String Attribute_Type;
		public String Attribute_for_customer;
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
	}	   
	/*****************************
	*Class Name: LineItems
	*Description: This class will process the line item tags
	*******************************/
	global without sharing class LineItems{
		//CXM Lines
		public String bundle_id; 
		public String sales_item_code;
		public Integer quantity;
		public string use_case;
	}	
}