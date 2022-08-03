/**
 * @description	 : Controller class for SitePhase LWC
 * @author	  : Yashdeep Prajapati
 * @last modified on  : 11-26-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log
 * Ver   Date	 Author		Modification
 * 1.0   05-11-2021   Yashdeep Prajapati   Initial Version
 **/
public with sharing class NokiaCPQ_SitePhaseController {
/**
 * @description Fetch LineItem details based on Config Id
 * @author Yashdeep Prajapati | 05-11-2021
 * @return NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseDetails
 **/
@AuraEnabled(cacheable=true)
public static NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseDetails getLineItems(string prodConfigId){
	try{

		NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseDetails sitePhaseDetail = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseDetails();
		sitePhaseDetail.hasAggregation=Nokia_CPQ_Utility.hasAggregation(prodConfigId);
		sitePhaseDetail.quoteUsesPhases = ([SELECT id FROM CPQ_Site_Phase_and_Quantity__c WHERE Line_Item__r.Apttus_Config2__ConfigurationId__c = : prodConfigId AND NCPQ_Phase__c != null LIMIT 1]).size() > 0;
		sitePhaseDetail.lines = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_LineItems>();
		//fetch maintenance and sps/srs prod codes
		
		List<string> codes = Nokia_CPQ_Utility.getMaintAndSSPSRSProdCodes();
		// surinder ITCCPQ-2515 , Support ticket:2182395=> added isinvalidproduct check
		List<Apttus_Config2__LineItem__c> lineItems =  [SELECT Id,NokiaCPQ_Alias__c,Apttus_Config2__LineSequence__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Description,NokiaCPQ_Spare__c,Apttus_Config2__Quantity__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c,Apttus_Config2__ConfigurationId__r.Quote_Type__c, (SELECT id,Name,Line_Item__c,NCPQ_Phase__c,NCPQ_Phase__r.Name,NCPQ_Quantity__c,NCPQ_Site__c,NCPQ_Site__r.Name FROM Site_Phase_and_Quantity__r ORDER BY NCPQ_Site__r.Name,NCPQ_Phase__r.Name) FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =: prodConfigId AND Apttus_Config2__LineType__c = :Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES AND Apttus_Config2__ProductId__r.ProductCode NOT IN :codes AND Apttus_Config2__ProductId__r.isInvalidProductCatalog__c != true ORDER BY Apttus_Config2__LineSequence__c ];
		if(lineItems != null && lineItems.size()>0) {

			string oppId = lineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c;
			if(oppId != null) {

	sitePhaseDetail.oppId = oppId;
	Opportunity opp = [SELECT Id, Name, (SELECT Id,Name FROM Sites__r ORDER BY Name), (SELECT Id,Name FROM Phases__r ORDER BY Name) FROM Opportunity WHERE Id =: oppId];
	if(opp != null) {
		Set<string> uniqueNames = new Set<String>();
		if(opp.Phases__r != null && opp.Phases__r.size() > 0) {
			sitePhaseDetail.phases = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_IdName>();
			for (NokiaCPQ_Phase__c phase : opp.Phases__r) {
				if(!uniqueNames.contains(phase.Name)) {
		NokiaCPQ_SitePhaseWrapper.NokiaCPQ_IdName ph = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_IdName();
		ph.id = phase.Id;
		ph.name = phase.Name;
		sitePhaseDetail.phases.add(ph);
		uniqueNames.add(phase.Name);
				}
			}
		}


		if(opp.Sites__r != null && opp.Sites__r.size() > 0) {
			uniqueNames = new Set<String>();
			sitePhaseDetail.sites = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_IdName>();
			for (NokiaCPQ_Site__c site : opp.Sites__r) {
				if(!uniqueNames.contains(site.Name)) {
		NokiaCPQ_SitePhaseWrapper.NokiaCPQ_IdName st = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_IdName();
		st.id = site.Id;
		st.name = site.Name;
		sitePhaseDetail.sites.add(st);
		uniqueNames.add(site.Name);
				}
			}
		}
	}
			}
			for (Apttus_Config2__LineItem__c line : lineItems) {
	Boolean hasNoSite = false;
	NokiaCPQ_SitePhaseWrapper.NokiaCPQ_LineItems sitePhaseLine = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_LineItems();
	sitePhaseLine.lineItemId = line.Id;
	sitePhaseLine.prodId = line.Apttus_Config2__ProductId__c;
	sitePhaseLine.productName = '['+ line.Apttus_Config2__LineSequence__c  +'] '+line.Apttus_Config2__ProductId__r.Name;
	sitePhaseLine.productCode = line.Apttus_Config2__ProductId__r.ProductCode;
	sitePhaseLine.productDesc = line.Apttus_Config2__ProductId__r.Description;
	sitePhaseLine.spares = line.NokiaCPQ_Spare__c ? 'Y' : 'N';
	sitePhaseLine.quantity = line.Apttus_Config2__Quantity__c.intValue();
	//added by surinder
	sitePhaseLine.alias = line.NokiaCPQ_Alias__c;
	sitePhaseLine.sites = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites>();
	if(line.Site_Phase_and_Quantity__r != null && line.Site_Phase_and_Quantity__r.size() > 0) {
		Map<string,NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites> sitePhaseMap = new Map<string,NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites>();
		NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites noSite = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites();
		noSite.siteName = 'No Site Assigned';
		noSite.quantity = 0;
		noSite.phases = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase>();
		sitePhaseMap.put('No Site Assigned', noSite);
		for (CPQ_Site_Phase_and_Quantity__c spq : line.Site_Phase_and_Quantity__r) {
			string siteName = spq.NCPQ_Site__c != null ? spq.NCPQ_Site__r.Name : 'No Site Assigned';
			Integer qty = spq.NCPQ_Quantity__c != null ? spq.NCPQ_Quantity__c.intValue() : 0;
			NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites sitePhaseQuantity = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites();
			if(sitePhaseDetail.quoteUsesPhases) {
				NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase phase = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase();
				phase.phaseId = spq.NCPQ_Phase__c;
				phase.phaseName = spq.NCPQ_Phase__c != null ? spq.NCPQ_Phase__r.Name : 'delta';
				phase.quantity = qty;
				phase.recordId = spq.Id;
				if(sitePhaseMap.containsKey(siteName)) {
		sitePhaseQuantity = sitePhaseMap.get(siteName);
		sitePhaseQuantity.quantity += qty;
		sitePhaseQuantity.phases.add(phase);
				}else{
		sitePhaseQuantity.siteId = spq.NCPQ_Site__c;
		sitePhaseQuantity.siteName = siteName;
		sitePhaseQuantity.quantity = qty;
		sitePhaseQuantity.phases = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase>();
		if(spq.NCPQ_Phase__c != null) {
			NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase phaseDelta = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase();
			phaseDelta.phaseName = 'delta';
			phaseDelta.quantity = 0;
			sitePhaseQuantity.phases.add(phaseDelta);
		}
		sitePhaseQuantity.phases.add(phase);
		sitePhaseMap.put(siteName, sitePhaseQuantity);
				}
			}
			else{
				sitePhaseQuantity = sitePhaseMap.get(siteName) != null ? sitePhaseMap.get(siteName) : new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites();
				sitePhaseQuantity.recordId = spq.Id;
				sitePhaseQuantity.siteId = spq.NCPQ_Site__c;
				sitePhaseQuantity.siteName = siteName;
				sitePhaseQuantity.quantity = qty;
				sitePhaseMap.put(siteName, sitePhaseQuantity);
			}
		}
		if(sitePhaseMap.size() > 0) {
			for (NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites item : sitePhaseMap.values()) {
				sitePhaseLine.sites.add(item);
			}
		}
	}else{
		NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites sitePhaseQuantity = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_SitePhaseQuantites();
		sitePhaseQuantity.siteName = 'No Site Assigned';
		sitePhaseQuantity.quantity = line.Apttus_Config2__Quantity__c.intValue();
		if(sitePhaseDetail.quoteUsesPhases) {
			NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase phase = new NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase();
			phase.phaseName = 'delta';
			phase.quantity = line.Apttus_Config2__Quantity__c.intValue();
			sitePhaseQuantity.phases = new List<NokiaCPQ_SitePhaseWrapper.NokiaCPQ_Phase>();
			sitePhaseQuantity.phases.add(phase);
		}
		sitePhaseLine.sites.add(sitePhaseQuantity);
	}
	sitePhaseDetail.lines.add(sitePhaseLine);
			}
			sitePhaseDetail.siteOrder = new List<string>();
			sitePhaseDetail.phaseOrder = new List<string>();
			for (NokiaCPQ_Site_Phase_Configuration__c spc : [SELECT Id,NokiaCPQ_Site__c,NokiaCPQ_Phase__c,NokiaCPQ_Sequence__c FROM NokiaCPQ_Site_Phase_Configuration__c WHERE NokiaCPQ_Configuration__c = :prodConfigId AND NokiaCPQ_Sequence__c != NULL ORDER BY NokiaCPQ_Sequence__c]) {
	if(spc.NokiaCPQ_Site__c != null) {
		sitePhaseDetail.siteOrder.add(spc.NokiaCPQ_Site__c);
	}
	else if(spc.NokiaCPQ_Phase__c != null) {
		sitePhaseDetail.phaseOrder.add(spc.NokiaCPQ_Phase__c);
	}
			}
			return sitePhaseDetail;
		}else{
			return null;
		}
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,NokiaCPQ_SitePhaseController.class.getName(),'saveSite');
		throw e;
	}
}

/**
 * @description
 * @author Yashdeep Prajapati | 06-09-2021
 * @param listUpsert
 * @param listDelete
 * @param quoteUsesPhases
 * @param isSaveOnly
 * @return Map<string, object>
 **/
@AuraEnabled
public static Map<string, object> saveSitePhaseQuantityLineItem(List<Map<string, object> > listUpsert, List<Id> listDelete, Boolean quoteUsesPhases, Boolean isSaveOnly) {
	Map<string, object> response = new Map<string, object>();
	try{
		if(listDelete != null && listDelete.size() > 0) {
			Nokia_CPQ_Constants.SKIP_EXECUTION = true;
			List<Database.DeleteResult> dltResult = Database.delete(listDelete);
			Nokia_CPQ_Constants.SKIP_EXECUTION = false;
		}
		if(listUpsert != null && listUpsert.size() > 0) {
			Map<string,string> errorMap = new Map<string,string>();
			Map<String,Integer> sitePhaseQtyMap = new Map<String,Integer>();
			List<CPQ_Site_Phase_and_Quantity__c> spqList = new List<CPQ_Site_Phase_and_Quantity__c>();
			for (Map<string, object> upMap : listUpsert) {
	CPQ_Site_Phase_and_Quantity__c spq = new CPQ_Site_Phase_and_Quantity__c();
	string lineItem = String.valueOf(upMap.get('lineItemId'));
	string prodName = String.valueOf(upMap.get('prodName'));
	spq.Line_Item__c = lineItem;
	if(upMap.containsKey('recordId') && upMap.get('recordId') != null ) {
		string spId = String.valueOf(upMap.get('recordId'));
		spq.Id= spId;
	}
	string siteId = String.valueOf(upMap.get('siteId'));
	string siteName = String.valueOf(upMap.get('siteName'));
	string phaseId = String.valueOf(upMap.get('phaseId'));
	string phaseName = String.valueOf(upMap.get('phaseName'));
	Integer qty = Integer.valueOf(String.valueOf(upMap.get('quantity')));
	String errorName = prodName + '-' + siteName;
	if(string.isNotBlank(phaseName)) {
		if(phaseName == 'Δ' && qty == 0) {
			continue;
		} else if(phaseName != 'Δ') {
			errorName += '-' + phaseName;
		}
	}
	if(qty < 0 && (quoteUsesPhases && String.isNotBlank(phaseName) && phaseName != 'Δ')) {
		if(errorMap.containsKey('negate')) {
			errorMap.put('negate', errorMap.get('negate') + ',' + errorName);
		}else{
			errorMap.put('negate', errorName);
		}
		continue;
	}else if(qty == 0) {		 // This needs to be discussed
		string key = quoteUsesPhases && String.isNotBlank(phaseName) ? phaseName : siteName;
		if(sitePhaseQtyMap.containsKey(key)) {
			sitePhaseQtyMap.put(key, qty + sitePhaseQtyMap.get(key));
		}else{
			sitePhaseQtyMap.put(key, qty);
		}
		continue;
	}
	else{
		string key = quoteUsesPhases && String.isNotBlank(phaseName) ? phaseName : siteName;
		if(sitePhaseQtyMap.containsKey(key)) {
			sitePhaseQtyMap.put(key, qty + sitePhaseQtyMap.get(key));
		}else{
			sitePhaseQtyMap.put(key, qty);
		}
		spq.NCPQ_Site__c = siteId;
		spq.NCPQ_Phase__c = phaseId;
		spq.NCPQ_Quantity__c = qty;
		spq.Name = (lineItem + '-' + siteId + (String.isNotBlank(phaseId) ? '-' + phaseId : ''));
		spqList.add(spq);
	}
			}
			if(errorMap.size() > 0) {
	for (string key : errorMap.keySet()) {
		if(key == 'negate') {
			response.put('isSuccess', false);
			response.put('error', 'Save operation failed. Please correct the issue and retry. Negative quantities exist for the following Product Site/Phase combinations:' + errorMap.get(key));
			return response;
		}
	}
			}
			if(spqList.size() > 0) {
	Nokia_CPQ_Constants.SKIP_EXECUTION = true;
	upsert spqList;
	Nokia_CPQ_Constants.SKIP_EXECUTION = false;
			}

			if(sitePhaseQtyMap.size() > 0) {
	string message = '';
	for (string name : sitePhaseQtyMap.keySet()) {
		if(sitePhaseQtyMap.get(name) <= 0 && name != 'Δ') {
			message += name +',';
		}
	}
	if(string.isNotBlank(message)) {
		if(response.containsKey('error')) {
			response.put('error', response.get('error') + '\n' + 'No data was saved for the following sites/phases as they have no quantities assigned: ' + message);
		}else{
			response.put('isSuccess', true);
			response.put('error', 'No data was saved for the following sites/phases as they have no quantities assigned: ' + message);
		}
	}
			}
		}
	}
	catch(DmlException e) {
		System.debug('Error-->'+ e.getMessage()+'----'+e.getLineNumber());

	}catch(Exception e) {
		System.debug('Error-->'+ e.getMessage()+'----'+e.getLineNumber());
		ExceptionHandler.addException(e,NokiaCPQ_SitePhaseController.class.getName(),'getOpptySitesAndPhases');
		response.put('isSuccess', false);
		response.put('error', 'Something went wrong while saving the records.');
	}
	return response;
}

/**
 * @description Update NokiaCPQ_Site_Phase_Configuration__c based on given order
 * @author Yashdeep Prajapati | 09-19-2021
 * @param configId
 * @param siteOrder
 * @param phaseOrder
 * @return Integer
 **/
@AuraEnabled
public static Integer saveSitePhaseConfiguration(string configId, Map<string,Decimal> siteOrder, Map<string,Decimal> phaseOrder) {
	try{
		system.debug('saveSitePhaseConfiguration-->' + siteOrder);
		List<NokiaCPQ_Site_Phase_Configuration__c> listDelete = new List<NokiaCPQ_Site_Phase_Configuration__c>();
		List<NokiaCPQ_Site_Phase_Configuration__c> upsertList = new List<NokiaCPQ_Site_Phase_Configuration__c>();
		Boolean hasSiteOrder = siteOrder != null && siteOrder.size() > 0;
		Boolean hasPhaseOrder = phaseOrder != null && phaseOrder.size() > 0;
		for (NokiaCPQ_Site_Phase_Configuration__c spc : [SELECT Id,NokiaCPQ_Site__c,NokiaCPQ_Phase__c,NokiaCPQ_Sequence__c FROM NokiaCPQ_Site_Phase_Configuration__c WHERE NokiaCPQ_Configuration__c = :configId AND NokiaCPQ_Sequence__c != NULL ORDER BY NokiaCPQ_Sequence__c]) {
			if(spc.NokiaCPQ_Site__c != null) {
	if(hasSiteOrder && siteOrder.containsKey(spc.NokiaCPQ_Site__c)) {
		if(spc.NokiaCPQ_Sequence__c != siteOrder.get(spc.NokiaCPQ_Site__c)) {
			spc.NokiaCPQ_Sequence__c = siteOrder.get(spc.NokiaCPQ_Site__c);
			upsertList.add(spc);
		}
	}else{
		listDelete.add(spc);
	}
	siteOrder.remove(spc.NokiaCPQ_Site__c);
			}
			if(spc.NokiaCPQ_Phase__c != null) {
	if(hasPhaseOrder && phaseOrder.containsKey(spc.NokiaCPQ_Phase__c) ) {
		if(spc.NokiaCPQ_Sequence__c != phaseOrder.get(spc.NokiaCPQ_Phase__c)) {
			spc.NokiaCPQ_Sequence__c = phaseOrder.get(spc.NokiaCPQ_Phase__c);
			upsertList.add(spc);
		}
	}else{
		listDelete.add(spc);
	}
	phaseOrder.remove(spc.NokiaCPQ_Phase__c);
			}
		}
		if(hasSiteOrder && siteOrder.size() > 0) {
			for (string site : siteOrder.keySet()) {
	NokiaCPQ_Site_Phase_Configuration__c spc = new NokiaCPQ_Site_Phase_Configuration__c();
	spc.NokiaCPQ_Configuration__c = configId;
	spc.NokiaCPQ_Site__c = site;
	spc.NokiaCPQ_Sequence__c = siteOrder.get(site);
	upsertList.add(spc);
			}
		}
		if(hasPhaseOrder && phaseOrder.size() > 0) {
			for (string phase : phaseOrder.keySet()) {
	NokiaCPQ_Site_Phase_Configuration__c spc = new NokiaCPQ_Site_Phase_Configuration__c();
	spc.NokiaCPQ_Configuration__c = configId;
	spc.NokiaCPQ_Phase__c = phase;
	spc.NokiaCPQ_Sequence__c = phaseOrder.get(phase);
	upsertList.add(spc);
			}
		}
		if(upsertList.size() > 0) {
			upsert upsertList;
		}
		if(listDelete.size() > 0) {
			delete listDelete;
		}
		return upsertList.size() + listDelete.size();
	}catch(Exception ex) {
		ExceptionHandler.addException(ex,NokiaCPQ_SitePhaseController.class.getName(),'saveSitePhaseConfiguration');
		throw ex;
	}
}
}