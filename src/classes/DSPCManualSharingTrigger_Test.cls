@istest(seealldata=false) 
public class DSPCManualSharingTrigger_Test {
    static testMethod void myUnitTest() {
        Platform__c pf = new Platform__c();
        pf.Name = 'Test Paltform one';
        pf.Model__c = '36-16AB';
        pf.Make__c = 'VARIOUS OEMS';
        pf.SAP_External_System__c = true;
        pf.Parent_Platform__c = null;
        insert pf;
        user systemAdmin=[select id from user where profile.name='System Administrator' and isActive=True and userRoleId!=null limit 1][0];
         Account ac = new Account();
        Contact con = new Contact();
       system.runAs(systemAdmin){
        ac.Name = 'Test Account';
        ac.Customer_Status__c = 'Active';
        ac.Region_Name__c = 'Americas';
        ac.Sub_Region_Name__c = 'United States';
        ac.Service_Level__c = 'Standard';
        ac.Strategic_Business_Unit__c = 'D&S';
        ac.CBT__c = 'DSPC';
        ac.CBT_Team__c = 'Orion';
        ac.Market_Name__c = 'Space';
        ac.Type = 'OEM';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Account';
        ac.DSPC_Account__c = true;
        insert ac; 
        system.debug('accountid'+ac.id);     
        
        con.Lastname = 'Test Portal';
        con.Accountid = ac.id;
        con.SBU_Contact__c = 'D&S';
        con.CBT__c = 'DSPC';
        con.CBT_Team__c = 'ORION';
        con.Email = 'test@test.com';
        insert con;
        }
        //account acc=[select id,name from account where Strategic_Business_Unit__c = 'D&S' and DSPC_Account__c = true limit 3];
        Profile p = [ select Id from Profile where Name=:'D&S_Partner_Portal_User'];
        User u = new User(ContactId = con.Id,
            Username = 'test@test.com.dspc',
            Email = 'test@test.com',
            LastName = 'lastName',
            Alias = 'alias',
            ProfileID = p.id,
            PortalRole = 'Manager',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8'
        );
        system.runAs(systemAdmin){
        insert u;  
        }     
        user u1=[select id,name from user where profileid =: p.id  and isactive = true and contact.accountid=:ac.id limit 1];
        //update
        //u.LastName = 'lastName1';
        //update u;
        
        system.runas(u1) {
        OppBeforeInsertHelperClass cls = new OppBeforeInsertHelperClass();
        opportunity op = new Opportunity();
        op.Name = 'Test Opportunity';
        op.StageName = 'Prospecting';
        op.CloseDate = date.today();
        system.debug('accountid>>>>>>>>>>'+ac.id);
        op.Accountid = ac.id;
        system.debug('op.accountid>>>>>>>>>>'+op.Accountid);
        op.End_User__c = ac.id;
        system.debug('op.enduser>>>>>>>>>>'+op.End_User__c);
        op.Platform__c = pf.id;
        system.debug('op.enduser>>>>>>>>>>'+op.Platform__c);
        op.Incumbent__c = 'Incumbent';
        system.debug('op.Incumbent__c>>>'+op.Incumbent__c);

       // insert op;
        
        system.debug('opportunity inserted>>>>'+op);
        system.debug('$$$$$$$$$$$$$$$$$$$$'+p.id);
        op.description = 'Test Description';
       // update op;
        }
        
         System.runAs(u) {
             u.FirstName = 'firstName';
             update u;
        }
    }
}