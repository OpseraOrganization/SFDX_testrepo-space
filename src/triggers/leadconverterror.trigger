trigger leadconverterror on Lead (after update) 
{


 for(Lead lead:System.Trigger.new)
  {
        if (lead.IsConverted && (lead.Account_SBU__c=='D&S' || lead.Account_SBU__c=='ATR' || lead.Account_SBU__c=='BGA') && lead.ConvertedOpportunityId == NULL) 
        {
        lead.addError('Please uncheck Do not create a new opportunity upon conversion');
        }
  }      
}