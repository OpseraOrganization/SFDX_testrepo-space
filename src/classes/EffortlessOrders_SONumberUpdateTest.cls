/*******************************************************************************
Name         : EffortlessOrders_SONumberUpdateTest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Phase-I>, <EfforlessOrders> 
Created Date : 25 September 2014
Usages       : Test Class for EffortlessOrders_SONumberUpdate & EfforlessOrdersAttachmentRequest           
*******************************************************************************/

@isTest(SeeAllData=false)
private class EffortlessOrders_SONumberUpdateTest{ 
    static testMethod void EffortlessOrders_SONumberUpdateTest(){
        List<id> attids = new List<id>{};
        User usr = new User();
        usr.Primary_Manager_Name__c = 'Harikishore';
        usr.Primary_Manager_EID__c = 'E801543';
        usr.Profileid = label.Sys_Admin_Profile_Id;
        usr.alias = 'EFFORTHA';
        usr.email='harikishore.vutukuri@nttdata.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='Testing';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.timezonesidkey='America/Los_Angeles';
        usr.CommunityNickname='tcs';
        usr.Username='Effortless@nttdata.com';
        insert usr;
        
        Account acc = new Account();
        acc.Name = 'Testwebacc';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Effortless';
        objContact.FirstName = 'Orders';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Employee_Number__c = 'E123123';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
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
        cs.Sales_Order_Number__c = '12345678';
        cs.Order_Entered_By__c = 'Harikishore';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        try{
            insert cs;
        }catch(DMLException e){}
        
        Case cs1 = [select id,CaseNumber,Sales_Order_Number__c,Order_Entered_By__c from Case where id=:cs.id];
        
        Attachment att = new Attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cs1.id;
        insert att;
        attids.add(att.id);
        
        Test.startTest();
        EffortlessOrders_SONumberUpdate.SOnCasNumberSAPtoSFDC socs = new EffortlessOrders_SONumberUpdate.SOnCasNumberSAPtoSFDC();
        socs.SalesOrderNum = '4567890';
        socs.OrderEntBy = 'Harikishore V';
        socs.CaseeNumber = cs1.CaseNumber;
        EffortlessOrders_SONumberUpdate.updateCase(socs);
        
        cs1.Sales_Order_Number__c = cs1.Sales_Order_Number__c+socs.SalesOrderNum;
        cs1.Order_Entered_By__c = cs1.Order_Entered_By__c+socs.OrderEntBy;
        update cs1;
        
        EfforlessOrdersAttachmentRequest.SendRequest(cs.Sales_Order_Number__c,cs1.CaseNumber,attids);
        Test.stopTest();
    }
    
    static testMethod void EffortlessOrders_SONumberUpdateTest1(){
        List<id> attids = new List<id>{};
        User usr = new User();
        usr.Primary_Manager_Name__c = 'Harikishore1';
        usr.Primary_Manager_EID__c = 'E801543';
        usr.Profileid = label.Sys_Admin_Profile_Id;
        usr.alias = 'EORTHATT';
        usr.email='harikishore.vutukuri@nttdata.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='Testing1';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.timezonesidkey='America/Los_Angeles';
        usr.CommunityNickname='tcs1';
        usr.Username='Effortless1@nttdata.com';
        insert usr;
        
        Account acc = new Account();
        acc.Name = 'Testwebacc1';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Effortless1';
        objContact.FirstName = 'Orders1';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Employee_Number__c = 'E123123';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
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
        cs.Sales_Order_Number__c = '12345678';
        cs.Order_Entered_By__c = 'Harikishore';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        try{
            insert cs;
        }catch(DMLException e){}
        
        Attachment att = new Attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body1');
        att.ParentId=cs.id;
        insert att;
        attids.add(att.id);
        
        Test.startTest();
        EffortlessOrders_SONumberUpdate.SOnCasNumberSAPtoSFDC socs = new EffortlessOrders_SONumberUpdate.SOnCasNumberSAPtoSFDC();
        socs.SalesOrderNum = '4567890';
        socs.OrderEntBy = 'Harikishore V';
        socs.CaseeNumber = cs.CaseNumber;
        EffortlessOrders_SONumberUpdate.updateCase(socs);
        
        cs.Sales_Order_Number__c = cs.Sales_Order_Number__c+socs.SalesOrderNum;
        cs.Order_Entered_By__c = cs.Order_Entered_By__c+socs.OrderEntBy;
        update cs;
        
        Test.stopTest();
    }
}