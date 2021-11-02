@isTest
public class SampleDemoApexClass {
private Integer num;
    
    @isTest
    public static void helloMethod() {
        System.debug('Change Hello SampleDemoApexClass helloMethod');
    }
    
    public static testMethod void testNewMethod() {
        System.debug('testMethod SampleDemoApexClass');
    }
}