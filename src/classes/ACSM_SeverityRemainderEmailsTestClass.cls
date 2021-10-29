@isTest(SeeAllData=true)
Public class ACSM_SeverityRemainderEmailsTestClass{ 
    static testMethod void ACSM_SeverityRemainderEmailsTest(){
        Account acc=new Account(name='testaccFSS',Customer_Status__c='Active');
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'ACSM';
        con.FirstName = 'FSS';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'H287751';
        con.Phone_1__c = '9896746849';
        con.Phone_5__c = '5498436181';
        insert con;
        
        Datetime dt = system.now();
        Case c = new Case();
        c.Status = 'New';
        c.Recordtypeid = label.FSS_Tech_Issue_RT_ID;
        c.Origin = 'Email';
        c.Priority = 'Normal';
        c.CreatedDate = dt.addMinutes(-120);
        c.Lastmodifieddate = dt.addMinutes(-120);
        c.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c.Government_Compliance_SM_M_Content__c = 'No';
        c.Notes__c = 'test cases';
        c.Subject = 'FSS test cases';
        c.Classification__c = 'JX';
        c.ContactId = con.id;
        c.HON_Commit_Date__c = c.CreatedDate+1;
        insert c;
        c.Priority = 'Severity 1';
        c.SLA_Flag_Case_age__c = c.CreatedDate+1;
        update c;
        
        Case c1 = new Case();
        c1.Status = 'New';
        c1.Recordtypeid = label.FSS_Tech_Issue_RT_ID;
        c1.Origin = 'Email';
        c1.Priority = 'Normal';
        c1.CreatedDate = dt.addMinutes(-120);
        c1.Lastmodifieddate = dt.addMinutes(-120);
        c1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c1.Government_Compliance_SM_M_Content__c = 'No';
        c1.Notes__c = null;
        c1.Subject = 'FSS test cases';
        c1.Classification__c = 'JX';
        c1.HON_Commit_Date__c = c1.CreatedDate+1;
        insert c1;
        c1.Priority = 'Severity 1';
        c1.SLA_Flag_Case_age__c = c1.CreatedDate+1;
        update c1;
        
        List<Case> cas = [Select id,ownerid,Owner.Name,Notes__c,Owner.Email,CaseNumber,Contact.Name,Account.Name,Primary_Cell_Number__c,Primary_Work_Number__c,CreatedDate,Lastmodifieddate,Priority,Case_Ref_ID__c,Recordtypeid,Status from Case where id=:c.id or id=:c1.id];        
        Test.startTest();
        ACSM_SeverityRemainderEmails batch = new ACSM_SeverityRemainderEmails();
        batch.start((Database.BatchableContext) null );
        batch.execute((Database.BatchableContext) null, cas);
        batch.finish((Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        Test.stopTest();
    }
}