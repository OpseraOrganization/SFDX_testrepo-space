@isTest(SeeAllData=true)
global class Case_SAPtoSFDC_Test{

       
    testMethod static void testSAPtoSFDC2() {
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
        
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        
        sfdcCase.add(cas);
        insert sfdcCase;
        test.startTest();
        Product2 prod = [select id,Product_Number__c from Product2 where Record_Type_Name__c='Products' limit 1];
        Case_SAPtoSFDC.CaseData sapData = new Case_SAPtoSFDC.CaseData();
        //sapData.dateTimeOpened_RMDAT = '2014-20-07';
        sapData.url_CQCP = 'http://test.com';
        sapData.additionalDesc_EVENT_CATEGORY = 'Test description';
        sapData.accountName_KUNNR = '';
        sapData.aircraftType = 'A350';
        sapData.aircraftTailNumber = 'CN-AMS';
        sapData.aircraftSerialNumber = 'G5X.5271';
        sapData.aircraftLocation = 'On Ground Tests Outside';
        sapData.productNumber_MATNR = prod.Product_Number__c ;
        sapData.productSerialNumber_SERIALNR = '3612124-2';
        sapData.subject_YYINCIDENT_DESCR = 'Test Subject';
        sapData.description = 'Test description';
        sapData.resolution_RES_COMMENT = 'Removal – Customer Damage';        
        sapData.additionalDesc2_ECATS = 'Test Additional description';
        sapData.hyperlinkToCQCP = 'http://cqcp.com';        
        sapData.contactPrimAddress_CONTACT_EMAIL = objContact.Primary_Email_Address__c;
        sapData.resolutionTool = 'PDM';
        sapData.userVNName_INNAM = 'e85022';
        //sapData.dateTimeClosed_DATUM = '2014-24-01';
        sapData.classification = 'BendixKing';
        sapData.customer_Request_Date = '2014-24-07';
        Case_SAPtoSFDC.DataSFDCTOSAP retunData = Case_SAPtoSFDC.createCase(sapData);
        
        Case_SAPtoSFDC.CaseData sapData1 = new Case_SAPtoSFDC.CaseData();
        sapData1.dateTimeOpened_RMDAT = '2014-20-07';
        sapData1.url_CQCP = 'http://test.com';
        sapData1.additionalDesc_EVENT_CATEGORY = 'Test description';
        sapData1.accountName_KUNNR = '';
        sapData1.aircraftType = 'A350';
        sapData1.aircraftTailNumber = 'CN-AMS';
        sapData1.aircraftSerialNumber = 'G5X.5271';
        sapData1.aircraftLocation = 'On Ground Tests Outside';
        sapData1.productNumber_MATNR = prod.Product_Number__c ;
        sapData1.productSerialNumber_SERIALNR = '3612124-2';
        sapData1.subject_YYINCIDENT_DESCR = '';
        sapData1.description = 'Test description';
        sapData1.resolution_RES_COMMENT = 'test';        
        sapData1.additionalDesc2_ECATS = ';';
        sapData1.hyperlinkToCQCP = 'http://cqcp.com';        
        sapData1.contactPrimAddress_CONTACT_EMAIL = 'test@test.com';
        sapData1.resolutionTool = 'PDM';
        sapData1.userVNName_INNAM = 'e85022';
        //sapData1.dateTimeClosed_DATUM = '2014-24-01';
        sapData1.classification = '';
        sapData1.customer_Request_Date = '2014-24-07';
        Case_SAPtoSFDC.DataSFDCTOSAP retunData1 = Case_SAPtoSFDC.createCase(sapData1);
        
        Case_SAPtoSFDC.CaseData sapData2 = new Case_SAPtoSFDC.CaseData();
        sapData2.dateTimeOpened_RMDAT = '';
        sapData2.url_CQCP = 'http://test.com';
        sapData2.additionalDesc_EVENT_CATEGORY = 'Test description';
        sapData2.accountName_KUNNR = '';
        sapData2.aircraftType = 'A350';
        sapData2.aircraftTailNumber = 'CN-AMS';
        sapData2.aircraftSerialNumber = 'G5X.5271';
        sapData2.aircraftLocation = 'On Ground Tests Outside';
        sapData2.productNumber_MATNR = prod.Product_Number__c ;
        sapData2.productSerialNumber_SERIALNR = '3612124-2';
        sapData2.subject_YYINCIDENT_DESCR = '';
        sapData2.description = 'Test description';
        sapData2.resolution_RES_COMMENT = 'test';        
        sapData2.additionalDesc2_ECATS = '';
        sapData2.hyperlinkToCQCP = 'http://cqcp.com';        
        sapData2.contactPrimAddress_CONTACT_EMAIL = '';
        sapData2.resolutionTool = 'PDM';
        sapData2.userVNName_INNAM = 'e85022';
        //sapData2.dateTimeClosed_DATUM = '2014-24-01';
        sapData2.classification = 'test';
        sapData2.customer_Request_Date = '2014-24-07';
        Case_SAPtoSFDC.DataSFDCTOSAP retunData2 = Case_SAPtoSFDC.createCase(sapData2);
        
         Case_SAPtoSFDC.CaseData sapData3 = new Case_SAPtoSFDC.CaseData();
        sapData3.dateTimeOpened_RMDAT = null;
        sapData3.url_CQCP = '';
        sapData3.additionalDesc_EVENT_CATEGORY = '';
        sapData3.accountName_KUNNR = '';
        sapData3.aircraftType = '';
        sapData3.aircraftTailNumber = '';
        sapData3.aircraftSerialNumber = '';
        sapData3.aircraftLocation = '';
        sapData3.productNumber_MATNR = '' ;
        sapData3.productSerialNumber_SERIALNR = '';
        sapData3.subject_YYINCIDENT_DESCR = '';
        sapData3.description = 'Test description';
        sapData3.resolution_RES_COMMENT = '';        
        sapData3.additionalDesc2_ECATS = 'Test Additional description ; test';
        sapData3.hyperlinkToCQCP = '';        
        sapData3.contactPrimAddress_CONTACT_EMAIL = '';
        sapData3.resolutionTool = '';
        sapData3.userVNName_INNAM = '';
        //sapData3.dateTimeClosed_DATUM = '2014-24-01';
        sapData3.classification = 'test';
        sapData3.customer_Request_Date = '';
        Case_SAPtoSFDC.DataSFDCTOSAP retunData3 = Case_SAPtoSFDC.createCase(sapData3);
        test.stopTest();
    }
    testMethod static void getCaseNumbertest() {
        
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
        
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        
        sfdcCase.add(cas);
        insert sfdcCase;
        string casNum = Case_SAPtoSFDC.getCaseNumber(cas.id);
        
    }
    
}