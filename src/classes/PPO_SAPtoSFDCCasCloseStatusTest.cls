@isTest(SeeAllData=true)
global class PPO_SAPtoSFDCCasCloseStatusTest{
    testMethod static void closeCaseTest() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012346';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='Cancelled due to non-payment';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    testMethod static void closeCaseTest1() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012347';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='No Payment made 3-day';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    testMethod static void closeCaseTest2() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012348';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='No Payment made 6-day';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    testMethod static void closeCaseTest3() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012349';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='Down payment received';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    testMethod static void closeCaseTest4() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'Email';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012340';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    testMethod static void closeCaseTest5() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.Repair_Overhaul_RT_ID;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012349';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='Down payment received';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    testMethod static void closeCaseTest6() {
    	Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012340';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        Case caseObj = new Case();
        caseObj = [select id, casenumber from case where id = : cas.id];
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.SALES_ORDER_NUMBER = cas.Sales_Order_Number__c;
        cs.CASENUMBER =caseObj.CaseNumber;
        cs.RESOLUTION ='';
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP returndata = PPO_SAPtoSFDCCasCloseStatus.closeCase(cs);
    }
    

}