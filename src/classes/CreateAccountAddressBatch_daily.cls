/** 
* Description :daily batch class called by the scheduled class DeniedPartyRequestSchedulable_daily
               processes all the account address that are updated on that day 
                except  with Report_Account_name__c like \'%VARIOUS%\' 
               and Formula_Strategic_Business_Unit__c like \'%Intercompany%\'
                and Denied_Party_Status__c like \'Whitelist\' and AccountStatus__c!=\'Inactive\'
                and devides the records into batchs of size 2000 
                this passes each batch to DeniedPartyRequest class which formats the data and calls the 
                pi webservice that passes it on to gts
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log ============ Ver Date Author Modification --- ---- ------ -------------* */ 

global class CreateAccountAddressBatch_daily implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global final String Query;
    global final String Entity;
    global final String Field;
    global final String Value;

    global Database.QueryLocator start(Database.BatchableContext BC){
        // Added for the Certido # - 356062 - Start
     //   Datetime StartDate = Datetime.now()-1;
      //  Datetime EndDate = Datetime.now();
        // return Database.getQueryLocator('select name,Address_LineFormulae1__c,Account_Name__c,ACCOUNT_CITY_NAME__C,AccountNameFormula__c,ADDRESS_POSTAL_CODE__C,ADDRESS_NAME__C,COUNTRY_CODE__C,Address_Work_Phone__c,Address_Fax__c from account_address__c where  (not (Report_Account_name__c like \'%VARIOUS%\'))  and (not (Formula_Strategic_Business_Unit__c like \'%Intercompany%\')) and LastModifiedDate = TODAY and (not (Denied_Party_Status__c like \'Whitelist\'))  and AccountStatus__c!=\'Inactive\' order by name');
        //return Database.getQueryLocator('select name,Address_LineFormulae1__c,Account_Name__c,ACCOUNT_CITY_NAME__C,AccountNameFormula__c,ADDRESS_POSTAL_CODE__C,ADDRESS_NAME__C,COUNTRY_CODE__C,Address_Work_Phone__c,Address_Fax__c from account_address__c where  (not (Report_Account_name__c like \'%VARIOUS%\'))  and (not (Formula_Strategic_Business_Unit__c like \'%Intercompany%\')) and LastModifiedDate >= YESTERDAY and LastModifiedDate <= TODAY and (not (Denied_Party_Status__c like \'Whitelist\'))  and AccountStatus__c != \'Inactive\' and (not(Owner.Profile.Name like \'%Portal API User%\')) and (not(Owner.Profile.Name like \'%DeniedPartyScreeningAPIUser%\'))  order by name');
          return Database.getQueryLocator('select name,Address_LineFormulae1__c,Account_Name__c,ACCOUNT_CITY_NAME__C,AccountNameFormula__c,ADDRESS_POSTAL_CODE__C,ADDRESS_NAME__C,COUNTRY_CODE__C,Address_Work_Phone__c,Address_Fax__c from account_address__c where  (not (Report_Account_name__c like \'%VARIOUS%\'))  and (not (Formula_Strategic_Business_Unit__c like \'%Intercompany%\')) and LastModifiedDate >= YESTERDAY and LastModifiedDate <= TODAY and (not (Denied_Party_Status__c like \'Whitelist\'))  and AccountStatus__c != \'Inactive\' order by name');
     
        // Added for the Certido # - 356062 - End
    }


    global void execute(Database.BatchableContext BC,List<sObject> scope){
        string body='';
        DeniedPartyRequest.SendRequest(scope);
    }

    global void finish(Database.BatchableContext BC){
    }
}