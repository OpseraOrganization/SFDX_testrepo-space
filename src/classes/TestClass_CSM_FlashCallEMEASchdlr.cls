@isTest
private class TestClass_CSM_FlashCallEMEASchdlr {
    
    static testMethod void testCSM_FlashCallEMEASchdlr() {
        
            Test.startTest();
            CSM_FlashCallEMEA tstOppSchd = new CSM_FlashCallEMEA();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('CSM_FlashCallEMEA1',Shdlr,tstOppSchd);
            Test.stoptest();
            
    }
}