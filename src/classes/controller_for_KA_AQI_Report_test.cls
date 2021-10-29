@isTest(SeeAllData=true)
public class controller_for_KA_AQI_Report_test {
    static testMethod void testCommented(){
        Test.StartTest();
        //The object name below has to match up with your trigger/class
        controller_for_KA_AQI_Report obj = new controller_for_KA_AQI_Report();
        //This one link is asserting that you successfully created it
        system.assertNotEquals(null,obj);   
        Test.StopTest();
    }
   /* public static testMethod void testMyController() {
        PageReference pageRef = Page.KAAQIReport;
        Test.setCurrentPage(pageRef);
      
        controller_for_KA_AQI_Report controller = new controller_for_KA_AQI_Report();
        //String nextPage = controller.filter().getUrl();
            controller.getData();
            controller.getRecordsToDisplay();
        
      
        // Instantiate a new controller with all parameters in the page
        controller = new controller_for_KA_AQI_Report(); 
        controller.setfilterInput('siva');
        
        controller.filter();
    }*/
}