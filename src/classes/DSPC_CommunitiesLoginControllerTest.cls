@IsTest global with sharing class DSPC_CommunitiesLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
        DSPCLoginController controller = new DSPCLoginController();
       // controller.forwardToDSPCAuthPage();
       // controller.login();
        controller.forgotPassword();
      //  System.assertEquals(D_S_Portal_CommunitiesLogin, controller.forwardToDSPCAuthPage()); 
      //  System.assertEquals(null, controller.login());
      //  System.assertEquals(null, controller.forgotPassword());       
    }    
}