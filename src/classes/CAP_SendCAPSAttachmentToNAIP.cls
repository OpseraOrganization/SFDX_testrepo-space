global class CAP_SendCAPSAttachmentToNAIP{
	public static void sendAttachmentId(Case cas, String fileName, String attachmentId, String description,Decimal fileSize){
		CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port con = new CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port();
		con.clientCertName_x = 'Nokia_EAI_Cerificate';
		CH_partnerNAIPWSDLForSF objCH_partnerNAIPWSDLForSF = new CH_partnerNAIPWSDLForSF();
		
		CH_partnerNAIPWSDLForSF.Case_x objCaseX	 = new CH_partnerNAIPWSDLForSF.Case_x();
		CH_partnerNAIPWSDLForSF.sObjects objsObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		//objsObjects.Id = cas.Id;
		objsObjects.CH_Action_ExternalSystem_xc = 'create-informationupdate';
		objsObjects.CaseNumber = cas.CaseNumber;
		objsObjects.CH_CaseOriginSystem_xc = cas.CH_CaseOriginSystem__c;
		objsObjects.ReferenceNumber_xc = cas.Reference_Number__c;
		objCaseX.sObjects = objsObjects;
		
		CH_partnerNAIPWSDLForSF.Attachment objAttachment = new CH_partnerNAIPWSDLForSF.Attachment();
		CH_partnerNAIPWSDLForSF.sObjects3 objsObject3 = new CH_partnerNAIPWSDLForSF.sObjects3();
		List<CH_partnerNAIPWSDLForSF.sObjects3> listObject3 = new List<CH_partnerNAIPWSDLForSF.sObjects3>();//this array/list;
		objsObject3.File_Name_xc = fileName;
		objsObject3.CH_Description_xc = description;
		//objsObject3.CH_FileType_xc = fileSize; this is decimal where anyither field to send file size
		objsObject3.AttachmentID_xc = attachmentId;
		listObject3.add(objsObject3);
		objAttachment.sObjects = listObject3;
		if(!Test.isRunningTest()){
			con.receiveFromSalesForce(objCaseX, null, objAttachment, null, null, null, null, null);
		}
	}
}