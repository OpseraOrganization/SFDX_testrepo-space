public class CH_CustomBreadCrumbsHelper {
   
	public static String FetchIds(String recordId){
		system.debug('FetchiDs Method starts here -->'+recordId);
		String executed;
		
		//Checking if recordId is not empty
		if(recordId !=null){
			EmailMessage emailmess= [SELECT Id,ParentId,RelatedToId FROM EmailMessage WHERE Id=: recordID];
	executed= emailmess.RelatedToId;
	  
			}else{
	 
			}
		system.debug('executed -->'+executed);
		return executed;
		}
	
   }