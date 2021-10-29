@isTest
public class TechPubFeedbackUpdate_test {
    
    public static testMethod void testUpdate(){
        
        Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Technical Publication Survey').getRecordTypeId(); 
        test.startTest();
        TechPubFeedbackUpdate controller = new TechPubFeedbackUpdate();
        
        Feedback__c feed = new Feedback__c();
        feed.RecordTypeId = devRecordTypeId;
        feed.Tech_Pub_Id__c = '123';
        
        insert feed;
        
        
        Case cs = new Case();
        Id devRecordTypeId2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Tech Pubs').getRecordTypeId(); 
        cs.RecordTypeId = devRecordTypeId2 ;
        cs.Origin = 'Web';
        cs.Status = 'Open';
        cs.Type = 'Order Changes';
        cs.Subject = 'pub req:123';
        cs.Classification__c = '3rd Party Repair';
        cs.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs.Government_Compliance_SM_M_Content__c = 'Yes';
        
        insert cs;
        
        test.stopTest();
        
    }

}