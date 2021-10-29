@isTest
public class MyAerospacePortalSurveyTest {
    @testSetup static void methodName() {
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.Type = 'Air Cargo Transporter';
        acc.APTS_Aviaso_Delta_Fleet_Count__c = 10;
        insert acc;        
        
        Contact con = new Contact();
        con.Is_Portal_Super_User__c = true;
        con.Contact_Status__c = 'Active';
        con.Primary_Email_Address__c = 'test@gmail.com';
        con.LastName = 'test';
        con.SBU_Contact__c = 'BGA';
        con.CBT__c='BGA Aftermarket';
        con.CBT_Team__c ='OEM & Dealers';
        con.Sales_Channel_Contact__c= 'Americas AM';
        con.Contact_Function__c = 'Maintenance';
        con.AccountId = acc.Id;        
        insert con;
    }
    
    @isTest static void testmethod1(){
        Test.startTest();
            Test.setCurrentPageReference(new pageReference('Page.MyAerospacePortalSurvey'));
            System.currentPageReference().getParameters().put('sonumber', '123');
            System.currentPageReference().getParameters().put('email', 'test@gmail.com');
            MyAerospacePortalSurvey ctrl = new MyAerospacePortalSurvey();
        	ctrl.feeedback.CES_Score__c = 8;
            ctrl.feeedback.FCR__c = 8;
        	ctrl.submitFeedback();
        Test.stopTest();
    }
    
    @isTest static void testmethod2(){
        Feedback__c fback = new Feedback__c();
        fback.Interviewer_Name__c = UserInfo.getUserId();
        fback.Order_Number__c = '123';
        fback.CES_Score__c = 8;
        fback.FCR__c = 8;
        insert fback;
        Test.startTest();
            Test.setCurrentPageReference(new pageReference('Page.MyAerospacePortalSurvey'));
            System.currentPageReference().getParameters().put('sonumber', '123');
            System.currentPageReference().getParameters().put('email', 'test@gmail.com');
            MyAerospacePortalSurvey ctrl = new MyAerospacePortalSurvey();
        Test.stopTest();
    }
    
    @isTest static void testmethod3(){
        Test.startTest();
            Test.setCurrentPageReference(new pageReference('Page.MyAerospacePortalSurvey'));
            System.currentPageReference().getParameters().put('email', 'test@gmail.com');
            MyAerospacePortalSurvey ctrl = new MyAerospacePortalSurvey();
        Test.stopTest();
    }
}