@isTest 
public class PPO_EmailRemainderStatusTest
{
    testMethod static void PPOtestMethod() 
    {
        List<Case> cas = new List<Case>();
        List<Case> cas1 = new List<Case>();
        
        Case c1 = new Case();
        c1.Origin = 'web';
        c1.Status = 'Open';  
        c1.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        c1.RecordtypeId = Label.OEM_Spares;
        c1.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        c1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c1.Government_Compliance_SM_M_Content__c = 'No';
        c1.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        c1.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';         
        c1.Requestor_Email__c = '';
        c1.Description = 'Down Payment Document has been mailed to customer';
        c1.subject='test case';
        c1.CreatedDate = system.today()-3;
        c1.LastModifiedDate=system.today()-3;
        c1.Sales_Order_Number__c = '12345678';
        cas1.add(c1);
        //insert c1;
        Case c2 = new Case();
        c2.Origin = 'web';
        c2.Status = 'Open';  
        c2.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        c2.RecordtypeId = Label.OEM_Spares;
        c2.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        c2.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c2.Government_Compliance_SM_M_Content__c = 'No';
        c2.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        c2.Requestor_Email__c='sofiya.peermohamed@nttdata.com';  
        c2.Description = 'Test cases';
        c2.subject='test case';
        c2.CreatedDate = system.today()-6;
        c2.Sales_Order_Number__c = '12345678';
        cas1.add(c2);
        insert cas1;
        
       
        cas = [select id,CaseNumber,LastModifiedDate,createddate,(select id,UFR_SBU__c,Case_object__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.LastModifiedDate from CASE.Case_Extensions__r) from case where id=:c1.id];
        system.debug('lastmodifieddate'+cas[0].LastModifiedDate);
        List<Case_Extension__c> elist = new List<Case_Extension__c>();
        for(Case cases:cas){
            Case_Extension__c e = new Case_Extension__c();
            if(cases.Case_Extensions__r!=null && cases.Case_Extensions__r.size()>0)
            
                e = cases.Case_Extensions__r;
                
                else 
                {
                System.debug('already exists:');
                e.Case_object__c = cases.id;
                e.Manual_Intervention_Last_Modified_Date__c = system.today()-3;
                System.debug('already exists:'+e.Manual_Intervention_Last_Modified_Date__c);
                }                
                elist.add(e);
        }
        
        
                upsert elist;
                EmailMessage newEmail = new EmailMessage();
                newEmail = new EmailMessage(FromAddress = 'aerodonotreply@honeywell.com', ToAddress= 'sofiya.peermohamed@nttdata.com', TextBody = '2345678', ParentId = cas[0].Id); 
                insert newEmail;
                Test.startTest();
                
                PPO_EmailRemainderStatus batch = new PPO_EmailRemainderStatus();
                 DataBase.executeBatch(batch); 
               
                Test.stopTest();
            
     
    }
    
     static testMethod void testschedule() {
        Test.StartTest();
        PPO_EmailRemainderStatus sh1 = new PPO_EmailRemainderStatus();
        String sch = '0 0 7 * * ?';
        system.schedule('Test Territory Check1', sch, sh1);
        Test.stopTest();  
    }
}