@isTest
public class CH_CasequeryTest {
	@isTest
	public static void constructorInitializationTest() {
	   PageReference pageRef = Page.excelfilepage;
	   Test.setCurrentPage(pageRef);
		String date2=string.valueof(Date.today());
	   pageRef.getParameters().put('startString', date2);
	   pageRef.getParameters().put('rtType','HWS');
	   CH_Casequery cs=new CH_Casequery();
	   cs.isHardWare =true;
	}
}