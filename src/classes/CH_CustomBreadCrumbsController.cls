public class CH_CustomBreadCrumbsController {

	@AuraEnabled
	public static String  FetchRecordIds(String recordID){
		system.debug(' recordID-->'+recordID);
		//Fetch Record ids
		String executed=CH_CustomBreadCrumbsHelper.FetchIds(recordID);
		return executed;
		//CH_CustomBreadCrumbsHelper.DebugCheck();
	}


}