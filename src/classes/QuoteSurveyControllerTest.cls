@isTest
public class QuoteSurveyControllerTest {
    
    public static testmethod void testOnInsert(){
        
        test.startTest();
        
        Test.setCurrentPageReference(new pageReference('Page.QuoteSurvey'));
        //System.currentPageReference().getParameters().put('quotenum', '123');
        System.currentPageReference().getParameters().put('email', 'test@gmail.com');
       System.currentPageReference().getParameters().put('casenum', '123');
        
       
         
      
        
        
        Account act = new Account();
        act.Name = 'test';
        act.Type = 'Honeywell';
        act.APTS_Aviaso_Delta_Fleet_Count__c = 10;
        act.PFECN__c = 'Portal';
        //act.Customer_Support_Focal__c = 'test1';
        
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
        
        /*
        User use = new User();
        //use.ContactId = con.Id;
        use.IsActive = true;
        use.ContactId = cont.Id;
        use.Alias = 'test';                                                                       
        use.Email = 'test@gmail.com';                                                                                                                       
        use.Username = 'test@tcs.com';                                          
        use.CommunityNickname = 'test';                                                                                                                      
        use.LastName = 'test';
        use.TimeZoneSidKey = 'America/Los_Angeles';
        use.LocaleSidKey = 'en_US';
        use.EmailEncodingKey = 'ISO-8859-1';
        use.ProfileId = pf.id;
        use.LanguageLocaleKey = 'en_US';
        
        insert use;*/
        
        QuotesurveyController controller = new QuotesurveyController();
        Feedback__c feed = new Feedback__c();
        
        feed.Order_Number__c='1234';
        feed.Interviewer_Name__c='0051B00000Co6yA';
       
        insert feed;
        /*
          Feedback__c feed1 = new Feedback__c();
        
        feed1.Order_Number__c='1234';
        feed1.Interviewer_Name__c='0051B00000Co6yA';
        
        insert feed1;
        */

        controller.save();
        controller.getValues();
        
        /*Account acto = new Account();
        acto.name = 'test2';
        acto.Type = 'Honeywell';
        acto.APTS_Aviaso_Delta_Fleet_Count__c = 10;
        acto.PFECN__c = 'Portal';
        
        insert acto;
        
        Contact con = new Contact();
        con.LastName='test2';
        con.AccountId = acto.Id;
        con.Contact_Function__c = cont.Contact_Function__c;
        con.SBU_Contact__c = cont.SBU_Contact__c;
        con.CBT__c = cont.CBT__c;
        con.CBT_Team__c = cont.CBT_Team__c;
        con.Sales_Channel_Contact__c = cont.Sales_Channel_Contact__c;
        con.SC1__c = cont.SC1__c ;
        con.Is_Portal_Super_User__c = cont.Is_Portal_Super_User__c;
        con.Contact_Status__c = cont.Contact_Status__c ;
        con.Primary_Email_Address__c = cont.Primary_Email_Address__c;
        
        insert con;*/
        
        
        
        
        
        test.stopTest();
    }
    
    
}