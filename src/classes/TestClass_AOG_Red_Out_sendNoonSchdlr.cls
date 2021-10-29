@isTest
private class TestClass_AOG_Red_Out_sendNoonSchdlr {
    
    static testMethod void testAOG_Red_Out_sendNoonSchdlr() {
        
            Test.startTest();
            AOG_Red_Out_sendNoon tstOppSchd = new AOG_Red_Out_sendNoon();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('AOG_Red_Out_sendNoon1',Shdlr,tstOppSchd);
            Test.stoptest();
            
    }
}