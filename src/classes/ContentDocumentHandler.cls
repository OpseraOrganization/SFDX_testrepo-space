/**
* @description: HND_ContentDocumentHandler apex class. This use to extend the delete file functionality of lightning component.
*			 class includes function to delete the appropriate record from Document__c object when an excisting file is deleted from file object.
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				  12/09/2016   Sprint 3 Doc Stretegy & LoA requirements.
* ============================================================================ 
*/
public without sharing class ContentDocumentHandler
{
	 public static boolean allowDelete = false;
	/**********************************************************************************************************************
	* author: Accenture
	* Date: July-2018
	* Param: ContentDocument map
	* Return: void
	* Description: Before File deletion
	**********************************************************************************************************************/
	public static void beforeDelete(Map<Id, ContentDocument> contentDocumentOld)
	{
			ContentDocumentHelper.blockFileDeletionOppty(contentDocumentOld);
			//D-8357 Block Document upload/deletion to offer when oppty at pending win/loss restricted
			ContentDocumentHelper.blockFileDeletionOnOffer(contentDocumentOld);
			//contDoc.addError('Sorry you can\'t delete a file once uploaded');
	}
	
	/**********************************************************************************************************************
	* author: Accenture
	* Date: July-2018
	* Param: ContentDocument map
	* Return: void
	* Description: afterUndelete File 
	**********************************************************************************************************************/
	public static void afterUndelete(Map<Id, ContentDocument> contentDocumentNew)
	{	
			//#Req: 2281
			//Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
			//Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
			//Req#4705 - PTA Signed automatically ticked
			ContentDocumentHelper.determineObjectTypeForUndelete(contentDocumentNew);
			ContentDocumentHelper.unDeleteFile(contentDocumentNew);
	}
	
	/**********************************************************************************************************************
	* author: Accenture
	* Date: July-2018
	* Param: ContentDocument map
	* Return: void
	* Description: After File delete
	**********************************************************************************************************************/
	public static void afterDelete(Map<Id,ContentDocument> contentDocumentOld)
	{   
			//#Req: 2281
			//Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
			//Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
			//Req#4705 - PTA Signed automatically ticked
			ContentDocumentHandler.allowDelete =true;
			ContentDocumentHelper.determineObjectTypeForDelete(contentDocumentOld);
			ContentDocumentHelper.deleteFile(contentDocumentOld);
	}
	
	
}