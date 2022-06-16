@istest
public class SWS_Constants_TEST {
	
	public static final String TEST = 'Nokia Employee';
	
	public static testmethod void constantsMtehod(){ 
		SWS_Constants constnts = new SWS_Constants();
		System.assertEquals(SWS_Constants.CONTTypeNokiaEmp,SWS_Constants.CONTTypeNokiaEmp);
		
		SWS_Constants.SWS_Constants();
	}
}