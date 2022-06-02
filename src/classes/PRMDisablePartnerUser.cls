/********************
	*Class Name: disablePartnerUser
	*Parameter:
	*Description: This class is used to trigger a Flow "Account_Flag_Update"
					 
*******************/	
public class PRMDisablePartnerUser implements Queueable 
{
   //try{	 
	Set<ID> accId;
	
	public PRMDisablePartnerUser(Set<ID> accId){
		this.accId = accId;
	}
	
	public void execute(QueueableContext context) 
	{
			system.debug('accId .....'+ accId);
			List<User> partnerUsers = new List<User>();
			partnerUsers = [select id, accountid, contactid, IsPortalEnabled from user where accountid in:accId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('partnerUsers .....'+ partnerUsers);
			for(User PartnerU : partnerUsers){
				//PartnerU.accountid = '';
				//PartnerU.contactid = '';
				PartnerU.IsPortalEnabled = false;
			}
			
			system.debug('partnerUsers : '+partnerUsers);
			database.update(partnerUsers);
			system.debug('partnerUsersafter update : '+partnerUsers);
			 system.debug('accId : '+accId);
			if(accId != null && accId.size() > 0 ){
			   
			//ID jobID = System.enqueueJob(new UpdateIsPartnerFlagOnAccount(accId));
			//System.debug('Quable job "UpdateIsPartnerFlagOnAccount" id for account - ' + accId  + ' user update is: ' + jobID);	  
			}
	   
	}
}