/*****************************************************************
Description:				
This class is invoked from Flow named HWS_CheckWarranty_Version_1.4
Input values 
 - MaterialCode 
 - SerialNumber
 - Customer Number
OutPut values
 -WarrantyCheck Status

History									
DATE		 AUTHOR	 Change
11/13/2018   Nikita Jain	  Created
*****************************************************************/
Public without sharing Class HWS_CheckWarranty_SVC {
	
	/*****************************************************************
	Description: Gets the List of values from Flow warranty check form

	Parameters: List of FlowInput
	Returns:  List of FlowOutput
	Throws [Exceptions]: [optional]				
	History						
	DATE	 AUTHOR	 Change
	11/13/2018	 Nikita Jain  	Created
	*****************************************************************/
	@InvocableMethod(label='Invoke Check Warranty Service')
	//Public Static List<FlowOutput> HWS_sucessfulSubmission(List<FlowInput> requests)
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
	Description: Calls the HWS_SendWarrantyCheckRequesttoSOO class to check the
	Warranty status of item with given Material Code,Serial Number, Customer Number and Source System. 
	Parameters:FlowInput[MaterialCode,SerialNumber,CustomerNumber,SourceSystem]
	Returns:  FlowOutput[isWarranty]
	Throws [Exceptions]: [optional]				
	History						
	DATE	 AUTHOR	 Change
	11/13/2018	 Nikita Jain  	Created
	*****************************************************************/
	Public Static FlowOutput hwsSucessfulSubmissionLocal(FlowInput request)
	{
		String materialNumber=request.MaterialCode;
		String serialNumber=request.SerialNumber;
		String customerNumber=request.CustomerNumber;
		//String materialNumber=request.inputMaterialCode;
		//String serialNumber=(request.inputSerialNumber).toUpperCase();
		//String customerNumber=request.inputCustomerNumber;
		request.SourceSystem=getSourceSystem(materialNumber);
		System.debug('request **'+request);
		HWS_SendWarrantyCheckRequesttoSOO objWSRO=new HWS_SendWarrantyCheckRequesttoSOO();
		String callOutResponse=objWSRO.sendToSOO(request);
		String jsonPayload = JSON.serialize(request,true);
		FlowOutput objFlowOutput=new FlowOutput();
		String response='Is the part covered under warranty?: ';
		response= response+callOutResponse;
		objFlowOutput.isWarranty=response;
		System.debug(jsonPayload);
		return objFlowOutput;
	}

	public static String getSourceSystem(String materialNumber){
		System.debug('materialNumber **'+materialNumber);
		Product2[] product=[Select id , HWS_PumaSourceSystem__c from Product2 where ProductCode =:materialNumber AND HWS_DoNotConsider__c = false limit 1];
		String resSourceSystem;
		System.debug('product**'+product.size());
		if(product.size()>0){
			resSourceSystem=product[0].HWS_PumaSourceSystem__c	;
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
		//Public String inputMaterialCode;
		
		@InvocableVariable(required=true)
		Public String SerialNumber;
		//Public String inputSerialNumber;
		
		@InvocableVariable
		Public String CustomerNumber;
		//Public String inputCustomerNumber;
		
		Public String SourceSystem;
		//Public String SourceSystem;
		
	}
	
	Public Class FlowOutput
	{
		@InvocableVariable
		Public String isWarranty;
	}
}