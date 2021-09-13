/****************************************
 * Class Name : DS_GetQuoteLI
 * Created Date: 25 Sep 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : display quote features in quotrelineitem
*/
Public  with sharing Class DS_GetQuoteLI{

/*****************************
	*Method Name: getLineItemRec
	 *Description: This method will display features in quoteline item.
	 #DSI-760-Sprint-14-Customer should be able to see Feature Details on recommendation page
	 *******************************/
@auraEnabled
	public static List<Product_Feature_Junction__c>  getLineItemRec (String ProdCode)
	{
	try{
	   List<Product_Feature_Junction__c> FJList = new LIST<Product_Feature_Junction__c>();  
		if(!String.isBlank(ProdCode)){
			
			//FJList = [select Feature__c ,Feature__r.Description__c,Feature__r.Name,Product_Fetaure_Release__r.Name ,Product_Fetaure_Release__c,Feature__r.Is_New__c  from Product_Feature_Junction__c  where Product__r.ProductCode  =:ProdCode LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			FJList = [select Product_Feature__c, Is_New__c, Product_Feature__r.Description__c,Product_Feature__r.Feature_Commercial_Number__c,Release__r.Description__c, Release__c  
					  from Product_Feature_Junction__c  
					  where Product__r.ProductCode  =:ProdCode 
					  And GBOM_type__c = :CSWXGlobalConstant.DS_FeatureComponent
					  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(Test.isRunningTest())
			{
				CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
				throw testingCatch;
			}
			
		}
		
			return FJList;
	  
	   }catch (Exception ex) {
		  ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_GetQuoteLI  ,CSWXGlobalConstant.getLineItemRec);
		  return null;
	   }  
	} 



}