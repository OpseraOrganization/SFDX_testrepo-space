/****************************************
 * Class Name : CustomerCompCtlr
 * Created Date: 1 November 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Apex Extension Class for NSACheck_JifflenowMeeting VF Page.
 * Test Class: CustomerCompCtlrTest
 *****************************************/
public class CustomerCompCtlr {
	
	/********************
	*Method Name: CustomerCompCtlr
	*Description: The extension constructor initializes the private member variable acct by using the getRecord 
	  method from the standard controller.
	*******************/
	public Account acct;
	public CustomerCompCtlr(ApexPages.StandardController stdController) {
			 this.acct = (Account)stdController.getRecord();
			 acct = [SELECT Id, Name, Customer_Compliance__c FROM Account WHERE Id = :acct.Id]; 
	}
	
	
   /********************
	*Method Name: checkNSA
	*Description: This method is used in NSACheck_JifflenowMeeting VF Page 
				  1. Throw an error if Customer_Compliance__c Picklist value is US_Govern.
	  2. Return a pagerefrence url VF Page if any other value is selected in Customer_Compliance__c
	*******************/
	 public pagereference checkNSA(){
					
		if(acct.Customer_Compliance__c=='US_Govern'){
		   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.JiffleNowMeeting_Error1+' ' +'<a href="/'+acct.id+'">'+acct.name+'</a>');
		   ApexPages.addMessage(myMsg); 
		   return null;
		}else{
			PageReference pageRef = new PageReference('/apex/jiffle__JNEvents?accid='+acct.Id);
			return pageRef;
		}	
	 }
}