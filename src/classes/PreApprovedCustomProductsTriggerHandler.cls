/****************************************
 * Trigger Name : PreApprovedCustomProductsTriggerHandler
 * Created Date: 6 June 2021
 * Created By : Christie JJ
 * Description : Handler Class for PreApprovedCustomProductsTrigger
 *****************************************/
/******************************************************************
   Change Log
 *******************************************************************
   Date	Author	Change
   23/8/2021	Christie JJ			Edited Email message format,
																				consolidated SOQL queries
 *******************************************************************/
public without sharing class PreApprovedCustomProductsTriggerHandler {
static Set<String> userEmailList = new Set<String>();
static Set<String> portfolioList = new Set<String>();
static List<Map<String,String> > emailData = new List<Map<String,String> >();
Set<Id> eligiblePAP = new Set<Id>();
static Map<String,List<Pre_Approved_Custom_Products__c> > accountPAPMap = new Map<String,List<Pre_Approved_Custom_Products__c> >();
static Set<Id> accountIds = new Set<Id>();

public static void handleBeforeInsertOrUpdateTrigger(Map<Id,Pre_Approved_Custom_Products__c> newMap, Map<Id,Pre_Approved_Custom_Products__c> oldMap, String action) {

	Map<Id,Pre_Approved_Custom_Products__c> tempMap = ((action == 'Deleted') ? oldMap : newMap);

	for (Pre_Approved_Custom_Products__c preApprovedRecord: tempMap.values()) {
		string account = preApprovedRecord.Account__c;
		accountIds.add(preApprovedRecord.Account__c);
		portfolioList.add(preApprovedRecord.Portfolio__c);
		if (accountPAPMap.containsKey(account)) {
			List<Pre_Approved_Custom_Products__c> setPAP = accountPAPMap.get(account);
			setPAP.add(preApprovedRecord);
			accountPAPMap.put(account, setPAP);
		}
		else {
			accountPAPMap.put(account, new List<Pre_Approved_Custom_Products__c> {
		preApprovedRecord
	});
		}
	}

	system.debug('accountPAPMap-->' + accountPAPMap);
	system.debug('[+] portfolioList size = ' + portfolioList.size());
	//Added by Yashdeep for ITCCPQ-1444
	Set<string> countrySet = new Set<string>();

	Map<String,Schema.SObjectField> M_Objects_Schema_Field = Schema.getGlobalDescribe().get('Pre_Approved_Custom_Products__c').getDescribe().fields.getMap();
	for (Account accountRecord: [SELECT Id, Country__c, AccountNumber, Name, Pre_Approved_Product_Notification_Date__c,CurrencyIsoCode, (SELECT Id, Is_active_User__c, Email__c FROM Account__r WHERE Is_active_User__c = true) FROM Account WHERE ID IN: accountIds]) {
		List <Pre_Approved_Custom_Products__c> papSet = accountPAPMap.get(accountRecord.Id);
		system.debug('papSet-->' + papSet);
		Integer serialNumber = 1;
		for (Pre_Approved_Custom_Products__c pap: papSet) {
			Map<string,string> data = new Map<string,string>();
			data.put('#', String.valueOf(serialNumber));
			data.put('Account Name', accountRecord.Name);
			data.put('Account Number', accountRecord.AccountNumber + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + accountRecord.Id);
			if (action != 'Deleted' && action != '')
	data.put('Product', pap.Name + '(' + pap.Product_Code__c + ')' + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + pap.Id);
			else
	data.put('Product', pap.Name + '(' + pap.Product_Code__c + ')');

			data.put('Action', action);
			data.put('Maintenance Type', pap.Maintenance_Type__c);
			data.put('Change Description', '');

			if (action == 'Update') {

	string detail = '';
	Pre_Approved_Custom_Products__c oldPAP = oldMap.get(pap.Id);

	for (String str: M_Objects_Schema_Field.keyset()) {
		Schema.DescribeFieldResult a_Field_Description = M_Objects_Schema_Field.get(str).getDescribe();
		if ((a_Field_Description.isCustom() || (a_Field_Description.getName() == 'Name')) && pap.get(str) != oldPAP.get(str)) {
			system.debug('a_Field_Description.getLabel()-->' + a_Field_Description.getLabel());
			//If field is Date field, encode / symbol
			if (a_Field_Description.getType() == Schema.DisplayType.DATE) {
				Date old=Date.valueOf(oldPAP.get(str));
				Date current=Date.valueOf(pap.get(str));
				detail += '</br><b>Field name: </b>' + a_Field_Description.getLabel() + '(MM/DD/YYYY) , <b>Old value: </b>' + DateTime.newInstance(old.year(), old.month(), old.day()).format('MM/dd/yyyy')  + ' , <b>New value: </b> ' + DateTime.newInstance(current.year(), current.month(), current.day()).format('MM/dd/yyyy') + ' </br>';
			}

			//If field is Percent, encode % symbol
			else if (a_Field_Description.getType() == Schema.DisplayType.PERCENT) {
				
				detail += '</br><b>Field name: </b>' + a_Field_Description.getLabel() + ' , <b>Old value: </b>' + (oldPAP.get(str)!=null ? String.valueOf((((Decimal)oldPAP.get(str)).setScale(2, RoundingMode.HALF_UP))) : ' ') + '%, <b>New value: </b> ' + (pap.get(str)!=null ? String.valueOf((((Decimal)pap.get(str)).setScale(2, RoundingMode.HALF_UP))) : ' ') + '%</br>';
				
			}
			else if (a_Field_Description.getType() == Schema.DisplayType.CURRENCY) {
				String currencyUnit = accountRecord.CurrencyIsoCode;
				detail += '</br><b>Field name: </b>' + (string.valueOf(a_Field_Description.getLabel()) == 'List Price' ? 'List Price' : a_Field_Description.getLabel()) + ' , <b>Old value: </b>' + (oldPAP.get(str)!=null ? String.valueOf((((Decimal)oldPAP.get(str)).setScale(2, RoundingMode.HALF_UP))) : ' ') + ' ' + currencyUnit + ' , <b>New value: </b> ' + (pap.get(str)!=null ? String.valueOf((((Decimal)pap.get(str)).setScale(2, RoundingMode.HALF_UP))) : ' ') + ' ' + currencyUnit + ' </br>';
			}
			else detail += '</br><b>Field name: </b>' + a_Field_Description.getLabel() + ' , <b>Old value: </b>' + oldPAP.get(str) + ', <b>New value: </b> ' + pap.get(str) + '</br>';

		}
	}
	if(string.isNotEmpty(detail)) {
		data.put('Change Description', detail );
		emailData.add(data);
	}
			}else{
	emailData.add(data);
			}
			serialNumber++;
		}

		system.debug('emailData-->' + emailData);
		if (accountRecord.Account__r != null && accountRecord.Account__r.size() > 0) {
			for (Account_Member__c accountMember: accountRecord.Account__r)
	userEmailList.add(accountMember.Email__c);

		}
		countrySet.add(accountRecord.Country__c);
	}

		//Fetch all cpqapprover emails
		if(!portfolioList.isEmpty() && !countrySet.isEmpty()) {
		for (CPQ_Approver__c cpq: [SELECT Id, OwnerId, CreatedById, LastModifiedById, User__c, User__r.Email, P__c, O__c, IN_Q__c, A__c FROM CPQ_Approver__c where IN_Q__c = true AND P__c IN: portfolioList AND O__c != null]) {
			for (string country : countrySet) {
	if(cpq.O__c.split(', ').contains(country)) {
		userEmailList.add(cpq.User__r.Email);
		break;
	}
			}
		}
	}

	//Send the Email
	if (userEmailList.size() > 0)
		sendmail();
}

//Send Email to all CPQ Approver Users.
public static void sendmail() {

	system.debug('[+] userEmail size inside finish = ' + emailData[0].get('Change Description'));

	String htmlBody2 = Nokia_CPQ_Constants.HTMLBODY2;
	String emailContent = Nokia_CPQ_Constants.HTMLBODY1_TRIGGER;

	for (string key: emailData[0].keySet()) {
		emailContent += '<th>' + key + '</th>';
	}
	emailContent += '</tr>';
	// emailContent += '<tr><td>'+ emailData[0].get('#')+'</td><td>' +emailData[0].get('Account Name')+'</td><td>	'+emailData[0].get('Account Number')+' </td><td> 	'+emailData[0].get('Product')+'  </td><td>	'+emailData[0].get('Action')+'</td><td>	' +emailData[0].get('Maintenance Type')+'</td><td>'+String.valueOf(emailData[0].get('Change Description')).replace('List Price','List Price')+'</td></tr>';
	// system.debug('emailContent = ' + emailContent);
	// emailContent += '<tr><td>'+ emailData[0].get('#')+'</td><td>' +emailData[0].get('Account Name')+'</td><td>	'+emailData[0].get('Account Number')+' </td><td> 	'+emailData[0].get('Product')+'  </td><td>	'+emailData[0].get('Action')+'</td><td>	' +emailData[0].get('Maintenance Type')+'</td><td>'+ 'List Price'+'</td></tr>';
	// system.debug('emailContent = ' + emailContent);
	// for (Map<string,string> data: emailData) {
	// 	if (data.get('Product').split('\\|').size() > 1)
	// 		emailContent += '<tr><td>' + String.valueOf(data.get('#')) + '</td><td>' + String.valueOf(data.get('Account Name')) + '</td><td>'  + String.valueOf(data.get('Account Number')) + '</td><td>' + String.valueOf(data.get('Product')) + '</td><td>' + String.valueOf(data.get('Action')) + '</td><td>' + String.valueOf(data.get('Maintenance Type')) + '</td><td>' + data.get('Change Description') + '</td></tr>';
	// 	else
	// 		emailContent += Nokia_CPQ_Constants.ROWDATA5 + String.valueOf(data.get('#')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Account Name')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA1 + URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(data.get('Account Number')).split('\\|')[1] + Nokia_CPQ_Constants.ROWDATA2 + String.valueOf(data.get('Account Number')).split('\\|')[0] + Nokia_CPQ_Constants.ROWDATA8 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Product')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Action')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Maintenance Type')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + data.get('Change Description') + Nokia_CPQ_Constants.ROWDATA4;
	// }
	for (Map<string,string> data: emailData) {
		if (data.get('Product').split('\\|').size() > 1)
			emailContent += Nokia_CPQ_Constants.ROWDATA5 + String.valueOf(data.get('#')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Account Name')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA1 + URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(data.get('Account Number')).split('\\|')[1] + Nokia_CPQ_Constants.ROWDATA2 + String.valueOf(data.get('Account Number')).split('\\|')[0] + Nokia_CPQ_Constants.ROWDATA8 + Nokia_CPQ_Constants.ROWDATA1 + URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(data.get('Product')).split('\\|')[1] + Nokia_CPQ_Constants.ROWDATA2 + String.valueOf(data.get('Product').split('\\|')[0]) + Nokia_CPQ_Constants.ROWDATA8 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Action')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Maintenance Type')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + data.get('Change Description') + Nokia_CPQ_Constants.ROWDATA4;
		else
			emailContent += Nokia_CPQ_Constants.ROWDATA5 + String.valueOf(data.get('#')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Account Name')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA1 + URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(data.get('Account Number')).split('\\|')[1] + Nokia_CPQ_Constants.ROWDATA2 + String.valueOf(data.get('Account Number')).split('\\|')[0] + Nokia_CPQ_Constants.ROWDATA8 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Product')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Action')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + String.valueOf(data.get('Maintenance Type')) + Nokia_CPQ_Constants.ROWDATA7 + Nokia_CPQ_Constants.ROWDATA6 + data.get('Change Description') + Nokia_CPQ_Constants.ROWDATA4;
	}
	emailContent += '</table></body></html>';
	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	/*string[] toaddress = New string[] {
	'christie.j@standav.com'
	};*/
	email.setSubject('Pre-Approved Custom Product Notification');
	email.setHtmlBody(emailContent + htmlBody2);
	//email.setToAddresses(toaddress);
	email.setToAddresses(new List<string>(userEmailList));
	system.debug('[+] emailContent value = ');
	system.debug(emailContent);
	Messaging.sendEmail(New Messaging.SingleEmailMessage[] {
			email
		});
}
}