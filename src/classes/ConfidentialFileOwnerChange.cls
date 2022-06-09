/**
* @description: Class will update confidential files owner to "Global File Owner"
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  PRATEEK PRASOON		  1/07/2018	Sprint 7 sCRM				DocStrategy Re-Design
* ============================================================================ 
*/
public  without sharing class ConfidentialFileOwnerChange implements Queueable
{	
	List<ContentDocument> contentDocumentToUpdate = new List<ContentDocument>();
	
	/**********************************************************************************************************************
* author: Accenture
* Date: July-2018
* Param: Document List to change there owner
* Description: 
**********************************************************************************************************************/
	public ConfidentialFileOwnerChange(List<ContentDocument> contDocToUpdate)
	{
		this.contentDocumentToUpdate = contDocToUpdate;
	}

	/**********************************************************************************************************************
	* author: Accenture
	* Date: July-2018
	* Param: Document List to change there owner
	* Return: void
	* Description: contentDocumentToUpdate will get updated
	**********************************************************************************************************************/
	public void execute(QueueableContext context)
	{
		try
		{
			ContentDocumentLinkHandler.isOwnerChanged = true;
			database.update(contentDocumentToUpdate, false);
			
			Boolean someFailure = false;
			Database.SaveResult[] savedResults = Database.update(contentDocumentToUpdate, false);
			
			for (Database.SaveResult sr : savedResults)
			{
				if (!sr.isSuccess())
				{
					someFailure = true;
					for(Database.Error err : sr.getErrors())
					{
						System.debug('Error occured : '+err.getStatusCode() + ' : ' + err.getMessage());
						System.debug('ContentDocument field that affected this error : ' + err.getFields());
					}
				}
			}
			if(!someFailure)
			{
				System.debug('All file owners changed successfully');
			}			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.ConfidentialFileOwnerChange, GlobalConstants.BATCH_EXECUTE);
		}		
	}
}