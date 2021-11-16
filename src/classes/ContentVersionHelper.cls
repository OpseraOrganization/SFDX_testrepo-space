public class ContentVersionHelper
{
	public static void UpdateTitle(map<Id,Contentversion> mapIdContentVersion)
	{
		List<File_Report__c> lsrFileReport = new List<File_Report__c>();
		List<Confidential_File__c> confyFileList = new List<Confidential_File__c>();
		for(File_Report__c objFileReport : [select id,File_Name__c,ContentDocumentId__c,File_Version__c,Share_with_External_Users__c  from File_Report__c where ContentDocumentId__c in: mapIdContentVersion.keyset()])
		{
			if(objFileReport.File_Version__c == mapIdContentVersion.get(objFileReport.ContentDocumentId__c).VersionNumber )
			{
				objFileReport.File_Name__c =  mapIdContentVersion.get(objFileReport.ContentDocumentId__c).Title;
				objFileReport.Description__c =  mapIdContentVersion.get(objFileReport.ContentDocumentId__c).Description;
				objFileReport.Share_with_External_Users__c = mapIdContentVersion.get(objFileReport.ContentDocumentId__c).Share_with_External_Users__c; 
				lsrFileReport.add(objFileReport);
			}
			
		}
		for(Confidential_File__c  objConfyFile : [select ContentDocumentId__c,Content_Version_Name__c,Id,Name from Confidential_File__c where ContentDocumentId__c in: mapIdContentVersion.keyset()])
		{
			objConfyFile.Content_Version_Name__c =  mapIdContentVersion.get(objConfyFile.ContentDocumentId__c).Title;
			objConfyFile.Description__c =  mapIdContentVersion.get(objConfyFile.ContentDocumentId__c).Description;
			confyFileList.add(objConfyFile);
		}
		
		Database.update(lsrFileReport);
		Database.update(confyFileList);
	}
}