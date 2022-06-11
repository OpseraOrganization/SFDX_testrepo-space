public without sharing class HWS_ServiceQuoteUtility {
	/***************************************
	* Method Name : createOrLinkSuspensionRecord 
	* Description : Creation or Linking of Suspension record to Service Quote 
	*based on Service Contract and RMA Contact - HWSDDP-76 
	*and sharing of Suspension records to SME3 WG 
	*****************************************/
	public static void createOrLinkSuspensionRecord(Map<Id,HWS_Service_Quote__c> oldMap, Map<Id,HWS_Service_Quote__c> newMap){
		Savepoint sp; 
		Map<String,String> suspensionToWGNameMap = new Map<String,String>();
		try{
			sp = Database.setSavepoint();
			Set<Id> susUpdated=new Set<Id>();
			for(Id sq:newMap.keySet()){
				if(  newMap.get(sq).HWS_Is_Quotable__c =='Yes' && (HWS_Service_Quote_OPT_Status_Mapping__mdt.getInstance(newMap.get(sq).HWS_OPT_OnProcess_Status__c).Is_Suspension_Eligible__c =='Yes') && ((newMap.get(sq).HWS_Is_Quote_Expired__c == true && newMap.get(sq).HWS_Is_Quote_Expired__c != oldMap.get(sq).HWS_Is_Quote_Expired__c )  
				|| (newMap.get(sq).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_REJECTED_CDM && newMap.get(sq).HWS_Quote_Status__c != oldMap.get(sq).HWS_Quote_Status__c) )){
					susUpdated.add(sq);
				}
			}
			List<HWS_Service_Quote__c> servQuoteList = [SELECT Id,HWS_Is_Quotable__c,HWS_OPT_OnProcess_Status__c,Support_Ticket_ServiceContract__c,HWS_Support_Ticket__r.NCP_Service_Contract__c,HWS_Support_Ticket__r.ContactId,HWS_Suspension__c,HWS_Quote_Status__c,HWS_Is_Quote_Expired__c,HWS_Support_Ticket__r.NCP_Service_Contract__r.OwnerId FROM HWS_Service_Quote__c WHERE Id IN :susUpdated];
			Map<HWS_Service_Quote__c,String> quotSusMap=new Map<HWS_Service_Quote__c,String>();
			Map<String,HWS_Service_Quote__c> quotSusMap2=new Map<String,HWS_Service_Quote__c>();
			Set<Id> servContrIds=new Set<Id>();
			Set<Id> rmaContIds=new Set<Id>();
			for(HWS_Service_Quote__c sq : servQuoteList){   
				
				quotSusMap.put(sq,String.valueOf(sq.HWS_Support_Ticket__r.NCP_Service_Contract__c).substring(0, 15)+''+String.valueOf(sq.HWS_Support_Ticket__r.ContactId).substring(0, 15));
				quotSusMap2.put(String.valueOf(sq.HWS_Support_Ticket__r.NCP_Service_Contract__c).substring(0, 15)+''+String.valueOf(sq.HWS_Support_Ticket__r.ContactId).substring(0, 15),sq);
				servContrIds.add(sq.HWS_Support_Ticket__r.NCP_Service_Contract__c);
				rmaContIds.add(sq.HWS_Support_Ticket__r.ContactId);
			}
			List<HWS_Suspension__c> lsp = [SELECT Id,OwnerId,HWS_Suspension_Status__c,HWS_Service_Contract_Name__c,HWS_Contact_Name__c,HWS_Suspension_Start_Date__c,HWS_Suspension_End_Date__c FROM HWS_Suspension__c WHERE HWS_Service_Contract_Name__c IN : servContrIds OR HWS_Contact_Name__c IN : rmaContIds];
			Map<String,HWS_Suspension__c>  CCSuspensionMap=new  Map<String,HWS_Suspension__c>();
			for(HWS_Suspension__c sc : lsp){   
				CCSuspensionMap.put(String.valueOf(sc.HWS_Service_Contract_Name__c).substring(0, 15)+''+String.valueOf(sc.HWS_Contact_Name__c).substring(0, 15),sc);
			}
			if(servQuoteList.size() > 0){
				List<HWS_Suspension__c> updateSus = new List<HWS_Suspension__c>();
				for(HWS_Service_Quote__c ss:servQuoteList){
					if(ss.HWS_Is_Quotable__c == 'Yes' && (ss.HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_REJECTED_CDM || ss.HWS_Is_Quote_Expired__c == true) ){
						HWS_Suspension__c screcord = CCSuspensionMap.get(String.valueOf(ss.HWS_Support_Ticket__r.NCP_Service_Contract__c).substring(0, 15)+''+String.valueOf(ss.HWS_Support_Ticket__r.ContactId).substring(0, 15));
						 if(screcord != null){
							if(screcord.HWS_Suspension_Status__c  == HWS_Constants.SUSPENSION_STATUS_REJECTED|| screcord.HWS_Suspension_Status__c == HWS_Constants.SUSPENSION_STATUS_UNSUSPENDED){  
								screcord.HWS_Suspension_Status__c = HWS_Constants.SUSPENSION_STATUS_PENDING_REVIEW;
								screcord.HWS_Suspension_Start_Date__c = null;
								screcord.HWS_Suspension_End_Date__c= null;
								
							}
							updateSus.add(screcord);
						}
						else{
							HWS_Suspension__c sc = new HWS_Suspension__c(); 
							sc.HWS_Contact_Name__c = ss.HWS_Support_Ticket__r.ContactId;
							sc.HWS_Service_Contract_Name__c = ss.HWS_Support_Ticket__r.NCP_Service_Contract__c;
							sc.HWS_Suspension_Start_Date__c = null;
							sc.HWS_Suspension_End_Date__c = null;
							sc.HWS_Suspension_Status__c = HWS_Constants.SUSPENSION_STATUS_PENDING_REVIEW;
							sc.OwnerId=ss.HWS_Support_Ticket__r.NCP_Service_Contract__r.OwnerId;
							updateSus.add(sc); 
						}
					}  
				}
				if(!updateSus.isEmpty()){
					upsert updateSus;
				}
				List<HWS_Service_Quote__c> quoteUpdateList=new List<HWS_Service_Quote__c>();
				for(HWS_Suspension__c sc : updateSus){
					HWS_Service_Quote__c sqc = quotSusMap2.get(String.valueOf(sc.HWS_Service_Contract_Name__c).substring(0, 15)+''+String.valueOf(sc.HWS_Contact_Name__c).substring(0, 15) );
					sqc.HWS_Suspension__c = sc.id;
					quoteUpdateList.add(sqc);
					if(oldMap.get(sqc.Id).HWS_WorkGroupType__c != System.Label.Exclusions_Quotation_Support_OC){ 
						suspensionToWGNameMap.put(sc.id,oldMap.get(sqc.Id).HWS_WorkgroupName__c); //WG changes to OC when Reject happens, hence taking value from old map for CDM
					}
					
				}
				if(!quoteUpdateList.isEmpty()){
					update quoteUpdateList;
					if(suspensionToWGNameMap.size() > 0){
						insertSuspensionUserShareRecords(suspensionToWGNameMap);
					}
				}
			}
		}
		catch(Exception ex){
			Database.RollBack(sp);
			Interface_Log__c ilog = new Interface_Log__c(Name='Suspense Log',Interface_Type__c='Suspension Log',Message_Type__c='Inbound',Operation_Type__c='Update' ,Status__c='Post Processing Error',Comment__c='Exception'+ex.getCause()+ex.getLineNumber()+ex.getMessage(),DS_Payload__c='Exception'+newMap );
			insert ilog; 
		}
	}
	
	/***************************************
	* Method Name : insertSuspensionUserShareRecords 
	* Description : created SuspensionShare records with SME3 Public group
	*****************************************/
	public static void insertSuspensionUserShareRecords(Map<String,String> suspensionToWGNameMap){
		Map<String,Id> wgNameToGroupMap = new Map<String,Id>();
		for(Group g : [SELECT Id, Name FROM Group WHERE Type ='Regular' and Name IN : suspensionToWGNameMap.values()]){
			wgNameToGroupMap.put(g.Name, g.Id);
		}
		List<HWS_Suspension__Share> suspensionShareList = new List<HWS_Suspension__Share>();
		for(String suspensionId : suspensionToWGNameMap.keySet()){
			HWS_Suspension__Share suspensionShare = new HWS_Suspension__Share();
			suspensionShare.ParentId = suspensionId;
			suspensionShare.UserOrGroupId = wgNameToGroupMap.get(suspensionToWGNameMap.get(suspensionId));
			suspensionShare.AccessLevel = 'Edit';
			suspensionShare.RowCause = Schema.HWS_Suspension__Share.RowCause.SVQ_Workgroup_Team__C;
			suspensionShareList.add(suspensionShare);
		}
		if(suspensionShareList.size() > 0) {
			DML_SObject.doInsert(suspensionShareList, true, true, false);
		}
	}
}