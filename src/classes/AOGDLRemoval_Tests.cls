@isTest
                    
public class AOGDLRemoval_Tests {

    public static testMethod void testMyController() {
        PageReference pageRef = Page.AOGDLRemoval;
        Test.setCurrentPage(pageRef);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('DLName', 'hawker');
      
        // Instantiate a new controller with all parameters in the page
        AOGDLRemoval controller = new AOGDLRemoval(); 
        controller.setUemail('siva.nannapaneni@honeywell.com');
        controller.setAdEmail('siva.nannapaneni@honeywell.com');
         controller.send();

    }
}