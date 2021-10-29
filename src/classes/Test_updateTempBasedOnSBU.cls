@isTest
private  class Test_updateTempBasedOnSBU
{
    static testmethod void updateTempBasedOnSBU_Triggers(){

        Profile pf= [select id from Profile where name = 'System Administrator'];
    
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
    
        System.runAs(usr)
        {
            try
            {
                Account acc= new Account(name='NewAcnt', Market_Name__c = 'Helicopters');
                insert acc;
                
                acc.Strategic_Business_Unit__c = 'ATR';
                acc.Market_Name__c = 'Military';
                update acc;
                
                acc.Strategic_Business_Unit__c = 'BGA';
                update acc;
                
                acc.Strategic_Business_Unit__c = 'D&S';
                update acc;
                
                
                
                Account acc1 = new Account(name = 'New Test Account', Market_Name__c = 'Intercompany');
                insert acc1;
                
                acc1.Market_Name__c = 'Intercompany';
                acc1.Name = 'HONEYWELL EMPLOYEE AMERICAS';
                update acc1;

                acc1.Market_Name__c = 'Helicopters';
                acc1.Strategic_Business_Unit__c = 'D&S';
                update acc1;
            }
            catch(System.DMLException e){
            }
        }
    }
}