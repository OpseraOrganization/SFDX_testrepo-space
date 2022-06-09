/****************************************
* Name : HWS_BulkUpload_Batch
* Author : TCS
* Description : This class is for inserting case records from bulk component. It is first inserting all parents and then its child. After that it calles SOO. All the exceptions are logged to HWS_BulkUpload__c records. Use Commects__c filed to retry.
* SOO is called in a bactch class HWS_BulkUpload_SOOCallout_Batch. 
* Test class : HWS_BulkUpload_Batch_Test 
* ReqNo : NOKIASC-37921
****************************************/
public without sharing class HWS_BulkUpload_Batch implements Database.batchable < sObject>, Database.AllowsCallouts,  Database.Stateful, Database.RaisesPlatformEvents{
	public String sReferenceNumber ='';
	public String sActionType ='';
	public String sServiceType = '';
	public List<string> lstError = new List<string>();
	public Map<string ,Id > stParentId =new Map<string ,Id>();
	  
	//public Map<String, Case> contractNumCaseIdMap = new Map<String, Case>();
	public Map<String, String> tempserviceContractIdWithRetrtTypeMap = new Map<String, String>();
	public Integer iParentCount=0;
	public Integer iEexecuteCount = 1;
	public string sCaseFields='';
	public boolean isPending;
	public Id accountId;
	public Id contactId;
	public Id childCaseRecordTypeId;
	public string sTransactionTypeNew;
	 Set<String> contractIdSet = new Set<String>();
	 public string sTransactionType='';
	 public set<id> insertedParentCaseId = new set<Id>();
	 public list<id>lstIds = new List<Id>(); 

	public HWS_BulkUpload_Batch(String sReferenceNumberValue, String sActionTypeValue, String serviceType, Boolean Pending, Id saccountId, Id scontactId, integer parentCount, string transactionType, set<id> allParentCaseId ){
		this.sReferenceNumber = sReferenceNumberValue;
		this.sActionType = sActionTypeValue; 
		this.sServiceType = serviceType;
		this.isPending = Pending;
		this.accountId = saccountId;
		this.contactId = scontactId;
		this.iParentCount = parentCount;
		this.sTransactionType = transactionType;
		if(allParentCaseId != null)
			this.insertedParentCaseId = allParentCaseId;
		 
		set<Id>parentCases = new set<Id>();
		for(HWS_BulkUpload__c bu :[SELECT Support_Ticket__c,HWS_Service_Contract_Number__c,NCP_Service_Contract__c FROM HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c=:sReferenceNumberValue]){
			parentCases.add(bu.Support_Ticket__c);
			if (bu.NCP_Service_Contract__c != null) {
							this.contractIdSet.add(bu.NCP_Service_Contract__c);	
					} 
			}
			this.lstIds.addall(parentCases);
		
		
		
		if(serviceType == 'Advanced Exchange in Days'){ 
			this.childCaseRecordTypeId = HWS_Utilty.exchangeInDays;
		} else if(serviceType == HWS_Constants.IR || serviceType == 'Return for Repair or Replacement'){
			this.childCaseRecordTypeId = HWS_Utilty.rfr;
		}
		if (contractIdSet.size() > 0) {
			for (servicecontract sc : [SELECT Id, HWS_Retrofit_Type__c FROM servicecontract WHERE Id IN :contractIdSet]) {
				this.tempserviceContractIdWithRetrtTypeMap.put(String.valueof(sc.Id), sc.HWS_Retrofit_Type__c);	
			}	
		}  
	 /*   for(HWS_BulkUpload__c bu :[SELECT Support_Ticket__c,HWS_Service_Contract_Number__c FROM HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c=:sReferenceNumberValue]){
			this.parentCases.add(bu.Support_Ticket__c);
			}
			if( bu.Support_Ticket__c != NULL)
				this.stParentId.put(bu.HWS_Service_Contract_Number__c, bu.Support_Ticket__c);
			if(this.childCount.containsKey(HWS_Service_Contract_Number__c))
				this.childCount.put(bu.HWS_Service_Contract_Number__c,this.childCount.get(HWS_Service_Contract_Number__c)+1 );
			else
				this.childCount.put(bu.HWS_Service_Contract_Number__c, 1);
		} */
		
	}

	public Database.QueryLocator  start(Database.BatchableContext bc) {
		string sSOQL ='';
		try{
			string sAllFields = 'Select id,HWS_PO_Number__c, HWS_Asset__r.HWS_ContractLineItem__r.Id,HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_Asset__r.HWS_ContractLineItem__r.Asset.Product2.Name,HWS_Asset__r.Product2.Name,HWS_Asset__r.HWS_ContractLineItem__r.CH_ServiceOffering__c, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Bulk_Version_Item__c ,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c, Warranty_Verification_Required__c,HWS_Site_Information__c,Support_Ticket__c,HWS_Asset__r.HWS_SourceSystem__c,HWS_Bulk_Version_Item__r.HWS_Source__c from HWS_BulkUpload__c ';
			String selects = '';
			string objectName ='Case';
			// Get a map of field name and field token
			Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
			list<string> selectFields = new list<string>();		
			if (fMap != null){
				for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
					Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
					//if (fd.isCreateable()){ // field is creatable
					selectFields.add(fd.getName());
					//}
				}
			}		
			if (!selectFields.isEmpty()){
				for (string s:selectFields){
					selects += s + ',';
				}
				if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
				
			}
			
			this.sCaseFields = selects;
			
			string[] srTT = this.sTransactionType.split('0');
			if(srTT.size()== 2)
				this.sTransactionType = srTT[1];
			if(this.sTransactionType !='Parentinsert' && srTT[0] != 'retry'){ 
						 
				sSOQL = sAllFields+' WHERE HWS_Job_Update__c=\'Queued\' and Support_Ticket__c IN : insertedParentCaseId';
			}
			else if(srTT[0] == 'retry'){
				this.sTransactionTypeNew =   srTT[0];				
				sSOQL = sAllFields+' WHERE HWS_Bulk_Reference_Number__c =:sReferenceNumber and HWS_Job_Update__c!=\'Success\'';
			   
			}
			else{			 
				sSOQL =  sAllFields+' WHERE HWS_Job_Update__c=\'Queued\' and Support_Ticket__c='+'\''+this.lstIds[iParentCount]+'\'';
			}
	
			return Database.getQueryLocator(sSOQL);
		}
		catch(Exception e){
			this.logError(null, 'start', null, 'Exception type -'+e.getTypeName()+' - Error line -'+e.getLineNumber()+' - Message - '+e.getMessage()+' - Stack Trace '+e.getStackTraceString() , null, string.valueof(this.lstIds[iParentCount]),'HWS_BulkUpload_Batch('+this.sReferenceNumber+', '+this.sActionType+', '+this.sServiceType+', '+this.isPending+', '+this.accountId+', '+this.contactId+', '+this.iParentCount+', retry0'+this.sTransactionType +', null )');
			return Database.getQueryLocator(sSOQL);
		}
		
	}   
	
	public void execute(Database.BatchableContext batchableContext, List<HWS_BulkUpload__c> lstBU){
		try{
			
			List<case>directInsertChildCases = new List<case>();
			List<case>insertChildCases = new List<case>();
			List<HWS_BulkUpload__c> updateBU = new List<HWS_BulkUpload__c>();
			List<Case> zoneCaseList = new List<Case>();
			
			this.insertedParentCaseId.add(this.lstIds[iParentCount]);
			if(lstBU.size()>0){
				if(this.sTransactionType =='Childinsert' ){
					for(HWS_BulkUpload__c bu :lstBU){
						case cdCase = formateChildCases(bu);
						directInsertChildCases.add(cdCase); 
						
					}
					if(directInsertChildCases.size()>0){
						zoneCaseList = HWS_CreateSupportTicketportal.timeZoneUpdateCaseList(directInsertChildCases);
						Database.SaveResult[] srList = Database.insert(zoneCaseList, false);
					// insert zoneCaseList;
							
					}			   
				}
				else if(this.sTransactionType =='Parentinsert' && this.iEexecuteCount > 1){
						string query = 'SELECT Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingCountry,Hws_Ship_to_Party_Address__r.BillingPostalCode, ' +sCaseFields+' FROM Case  WHERE Id='+'\''+this.lstIds[iParentCount]+'\'';
						Case parentCase = Database.query(query);
						Case c = parentCase.Clone(false,false,false,false);
						
						database.insert(c, true);
						//insert c;
						
						this.insertedParentCaseId.add(c.id);
						for(HWS_BulkUpload__c bu :lstBU){
							bu.Support_Ticket__c = c.id;					
							updateBU.add(bu);
						}					
						update updateBU ; 
				}
			}			
		}
		catch(Exception e){
			this.logError(this.sTransactionType, 'execute', batchableContext.getChildJobId(), 'Exception type -'+e.getTypeName()+' - Error line -'+e.getLineNumber()+' - Message - '+e.getMessage()+' - Stack Trace '+e.getStackTraceString() , lstBU, null,'HWS_BulkUpload_Batch('+this.sReferenceNumber+', '+this.sActionType+', '+this.sServiceType+', '+this.isPending+', '+this.accountId+', '+this.contactId+', '+this.iParentCount+', retry0'+this.sTransactionType +', null )');
		}
		finally{
			this.iEexecuteCount = this.iEexecuteCount+1;
		} 
		
	
	}
	
	public void finish(Database.BatchableContext batchableContext) {
		try{
			HWS_GenericSettings__c record = HWS_GenericSettings__c.getValues('HWS_BulkUploadBachSize');
			string BatchSize ;
			if(record == null)
				BatchSize = '25';
			else
				BatchSize= (string) record.get('HWS_Field1__c');
			if(this.lstIds.size() > this.iParentCount+1 && this.sTransactionType =='Parentinsert'){
				
				this.iParentCount = this.iParentCount+1;
				HWS_BulkUpload_Batch runAgain= new HWS_BulkUpload_Batch(this.sReferenceNumber, this.sActionType, this.sServiceType, this.isPending,this.accountId, this.contactId,this.iParentCount,this.sTransactionType, this.insertedParentCaseId);
				Database.executeBatch(runAgain,integer.valueof(BatchSize));
			}
			else if(this.lstIds.size() == this.iParentCount+1 && this.sTransactionType =='Parentinsert' ){
			
				this.iParentCount = 0;
				HWS_BulkUpload_Batch runAgain= new HWS_BulkUpload_Batch(this.sReferenceNumber, this.sActionType, this.sServiceType, this.isPending,this.accountId, this.contactId,this.iParentCount,'Childinsert', this.insertedParentCaseId);
				Database.executeBatch(runAgain,integer.valueof(BatchSize));
			}
			else if(this.sTransactionType =='Childinsert'  ){
				List<case> lstCS = [SELECT ID,Reference_Number__c  FROM Case WHERE ID IN:this.insertedParentCaseId ];
				List<case> updateCS = new List<case>();
				for(case c : lstCS){
					if(c.Reference_Number__c  == '' || c.Reference_Number__c  == null){
						c.Reference_Number__c  = this.sReferenceNumber;
						updateCS.add(c);
					}
				}
			 
				List <Database.SaveResult> updateCSResults = Database.update(updateCS, false);
				map<id, string >faildCases = new map<id, string >();
				for (Integer i = 0; i < updateCS.size(); i++) {
					Database.SaveResult s = updateCSResults[i];
					case origRecord = updateCS[i];
					if (!s.isSuccess()) {
						faildCases.put(origRecord.Id, s.getErrors()[0].getStatusCode() + ' - ' + s.getErrors()[0].getMessage()) ;  
						
					} 
				}
				string sSOQLData = '';
				if(this.sTransactionTypeNew != 'retry')
					sSOQLData = 'SELECT id, HWS_Error_Message__c, HWS_Job_Update__c,Support_Ticket__c from HWS_BulkUpload__c WHERE (Support_Ticket__c IN:insertedParentCaseId and HWS_Job_Update__c !=\'Success\' and HWS_Job_Update__c !=\'Error\')';
				else
					sSOQLData = 'SELECT id, HWS_Error_Message__c, HWS_Job_Update__c,Support_Ticket__c from HWS_BulkUpload__c WHERE  HWS_Bulk_Reference_Number__c =:sReferenceNumber and HWS_Job_Update__c!=\'Success\'';
					
				List<HWS_BulkUpload__c>tempBU = database.query(sSOQLData);   
				List<HWS_BulkUpload__c>lstUpdateBU = new List<HWS_BulkUpload__c> ();	  
				for(HWS_BulkUpload__c bu : tempBU){
					if(String.isBlank(faildCases.get(bu.Support_Ticket__c))){
						bu.HWS_Job_Update__c = 'Success';
						bu.HWS_Error_Message__c = 'Ok';
						lstUpdateBU.add(bu);
					}
					else{
						bu.HWS_Job_Update__c = 'Success';
						bu.HWS_Error_Message__c = 'Unable to tag the reference number to case beacuse --'+faildCases.get(bu.Support_Ticket__c);
						lstUpdateBU.add(bu);
					}
				}
				update lstUpdateBU;
				if(this.sActionType == 'Submit'){
					HWS_BulkUpload_SOOCallout_Batch cls = new HWS_BulkUpload_SOOCallout_Batch(this.insertedParentCaseId,'Submit');				   
					Database.executeBatch(cls, 1);
				}
				else if(this.sActionType == 'SaveReview'){				
					HWS_BulkUpload_SOOCallout_Batch cls = new HWS_BulkUpload_SOOCallout_Batch(this.insertedParentCaseId,'SaveReview');				   
					Database.executeBatch(cls, 1);			 
				}
				
			}
		}
		 catch(Exception e){
			this.logError(this.sTransactionType, 'finish', null, 'Exception type -'+e.getTypeName()+' - Error line -'+e.getLineNumber()+' - Message - '+e.getMessage()+' - Stack Trace '+e.getStackTraceString() , null, null,'HWS_BulkUpload_Batch('+this.sReferenceNumber+', '+this.sActionType+', '+this.sServiceType+', '+this.isPending+', '+this.accountId+', '+this.contactId+', '+this.iParentCount+', retry0'+this.sTransactionType +', null )');
		} 
	}

   
	public case formateChildCases(HWS_BulkUpload__c bu){
	case childCase = new case();
	if ((bu.Warranty_Verification_Required__c != 'Yes' && isPending || (bu.Warranty_Verification_Required__c == 'Yes' && !isPending))) {
		if(bu.HWS_Part_Revision__c == 'ANY'){	 
			childCase.HWS_Customer_Part_Revision__c = (bu.Part_Code_Part_Revision__c.remove(bu.HWS_Part_Code__c));  
			if(childCase.HWS_Customer_Part_Revision__c.startsWith('-') || childCase.HWS_Customer_Part_Revision__c.startsWith('.') || childCase.HWS_Customer_Part_Revision__c.startsWith(':') || childCase.HWS_Customer_Part_Revision__c.startsWith('/') || childCase.HWS_Customer_Part_Revision__c.startsWith(',')){	 
				childCase.HWS_Customer_Part_Revision__c = childCase.HWS_Customer_Part_Revision__c.substring(1, childCase.HWS_Customer_Part_Revision__c.length());	 
				if(childCase.HWS_Customer_Part_Revision__c.startsWith('-')){
					childCase.HWS_Customer_Part_Revision__c = childCase.HWS_Customer_Part_Revision__c.substring(1, childCase.HWS_Customer_Part_Revision__c.length());	 
				}	 
			}	 
		}
		childCase.RecordTypeId = this.childCaseRecordTypeId;
			List<case> cs = [SELECT Id,CaseNumber,HWS_Contract_Number__c,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,Hws_Ship_to_Party_Address__c,HWS_ShipmentRecipientEmailId__c,HWS_Shipment_Recipient_Name__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry FROM Case WHERE Id = :bu.Support_Ticket__c];
			if(cs.size()>0 ){
				case c = cs[0];
				childCase.ParentId = c.Id;
				childCase.HWS_Parent_case_Number__c = c.CaseNumber;
				childCase.Hws_Ship_to_Party_Address__c = c.Hws_Ship_to_Party_Address__c;
				childCase.HWS_ShipmentRecipientEmailId__c = c.HWS_ShipmentRecipientEmailId__c;
				childCase.HWS_Shipment_Recipient_Name__c = c.HWS_Shipment_Recipient_Name__c;		 
				childCase.Comment__c = (c.HWS_Shipment_Recipient_Name__c==null ? ' ' :c.HWS_Shipment_Recipient_Name__c+',\n')+
					(c.Hws_Ship_to_Party_Address__r.BillingStreet==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingStreet+'\n')+
					(c.Hws_Ship_to_Party_Address__r.BillingCity==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingCity+',\n')+
					(c.Hws_Ship_to_Party_Address__r.BillingState==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingState+',\n')+
					(c.Hws_Ship_to_Party_Address__r.BillingCountry==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingCountry+',\n')+
					(c.Hws_Ship_to_Party_Address__r.BillingPostalCode==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingPostalCode+'.');
				childCase.CH_GWC_SecurityGroup__c = c.CH_GWC_SecurityGroup__c;  
				childCase.CH_SecurityGroup__c	= c.CH_SecurityGroup__c;
			   
			}
			
		
		childCase.NCP_Service_Contract__c = bu.NCP_Service_Contract__c;
		childCase.AccountId = this.accountId;
		childCase.ContactId = this.contactId;
		
		if(bu.HWS_NetworkElementAsset__c !=null){
			childCase.CH_NetworkElementAsset__c=bu.HWS_NetworkElementAsset__c;
		}
		if (!tempserviceContractIdWithRetrtTypeMap.isEmpty() && (tempserviceContractIdWithRetrtTypeMap.get(bu.NCP_Service_Contract__c) == 'Global Retrofit' || 
		tempserviceContractIdWithRetrtTypeMap.get(bu.NCP_Service_Contract__c) == 'Local Retrofit')) {
			childCase.CH_ServiceType__c='Internal Support';
		
		}
		childCase.AssetId = bu.HWS_Asset__c;	
		childCase.HWS_Part_Code__c = bu.HWS_Part_Code__c;
		//Added for single email
		
		childCase.HWS_Customer_Reference_Number__c = bu.Customer_Reference_Number__c;
		childCase.HWS_ServiceType__c = this.sServiceType;
		childCase.HWS_Part_Code__c = bu.HWS_Part_Code__c;
		 if(bu.HWS_Asset__r.HWS_SourceSystem__c != bu.HWS_Bulk_Version_Item__r.HWS_Source__c && bu.HWS_Asset__r.HWS_SourceSystem__c =='PUMA2'){
			List<HWS_VersionItem__c> lstId = [select Id from HWS_VersionItem__c where HWS_Hardware_Sellable_Item__c=:bu.HWS_Sellable_Product__c and HWS_Source__c='PUMA2' limit 1];
			if( lstId.size()> 0)
			 childCase.HWS_Stockable_Product__c = lstId[0].id;
		}			
		else
			childCase.HWS_Stockable_Product__c = bu.HWS_Bulk_Version_Item__c;
		childCase.HWS_Sellable_Product__c = bu.HWS_Sellable_Product__c;	   
		childCase.HWS_Failure_Description__c = bu.Fault_Description__c;
		childCase.HWS_Failure_Detection__c = bu.Fault_Detection__c;
		childCase.HWS_Failure_Detection_Date__c = bu.Fault_Detection_Date__c;
		childCase.HWS_Failure_Occurance__c = bu.Fault_Occurrence__c;
		childCase.HWS_Faulty_Serial_Number__c = bu.Faulty_Serial_number__c;
		childCase.HWS_Fault_Reported_By_Name__c = bu.Fault_Reported_by_Name__c;
		childCase.HWS_Fault_Reported_By_Email__c = bu.Fault_Reported_by_Email__c;
		childCase.HWS_Fault_Reported_By_Phone__c = bu.Fault_Reported_by_Phone__c;
		childCase.HWS_Site_ID__c = bu.Site_Id__c;
		childCase.HWS_Site_Information__c = bu.HWS_Site_Information__c;
		childCase.HWS_Failure_Description_Server_ID__c = bu.Failure_Description_Server_ID__c;
		//HWST-4039 added HWS_Contract_Line_Item__c value
		childCase.HWS_Contract_Line_Item__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.Id;
		//NOKIASC-32497 STARTS
		childCase.NCP_Product_Name__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.Asset.Product2.Name;
		childCase.HWS_Part_Name__c = bu.HWS_Asset__r.Product2.Name;
		childCase.HWS_Service_Offering__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_ServiceOffering__c;
		//NOKIASC-34637
		if(childCase.CH_EntitlementException__c == 'Warranty Status Check Failed'){
			childCase.HWS_WarrantyStatus__c = 'Warranty Unknown';
		}
		////NOKIASC-32497 ENDS
		//35978
		else if(isPending){
			childCase.HWS_WarrantyStatus__c = 'Not Applicable';
			childCase.CH_EntitlementException__c = 'No Exception';
			childCase.CH_EntitlementStatus__c = 'Entitled (Automated Verification)';
			
		}
	} 
		return childCase;
	}

	public void logError(string mode, string method, string batchId, string errorlog, List<HWS_BulkUpload__c> BUs, string PIds, string retry ){
		if( !String.isBlank(method) && !String.isBlank(errorlog)){
			if(method.toLowerCase() == 'start' && !String.isBlank(PIds)){ // For start method
				string sAllFields = 'Select id,HWS_Error_Message__c,Support_Ticket__c, HWS_Job_Update__c from HWS_BulkUpload__c WHERE HWS_Job_Update__c=\'Queued\' and Support_Ticket__c='+'\''+PIds+'\'';  
				List<HWS_BulkUpload__c>  bu =database.query(sAllFields) ;	   
				for(HWS_BulkUpload__c b :bu){
					b.HWS_Job_Update__c ='Error';
					b.HWS_Error_Message__c = 'retry script-'+retry+' -- Batch Id-'+batchId+' - '+errorlog;	
									 
				}	  
				update bu;
			}

			else if(method.toLowerCase() == 'execute' && BUs.size()> 0){ // For execute method				 
				for(HWS_BulkUpload__c b :BUs){
					b.HWS_Job_Update__c ='Error';
					b.HWS_Error_Message__c = 'retry script-'+retry+' -- Batch Id-'+batchId+' - '+errorlog;  
										 
				}	  
				update BUs;
			}
		}
	}
	
}