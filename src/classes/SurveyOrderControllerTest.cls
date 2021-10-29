@isTest
public class SurveyOrderControllerTest {
    
    
    public static testmethod void testOnInsert(){
 
        test.startTest();
        
        Test.setCurrentPageReference(new pageReference('Page.SurveyOrder'));
		System.currentPageReference().getParameters().put('sonumber', '123');
        
       /* Account acc = new Account();
        acc.Name = 'testAcc';
        acc.CurrencyIsoCode = 'USD - U.S. Dollar';
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
        con.CurrencyIsoCode = 'USD - U.S. Dollar';
        con.Contact_Function__c = 'Maintenance';
        con.AccountId = acc.Id;
        
        insert con;*/
        
        User user = new User();
        
        
        
        SurveyOrderController controller = new SurveyOrderController();
        Feedback__c f = new Feedback__c();
        
        f.Order_Number__c='1234';
        f.Interviewer_Name__c='0051B00000Co6yA';
        
       
        
        insert f;
        
        controller.save();
        
        controller.getValues();
        
        
        
    
        test.stopTest();
         
         
    }
}