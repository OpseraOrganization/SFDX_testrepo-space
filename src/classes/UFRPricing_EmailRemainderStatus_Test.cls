@isTest
class UFRPricing_EmailRemainderStatus_Test{
    static testMethod void UFRPricing_EmailRemainderStatus_Test() 
    {   
        Account a= new Account();
        a.Name='Tesst Account';
        a.Customer_Status__c='Active';
        a.Region_Name__c='Americas';
        a.Sub_Region_Name__c='Africa';
        a.Service_Level__c='Comprehensive';
        a.Strategic_Business_Unit__c='ATR';
        a.CBT__c='Airbus';
        a.CBT_Team__c='Airbus';
        a.Market_Name__c='Air Transport';
        a.Business_Owner__c='Ryan, Justin';
        a.Type='Air Cargo Transporter';
        a.REPORT_ACCOUNT_NAME__c='Test Report';
        a.Concierge__c = TRUE;
        a.RAI_Excluded__c = FALSE;
        insert a;

        Contact c= new Contact();
        c.AccountId=a.Id;
        c.LastName='Hari';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='test@honeywell.com';
        c.Phone_1__c= '12345678';
        c.Employee_Number__c = 'E000001';  
        insert c;
        
        List<Case> cas = new List<Case>();
        List<Case> cas1 = new List<Case>();
        case c1 = new case();
        c1.recordtypeid = label.Repair_Overhaul_RT_ID;
        c1.origin = 'UFR Pricing';
        c1.type = 'PO Mismtach';
        c1.Status = 'Open';
        c1.CreatedDate = system.today()-5;
        c1.CaseOwnerChanged__c = 'harikishore.vutukuri@honeywell.com';
        c1.Requestor_Email__c = '';
        c1.Sales_Order_Number__c = '634537456';
        c1.UFR_Standard_Price_Amount__c = 23.55;
        //insert c1;
        cas1.add(c1);
        case c2 = new case();
        c2.recordtypeid = label.Repair_Overhaul_RT_ID;
        c2.origin = 'UFR Pricing';
        c2.type = 'PO Mismtach';
        c2.Status = 'Open';
        c2.CreatedDate = system.today()-10;
        c2.Requestor_Email__c = 'harikishore@nrr.com';
        c2.Sales_Order_Number__c = '634537456';
        c2.UFR_Standard_Price_Amount__c = 23.55;
        //insert c2;
        cas1.add(c2);
        insert cas1;
        cas = [select id,CaseNumber,lastmodifieddate,createddate,(select id,UFR_SBU__c,Case_object__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.LastModifiedDate from CASE.Case_Extensions__r) from case where id IN:cas1];
        
        List<Case_Extension__c> elist = new List<Case_Extension__c>();
        for(Case cases:cas){
            Case_Extension__c e = new Case_Extension__c();
            if(cases.Case_Extensions__r!=null && cases.Case_Extensions__r.size()>0)
                e = cases.Case_Extensions__r;
                else
                e.Case_object__c = cases.id;
                e.Manual_Intervention_Last_Modified_Date__c = system.today()-5;
                e.UFR_SBU__c = 'D&S';
                elist.add(e);
        }
        try{
        update elist;
        EmailMessage newEmail = new EmailMessage();
        newEmail = new EmailMessage(FromAddress = 'aerodonotreply@honeywell.com', ToAddress= 'harikishore.vutukuri@honeywell.com', Subject = 'HIA - Action', TextBody = '2345678', ParentId = cas[0].Id); 
        insert newEmail;
        test.startTest();
        UFRPricing_EmailRemainderStatus batch = new UFRPricing_EmailRemainderStatus();
        batch.start( (Database.BatchableContext) null );
        batch.execute( (Database.BatchableContext) null, elist);
        batch.finish( (Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        test.stopTest();
        }catch(DMLException e){}
    }  
    static testMethod void UFRPricing_EmailRemainderStatus_Test1() 
    {   
        Account a= new Account();
        a.Name='Tesst Account';
        a.Customer_Status__c='Active';
        a.Region_Name__c='Americas';
        a.Sub_Region_Name__c='Africa';
        a.Service_Level__c='Comprehensive';
        a.Strategic_Business_Unit__c='ATR';
        a.CBT__c='Airbus';
        a.CBT_Team__c='Airbus';
        a.Market_Name__c='Air Transport';
        a.Business_Owner__c='Ryan, Justin';
        a.Type='Air Cargo Transporter';
        a.REPORT_ACCOUNT_NAME__c='Test Report';
        a.Concierge__c = TRUE;
        a.RAI_Excluded__c = FALSE;
        insert a;

        Contact c= new Contact();
        c.AccountId=a.Id;
        c.LastName='Hari';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='test@honeywell.com';
        c.Phone_1__c= '12345678';
        c.Employee_Number__c = 'E000001';  
        insert c;
        
        List<Case> cas = new List<Case>();
        List<Case> cas1 = new List<Case>();
        case c1 = new case();
        c1.recordtypeid = label.Repair_Overhaul_RT_ID;
        c1.origin = 'UFR Pricing';
        c1.type = 'PO Mismtach';
        c1.Status = 'Open';
        c1.CreatedDate = system.today()-10;
        c1.CaseOwnerChanged__c = 'harikishore.vutukuri@honeywell.com';
        c1.Requestor_Email__c = '';
        c1.Sales_Order_Number__c = '634537456';
        c1.UFR_Standard_Price_Amount__c = 23.55;
        //insert c1;
        cas1.add(c1);
        case c2 = new case();
        c2.recordtypeid = label.Repair_Overhaul_RT_ID;
        c2.origin = 'UFR Pricing';
        c2.type = 'PO Mismtach';
        c2.Status = 'Open';
        c2.CreatedDate = system.today()-10;
        c2.CaseOwnerChanged__c = 'harikishore.vutukuri@honeywell.com';
        c2.Requestor_Email__c = '';
        c2.Sales_Order_Number__c = '634537456';
        c2.UFR_Standard_Price_Amount__c = 23.55;
        //insert c2;
        cas1.add(c2);
        insert cas1;
        cas = [select id,CaseNumber,lastmodifieddate,createddate,(select id,UFR_SBU__c,Case_object__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.LastModifiedDate from CASE.Case_Extensions__r) from case where id IN:cas1];
        
        List<Case_Extension__c> elist = new List<Case_Extension__c>();
        for(Case cases:cas){
            Case_Extension__c e = new Case_Extension__c();
            if(cases.Case_Extensions__r!=null && cases.Case_Extensions__r.size()>0)
                e = cases.Case_Extensions__r;
                else
                e.Case_object__c = cases.id;
                e.Manual_Intervention_Last_Modified_Date__c = system.today()-10;
                e.UFR_SBU__c = 'ATR';
                elist.add(e);
        }
        try{
        update elist;
        EmailMessage newEmail = new EmailMessage();
        newEmail = new EmailMessage(FromAddress = 'aerodonotreply@honeywell.com', ToAddress= 'harikishore.vutukuri@honeywell.com', Subject = 'HIA - Action', TextBody = '2345678', ParentId = cas[0].Id); 
        insert newEmail;
        test.startTest();
        UFRPricing_EmailRemainderStatus batch = new UFRPricing_EmailRemainderStatus();
        batch.start( (Database.BatchableContext) null );
        batch.execute( (Database.BatchableContext) null, elist);
        batch.finish( (Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        test.stopTest();
        }catch(DMLException e){}
    }
    static testMethod void testschedule() {
        Test.StartTest();
        UFRPricing_EmailRemainderStatus sh1 = new UFRPricing_EmailRemainderStatus();
        String sch = '0 0 7 * * ?';
        system.schedule('Test Territory Check1', sch, sh1);
        Test.stopTest();  
    }
}