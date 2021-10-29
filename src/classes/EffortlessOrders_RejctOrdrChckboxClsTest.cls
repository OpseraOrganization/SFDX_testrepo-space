/*******************************************************************************
Name         : EffortlessOrders_RejctOrdrChckboxClsTest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Phase-I>, <EfforlessOrders> 
Created Date : 25 September 2014
Usages       : Test Class for EffortlessOrders_RejectOrderCheckboxClas           
*******************************************************************************/

@isTest(SeeAllData=true)
private class EffortlessOrders_RejctOrdrChckboxClsTest{ 
    static testMethod void EffortlessOrders_RejectOrderCheckboxClasTest(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
         Account acc = new Account();
            acc.Name = 'Test Account';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'ATR';
            acc.CBT__c = 'Airbus';
            acc.Region_Name__c = 'Americas';
            acc.Sub_Region_Name__c = 'Canada';
            acc.Service_Level__c = 'Refer to Network';
            acc.Type = 'OEM';
            acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
            acc.Market_Name__c = 'Marine';
            acc.PFECN__c='';
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
        cs.Reject_Order_Reasons__c = '';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';        
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.OwnerId = usr.id;
        
            insert cs;
       
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';                
        cs1.ContactId = objContact.Id;
        cs1.RecordtypeId = label.Orders_Rec_ID;
        cs1.Classification__c = 'EMS';
        cs1.Type = 'Place Order';
        cs1.HON_Commit_Date__c = system.today();
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.Reject_Order_Reasons__c = '';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs1.OwnerId = usr.id;
        
            insert cs1;
      
        
        /*Attachment att = new Attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cs.id;
        insert att;*/
        
        
                       
        cs.Status = 'Reject';
        cs.Reject_Order_Reasons__c = 'Missing PO Number, Missing Part Number';
        update cs;
        Test.StartTest(); 
        test.setCurrentPage(new PageReference('Page.EffortlessOrders_RejectOrderCheckboxPage')); 
        ApexPages.StandardController sc = new ApexPages.standardController(cs);
        ApexPages.currentPage().getParameters().put('id',cs.id);
        EffortlessOrders_RejectOrderCheckboxClas controller = new EffortlessOrders_RejectOrderCheckboxClas(sc);
        controller.MTAdd = 'true';
        controller.MShTAdd = 'true';
        controller.MPO = 'true';
        controller.MQuan = 'true';
        controller.MPart = 'true';
        controller.ShTPO = 'true';
        controller.getSelected();
        
        cs1.Status = 'Reject';
        cs1.Reject_Order_Reasons__c = 'Missing PO Number';
        update cs1;
        
        test.setCurrentPage(new PageReference('Page.EffortlessOrders_RejectOrderCheckboxPage')); 
        ApexPages.StandardController sc1 = new ApexPages.standardController(cs1);
        ApexPages.currentPage().getParameters().put('id',cs1.id);
        EffortlessOrders_RejectOrderCheckboxClas controller1 = new EffortlessOrders_RejectOrderCheckboxClas(sc1);
        controller1.MTAdd = 'true';
        controller1.MShTAdd = 'true';
        controller1.MPO = 'true';
        controller1.MQuan = 'true';
        controller1.MPart = 'true';
        controller1.ShTPO = 'true';
        controller1.getSelected();
        Test.StopTest();
    }

}