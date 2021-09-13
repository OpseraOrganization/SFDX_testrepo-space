/******************************************************************************************************
Name : CustomerDocumentContoller
Created Date: 7 July 2019
Created by: Accenture
Description : This class is controller class for change status lightning button on salesforce
*********************************************************************************************************/
public with sharing class CustomerDocumentController {

	
	  /***********************************************
Name : checkValidation
Descritpion: This method is used to get Mandatory fields on customer document
based on Status from Custom Setting 'Customer_Document'. 
Parameter : List<Customer_Document__c> Customer_Document_Vaidation__c
*************************************************/
	@AuraEnabled
	public static String checkValidation(Id recID,String cdstatus){
		String missing_Fields = '',errorText='';
		String status = cdstatus;
		String cdLSoqlFields = '',soqlFields='';
		Set<String> cdLIMandatoryFields = new Set<String>();
		Set<String> cdMandatoryFields = new Set<String>();
		Map<String,String> reqFieldsMap = new Map<String,String>();
		Map<String,List<Customer_Document_Line_Items__c>> custDocLineItemsMap = new Map<String,List<Customer_Document_Line_Items__c>>();
		List<Customer_Document_Line_Items__c> cdlUpdateList = new List<Customer_Document_Line_Items__c>();
		try{
			if(FeatureManagement.checkPermission(CSWXGlobalConstant.CustomerDocumentRegistration) 
			   && !cdstatus.equalsIgnoreCase(CSWXGlobalConstant.CloseCancelled))
			   errorText = 'You are not authorized to select this status';
			
			 if(FeatureManagement.checkPermission(CSWXGlobalConstant.DS_GDC) 
			   && (cdstatus.equalsIgnoreCase(CSWXGlobalConstant.InRegistration) || cdstatus.equalsIgnoreCase(CSWXGlobalConstant.Registered)))
			   errorText = 'You are not authorized to select this status';
			
			
			  
			if(String.isBlank(errorText)){
		   //Collect all validations from custom settings and store it in a map
			for(Mandatory_fields_for_Customer_Document__c cdVal : Mandatory_fields_for_Customer_Document__c.getAll().values()){
				if(cdVal.Mandatory_Fields__c <> null || !String.isBlank(cdVal.Mandatory_Fields__c) ){
					if(cdVal.Classification__c <> null && !String.isBlank(cdVal.Classification__c)){
						if(cdVal.Sub_Classification__c <> null && !String.isBlank(cdVal.Sub_Classification__c)){
							reqFieldsMap.put(cdVal.Object__c+cdVal.Classification__c+cdVal.Sub_Classification__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
						}else{
							reqFieldsMap.put(cdVal.Object__c+cdVal.Classification__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
						}
					}					   
					else if(cdVal.Sub_Classification__c <> null && !String.isBlank(cdVal.Sub_Classification__c)){
						reqFieldsMap.put(cdVal.Object__c+cdVal.Sub_Classification__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
					}
					   else {
						reqFieldsMap.put(cdVal.Object__c+cdVal.Status__c, cdVal.Mandatory_Fields__c);
					}
					if(cdVal.object__c.equalsIgnoreCase(CSWXGlobalConstant.CustomerDocument)){
					cdMandatoryFields.addAll(cdVal.Mandatory_Fields__c.split(','));				   
					}
					if(cdVal.object__c.equalsIgnoreCase(CSWXGlobalConstant.CustomerDocumentLineItems)){
					cdLIMandatoryFields.addAll(cdVal.Mandatory_Fields__c.split(','));				   
					}
				}
			}
	
				if(!cdLIMandatoryFields.isEmpty()) {
					cdLSoqlFields = String.join(new List<String>(cdLIMandatoryFields), ','); 
			
			 String soql = 'Select Id,'+cdLSoqlFields+',Missing_Fields__c,Customer_Document__c'+' from '+CSWXGlobalConstant.CustomerDocumentLineItems+' where Customer_Document__c = \''+recID+'\'';
			System.debug('soql'+soql);
	
				for(Customer_Document_Line_Items__c docLineItems : Database.query(soql))
				{
					if(!custDocLineItemsMap.containsKey(docLineItems.Customer_Document__c))
						custDocLineItemsMap.put(docLineItems.Customer_Document__c, new List<Customer_Document_Line_Items__c>{docLineItems});
					else
						custDocLineItemsMap.get(docLineItems.Customer_Document__c).add(docLineItems);
				}
				}
			
			String Query = 'Select Id';
				if(!cdMandatoryFields.isEmpty()) {
					soqlFields = String.join(new List<String>(cdMandatoryFields), ',');  
					soqlFields = ','+soqlFields;
				}
					
			Query = Query +soqlFields+',status__c From '+CSWXGlobalConstant.CustomerDocument+' Where Id = \''+recID+'\'';
				
			system.debug('Query:'+Query);
	List<Customer_Document__c> custDocList = database.query(query);
			for(Customer_Document__c custDoc :custDocList)
			{
				
				if(FeatureManagement.checkPermission(CSWXGlobalConstant.DS_GDC) && custDoc.status__c.equalsIgnoreCase(CSWXGlobalConstant.CD_Draft)
			   && (cdstatus.equalsIgnoreCase(CSWXGlobalConstant.Closedvalidated) || cdstatus.equalsIgnoreCase(CSWXGlobalConstant.Closedconsumed)
				  || cdstatus.equalsIgnoreCase(CSWXGlobalConstant.Closedrejected)))
			   errorText = 'You are only allowed to change the status from Draft to Close cancelled';
				
				
				String key = ''; 
				Boolean isMandatoryPresent = true;
				if(custDoc.Classification__c <> null && !String.isBlank(custDoc.Classification__c))
					key = custDoc.Classification__c;
				if(custDoc.Sub_Classification__c <> null && !String.isBlank(custDoc.Sub_Classification__c))
					key = key + custDoc.Sub_Classification__c;
				key = key + status;
				custDoc.status__c = status;
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
						errorText = 'These required fields must be filled: '+missing_Fields+'!'; 
						system.debug('errorText>>>>>>'+errorText);
					}
				
				  //logic for checking validation on line items
					String cdlmandatoryFields = reqFieldsMap.get(CSWXGlobalConstant.CustomerDocumentLineItems+key) ;  
					
					if(cdlmandatoryFields <> null){
						List<String> cdlmandatoryFieldsList = cdlmandatoryFields.split(GlobalConstants.COMMA);
						system.debug('cdlmandatoryFieldsList'+cdlmandatoryFieldsList);
						if(custDocLineItemsMap.get(custDoc.Id) <> null){
							
							for(Customer_Document_Line_Items__c custDocLineItem : custDocLineItemsMap.get(custDoc.Id))
							{
								String cdlMissingFields ='';
								for(String field : cdlmandatoryFieldsList){
									if(custDocLineItem.get(field) == null || custDocLineItem.get(field) == '')
									{
										cdlMissingFields = cdlMissingFields + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CustomerDocumentLineItems).getDescribe().fields.getMap().get(field).getDescribe().getLabel() + CSWXGlobalConstant.comma;
										isMandatoryPresent = false;
									}
								}
								cdlMissingFields = cdlMissingFields.removeEnd(',');
								system.debug('cdlMissingFields'+cdlMissingFields);
								if(cdlMissingFields != custDocLineItem.Missing_Fields__c)
								{	custDocLineItem.Missing_Fields__c = cdlMissingFields;
								cdlUpdateList.add(custDocLineItem);
								system.debug('cdlUpdateList'+cdlUpdateList);
								}					
							}
							if(!isMandatoryPresent){
								if(String.isBlank(errorText)) errorText = 'Please check missing fields in line Items section';
								else
							   errorText = errorText + '\nPlease check missing fields in line Items section';
							}
						}
					}
			}
			if(!cdlUpdateList.isEmpty()) Database.update(cdlUpdateList,false);
			if(String.isBlank(errorText)) update custDocList;//Database.update(custDocList,false);
		}
		  }catch(Exception ex){
			  if(ex.getMessage().contains(GlobalConstants.VALIDATION)){
					//catching error in error field due to Validation
					errorText = ex.getMessage().Split(GlobalConstants.VALIDATION_EXCEPTION)[1];
				}
				if(ex.getMessage().contains(GlobalConstants.MIXED_DML)){
					//catching error in error field due to Mixed DML Exception
					errorText = ex.getMessage().Split(GlobalConstants.MIXED_DML + GlobalConstants.COMMA)[1];
				}
				if(ex.getMessage().contains(GlobalConstants.DMLEXCEPTION)){
					//catching error in error field due to DML Exception
					errorText = ex.getMessage().Split(GlobalConstants.SYSTEM_DML)[1];
				}
				if(ex.getMessage().contains(GlobalConstants.REQUIRED_FILED_MISSING)){
					//catching error in error field due to Required  Exception
					errorText = ex.getMessage().Split(GlobalConstants.REQUIRED_FILED_MISSING + GlobalConstants.COMMA)[1];
				}
			  errorText = errorText.remove('[]');
			  errorText = errorText.remove(':');
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CustomerDocumentController ,CSWXGlobalConstant.CheckValidation);
		}		
		return errorText;
	}
	
	
	@AuraEnabled
	public static List < String > getselectOptions(sObject objObject, string fld) {
		system.debug('objObject --->' + objObject);
		system.debug('fld --->' + fld);
		List < String > allOpts = new list < String > ();
		// Get the object type of the SObject.
		try{
		Schema.sObjectType objType = objObject.getSObjectType();
		
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		
		// Get a map of fields for the SObject
		map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
		
		// Get the list of picklist values for this field.
		list < Schema.PicklistEntry > values =
			fieldMap.get(fld).getDescribe().getPickListValues();
		
		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a: values) {
			allOpts.add(a.getValue());
		}
		system.debug('allOpts ---->' + allOpts);
		//allOpts.sort();
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CustomerDocumentController ,CSWXGlobalConstant.getselectOptions);
		}
		return allOpts;
	}
}