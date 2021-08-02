/****************************************
* Class Name : CH_ProcessClosedLegacyCasesBatch
* Created Date: 28th Feb 2020
* Created By : TCS
* Last Modified by: Prateek Sarangi
*****************************************/
global class CH_ProcessClosedLegacyCasesBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful{
	global List<Interface_Log__c> logs = new List<Interface_Log__c>();
	global Set<Id> caseIds = new Set<Id> ();
	global Database.QueryLocator start(Database.BatchableContext BC){
		//String query = 'select id, Status, AccountId, CH_Solution__c, CH_ProductName__c, CH_ServiceContractNumber__c, AssetId, CH_Product_Release__c, CH_RDInterface__c, CH_ProductVariant__c,CH_ActionTaken__c,CH_CauseoftheIncident__c, CH_CorrectiveActions__c, CH_CustomerDescription__c, CH_Defect__c, CH_InitialDiagnosis__c, CH_InitialResponse__c,CH_IssueDescription__c, CH_LegacyCaseNumber__c, CH_ListofContributingCauses__c, CH_Outage__c, CH_PreventiveActions__c, CH_ProblemStatement__c,CH_Product_Code_CAPS__c, CH_RecordTypeCheck__c, CH_RecordTypeDevName__c, CH_RestorationMethod__c, CH_SequenceOfEvents__c, CH_ServiceType__c, CH_SolutionDetails__c,CH_Summary__c, CH_SummaryofAnalysis__c, CH_TechnicalAnalysis__c, CH_TemporarySolution__c, Comment__c, Country__c, Description, EntitlementId, HWS_DeliveryNote__c,ProductId, Severity__c, Subject,CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c, RecordTypeId, RecordType.developername,Account.Region__c, Account.Country__c,CH_Reassignment__c, NCP_Service_Contract__r.Name, BusinessHoursId,CH_SystemRestored__c,CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c, CH_Workgroup__r.CH_Type__c, CH_Product_Module__c, ParentId, CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_Rep_CDBContractType__c,OwnerId,Entitlement.ServiceContractId,CH_Originating_Incident_Number__r.Country__c, CH_Originating_Incident_Number__r.AccountId from case where HWS_DeliveryNote__c=null and CH_LegacyCaseNumber__c != null and CH_LegacyCaseStatus__c=\'Closed\' and CH_RecordTypeCheck__c=True';
		//System.debug(query);
		//Using Custom Metadata CH_LegacyCasesBatchQuery to make this query configurable
		CH_LegacyCasesBatchQuery__mdt closedLegacyCasesBatchQuery = [Select CH_LegacyCasesBatchQuery__c from CH_LegacyCasesBatchQuery__mdt where Label= 'Closed'];
		return Database.getQueryLocator(closedLegacyCasesBatchQuery.CH_LegacyCasesBatchQuery__c);
	}
	global void execute(Database.BatchableContext BC, List<Case> newCaseList){
		CH_CaseTriggerHelper.fetchCaseFields(newCaseList, null);
		//CH_CaseTriggerHelper2.setSecurityGroups(null, newCaseList);
		CH_SecurityUtils.setCaseSecurityGroups(newCaseList, null);
		CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), new Map<Id, Case>(), true, false);
		//CH_CaseTriggerHelper.updateProductDetails(newCaseList);
		for(Case newCase : newCaseList ){
			newCase.HWS_DeliveryNote__c='processed';
			caseIds.add(newCase.Id);
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
			//Here should go the logic of if legacyCase.CH_Workgroup__c = GWC then change to default WG
		}
	
		Database.SaveResult[] caseList = Database.update(newCaseList,false);	
		Integer i=0;
		for(Database.SaveResult a : caseList){
			if(!a.isSuccess()){
				for(Database.Error err : a.getErrors()) {
					logs.add(new Interface_Log__c(
						Comment__c = 'Error with the Case with Id: ' +newCaseList.get(i).Id + '--> ' + err.getMessage(),
						Interface_Type__c = 'Closed Legacy Case Error'
					));
				}
			}
			i++; 
		}
		Database.insert(logs,false);
	}
	global void finish(Database.BatchableContext BC){
		//
	}
	global void execute(SchedulableContext SC){
		CH_ProcessClosedLegacyCasesBatch  batch = new CH_ProcessClosedLegacyCasesBatch();
		Database.executebatch(batch,50);	 
	}
}