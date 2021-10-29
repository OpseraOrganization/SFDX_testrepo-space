@isTest
private class S2S_CEC_2_Aero_LeadTest
{

    @isTest
    static void testC3Lead()
  {
    try
    {
      List<RecordType> listRecordType = [select Id from RecordType
                                                                                    where SobjectType = 'Lead'
                                                                                    and DeveloperName='Lead_Create_Layout'];
      if(listRecordType.isEmpty()) return;
      Id chinaLeadRecordType = listRecordType[0].Id;

            Lead newLead = new Lead();
      newLead.LastName = 'received lead';
            newLead.Company = 'Salesforce';
      newLead.CEC_Lead_Number__c = 'Lead-Test';
            newLead.CEC_Record_Type__c = 'C3 Lead';
            insert newLead;
    }
    catch(Exception e)
    {
      system.debug('----------test error:---------------');
      system.debug('----------error line:---------------' + e.getLineNumber());
      system.debug('----------error type:---------------' + e.getTypeName());
      system.debug('----------stack trace:---------------' + e.getStackTraceString());
      system.debug('----------detail info:---------------' + e.getMessage());
    }
  }

    @isTest
    static void testC4Lead()
  {
    try
    {
      List<RecordType> listRecordType = [select Id from RecordType
                                                                                    where SobjectType = 'Lead'
                                                                                    and DeveloperName='Lead_Create_Layout'];
      if(listRecordType.isEmpty()) return;
      Id chinaLeadRecordType = listRecordType[0].Id;

            Lead newLead = new Lead();
      newLead.LastName = 'received lead';
            newLead.Company = 'Salesforce';
      newLead.CEC_Lead_Number__c = 'Lead-Test';
            newLead.CEC_Record_Type__c = 'C4 Lead';
            insert newLead;
    }
    catch(Exception e)
    {
      system.debug('----------test error:---------------');
      system.debug('----------error line:---------------' + e.getLineNumber());
      system.debug('----------error type:---------------' + e.getTypeName());
      system.debug('----------stack trace:---------------' + e.getStackTraceString());
      system.debug('----------detail info:---------------' + e.getMessage());
    }
  }
  @isTest
    static void testC3Lead3()
  {
    try
    {
      List<RecordType> listRecordType = [select Id from RecordType
                                                                                    where SobjectType = 'Lead'
                                                                                    and DeveloperName='Lead_Create_Layout'];
      if(listRecordType.isEmpty()) return;
      Id chinaLeadRecordType = listRecordType[0].Id;
        Contact contact = new Contact(LastName = 'test',Honeywell_ID__c = 'received lead');
        insert contact;
            Lead newLead = new Lead();
      newLead.LastName = 'received lead';
            newLead.Company = 'Salesforce';
            newLead.Lead_Source_Other__c = 'Channel Partner';
      newLead.CEC_Lead_Number__c = 'Lead-Test';
            newLead.CEC_Record_Type__c = 'C3 Lead';
            insert newLead;
    }
    catch(Exception e)
    {
      system.debug('----------test error:---------------');
      system.debug('----------error line:---------------' + e.getLineNumber());
      system.debug('----------error type:---------------' + e.getTypeName());
      system.debug('----------stack trace:---------------' + e.getStackTraceString());
      system.debug('----------detail info:---------------' + e.getMessage());
    }
  }
}