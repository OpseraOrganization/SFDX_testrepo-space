@isTest
private class TestClass_CSM_FlashCallAsiaPacificSchdlr {
    
    static testMethod void testCSM_FlashCallAsiaPacificSchdlr() {
        
            Test.startTest();
            CSM_FlashCallAsiaPacificRim tstOppSchd = new CSM_FlashCallAsiaPacificRim();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('CSM_FlashCallAsiaPacificRim1',Shdlr,tstOppSchd);
            Test.stoptest();
            
    }
}