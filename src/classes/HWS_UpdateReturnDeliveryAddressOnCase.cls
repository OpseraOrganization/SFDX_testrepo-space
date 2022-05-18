/***************************************** 
* Class Name : HWS_UpdateReturnDeliveryAddressOnCase  
* Created Date: 28 OCT 2020 
* Created By : TCS 
*Test Class : HWS_UpdateReturnDeliveryAddress_Test
* Description : To make custom rest API call to update the Return Delivery Address on Child support ticket 
************/ 
@RestResource(urlMapping='/api/LSPInstructions/*') 
global without sharing class HWS_UpdateReturnDeliveryAddressOnCase { 
	@HttpPost
	global static ResponseLSPInstraction updateCaseWithReturnDeliveryAddress(){
		RestRequest req = RestContext.request; 
		
		ResponseLSPInstraction responseObj;
		Savepoint sp = Database.setSavepoint();//NOKIASC-37193 moved above 
		HWS_WrapLSPInstructions requestObj = (HWS_WrapLSPInstructions)JSON.deserialize(req.requestBody.tostring(), HWS_WrapLSPInstructions.class);
		HWS_BulkUpload__c bulkobj = new HWS_BulkUpload__c();
		bulkobj.Part_Code_Part_Revision__c= requestObj.ParentCaseId;
		bulkobj.ParentCaseId__c = requestObj.ParentCaseId;
		bulkobj.HWS_LSPResponse__c =  req.requestBody.tostring();
		insert bulkobj;
		try{
		//	Savepoint sp = Database.setSavepoint();
			Case parentCaseDetails = [Select Id, CaseNumber,HWS_SOO_Reference_Number__c, HWS_Bar_Code__c,HWS_ReturnAddressReceivedFromSOO__c,(Select Id,HWS_Bar_Code_Ref1__c,HWS_Bar_Code__c from Cases WHERE Status != 'Cancelled') from Case Where Id=:requestObj.ParentCaseId];
			if(parentCaseDetails.HWS_ReturnAddressReceivedFromSOO__c == false){	//added for NOKIASC-38055
	  /*	if(parentCaseDetails.HWS_SOO_Reference_Number__c == null && !Test.isRunningTest()){ // NOKIASC-37920 | Added null check if null then retry | Start
		responseObj = new ResponseLSPInstraction(parentCaseDetails.CaseNumber,400 ,'Error');		
		return responseObj;
	}		// NOKIASC-37920 | Added null check if null then retry | End
	*/
	try{
		Map<String,HWS_WrapLSPInstructions.DeliveryAddress> mapNodeDeliveryAddress = new Map<String,HWS_WrapLSPInstructions.DeliveryAddress>();
		Map<String,String> mapSupplierNode = new Map<String,String>();
		List<ContentNote> listNotes = new List<ContentNote>();
		for(HWS_WrapLSPInstructions.DeliveryAddress address: requestObj.DeliveryAddress){
			mapNodeDeliveryAddress.put(address.ReturnAddressNode,address);
		}
		for(HWS_WrapLSPInstructions.SupplierNodes supplierNode : requestObj.SupplierNodes)
		{ 
			mapSupplierNode.put(supplierNode.LogisticNode,supplierNode.ReferralInstruction);
			if(supplierNode.ReferralInstruction!=null && supplierNode.ReferralInstruction!='')
			{ 
				ContentNote cn = new ContentNote(Title = supplierNode.LogisticNode+'|'+supplierNode.LogisticNodeName +' Referral Instructions', Content = Blob.valueOf(EncodingUtil.base64Decode(supplierNode.ReferralInstruction).toString()));
				listNotes.add(cn);
			}
		}
		if(!listNotes.isEmpty()){ 
			insert listNotes;
			List<ContentDocumentLink> listCDL = new List<ContentDocumentLink>();
			for(ContentNote cn : listNotes){ 
				ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = requestObj.ParentCaseId,ContentDocumentId = cn.Id,shareType = 'V'); 
				listCDL.add(cdl);
			}
			if(!listCDL.isEmpty()){ 
				insert listCDL; 
			} 
			parentCaseDetails.CH_InternalStatus__c = HWS_Constants.PENDING_REFERRAL_INSTRUCTION ; 
		}else if(listNotes.isEmpty()){
			parentCaseDetails.CH_InternalStatus__c = 'No Referral Instruction';
		}
		parentCaseDetails.HWS_ReturnAddressReceivedFromSOO__c = true;
		update parentCaseDetails;
		
	}catch(Exception e){ 
		Database.rollback(sp); 
		createInterfaceLogError(e.getMessage() + ' and Case:'+ parentCaseDetails.CaseNumber,e.getLineNumber());
		responseObj = new ResponseLSPInstraction(parentCaseDetails.CaseNumber,400 ,e.getMessage());
		return responseObj;
	} 
			}
			responseObj = new ResponseLSPInstraction(parentCaseDetails.CaseNumber,204 ,'');			
			return responseObj;
		}
		Catch(Exception e){
			createInterfaceLogError(e.getMessage() + ' and Case:'+ requestObj.ParentCaseId,e.getLineNumber() );
			responseObj = new ResponseLSPInstraction(requestObj.ParentCaseId,500 ,e.getMessage());
			
			return responseObj;
		}
	}
	Public static void createInterfaceLogError(String errorMessage, Integer lineNumber){
		Interface_Log__c ilogcallout = new Interface_Log__c();
		ilogcallout.Interface_Type__c = 'SOO';
		ilogcallout.Message_Type__c = 'Inbound';
		ilogcallout.Operation_Type__c = 'Update';
		ilogcallout.Comment__c = errorMessage + ' and Line number is: '+lineNumber;
		ilogcallout.Status__c = 'Failure';
		ilogcallout.Name = 'LSP Instraction Failure';
		Database.insert(ilogcallout,true);
	}
	global class ResponseLSPInstraction{
		public String CaseNumber;
		public Integer StatusCode;
		public String FailReason;
		public ResponseLSPInstraction(String CaseNumber, Integer StatusCode, String FailReason){
			this.CaseNumber = CaseNumber;
			this.StatusCode = StatusCode;
			this.FailReason = FailReason;
		}
	}
}