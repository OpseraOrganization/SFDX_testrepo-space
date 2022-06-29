/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 02-09-2022
 * @last modified by  : Yashdeep Prajapati
 **/
public with sharing class NokiaCPQ_AccreditationExportController {

/**
 * @description Prepare data for the Export table based on the Accreditation and portfolio
 * @author Yashdeep Prajapati | 01-17-2022
 * @param accId
 * @return List<NokiaCPQ_AccreditationExportWrapper>
 **/
@AuraEnabled(cacheable=true)
public static List<NokiaCPQ_AccreditationExportWrapper> getDetails(string accId){
	try{
		if(string.isBlank(accId)) {
			return null;
		}
		List<NokiaCPQ_AccreditationExportWrapper> wprList = new List<NokiaCPQ_AccreditationExportWrapper>();
		string envURL = '';
		Map<string,string> portEaMap = new Map<string,string>();
		Map<string,List<string> > portAccrMap = new Map<string,List<string> >();
		Map<string,string> portfolioMap = new Map<string,string>();
		Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilityObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
		Map<string,List<string> > pMap = utilityObj.getPortfolioMapping(null);
		if(!pMap.isEmpty()) {
			for (string port : pMap.keySet()) {
	for (string subPort : pMap.get(port)) {
		portfolioMap.put(subPort,port);
	}
			}
		}
		pMap = null;
		List<string> accrIds = new List<string>();
		for (Accreditation__c accr : [SELECT Id, Accreditation_Level__c,Pricing_Cluster__c, Accreditation_Type__c, Nokia_CPQ_Env_Type__c, Partner_Type__c,Portfolio__c,  Nokia_Env_URL__c FROM Accreditation__c WHERE Partner__c = :accId]) {
			if(string.isBlank(accr.Pricing_Cluster__c)) {
	continue;
			}
			string portfolio = portfolioMap.containsKey(accr.Portfolio__c) ? portfolioMap.get(accr.Portfolio__c) : accr.Portfolio__c;
			if(!portAccrMap.containsKey(portfolio)) {
	portAccrMap.put(portfolio,new List<string>());
			}
			portAccrMap.get(portfolio).add(accr.Id);
			envURL = accr.Nokia_CPQ_Env_Type__c.equalsIgnoreCase('sCRM') ? '' : accr.Nokia_Env_URL__c;
			accrIds.add(accr.Id);
		}
		if(portAccrMap.isEmpty()) {
			return null;
		}
		portAccrMap.put('All',accrIds);
		for (CPQ_ExportAttach__c ea : [SELECT Id,CPQ_Portfolio__c FROM CPQ_ExportAttach__c WHERE CPQ_Account__c = :accId ORDER BY CPQ_Portfolio__c]) {
			portEaMap.put(ea.CPQ_Portfolio__c,ea.Id);
		}

		Map<string,string> appMap =  Nokia_CPQ_Utility.getXAEApps(new List<string> {'Price_Catalog','OEP'});
		string ppcURL = envURL + appMap.get('Price_Catalog');
		string oepURL = envURL + appMap.get('OEP');
		List<String> keySetList = new List<String> ();
		keySetList.addAll(portAccrMap.keySet());
		keySetList.sort();
		for (string portfolio : keySetList) {
			NokiaCPQ_AccreditationExportWrapper objWpr = new NokiaCPQ_AccreditationExportWrapper();
			objWpr.portfolio = portfolio;
			objWpr.accrIds = portAccrMap.get(portfolio);
			objWpr.ppcExport = ppcURL;
			objWpr.oepExport = oepURL;
			if(portEaMap.containsKey(portfolio)) {
	objWpr.attParentId = portEaMap.get(portfolio);
	objWpr.ppcExport += objWpr.attParentId;
	objWpr.oepExport += objWpr.attParentId;
			}
			wprList.add(objWpr);
		}
		return wprList;
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,NokiaCPQ_AccreditationExportController.class.getName(),'getDetails');
	}
	return null;
}

/**
 * @description Create the data for the export attachments
 * @author Yashdeep Prajapati | 01-17-2022
 * @param accrSet
 * @param portfolio
 * @param accountId
 * @return string
 **/
@AuraEnabled
public static string export(List<string> accrSet, string portfolio, string accountId){
	try{
		system.debug('accrSet-->' + accrSet + ' portfolio-->' + portfolio + ' accountId--> '+accountId);
		List<CPQ_ExportAttach__c> taList = [SELECT ID FROM CPQ_ExportAttach__c WHERE CPQ_Portfolio__c=:portfolio AND CPQ_Account__c=:accountId];
		Savepoint sp;
		if(taList.isEmpty()) {
			CPQ_ExportAttach__c ta = new CPQ_ExportAttach__c();
			ta.CPQ_Portfolio__c = portfolio;
			ta.CPQ_Account__c = accountId;
			ta.Name = portfolio;
			taList.add(ta);
			system.debug('taList--> '+taList);
			sp = Database.setSavepoint();
			insert taList;
			system.debug('ta.Id--> '+ta.Id);

		}else{
			for (CPQ_AccreditationExports__c ae : [SELECT ID,CPQ_Accreditation__c FROM CPQ_AccreditationExports__c WHERE CPQ_Accreditation__c IN :accrSet]) {
	accrSet.remove(accrSet.indexOf(string.valueOf(ae.CPQ_Accreditation__c)));
			}
		}
		try{
			if(!accrSet.isEmpty()) {
	List<CPQ_AccreditationExports__c> ataList = new List<CPQ_AccreditationExports__c>();
	for (string accr : accrSet) {
		system.debug('accr--> '+accr);
		CPQ_AccreditationExports__c ata = new CPQ_AccreditationExports__c();
		ata.CPQ_Accreditation__c = accr;
		ata.CPQ_ExportAttachment__c = taList[0].Id;
		ataList.add(ata);
	}
	system.debug('ataList--> '+ataList);
	insert ataList;
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQ_AccreditationExportController.class.getName(),'export');
			if(sp != null) {
	Database.rollback(sp);
			}
		}
		return taList[0].Id;
	}catch(Exception e) {
		ExceptionHandler.addException(e,NokiaCPQ_AccreditationExportController.class.getName(),'export');
	}
	return null;
}

/**
 * @description get all the attachments
 * @author Yashdeep Prajapati | 01-17-2022
 * @param accId
 * @return List<NokiaCPQ_Attachment>
 **/
@AuraEnabled(cacheable=true)
public static List<NokiaCPQ_Attachment> getAttachments(string accId){
	try{
		if(string.isBlank(accId)) {
			return null;
		}
		Set<Id> parentIds = new Set<Id>();
		for(CPQ_AccreditationExports__c aeList : [SELECT CPQ_ExportAttachment__c FROM CPQ_AccreditationExports__c WHERE CPQ_Accreditation__r.Partner__c = :accId]) {
			parentIds.add(aeList.CPQ_ExportAttachment__c);
		}
		//Map<string,Attachment> parentAttMap = new Map<string,Attachment>();
		List<NokiaCPQ_Attachment> attList = new List<NokiaCPQ_Attachment>();
		string ppcLike = Nokia_CPQ_Constants.NOKIA_ACCR_PRICE_EXPORT + '%';
		for (CPQ_ExportAttach__c ea : [SELECT ID,(SELECT Id, Name,ParentId,CreatedDate FROM Attachments WHERE Name LIKE :ppcLike ORDER BY CreatedDate DESC LIMIT 1) FROM CPQ_ExportAttach__c WHERE Id IN :parentIds]) {
			// string key = string.valueOf(aObj.ParentId) + Nokia_CPQ_Constants.NOKIA_STRING_APPENDER + (!aObj.Name.startsWith(Nokia_CPQ_Constants.NOKIA_ACCR_PRICE_EXPORT) ? 'OEP' : 'PPC');
			// if(!parentAttMap.containsKey(key)) {
			// 	parentAttMap.put(key, aObj);
			// }
			if(!ea.Attachments.isEmpty()) {
	for (Attachment aObj : ea.Attachments) {
		NokiaCPQ_Attachment att = new NokiaCPQ_Attachment();
		att.id = aObj.Id;
		att.name = aObj.Name;
		att.createdDate = aObj.CreatedDate;
		att.url = '/servlet/servlet.FileDownload?file=' + aObj.Id;
		attList.add(att);
	}
			}
		}
		for (CPQ_ExportAttach__c ea : [SELECT ID,(SELECT Id, Name,ParentId,CreatedDate FROM Attachments WHERE (NOT Name LIKE :ppcLike) ORDER BY CreatedDate DESC LIMIT 1) FROM CPQ_ExportAttach__c WHERE Id IN :parentIds]) {
			// string key = string.valueOf(aObj.ParentId) + Nokia_CPQ_Constants.NOKIA_STRING_APPENDER + (!aObj.Name.startsWith(Nokia_CPQ_Constants.NOKIA_ACCR_PRICE_EXPORT) ? 'OEP' : 'PPC');
			// if(!parentAttMap.containsKey(key)) {
			// 	parentAttMap.put(key, aObj);
			// }
			if(!ea.Attachments.isEmpty()) {
	for (Attachment aObj : ea.Attachments) {
		NokiaCPQ_Attachment att = new NokiaCPQ_Attachment();
		att.id = aObj.Id;
		att.name = aObj.Name;
		att.createdDate = aObj.CreatedDate;
		att.url = '/servlet/servlet.FileDownload?file=' + aObj.Id;
		attList.add(att);
	}
			}
		}
		// for (Attachment aObj : parentAttMap.values()) {
		// 	NokiaCPQ_Attachment att = new NokiaCPQ_Attachment();
		// 	att.id = aObj.Id;
		// 	att.name = aObj.Name;
		// 	att.createdDate = aObj.CreatedDate;
		// 	att.url = '/servlet/servlet.FileDownload?file=' + aObj.Id;
		// 	attList.add(att);
		// }
		attList.sort();
		return attList;
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,NokiaCPQ_AccreditationExportController.class.getName(),'getAttachments');
	}
	return null;
}

public class NokiaCPQ_AccreditationExportWrapper {
@AuraEnabled public string portfolio {get; set;}
@AuraEnabled public List<string> accrIds {get; set;}
@AuraEnabled public string ppcExport {get; set;}
@AuraEnabled public string oepExport {get; set;}
@AuraEnabled public string attParentId {get; set;}
}
public class NokiaCPQ_Attachment implements Comparable {
@AuraEnabled public string name {get; set;}
@AuraEnabled public string id {get; set;}
@AuraEnabled public string url {get; set;}
@AuraEnabled public Datetime createdDate {get; set;}
public Integer compareTo(Object compareTo) {
	NokiaCPQ_Attachment attObj = (NokiaCPQ_Attachment)compareTo;
	if (createdDate == attObj.createdDate) return 0;
	if (createdDate < attObj.createdDate) return 1;
	return -1;
}
}
}