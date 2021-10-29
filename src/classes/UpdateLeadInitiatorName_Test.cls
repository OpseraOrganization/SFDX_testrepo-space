@isTest(Seealldata = true) 
public class UpdateLeadInitiatorName_Test {
    public static testMethod void loggedinAPIUSER()
    {
        ValidationRuleSettings__c ValdRlu= new ValidationRuleSettings__c();
        ValdRlu.Name = 'Test Setting';
        ValdRlu.Disable_Validation_Rules__c=True;
        insert ValdRlu;  
        // User testUser = [SELECT Id FROM User WHERE profileid='00ea000000286sN'and username='atrrmuapiuser@honeywell.com.rdf' limit 1];
        
        Profile  pf=[SELECT Id FROM Profile WHERE Name = 'Portal API User RO Automation'limit 1];
        
        UserRole ur = new UserRole(Name = 'Honeywell');
        //insert ur;
        User usr=new user();
        usr.ProfileId=pf.id;
        usr.LastName = 'last';
        usr.Email = 'puser000@amamama.com';
        usr.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        usr.CompanyName = 'TEST';
        usr.Title = 'title';
        usr.Alias = 'alias';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        
        insert usr;
        
        
        user usr1 = [Select id,Name from user where id= '0051300000BbHC4'];
        Id  RID =Schema.SObjectType.Lead.getRecordTypeInfosByName().get('ATR RMU Tool').getRecordTypeId();    
        system.runAs(Usr1)
        {
            
            Account acc = [Select id,Name,IATA_Code__c,ownerid from Account where IATA_Code__c !='' Limit 1];
             Contact tstCon =[Select id,Honeywell_ID__c from contact where (not email like '%@honeywell.com') and Honeywell_ID__c != '' and  CreatedDate > 2015-08-03T05:35:18.000+0000 limit 1];
           /* Contact con=new contact();
            Con.Honeywell_ID__c='547822';
            Con.LastName = 'Test';
            con.Accountid =acc.id;
            con.Email = 'Test@gmail.com';
            insert con;*/
            
            lead ld=new lead();
            ld.Status='Engaged';
            ld.Account_Address_line_1__c='test';
            ld.LastName = 'Test';
            ld.Company = 'Honey';
            ld.HONEYWELL_ID__c= tstCon.Honeywell_ID__c;
            ld.RecordtypeID = RID;
            ld.Service_Bulletins__c = 'Test';
            ld.Contact__c=tstCon.id;
            ld.Account__c = acc.id;
            ld.IATA_Code__c = acc.IATA_Code__c ;
            
            insert ld;
            
        }
        
        
    }
 /*   public static testMethod void loggedinGTOUSER()
    {
        
        // User testUser = [SELECT Id FROM User WHERE profileid='00ea000000286sN'and username='atrrmuapiuser@honeywell.com.rdf' limit 1];
        
        Profile  pf=[SELECT Id FROM Profile WHERE Name = 'GTO Business Admin (US)'limit 1];
        
        UserRole ur = new UserRole(Name = 'Honeywell');
        insert ur;
        User usr=new user();
        usr.ProfileId=pf.id;
        usr.LastName = 'last';
        usr.Email = 'puser000@amamama1.com';
        usr.Username = 'puser000@amamama1.com' + System.currentTimeMillis();
        usr.CompanyName = 'TEST';
        usr.Title = 'title';
        usr.Alias = 'alias';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usr.UserRoleId = ur.Id;
        //try{
        insert usr;
        
        
        Id  RID =Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Converted C&PS Lead').getRecordTypeId();    
        system.runAs(Usr)
        {
            Account acc = [Select id,Name,IATA_Code__c,ownerid from Account Limit 1];
            
            Contact con=new contact();
            Con.Honeywell_ID__c='547821';
            Con.LastName = 'Test';
            con.email ='Test@gmail.com';
            con.AccountID = acc.id;
            insert con;
            
            lead ld=new lead();
            ld.Status='Sales Qualified Lead (SQL)';
            ld.Account_Address_line_1__c='test';
            ld.LastName = 'Test';
            ld.Company = 'Honey';
            ld.HONEYWELL_ID__c= Con.Honeywell_ID__c;
            ld.RecordtypeID = RID;
            ld.Service_Bulletins__c = 'Test';
            ld.Contact__c=con.id;
            // ld.OwnerID = usr.id;
            insert ld;
            //update ld;
        }
        
        
    } */
    
}