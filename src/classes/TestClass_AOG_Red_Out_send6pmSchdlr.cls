@isTest
private class TestClass_AOG_Red_Out_send6pmSchdlr {
    
    static testMethod void testAOG_Red_Out_send6pmSchdlr() {
        
            Test.startTest();
            AOG_Red_Out_send6pm tstOppSchd = new AOG_Red_Out_send6pm();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('AOG_Red_Out_send6pm1',Shdlr,tstOppSchd);
            Test.stoptest();
            
    }
}