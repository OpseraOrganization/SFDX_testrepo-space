/** 
* Description :Weekly batch class called by the scheduled class DeniedPartyRequestSchedulable
               processes all the account address except  with Report_Account_name__c like \'%VARIOUS%\' 
               and Formula_Strategic_Business_Unit__c like \'%Intercompany%\'
                and Denied_Party_Status__c like \'Whitelist\' and AccountStatus__c!=\'Inactive\'
                and devides the records into batchs of size 2000 
                As on date 17-8-2012 there are arround 44000 records so 22 batches are created.
                this passes each batch to DeniedPartyRequest class which formats the data and calls the 
                pi webservice
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log ============ Ver Date Author Modification --- ---- ------ -------------* */ 
 
global class CreateAccountAddressBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
global final String Query;
global final String Entity;
global final String Field;
global final String Value;


global Database.QueryLocator start(Database.BatchableContext BC){
return Database.getQueryLocator('select name,Address_LineFormulae1__c,Account_Name__c,ACCOUNT_CITY_NAME__C,AccountNameFormula__c,ADDRESS_POSTAL_CODE__C,ADDRESS_NAME__C,COUNTRY_CODE__C,Address_Work_Phone__c,Address_Fax__c from account_address__c where (not (Report_Account_name__c like \'%VARIOUS%\')) and (not (Formula_Strategic_Business_Unit__c like \'%Intercompany%\')) and (not (Denied_Party_Status__c like \'Whitelist\')) and AccountStatus__c!=\'Inactive\' order by name');
}


global void execute(Database.BatchableContext BC,List<sObject> scope){
string body='';
DeniedPartyRequest.SendRequest(scope);

}

global void finish(Database.BatchableContext BC){
}

}