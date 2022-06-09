/****************************************
* Name : DS_EntitlementHeaderTest
* Author : Accenture

*****************************************/
@isTest
public class DS_EntitlementHeaderTest{

Public testmethod  static void TestDS_EntitlementHeader(){
 try{
	List<Account> acclist  = TestDataFactory.createAccount(1);

	insert acclist;

	DS_EntitlementHeader.GetEntitleRec(acclist[0].id);
	}catch (Exception ex) {
		  ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_EntitlementHeaderTest,CSWXGlobalConstant.TestDS_EntitlementHeader);
		   
		}		


}

}