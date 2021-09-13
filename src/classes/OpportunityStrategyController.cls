public class OpportunityStrategyController
{
	@AuraEnabled(cacheable=true)
	public static boolean allowedUserToEdit(ID recordId)
	{
		try
		{
			List<Opportunity> oppList = [SELECT ID,Phase_Status__c FROM Opportunity WHERE ID=:recordId];
			if(oppList.isEmpty())
				return false;
			else
			{
				if((oppList[0].Phase_Status__c).contains('Submitted for'))
					return false;
				else
				{
					Id profileId = UserInfo.getProfileId();
					List<Profile> profilesList = [SELECT ID,name 
													FROM Profile 
												   WHERE Name IN ('Excel Add-In Profile','Sales Ops Profile','Non-Sales User Profile',
																  'Nokia Sales Profile','Nokia Admin Profile','System Administrator',
																  'Integration API Only Profile','DeployProfile','Global Process Admin Profile',
																  'Data Loader Profile')];

					if(profilesList.isEmpty())																	
						return false;
					else
					{
						for(Profile p: profilesList)
							if((p.Id).equals(profileId))
								return true;						
					}   
				}
			}
			return false;
		}
		catch(Exception e){
			System.debug('[OpportunityStrategyController] --> '+e.getLineNumber()+' '+e.getTypeName()+' '+ e.getMessage()+' '+e.getStackTraceString());
			return false;
		}
	}//end saveOppRecord method


	@AuraEnabled(cacheable=true)
	public static boolean saveOppRecord(Opportunity opp)
	{
		try
		{
			update opp; 
			return true;
		}
		catch(Exception e){
			System.debug('[OpportunityStrategyController] --> '+e.getLineNumber()+' '+e.getTypeName()+' '+ e.getMessage()+' '+e.getStackTraceString());
			return false;
		}
	}//end saveOppRecord method
}//end class