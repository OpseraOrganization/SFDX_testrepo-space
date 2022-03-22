/**
 * @description: restrict the user to upload documents with few claim status. Req-4547 Sprint 2
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
 * 1.0	 Accenture	   15/6/2018 Sprint 2 Coop claim-pop requirements.
 
 * ============================================================================ 
 */
public with sharing class ContentDocumentLinkHandlerPRM {
/*****************************
 *Method Name:restrictFileUploadOnClaim
 *Description: 
 *Parameters:
 *Test coverage from: 
 *******************************/
	public static void beforeInsert(List<ContentDocumentLink> contentDoclist){
		try{ 
			ContentDocumentLinkHelperPRM.restrictFileUploadOnClaim(contentDoclist);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.ContentDocumentLinkHandlerPRM,PRMGlobalConstants.beforeInsertOperation);}
		
	} 
	

}