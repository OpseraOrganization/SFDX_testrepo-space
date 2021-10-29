@isTest
public class DSPC_ContactUs_test {
    static testMethod void myUnitTest() {
        DSPC_ContactUs Cntlr = new DSPC_ContactUs();  
        Cntlr.sendMail();  
        Cntlr.closebox();
    }
}