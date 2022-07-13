@isTest
public class SampleApexClass {
	private Integer num;
    
    @isTest
 	public static void helloMethod() {
        System.debug('helloMethod SampleApexClass');
    }
    
    public static testMethod void testNewMethod() {
        System.debug('testNewMethod SampleApexClass - change in sys log');
    }
}