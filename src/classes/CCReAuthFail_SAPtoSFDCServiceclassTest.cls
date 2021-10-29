@isTest(SeeAllData=true)
global class CCReAuthFail_SAPtoSFDCServiceclassTest{
    testMethod static void CCReAuthFailTest() {
        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Origin = 'XML Order';
        cas.Status = 'On Hold';
        cas.Sub_Status__c = 'Bussiness Hold';
        cas.Sales_Order_Number__c = '0000012346';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
      
        cs.ACCOUNT_NAME=act.Sbl_Account_Row_Id__c;
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'null'; 
        cs.NotificationNumber=cas.Repair_Notification_Number__c;
        //cs.CUSTOMER_REQUEST_DT='17-08-2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.SAP_ACCOUNT_INFO ='ZRPR';
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CASENUMBER = '';
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRA';  
        cs.DistributionChannel = 'PPO'; 
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = CCReAuthFail_SAPtoSFDCServiceclass.CCReAuthFail(cs);
    }
    
    testMethod static void CCReAuthFailTest1() {
        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = label.OEM_Spares;
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        cas.Subject = 'Credit Card Re-Auth Error. Sales order Number - 0000012346';
        cas.Sales_Order_Number__c = '0000012346';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
      
        cs.ACCOUNT_NAME=act.Sbl_Account_Row_Id__c;
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'null'; 
        cs.NotificationNumber=cas.Repair_Notification_Number__c;
        //cs.CUSTOMER_REQUEST_DT='17-08-2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.SAP_ACCOUNT_INFO ='ZRA';
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CASENUMBER = '';
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRA';  
        cs.DistributionChannel = 'PPO'; 
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = CCReAuthFail_SAPtoSFDCServiceclass.CCReAuthFail(cs);
    }
    testMethod static void CCReAuthFailTest2() {
        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = label.OEM_Spares;
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        cas.Subject = 'Credit Card Re-Auth Error. Sales order Number - 0000012';
        cas.Sales_Order_Number__c = '0000012346';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
      
        cs.ACCOUNT_NAME=act.Sbl_Account_Row_Id__c;
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'null'; 
        cs.NotificationNumber=cas.Repair_Notification_Number__c;
        //cs.CUSTOMER_REQUEST_DT='17-08-2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.SAP_ACCOUNT_INFO ='ZRA';
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CASENUMBER = '';
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRA';  
        cs.DistributionChannel = 'PPO'; 
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = CCReAuthFail_SAPtoSFDCServiceclass.CCReAuthFail(cs);
    }  
        

}