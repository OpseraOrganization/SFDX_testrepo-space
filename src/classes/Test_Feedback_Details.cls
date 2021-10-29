@isTest(SeeAllData=false)
public class Test_Feedback_Details {
        
       
    
    static testMethod void Test_Feedback () {
     
        
        Test.startTest();
        Feedback__c fed =new Feedback__c(Communication__c='1');
        insert fed;

ApexPages.currentPage().getParameters().put('Id',fed.id);
        system.debug('fed'+fed.name);
        // Get the standard controller
               ApexPages.StandardController sc = new ApexPages.StandardController(fed);     

        Feedback_Details  controller = new Feedback_Details(sc);
        controller.Feedid = fed.id;
        Test.stopTest();
    }

    
}