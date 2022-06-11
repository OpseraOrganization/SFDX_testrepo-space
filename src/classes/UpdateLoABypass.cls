global class UpdateLoABypass implements Database.Batchable<sObject> 
{
	string MigrationSource;
	global UpdateLoABypass(string source)
	{
		MigrationSource=source;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		String query ='';	  
		
		if(MigrationSource=='fNOK')
		{	
			query ='SELECT Id,HighestOfferNumber__c, TotalOfferCount__c, sCRMOfferCount__c, Migration_Source__c FROM Opportunity WHERE Migration_Source__c = null OR Migration_Source__c =: MigrationSource';  
		}
		else if(MigrationSource=='fALU')
		{
			query ='SELECT Id,HighestOfferNumber__c, TotalOfferCount__c, sCRMOfferCount__c, Migration_Source__c FROM Opportunity WHERE Migration_Source__c =: MigrationSource';
		}
		
		System.debug(query);
		return Database.getQueryLocator(query);
	}
	
   
	global void execute(Database.BatchableContext BC, List<Opportunity> scope)
	{
		List<Opportunity> lstOppty = new List<Opportunity>();
		
		try
		{
			for(Opportunity oppty : scope)
			{
				if(oppty.Migration_Source__c == null || oppty.Migration_Source__c == 'fNOK')
				{
					oppty.HighestOfferNumber__c = oppty.TotalOfferCount__c;
				}   
				else if(oppty.Migration_Source__c == 'fALU')
				{
					if(oppty.HighestOfferNumber__c==null || oppty.HighestOfferNumber__c==0)
					{
						oppty.HighestOfferNumber__c = oppty.TotalOfferCount__c;
					}
					else
					{
						oppty.HighestOfferNumber__c = oppty.HighestOfferNumber__c + oppty.sCRMOfferCount__c;
					}
				}
				
				lstOppty.add(oppty);
			}
		
			DataBase.Update(lstOppty);
		} 
		catch(Exception ex)
		{					   
			System.debug(ex.getMessage());
			System.debug(ex.getCause());
		}	
	}

	global void finish(Database.BatchableContext BC)
	{
	}
}