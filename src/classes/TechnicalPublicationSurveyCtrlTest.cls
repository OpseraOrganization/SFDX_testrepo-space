/***********************************************************************************************************
* Company Name          : Tata Consultancy Services
* Name                  : TechnicalPublicationSurveyCtrlTest
* Description           : Test Class for the TechnicalPublicationSurveyController 
***********************************************************************************************************/
@isTest
public class TechnicalPublicationSurveyCtrlTest {
    
    public static testmethod void testOnInsert(){
        
        test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Technical Publication Survey').getRecordTypeId();

        Test.setCurrentPageReference(new pageReference('Page.TechPubSurvey'));
        System.currentPageReference().getParameters().put('email', 'test@gmail.com');
        System.currentPageReference().getParameters().put('strTech', '123');     
        
        Account act = new Account();
        act.Name = 'test';
        act.Type = 'Honeywell';
        act.APTS_Aviaso_Delta_Fleet_Count__c = 10;
        act.PFECN__c = 'Portal';
        
        insert act;
        
        Contact cont = new Contact();
        cont.LastName = 'test';
        cont.AccountId = act.id;
        cont.Contact_Function__c='N/A';
        cont.SBU_Contact__c = 'BGA';
        cont.CBT__c = 'BGA Aftermarket';
        cont.CBT_Team__c = 'OEM & Dealers';
        cont.Sales_Channel_Contact__c = 'Americas AM';
        cont.SC1__c = 'BGA AM Americas';
        cont.Is_Portal_Super_User__c = true;
        cont.Contact_Status__c ='Active';
        cont.Primary_Email_Address__c = 'test@gmail.com';
        
        insert cont;
        
        TechnicalPublicationSurveyController controller = new TechnicalPublicationSurveyController();
        Feedback__c feed = new Feedback__c();
        Feedback__c feed1 = new Feedback__c();

        //feed.Order_Number__c='123';
        feed.Interviewer_Name__c='0051B00000Co6yA';
        feed.Tech_Pub_Id__c = '123';
        feed.RecordTypeId = devRecordTypeId;
        insert feed;
        
        feed1.Interviewer_Name__c='0051B00000Co6yA';
        feed1.Tech_Pub_Id__c = '123';
        feed1.RecordTypeId = devRecordTypeId;
        insert feed1;
        
        controller.mysearchtext = '6';
        System.assertEquals(controller.mysearchtext, '6');


        controller.save();
        
        
        test.stopTest();
    }

}