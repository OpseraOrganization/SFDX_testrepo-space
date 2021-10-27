public class SaaSDocumentDownload 
{
	public String docDeveloperName {get;set;}
	
	public String getDocumentID()
	{
		String documentID ='';
		 if( docDeveloperName != null){
			 docDeveloperName = docDeveloperName;
		 } else{
		  docDeveloperName = 'NOKIA_Logo_1';
		 }
		
		String docLst= String.valueOf([Select id from Document where DeveloperName = : docDeveloperName limit 1].Id);
		/*if(docLst.size() > 0)
		{
			documentID  = docLst.get(0).id;	 
		}*/
		
		if(docLst==Null)
		docLst = '01541000001bE0FAAU';
		return docLst;
	}
}