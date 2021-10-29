@isTest 
public class PPO_EmailSendingTest{

     testMethod static void PPOtest(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId =Label.Repair_Overhaul_RT_ID;
        //cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.Requestor_Email__c = 'sofiya.peermohamed@nttdata.com';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        Blob b = Blob.valueOf('Test Data');
        /*Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;*/
         
         ContentVersion conVer = new ContentVersion();
         conVer.PathOnClient = 'Test Attachment for Parent'; // file name with extension
         conVer.Title = 'Test Attachment for Parent'; // file name to display. Usually specify the extension here also
         conVer.VersionData = b;
         
         //insert a;
         insert conVer;
         ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
         ContentDocumentlink objCDL = new ContentDocumentlink();
         objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
         objCDL.linkedentityId = cas.id;
         objCDL.Sharetype = 'I';
         insert objCDL;
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
   
        PPO_EmailSending.EmailSend(c.id);
        
        Test.stopTest();
 }
     testMethod static void PPOtest1(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Case_Extension__c ce = new Case_Extension__c();
        
        ce.Case_object__c=cas.id;
        insert ce;*/
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        
        PPO_EmailSending.EmailSend(c.id);
        Test.stopTest();
 
 }
 
 testMethod static void PPOtest2(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.Requestor_Email__c = 'sofiya.peermohamed@nttdata.com';
        
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Case_Extension__c ce = new Case_Extension__c();
        
        ce.Case_object__c=cas.id;
       insert ce;*/
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;
        
        Blob b1 = Blob.valueOf('Test Data1');
        Attachment att1 = new Attachment();  
        att1.ParentId = cas.id;  
        att1.Name = 'Test Attachment for Parent1';  
        att1.Body = b1;
        insert att1;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
       
        PPO_EmailSending.EmailSend(c.id);
        string ReminderDays='No Payment made 3-day';
        PPO_CasecloseEMail.EmailSend(c.id,ReminderDays);
        Test.stopTest();
 
 }
 testMethod static void PPOtest3(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
       /* Case_Extension__c ce = new Case_Extension__c();
       
        ce.Case_object__c=cas.id;
        insert ce;*/
        
       /* Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;
        
        Blob b1 = Blob.valueOf('Test Data1');
        Attachment att1 = new Attachment();  
        att1.ParentId = cas.id;  
        att1.Name = 'Test Attachment for Parent1';  
        att1.Body = b1;
        insert att1;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        
        PPO_EmailSending.EmailSend(c.id);
        
        Test.stopTest();
 
 }
 testMethod static void PPOtest4(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId =Label.Repair_Overhaul_RT_ID;
        //cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
       /* Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        
        PPO_EmailSending.EmailSend(c.id);
        Test.stopTest();
 }
 testMethod static void PPOtest5(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId =Label.Repair_Overhaul_RT_ID;
        //cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Requestor_Email__c = 'sofiya.peermohamed@nttdata.com';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
       
        PPO_EmailSending.EmailSend(c.id);
        Test.stopTest();
 }
 testMethod static void PPOtest6(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId =Label.Repair_Overhaul_RT_ID;
        //cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
       
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;*/
        
        Z_Task__c zt = new Z_Task__c();
        zt.Type__c='Z151 Prepayment Order followup for payment';
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.RelatedTo__c = cas.id;
        zt.Short_Text__c = 'Test';
        zt.Comments__c = 'Test Ztask';
        zt.Long_Text__c = 'Test122';
        zt.Status__c = 'Open';
        insert zt;  
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        
        PPO_EmailSending.EmailSend(c.id);
        Test.stopTest();
 }
 testMethod static void PPOtest7(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId =Label.Repair_Overhaul_RT_ID;
        //cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
       
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;*/
        
        Z_Task__c zt = new Z_Task__c();
        zt.Type__c='Z135 Escalation to CSR';
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.Sub_Type__c='Customer information required';
        zt.RelatedTo__c = cas.id;
        zt.Short_Text__c = 'Test';
        zt.Comments__c = 'Test Ztask';
        zt.Long_Text__c = 'Test122';
        zt.Status__c = 'Open';
        insert zt;  
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        
        PPO_EmailSending.EmailSend(c.id);
        Test.stopTest();
 }
  testMethod static void PPOtest8(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId =Label.Repair_Overhaul_RT_ID;
        //cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
       
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;*/
        
        Z_Task__c zt = new Z_Task__c();
        zt.Type__c='Z135 Escalation to CSR';
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.Sub_Type__c='Need Missing Information';
        zt.RelatedTo__c = cas.id;
        zt.Short_Text__c = 'Test';
        zt.Comments__c = 'Test Ztask';
        zt.Long_Text__c = 'Test122';
        zt.Status__c = 'Open';
        insert zt;  
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        
        PPO_EmailSending.EmailSend(c.id);
        Test.stopTest();
 }
 testMethod static void PPOcasclosetest(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.Requestor_Email__c = 'sofiya.peermohamed@nttdata.com';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;
        
        Blob b1 = Blob.valueOf('Test Data1');
        Attachment att1 = new Attachment();  
        att1.ParentId = cas.id;  
        att1.Name = 'Test Attachment for Parent1';  
        att1.Body = b1;
        insert att1;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        string ReminderDays='Cancelled due to non-payment';
        PPO_CasecloseEMail.EmailSend(c.id,ReminderDays);
        Test.stopTest();
 
 }
 testMethod static void PPOcasclosetest1(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();  
        att.ParentId = cas.id;  
        att.Name = 'Test Attachment for Parent';  
        att.Body = b; 
        insert att;
        
        Blob b1 = Blob.valueOf('Test Data1');
        Attachment att1 = new Attachment();  
        att1.ParentId = cas.id;  
        att1.Name = 'Test Attachment for Parent1';  
        att1.Body = b1;
        insert att1;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        string ReminderDays='No Payment made 6-day';
        PPO_CasecloseEMail.EmailSend(c.id,ReminderDays);
        Test.stopTest();
 
 }
}