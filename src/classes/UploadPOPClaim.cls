/* description: Trigger helper to perform functions before and after Fund creation
* *author:	Accenture IDC.
* ============================================================================
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  Pooja Kurkute			08/06/2018	Release 4.1 PRM			   CO-OP
* ============================================================================ 
*/
public without sharing class UploadPOPClaim {
	/*******************************
*Method name: getClaimData
*Description: This Method will get claim date from record
*Parameter: claim Id 
*******************************/  
	@AuraEnabled
	public static String getClaimData(String claimId) {
		Claim__c claim = new Claim__c();
		String activityType = PRMGlobalConstants.BLANK_VALUE;
		try{
			claim = [SELECT Id, Activity_Type__c FROM Claim__c 
					 WHERE Id =: claimId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
			if(claim.Activity_Type__c != null) {
				activityType = claim.Activity_Type__c;
			}
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.UploadPOPClaim,PRMGlobalConstants.getClaimData);}
		return activityType;
	}
	/*******************************
*Method name: sendMailstoPartnerusers
*Description: This Method will send mail to partnerusers for allocation expire in 15 days
*Parameter: allocation Values
*******************************/	  
	@AuraEnabled
	public static List<String> getPOPValues(String activityId){
		String strAccounts1 = PRMGlobalConstants.BLANK_VALUE;
		String strAccounts2 = PRMGlobalConstants.BLANK_VALUE;
		List<String> popList = new List<String>();
		List<String> popList2 = new List<String>();
		try{   
			List<Coop_Activity_type_to_POP__c> activityToPOP = [select name,Activity_Type__c,POP__c,POP1__c 
																from Coop_Activity_type_to_POP__c WHERE Activity_Type__c =: activityId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(activityToPOP.size()>0){
				for(Coop_Activity_type_to_POP__c actToPOP :activityToPOP){
					if(actToPOP.Activity_Type__c == activityId ){
						strAccounts1 = actToPOP.POP__c;
						strAccounts2 = actToPOP.POP1__c;
						popList = strAccounts1.split(PRMGlobalConstants.SemiColon);
						if(!(String.IsEmpty(strAccounts2))){
							popList2 = strAccounts2.split(PRMGlobalConstants.SemiColon);
							popList.addall(popList2);
						}
					} 
				}
			}
		}Catch(System.Exception e)
		{			throw new AuraHandledException(e.getMessage());
		 //String message=e.getMessage();
		 //ExceptionHandler.addException(e,'UploadPOPClaim','getPOPValues');		   
		}
		return popList;
	}
 
	/*******************************
*Method name: sendMailstoPartnerusers
*Description: This Method will send mail to partnerusers for allocation expire in 15 days
*Parameter: allocation Values
*******************************/	  
	@AuraEnabled
	public static void updateContentVersion(String docId, String activityType, String pOP, String claimId){
		try{
			// System.debug('Contect id'+docId);
			ContentVersion contentVersion = new ContentVersion();
			Claim__c claim = Null;
			Set <String> attachesPOPValueSet = new Set<String>();
			contentVersion = [SELECT Id, Activity_Type__c,ContentDocumentId,Proof_of_Performance__c FROM ContentVersion 
							  WHERE ContentDocumentId =: docId LIMIT 1 ];
			contentVersion.Activity_Type__c = activityType;
			contentVersion.Proof_of_Performance__c = pOP;
			contentVersion.RecordTypeId = System.Label.PRM_Unrestricted_File_to_Other_record_Id;
			//system.debug('contentVersion>>>>>>>>'+contentVersion);
			database.update(contentVersion);
			claim = [SELECT ID, Attached_POP__c FROM Claim__c WHERE Id =: claimId limit 1];
			system.debug('pop:::'+claim.Attached_POP__c);
			if(claim.Attached_POP__c != Null)
			{
				for(String str : claim.Attached_POP__c.split(';'))
				{
					attachesPOPValueSet.add(str.trim());
				}
			}
			system.debug('attachesPOPValueSet'+attachesPOPValueSet);
			if(!attachesPOPValueSet.contains(pOP.trim())){
				system.debug('start-test');
				if(claim.Attached_POP__c != null ) {
					system.debug('not null');
					claim.Attached_POP__c = claim.Attached_POP__c+';'+pOP;
					system.debug('Attached_POP__c'+claim.Attached_POP__c);
				}
				/*else if(claim.Attached_POP__c == null ){
claim.Attached_POP__c = pOP;
system.debug('Attached_POP__c-else condition'+claim.Attached_POP__c);
}*/
				else{
					 system.debug('start-null');
					claim.Attached_POP__c = pOP;
					system.debug('Attached_POP__c-else condition'+claim.Attached_POP__c);
				}
			}
			update claim;
		}catch(System.Exception e){
			//   System.debug('Error has occured'+e.getMessage());
			ExceptionHandler.addException(e,PRMGlobalConstants.UploadPOPClaim,PRMGlobalConstants.getClaimData);}
	}
	/*******************************
*Method name: sendMailstoPartnerusers
*Description: This Method will send mail to partnerusers for allocation expire in 15 days
*Parameter: allocation Values
*******************************/	  
	@AuraEnabled
	public static List<ContentVersion> getFileLists(String claimId){ 
		List<ContentVersion> versionList = new List<ContentVersion>();
		//List<ContentVersion> versionListfinal = new List<ContentVersion>();
		try{
			Set<Id> contentDocumenIds = new Set<Id>();
			for(ContentDocumentLink link : [SELECT Id, contentDocumentId  FROM ContentDocumentLink 
											WHERE LinkedEntityId = : claimId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
												contentDocumenIds.add(link.contentDocumentId);
											}
			versionList = [SELECT Id, TITLE, Proof_of_Performance__c, LastModifiedDate, ContentSize, ContentDocumentId
						   FROM ContentVersion 
						   WHERE ContentDocumentId IN: contentDocumenIds 
						   Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
			/*for(ContentVersion version : versionList) {
versionListfinal.add(version);
getFileSize(String.valueOf(version.ContentSize));
}*/
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.UploadPOPClaim,PRMGlobalConstants.getClaimData);
								  }
		System.debug('versionlist'+versionList);
		return versionList;
	}
	/*******************************
*Method name: sendMailstoPartnerusers
*Description: This Method will send mail to partnerusers for allocation expire in 15 days
*Parameter: allocation Values
*******************************/	  
	/*  @AuraEnabled
public static String getFileSize(String contentSize) { 
String fieSize = contentSize.toUpperCase();
Long longValue = Long.valueOf(contentSize);

if (longValue < 1024) {
fieSize =  string.valueOf(longValue) + ' Bytes';
} else if (longValue >= 1024 && longValue < (1024*1024)) {
//KB
Decimal kb = Decimal.valueOf(longValue);
kb = kb.divide(1024,2);
fieSize = string.valueOf(kb) + ' KB';
}
else if (longValue >= (1024*1024) && longValue < (1024*1024*1024)) {
//MB
Decimal mb = Decimal.valueOf(longValue);
mb = mb.divide((1024*1024),2);
fieSize = string.valueOf(mb) + ' MB';
}
else {
//GB
Decimal gb = Decimal.valueOf(longValue);
gb = gb.divide((1024*1024*1024),2);
fieSize = string.valueOf(gb) + ' GB';
}   

return fieSize;
}*/
	/*******************************
*Method name: sendMailstoPartnerusers
*Description: This Method will send mail to partnerusers for allocation expire in 15 days
*Parameter: allocation Values
*******************************/	  
	@AuraEnabled
	public static String deleteFileRecord(String ContentDocId, String claimId) {
		String errormessage = PRMGlobalConstants.SUCCESS;
		Claim__c claim = Null;
		ContentVersion version = Null;
		Set<Id> contentDocIdSet = new Set<Id>() ;
		Set<Id> sameContentDocIdSet = new Set<Id>() ;
		List<ContentDocument> delContentLink = new List<ContentDocument>();
		try{
			//system.debug('++++ContentDocId+' + ContentDocId);
			if(ContentDocId != Null){
				version = [SELECT Id, TITLE, Proof_of_Performance__c, LastModifiedDate, ContentSize, ContentDocumentId, Document_Type_POC__c
										  FROM ContentVersion 
										  WHERE ContentDocumentId =: ContentDocId 
										  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
				
				delContentLink = [SELECT Id FROM ContentDocument 
								  WHERE Id =: ContentDocId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				system.debug('++++delContentLink+' + delContentLink);
				//Database.DeleteResult[] drList = Database.delete(delContentLink, false);
				claim = [SELECT ID, Attached_POP__c FROM Claim__c WHERE Id =: claimId Limit 1];
				
				for(ContentDocumentlink conDocLink : [Select ContentDocumentId,linkedEntityId from ContentDocumentlink
													  where linkedEntityId =: claimId
													  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())])
				{
					contentDocIdSet.add(conDocLink.ContentDocumentId);
				}
			
			if(contentDocIdSet.size() > 0){
				for(ContentVersion conVer : [SELECT ContentDocumentId,Proof_of_Performance__c FROM ContentVersion 
											 WHERE ContentDocumentId in: contentDocIdSet 
											 Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())])
				{
					if( conVer.Proof_of_Performance__c == version.Proof_of_Performance__c )
					{
						sameContentDocIdSet.add(conVer.ContentDocumentId);
					}
				}
			}
		
		//ContentVersion contentclaim = [SELECT ContentDocumentId, Proof_of_Performance__c  FROM ContentVersion WHERE Id =: claimId];
		System.debug('claim-attached pop'+claim.Attached_POP__c);
		Database.DeleteResult[] drList = Database.delete(delContentLink, false);
		if(sameContentDocIdSet.size() <=1){
			if(claim.Attached_POP__c.contains(version.Proof_of_Performance__c+';')) {
				// List<String> parts = claim.Attached_POP__c.split(';');
				
				claim.Attached_POP__c= claim.Attached_POP__c.remove(version.Proof_of_Performance__c+';');
				System.debug('claim-attached pop-in if loop'+claim.Attached_POP__c);
			}
			else if(claim.Attached_POP__c.contains(';'+version.Proof_of_Performance__c))
			{
				claim.Attached_POP__c= claim.Attached_POP__c.remove(';'+version.Proof_of_Performance__c);
				
			}
			else {
				claim.Attached_POP__c = null;
				//claim.Attached_POP__c.remove(version.Proof_of_Performance__c);
				System.debug('claim-attached pop-in else loop'+claim.Attached_POP__c);
			}   
		}   
		
		update claim;
		// Database.DeleteResult[] drList = Database.delete(delContentLink, false);
		// Iterate through each returned result
		for(Database.DeleteResult dr : drList) {
			if (dr.isSuccess()) {
				// Operation was successful, so get the ID of the record that was processed
				//System.debug('Successfully deleted account with ID: ' + dr.getId());
			}
			else {
				// Operation failed, so get all errors				
				for(Database.Error err : dr.getErrors()) {
					errormessage=err.getMessage();
					//System.debug('The following error has occurred.');					
					//System.debug(err.getStatusCode() + ': ' + err.getMessage());
					//System.debug('Account fields that affected this error: ' + err.getFields());
				}
			}
		} 
		}
	}Catch(System.Exception e)
	{
		String message=e.getMessage();
		//ExceptionHandler.addException(e,'UploadPOPClaim','getPOPValues');		   
	}
	return errormessage;		
}	
}