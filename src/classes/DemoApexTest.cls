@isTest
public class DemoApexTest {
    
    @isTest
    public static void helloMethod() {
        System.debug('Hello DemoApexTest');
    }
    
    public static testMethod void testNewMethod() {
        System.debug('DemoApexTest testNewMethod');
    }
}