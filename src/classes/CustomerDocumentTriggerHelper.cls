/******************************************************************************************************
Name : CustomerDocumentTriggerHelper
Created Date: 7 July 2019
Created by: Accenture
Description : This class is a handler class for customerDocumentTrigger
*********************************************************************************************************/
public class CustomerDocumentTriggerHelper{
	
	/***********************************************
Name : checkValidation
Descritpion: This method is used to get Mandatory fields on customer document
based on Status from Custom Setting 'Customer_Document'. 
Parameter : List<Customer_Document__c>,Set<Id>
*************************************************/
	public static void checkValidation(List<Customer_Document__c> custDocList,Set<Id> customerDocSet){
		try{
			String soqlFields = '';
			String cdLSoqlFields = '';
			Set<String> cdLIMandatoryFields = new Set<String>();
			Map<String,String> reqFieldsMap = new Map<String,String>();
			Map<String,List<Customer_Document_Line_Items__c>> custDocLineItemsMap = new Map<String,List<Customer_Document_Line_Items__c>>();
			
			//Collect all validations from custom settings and store it in a map
			for(Mandatory_fields_for_Customer_Document__c cdVal : Mandatory_fields_for_Customer_Document__c.getAll().values()){				   
					if(cdVal.Mandatory_Fields__c <> null && !String.isBlank(cdVal.Mandatory_Fields__c) ) {
						
						if(cdVal.Classification__c <> null && !String.isBlank(cdVal.Classification__c)){
							if(cdVal.Sub_Classification__c <> null && !String.isBlank(cdVal.Sub_Classification__c)){
								reqFieldsMap.put(cdVal.Object__c+cdVal.Classification__c+cdVal.Sub_Classification__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
							}else{
								reqFieldsMap.put(cdVal.Object__c+cdVal.Classification__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
							}
						}		
						
						else if(cdVal.Sub_Classification__c <> null && !String.isBlank(cdVal.Sub_Classification__c)){
							reqFieldsMap.put(cdVal.Object__c+cdVal.Sub_Classification__c+cdVal.Status__c,
											 cdVal.Mandatory_Fields__c);
						}
						else {
							reqFieldsMap.put(cdVal.Object__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
						}
						
						
					}
					if(cdVal.object__c.equalsIgnoreCase(CSWXGlobalConstant.CustomerDocumentLineItems)){
						cdLIMandatoryFields.addAll(cdVal.Mandatory_Fields__c.split(','));	   
					}
			}
			
			System.debug('reqFieldsMap>>>>>> ' +reqFieldsMap);
			//Collect all line items for the customer document
			if(customerDocSet <> null && (!cdLIMandatoryFields.isEmpty())){				
	cdLSoqlFields = String.join(new List<String>(cdLIMandatoryFields), ','); 
	
	String soql = CSWXGlobalConstant.CD_SelectString +cdLSoqlFields+CSWXGlobalConstant.CD_MissingFields+CSWXGlobalConstant.CD_From+CSWXGlobalConstant.CustomerDocumentLineItems+' where Customer_Document__c in :customerDocSet';
	System.debug('soql'+soql);
	
	for(Customer_Document_Line_Items__c docLineItems : Database.query(soql))
	{
		if(!custDocLineItemsMap.containsKey(docLineItems.Customer_Document__c))
			custDocLineItemsMap.put(docLineItems.Customer_Document__c, new List<Customer_Document_Line_Items__c>{docLineItems});
		else
			custDocLineItemsMap.get(docLineItems.Customer_Document__c).add(docLineItems);
	}
	system.debug('CDLI'+custDocLineItemsMap);
			}	
						   
			for(Customer_Document__c custDoc :custDocList)
			{
				System.debug('custDoc>>>>>' + custDoc.Status__c);
				
				String key = '', missing_Fields = ''; String errorText = '';
				Boolean isMandatoryPresent = true;
				if(custDoc.Classification__c <> null && !String.isBlank(custDoc.Classification__c))
					key = custDoc.Classification__c;
				if(custDoc.Sub_Classification__c <> null && !String.isBlank(custDoc.Sub_Classification__c))
					key = key + custDoc.Sub_Classification__c;
				key = key + custDoc.status__c;
				System.debug('key-------'+key);
				String mandatoryFields = reqFieldsMap.get(CSWXGlobalConstant.CustomerDocument+key) ;  
				
				if(mandatoryFields <> null){
					List<String> mandatoryFieldsList = mandatoryFields.split(GlobalConstants.COMMA);
					for(String field : mandatoryFieldsList){
						if(custDoc.get(field) == null || custDoc.get(field) == '')
						{
							missing_Fields = missing_Fields + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CustomerDocument).getDescribe().fields.getMap().get(field).getDescribe().getLabel() + CSWXGlobalConstant.comma;
						}
					}
					missing_Fields = missing_Fields.removeEnd(',');
				}
				System.debug('missing_Fields>>>>>>'+missing_Fields);
				
				//Throw error if fields are missing on header level
				if(!String.isBlank(missing_Fields)){
					errorText = 'These required fields must be filled: '+missing_Fields;
					if(custDoc.Customer__c != NULL && custDoc.Customer_Document_ID__c != NULL){
			custDoc.addError(errorText); 
					}				
				}
							
				//logic for checking validation on line items
				String cdlmandatoryFields = reqFieldsMap.get(CSWXGlobalConstant.CustomerDocumentLineItems+key) ;  
				String cdlMissingFields ='';
				if(cdlmandatoryFields <> null){
					List<String> cdlmandatoryFieldsList = cdlmandatoryFields.split(GlobalConstants.COMMA);
					system.debug('cdlmandatoryFieldsList'+cdlmandatoryFieldsList);
					if(custDocLineItemsMap.get(custDoc.Id) <> null){
						
						for(Customer_Document_Line_Items__c custDocLineItem : custDocLineItemsMap.get(custDoc.Id))
						{
							for(String field : cdlmandatoryFieldsList){
								if(custDocLineItem.get(field) == null || custDocLineItem.get(field) == '')
								{
									cdlMissingFields = cdlMissingFields + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CustomerDocumentLineItems).getDescribe().fields.getMap().get(field).getDescribe().getLabel() + CSWXGlobalConstant.comma;
									isMandatoryPresent = false;
								}
							}
							cdlMissingFields = cdlMissingFields.removeEnd(',');
						}
						if(!isMandatoryPresent){
							custDoc.addError('Please update these missing fields on the related Line Items: '+cdlMissingFields);
						}
					}
				}  
			}
			
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CustomerDocumentTriggerHelper ,CSWXGlobalConstant.CheckValidation);
		}		
	}
	
	
}