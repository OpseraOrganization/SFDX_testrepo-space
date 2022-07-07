/****************************************************************
* Class Name : HWS_Constants_TEST 
* Created Date: 
* Created By:  
* Description : Test class for HWS_Constants
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
@istest
public class HWS_Constants_TEST {
	
	public static final String TEST = 'Legal_Entity';
	
	public static testmethod void constantsMtehod(){ 
	   
		System.assertEquals(HWS_Constants.Legal_Entity,HWS_Constants.Legal_Entity);
		
		HWS_Constants.hwsConstantsmethod();
	}
	
	
	
}