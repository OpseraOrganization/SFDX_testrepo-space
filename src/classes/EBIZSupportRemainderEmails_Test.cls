@isTest(seealldata=true)
public class EBIZSupportRemainderEmails_Test
{
    testMethod static void EBIZtestMethod() 
    {   
        try
        {
            String body,sub;
            body = 'Test Case Body';
            sub = 'Test Subject';     
            List<Case> cas = new List<Case>();
            List<Account> acclist = new List<Account>();
            List<Contact> conlist = new List<Contact>();
            Account acc1 = new Account();
            acc1.Name = 'Testweb23';
            acc1.Customer_Status__c = 'Active';
            acc1.Strategic_Business_Unit__c = 'BGA';
            acc1.CBT__c = 'BGA Aftermarket';
            acc1.Region_Name__c = 'Americas';
            acc1.Sub_Region_Name__c = 'Canada';
            acc1.Service_Level__c = 'Standard';
            acc1.Type = 'Honeywell';
            acc1.RAI_Excluded__c = FALSE;
            acc1.REPORT_ACCOUNT_NAME__c = 'Honeywell';
            acclist.add(acc1);
            insert acclist;
            
            Contact objContact1 = new Contact();
            objContact1.LastName = 'hariiii2';
            objContact1.FirstName = 'testweb3';
            objContact1.AccountId = acclist[0].Id;
            objContact1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com.qa';
            objContact1.Email='harikishore.vutukuri@honeywell.com.qa';
            objContact1.User_Primary_Manager_Name__c = 'Test';   
            objContact1.User_Primary_Manager_EID__c = 'E827381';
            objContact1.Employee_Number__c = 'H287751';      
            conlist.add(objContact1);
            insert conlist;
            
            Case c1 = new Case();
            c1.Origin = 'web';
            c1.Status = 'Open';  
            c1.SuppliedEmail = 'mariakitheri.tinulin@nttdata.com';
            c1.ContactId = conlist[0].id;
            c1.AccountId =acclist[0].id;      
            c1.Notes__c = 'Test';
            c1.Browser__c = 'N/A';
            c1.OwnerId = Userinfo.getUserid();
            c1.RecordtypeId = Label.AerobizRecType;
            c1.type = 'FSS';
            c1.Classification__c = 'CSO Repair Order';        
            c1.Export_Compliance_Content_ITAR_EAR__c = 'No';
            c1.Government_Compliance_SM_M_Content__c = 'No';
            c1.Sales_Order_Number__c = '12345678';
            c1.CurrencyIsoCode = 'EUR - Euro';
            //c1.CaseOwnerChanged__c = 'mariakitheri.tinulin@nttdata.com';         
            c1.Description = 'Support remainder emails';
            c1.subject='test case';
            c1.Sales_Order_Number__c = '12345678';
            c1.Priority = 'Critical';
            c1.HON_Commit_Date__c = system.today();
            cas.add(c1);
            
            Case c2 = new Case();
            c2.Origin = 'web';
            c2.Status = 'Open';  
            c2.SuppliedEmail = 'mariakitheri.tinulin@nttdata.com';
            c2.Browser__c = 'N/A';
            c2.ContactId = conlist[0].id;
            c2.AccountId =acclist[0].id;    
            c2.Notes__c = 'Test';
            c2.OwnerId = Label.AEROBIZOwner_ID;
            c2.RecordtypeId = Label.AerobizRecType;
            c2.type = 'FSS';
            c2.Classification__c = 'CSO Repair Order';       
            c2.Export_Compliance_Content_ITAR_EAR__c = 'No';
            c2.Government_Compliance_SM_M_Content__c = 'No';
            c2.Sales_Order_Number__c = '12345678';
            c2.Requestor_Email__c='mariakitheri.tinulin@nttdata.com';  
            c2.Description = 'Test cases';
            c2.subject='test case';
            c2.CreatedDate = system.today()-3;
            c2.Sales_Order_Number__c = '12345678';
            c2.Priority = 'High';
            c2.HON_Commit_Date__c = system.today();
            cas.add(c2);
            
            Case c3 = new Case();
            c3.Origin = 'web';
            c3.Status = 'Open';  
            c3.SuppliedEmail = 'mariakitheri.tinulin@nttdata.com';
            c3.Browser__c = 'N/A';
            c3.ContactId = conlist[0].id;
            c3.AccountId =acclist[0].id; 
            c3.Notes__c = 'Test';
            c3.OwnerId = Label.AEROBIZOwner_ID;
            c3.RecordtypeId = Label.AerobizRecType;
            c3.type = 'FSS';
            c3.Classification__c = 'CSO Repair Order';       
            c3.Export_Compliance_Content_ITAR_EAR__c = 'No';
            c3.Government_Compliance_SM_M_Content__c = 'No';
            c3.Sales_Order_Number__c = '12345678';
            c3.Requestor_Email__c='mariakitheri.tinulin@nttdata.com';  
            c3.Description = 'Test cases';
            c3.subject='test case';
            c3.CreatedDate = system.today()-5;
            c3.Sales_Order_Number__c = '12345678';
            c3.Priority = 'Low';
            c3.HON_Commit_Date__c = system.today();
            cas.add(c3);
            insert cas;

            /*Test.setCreatedDate(c1.Id, System.Today() - 2);
            Test.setCreatedDate(c2.Id, System.Today() - 3);
            Test.setCreatedDate(c3.Id, System.Today() - 5); */                  
            Test.startTest();  
            EBIZSupportRemainderEmails emailbatch = new EBIZSupportRemainderEmails ();
            DataBase.executeBatch(emailbatch); 
            Test.stopTest();
        }
        catch(Exception e){ }
    }
    static testMethod void testschedule() {
        Test.StartTest();
        try
        {
            EBIZSupportRemainderEmails ebiz = new EBIZSupportRemainderEmails ();
            String em = '0 0 7 * * ?';
            system.schedule('Test Check', em , ebiz );
        }
        catch(Exception e){}
        Test.stopTest();  
    }
    /*static testMethod void testschedule1() {
        Test.StartTest();
        try
        {
            EBIZSupportRemainderEmails ebiz = new EBIZSupportRemainderEmails ();
            DataBase.executeBatch(ebiz);
            
        }
        catch(Exception e){}
        Test.stopTest();  
    }*/
}