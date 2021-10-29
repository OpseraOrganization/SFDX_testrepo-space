@isTest(SeeAllData=true)
private class TestClass_ROActivitycreation 
{
    static testMethod void TestMthd_ROActivitycreation2 ()
    { 
        List<Case> lstCases = new List<Case>();          
        list<EmailMessage> lstnewEmails = new list<EmailMessage>(); 
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E123567');
        insert usr;
        Id userid = usr.Id;
        System.runAs(usr)
        {  
            try
            {
                Account acc = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
                insert acc;
                Contact con = new Contact(lastname='Test1',firstname='firstname1',accountId=acc.Id,
                Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@honeywell.com.qa',email='mythreyee.sureshkumar@honeywell.com.qa');
                insert con; 
                
                Agent_Contact_Mapping__c acm = new  Agent_Contact_Mapping__c();
                acm.CSR__c = usr.Id; 
                acm.Contact__c = con.Id;
                acm.Process__c = 'R&O Avionics';
                insert acm;

                Case cs = new Case();
                cs.Origin = 'Phone';
                cs.Status = 'Open';
                cs.subject = 'test case';
                if(con.Id != NULL || con.Id != ''){
                cs.ContactId = con.Id;
                }else {
                cs.ContactId = [Select Id from Contact Limit 1].Id;
                }
                cs.Classification__c = 'GTO Field Service';
                cs.HON_Commit_Date__c = System.now() + 1;
                cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cs.Government_Compliance_SM_M_Content__c = 'NO';
                //cs.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
                cs.AccountId = acc.Id;
                cs.Agent_Contact_Flag__c = false;
                cs.RecordTypeId = '01230000000Zen5AAC';            
                cs.R_O_Case_Origin__c = 'R&O Avionics';
                insert cs;
                                
                EmailMessage em =new EmailMessage();
                em.Incoming = true;
                em.ParentId = cs.Id; 
                em.FromAddress = 'venkatesh.athanti@nttdata.com';
                em.Subject = 'Test ROActivitycreation';
                em.ToAddress  = 'aeror&oavionics@honeywell.com';
                insert em;
                }
            catch(Exception e)
            {
                System.debug('Exception occured '+e);
            }
        }
      
    }
     static testMethod void TestMthd_ROActivitycreation1 ()
    {
        List<Case> lstCases = new List<Case>();          
        list<EmailMessage> lstnewEmails = new list<EmailMessage>(); 
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='T123567');
        insert usr;
        Id userid = usr.Id;
        System.runAs(usr)
        {  
            try
            {
                
                Case cs1 = new Case();
                cs1.Origin = 'Phone';
                cs1.Status = 'Open';            
                cs1.Classification__c = 'GTO Field Service';
                cs1.HON_Commit_Date__c = System.now() + 1;
                cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cs1.Government_Compliance_SM_M_Content__c = 'NO';
                //cs1.No_FCR_Reason__c='Not Trained';    For Ticket INC000009687923       
                cs1.Agent_Contact_Flag__c = false;
                cs1.RecordTypeId = '01230000000Zen5AAC';
                cs1.R_O_Case_Origin__c = null;
                cs1.OwnerId__c = '005e0000000NGX5';

                insert cs1;
                
                
                EmailMessage em1 =new EmailMessage();
                em1.Incoming = true;
                em1.ParentId = cs1.Id; 
                em1.FromAddress = 'venkatesh.athanti@nttdata.com';
                em1.Subject = 'Test1 ROActivitycreation';
                em1.ToAddress  = 'AeroROAvionicsQA@honeywell.com';
                insert em1;
                                                                              
            }
            catch(Exception e)
            {
                System.debug('Exception occured '+e);
            }
        }
    }
    static testMethod void TestMthd_ROActivitycreation3 ()
    {
        List<Case> lstCases = new List<Case>();          
        list<EmailMessage> lstnewEmails = new list<EmailMessage>(); 
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E123567');
        insert usr;
        Id userid = usr.Id;
        System.runAs(usr)
        {  
            try
            {
                
                Case cs2 = new Case();
                cs2.Origin = 'Phone';
                cs2.Status = 'Open';            
                cs2.Classification__c = 'GTO Field Service';
                cs2.HON_Commit_Date__c = System.now() + 1;
                cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cs2.Government_Compliance_SM_M_Content__c = 'NO';
                //cs2.No_FCR_Reason__c='Not Trained';     For Ticket INC000009687923      
                cs2.Agent_Contact_Flag__c = false;
                cs2.RecordTypeId = '01230000000Zen5AAC';
                cs2.R_O_Case_Origin__c = null;
                cs2.OwnerId__c = null;
                cs2.OwnerId = '00G30000002YnyT';
                //cs2.OwnerId = usr.Id;
                insert cs2;
                
                
                EmailMessage em2 =new EmailMessage();
                em2.Incoming = true;
                em2.ParentId = cs2.Id; 
                em2.FromAddress = 'venkatesh.athanti@nttdata.com';
                em2.Subject = 'Test1 ROActivitycreation';
                em2.ToAddress  = 'AeroROAvionicsQA@honeywell.com';
                insert em2;
                                                                              
            }
            catch(Exception e)
            {
                System.debug('Exception occured '+e);
            }
        }
    }
}