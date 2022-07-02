/****************************************
* Class Name : HWS_EmailNotifications
* Created Date:  September 2020
* Created By : TCS
* Description : To send email notifications
*****************************************/
public without sharing class HWS_EmailNotifications {
	/****************************************
* Created Date:  September 2020
* Created By : TCS 
* Developer : Bharathi Nutakki
* Description : To send email notifications for Pending Referral Instructions for portal
*****************************************/
	@future (callout=true)
	public static void pendingReferralInstructionsEmail(Set<Id> caseIdSet,String intStatus){ 
			String parentCaseQuery = 'SELECT id, RecordTypeId, ParentId, Createdby.Profile.Name FROM Case WHERE ParentId IN :caseIdSet';		
		List<Case> parentCaseList = Database.query(parentCaseQuery);
		Set<Id> parentCaseIdSet = new Set<Id>();		
		List<CH_EmailAlert__c> emailAlertList = new List<CH_EmailAlert__c>();
		if(parentCaseList.size() > 0){
			for(Case cs:parentCaseList){
				if(cs.ParentId != null && (cs.Createdby.Profile.Name == 'Customers' || cs.Createdby.Profile.Name == 'Customers Login' || intStatus == 'Waiting for Referral Instruction')){										   
					parentCaseIdSet.add(cs.ParentId);					
				}
			}		 
											
			List<Case> childCaseList = [SELECT Id,CaseNumber,HWS_ServiceType__c,Asset.HWS_ContractLeadTimeUnit__c,Parent.CH_InternalStatus__c,Asset.HWS_ContractLeadTimeDuration__c,Parent.CreatedDate,Parent.Country__c,Parent.Id,Parent.OwnerId, Parent.CaseNumber,Parent.Account.Name,Parent.Origin FROM Case 
										WHERE ParentId IN: parentCaseIdSet AND Parent.CH_InternalStatus__c ='Pending Referral Instruction'];	  
			List<Integer> astList = new List<Integer>();
			for(Case ca : childCaseList){
				if(ca.Asset.HWS_ContractLeadTimeDuration__c != null)
					astList.add(Integer.ValueOf(ca.Asset.HWS_ContractLeadTimeDuration__c));
			}
			if(!astList.isEmpty())
				astList.sort();
			Group gwcGroup = [SELECT Id,Email FROM Group WHERE Type='Queue' AND Name='GWC'];
			if(childCaseList.size() > 0){
				CH_EmailAlert__c createEmail = new CH_EmailAlert__c();
				createEmail.CH_Bind1__c = childCaseList[0].Parent.CaseNumber;
				createEmail.CH_Bind2__c = String.valueOfGmt(childCaseList[0].parent.CreatedDate);
				createEmail.CH_EmailAlertName__c = 'HWS '+ childCaseList[0].parent.CH_InternalStatus__c+' Alert';
				createEmail.CH_Bind3__c = childCaseList[0].HWS_ServiceType__c;
				createEmail.CH_Bind4__c = astList.isEmpty() ? '' : String.valueOf(astList[0]);
				createEmail.CH_Bind5__c = childCaseList[0].Asset.HWS_ContractLeadTimeUnit__c;
				createEmail.CH_Bind6__c = childCaseList[0].Parent.Account.Name;
				createEmail.CH_Bind7__c = childCaseList[0].Parent.Country__c;			
				createEmail.CH_Bind14__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + childCaseList[0].ParentId ;
				createEmail.CH_Bind13__c = childCaseList[0].Parent.Account.Name;
				createEmail.CH_Bind15__c = gwcGroup.Email;
				emailAlertList.add(createEmail);  
			}		
			if(emailAlertList.size()>0){
				try{
					Database.insert(emailAlertList,false);
				}catch(Exception e){
					System.debug('EXCEPTION:'+e.getMessage());
				}
			}
		}	
	}
	/****************************************
* Created Date:  September 2020
* Created By : NOKIA COE 
* Developer : Nikhil
* Description : To send email notifications to Sharepoint
*****************************************/
   //Removed Future annotation for PROD Defect 37600
	public static void RequestHWFMARCA(Set<Id> caseSet){	 
		Set<Id> HWSRecordTypeIdSet = new Set<Id>();
		Set<String> HWSRecordTypeSet = new Set<String>{'HWS_Advance_Exchange_In_Days','HWS_Advance_Exchange_In_Hours','HWS_Child_Case_Read_Only','HWS_Return_For_Repair'};
			for (RecordType rt : [SELECT Id, SobjectType, DeveloperName 
								  FROM RecordType 
								  WHERE SobjectType='Case'
								  AND DeveloperName IN :HWSRecordTypeSet]) 
		{
			HWSRecordTypeIdSet.add(rt.Id);	
		}
		
		List<case> ChildCaseList = [select id,Status, CaseNumber,CreatedDate, Parentid,HWS_RequestHWRCAFMA__c,HWS_RMA_Number__c,HWS_Part_Code__c,Parent.CreatedDate,
									HWS_Faulty_Serial_Number__c,HWS_Address_Name__c,HWS_Contract_Line_Item__r.Product2.CH_Business_Group__c,
									HWS_RelatedSoftwareTicketNumber__c,HWS_Contract_Line_Item__r.Product2.Name,Parent.Contact.Name,
									Parent.Contact.Account.Name,CH_Account_Name__c,Parent.Contact.Email,HWS_ServiceType__c,
									Asset.HWS_ContractLeadTimeDuration__c,Asset.HWS_ContractLeadTimeUnit__c 
									from case 
									where Id in :caseSet 
									AND RecordTypeId IN :HWSRecordTypeIdSet 
									AND HWS_RequestHWRCAFMA__c=true 
									AND HWS_RelatedSoftwareTicketNumber__c!=null];
		
		List<CH_EmailAlert__c> emailList = new List<CH_EmailAlert__c>();
		if(ChildCaseList.size() > 0){
			for(Case childCase: ChildCaseList){
				if(childCase.HWS_RelatedSoftwareTicketNumber__c!=null && childCase.Parent!=null && 
				   childCase.Status!='Draft'){
					   CH_EmailAlert__c createEmail = new CH_EmailAlert__c();
					   createEmail.CH_Bind1__c = String.valueOf(childCase.CreatedDate)+'()'+childCase.HWS_Part_Code__c;
					   createEmail.CH_Bind2__c = childCase.HWS_RMA_Number__c;
					   createEmail.CH_EmailAlertName__c = 'HWS Request HW FMA RCA Sharepoint';
					   createEmail.CH_Bind3__c = childCase.HWS_Faulty_Serial_Number__c;
					   createEmail.CH_Bind4__c = childCase.Asset.HWS_ContractLeadTimeDuration__c;
					   createEmail.CH_Bind5__c = childCase.Asset.HWS_ContractLeadTimeUnit__c;
		// NOKIASC-34546 - using HWS_Address_Name__c from parent itself
			string sAddress_Name =  childCase.HWS_Address_Name__c == null ? '': childCase.HWS_Address_Name__c ;
					   createEmail.CH_Bind6__c =  sAddress_Name  +'()'+childCase.HWS_Contract_Line_Item__r.Product2.Name;
					   createEmail.CH_Bind7__c = childCase.HWS_Contract_Line_Item__r.Product2.Name;			
					   createEmail.CH_Bind8__c = childCase.HWS_RelatedSoftwareTicketNumber__c;
					   createEmail.CH_Bind9__c = childCase.CH_Account_Name__c;
					   createEmail.CH_Bind10__c = childCase.HWS_Contract_Line_Item__r.Product2.CH_Business_Group__c;
					   createEmail.CH_Bind11__c = childCase.Parent.Contact.Name;
					   createEmail.CH_Bind12__c = childCase.Parent.Contact.Account.Name;
					   createEmail.CH_Bind14__c = childCase.HWS_ServiceType__c ;
					   createEmail.CH_Bind13__c = childCase.Parent.Contact.Email;
					   createEmail.CH_Bind15__c = System.Label.HWS_RCA_FMA_SharePointEmail;
					   createEmail.CH_Bind_16__c= String.valueOf(childCase.HWS_RequestHWRCAFMA__c);
		createEmail.CH_Bind_17__c= String.valueOf(childCase.id);
					   emailList.add(createEmail);
					   
				   }
			}
		}
		if(emailList.size()>0){
			try{
				Database.insert(emailList,false);
			} catch(Exception e){
				System.debug('Exception'+e.getMessage());
			}
			
		}
	}
	 //NOKIASC-35000
	@future (callout=true)
	public static void workgroupEmailAssignment(Id parentId,String alertName, String emailAddressvalue, String workgroupName){	 
		List<case> ParentCaseList = [select Id, CaseNumber,CreatedDate, Parentid,
									Contact.Name, Contact.Phone, Contact.MobilePhone, NCP_Service_Contract__r.Name, Owner.Name,
									Contact.Account.Name, CH_Account_Name__c, Contact.Email, Contact.Email1__c, Contact.CH_Email3__c, HWS_Communication_Contact__r.Email, Owner.Email,CH_OwnerName__c,CH_CurrentQueue__c,CH_OwnerEmail__c,
									CH_Workgroup__r.CH_Type__c,NCP_Service_Contract__r.Id,CH_InternalStatus__c,CH_Workgroup__c,CH_Workgroup__r.Name, CH_Originating_Incident_Number__r.CaseNumber, (SELECT Id FROM Cases)
									from case 
									where Id = :parentId and HWS_RecordTypeCheck__c=true
									];
		
		List<CH_EmailAlert__c> emailAlertList = new List<CH_EmailAlert__c>();
		if(ParentCaseList.size() > 0){
			for(Case cs: ParentCaseList){
			CH_EmailAlert__c createEmail = new CH_EmailAlert__c();
			if(emailAddressvalue!=null && (cs.CH_OwnerName__c=='GWC'|| String.isNotBlank(cs.CH_CurrentQueue__c)) && alertName =='HWS Workgroup Email Reassignment Alert'){
					//continue;
					createEmail.CH_Bind15__c = emailAddressvalue;
				}
				
				createEmail.CH_Bind1__c = cs.CaseNumber;
				createEmail.CH_Bind2__c = String.valueOfGmt(cs.CreatedDate);
				createEmail.CH_Bind3__c = cs.CH_Account_Name__c;
				createEmail.CH_Bind4__c = cs.Contact.Account.Name;
				createEmail.CH_Bind5__c = cs.Contact.Name;
				createEmail.CH_Bind6__c = cs.Contact.Phone;
				createEmail.CH_Bind7__c = cs.Contact.MobilePhone;
				createEmail.CH_Bind8__c = cs.Contact.Email;
				createEmail.CH_Bind9__c = cs.NCP_Service_Contract__r.Name;
				createEmail.CH_Bind10__c = cs.Id;
				createEmail.CH_Bind11__c = cs.Owner.Name;
				
				//NOKIASC-34830 Added if-else to use field values for Manula Split Email
				if(alertName == 'HWS Pending Order Summary Manual Split'){
					createEmail.CH_Bind15__c = cs.Contact.Email;
					createEmail.CH_Bind_16__c = cs.CH_Originating_Incident_Number__r.CaseNumber;
					createEmail.CH_Bind_17__c = string.valueof(cs.Cases.size());
				}
	else if(alertName == 'HWS Order Acknowledgement Escalated Case'){ //added for NOKIASC-36876
					createEmail.CH_Bind_16__c = cs.CH_Originating_Incident_Number__r.CaseNumber;
					createEmail.CH_Bind_17__c = string.valueof(cs.Cases.size());
					createEmail.CH_Bind15__c = cs.Contact.Email;
				}
				else{
		createEmail.CH_Bind19__c = cs.CH_Workgroup__r.Name;
					if(alertName == 'Workgroup Assign Emails'){
						createEmail.CH_Bind15__c = emailAddressvalue;
				if(workgroupName != null && workgroupName !=''){	
		createEmail.CH_Bind19__c =  workgroupName;	
				}
					}
		else if(alertName == 'Pending Order Summary Auto split'){
						createEmail.CH_Bind15__c = cs.Contact.Email;
					}
					else if(emailAddressvalue!=null && alertName =='HWS Workgroup Email Reassignment Alert'){
					// NOKIASC-36927
						createEmail.CH_Bind15__c = emailAddressvalue;
					}
					else{
						createEmail.CH_Bind15__c = cs.CH_OwnerEmail__c; 
					}
					createEmail.CH_Bind_16__c = cs.NCP_Service_Contract__r.Id;
					if(cs.CH_Workgroup__c != null){
						List<String> workGroupType = cs.CH_Workgroup__r.CH_Type__c.split(';');
						createEmail.CH_Bind_17__c = String.join(workGroupType, '|');
					}
					
					createEmail.CH_Bind18__c = cs.CH_InternalStatus__c;
		createEmail.CH_Bind20__c = string.valueof(cs.Cases.size());
				}
				createEmail.CH_EmailAlertName__c = alertName;
				createEmail.CH_BindEmail1__c = cs.HWS_Communication_Contact__r.Email;
				createEmail.CH_BindEmail2__c = cs.Contact.Email1__c;
				createEmail.CH_BindEmail3__c = cs.Contact.CH_Email3__c;
				
				emailAlertList.add(createEmail);  
			}
		}
		if(emailAlertList.size()>0){
			try{
				Database.insert(emailAlertList,false);
			} catch(Exception e){
				System.debug('Exception'+e.getMessage());
			}
			
		}
	}
	 //NOKIASC-35000
	public Id parentCaseRecId {get;set;}
	public String displayTable {get;set;}
	public String alertType {get;set;} //added for NOKIASC-36876
	
	//34830
	public Boolean entExceptionCheck {get{
		if(entExceptionCheck == null){
				entExceptionCheck = false;				
			}
		return entExceptionCheck;
	}set;}
	public List<CaseWrapper> getCases()
	{
		List<CaseWrapper> caseList = new List<CaseWrapper>();
		if(parentCaseRecId!=null){
			for(Case c :[SELECT HWS_Part_Code__c, HWS_Faulty_Serial_Number__c,CaseNumber,HWS_RMA_Number__c,CH_EntitlementStatus__c,HWS_Sellable_Product__r.Name,HWS_ServiceType__c,CH_EntitlementException__c,HWS_EntitlementException__c,HWS_Customer_Reference_Number__c FROM Case WHERE ParentId =: parentCaseRecId]){
	CaseWrapper wrapper = new CaseWrapper();
				wrapper.CaseNumber = c.HWS_RMA_Number__c;
	wrapper.HWS_Customer_Reference_Number = c.HWS_Customer_Reference_Number__c;
				wrapper.HWS_Part_Code = c.HWS_Part_Code__c;
				wrapper.HWS_Sellable_ProductName = c.HWS_Sellable_Product__r.Name;
				wrapper.HWS_Faulty_Serial_Number = c.HWS_Faulty_Serial_Number__c;
				wrapper.HWS_ServiceType = c.HWS_ServiceType__c;
				if(entExceptionCheck){
					//added for NOKIASC-36876 
					if(alertType == 'HWS Order Acknowledgement Escalated Case'){
						wrapper.HWS_EntitlementException = 'Verifying Warranty';
					}else{
						wrapper.HWS_EntitlementException = HWS_OrderConfirmationNotification.getWarrantyStatusandOrderStatusForPortal(c);
					}
				}else{
				   wrapper.HWS_EntitlementException = c.HWS_EntitlementException__c; 
				}
	caseList.add(wrapper);
			}}
			return caseList;
		}
		
		
	public class CaseWrapper {
		public String CaseNumber { get; set; }
		public String HWS_Part_Code { get; set; }
		public String HWS_Sellable_ProductName { get; set;}
		public String HWS_Faulty_Serial_Number { get; set; }
		public String HWS_EntitlementException { get; set; }
		public String HWS_ServiceType { get; set; }
		public String HWS_Customer_Reference_Number { get; set; }
	}
	//added for HWSDDP-99
	public Id quotationId{get;set;}
	public class QuotationWrapper {
		public String QuoteNumber { get; set; }
		public String RmaNumber { get; set; }
		public String ChildCaseNumber { get; set; }
		public String PartNumber { get; set;}
		public String PartDescription { get; set; }
		public String FaultySerialNumber { get; set; }
		public String QuoteStatus { get; set; }
		public String QuoteOwner { get; set; }
		public String QuoteType { get; set; }
	}
	public List<QuotationWrapper> getQuotation(){
		List<QuotationWrapper> quoteList = new List<QuotationWrapper>();
		for(HWS_Service_Quote__c sq : [SELECT Id,Name,HWS_Support_Ticket__c,HWS_Support_Ticket__r.CaseNumber,HWS_Support_Ticket__r.HWS_Part_Code__c,HWS_RMA_Number__c,
							HWS_Support_Ticket__r.HWS_Sellable_Product__r.Name,HWS_Support_Ticket__r.HWS_Faulty_Serial_Number__c,HWS_Quote_Status__c,Owner.Name,RecordType.Name
								FROM HWS_Service_Quote__c WHERE Id=: quotationId]){
			QuotationWrapper quoteWrap = new QuotationWrapper();   
			quoteWrap.QuoteNumber = sq.Name;
			quoteWrap.RmaNumber = sq.HWS_RMA_Number__c;
			quoteWrap.ChildCaseNumber = sq.HWS_Support_Ticket__r.CaseNumber;
			quoteWrap.PartNumber = sq.HWS_Support_Ticket__r.HWS_Part_Code__c;
			quoteWrap.PartDescription = sq.HWS_Support_Ticket__r.HWS_Sellable_Product__r.Name;
			quoteWrap.FaultySerialNumber = sq.HWS_Support_Ticket__r.HWS_Faulty_Serial_Number__c; 
			quoteWrap.QuoteStatus = sq.HWS_Quote_Status__c;
			quoteWrap.QuoteOwner = sq.Owner.Name;
			quoteWrap.QuoteType = sq.RecordType.Name;
			quoteList.add(quoteWrap);
		}
		return quoteList;
	}
	 /*******************************************************
	* Method Name : serviceQuoteWGAssignmentEmail 
	* Description : sends email to all workgroup members when 
					WG is changed and owner is CH Queue
					created for HWSDDP-99
	*********************************************************/ 
	public static void serviceQuoteWGAssignmentEmail(List<HWS_Service_Quote__c> servQuoteWgAssignmentLst){
		List<Id> quotationIdLst = new List<Id>();
		for(HWS_Service_Quote__c sq : servQuoteWgAssignmentLst ){
			quotationIdLst.add(sq.Id);
		}
		//get details of Service quote and related case
		Map<Id,HWS_Service_Quote__c> servQuoteMap = new Map<Id,HWS_Service_Quote__c>([SELECT Id,Name,HWS_RMA_Number__c,HWS_Support_Ticket__c,HWS_Account_Name__c,HWS_Support_Ticket__r.CaseNumber,HWS_Support_Ticket__r.HWS_Part_Code__c,CreatedDate,HWS_Workgroup__r.Name,HWS_Workgroup__c,
					HWS_Support_Ticket__r.Description,HWS_Support_Ticket__r.HWS_Faulty_Serial_Number__c,HWS_Quote_Status__c,Owner.Name,RecordType.Name,HWS_Support_Ticket__r.NCP_Service_Contract__c,HWS_Support_Ticket__r.NCP_Service_Contract__r.Name,HWS_Support_Ticket__r.Account.Name
					FROM HWS_Service_Quote__c WHERE Id IN : quotationIdLst]);
		List<Id> wgIdList = new List<Id>();
		for(HWS_Service_Quote__c sq : servQuoteMap.values()){
			wgIdList.add(sq.HWS_Workgroup__c);
		}	
		Map<Id,String> wgUserEmailMap = new Map<Id,String>();
		List<CH_Workgroup_Member__c> wgMemberList = [SELECT Id,CH_User__c,CH_User__r.Email,CH_Workgroup__c,CH_Workgroup__r.CH_Type__c,CH_Queue_Email__c FROM CH_Workgroup_Member__c WHERE CH_Workgroup__c IN : wgIdList AND CH_Workgroup_Member_Type__c = 'Queue'];
		if(!wgMemberList.isEmpty()){
			for(CH_Workgroup_Member__c wgm : wgMemberList){
				wgUserEmailMap.put(wgm.CH_Workgroup__c,wgm.CH_Queue_Email__c);
			}
		} 
		List<CH_EmailAlert__c> emailAlertList = new List<CH_EmailAlert__c>();
		for(Id quote : quotationIdLst){
			CH_EmailAlert__c createEmail = new CH_EmailAlert__c();
			createEmail.CH_Bind3__c = servQuoteMap.get(quote).HWS_RMA_Number__c;
			createEmail.CH_Bind5__c = servQuoteMap.get(quote).HWS_Workgroup__r.Name;
			createEmail.CH_Bind1__c = servQuoteMap.get(quote).Id ;
			createEmail.CH_Bind2__c = servQuoteMap.get(quote).Name;
			createEmail.CH_Bind4__c = servQuoteMap.get(quote).HWS_Support_Ticket__c;
			createEmail.CH_Bind10__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.CaseNumber;
			createEmail.CH_Bind6__c = servQuoteMap.get(quote).CreatedDate.format('yyyy-MM-dd');
			createEmail.CH_Bind7__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Account.Name;
			createEmail.CH_Bind8__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.NCP_Service_Contract__c;
			createEmail.CH_Bind9__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.NCP_Service_Contract__r.Name;
			createEmail.CH_BindEmail1__c = wgUserEmailMap.get(servQuoteMap.get(quote).HWS_Workgroup__c);
			createEmail.CH_EmailAlertName__c = 'HWS_Quotation_WG_Assignment_Email';
			if(createEmail.CH_BindEmail1__c != ''){
				emailAlertList.add(createEmail);
			}
		}	   
		if(emailAlertList.size()>0 && !Test.isRunningTest()){
			try{
				Database.insert(emailAlertList,false);
			} catch(Exception e){
				System.debug('Exception'+e.getMessage());
			}
		}	
	}

	/*******************************************************
	* Method Name : ownerReAssignmentEmail 
	* Description : sends email to new quote owner when 
				   owner is reassigned, created for HwSDDP-99
	*********************************************************/ 
	public static void ownerReAssignmentEmail(List<Id> quotationIdLst){
		//get details of Service quote and related case
		Map<Id,HWS_Service_Quote__c> servQuoteMap = new Map<Id,HWS_Service_Quote__c>([SELECT Id,Name,HWS_RMA_Number__c,HWS_Support_Ticket__c,HWS_Account_Name__c,HWS_Support_Ticket__r.CaseNumber,HWS_Support_Ticket__r.HWS_Part_Code__c,CreatedDate,HWS_Workgroup__r.Name,HWS_Workgroup__c,
					HWS_Support_Ticket__r.Description,HWS_Support_Ticket__r.HWS_Faulty_Serial_Number__c,HWS_Quote_Status__c,Owner.Name,Owner.Email,RecordType.Name,HWS_Support_Ticket__r.NCP_Service_Contract__c,HWS_Support_Ticket__r.NCP_Service_Contract__r.Name,HWS_Support_Ticket__r.Account.Name,
					HWS_Support_Ticket__r.Contact.Name,HWS_Support_Ticket__r.ContactId,HWS_Support_Ticket__r.Contact.MobilePhone,HWS_Support_Ticket__r.Contact.Phone,HWS_Support_Ticket__r.Contact.Email,HWS_Support_Ticket__r.Contact.Account.Name
					FROM HWS_Service_Quote__c WHERE Id IN : quotationIdLst]);
		List<CH_EmailAlert__c> emailAlertList = new List<CH_EmailAlert__c>();
		for(Id quote : quotationIdLst){
			CH_EmailAlert__c createEmail = new CH_EmailAlert__c();
			createEmail.CH_Bind1__c = servQuoteMap.get(quote).Owner.Name;
			createEmail.CH_Bind2__c = servQuoteMap.get(quote).HWS_RMA_Number__c;
			createEmail.CH_Bind3__c = servQuoteMap.get(quote).Name;
			createEmail.CH_Bind4__c = servQuoteMap.get(quote).Id ;
			createEmail.CH_Bind5__c = servQuoteMap.get(quote).HWS_Support_Ticket__c;
			createEmail.CH_Bind_17__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.CaseNumber;
			createEmail.CH_Bind6__c = servQuoteMap.get(quote).CreatedDate.format('yyyy-MM-dd');
			createEmail.CH_Bind7__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Account.Name;
			createEmail.CH_Bind8__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Contact.Account.Name;
			createEmail.CH_Bind9__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Contact.Name;
			createEmail.CH_Bind10__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Contact.Phone;
			createEmail.CH_Bind11__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Contact.MobilePhone;
			createEmail.CH_Bind12__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.Contact.Email;
			createEmail.CH_Bind13__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.NCP_Service_Contract__c;
			createEmail.CH_Bind_16__c = servQuoteMap.get(quote).HWS_Support_Ticket__r.NCP_Service_Contract__r.Name;
			createEmail.CH_BindEmail1__c = servQuoteMap.get(quote).Owner.Email;
			createEmail.CH_EmailAlertName__c = 'HWS_Quotation_Owner_ReAssignment_Email';
			if(createEmail.CH_BindEmail1__c != ''){
				emailAlertList.add(createEmail);
			}
		}	   
		if(emailAlertList.size()>0 && !Test.isRunningTest()){
			try{
				Database.insert(emailAlertList,false);
			} catch(Exception e){
				System.debug('Exception'+e.getMessage());
			}
		}
	}
}