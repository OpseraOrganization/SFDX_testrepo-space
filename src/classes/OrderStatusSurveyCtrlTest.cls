/***********************************************************************************************************
* Company Name          : Tata Consultancy Services
* Name                  : OrderStatusSurveyCtrlTest
* Description           : Test Class for the OrderStatusSurveyCtrl
***********************************************************************************************************/
@isTest
public class OrderStatusSurveyCtrlTest {

    
    public static testmethod void testOnInsert(){
        
        test.startTest();

        Test.setCurrentPageReference(new pageReference('Page.OrderStatusSurvey'));
        System.currentPageReference().getParameters().put('sonumber', '123');
        System.currentPageReference().getParameters().put('email', 'test@gmail.com');   
        
        
        
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
        
        List<User> lstUser =  [Select Id ,IsPortalEnabled  from User where Id =: UserInfo.getUserId() ];
        OrderStatusSurveyCtrl controller = new OrderStatusSurveyCtrl();
        Feedback__c feed = new Feedback__c();
        
        feed.Order_Number__c='123';
        feed.Interviewer_Name__c =lstUser[0].id;
        //feed.Interviewer_Name__c='0051B00000Co6yA';
        
        insert feed;
        
        
        controller.mysearchtext = '6';
        System.assertEquals(controller.mysearchtext, '6');

        controller.save();
        
        
        test.stopTest();
    }

}