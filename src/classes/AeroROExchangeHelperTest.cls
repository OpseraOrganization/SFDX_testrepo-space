@isTest
private class AeroROExchangeHelperTest {
    static testMethod void AeroROExchangeHelperTestMethod() {  

        Group csQ =   [select Id, name from Group where  Type = 'Queue' AND NAME = 'CSO R&O Team'];
        Account ac = new Account();
        ac.Name = 'Test Acc';
        ac.Strategic_Business_Unit__c = 'Aero Level';
        ac.CBT__c = 'Aero Level Other';
        ac.CBT_Team__c = 'Aero Level Other';
        ac.Sales_Channel__c = 'Aerospace';
        ac.SC1__c = 'Aero Level Other';
        ac.Market_Name__c = 'Unknown';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
        ac.potential_conexiom__c = true;
        Insert ac;
        
        Account_Cross_Ref__c ar = new Account_Cross_Ref__c();
        ar.Name = 'TestAR';
        ar.Account_Name__c = ac.id;
        ar.Auto_Conexiom__c = true;
        ar.Site_Code__c = '9000';
        ar.External_Account_ID__c = '11223344';
        
        insert ar;
        
        Contact co = new Contact();
        co.LastName = 'Test Con';
        co.Contact_Function__c = 'Accounting';
        co.SBU_Contact__c = 'Aero Level';
        co.CBT__c = 'Aero Level Other';
        co.CBT_Team__c = 'Aero Level Other';
        co.Sales_Channel_Contact__c = 'Aerospace';
        co.SC1__c = 'Aero Level Other';
        co.AccountId = ac.Id;
        co.Primary_Email_Address__c = 'test@msn.com';
        co.Functional_Role__c = 'Aero Offset Director';
        Insert co;
        
        Id RTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Case ca = new Case();
        ca.RecordtypeId = RTID;
        ca.AccountID = ac.ID;
        ca.ownerID=csQ.ID;
        ca.Origin = 'Email';
        ca.Emailbox_Origin__c = 'Email-Orders';
        ca.Classification__c = 'EDI';
        ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
        ca.Type = 'Place Orders';
        ca.Sub_Class__c = 'conexiom';
        ca.Status = 'Open';
        ca.ContactId = co.Id;
        Insert ca;

    Emailmessage e1 = new Emailmessage(parentid=ca.id);
        e1.ToAddress= label.XML_Response_Toaddress;
        e1.Incoming=False;
        e1.ParentID = ca.ID;
        e1.subject = 'RO Note Exchange : AeroXchange R&O Note%';
        insert e1;
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.contentType = 'application/pdf';
        attach.parentId=e1.id;
        insert attach;
    
         List<Case_Extension__c>  ce = [Select ID,ROExchange_XML__c,RoExchange_IsAttach__c,Case_object__c  from Case_Extension__c where Case_object__c =:ca.id];
            ce[0].ROExchange_XML__c = 'envelope';
            ce[0].RoExchange_IsAttach__c = true;   
            system.debug('ROExchange_XML__c==>' +ce[0].ROExchange_XML__c);
            update ce;
        
        set<ID> EmsgID = new set<ID>();
        EmsgID .add(e1.ID);
}
}