/* description: Scheduler to create Accruals for Account eligible Funds
* *author:	Accenture IDC.
* ============================================================================
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  Pooja Kurkute			15/05/2018	Release 4.1 PRM			   CO-OP
* ============================================================================ 
*/
global class MonthlyAccrualCreation implements schedulable
{
	private Date DateVal;
	global MonthlyAccrualCreation(Date DateVal) {
	   this.DateVal = DateVal;
	} 
/********************
	*Method Name: execute
	*Parameter:
	*Description: Each Month This method will create Accruals for Account eligible Funds		
*******************/
  global void execute(SchedulableContext sc)
   {
	  Date todaydate;
	  if(!Test.isRunningTest()) {
		  todaydate = System.today();
	  }
	  else {
		  todaydate = DateVal;
	  } 
	  Integer first = todaydate.day();
	  integer mmonth = todaydate.month();
	  integer yyear = todaydate.year();
	  string month = null;
	
	  //system.debug('first>>>>>'+first);
	   
	  List<Co_Op_Allocation__c> accrualList = new List<Co_Op_Allocation__c>();
	  List<Account> accountList = new List<Account>();
	  accountList = [SELECT Enrolled_in_Co_Op__c,Id,Name FROM Account 
					 Where Enrolled_in_Co_Op__c = true AND Active__c =: PRMGlobalConstants.TRUE_VALUE Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];  
	  //system.debug('accountList>>>>>>>>>'+accountList);
	  ////system.debug('fundList>>>>>>>>>'+fundList);
	   Try{ 
	   if(!accountList.IsEmpty()){
	   if(first == Integer.valueOf(System.label.Coop_creation_date)){
		for(Fund__c fund: [SELECT Id, Partner_Name__c FROM Fund__C 
				  WHERE  Partner_Name__c IN: accountList Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			Co_Op_Allocation__c accrual = new Co_Op_Allocation__c();
			accrual.Allocation_Year__c = String.valueOf(yyear);
			if(mmonth == 1){
			accrual.Allocation_Month__c = PRMGlobalConstants.December ;
			accrual.Allocation_Year__c = String.valueOf(yyear - 1);	
		}else if(mmonth == 2){
			accrual.Allocation_Month__c = PRMGlobalConstants.January;
		}else if(mmonth == 3){
			accrual.Allocation_Month__c = PRMGlobalConstants.February;
		}else if(mmonth == 4){
			accrual.Allocation_Month__c = PRMGlobalConstants.March;
		}else if(mmonth == 5){
			accrual.Allocation_Month__c = PRMGlobalConstants.April;
		}else if(mmonth == 6){
			accrual.Allocation_Month__c = PRMGlobalConstants.May;
		}else if(mmonth == 7){
			accrual.Allocation_Month__c = PRMGlobalConstants.June;
		}else if(mmonth == 8){
			accrual.Allocation_Month__c = PRMGlobalConstants.July;
		}else if(mmonth == 9){
			accrual.Allocation_Month__c = PRMGlobalConstants.August;
		}else if(mmonth == 10){
			accrual.Allocation_Month__c = PRMGlobalConstants.September;
		}else if(mmonth == 11){
			accrual.Allocation_Month__c = PRMGlobalConstants.October;
		}else{
			accrual.Allocation_Month__c = PRMGlobalConstants.November;
		}
			integer dd1 = 01;
			Date availableDate = date.newinstance(yyear, mmonth, dd1);
			accrual.Available_Date__c  = availableDate; 
			accrual.Partner_Name__c = fund.Partner_Name__c;
			accrual.Fund_Id__c = fund.id;
			accrualList.add(accrual);
		}
		//system.debug('accrualList>>>>>>>>>'+accrualList);
		database.insert(accrualList, false);
		//monthlyAccrualCreation sm = new monthlyAccrualCreation();
		//System.schedule('Monthly Reconciliation', CRON_EXP_NEXT_MONTH, sm);
	   }else{}
		  }
	   }
   catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.monthlyAccrualCreation ,PRMGlobalConstants.Execute);
		}
		
   } 
   }