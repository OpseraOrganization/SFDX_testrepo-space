/****************************************
 * Name : ExceptionHandlerTest
 * Author : Accenture
 * Description : Test class for ExceptionHandler class
 *****************************************/
 @istest
 private class ExceptionHandlerTest{
	/******************************
	*Method Name: ExceptionTest
	*Description: Test Method to cover all the methods of ExceptionHandler class
	********************************/

	static testMethod void ExceptionTest(){
		List<Exception__c> exceptionList = new List<Exception__c>();
		List<Account> acc = TestDataFactory.createAccount(1);
		List<Opportunity> oppty = TestDataFactory.OpportunityCreation(1,acc[0]);
		List<Product2> prod = TestDataFactory.productCreation(1);
		List<Nokia_Financial_Calendar__c> nfc = TestDataFactory.nokiaFinCalCreation(1);
		List<Order_Intake_Forecast__c> oif = TestDataFactory.orderIntakeCreation(1,oppty[0],prod[0],nfc[0]);
		List<Database.saveResult> sr = Database.update(oif,false);
		Exception__c ExceptionRecord = new Exception__c();
		//Exception ex;
		String className,methodName,message,fieldError,methodNameEx;
		className = 'Test Class';
		methodName = 'Test Method';
		message = 'Test Validation';
		fieldError = 'Test Error';
		try{
			database.insert(new Account());
		}
		Catch(Exception ex){
			ex.setMessage(GlobalConstants.VALIDATION+' ,'+GlobalConstants.VALIDATION_EXCEPTION+' ,'+GlobalConstants.MIXED_DML + GlobalConstants.COMMA+' ,'+GlobalConstants.REQUIRED_FILED_MISSING+GlobalConstants.COMMA+' ,'+GlobalConstants.DMLEXCEPTION+' ,'+GlobalConstants.SYSTEM_DML+'Test');
			ExceptionHandler.addException(ex,className,methodName);
		}
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			//Creating Exception record
			ExceptionRecord.Class__c = className;
			ExceptionRecord.Message__c = message;
			ExceptionRecord.Method__c = methodName;
			ExceptionRecord.Error__c = fieldError;
			exceptionList.add(ExceptionRecord);
			//insert ExceptionRecord;
			insert exceptionList;

		}
		//Calling methods from Exception handler class
		//ExceptionHandler.generateExceptionRecord(message,className,methodName,fieldError);
		ExceptionHandler.logException(exceptionList[0]);
		ExceptionHandler.logExceptions(exceptionList);
		ExceptionHandler.addExceptionForOIFBtach(oif,sr);
		ExceptionHandler.addExceptionForPSROBatch(oif,sr);
		ExceptionHandler.addExceptionForPSROEURBatch(oif,sr);
	}
 }