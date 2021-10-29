@isTest
private class TestClass_Update7DaysCaseAgedate{ 
    static testMethod void Update7DaysCaseAgedate(){
        Account acc=new Account(name='testacc',Customer_Status__c='Active');
        insert acc;
        
        Contact objContact = new Contact();
        objContact.LastName = 'test2424';
        objContact.FirstName = 'sbu2321';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.Employee_Number__c = 'E000002';
        insert objContact;
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.CreatedDate = system.today()-7;
        try{
            insert cs;
        }catch(DMLException e){}
        
        Case c = [select id,CaseNumber,(select id,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Eight_Emails_on_Case__c from CASE.Case_Extensions__r) from Case where id=:cs.id];
        EmailMessage newEmail = new EmailMessage();
        newEmail = new EmailMessage(FromAddress = 'aerodonotreply@honeywell.com', ToAddress= 'harikishore.vutukuri@honeywell.com', Subject = 'HIA - Action', TextBody = '2345678', ParentId = c.Id); 
        insert newEmail;
                
        Case_Extension__c CasExt1 = new Case_Extension__c();
        if(c.Case_Extensions__r!=null && c.Case_Extensions__r.size()>0){
            CasExt1 = c.Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt1.Case_object__c = c.id;                
        }
        CasExt1.X7_Days_Case_Age_date__c = null;
        CasExt1.X7_Days_Case_Age__c = FALSE;
        CasExt1.UFR_SBU__c = 'BGA';
        CasExt1.Manual_Intervention_Last_Modified_Date__c = system.today()-5;
        upsert CasExt1;
        
        List<Case_Extension__c> CasExtlist = [select id,UFR_SBU__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.LastModifiedDate,Case_object__r.Quote_Number__c,Case_object__r.CaseOwnerChanged__c,Case_object__r.SuppliedEMail,Case_object__r.Requestor_Email__c,Case_object__r.Origin,Case_object__r.Sales_Order_Number__c,Case_object__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c from Case_Extension__c where id=:CasExt1.id];       
        Test.StartTest();                       
        try{
        Update7DaysCaseAgedate  batch = new Update7DaysCaseAgedate();
        batch.start( (Database.BatchableContext) null );
        batch.execute( (Database.BatchableContext) null, CasExtlist);
        batch.finish( (Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        CasExt1.X7_Days_Case_Age_date__c = system.today();
        CasExt1.X7_Days_Case_Age__c = TRUE;
        update CasExt1;
        UFRPricing_EmailRemainderStatus batch1 = new UFRPricing_EmailRemainderStatus();
        batch1.start( (Database.BatchableContext) null );
        batch1.execute( (Database.BatchableContext) null, CasExtlist);
        batch1.finish( (Database.BatchableContext) null );
        batch1.execute((SchedulableContext) null );
        }catch(Exception e1){}
        Test.StopTest();
    }
}