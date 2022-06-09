public with sharing class SaaSDocumentDownload 
{
	public String docDeveloperName {get;set;}
	
	public String getDocumentID()
	{
		String documentID ='';
		if(docDeveloperName == null)
			//docDeveloperName = docDeveloperName;
			docDeveloperName = 'NOKIA_Logo_1';

		String docLst;
		list<Document> lstdocumt = new list<Document>();
		lstdocumt  = [Select id from Document where DeveloperName = : docDeveloperName limit 1];
		 if(!lstdocumt.isEmpty()){
			 doclst = lstdocumt[0].id;
		}
		if(docLst==Null){
		
			lstdocumt = [select id from document where DeveloperName = 'ApttusLogo' Limit 1];
			if(!lstdocumt.isEmpty()){
				doclst = lstdocumt[0].id;
			}
		
		}
		//docLst = '01541000001bE0FAAU';
		return docLst;
	}
}