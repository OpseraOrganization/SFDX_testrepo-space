/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class CommunitiesLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
        DSPCLoginController controller = new DSPCLoginController();
        controller.forwardToDSPCAuthPage();
       // controller.login();
        controller.forgotPassword();
        controller.sendMail();
      //  System.assertEquals(D_S_Portal_CommunitiesLogin, controller.forwardToDSPCAuthPage()); 
      //  System.assertEquals(null, controller.login());
      //  System.assertEquals(null, controller.forgotPassword());  
      	CommunitiesLoginController clc = new CommunitiesLoginController();
        PageReference pageRef = Page.CommunitiesLogin;
		Test.setCurrentPage(pageRef);
        clc.forwardToAuthPage();
    }    
}