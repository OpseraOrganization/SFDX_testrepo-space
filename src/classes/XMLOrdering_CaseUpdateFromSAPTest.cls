/*******************************************************************************
Name         : XMLOrdering_CaseUpdateFromSAPTest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <XML Ordering> 
Created Date : 28-July-2015
Usages       : Test Class for XMLOrdering_CaseUpdateFromSAPTest       
*******************************************************************************/
@isTest(SeeAllData=true)
private class XMLOrdering_CaseUpdateFromSAPTest{ 
    static testMethod void XMLOrdering_CaseUpdateFromSAPTest(){            
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        List<Account> acc1 = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Honeywell';
        acc1.add(ac);
        
        insert acc1;
        
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name Like '%Honeywell%' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'XML';
        objContact.FirstName = 'Orders';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        objContact.Employee_Number__c = 'H287751';     
        insert objContact;
        
        Case cas = new Case();
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        cas.ContactId = objContact.Id;
        cas.Classification__c = 'CSO Repair/Overhaul';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cas.Government_Compliance_SM_M_Content__c = 'NO';
        cas.recordtypeid=Label.XML_Orders_RecordType_Id;
        cas.Type = 'Place Order';
        cas.ownerid = label.RnO_Automation_Default_Owner;
        cas.Customer_PO_RO_WONumber__c = '';
        cas.SuppliedEmail = 'vnvhksf@gmail.com';
        cas.Sales_Order_Number__c = '';
        insert cas;
        
        Attachment a = new Attachment();
        a.body = blob.valueof('Testing XML Attachments');
        a.ContentType = 'text/xml';
        a.name = 'test.xml';
        a.parentid = cas.id;
        insert a;
        
        list<EmailMessage> newEmail = new list<EmailMessage>();
        newEmail.add(new EmailMessage(FromAddress = 'harikishore.vutukuri@honeywell.com', Incoming = True, ToAddress= 'XMLOrders@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));    
        insert newEmail;
        
        Case c = [SELECT Status,CreatedDate,Resolution__c,CaseNumber,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Requestor_Email__c,Resolution_Comments__c,First_Name__c,Material_Receipt_Date__c from Case where id=:cas.id];
        Test.startTest();       
        try{
            XMLOrdering_CaseUpdateFromSAP.CaseUpdateSAPtoSFDC casupd = new XMLOrdering_CaseUpdateFromSAP.CaseUpdateSAPtoSFDC();
            casupd.PONumber = 'POTest123';
            casupd.SalesOrderNum = '123456';
            casupd.BuyerName = 'Hari';
            casupd.CustEmailAddr = 'vnvhksf@gmail.com';
            casupd.CasNumber = c.CaseNumber;
            casupd.MessageContent = 'Testing';
            casupd.ResponseMsg = 'Success!';
            casupd.POReceiptDate = '04/09/2015';
            XMLOrdering_CaseUpdateFromSAP.updateCase(casupd);
            c.First_Name__c = casupd.BuyerName;
            c.Material_Receipt_Date__c = Date.valueOf(c.CreatedDate);
            c.Resolution_Comments__c = casupd.MessageContent;
            c.Sales_Order_Number__c = casupd.SalesOrderNum;
            c.Customer_PO_RO_WONumber__c = casupd.PONumber;
            c.Requestor_Email__c = casupd.CustEmailAddr;
            c.Status = 'Closed';
            c.Resolution__c = 'None';
            update c;
        }catch(Exception e){}
        Test.stopTest();
    }
    
    static testMethod void XMLOrdering_CaseUpdateFromSAPTest2(){      
         User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias='sadmin' and isactive = true order by createddate asc limit 1];
       // User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        List<Account> acc1 = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Honeywell';
        acc1.add(ac);
        
        insert acc1;
        
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name Like '%Honeywell%' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'XML';
        objContact.FirstName = 'Orders';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        objContact.Employee_Number__c = 'H287751';     
        insert objContact;
        
        Case cas = new Case();
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        cas.ContactId = objContact.Id;
        cas.Classification__c = 'CSO Repair/Overhaul';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cas.Government_Compliance_SM_M_Content__c = 'NO';
        cas.recordtypeid=Label.XML_Orders_RecordType_Id;
        cas.Type = 'Place Order';
        cas.ownerid = label.RnO_Automation_Default_Owner;
        cas.Customer_PO_RO_WONumber__c = '';
        cas.SuppliedEmail = 'testxml@xmlorders.com';
        cas.Sales_Order_Number__c = '';
        insert cas;
        
        Attachment a = new Attachment();
        a.body = blob.valueof('Testing XML Attachments');
        a.ContentType = 'text/xml';
        a.name = 'test.xml';
        a.parentid = cas.id;
        insert a;
        
        list<EmailMessage> newEmail = new list<EmailMessage>();
        newEmail.add(new EmailMessage(FromAddress = 'harikishore.vutukuri@honeywell.com', Incoming = True, ToAddress= 'XMLOrders@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));    
        insert newEmail;
        
        Case c = [SELECT Status,CreatedDate,Resolution__c,CaseNumber,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Requestor_Email__c,Resolution_Comments__c,First_Name__c,Material_Receipt_Date__c from Case where id=:cas.id];
        Test.startTest();       
        try{
            XMLOrdering_CaseUpdateFromSAP.CaseUpdateSAPtoSFDC casupd = new XMLOrdering_CaseUpdateFromSAP.CaseUpdateSAPtoSFDC();
            casupd.PONumber = 'POTest123';
            casupd.SalesOrderNum = '123456';
            casupd.BuyerName = 'Hari';
            casupd.CustEmailAddr = 'vnvhksf@gmail.com';
            casupd.CasNumber = c.CaseNumber;
            casupd.MessageContent = 'Testing';
            casupd.ResponseMsg = 'Exception!';
            casupd.POReceiptDate = null;
            XMLOrdering_CaseUpdateFromSAP.updateCase(casupd);
            c.First_Name__c = casupd.BuyerName;
            c.Material_Receipt_Date__c = Date.valueOf(c.CreatedDate);
            c.Resolution_Comments__c = casupd.MessageContent;
            c.Sales_Order_Number__c = casupd.SalesOrderNum;
            c.Customer_PO_RO_WONumber__c = casupd.PONumber;
            c.Requestor_Email__c = casupd.CustEmailAddr;
            c.Status = 'Closed';
            c.Resolution__c = 'None';
            update c;
        }catch(Exception e){}
        Test.stopTest();
    }
    static testMethod void XMLOrdering_CaseUpdateFromSAPTest3(){            
        Test.startTest();       
        XMLOrdering_CaseUpdateFromSAP.CaseUpdateSAPtoSFDC casupd = new XMLOrdering_CaseUpdateFromSAP.CaseUpdateSAPtoSFDC();
        casupd.PONumber = 'POTest123';
        casupd.SalesOrderNum = '123456';
        casupd.BuyerName = 'Hari';
        casupd.CustEmailAddr = 'vnvhksf@gmail.com';
        casupd.CasNumber = 'CASE-0000001';
        casupd.MessageContent = 'Testing';
        casupd.ResponseMsg = 'Exception!';
        casupd.POReceiptDate = null;
        try{
        XMLOrdering_CaseUpdateFromSAP.updateCase(casupd);
        }catch(Exception e){}
        Test.stopTest();
    }
}