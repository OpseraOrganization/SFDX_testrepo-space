@isTest
private class TestClass_CSMFlashcallReportSchdlr {
    
    static testMethod void testCSMFlashcallReportSchdlr() {
        
            Test.startTest();
            CSM_FlashCallAmerics tstOppSchd = new CSM_FlashCallAmerics();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('CSM_FlashCallAmerics1',Shdlr,tstOppSchd);
            Test.stoptest();
            
    }
}