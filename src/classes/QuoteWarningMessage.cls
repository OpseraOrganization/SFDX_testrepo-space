public with sharing class QuoteWarningMessage{
//This class will handle the logic for warning message on Quote/Proposal Object
	
	/******************************
	*Method Name: getquoteId
	*Description: Test Method will get Quote/Proposal id for displaying the error message
	*Parameters: Id recordId
	********************************/
	@AuraEnabled  
	public static String getQuoteId(Id recordId){
  
		String quoteWarningMsg = GlobalConstants.BLANK_VALUE;
		Datetime dateTimeNow = System.now(); 
		Long timeNow = dateTimeNow.getTime();
		Long timeCreated;
		Long timeDifference;
		
		List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		try{
			
			system.debug('recordId'+recordId);		
			String objectName = recordId.getSObjectType().getDescribe().getName();
			system.debug('InQuote>>>>>'+objectName);
			
		   
			if(objectName.equalsIgnoreCase('Apttus_Proposal__Proposal__c')) {
			   quoteList = [SELECT id, Apttus_Proposal__Approval_Stage__c,CreatedDate FROM Apttus_Proposal__Proposal__c where Id=:recordId];

				
				if(!quoteList.isEmpty())
				  {
				   
					timeCreated = quoteList.get(0).CreatedDate.getTime();
					timeDifference = timeNow - timeCreated;  
					
					System.debug('time created>>>>>>>>>'+timeCreated);
					
					System.debug('time now>>>>>>>>>'+timeNow);
					
					System.debug('time difference'+timeDifference);
				
					if(quoteList.get(0).Apttus_Proposal__Approval_Stage__c =='Draft' && timeDifference <=60000)
					 {
					   quoteWarningMsg = system.label.NOKIA_CPQ_QuoteWarning;
					 }
					 else
					 {
					  quoteWarningMsg = GlobalConstants.BLANK_VALUE;
					 }
				  }
				}
			return quoteWarningMsg; 
		}
		catch(Exception e)
		{
		 System.debug('Exception found'+e);
		 return quoteWarningMsg;
		}
				
	}
}