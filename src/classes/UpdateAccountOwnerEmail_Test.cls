@isTest
public class UpdateAccountOwnerEmail_Test
{
    public static testmethod void RepLocator_AccountCreation(){
        Test.startTest();
        Country__c c = new Country__c(Name = 'test',SFDC_Country_Name__c = 'test');
        insert c;
        Account a = new account(Name = 'test',Customer_Status__c = 'Active',Strategic_Business_Unit__c = 'ATR',Service_Level__c = 'Standard',Type = 'test',
                              REPORT_ACCOUNT_NAME__c = 'test',Report_Address_Line_1__c = 'test',Report_Address_Line_2__c = 'test',Report_Address_Line_3__c = 'test',
                              Report_City_Name__c = 'test',Report_Postal_Code__c ='test',Report_Country_Name__c ='India',Country__c = c.id);
        insert a;
        Account_Address__c accountAddress = new Account_Address__c(Account_Name__c = a.id,Sync_from_account_address__c = false,Report_State_Name__c ='test',
                                                                 AccountOwner_Email__c = 'test@test.com');
        insert accountAddress;     
            accountAddress.Sync_from_account_address__c = true;
            update accountAddress;           
            if(accountAddress.Account_Name__c != null){            
                    if(null!=a.ownerid){
                        accountAddress.AccountOwner_Email__c = a.ownerid;                       
                    }            
            if(accountAddress.Sync_from_account_address__c == true){
                 accountAddress.BGAMob_Address_1__c = accountAddress.Report_Address_Line_1__c;
                 accountAddress.BGAMob_Address_2__c = accountAddress.Report_Address_Line_2__c;
                 accountAddress.BGAMob_Address_3__c = accountAddress.Report_Address_Line_3__c;
                 accountAddress.BGAMob_City_Name__c = accountAddress.Report_City_Name__c;
                 accountAddress.BGAMob_State_Province__c = accountAddress.Report_State_Code__c;
                 accountAddress.BGAMob_Postal_Code__c = accountAddress.Report_Postal_Code__c;
                 accountAddress.BGAMob_Country_Nm__c = accountAddress.Report_Country_Name__c;
              }     
            }   
           
        Test.stopTest();     
    }
}