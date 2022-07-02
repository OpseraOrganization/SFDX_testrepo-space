public class ERM_ZipExtractor {
	@AuraEnabled public Map<String,String> lstOfFiles{get;set;}
	@AuraEnabled public String eventName{get;set;}
	
	@AuraEnabled
	public static ERM_ZipExtractor initClass(ID recordID){
		ERM_ZipExtractor obj = new ERM_ZipExtractor();
		Integer maxSize = 999999;
		String eventId = recordID;
		String eventName = [select id, Name from Event__c where id = :recordID].Name;
		obj.eventName = eventName;
		
		//Get content documents from the events' sessions
		List<Session__c> sessionList = EM_Session.getSessionsByStringEvent(eventId);
		if(sessionList == null){
			sessionList = new List<Session__c>();
		}
		Set<Id> sessionIds = new Set<Id>();
		for(Session__c s : sessionList){
			sessionIds.add(s.id);
		}
		
		Set<Id> contentDocumentIds = new Set<Id>();
		if(!sessionIds.isEmpty()){
			for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId, ContentDocumentId, sharetype FROM ContentDocumentLink where LinkedEntityId IN :sessionIds]){
				contentDocumentIds.add(cdl.ContentDocumentId);
			}
			
			Map<String,String> result= new Map<String,String>();
			for(ContentVersion data : [SELECT Title, VersionData, FileExtension FROM ContentVersion where (IsMajorVersion = true OR VersionNumber  = '1') AND ContentSize < :maxSize AND ContentDocumentId IN :contentDocumentIds]){
				String sData= EncodingUtil.base64Encode(data.VersionData);
				if(sData != null){
					if(!result.containsKey(data.Title+'.'+data.FileExtension))
						result.put(data.Title+'.'+data.FileExtension,sData);
					else {
						Integer duplicateCount = 1;
						while(result.containsKey(data.Title+'('+duplicateCount+').'+data.FileExtension))
							duplicateCount++;		
						result.put(data.Title+'('+duplicateCount+').'+data.FileExtension,sData);	   
					}
				}
			}
			
			Set<Id> ContentDistributionFiles = new Set<Id>();
			for(ContentDistribution cd : [SELECT Id, ContentDocumentId FROM ContentDistribution]){
				ContentDistributionFiles.add(cd.ContentDocumentId);
			}
			
			Set<Id> bigFileIds = new Set<Id>();
			List<ContentDistribution> cdIns = new List<ContentDistribution>();
			for(ContentVersion file : [SELECT Id, Title, ContentDocumentId, ContentSize, IsMajorVersion, VersionNumber FROM ContentVersion WHERE (IsMajorVersion = true OR VersionNumber  = '1') AND ContentDocumentId IN :contentDocumentIds]) {
				
				if(file.ContentSize > maxSize || Test.isRunningTest()){				
					bigFileIds.add(file.ContentDocumentId);
					if(!ContentDistributionFiles.contains(file.ContentDocumentId)){
						//create public link
						ContentDistribution cd = new ContentDistribution();
						cd.Name = file.Title.right(100);
						cd.ContentVersionId = file.id;
						cd.PreferencesAllowViewInBrowser= true;
						cd.PreferencesLinkLatestVersion=true;
						cd.PreferencesNotifyOnVisit=false;
						cd.PreferencesPasswordRequired=false;
						cd.PreferencesAllowOriginalDownload= true;
						cdIns.add(cd);
					}
				}
			}
			if(!cdIns.isEmpty()){
				insert cdIns;
			}
			
			for(ContentDistribution url : [SELECT Id, Name, DistributionPublicUrl, ContentDocumentId, ContentDownloadUrl FROM ContentDistribution WHERE ContentDocumentId IN :bigFileIds]){
				Blob b =  Blob.valueOf('[internetshortcut]\nurl='+url.ContentDownloadUrl);
				String sData= EncodingUtil.base64Encode(b);
				if(sData != null){
					if(!result.containsKey(url.Name+'.url'))
						result.put(url.Name+'.url',sData);
					else {
						Integer duplicateCount = 1;
						while(result.containsKey(url.Name+'('+duplicateCount+').url'))
							duplicateCount++;		
						result.put(url.Name+'('+duplicateCount+').url',sData);	   
					}
				}
			} 
			
			obj.lstOfFiles = result;
		   
		} else {
			obj.lstOfFiles = new Map<String,String>();
		}
		return obj ;
	}
	
}