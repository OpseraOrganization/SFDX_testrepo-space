public without sharing class LOAFileReports{
	//For the Test class, we have written this constructor.
	public LOAFileReports() {
	
/*	@future
	public static void validateAndCreate(String offerNumber){
		System.debug('INside validateAndCreate..........');
		List<Offer__c> ofr = [select  d from Offer__c where Offer_Number__c=:offerNumber];
		List<ContentDocumentLink> documentLinkList = [select Id,contentdocumentId from ContentDocumentLink 
					where linkedEntityId =: ofr.get(0).Id];
		List<Id> alldocumentIdList = new List<Id>();
		for(ContentDocumentLink lnk: documentLinkList){
			alldocumentIdList.add(lnk.contentDocumentId);
		}
		List<ContentVersion> versionList = [select Id,contentDocumentId from ContentVersion 
			where isLatest=true 
			and (Document_Type_POC__c=:GlobalConstants.LoA_G4_Template OR Document_Type_POC__c=:GlobalConstants.LoA_G5_Template) 
			and contentDocumentId in: alldocumentIdList 
			order by lastmodifieddate desc
			limit 1];
		System.debug('Inside validateAndCreate..........versionList ........'+versionList );
		List<Id> documentIdList = new List<Id>();
		for(ContentVersion ver : versionList ){
			documentIdList.add(ver.contentDocumentId);
		}
		List<ContentDocumentLink> actualDocumentLinkList = [select Id,contentdocumentId,LinkedEntityId from ContentDocumentLink 
					where contentdocumentId IN :documentIdList ];
		//update versionList;
		//update actualDocumentLinkList;
		System.debug('Inside validateAndCreate..........creating file report........');
		ContentDocumentLinkHelper.createFileRecord(actualDocumentLinkList);
	}	*/
   }
}