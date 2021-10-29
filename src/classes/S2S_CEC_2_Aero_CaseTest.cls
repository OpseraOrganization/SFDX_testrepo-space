/*******************************************************************************
Name : S2S_CEC_2_Aero_CaseTest
Created By : Harry
Company Name : NTT Data China
Project : HW S2S Extension  
Created Date : 24th Jan 2016
Description : Test class for the trigger trg_SC_S2S_Case_With_C3

Updated By : Harry
Update Date : 12th Sep 2016
Description : Set up custom settings for unit tests.

Updated By : Harry
Update Date : 13th Oct 2016
Description : Removed custom settings for production deployment.
*******************************************************************************/
@isTest
private class S2S_CEC_2_Aero_CaseTest
{
  /*
  @TestSetup
  static void initSettings()
  {
    MuteTriggerForCaseBacthClass__c settings = MuteTriggerForCaseBacthClass__c.getOrgDefaults();
    settings.Disable_Triggers__c = false;
    settings.Object_Type__c = 'Case';
    upsert settings MuteTriggerForCaseBacthClass__c.Id;
  }
  */

  @isTest
  static void testAeroC3()
  {
    List<RecordType> caseRecordTypes = [select Id from RecordType where
    SobjectType = 'Case'
    and DeveloperName = 'Orders'];
    if (caseRecordTypes.isEmpty())
    {
      system.debug('****: no aero record type!');
      return;
    }

    Id aeroRecordTypeId = caseRecordTypes[0].Id;
    Case newCase = new Case();
    newCase.Subject = 'received case';
    newCase.Status = 'New';
    newCase.Priority = 'Normal';
    newCase.Origin = 'Other';
    newCase.CEC_Record_Type__c = 'C3CallCenter';
    newCase.Type = 'Order Status';
    newCase.Sales_Order_Number__c='test1234';
    newCase.First_Call_Resolution__c = true; // By pass custom validation rule.
    insert newCase;
    newCase = [select Export_Compliance_Content_ITAR_EAR__c, RecordTypeId,
    Government_Compliance_SM_M_Content__c
    from Case where Id = :newCase.Id];
    system.assertEquals(aeroRecordTypeId, newCase.RecordTypeId);
    system.assertEquals(newCase.Export_Compliance_Content_ITAR_EAR__c, 'Undetermined');
    system.assertEquals(newCase.Government_Compliance_SM_M_Content__c, 'Undetermined');
  }

  @isTest
  static void testAeroC4()
  {
    List<RecordType> caseRecordTypes = [select Id from RecordType where
    SobjectType = 'Case'
    and DeveloperName = 'Orders'];
    if (caseRecordTypes.isEmpty())
    {
      system.debug('****: no aero record type!');
      return;
    }

    Id aeroRecordTypeId = caseRecordTypes[0].Id;
    Case newCase = new Case();
    newCase.Subject = 'received case';
    newCase.Status = 'New';
    newCase.Priority = 'Normal';
    newCase.Origin = 'Other SBU Web Source';
    newCase.CEC_Record_Type__c = 'C4CallCenter';
    newCase.Type = 'Order Status';
    newCase.Sales_Order_Number__c='test1234';

    newCase.First_Call_Resolution__c = true; // By pass custom validation rule.
    insert newCase;
    newCase = [select Export_Compliance_Content_ITAR_EAR__c, RecordTypeId,
    Government_Compliance_SM_M_Content__c
    from Case where Id = :newCase.Id];
    system.assertEquals(aeroRecordTypeId, newCase.RecordTypeId);
    system.assertEquals(newCase.Export_Compliance_Content_ITAR_EAR__c, 'Undetermined');
    system.assertEquals(newCase.Government_Compliance_SM_M_Content__c, 'Undetermined');
  }
}