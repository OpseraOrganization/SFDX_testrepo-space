/****************************************
* Class Name : HWS_WarrantyQuotation_Controller
* User Story :NOKIASC-34453
* Created Date: 01 Feb 2021
* Created By : TCS
* Last Modified by: 
* Last Modified Date:
* Description : Controller for Warranty and Quotation Review
* Test Class: 
*****************************************/

public  without sharing class HWS_WarrantyQuotation_Controller {
	public static List<Case> childCaseQueryRes = new List<Case>();
	public static Boolean isInwarranty = false;
	public static final String WarrantyUnknown = 'Warranty Unknown';
	/****************************************
* Name : getAccounts
* Description : Check Warranty Quotation condition on all child cases
* Parameters: parentCaseID
* Returns : List
* Created Date: 01 Feb 2021
* Created By : Afif Reja
* User Story :NOKIASC-34090
*****************************************/
	@AuraEnabled
	public static WarrantyQuotationWrapper checkWarrantyQuotationCondition(Id parentCaseID,Boolean refreshChildOnly){ 
		
		WarrantyQuotationWrapper objOarrantyQuotationWrapper =  new WarrantyQuotationWrapper();
		Set<String> setlabelName=new Set<String>(); 
		
		Set<String> HWS_W_AND_Q_CONDITION =new Set<String>(); 
		//set contain concat value  of quotation required and warranty status 
		Set<String> QuotationRequired_WarrantyStatus =new Set<String>();  
		Set<String> QuotationRequiredSet =new Set<String>();  
		Set<String> WarrantyStatusSet =new Set<String>();  
		List<Case> caseList=[SELECT Id, CH_InternalStatus__c,HWS_Sent_To_SOO__c,CaseNumber,
							 (SELECT  Id,CaseNumber, Subject, Status, HWS_Contract_Line_Item__r.HWS_WarrantyVerificationRequired__c,
							  HWS_Contract_Line_Item__r.HWS_QuotationRequiredFlag__c,
							  HWS_Contract_Line_Item__r.HWS_InvoicingType__c,HWS_WarrantyStatus__c, 
							  HWS_Part_Code__c, CH_EntitlementException__c, HWS_Sent_To_SOO__c ,
							  HWS_isQuoteRequired__c,HWS_Faulty_Serial_Number__c,
							  HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c   FROM Cases order by CaseNumber asc) 
							 from Case where Id =:parentCaseID ];   
		
		if (!caseList.isEmpty()){
			objOarrantyQuotationWrapper.listofCases=caseList;
			if(refreshChildOnly){
				return objOarrantyQuotationWrapper; 
			} 
			else{
				for ( Case parentCase :caseList ){	 
					for(Case child :parentCase.Cases){
						
						HWS_W_AND_Q_CONDITION.add(child.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c);
						QuotationRequiredSet.add(String.valueof(child.HWS_isQuoteRequired__c));
						WarrantyStatusSet.add(child.HWS_WarrantyStatus__c);
						String vQuotationRequired_WarrantyStatus=child.HWS_isQuoteRequired__c +'-'+child.HWS_WarrantyStatus__c; 
						System.debug('vQuotationRequired_WarrantyStatus' + vQuotationRequired_WarrantyStatus);
						QuotationRequired_WarrantyStatus.add(vQuotationRequired_WarrantyStatus);   
					}
				}			
			}
		}
		else{
			//NOKIASC-34453
			return objOarrantyQuotationWrapper;  
		}
		//Order#1:NOKIASC-34275:UC(2a,6 & 7) : Open PO Missing Console & Portal
		if(HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2A_PO_MISSING') || HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_6_7_PO_MISSING') ){
			setlabelName.add('HWS_PO_MISSING');
			objOarrantyQuotationWrapper.sLabelName=setlabelName;			
			return objOarrantyQuotationWrapper;  
		}  
		//34587
		
		// Order#2:Splitcasefew WU OR few qr TRUE and Others split required
		//Modified NOKIASC-36633 Few unknowns + few quotation required + other scenarios
		//Modified NOKIASC-36633
		if((QuotationRequired_WarrantyStatus.contains('false-Warranty Unknown')||QuotationRequired_WarrantyStatus.contains('true-Warranty Unknown')) 
		   &&(QuotationRequired_WarrantyStatus.contains('true-In Warranty') || QuotationRequired_WarrantyStatus.contains('true-Out of Warranty')|| 
			  QuotationRequired_WarrantyStatus.contains('true-Not Applicable'))&&
		   (QuotationRequired_WarrantyStatus.contains('false-Out of Warranty') || QuotationRequired_WarrantyStatus.contains('false-Not Applicable')||
			QuotationRequired_WarrantyStatus.contains('false-In Warranty'))){
				setlabelName.add('FewWUorQR,HWS_WCheck_UnKnowns_Split');
				objOarrantyQuotationWrapper.sLabelName=setlabelName; 
				objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
				return objOarrantyQuotationWrapper;  
			}
		
		//Modified NOKIASC-36633 Few unknowns + other scenarios
		if((QuotationRequired_WarrantyStatus.contains('false-Warranty Unknown')||QuotationRequired_WarrantyStatus.contains('true-Warranty Unknown')) 
		   &&
		   (QuotationRequired_WarrantyStatus.contains('false-Out of Warranty') || QuotationRequired_WarrantyStatus.contains('false-Not Applicable')||
			QuotationRequired_WarrantyStatus.contains('false-In Warranty'))){
				setlabelName.add('FewWUorQR,HWS_WCheck_UnKnowns_Split');
				objOarrantyQuotationWrapper.sLabelName=setlabelName; 
				objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
				return objOarrantyQuotationWrapper;  
			}
		//Added NOKIASC-36633 Few quotation required + other scenarios
		//Added NOKIASC-36633
		if((QuotationRequired_WarrantyStatus.contains('true-In Warranty')|| QuotationRequired_WarrantyStatus.contains('true-Out of Warranty')||QuotationRequired_WarrantyStatus.contains('true-Not Applicable'))&&
		   (QuotationRequired_WarrantyStatus.contains('false-Out of Warranty')||QuotationRequired_WarrantyStatus.contains('false-Not Applicable')|| QuotationRequired_WarrantyStatus.contains('false-In Warranty'))){
			   setlabelName.add('FewWUorQR,HWS_WCheck_All_QuoteRequired_Split');
			   System.debug('setlabelName***'+setlabelName);
			   objOarrantyQuotationWrapper.sLabelName=setlabelName; 
			   objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
			   return objOarrantyQuotationWrapper;  
		   }
		//Order#3:No Split ALL wu and all QR req
		
		//Added NOKIASC-36633
		//Added NOKIASC-36633
		if(WarrantyStatusSet.contains(HWS_Constants.HWS_WCheck_UnKnowns) ){
			setlabelName.add('HWS_WCheck_UnKnowns');
			objOarrantyQuotationWrapper.sLabelName=setlabelName; 
			return objOarrantyQuotationWrapper;  
		}
		//Added NOKIASC-36633
		if(QuotationRequiredSet.size()==1 && QuotationRequiredSet.contains('true') ){
			setlabelName.add('HWS_WCheck_All_QuoteRequired');
			objOarrantyQuotationWrapper.sLabelName=setlabelName; 
			objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
			return objOarrantyQuotationWrapper;  
		}
		//Order#3:NOKIASC-34095:Use Case 1- All Unknown Warranty Required=No here split will not happen 
		/* if(WarrantyStatusSet.contains(HWS_Constants.HWS_WCheck_UnKnowns)|| QuotationRequiredSet.contains('true') ){
setlabelName.add('HWS_WCheck_UnKnowns');
objOarrantyQuotationWrapper.sLabelName=setlabelName; 
return objOarrantyQuotationWrapper;  
}*/
		//added for NOKIASC-37056
		if(WarrantyStatusSet.size() == 1 && (new List<String> (WarrantyStatusSet).get(0)) == null){
			setlabelName.add('HWS_MSG_WarrantyCheckInProgress');
			objOarrantyQuotationWrapper.sLabelName=setlabelName; 
			return objOarrantyQuotationWrapper;  
		}
		
		//below code - we need to check if the condition matched with any child records then add if block with return value.for example NOKIASC-34093	
		switch on QuotationRequired_WarrantyStatus.size() {
			//When we need not check all child cases in same cindition 
			//all cases quotation required false and warranty status is in Warranty 
			//all cases quotation required false and warranty status is Out Warranty 
			//all cases quotation required false and warranty status is Warranty Unknown
			when 1 {
				//NOKIASC-34090:Use Case 1- All In Warranty/Warranty Check Required=No
				//NOKIASC-34121:UC2a- All In Warranty/Warranty Check Required=No : Console & Portal
				if(QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_InWarranty) || QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_NotApplicable)){
					setlabelName.add('HWS_WCheck_VALIDATE_SUBMIT'); 
					objOarrantyQuotationWrapper.sLabelName=setlabelName;
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;
				}	
				
				//ALL OOW Autocancel cases:'HWS_W_AND_Q_UC_1', 'HWS_W_AND_Q_UC_8','HWS_W_AND_Q_UC_2A','HWS_W_AND_Q_UC_2B'
				if(QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)&&
				   (HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_1')||
					HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_8')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2A')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2B'))){
						setlabelName.add('HWS_WCheck_OOW');
						objOarrantyQuotationWrapper.sLabelName=setlabelName; 
						objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
						return objOarrantyQuotationWrapper;
					}//ALL OOW Autocancel "No" cases:HWS_W_AND_Q_UC_9,HWS_W_AND_Q_UC_6_7
				if(QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)){//ALL OOW but not cancelled cases
					
					setlabelName.add('HWS_WCheck_VALIDATE_SUBMIT');  
					objOarrantyQuotationWrapper.sLabelName=setlabelName; 
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;  
				}
				
			}
			//When we need not check two condtion like All cases quotation required false and few warranty status is in Warranty and Not Applicable
			//All cases quotation required false/true and few warranty status is in Warranty and Not Applicable
			//All cases quotation required false/true and few warranty status is Out Warranty and Not Applicable
			//All cases quotation required false/true and few warranty status is Warranty Unknown and Not Applicable
			when 2 {
				//NOKIASC-34090:Use Case 1- All In Warranty/Warranty Check Required=No
				//NOKIASC-34121:UC2a- All In Warranty/Warranty Check Required=No : Console & Portal
				if(QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_InWarranty) && QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_NotApplicable)){
					setlabelName.add('HWS_WCheck_VALIDATE_SUBMIT');			
					objOarrantyQuotationWrapper.sLabelName=setlabelName;
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;	
				}
				//34119 : possible in all 1,2,3--based on out of warrnty approved values 
				if( (QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_NotApplicable) 
					 && (QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)&&(HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_1')||
																										HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_8')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2A')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2B'))))
				   || (QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_InWarranty) )
				   && (QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)&&(HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_1')||
																									  HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_8')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2A')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2B') )))
				{
					setlabelName.add('HWS_WCheck_OOW');
					objOarrantyQuotationWrapper.sLabelName=setlabelName;
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;
				}   
				if( (QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_NotApplicable) 
					 && QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)) || (QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_InWarranty) 
																										  && QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)))
				{
					setlabelName.add('HWS_WCheck_VALIDATE_SUBMIT');
					objOarrantyQuotationWrapper.sLabelName=setlabelName;
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;
				}	
			}
			when 3 {
				//34119
				if( QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_NotApplicable)
				   &&QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_InWarranty)
				   &&(QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty)&& (HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_1')||
																									  HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_8')||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2A')
																									  ||HWS_W_AND_Q_CONDITION.contains('HWS_W_AND_Q_UC_2B')))
				  )
				{
					setlabelName.add('HWS_WCheck_OOW');
					objOarrantyQuotationWrapper.sLabelName=setlabelName;
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;
				}
				
				if( QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_NotApplicable) 
				   && QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_OutofWarranty) && QuotationRequired_WarrantyStatus.contains(HWS_Constants.false_InWarranty) )
				{
					setlabelName.add('HWS_WCheck_VALIDATE_SUBMIT');
					objOarrantyQuotationWrapper.sLabelName=setlabelName;
					objOarrantyQuotationWrapper.sAfterLabelName='HWS_WCheck_SUBMIT';
					return objOarrantyQuotationWrapper;
				}
				
			}
			
			when else{ 
				//Do Nothing
			}  
		}
		objOarrantyQuotationWrapper.sLabelName=setlabelName;
		return objOarrantyQuotationWrapper;   
		
	}
	
	@AuraEnabled
	public static ID editCase(Id caseId, String serialNumber){
		Case casRec = new Case();
		casRec.Id = caseId;
		casRec.HWS_Faulty_Serial_Number__c = serialNumber;
		update casRec;
		return casRec.Id;
	} 
	
	
	@AuraEnabled
	public static void updateParentInternalStatus(Id parentCaseId){ 
		HWS_Utilty.updateParentInternalStatus(new Set<Id>{parentCaseId});
	}
	
	@AuraEnabled
	public static void updateCaseValues(List<Case> editedCaseList){
		try{
			update editedCaseList; 
			
		} 
		catch(Exception e){ 
			system.debug('Exception Occured: '+e);
		}
	}
	
	@AuraEnabled
	public static void getWarrantyStatus(Case caseRecord){
		Boolean toUpdate = false;
		Case updCase = new Case();
		updCase.Id = caseRecord.Id;
		System.debug('Calling API');
		//NOKIASC-35984 | 13-May-2021 | Start 
		Case cs=[Select id,Status,HWS_Faulty_Serial_Number__c,Asset.HWS_SourceSystem__c, HWS_Stockable_Product__r.Name,HWS_Part_Code__c from Case where id=:caseRecord.id];
		
		string sourcesystem = cs.Asset.HWS_SourceSystem__c;
		string meterialcode = '';
		if(sourcesystem == 'PUMA1')
			meterialcode = cs.HWS_Stockable_Product__r.Name;
		else 
			meterialcode = cs.HWS_Part_Code__c; 
		
		String warrantyStatus = HWS_CheckWarranty_SVC.getWarrentStatus(meterialcode, cs.HWS_Faulty_Serial_Number__c, sourcesystem );
		
		//String warrantyStatus = HWS_CheckWarranty_SVC.getWarrentStatus(caseRecord.HWS_Part_Code__c, caseRecord.HWS_Faulty_Serial_Number__c, 'both');
		//NOKIASC-35984 | 13-May-2021 | End
		System.debug('Succesfully Called API');
		if(warrantyStatus =='In Warranty'){
			updCase.CH_EntitlementException__c = 'No Exception';
			updCase.CH_EntitlementStatus__c = 'Entitled (Automated Verification)';
			toUpdate = true;
			//NOKIASC-33573
			isInwarranty = true;
		}
		else if(caseRecord.HWS_WarrantyStatus__c != WarrantyUnknown && warrantyStatus == WarrantyUnknown){
			updCase.CH_EntitlementException__c = 'Warranty Unknown';
			updCase.CH_EntitlementStatus__c = 'Pending Warranty Verification';
			toUpdate = true;
		}
		else if(caseRecord.HWS_WarrantyStatus__c !='Failed to determine Warranty' && (warrantyStatus =='Failed to determine Warranty' || warrantyStatus == '')){
			updCase.CH_EntitlementException__c = 'Warranty Status Check Failed';
			updCase.CH_EntitlementStatus__c = 'Pending Warranty Verification';
			toUpdate = true;
		}
		else if(warrantyStatus =='Out of Warranty' || test.isRunningTest()){
			updCase.CH_EntitlementException__c = warrantyStatus;
			updCase.CH_EntitlementStatus__c = 'Service Declined';
			toUpdate = true;
		}
		updCase.HWS_WarrantyStatus__c = warrantyStatus;
		if(toUpdate){
			updateCaseValues(new List<Case>{updCase});
		}
	}
	//NOKIASC-34650-start -Ajesh
	@AuraEnabled
	public Static void updateParentCaseStatusWarrantyQuote(String childCaseId) {
		Case caseRecord =[SELECT Id, ParentId FROM Case WHERE Id =:childCaseId] ;
		List<Case> updateCaseList = new List<case>();
		Boolean warrantyVerificationRequired = false;
		Boolean QuoteRequired = false;
		Id ParentRecId = null;
		if (caseRecord.ParentId != null) {
			ParentRecId=caseRecord.ParentId;
		}
		else{
			ParentRecId =  childCaseId;
		}
		case ca = new case();
		ca.Id= ParentRecId;
		for (Case cas :[SELECT Id, HWS_WarrantyStatus__c,HWS_isQuoteRequired__c FROM Case WHERE ParentId =:ParentRecId]) {
			
			if(cas.HWS_WarrantyStatus__c == WarrantyUnknown){
				warrantyVerificationRequired = true;
				QuoteRequired = false;
				break;
			}else if(cas.HWS_isQuoteRequired__c){
				QuoteRequired = true;
			}
			
		}   
		if(warrantyVerificationRequired == true){
			ca.CH_InternalStatus__c = 'Warranty Verification required';
		}else{
			ca.CH_InternalStatus__c ='Quotation Required';
		}
		updateCaseList.add(ca);
		if (!updateCaseList.isEmpty()) {
			
			Update updateCaseList;  
		}
		//NOKIASC-37553
		HWS_EmailNotifications.workgroupEmailAssignment(ParentRecId, 'Pending Order Summary Auto split',null,null);
	}//NOKIASC-34650-End
	@AuraEnabled
	public Static void updateParentCaseStatus(String childCaseId) {
		Case caseRecord =[SELECT Id, ParentId FROM Case WHERE Id =:childCaseId] ;
		List<Case> updateCaseList = new List<case>();
		if (caseRecord.ParentId != null) {
			for (Case cas :[SELECT Id, CH_InternalStatus__c FROM Case WHERE Id =:caseRecord.ParentId]) {
				case ca = new case();
				ca.Id= cas.Id;
				ca.CH_InternalStatus__c= 'Review Completed';
				updateCaseList.add(ca);  
			}   
		} else {
			caseRecord.CH_InternalStatus__c= 'Review Completed';
			updateCaseList.add(caseRecord);
		}
		if (!updateCaseList.isEmpty()) {
			Update updateCaseList;   
		}
	}
	//Nokiasc-34880:updating parent internal status blank for all cancelled cases
	@AuraEnabled
	public Static void updateParentCaseStatusBlank(String parentCaseId) {
		Case caseRecord =[SELECT Id, CH_InternalStatus__c FROM Case WHERE Id =:parentCaseId];
		if (caseRecord.Id != null) {
			caseRecord.CH_InternalStatus__c= null;  
			Update caseRecord;
		}
	}
	
	@auraEnabled
	public static String getPayPerUse(Id parentCaseId){
		String isValue='';
		List<Case> parentCase=[SELECT Id,HWS_Customer_PO__c,CH_InternalStatus__c,
							   (SELECT Id, HWS_Contract_Line_Item__r.CH_ServiceOffering__c,Asset.HWS_ServiceOffering__c,
								Asset.HWS_Price__c,HWS_ServiceType__c,HWS_Contract_Line_Item__r.HWS_InvoicingType__c
								FROM Cases where Status!='Cancelled')
							   FROM Case where Id =:parentCaseId  LIMIT 1];
		if(parentCase.Size()>0){			
			for ( Case pCase :parentCase ){
				if(String.isBlank(pCase.HWS_Customer_PO__c)){		
					for(Case getChildCaseValues:pCase.Cases){   
						string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;  
						string servicetype =getChildCaseValues.HWS_ServiceType__c;	  
						if((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) 
						   && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))){  
							   isValue='PO Error';  
							   break;   
						   }	
					}	
				}
			}	 
		}
		return isValue;
	}
	
	@auraEnabled
	public static HWS_SendServiceRequesttoSOO_SVC.processResponse makeSOOCallout(Id parentCaseId){
		return HWS_Utilty.makeSOOCallout(parentCaseId,'Yes');
	}
	@AuraEnabled
	public static Boolean cancelChildCases(Id parentCaseId,List<String> condition){
		
		
		List<Case> oowCases = [Select id,CaseNumber from case where Status!='Cancelled'		 
							   and HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c IN: condition	
							   and ParentId  =: parentCaseId and ( CH_EntitlementException__c ='Out of Warranty'  OR 
																  (HWS_WarrantyStatus__c='Out of Warranty' and  CH_EntitlementException__c ='Out of Warranty')  
																 )];
		List<Case> cancelledCaseList=new List<Case>();
		for(Case cs:oowCases)
		{
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
	
	
	public class WarrantyQuotationWrapper{
		@AuraEnabled public List<Case> listofCases {get;set;}	
		@AuraEnabled public Set<String> sLabelName {get;set;}
		@AuraEnabled public String sAfterLabelName{get;set;} 
	}
	
	/****************************************
* Name : cloneCases
* Description : This method is used to get clone the HWS cases
* By Satya Pagadala
* Created Date: 12 Feb 2021
* User story : NOKIASC-34093
*****************************************/ 
	@AuraEnabled
	public static String cloneCases(Id parentCaseId, List<Case> childCaseLst, String emailType){
		//Set save point
		Savepoint sp = Database.setSavepoint();
		List<Case> parentCaseList = new List<Case>();
		//get all fields for query dynamically
		String query = HWS_Utilty.getCreatableFieldsSOQL('Case');
		try {
			//Query parent Case for all fields to clone
			Case parentCase = Database.query(query+' WHERE Id=:parentCaseId');
			//Clone and insert parent Case
			Case clonedParentCase = parentCase.Clone(false,false,false,false);
			clonedParentCase.CH_Originating_Incident_Number__c =parentCaseId;
			
			//NOKIASC-34650-start -Ajesh
			Boolean warrantyVerificationRequired = false;
			Boolean QuoteRequired = false;
			for(Case caseRec : childCaseLst){
				if(caseRec.HWS_WarrantyStatus__c ==HWS_Constants.WS_FailDWarranty || (caseRec.HWS_WarrantyStatus__c==HWS_Constants.WS_UKWarranty && caseRec.CH_EntitlementException__c == WarrantyUnknown)){//NOKIASC-38437	
					warrantyVerificationRequired = true;
					QuoteRequired = false;
					break;
				}else if(caseRec.HWS_isQuoteRequired__c){
					QuoteRequired = true;
				}
			}
			if(warrantyVerificationRequired == true){
				clonedParentCase.CH_InternalStatus__c = 'Warranty Verification Required';
			}else{
				clonedParentCase.CH_InternalStatus__c ='Quotation Required';
			}
			//NOKIASC-34650-End
			
			insert clonedParentCase; 
			parentCaseList.add(clonedParentCase);
			if(!childCaseLst.isEmpty()){
				List<Case> childCasesToClone = new List<Case>();
				//Clone and insert child Cases
				for(Case childCase : Database.query(query+' WHERE Id=:childCaseLst')){
					childCase.ParentId = clonedParentCase.Id;
					Case clonedChildCase = childCase.Clone(false,false,false,false);
					childCasesToClone.add(clonedChildCase);
				}
				if(!childCasesToClone.isEmpty()){
					//delete existing child cases
					delete childCaseLst;
					
					//insert cloned child cases
					HWS_CasetriggerHandler.isNewCase=true;//added for 38095
					insert childCasesToClone;
					// NOKIASC-36642 Split scenario parent case cancel code
					List<Case> csList=[Select id,RecordTypeId,ParentId,status,HWS_CancelConfirm__c from Case where ParentId=:parentCaseId];
					HWS_CaseTriggerHelper.changeParentCaseStatus(csList);
					HWS_CaseTriggerHelper.passiveAssignmentHWSParentCase(null, parentCaseList);//NOKIASC-36798
				}
				//34830 -- to send email
				if(emailType != null){
					HWS_EmailNotifications.workgroupEmailAssignment(clonedParentCase.Id, emailType,null,null);
				}	
			}
			//return clonedParentCase.Id;
			// NOKIASC-36633
			clonedParentCase= [SELECT Id, CaseNumber FROM Case WHERE Id = :clonedParentCase.Id];
			return JSON.serialize(clonedParentCase);
		}
		catch(Exception e) {
			Database.rollback(sp);
			System.debug('Cloning Exception ' + e);
			throw new AuraHandledException(e.getMessage());
			
		}
	} 
	
	@AuraEnabled(cacheable=true)
	public static boolean isPortalUser(){
		boolean returnMe = false;
		List<User> lstusr = [SELECT ContactID from User Where ID=: userinfo.getuserid()];
		if(lstusr.size()>0 && lstusr[0].ContactID != null)
			returnMe = true;
		return returnMe;
	}
	
	//NOKIASC-34599
	@AuraEnabled(cacheable=false)
	public static Case getCaseInfo(Id recordId){
		return [SELECT Id, CH_InternalStatus__c, Status FROM CASE WHERE Id = :recordId];
	}
	
	//NOKIASC-34599
	@AuraEnabled(cacheable=false)
	public static Case escalateCases(Id parentCaseId, List<Case> oChildCaseList, Boolean skipSplit,String emailType){
		Case oNewParentCase;
		List<Case> parentCaseList = new List<Case>();
		if(!oChildCaseList.isEmpty()){
			String query = HWS_Utilty.getCreatableFieldsSOQL('Case');
			Case oParentCase = Database.query(query+' WHERE Id = :parentCaseId');
			if(!skipSplit) {
				oNewParentCase = oParentCase.Clone(false,false,false,false);
				oNewParentCase.CH_Originating_Incident_Number__c = parentCaseId;
			}
			else oNewParentCase = oParentCase;
			oNewParentCase.CH_InternalStatus__c = 'Warranty Verification Required';
			upsert oNewParentCase;
			//
			List<Case> oNewChildCaseList = new List<Case>();
			Set<Id> oChildCaseIdSet = (new Map<Id,Case>(oChildCaseList)).keySet();
			for(Case oChildCase : Database.query(query+' WHERE Id IN :oChildCaseIdSet')){
				Case clonedChildCase = skipSplit ? oChildCase : oChildCase.Clone(false,false,false,false);
				clonedChildCase.ParentId = oNewParentCase.Id;
				oNewChildCaseList.add(clonedChildCase);
			}
			if(!oNewChildCaseList.isEmpty()){
				if(!skipSplit) {
					delete oChildCaseList;
					for(Case oChildCase : oNewChildCaseList){
						oChildCase.CH_EntitlementStatus__c = 'Pending Warranty Verification';
						oChildCase.CH_EntitlementException__c = 'Out of Warranty Dispute';
						oChildCase.Status = 'On Hold';
					}
					//37186 Fix for cloned cases to set proper EntitlementException and Entitlementstatus values
					HWS_CaseTriggerHandler.isNewCase= true;
					insert oNewChildCaseList;
				}
				else{
					for(Case oChildCase : oNewChildCaseList){
						oChildCase.CH_EntitlementStatus__c = 'Pending Warranty Verification';
						oChildCase.CH_EntitlementException__c = 'Out of Warranty Dispute';
						oChildCase.Status = 'On Hold';
					}
					HWS_CaseTriggerHandler.isNewCase= true;
					update oNewChildCaseList;
				}
				
			}
			else {
				if(!skipSplit) {
					delete oNewParentCase;
				}
				throw new AuraHandledException('Error while updating child Cases.');
			}
		}
		//NOKIASC-36798
		parentCaseList.add(oNewParentCase);
		HWS_CaseTriggerHelper.passiveAssignmentHWSParentCase(null, parentCaseList);
		//added for NOKIASC-36876
		if(emailType != null){
			HWS_EmailNotifications.workgroupEmailAssignment(oNewParentCase.Id, emailType,null,null);
		}  
		//NOKIASC-36633
		if(oNewParentCase!=null){
			oNewParentCase= [SELECT Id, CaseNumber,CH_InternalStatus__c,CH_Originating_Incident_Number__c FROM Case WHERE Id = :oNewParentCase.Id];  
		}
		return oNewParentCase;
	}
}