/**
* @description: Method for updating SObjects
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0	 Accenture	   22/6/2018 
Description : //Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
				//Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
				//Req#4705 - PTA Signed automatically ticked
* ============================================================================ 
*/
public without sharing class UpdateSObjectFlags implements Queueable 
{	   
	List<SObject> sobjectToUpdate = new List<SObject>();
	/*constuctor to initialize list of SObject*/
	public UpdateSObjectFlags(List<SObject> sobjectList){
		this.sobjectToUpdate = sobjectList;
	}
	
	/*method to update sobject list*/
	public void execute(QueueableContext context) {
		try{
			//system.debug('sobjectToUpdate .....'+ sobjectToUpdate);		
			Database.SaveResult[] savedResults = Database.update(sobjectToUpdate, false);
			/*Boolean someFailure = false;
			for (Database.SaveResult sr : savedResults) 
			{
				if (!sr.isSuccess())
				{
					someFailure = true;
					for(Database.Error err : sr.getErrors()) 
					{
						System.debug('The following error has occurred : '+err.getStatusCode() + ' : ' + err.getMessage());
						System.debug('Offer fields that affected this error : ' + err.getFields());
					}
				}
			}		
			if(!someFailure)
			{
				System.debug('All Offer records update successfully'); 
			} */	  
		}catch(Exception ex){
			 ExceptionHandler.addException(ex, GlobalConstants.UpdateSObjectFlags, GlobalConstants.UpdateSObjectFlags);
		}
	}
}