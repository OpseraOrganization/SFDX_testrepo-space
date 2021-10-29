@isTest
private class TestClass_AOG_Red_Out_send6amSchdlr {
    
    static testMethod void testAOG_Red_Out_send6amSchdlr() {
        
            Test.startTest();
            AOG_Red_Out_send6am tstOppSchd = new AOG_Red_Out_send6am();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('AOG_Red_Out_send6am1',Shdlr,tstOppSchd);
            Test.stoptest();
            
    }
}