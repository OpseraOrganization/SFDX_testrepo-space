/***********************************************
Class Name: HWS_CaseMilestoneTimeCalculator
Description: Used to set case milestone SLA time
************************************************/
public without sharing class HWS_CaseMilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator{
	private static Date byPasDate=null;
	
	/*********************************************
	*Method Name: calculateMilestoneTriggerTime
	*Parameter: Case Id, MilestoneType Id
	*Description: Used to set case milestone SLA time
	***********************************************/	
	public Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){	  
		Integer milestoneSLATime;
		DateTime  plannedDt;
		Case caseObj = [SELECT Id, 
						Asset.HWS_ContractLeadTimeDuration__c, 
						Asset.HWS_ContractLeadTimeUnit__c,
						Asset.HWS_ContractLineItem__r.CH_BusinessHour__c,
						HWS_FaultyUnitReceivedDate__c,
						Asset.HWS_SpecifiedDeliveryTargetTime__c,
						HWS_ServiceType__c
						FROM Case WHERE Id = :caseId];
		
		if(caseObj != null){
			if(caseObj.HWS_ServiceType__c == 'Identical Repair'){
				plannedDt = HWS_Utilty.plannedDeliveryDateTime(caseObj.Asset.HWS_ContractLineItem__r.CH_BusinessHour__c, caseObj.Asset.HWS_ContractLeadTimeUnit__c, caseObj.Asset.HWS_ContractLeadTimeDuration__c,caseObj.HWS_FaultyUnitReceivedDate__c,caseObj.Asset.HWS_SpecifiedDeliveryTargetTime__c); 
			}else {
				plannedDt = HWS_Utilty.plannedDeliveryDateTime(caseObj.Asset.HWS_ContractLineItem__r.CH_BusinessHour__c, caseObj.Asset.HWS_ContractLeadTimeUnit__c, caseObj.Asset.HWS_ContractLeadTimeDuration__c,byPasDate,caseObj.Asset.HWS_SpecifiedDeliveryTargetTime__c);
			}
			Date startDate = Date.today();
			Date dueDate = date.newinstance(PlannedDt.year(), PlannedDt.month(), PlannedDt.day());
			Integer numberOfDueDays = startDate.daysBetween(dueDate);
			Integer numberOfDueHours = PlannedDt.hour();
			Integer numberOfDueMinutes = PlannedDt.minute();
			System.debug('HWS_CaseMilestoneTimeCalculator:calculateMilestoneTriggerTime:minutes: ' +numberOfDuehours);
			System.debug('HWS_CaseMilestoneTimeCalculator:calculateMilestoneTriggerTime:PlannedDt: ' +PlannedDt);
			if(caseObj.Asset.HWS_ContractLeadTimeUnit__c.containsIgnoreCase('Days')){
				milestoneSLATime = (numberOfDueDays * 24 * 60) + (numberOfDueHours * 60) + numberOfDueMinutes;
			}else if(caseObj.Asset.HWS_ContractLeadTimeUnit__c.containsIgnoreCase('Hours')){
				milestoneSLATime = Integer.valueOf(caseObj.Asset.HWS_ContractLeadTimeDuration__c) * 60 ;
			}
		}	   
		return milestoneSLATime;
	}
}