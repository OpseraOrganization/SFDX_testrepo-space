/****************************************
 * Trigger Name : PreApprovedCustomProductsTriggerHandler   
 * Created Date: 6 June 2021
 * Created By : Christie JJ
 * Description : Handler Class for PreApprovedCustomProductsTrigger
 *****************************************/
public without sharing class PreApprovedCustomProductsTriggerHandler {
	static List<String> userEmailList= new List<String>();
	static List<String> accountMemberEmailList = new List<String>();
	static List<Account> accountList = new List<Account>();
	static Set<String> portfolioList = new Set<String>();
	static List<Pre_Approved_Custom_Products__c> preApprovedProductsList = new List<Pre_Approved_Custom_Products__c>();
	static Map<Id,CPQ_Approver__c> cpqApprovers = new Map<Id,CPQ_Approver__c>();
	static Set<Id> accountIds = new Set<Id>();
	
	public static void handleBeforeInsertOrUpdateTrigger(Map<Id,Pre_Approved_Custom_Products__c> newMap,Map<Id,Pre_Approved_Custom_Products__c> oldMap){

	   
		for(Pre_Approved_Custom_Products__c preApprovedRecord : newMap.values()){
			
			accountIds.add(preApprovedRecord.Account__c);
		}
		accountList=[SELECT Id,Country__c,AccountNumber,Name,Pre_Approved_Product_Notification_Date__c FROM Account WHERE ID IN :accountIds];
			 
			 
	system.debug('[+] accountIds size = '+accountIds.size());
	system.debug('[+] accountList size = '+accountList.size());
	//Fetch portfolios of all pre-approved custom products in the Account.
	for(Pre_Approved_Custom_Products__c preApprovedProduct : newMap.values())
	portfolioList.add(preApprovedProduct.Portfolio__c);
	system.debug('[+] portfolioList size = '+portfolioList.size());
	//Query all cpq approvers with the portfolio list
	cpqApprovers =  new Map<Id,CPQ_Approver__c>([SELECT Id, OwnerId, CreatedById, LastModifiedById, User__c,User__r.Email, P__c, O__c, IN_Q__c,A__c FROM CPQ_Approver__c where IN_Q__c = true AND P__c IN :portfolioList]);
	
	//Filter the list where the Account country matches the CPQ Approver country.
	for(CPQ_Approver__c cpq : cpqApprovers.values()){
		for(Account accountRecord :accountList){
		if(cpq.O__c.split(', ').contains(accountRecord.Country__c))
		userEmailList.add(cpq.User__r.Email);
		}
	}
	system.debug('[+] userEmail size inside execute = '+userEmailList.size());
	
	//Add logic to get Account Members
	List<Account_Member__c> accountMemberList = [SELECT Id,Is_active_User__c,Email__c FROM Account_Member__c WHERE Account__c IN :accountIds AND Is_active_User__c = true];
	for(Account_Member__c accountMember : accountMemberList)
	accountMemberEmailList.add(accountMember.Email__c);
	if(accountMemberEmailList.size()>0)
	System.debug('[+] accountMemberEmailList size = '+accountMemberEmailList.size()+' with 1st accountMember = '+accountMemberEmailList.get(0));

	//Send the Email
	sendmail();
	}


	 //Send Email to all CPQ Approver Users.
	 public static void sendmail()
	 {  List<String> accountNumberList = new List<String>();
		List<String> accountNameList = new List<String>();
		userEmailList.addAll(accountMemberEmailList);
		 system.debug('[+] userEmail size inside finish = '+userEmailList.size());
		 String htmlBody1 = Nokia_CPQ_Constants.HTMLBODY1_BATCH;
		 String htmlBody2=Nokia_CPQ_Constants.HTMLBODY2;
		 String rowData = Nokia_CPQ_Constants.ROWDATA;
		for(Account accountRecord : accountList){
			rowData+=Nokia_CPQ_Constants.ROWDATA1;
			rowData+=URL.getSalesforceBaseUrl().toExternalForm()+'/'+accountRecord.Id;
			rowData+=Nokia_CPQ_Constants.ROWDATA2;
			rowData+=accountRecord.Name;
			rowData+=Nokia_CPQ_Constants.ROWDATA3;
			rowData+=accountRecord.AccountNumber;
			rowData+=Nokia_CPQ_Constants.ROWDATA4;
			accountNumberList.add(accountRecord.AccountNumber);
			accountNameList.add(accountRecord.Name); 
		}
		
		 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		 
		 email.setSubject('Pre-Approved Custom Product Notification');
		 email.setHtmlBody(htmlBody1+rowData+htmlBody2);
		 if(userEmailList.size()>0){
		 email.setToAddresses(userEmailList);
		 Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
	 }
	 }
}