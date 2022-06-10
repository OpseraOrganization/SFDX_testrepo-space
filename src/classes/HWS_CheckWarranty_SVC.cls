/*****************************************************************
@description:   
This class is invoked from Flow named HWS_CheckWarranty_Version_1.4
Input values 
 - MaterialCode 
 - SerialNumber
 - Customer Number
OutPut values
 -WarrantyCheck Status

History		 
DATE		 AUTHOR  Change
11/13/2018   Nikita Jain	  Created
*****************************************************************/
Public without sharing Class HWS_CheckWarranty_SVC {
	
	/*****************************************************************
	description: Gets the List of values from Flow warranty check form

	@param: List of FlowInput
	@return:  List of FlowOutput
	Throws [Exceptions]: [optional] 
	History		 
	DATE	 AUTHOR  Change
	11/13/2018   Nikita Jain	Created
	*****************************************************************/
	@InvocableMethod(label='Invoke Check Warranty Service')
	Public Static List<FlowOutput> hwsSucessfulSubmission(List<FlowInput> requests) 
	{
		List<FlowOutput> results=new List<FlowOutput>();
		for(FlowInput request:requests)
		{
			results.add(hwsSucessfulSubmissionLocal(request));
		}   
		return results;
	}
	
	 /*****************************************************************
	@description: Calls the HWS_SendWarrantyCheckRequesttoSOO class to check the
	Warranty status of item with given Material Code,Serial Number, Customer Number and Source System. 
	@param:FlowInput[MaterialCode,SerialNumber,CustomerNumber,SourceSystem]
	@return:  FlowOutput[isWarranty]
	Throws [Exceptions]: [optional] 
	History		 
	DATE	 AUTHOR  Change
	11/13/2018   Nikita Jain	Created
	*****************************************************************/
	Public Static FlowOutput hwsSucessfulSubmissionLocal(FlowInput request)
	{
		String materialNumber = request.MaterialCode;
		materialNumber = materialNumber.trim();
		String serialNumber = request.SerialNumber;
		serialNumber = serialNumber.trim();
		String customerNumber = request.CustomerNumber;
		//NOKIASC-35005
		String custSetting = HWS_GenericSettings__c.getValues('HWS_EnableWarrantyCheck').HWS_Field1__c;
		//NOKIASC-35005
		Boolean flowRequest = true;
		FlowOutput objFlowOutput = new FlowOutput();
		
		if(materialNumber != '' && materialNumber != null){
			List<Product2> prodPartCodelist = new List<Product2>();
			// NOKIASC-35932 | 12-May-2021 | Start
			List<HWS_VersionItem__c> prodVersionItemPartCodelist = new List<HWS_VersionItem__c>();
			string sSourceSystem = '';
			prodPartCodelist = [SELECT Id, ProductCode, HWS_NSNPartCode__c, RecordTypeId, ExternalId,HWS_PumaSourceSystem__c FROM Product2 WHERE HWS_NSNPartCode__c = :materialNumber];
			prodVersionItemPartCodelist = [SELECT Id, HWS_NSNCode__c,HWS_Source__c FROM HWS_VersionItem__c WHERE HWS_NSNCode__c = :materialNumber];
			if(prodVersionItemPartCodelist.size()> 0 ){
	sSourceSystem = prodVersionItemPartCodelist[0].HWS_Source__c;	 
			} else if(prodPartCodelist.size() > 0) {
	sSourceSystem = prodPartCodelist[0].HWS_PumaSourceSystem__c;
			}
			if(prodPartCodelist.size() > 0 || prodVersionItemPartCodelist.size() > 0){
				ChildDetails childDetailsrequest = new ChildDetails();				  
				String sourceSystem;
				if (sSourceSystem=='PUMA1'){
					sourceSystem='P20';
				}
				else if (sSourceSystem=='PUMA2'){
					sourceSystem='WES';
				}
				else{
					sourceSystem='Both';
				}
				request.SourceSystem = sourceSystem;
				// NOKIASC-35932 | 12-May-2021 | End
				//NOKIASC-35005
				if(custSetting=='true'){
								request.RequestType = 'Single';
							} else {
								request.RequestType = '';
							}
				//NOKIASC-35005
				HWS_SendWarrantyCheckRequesttoSOO objWSRO = new HWS_SendWarrantyCheckRequesttoSOO();
				String callOutResponse=objWSRO.sendToSOO(request, flowRequest, childDetailsrequest);
				String jsonPayload = JSON.serialize(request);
				String response = 'Is the part covered under warranty?: ';
				response = response+callOutResponse;
				objFlowOutput.isWarranty = response;
			} else {
				String response = 'Invalid part number, please check again. ';
				objFlowOutput.isWarranty = response;
			}
		}	   
		return objFlowOutput;
	}

		 /*****************************************************************
	@description: get the source system using productcode/material number
	@param : String materialNumber
	@return : string sourcesystem
**********************************************************/
	public static String getSourceSystem(String materialNumber){
		Product2[] product=[Select id , HWS_PumaSourceSystem__c from Product2 where ProductCode =:materialNumber AND HWS_DoNotConsider__c = false limit 1];
		String resSourceSystem;
		if(product.size()>0){
			resSourceSystem=product[0].HWS_PumaSourceSystem__c  ;
		}
		String sourceSystem;
		if (resSourceSystem=='PUMA1'){
			sourceSystem='P20';
		}
		else if (resSourceSystem=='PUMA2'){
			sourceSystem='WES';
		}
		else{
			sourceSystem='Both';
		}
		return sourceSystem;
	}
	
	Public Class FlowInput
	{
		@InvocableVariable(required=true)
		Public String MaterialCode;	 
		
		@InvocableVariable(required=true)
		Public String SerialNumber;	 
		
		@InvocableVariable
		Public String CustomerNumber;
		
		Public String SourceSystem;

		Public String RequestType;
		
	}
	
	Public Class FlowOutput
	{
		@InvocableVariable
		Public String isWarranty;
	}
	/****************************************
	* Name : getWarrentStatus
	* @description : returns Warranty Status
	* @param: Material Code, Faulty Unit Serial Number, Source System
	* @return : Warranty Status
	* written on 21st Oct 2020
	* User Story : NOKIASC-32212 & NOKIASC-32213
	*****************************************/
	Public Static String getWarrentStatus(String materialCode,String serialNumber,String sourceSystem){
		String warentyStatus;
		Boolean flowRequest = false;
		//NOKIASC-35005
		String custSetting = HWS_GenericSettings__c.getValues('HWS_EnableWarrantyCheck').HWS_Field1__c;
		//NOKIASC-35005
		FlowInput request = new FlowInput();
		ChildDetails childDetailsrequest = new ChildDetails();
		childDetailsrequest.MaterialCode = materialCode;
		childDetailsrequest.SerialNumber = serialNumber;
		 //NOKIASC-35005
		if(custSetting=='true'){
			childDetailsrequest.RequestType = 'Single';
		} else {
			childDetailsrequest.RequestType = '';
		}
		//NOKIASC-35005
		if (sourceSystem=='PUMA1'){
			sourceSystem='P20';
		}
		else if (sourceSystem=='PUMA2'){
			sourceSystem='WES';
		}
		else{
			sourceSystem='Both';
		}
		childDetailsrequest.SourceSystem = sourceSystem;
		HWS_SendWarrantyCheckRequesttoSOO objWSRO=new HWS_SendWarrantyCheckRequesttoSOO();
		String callOutResponse=objWSRO.sendToSOO(request,flowRequest,childDetailsrequest);
		warentyStatus = callOutResponse;
		if(callOutResponse == 'Under Warranty'){
		   warentyStatus =  'In Warranty';
		}
		else if(callOutResponse == 'Unknown'){
		   warentyStatus =  'Warranty Unknown';
		} 
		else if(callOutResponse == null){
			warentyStatus =  'Failed to determine Warranty';
		}
		return warentyStatus;
	}
	Public Class ChildDetails
	{
		Public String MaterialCode{get;set;}
		Public String SerialNumber{get;set;}
		Public String SourceSystem{get;set;}
		Public String RequestType{get;set;}
		
	}
}