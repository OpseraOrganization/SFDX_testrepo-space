/******************
@UpdatedDate: 1 apr 2022
******************/
@isTest
public class DemoApex4 {
private Integer num;
    
    @isTest
 	public static void helloMethod() {
        System.debug('Change Hello DemoApexClass4 new changes on 1 Apr');
    }
    
    public static testMethod void testNewMethod() {
        System.debug('Change Hello DemoApexClass4');
    }
}
