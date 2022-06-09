/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 10-04-2021
 * @last modified by  : Yashdeep Prajapati
 **/
public with sharing class NokiaCPQ_SitePhaseQuntityTriggerHandler {
public static void sitePhaseConfigCheck(List<CPQ_Site_Phase_and_Quantity__c> spqList){
	Map<Id, Set<Id> > siteConfigMap = new Map<Id, Set<Id> >();
	Map<Id, Set<Id> > phaseConfigMap = new Map<Id, Set<Id> >();
	Set<Id> configSet = new Set<Id>();
	Set<Id> siteSet = new Set<Id>();
	Set<Id> phaseSet = new Set<Id>();
	for(CPQ_Site_Phase_and_Quantity__c spq:spqList) { // Iterating over CPQ_Site_Phase_and_Quantity__c list.
		configSet.add(spq.NCPQ_Configuration__c);
		// if(spq.NCPQ_Site__c != null) {
		// 	if(siteConfigMap.containsKey(spq.NCPQ_Configuration__c)) {
		// 		Set<Id> st = siteConfigMap.get(spq.NCPQ_Configuration__c);
		// 		st.add(spq.NCPQ_Site__c);
		// 		siteConfigMap.put(spq.NCPQ_Configuration__c, st);
		// 	}else{
		// 		siteConfigMap.put(spq.NCPQ_Configuration__c, new Set<Id> {spq.NCPQ_Site__c});
		// 	}
		// 	siteSet.add(spq.NCPQ_Site__c);
		// }
		// if(spq.NCPQ_Phase__c != null) {
		// 	if(phaseConfigMap.containsKey(spq.NCPQ_Configuration__c)) {
		// 		Set<Id> ph = phaseConfigMap.get(spq.NCPQ_Configuration__c);
		// 		ph.add(spq.NCPQ_Phase__c);
		// 		phaseConfigMap.put(spq.NCPQ_Configuration__c, ph);
		// 	}else{
		// 		phaseConfigMap.put(spq.NCPQ_Configuration__c, new Set<Id> {spq.NCPQ_Phase__c});
		// 	}
		// 	phaseSet.add(spq.NCPQ_Phase__c);
		// }
	}
	Nokia_CPQ_Utility.sitePhaseConfigCheck(configSet);
	// try{
	// 	for (CPQ_Site_Phase_and_Quantity__c spq : [SELECT id,Name,Line_Item__c,NCPQ_Configuration__c,Line_Item__r.Apttus_Config2__ConfigurationId__c,NCPQ_Phase__c,NCPQ_Phase__r.Name,NCPQ_Quantity__c,NCPQ_Site__c,NCPQ_Site__r.Name FROM CPQ_Site_Phase_and_Quantity__c WHERE Line_Item__r.Apttus_Config2__ConfigurationId__c IN :configSet AND (NCPQ_Site__c IN :siteSet OR NCPQ_Phase__c IN :phaseSet)]) {
	// 		system.debug('spq-->' + spq);
	// 		if(spq.NCPQ_Site__c != null && siteConfigMap.containsKey(spq.NCPQ_Configuration__c)) {
	//	Set<Id> st = siteConfigMap.get(spq.NCPQ_Configuration__c);
	//	if(st.contains(spq.NCPQ_Site__c)) {
	//		st.remove(spq.NCPQ_Site__c);
	//		if(st.isEmpty()) {
	//			siteConfigMap.remove(spq.NCPQ_Configuration__c);
	//		}
	//	}
	// 		}
	// 		if(spq.NCPQ_Phase__c != null && phaseConfigMap.containsKey(spq.NCPQ_Configuration__c)) {
	//	Set<Id> ph = phaseConfigMap.get(spq.NCPQ_Configuration__c);
	//	if(ph.contains(spq.NCPQ_Phase__c)) {
	//		ph.remove(spq.NCPQ_Phase__c);
	//		if(ph.isEmpty()) {
	//			phaseConfigMap.remove(spq.NCPQ_Configuration__c);
	//		}
	//	}
	// 		}
	// 	}
	// 	List<NokiaCPQ_Site_Phase_Configuration__c> deleteList = new List<NokiaCPQ_Site_Phase_Configuration__c>();
	// 	system.debug('siteConfigMap-->' + siteConfigMap);
	// 	system.debug('phaseConfigMap-->' + phaseConfigMap);
	// 	if(siteConfigMap.size() > 0 || phaseConfigMap.size() > 0) {
	// 		for (NokiaCPQ_Site_Phase_Configuration__c spc : [SELECT Id,NokiaCPQ_Configuration__c,NokiaCPQ_Site__c,NokiaCPQ_Phase__c,NokiaCPQ_Sequence__c FROM NokiaCPQ_Site_Phase_Configuration__c WHERE NokiaCPQ_Configuration__c IN :configSet AND (NokiaCPQ_Site__c IN :siteSet OR NokiaCPQ_Phase__c IN :phaseSet)]) {
	//	system.debug('spc-->' + spc);
	//	if(spc.NokiaCPQ_Site__c != null && siteConfigMap.containsKey(spc.NokiaCPQ_Configuration__c)) {
	//		Set<Id> st = siteConfigMap.get(spc.NokiaCPQ_Configuration__c);
	//		system.debug('st-->' + st);
	//		if(st.contains(spc.NokiaCPQ_Site__c)) {
	//			deleteList.add(spc);
	//		}
	//	}
	//	if(spc.NokiaCPQ_Phase__c != null && phaseConfigMap.containsKey(spc.NokiaCPQ_Configuration__c)) {
	//		Set<Id> ph = phaseConfigMap.get(spc.NokiaCPQ_Configuration__c);
	//		system.debug('ph-->' + ph);
	//		if(ph.contains(spc.NokiaCPQ_Phase__c)) {
	//			deleteList.add(spc);
	//		}
	//	}
	// 		}
	// 		system.debug('deleteList-->' + deleteList);
	// 		if(deleteList.size() > 0) {
	//	delete deleteList;
	// 		}
	// 	}
	// }catch(Exception e) {
	// 	System.debug('Error-->'+ e.getMessage()+'----'+e.getLineNumber());
	// 	ExceptionHandler.addException(e,NokiaCPQ_SitePhaseQuntityTriggerHandler.class.getName(),'sitePhaseConfigCheck');
	// }
}

public static void afterUpdate(List<CPQ_Site_Phase_and_Quantity__c> spqList){
	set<ID> dSet = new set<ID>();
	for (CPQ_Site_Phase_and_Quantity__c spq : spqList) {
		if(spq.NCPQ_Quantity__c == 0) {
			dSet.add(spq.Id);
		}
	}
	if(!dSet.isEmpty()) {
		delete [SELECT ID FROM CPQ_Site_Phase_and_Quantity__c WHERE ID IN : dSet];
	}
}

}