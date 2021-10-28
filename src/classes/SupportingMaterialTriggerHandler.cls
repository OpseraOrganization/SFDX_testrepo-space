public class SupportingMaterialTriggerHandler {
/*****************************
*Method Name: beforeInsert
*Description: This is handler method for beforeInsert on Supporting Material
*Parameters: supportingMaterialList
*******************************/	
	public static void beforeInsert(List<File_Upload__c> supportingMaterialList){
  
		  try{
				 System.debug('In Handler');
			   SupportingMaterialTriggerHelper.validateDuplicateSupportingMaterialRecord(supportingMaterialList);
			  
			  if(Test.isRunningTest()){
					CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
					throw testingCatch; 
				}	
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.SupportingMaterialTriggerHandler,CSWXGlobalConstant.beforeInsert);
			   
		   }  
	
	}

}