/*******************************************************************************
Name         : UFRPricing_CaseSAPtoSFDCTest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Phase-II>, <UFR Pricing>
Created Date : 06-April-2015
Usages       : Test Class for UFRPricing_CaseSAPtoSFDC &            
*******************************************************************************/

@isTest(SeeAllData=true)
global class UFRPricing_CaseSAPtoSFDCTest{ 
    testMethod static void UFRPricing_CaseSAPtoSFDCTest(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs = new UFRPricing_CaseSAPtoSFDC.CaseData();        
        cs.TYPE = 'UFR PO Mismatch';
        cs.SALES_ORDER_NUM = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';
        cs.QUOTATION_NUMBER = '21323434';
        cs.CUST_EMAIL_ADDR = 'harikishore.vutukuri@honeywell.com'; 
        cs.UFR_PRICING_AMT = 23.55;
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'UFR/Standard Price – Unfunded PO Quotation Number ';
        cs.DESCRIPTION = 'UFR/Standard Price Amount $ ';
        cs.PRODUCT_NUM = 'YD156';
        cs.SAP_PLANT_CODE = '4144';
        string caseno = cs1[0].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs.SAP_SITE_CODE = caseno ;
        cs.NOTIFICATION_NUMBER = '498764654';
        cs.AttBody = 'Test atta';
        cs.AttFileName = 'test.txt';
        cs.AttContentType = 'text/html';
        cs.UFR_SBU = 'ATR';        
        try{
        
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata = UFRPricing_CaseSAPtoSFDC.createCase(cs);
        }Catch(DMLException e1){}
        string UFRSBU='ATR';
        Test.stopTest();
    }
    testMethod static void UFRPricing_CaseSAPtoSFDCTest2(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID limit 2];        
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs = new UFRPricing_CaseSAPtoSFDC.CaseData();
        cs.TYPE = 'UFR Unfunded PO';
        cs.QUOTATION_NUMBER = '21323434';
        cs.SUBJECT = 'ROI_Quote';
        string caseno1 = cs1[0].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs.SAP_SITE_CODE = caseno1;
        cs.NOTIFICATION_NUMBER = '498764654';
        cs.AttBody = 'Test atta';
        cs.AttFileName = 'test.txt';
        cs.AttContentType = 'text/html';
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata = UFRPricing_CaseSAPtoSFDC.createCase(cs);
        }catch(DMLException e2){}
        
        UFRPricing_CaseSAPtoSFDC.CaseData cs3 = new UFRPricing_CaseSAPtoSFDC.CaseData();
        cs3.QUOTATION_NUMBER = '21323434';
        cs3.SUBJECT = 'ROI_Quote';
        string caseno13 = cs1[0].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs3.SAP_SITE_CODE = caseno13;
        cs3.AttBody = 'Test atta';
        cs3.AttFileName = ' ';
        cs3.AttContentType = '_';
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata3 = UFRPricing_CaseSAPtoSFDC.createCase(cs3);
        }catch(DMLException e21){}
        Test.stopTest();
    }
    testMethod static void UFRPricing_CaseSAPtoSFDCTest3(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID and Case_object__r.CaseOwnerChanged__c!=null limit 1];        
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs = new UFRPricing_CaseSAPtoSFDC.CaseData();
        cs.TYPE = 'Unfunded PO';
        cs.SALES_ORDER_NUM = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';
        cs.QUOTATION_NUMBER = '21323434';
        cs.CUST_EMAIL_ADDR = 'harikishore.vutukuri@honeywell.com'; 
        cs.UFR_PRICING_AMT = 23.55;
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'UFR/Standard Price – Unfunded PO Quotation Number ';
        cs.DESCRIPTION = 'UFR/Standard Price Amount $ ';
        cs.PRODUCT_NUM = 'YD156';
        cs.SAP_PLANT_CODE = '4144';
        string caseno0 = cs1[0].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs.SAP_SITE_CODE = caseno0;
        cs.NOTIFICATION_NUMBER = '498764654';
        cs.UFR_SBU = 'D&S';  
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata = UFRPricing_CaseSAPtoSFDC.createCase(cs);
        }Catch(DMLException e4){}
        Test.stopTest();
    }
    testMethod static void UFRPricing_CaseSAPtoSFDCTest1(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs0 = new UFRPricing_CaseSAPtoSFDC.CaseData();
        cs0.TYPE = 'Unfunded PO';
        cs0.SALES_ORDER_NUM = '12345678';
        cs0.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';
        cs0.QUOTATION_NUMBER = '21323434';
        cs0.CUST_EMAIL_ADDR = 'harikishore.vutukuri@honeywell.com'; 
        cs0.UFR_PRICING_AMT = 23.55;
        cs0.PRODUCT_SERIAL_NUM = '50001313';
        cs0.SUBJECT = 'test';
        cs0.DESCRIPTION = 'UFR/Standard Price Amount $ ';
        cs0.PRODUCT_NUM = 'YD156';
        cs0.SAP_PLANT_CODE = '4144';
        string caseno0 = cs1[1].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs0.SAP_SITE_CODE = caseno0;
        cs0.NOTIFICATION_NUMBER = '498764654';
        cs0.AttBody = 'Test atta';
        cs0.AttFileName = 'test.txt';
        cs0.AttContentType = 'text/html';
        cs0.UFR_SBU = 'BGA';        
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata0 = UFRPricing_CaseSAPtoSFDC.createCase(cs0);
        }catch(DMLException e){}
        string UFRSBU1='BGA';
        Test.stopTest();
    } 
    testMethod static void UFRPricing_CaseSAPtoSFDCTest4(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID limit 2];        
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs0 = new UFRPricing_CaseSAPtoSFDC.CaseData();
        cs0.TYPE = 'UFR Unfunded PO';
        cs0.SALES_ORDER_NUM = '12345678';
        cs0.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';
        cs0.QUOTATION_NUMBER = '21323434';
        cs0.CUST_EMAIL_ADDR = 'harikishore.vutukuri@honeywell.com'; 
        cs0.UFR_PRICING_AMT = 23.55;
        cs0.PRODUCT_SERIAL_NUM = '50001313';
        cs0.SUBJECT = 'test';
        cs0.DESCRIPTION = 'UFR/Standard Price Amount $ ';
        cs0.PRODUCT_NUM = 'YD156';
        cs0.SAP_PLANT_CODE = '4144';
        string caseno0 = cs1[1].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs0.SAP_SITE_CODE = caseno0;
        cs0.NOTIFICATION_NUMBER = '498764654';
        cs0.AttBody = 'Test atta';
        cs0.AttFileName = 'test.txt';
        cs0.AttContentType = 'text/html';
        cs0.UFR_SBU = 'D&S';     
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata0 = UFRPricing_CaseSAPtoSFDC.createCase(cs0);
        }catch(DMLException e5){}
        string UFRSBU1='D&S';
        Test.stopTest();
    }
    testMethod static void UFRPricing_CaseSAPtoSFDCTest21(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs0 = new UFRPricing_CaseSAPtoSFDC.CaseData();
        //cs0.TYPE = 'Unfunded PO';
        cs0.SALES_ORDER_NUM = '12345678';
        cs0.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';
        cs0.QUOTATION_NUMBER = '21323434';
        cs0.CUST_EMAIL_ADDR = 'harikishore.vutukuri@honeywell.com'; 
        cs0.UFR_PRICING_AMT = 23.55;
        cs0.PRODUCT_SERIAL_NUM = '50001313';
        cs0.SUBJECT = 'test';
        cs0.DESCRIPTION = 'UFR/Standard Price Amount $ ';
        cs0.PRODUCT_NUM = 'YD156';
        cs0.SAP_PLANT_CODE = '4144';
        string caseno0 = cs1[1].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs0.SAP_SITE_CODE = caseno0;
        cs0.NOTIFICATION_NUMBER = '498764654';
        /*cs0.AttBody = 'Test atta';
        cs0.AttFileName = 'test.txt';
        cs0.AttContentType = 'text/html';
        cs0.UFR_SBU = 'BGA';   */     
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata0 = UFRPricing_CaseSAPtoSFDC.createCase(cs0);
        }catch(DMLException e){}
        string UFRSBU1='BGA';
        Test.stopTest();
    }
    testMethod static void UFRPricing_CaseSAPtoSFDCTest5(){
        List<Case_Extension__c> cs1 = [select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c != null and  Case_object__r.RecordtypeId=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        UFRPricing_CaseSAPtoSFDC.CaseData cs0 = new UFRPricing_CaseSAPtoSFDC.CaseData();
        //cs0.TYPE = 'Unfunded PO';
        cs0.SALES_ORDER_NUM = '12345678';
        cs0.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';
        cs0.QUOTATION_NUMBER = '21323434';
        cs0.CUST_EMAIL_ADDR = 'harikishore.vutukuri@honeywell.com'; 
        cs0.UFR_PRICING_AMT = 23.55;
        cs0.PRODUCT_SERIAL_NUM = '50001313';
        cs0.SUBJECT = 'test';
        cs0.DESCRIPTION = 'UFR/Standard Price Amount $ ';
        cs0.PRODUCT_NUM = 'YD156';
        cs0.SAP_PLANT_CODE = '4144';
        string caseno0 = cs1[1].Case_object__r.casenumber.replaceAll('CASE-', '');
        cs0.SAP_SITE_CODE = caseno0;
        cs0.NOTIFICATION_NUMBER = '498764654';
        cs0.AttBody = 'Test atta';
        cs0.AttFileName = 'test.txt';
        cs0.AttContentType = 'test';
        cs0.UFR_SBU = 'BGA';        
        try{
        UFRPricing_CaseSAPtoSFDC.CaseDataSFDCtoSAP sfdcdata0 = UFRPricing_CaseSAPtoSFDC.createCase(cs0);
        }catch(DMLException e){}
        string UFRSBU1='BGA';
        Test.stopTest();
    }
}