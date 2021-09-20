/******************************
 * Author : Christie JJ
 * Date : 06/04/2021
 * Description : The class monitors the Pre-Approved Custom Products Last Notification Date for all accounts in the org.
 *******************************/

global without sharing class PreApprovedProductsBatchJob implements Database.Batchable<sObject>,Database.Stateful
{
List<String> userEmailList;
Set<String> portfolioList = new Set<String>();
Map<Id,Account> mapAccount = new Map<Id,Account>();

global PreApprovedProductsBatchJob()
{
	userEmailList = new List<String>();
}
global Database.QueryLocator start(Database.BatchableContext BC)
{
	Date delayDate  = Date.today().addDays(-Integer.valueOf(System.Label.Pre_Approved_Product));
	// String query = 'SELECT Id,Pre_Approved_Product_Notification_Date__c,Country__c,Name,AccountNumber FROM Account WHERE Pre_Approved_Product_Notification_Date__c < :delayDate';
	String query = 'SELECT Id,Account__c,Portfolio__c,Account__r.Id, Account__r.Pre_Approved_Product_Notification_Date__c,Account__r.Country__c,Account__r.Name,Account__r.AccountNumber FROM Pre_Approved_Custom_Products__c WHERE Account__r.Pre_Approved_Product_Notification_Date__c = null OR Account__r.Pre_Approved_Product_Notification_Date__c < :delayDate';
	System.debug('[+] Inside start query size = '+Database.getQueryLocator(query));
	return Database.getQueryLocator(query);
}
global void execute(Database.BatchableContext BC, List<Pre_Approved_Custom_Products__c> preApprovedProductsList)
{
	if(preApprovedProductsList != null && preApprovedProductsList.size() > 0) {
		List<Account> accountListUpdate = new List<Account>();
		for(Pre_Approved_Custom_Products__c preApprovedProduct : preApprovedProductsList) {
			portfolioList.add(preApprovedProduct.Portfolio__c);
			if(!mapAccount.containsKey(preApprovedProduct.Account__c)) {
	mapAccount.put(preApprovedProduct.Account__c, preApprovedProduct.Account__r);
	accountListUpdate.add(new Account(Id = preApprovedProduct.Account__c, Pre_Approved_Product_Notification_Date__c=System.today()));
			}
		}

		system.debug('[+] portfolioList size = '+portfolioList.size());
		//Query all cpq approvers with the portfolio list
		Map<Id,CPQ_Approver__c> cpqApprovers =  new Map<Id,CPQ_Approver__c>([SELECT Id, OwnerId, CreatedById, LastModifiedById, User__c,User__r.Email,User__r.IsActive, P__c, O__c, IN_Q__c,A__c FROM CPQ_Approver__c where IN_Q__c = true AND P__c IN: portfolioList AND User__r.IsActive = TRUE]);

		//Filter the list where the Account country matches the CPQ Approver country.
		for(CPQ_Approver__c cpq : cpqApprovers.values()) {
			for(Account accountRecord :mapAccount.values()) {
	if(cpq.O__c.split(', ').contains(accountRecord.Country__c))
		userEmailList.add(cpq.User__r.Email);
			}
		}
		system.debug('[+] userEmail size inside execute = '+userEmailList.size());


		//Update Notification Date on Account to Today
		if(accountListUpdate.size()>0) {
			Database.update(accountListUpdate, false);
			System.debug('[+] Updated completed with accountListUpdate size = '+accountListUpdate.size());
		}
	}
}
global void finish(Database.BatchableContext BC) {
	if(mapAccount.size() > 0) {
		sendmail();
	}
}

//Send Email to all CPQ Approver Users.
public void sendmail()
{
	system.debug('[+] userEmail size inside finish = '+userEmailList.size());
	String htmlBody1 = Nokia_CPQ_Constants.HTMLBODY1_BATCH;
	String htmlBody2=Nokia_CPQ_Constants.HTMLBODY2;
	String rowData = Nokia_CPQ_Constants.ROWDATA;
	for(Account accountRecord : mapAccount.values()) {
		rowData+=Nokia_CPQ_Constants.ROWDATA1;
		rowData+=URL.getSalesforceBaseUrl().toExternalForm()+'/'+accountRecord.Id;
		rowData+=Nokia_CPQ_Constants.ROWDATA2;
		rowData+=accountRecord.Name;
		rowData+=Nokia_CPQ_Constants.ROWDATA3;
		rowData+=accountRecord.AccountNumber;
		rowData+=Nokia_CPQ_Constants.ROWDATA4;
	}
	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	//string [] toaddress= New string[]{'christie.j@standav.com'};
	email.setSubject('Pre-Approved Custom Product Notification');
	//email.setPlainTextBody('Testing Apex Scheduler-Body : size = '+userEmailList.size());
	email.setHtmlBody(htmlBody1+rowData+htmlBody2);
	//email.setToAddresses(toaddress);
	email.setToAddresses(userEmailList);
	if(userEmailList.size()>0)
		Messaging.sendEmail(New Messaging.SingleEmailMessage[] {email});
}
}