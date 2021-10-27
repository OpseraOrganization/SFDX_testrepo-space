/******************************************************************************************************
Name : QTO_ContentDocumentLinkHandler
Created Date: 14 September 2020
Created by: Bogdan Botcharov
Description : Processing ContentDocumentLink (Lightning) when being uploaded to cases
*********************************************************************************************************/
public with sharing class QTO_ContentDocumentLinkHandler {

	public static void resetCaseStatus(List<ContentDocumentLink> listContentDocLink){

		Set<Id> relatedCaseIds = new Set<Id>();

		String case_prefix = Schema.SObjectType.Case.getKeyPrefix();
		
		for(ContentDocumentLink cdsSO : listContentDocLink)
			if(((String)cdsSO.LinkedEntityId).startsWith(case_prefix))
				relatedCaseIds.add(cdsSO.LinkedEntityId);

		System.debug('*****relatedCaseIds: '+relatedCaseIds);

		if(!relatedCaseIds.isEmpty()){
			List<Case> casesForUpdate = new List<Case>();
			for(Case caseSO : [SELECT Id, Status, RecordType.Name
								FROM Case WHERE Id IN: relatedCaseIds AND RecordType.Name = 'Quote to Order CPO Case']){
				if(caseSO.Status == 'Exception')
					caseSO.Status = 'Retake';
				System.debug('*****caseSO.Status: '+caseSO.Status);
				casesForUpdate.add(caseSO);
			}

			if(!casesForUpdate.isEmpty()){
				try{
					update casesForUpdate;
				} catch (Exception e){
					System.debug('*****exception updating Case in QTO_ContentDocumentLinkHandler: '+e.getMessage());
				}
			}
		}
	}
}