/**
 * @description	   : 
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 12-21-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   12-15-2020   Raj Kamdar   Initial Version
**/
@isTest
public class QTO_AutomaticAssociationSchedulerTest {

	@isTest
	static void method1(){
		Test.startTest();
		QTO_AutomaticAssociationScheduler assosch = new QTO_AutomaticAssociationScheduler();
		String sch = '0 05 18 * * ?'; 
		system.schedule('TestCheck5', sch, assosch);
		Test.stopTest();
		}
}