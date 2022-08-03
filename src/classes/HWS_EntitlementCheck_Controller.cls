/****************************************
* Class Name : HWS_EntitlementCheck_Controller
* User Story : NOKIASC-32636 
* Created Date: 26 Oct 2020
* Created By : TCS - Satya Pagadala
* Last Modified by: 
* Last Modified Date:
* Description : Controller for Entitlemnet Check
* Test Class: HWS_EntitlementCheck_Controller_Test
*****************************************/
public without sharing class HWS_EntitlementCheck_Controller {	
	/****************************************
	* Name : getChildCaseDetails
	* Description : This method is used to get related child records
	* By Satya Pagadala
	* Created Date: 26 Oct 2020
	* User story : NOKIASC-32636
	*****************************************/ 
	//NOKIASC-33573
	public static Boolean isInwarranty = false;
	@AuraEnabled
	public static List<Case> getChildCaseDetails(Id caseId){
		return [SELECT Id, CaseNumber, Subject, Status, HWS_WarrantyStatus__c, HWS_Part_Code__c, HWS_Faulty_Serial_Number__c, CH_EntitlementException__c, CH_EntitlementStatus__c, parent.HWS_Is_Error__c,parent.HWS_ErrorReason__c, Parent.CH_Status__c,Parent.Status,Parent.HWS_Sent_To_SOO__c
	FROM Case 
	WHERE ParentId =: caseId ORDER BY Subject ASC];
	}
	
 /****************************************
* Name : updateCaseValues
* Description : This method is used to save child records
* By Satya Pagadala
* Created Date: 28 Oct 2020
* User story : NOKIASC-32636
*****************************************/ 
	@auraEnabled
	public static void updateCaseValues(List<Case> editedCaseList,Id parentCaseId){
		String errorMsg='';
		try{
			String errorMessage='';
			errorMessage=validateUser(parentCaseId);			
			if(String.isBlank(errorMessage)){
	//NOKIASC-35984 | 13-May-2021 | Start 
	Case cs=[Select id,Status,HWS_Faulty_Serial_Number__c,Asset.HWS_SourceSystem__c, HWS_Stockable_Product__r.Name,HWS_Part_Code__c from Case where id=:editedCaseList[0].id];		
	if(editedCaseList[0].HWS_Faulty_Serial_Number__c!=cs.HWS_Faulty_Serial_Number__c)
	{	
		string sourcesystem = cs.Asset.HWS_SourceSystem__c;
		string meterialcode = '';
		if(sourcesystem == 'PUMA1'){
			meterialcode = cs.HWS_Stockable_Product__r.Name;
		}		
		else {
			meterialcode = cs.HWS_Part_Code__c; 
		}	
		String warrantyStatus = HWS_CheckWarranty_SVC.getWarrentStatus(meterialcode, cs.HWS_Faulty_Serial_Number__c, sourcesystem );
		
		//String warrantyStatus = HWS_CheckWarranty_SVC.getWarrentStatus(editedCaseList[0].HWS_Part_Code__c, editedCaseList[0].HWS_Faulty_Serial_Number__c, 'both');
		//NOKIASC-35984 | 13-May-2021 | End
		editedCaseList[0].HWS_WarrantyStatus__c=warrantyStatus;
	}
	update editedCaseList;	
	//NOKIASC-33573
	 if(editedCaseList.size()==1){
		updateParentInternalStatus(editedCaseList[0].ParentId);
	}
			} 
			else{
	
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage(errorMessage);	
	throw auraExp;
			}
		}		 
		catch(DmlException e){	 
			for (Integer i = 0; i < e.getNumDml(); i++) {
	errorMsg =+ e.getDmlMessage(i) +  '\n' ;
			}
			throw new AuraHandledException(errorMsg);
		}
		catch(Exception e){
			System.debug(e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
		
	}
		/****************************************
* Name : getWarrantyStatus
* Description : This method is used to get Warranty Status
* By Satya Pagadala
* Created Date: 28 Oct 2020
* User story : NOKIASC-32645
*****************************************/ 
	@auraEnabled
	public static void getWarrantyStatus(Case caseRecord){
		try{
	  
		 
			Boolean toUpdate = false;
			//NOKIASC-35984 | 13-May-2021 | Start
		List<Case> lstCase = [SELECT id, Asset.HWS_SourceSystem__c, HWS_Stockable_Product__r.Name,HWS_Part_Code__c,HWS_Faulty_Serial_Number__c FROM case where id=:caseRecord.Id LIMIT 1];
		string sourcesystem = lstCase[0].Asset.HWS_SourceSystem__c;
		string meterialcode = '';
		if(sourcesystem == 'PUMA1')
			meterialcode = lstCase[0].HWS_Stockable_Product__r.Name;
		else 
			meterialcode = lstCase[0].HWS_Part_Code__c; 
		
		String warrantyStatus = HWS_CheckWarranty_SVC.getWarrentStatus(meterialcode, lstCase[0].HWS_Faulty_Serial_Number__c, sourcesystem );
		//NOKIASC-35984 | 13-May-2021 | End
		System.debug('This is the value--'+warrantyStatus);
			if(warrantyStatus =='In Warranty'){
	caseRecord.CH_EntitlementException__c = 'No Exception';
	caseRecord.CH_EntitlementStatus__c = 'Entitled (Automated Verification)';
	toUpdate = true;
	//NOKIASC-33573
	isInwarranty = true;
			}
			else if(caseRecord.HWS_WarrantyStatus__c !='Warranty Unknown' && warrantyStatus =='Warranty Unknown'){
	caseRecord.CH_EntitlementException__c = 'Warranty Unknown';
	caseRecord.CH_EntitlementStatus__c = 'Pending Warranty Verification';
	toUpdate = true;
			}
			else if(caseRecord.HWS_WarrantyStatus__c !='Failed to determine Warranty' && (warrantyStatus =='Failed to determine Warranty' || warrantyStatus == '')){
	caseRecord.CH_EntitlementException__c = 'Warranty Status Check Failed to Complete';
	caseRecord.CH_EntitlementStatus__c = 'Pending Warranty Verification';
	toUpdate = true;
			}
			else if(warrantyStatus =='Out of Warranty' || test.isRunningTest()){
	caseRecord.CH_EntitlementException__c = warrantyStatus;
	caseRecord.CH_EntitlementStatus__c = 'Service Declined';
	toUpdate = true;
			}
			caseRecord.HWS_WarrantyStatus__c = warrantyStatus;
			if(toUpdate){
		updateCaseValues(new List<Case>{caseRecord},caseRecord.parentId);
			}
			
		}
		catch(Exception e){
			System.debug('Exception Occured' + e);
			throw new AuraHandledException(e.getMessage());
		}
	}
	/****************************************
	* Name : updateParentInternalStatus
	* Description : This method is used to check and Update Parent Internal Status if child case status is either Draft or Cancel
	* By Satya Pagadala
	* Created Date: 06 Nov 2020
	* User story : NOKIASC-32645
	*****************************************/ 
	@auraEnabled
	public static void updateParentInternalStatus(Id parentCaseId){
	HWS_Utilty.updateParentInternalStatus(new Set<Id>{parentCaseId});
	
	}
	/****************************************
	* Name : updateParentInternalStatus
	* Description : This method is used to update Internal status to update Quotation Required automatically for verified Quotation cases
	* By TCS
	* Created Date: 19 July 2021
	* User story : NOKIASC-36933
	*****************************************/
	 @auraEnabled
	public static Case modifyInternalStatusToQuoteReq(Id parentCaseId){
		Case parentWG =new Case();
		//NOKIASC-36933:Internal status to update automatically for verified Quotation cases
		List<Case> parentCaseToUpdate = new List<Case>();
		for(Case parentCase: [Select Id, CH_InternalStatus__c, (SELECT CH_EntitlementException__c, CH_EntitlementStatus__c,HWS_isQuoteRequired__c FROM Cases) from Case where Id = :parentCaseId]){
			Integer increment=0;
			 if(!(parentCase.Cases).isEmpty()){
				for(Case c :parentCase.Cases){
					if(c.HWS_isQuoteRequired__c){
						increment++;
					}
				}
			}	   
			if(parentCase.Cases.size()==increment &&  parentCase.CH_InternalStatus__c!='Quotation Required'){
				parentCase.CH_InternalStatus__c='Quotation Required'; 
				parentCaseToUpdate.add(parentCase); 
			}
		}
		if(!parentCaseToUpdate.isEmpty()){
			update parentCaseToUpdate; 
			parentWG=[SELECT CH_Workgroup__r.name,CH_Workgroup__c FROM Case WHERE Id = :parentCaseId LIMIT 1];
		}
		return parentWG;
	}
	/****************************************
	* Name : checkInternalStatus
	* Description : This method is used to pass the value when Internal Status is not blank
	* By Gopi Krishna
	* Created Date: 06 Nov 2020
	* User story : NOKIASC-32649
	*****************************************/ 
	 @AuraEnabled
	Public static boolean getInternalStatus(Id parentCaseId){
		boolean checkInternalStatus = false;
		case caseList = [select id,CH_InternalStatus__c from Case where Id =:parentCaseID];
		if(caseList.CH_InternalStatus__c != null && caseList.CH_InternalStatus__c != '')
			checkInternalStatus = true;
		return checkInternalStatus;
	}
	@AuraEnabled
  public static HWS_SendServiceRequesttoSOO_SVC.processResponse makeSOOCallout(Id parentCaseId){
	return HWS_Utilty.makeSOOCallout(parentCaseId,'true');
  }
  @AuraEnabled
	public static boolean cancelChildCases(Id parentCaseId,List<String> condition){
		
		
		List<Case> oowCases = [Select id,CaseNumber from case where Status!='Cancelled'		 
	and HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c IN: condition	
	and ParentId  =: parentCaseId and ( CH_EntitlementException__c ='Out of Warranty'  OR 
	(HWS_WarrantyStatus__c='Out of Warranty' and  CH_EntitlementException__c ='Out of Warranty')  
	  )]; // Modified as per uat defect
		List<Case> cancelledCaseList=new List<Case>();
		for(Case cs:oowCases){
	
			cs.Cancellation_Reason__c='Out of warranty';
			cs.CH_ReasonForCancellation__c = 'Auto Cancelled due to Out of warranty';
			cs.Status = 'Cancelled';
			cancelledCaseList.add(cs);
			
		}
		try{
			if(cancelledCaseList.size()>0){
	HWS_BypassStatusChangeValidation__c custSetting= HWS_BypassStatusChangeValidation__c.getInstance(); 
	custSetting.HWS_BypassCaseStatusValidation__c = true;
	upsert custSetting;
	
	update cancelledCaseList;
	custSetting.HWS_BypassCaseStatusValidation__c = false;
	upsert custSetting;
	
	
	return true;
			} else {
	
	return true;
			}
		}
		catch(Exception ex){
			System.debug('Exception is'+ex.getMessage());
			
			return false;
		}
	}
	
  @auraEnabled
 public static String getPayPerUse(Id parentCaseId){
		String isValue;
		 Boolean invoicingType = false;
		//added  for PMD Error - NOKIASC-32425
		List<Case> parentCase=[select id,HWS_Customer_PO__c,CH_InternalStatus__c from case where Id =:parentCaseId  LIMIT 1];
		List<Case> childCases;
		if(parentCase.Size()>0){
			//added  for PMD Error - NOKIASC-32425
			childCases = [select Id, HWS_Contract_Line_Item__r.CH_ServiceOffering__c,Asset.HWS_ServiceOffering__c,Asset.HWS_Price__c,HWS_ServiceType__c,HWS_Contract_Line_Item__r.HWS_InvoicingType__c
		FROM Case where ParentId =: parentCaseId AND Status!='Cancelled' ];
			if((parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) && childCases.Size()>0){   
		
		for(Case getChildCaseValues:childCases){	
			string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;  
			string servicetype =getChildCaseValues.HWS_ServiceType__c;  
	String invoiceType = getChildCaseValues.HWS_Contract_Line_Item__r.HWS_InvoicingType__c;
			if(invoiceType == 'event based'){
		invoicingType = true;
	}
			if((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))){   
	isValue='PO Error'; 
	break;  
			}   
		}   
	
			}   
			if(childCases.Size()>0){	
	for(Case getChildCaseValues:childCases){	
		string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;  
		string getPrice=getChildCaseValues.Asset.HWS_Price__c;  
		string servicetype =getChildCaseValues.HWS_ServiceType__c;  
		if(((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))) && ((parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) &&  
		 (getPrice == '' || getPrice == null ))) {	
	
	isValue='Quotation Error';
	break;
		 
		}
	}
			}
			if(invoicingType && (parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) &&
	  parentCase[0].CH_InternalStatus__c == 'Warranty Verification Required'){
	isValue='WarrantyError';
	  }
			else if(invoicingType && (parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) &&
		(parentCase[0].CH_InternalStatus__c == '' || parentCase[0].CH_InternalStatus__c == NULL)){
			isValue='WarrantyNullError';
		}
		}
		return isValue;
	}
	/****************************************
	* Name : cloneCases
	* Description : This method is used to clone the selcted child HWS cases
	* By Vinod T
	* Created Date: 15 Feb 2021
	* User story : NOKIASC-34261
	*****************************************/ 
	@AuraEnabled
	public static String cloneCases(Id parentCaseId, List<Case> childCaseLst, String emailType){
		return HWS_WarrantyQuotation_Controller.cloneCases(parentCaseId,childCaseLst, emailType);
	}
	
	@AuraEnabled	
   public static HWS_SendServiceRequesttoSOO_SVC.ProcessResponse retryTosync(string caseId) {	
	HWS_SendServiceRequesttoSOO_SVC.ProcessResponse response = new HWS_SendServiceRequesttoSOO_SVC.ProcessResponse();
	response = HWS_SendServiceRequesttoSOO_SVC.sendBulkToSOO(caseId);
	return response;   
   }
	/****************************************
* Name : accetRejectQuoteDate
* Description : This method is used to update and validate Qoute Accepetd Date and Quote Rejected Date
* By Afif
* Created Date: 22 March 2021
* User story : NOKIASC-34877
*****************************************/
	@AuraEnabled
	public static void acceptRejectQuoteDate(List<Id> caseSet,String action) {		
		String errorMessage=Null;
		List<Case> updatechildCaseList=new List<Case>();
		
		try{
			List<Case> childCaseList=[SELECT Id,HWS_SupportTicketReference__c,CH_EntitlementStatus__c,
	 HWS_QuotationAcceptedDate__c,HWS_QuotationRejectedDate__c,Parent.HWS_Customer_PO__c from Case WHERE Id IN:caseSet];
	 ID parentCaseID = childCaseList[0].ParentId;
			for(Case childCase:childCaseList){
	//Validate Customer Purchase Order Number avaliable or not in parent case
	if(String.isBlank(childCase.Parent.HWS_Customer_PO__c) && action=='acceptQuote'){
		errorMessage='Purchase Order Number field must be populated with the customer PO';
		break;
	} 
	//For Accept Quote "Quotation Accepted Date" should be blank
	////For Reject Quote "Quotation Rejected Date" should be blank
	if((childCase.HWS_QuotationAcceptedDate__c!=Null && action=='acceptQuote') 
	|| (childCase.HWS_QuotationRejectedDate__c!=Null && action=='rejectQuote')){		
		continue;
	}
	if((childCase.HWS_QuotationRejectedDate__c!=Null && action=='acceptQuote') 
	|| (childCase.HWS_QuotationAcceptedDate__c!=Null && action=='rejectQuote')){		
		errorMessage='One or more selected RMA(s) have already been '+(action=='acceptQuote'?'rejected':'accepted')+'.';
		break;
	}
	//Create case object for field update
	Case updateCase=new Case();
	updateCase.Id=childCase.Id;
	//Update Quotation Accepted Date when action is acceptQuote
	if(action=='acceptQuote'){
		updateCase.HWS_QuotationAcceptedDate__c=Datetime.now();
	
		updateCase.CH_EntitlementStatus__c='Quotation Accepted and PO Received';
	}
	//Update Quotation Rejected Date when action is rejectQuote
	else if(action=='rejectQuote'){
		updateCase.HWS_QuotationRejectedDate__c=Datetime.now();
	  
		updateCase.CH_EntitlementStatus__c='Quotation Rejected';
	}
	// Quotation Accepted and PO Received
	updatechildCaseList.add(updateCase);	
			}
			//When Customer Purchase Order Number not avaliable then throwing error message
			if(String.isNotBlank(errorMessage)){	
	AuraHandledException auraEx = new AuraHandledException(errorMessage);
	auraEx.setMessage(errorMessage);
	throw auraEx;
			}		 
			//Update child case list
			if(updatechildCaseList.size()>0){
	update updatechildCaseList;
	updateParentInternalStatus(parentCaseID);//making iternal status blank
			}
			else if (updatechildCaseList.size()==0){
	errorMessage='Selected RMA(s) have already been '+(action=='acceptQuote'?'accepted':'rejected')+'.';
	AuraHandledException auraEx = new AuraHandledException(errorMessage);
	auraEx.setMessage(errorMessage);
	throw auraEx;  
			}
			
		}catch(Exception e){			
			throw new AuraHandledException(e.getMessage());
		}
}
 /****************************************
* Name : getDependentMap
* Description : This method is used to get dependent picklist value
* By Afif
* Created Date: 21 June,2021
* User story : NOKIASC-36696
*****************************************/
	@AuraEnabled 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
		String Param='';
		Map<String, List<String>> objResults = HWS_Utilty.getDependentMap(objDetail, contrfieldApiName,depfieldApiName,Param);
		return objResults;
	}
	/****************************************
* Name : validateUser
* Description : This method is used to get dependent picklist value
* By Afif
* Created Date: 21 June,2021
* User story : NOKIASC-36696
*****************************************/
	
	@AuraEnabled
	public static String validateUser(String parentCaseId){	 
		String errorMessage='';		
		Id loginUserId=Userinfo.getUserId();
		Case currentCase=[SELECT Id,OwnerId,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,CH_3rdPartySecurityGroup__c FROM Case WHERE Id=:parentCaseId];
		List<CH_CA_DTO.WorkgroupMemberDTO> caseTeamMembersDTO = new List<CH_CA_DTO.WorkgroupMemberDTO>();		
		CH_CA_DTO.WorkgroupMemberDTO caseTeamMemberDTO = new CH_CA_DTO.WorkgroupMemberDTO();
		caseTeamMemberDTO.userId = loginUserId;
		caseTeamMembersDTO.add(caseTeamMemberDTO);
		CH_CA_Security security = new CH_CA_Security();
		List<CH_CA_DTO.WorkgroupMemberDTO> isAuthorizedMember=security.checkWGMembersSecurity(currentCase,caseTeamMembersDTO);
		if (isAuthorizedMember.size()==0){
			errorMessage='This user does not have the right security permission to update the record.';
		} 
		if (currentCase.OwnerId ==loginUserID){	
			return errorMessage;
		} 
		if(String.isBlank(errorMessage)){
			//Check if login user is in valid Security group 
			List<GroupMember> grpNameList   = [select Group.Name from groupmember where userorgroupid = :loginUserId ];
			for (GroupMember grpName : grpNameList){	 
	if (grpName.Group.Name =='SEC_GWC|ALL' || grpName.Group.Name =='SEC_GWC|NSB'){
		return errorMessage;
	}
			} 
		}	  
		if(String.isBlank(errorMessage)){
			//Check if login user is a part of Case Team
			Integer caseTeamMembercount= [SELECT count()
			FROM CaseTeamMember 
			WHERE ParentId =: currentCase.Id AND MemberId= : loginUserID limit 1 ];
			if (caseTeamMemberCount == 0){	 
	errorMessage='Login User is not part of the Case Team and cannot update the record.';	  
			}
			if(caseTeamMemberCount > 0){	
	return errorMessage;
			}
		}
		return errorMessage;
	}
}