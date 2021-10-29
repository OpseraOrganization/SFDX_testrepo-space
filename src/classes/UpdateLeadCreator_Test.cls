@isTest
public class UpdateLeadCreator_Test {
    @isTest
    Public Static void testMethod1(){
       // Contact tstCon =[Select id,Honeywell_ID__c from contact where (not email like '%@honeywell.com') and Honeywell_ID__c != '' and  CreatedDate > 2015-08-03T05:35:18.000+0000 limit 1];
        Id  RID =Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Create C&PS Lead').getRecordTypeId();
        Lead lead = new Lead();
        lead.Status='Sales Qualified Lead (SQL)';
        lead.Account_Address_line_1__c='test';
        lead.LastName = 'Test';
        lead.Company = 'Honey';
        lead.HONEYWELL_ID__c= '547821';
        lead.RecordtypeID = RID;
        lead.Service_Bulletins__c = 'Test';
        //lead.LeadSource = 'Honeywell.com.cn';
        insert lead;
        
        lead.Status='Disqualified'; 
        lead.Reasons_for_Disqualification__c = 'test';
        update lead;
        
        Id  RID1 =Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Convert C&PS Lead').getRecordTypeId();
        Lead lead1 = new Lead();
        lead1.Status='Engaged';
        lead1.Account_Address_line_1__c='test';
        lead1.LastName = 'Test';
        lead1.Company = 'Honey';
        lead1.HONEYWELL_ID__c= '547821';
        lead1.RecordtypeID = RID1;
        lead1.Service_Bulletins__c = 'Test';
        //lead.LeadSource = 'Honeywell.com.cn';
        insert lead1;

        
    }
}