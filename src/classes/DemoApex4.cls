@isTest
public class DemoApex4 {
private Integer num;
    
    @isTest
 	public static void demoMethod() {
        System.debug('Change Hello DemoApex4');
    }
    
    public static testMethod void testNew() {
        System.debug('Change Hello DemoApex4');
    }
}