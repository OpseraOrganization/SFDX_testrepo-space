/****************************************
* Name : DS_CPOValidity_CheckTest
* Author : Accenture

*****************************************/
@isTest
Private class DS_CPOValidity_CheckTest {
/****************************************
* Method Name : checkCPOValidityTest
* Author : Accenture

*****************************************/
	public static testMethod void checkCPOValidityTest(){
	   try{
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
	   
		DS_CPO_validation__c csCPOVAlidation = new DS_CPO_validation__c();
		csCPOVAlidation.CPO_MandatoryFields__c= 'Contract_Type_Name__c' ;
		csCPOVAlidation.CPO_Mandatory_Fields2__c = 'Terms__c';
		csCPOVAlidation.CPO_Mandatory_Fields3__c = null;
		csCPOVAlidation.CPO_Status__c =CSWXGlobalConstant.draft;
		csCPOVAlidation.Name='Draft_Mandatory_Fields';
		database.insert(csCPOVAlidation);
		
		 test.startTest();
		 Apttus_Config2__CustomerPurchaseOrder__c cpo = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpo.Contract_Type_Name__c='Contract';
		cpo.Legacy_CPO__c=true;
		cpo.Terms__c = 12;
		cpo.Apttus_Config2__Status__c=CSWXGlobalConstant.draft;
		database.insert(cpo) ;
		
		List <id> cpolist = new List<id>();
		cpolist.add(cpo.id);
		boolean testpass = DS_CPOValidity_Check.checkCPOValidity(cpolist);
		test.stopTest();
	   system.assertEquals(true, testpass);
		}
	  }catch(Exception ex){ ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_CheckTestclass,CSWXGlobalConstant.checkCPOValidityTestmethod);}
	}
/****************************************
* Method Name : checkCPOValidityTest2
* Author : Accenture

****************************************/
	public static testMethod void checkCPOValidityTest2(){
		
		 try{
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		
	  
		DS_CPO_validation__c csCPOVAlidation = new DS_CPO_validation__c();
		csCPOVAlidation.CPO_MandatoryFields__c= 'Contract_Type_Name__c' ;
		csCPOVAlidation.CPO_Mandatory_Fields2__c = 'Terms__c';
		csCPOVAlidation.CPO_Mandatory_Fields3__c = 'Payment_Terms__c';
		csCPOVAlidation.CPO_Status__c =CSWXGlobalConstant.draft;
		csCPOVAlidation.Name='Draft_Mandatory_Fields';
		insert csCPOVAlidation;
		
		test.startTest();
		Apttus_Config2__CustomerPurchaseOrder__c cpo2 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpo2.Terms__c=null;
		cpo2.Legacy_CPO__c=true;
		insert cpo2;
		
		List <id> cpolist2 = new List<id>();
		List <id> cpolist3 = new List<id>();
		cpolist2.add(cpo2.id);
		cpolist3.add(null);
		boolean testpass2 = DS_CPOValidity_Check.checkCPOValidity(cpolist2);
	   // boolean testpass3 = DS_CPOValidity_Check.checkCPOValidity(cpolist3);
	  
		test.stopTest();
		system.assertEquals(false, testpass2); 
		 }
		}catch(Exception ex){ ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_CheckTestclass,CSWXGlobalConstant.checkCPOValidityTestmethod2);}
	}
}