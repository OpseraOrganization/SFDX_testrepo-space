global without sharing class UpdateGoDirectViewForMgtCmpnyController {

    global static void getRecord() {
        List<Management_Sold_To__c> lstMgtSoldTos = Management_Sold_To__c.getAll().values();
        List<String> mgtAccounts = new List<String>();
        List<Account_Cross_Ref__c> acc = new List<Account_Cross_Ref__c>();
        List<Account_Cross_Ref__c> accRefList = new List<Account_Cross_Ref__c>();
        String accountId = '';
        String mgtAccountStr = '';
        system.debug('List1:'+lstMgtSoldTos);
        if(null != lstMgtSoldTos && lstMgtSoldTos.size() > 0){
            for(Management_Sold_To__c soldTo: lstMgtSoldTos){
                system.debug('soldTo - '+soldTo.Sold_To_Nos__c);
                string tempInput = '%' + soldTo.Sold_To_Nos__c + '%';
                acc = [Select Account_Name__c from Account_Cross_Ref__c xref where XREF_Type__c = 'SAP_SOLD_TO' AND External_Account_ID__c LIKE : tempInput  AND account_status__c = 'ACTIVE' AND (not external_account_name__c like '%do not use%')and (not external_account_name__c like '%reference account%') and (not external_account_name__c like '%various%') and account_name__r.name not in ('HONEYWELL UNIDENTIFIED PORTAL USERS', 'Honeywell Default Account', 'NO ACCOUNT FOUND', 'FSR TEMPORARY OPERATOR', 'Portal Missing Users (Do not use)') ];
            	accRefList.add(acc[0]);    
                mgtAccountStr = mgtAccountStr +acc.get(0) +',';
                system.debug('mgtAccounts - '+mgtAccountStr);
            }
			Set<Id> setId = new Set<Id>();
			for(Account_Cross_Ref__c acr :accRefList)
			{
				setId.add(acr.Account_Name__c);
			}
			System.debug('setId::'+setId);
			List<Account> account = [Select GoDirect_View__c, id, name from Account where id IN: setId];
			List<Account> lstAccToUpdate = new List<Account>();
			for(Account a: account)
			{
				a.GoDirect_View__c = 'Management Company';
				lstAccToUpdate.add(a);
			}
			System.debug('lstAccToUpdate::'+lstAccToUpdate);
            update lstAccToUpdate;
            
        }
    }  
}