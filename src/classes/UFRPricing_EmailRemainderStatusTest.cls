@isTest
class UFRPricing_EmailRemainderStatusTest{
    static testMethod void UFRPricing_EmailRemainderStatus_Test() 
    {   
        
        case c1 = new case();
        c1.recordtypeid = label.Repair_Overhaul_RT_ID;
        c1.origin = 'UFR Pricing';
        c1.type = 'PO Mismtach';
        c1.Status = 'Open';
        insert c1;
        List<Case> cas = [select id,CaseNumber,lastmodifieddate,createddate,(select id,UFR_SBU__c,Case_object__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.LastModifiedDate from CASE.Case_Extensions__r) from case where id=:c1.id];
        
        List<Case_Extension__c> elist = new List<Case_Extension__c>();
        for(Case cases:cas){
            Case_Extension__c e = new Case_Extension__c();
            if(cases.Case_Extensions__r!=null && cases.Case_Extensions__r.size()>0)
                e = cases.Case_Extensions__r;
                else
                e.Case_object__c = cases.id;
                e.Manual_Intervention_Last_Modified_Date__c = system.today()-6;
                e.UFR_SBU__c = 'BGA';
                elist.add(e);
        }
        update elist;
        
        EmailMessage newEmail = new EmailMessage();
        newEmail = new EmailMessage(FromAddress = 'aerodonotreply@honeywell.com', ToAddress= 'harikishore.vutukuri@honeywell.com', Subject = 'HIA - Action', TextBody = '2345678', ParentId = c1.Id); 
        insert newEmail;
        test.startTest();
        try{
        UFRPricing_EmailRemainderStatus batch = new UFRPricing_EmailRemainderStatus();
        batch.start( (Database.BatchableContext) null );
        batch.execute( (Database.BatchableContext) null, elist);
        batch.finish( (Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        }catch(Exception e){}
        test.stopTest();
    }   
}