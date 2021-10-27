public class CertificationMatrixHandlerPRM {
	public static void afterUpdate( Map<id,Certification_Matrix__c> Certification_MatrixOldMap , Map<id,Certification_Matrix__c> Certification_MatrixNewMap  ){
		try{
		   CertificationMatrixHelperPRM.updateGPPFields(Certification_MatrixOldMap, Certification_MatrixNewMap);
	   }
	   catch(exception e){
				system.debug('exception :'+e);
			}
	}
	
		 
	/********************
	*Method Name: afterInsertOperation
	*Parameter: Certification_Matrix__c List
	*Description: Used to handle after Insert activities
				 
	*******************/
	public static void afterInsertOperation(List<Certification_Matrix__c> CertificationMatrixList){ 
	 }
	 

}