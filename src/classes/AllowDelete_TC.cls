@isTest

private class AllowDelete_TC{

static testMethod void AllowDelete_TM()
    {
        /*Id pfid = '00e30000001Wlfd';
        //Profile pf = [select id from Profile where name = 'GTO DS FSE (US)'];
        
        User usr = new User(LastName = 'Test UserSol',Username = 'tu1cso@test.com',
        Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        
                
            Account newacc = new Account(Name = 'Test Account', Type = 'Energy', 
            Strategic_Business_Unit__c = 'ATR', Customer_Status__c = 'Active', Region_Name__c= 'Americas', 
            Service_Level__c = 'Standard', REPORT_ACCOUNT_NAME__c = 'New Test Account');
            insert newacc; 
            
            system.runas(usr)
        {
        
         
            Contact newcon = new Contact(firstname = 'Test', LastName = 'Contact', AccountId = newacc.Id, Phone_3__c = '987654321',
            Contact_Is_Employee__c = true, Contact_Status__c = 'Active', Employee_Contact_Role__c = 'Analyst', Employee_Number__c = 'E67890' );
            insert newcon;
       
            Skills2__c newskill = new Skills2__c(Contact__c = newcon.id, Skill_Type__c = 'Supported Product',
            Product_Type__c = 'Services', Catalog_Product_Group__c = 'Training (SV)',
            Supported_Product__c = 'Avionics Simulators (PC)', Expertise__c = '1-Basic', Primary_Secondary__c = 'Primary');
            insert newskill;
              
            try{
                delete newskill;
            }
            catch(System.DMLException e){
                System.assert(
                e.getMessage().contains(
                'Please Contact your System Administrator: Deletion Not Permitted'),
                e.getMessage());    
            }
        }*/
    }
}