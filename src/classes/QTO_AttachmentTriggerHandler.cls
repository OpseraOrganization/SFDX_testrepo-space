/******************************************************************************************************
Name : QTO_AttachmentTriggerHandler
Created Date: 11 September 2020
Created by: Bogdan Botcharov
Description : Processing attachments when being uploaded to cases
*********************************************************************************************************/
public with sharing class QTO_AttachmentTriggerHandler {

	public static void resetCaseStatus(List<Attachment> listAttchSO){

		Set<Id> relatedCaseIds = new Set<Id>();

		String case_prefix = Schema.SObjectType.Case.getKeyPrefix();
		
		for(Attachment attch : listAttchSO){
			String parentId = (String)attch.ParentId;
			
			if(!String.isEmpty(parentId) && parentId.startsWith(case_prefix))
				relatedCaseIds.add(attch.ParentId);
		}			

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

			try{
				update casesForUpdate;
			} catch (Exception e){
				System.debug('*****exception updating Case in QTO_AttachmentTriggerHandler: '+e.getMessage());
			}
		}
	}
}