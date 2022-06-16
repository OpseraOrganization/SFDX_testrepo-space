/****************************************
* Class Name : CH_ProcessOpenLegacyCasesBatch
* Created Date: 28th Feb 2020
* Created By : TCS
*
*****************************************/
global with sharing class CH_ProcessOpenLegacyCasesBatch implements Database.Batchable<sObject>, Schedulable {
	global List<Interface_Log__c> logs = new List<Interface_Log__c>();
	global Database.QueryLocator start(Database.BatchableContext BC){
		//String query = 'select id, Status, AccountId, CH_Solution__c, CH_ProductName__c, CH_ServiceContractNumber__c, CH_CARES_ServiceAgreement__c , AssetId, CH_Product_Release__c, CH_RDInterface__c, CH_ProductVariant__c,CH_ActionTaken__c,CH_CauseoftheIncident__c, CH_CorrectiveActions__c, CH_CustomerDescription__c, CH_Defect__c, CH_InitialDiagnosis__c, CH_InitialResponse__c,CH_IssueDescription__c, CH_LegacyCaseNumber__c, CH_ListofContributingCauses__c, CH_Outage__c, CH_PreventiveActions__c, CH_ProblemStatement__c,CH_Product_Code_CAPS__c, CH_RecordTypeCheck__c, CH_RecordTypeDevName__c, CH_RestorationMethod__c, CH_SequenceOfEvents__c, CH_ServiceType__c, CH_SolutionDetails__c,CH_Summary__c, CH_SummaryofAnalysis__c, CH_TechnicalAnalysis__c, CH_TemporarySolution__c, Comment__c, Country__c, Description, EntitlementId, HWS_DeliveryNote__c,ProductId, Severity__c, Subject,CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c, RecordTypeId, RecordType.developername,Account.Region__c, Account.Country__c,CH_Reassignment__c, NCP_Service_Contract__r.Name, BusinessHoursId,CH_SystemRestored__c,CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c, CH_Workgroup__r.CH_Type__c, CH_Product_Module__c, ParentId, CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_Rep_CDBContractType__c,OwnerId,Entitlement.ServiceContractId,CH_Originating_Incident_Number__r.Country__c, CH_Originating_Incident_Number__r.AccountId from case where HWS_DeliveryNote__c=null and CH_LegacyCaseNumber__c != null and CH_LegacyCaseStatus__c=\'Open\' and CH_RecordTypeCheck__c=True';
		//System.debug(query);
		//Using Custom Metadata CH_LegacyCasesBatchQuery to make this query configurable
		CH_LegacyCasesBatchQuery__mdt openLegacyCasesBatchQuery = [Select CH_LegacyCasesBatchQuery__c from CH_LegacyCasesBatchQuery__mdt where Label= 'Open'];
		String query = openLegacyCasesBatchQuery.CH_LegacyCasesBatchQuery__c;
		System.debug(query);
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<Case> newCaseList){
		System.debug(newCaseList);
		CH_CaseTriggerHelper.fetchCaseFields(newCaseList, null);
		CH_SecurityUtils.setCaseSecurityGroups(newCaseList, null);
		System.debug('Security Groups set...');
		CH_CaseTriggerHelper.setEmailTypes(newCaseList);
		 /*To update CH_BlockCases__c field as true -- For 32408*/
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
		 /*To update CH_BlockCases__c field as true -- For 32408*/

			/* Open case migration--For 30554*/
			CH_CaseTriggerHelper.populateCaseFields(new Map <Id,Case>(),newCaseList);
			List < CaseMilestone > compList = new list<CaseMilestone>([SELECT Id, startdate,IsCompleted,CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestone WHERE CaseId IN :newCaseList and IsCompleted = True ]);
			for(CaseMilestone comple:compList){
			comple.startdate=comple.startdate+0.001;
			}
			update compList;
/* Open case migration--For 30554*/

		CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), new Map<Id, Case>(), true, false);
		for(Case newCase : newCaseList ){
			newCase.HWS_DeliveryNote__c='processed';
			newCase.SlaStartDate = newCase.CH_MilestoneSLA_Start__c;

			//Update product details method replicated below -- NOKIASC-28485 
			if(newCase.AssetId != null){
				newCase.CH_Solution__c = (newCase.Asset.CH_Solution__c != null) ? newCase.Asset.CH_Solution__c : newCase.CH_Solution__c;
				newCase.ProductId = (newCase.Asset.Product2Id != null) ? newCase.Asset.Product2Id : newCase.ProductId;
				newCase.CH_ProductName__c = (newCase.Asset.Product2Id != null) ? newCase.Asset.Product2Id : newCase.CH_ProductName__c;
				newCase.CH_Product_Release__c = (newCase.Asset.CH_ProductRelease__c != null) ? newCase.Asset.CH_ProductRelease__c : newCase.CH_Product_Release__c;		
				newCase.CH_ProductVariant__c = (newCase.Asset.CH_ProductVariant__c != null) ? newCase.Asset.CH_ProductVariant__c : newCase.CH_ProductVariant__c;
			}
		}
		// Miguel Silva - Route cases to WG based on WG Rules - NOKIASC-27920
		// If we want to bypass the before update block
		CH_AvoidRecursion.runBeforeUpdateOnce();
		// If we want to bypass the after update block
		CH_AvoidRecursion.runAfterUpdateOnce();
		CH_CA_Service service = new CH_CA_Service();
		for(Case legacyCase : newCaseList){
			service.currentCase = legacyCase;
			CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = service.getCaseDetails();
			CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
			CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(caseFieldsDTO, true);
			
			legacyCase.CH_Workgroup__c = caseDetails.validWorkgroupRules[0].CH_Workgroup__c;
			system.debug('legacyCase id --> ' + legacyCase.Id);
		}
		
		Database.SaveResult[] caseList = Database.update(newCaseList,false);
		Integer i=0;
		for(Database.SaveResult a : caseList){
			if(!a.isSuccess()){
				for(Database.Error err : a.getErrors()) {
					logs.add(new Interface_Log__c(
						Comment__c = 'Error with the Case with Id: ' +newCaseList.get(i).Id + '--> ' + err.getMessage(),
						Interface_Type__c = 'Open Legacy Case Error'
					));
				}
			}
			i++;
		}
		
		Database.insert(logs,false);
		
		
		//To update completion date of Open legacy cases:Suniti Code starts
		//
		
		if(newCaseList != null && !newCaseList.isEmpty()) {
			Map < Id, Case > newCaseMap = new Map < Id, Case > (newCaseList);			   
			
			List < CaseMilestone > cmList = new list<CaseMilestone>([SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestone WHERE CaseId IN :newCaseMap.keySet()]);
			if(cmList != null && !cmList.isEmpty()) {
				for(CaseMilestone cmObj: cmList) {
					Case caseObj = newCaseMap.get(cmObj.CaseId);
					if(caseObj != null && String.isNotBlank(cmObj.MilestoneTypeId)) {						
						if(caseObj.CH_InitialResponse__c !=null){
							if(cmObj.MilestoneType.Name == System.Label.CH_LegacyInitialResponse) {
								cmObj.CompletionDate = caseObj.CH_InitialResponse__c;
							}}
						if(caseObj.CH_SystemRestored__c !=null){
							if(cmObj.MilestoneType.Name == System.Label.CH_LegacySystemRestored) {
								cmObj.CompletionDate = caseObj.CH_SystemRestored__c;
							}}
						if(caseObj.CH_TemporarySolutionProvided__c !=null){
							if(cmObj.MilestoneType.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
								cmObj.CompletionDate = caseObj.CH_TemporarySolutionProvided__c;
							}}
						if(caseObj.CH_SolutionProvided__c !=null){
							if(cmObj.MilestoneType.Name == System.Label.CH_LegacySolutionProvided) {
								cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
							}}						
					} }				
				update cmList;			
			}
			
			Database.SaveResult[] cmsList =Database.update(cmList,false);
			Integer j=0;
			for(Database.SaveResult a : cmsList){
				if(!a.isSuccess()){
					for(Database.Error err : a.getErrors()) {
						logs.add(new Interface_Log__c(
							Comment__c = 'Error with the Case Milestone with Id: ' +cmList.get(j).Id + '--> ' + err.getMessage(),
							Interface_Type__c = 'Open Legacy Case Milestone Error'
						));
					}
				}
	j++;
			}
			
			Database.insert(logs,false);
		}
		//
		//Suniti code ends
		
		
		
	}
	global void finish(Database.BatchableContext BC){
		//schedule this batch class.
	}
	global void execute(SchedulableContext SC){
		CH_ProcessOpenLegacyCasesBatch  batch = new CH_ProcessOpenLegacyCasesBatch();
		Database.executebatch(batch,50);   
	}
}