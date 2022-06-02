@isTest
private class NF_CT001_LexForceComponentTest {
	 private static Account currentAccount;
 @isTest static void test_lexForce(){
		 List<Account> currentAccountList = NF_TestDataFactory.getAccounts(1);
		currentAccount=currentAccountList[0];
		currentAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		insert currentAccount;
	 
		NF_CT001_LexForceComponent controller = new NF_CT001_LexForceComponent();
	 
		  controller.inputObject=currentAccount;
		  controller.fieldName='Name';
		  string ObjectName=controller.ObjectName;
		  boolean isTextarea=controller.isTextarea;
		  boolean isCheckbox=controller.isCheckbox;
		  boolean isDatetime=controller.isDatetime;
		  boolean isDependentPicklist=controller.isDependentPicklist;
		  boolean isInput=controller.isInput;
		  boolean isLookup=controller.isLookup;
		  boolean isMultiPicklist=controller.isMultiPicklist;
		  boolean isPicklist=controller.isPicklist;
		  boolean isReadOnly=controller.isReadOnly;
		  
		  
		  controller.inputObject=currentAccount;
		  controller.fieldName='CTHeadEmail__c';
		  boolean isInput1=controller.isInput;
	 
		  controller.inputObject=currentAccount;
		  controller.fieldName='IsExcludedFromRealign';
		  boolean isInput2=controller.isInput;
	 
		  controller.inputObject=currentAccount;
		  controller.fieldName='NumberOfEmployees';
		  boolean isInput3=controller.isInput;
	 
	
		  system.assertEquals(isCheckbox,false);
		  
 }
}