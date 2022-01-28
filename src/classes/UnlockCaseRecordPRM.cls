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
public without sharing class UnlockCaseRecordPRM implements Queueable 
{	   
	private List<Case> sobjectToUpdate = new List<Case>();
	/*constuctor to initialize list of SObject*/
	public UnlockCaseRecordPRM(List<Case> newCaseList){
		this.sobjectToUpdate = newCaseList;
	}
	
	/*method to update sobject list*/
	public void execute(QueueableContext context) {
		try{
		 //   System.debug('Approval unlocked Case with ID: ' + sobjectToUpdate);
		//  Approval.UnlockResult unlockedRersult = Approval.unlock(chilcase.id);
		Approval.UnlockResult[] unlockedRersult = Approval.unlock(sobjectToUpdate);
		for(Approval.UnlockResult ur : unlockedRersult) {
			if (ur.isSuccess()) {
				// Operation was successful, so get the ID of the record that was processed
				//System.debug('Successfully unlocked account with ID: ' + ur.getId());
			}
			else {
				// Operation failed, so get all errors				
				for(Database.Error err : ur.getErrors()) {
				   // System.debug('The following error has occurred.');					
				   // System.debug(err.getStatusCode() + ': ' + err.getMessage());
				   // System.debug('Account fields that affected this error: ' + err.getFields());
				}
			}
		}	 
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.UpdateSObjectFlags, GlobalConstants.UpdateSObjectFlags);
		}
	}
}