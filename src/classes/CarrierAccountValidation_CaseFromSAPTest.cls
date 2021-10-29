/*******************************************************************************
Name         : CarrierAccountValidation_CaseFromSAPTest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Carrier Account Validation> 
Created Date : 18-Feb-2016
Usages       : Test Class for CarrierAccountValidation_CaseFromSAP        
*******************************************************************************/
@isTest(SeeAllData=true)
global class CarrierAccountValidation_CaseFromSAPTest{ 
    testMethod static void CarrierAccountValidation_CaseFromSAPTest(){
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = '123466';
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'MULTIPLE';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '523555'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'harikishore.vutukuri@honeywell.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest1(){
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = '123466';
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'INVALID';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '300075'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'harikishore.vutukuri@nttdata.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest2(){
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = '123466';
        cs.SALES_ORDER_TYPE = 'ZRPR1';
        cs.SUBJECT = 'MISSING SPI';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '523555'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'harikishore.vutukuri@honeywell.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs1 = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs1.CASE_NUMBER = '123466';
        cs1.SALES_ORDER_TYPE = 'ZRPR1';
        cs1.SUBJECT = 'MISSING CC';
        cs1.DESCRIPTION = '04/20/2016';
        cs1.ACCOUNT_NAME = '523555'; 
        cs1.SALES_ORDER_NUMBER = '50001313';
        cs1.CUSTOMER_PO = 'PO13';
        cs1.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs1.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs1.MATERIAL_NUMBER = '4144';
        cs1.CUSTOMER_EMAIL = 'harikishore.vutukuri@honeywell.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata1 = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs1);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest3(){
        String Casenumber = [select CaseNumber from Case where Recordtypeid=:label.Repair_Overhaul_RT_ID limit 1].CaseNumber;
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = '123466';
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'BLOCKED CC';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '523555'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'robert.p.lambert@uscg.mil';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs1 = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs1.CASE_NUMBER = Casenumber;
        cs1.SALES_ORDER_TYPE = 'ZRPR';
        cs1.SUBJECT = 'BLOCKED CC';
        cs1.DESCRIPTION = '04/20/2016';
        cs1.ACCOUNT_NAME = '300075'; 
        cs1.SALES_ORDER_NUMBER = '50001313';
        cs1.CUSTOMER_PO = 'PO13';
        cs1.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs1.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs1.MATERIAL_NUMBER = '4144';
        cs1.CUSTOMER_EMAIL = 'harikishore.vutukuri@nttdata.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata1 = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs1);
        Test.stopTest();
    }  
    testMethod static void CarrierAccountValidation_CaseFromSAPTest4(){
        String Casenumber = [select CaseNumber from Case where ContactId=null and Recordtypeid=:label.Repair_Overhaul_RT_ID limit 1].CaseNumber;
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = '123466';
        cs.SALES_ORDER_TYPE = 'ZRPR1';
        cs.SUBJECT = 'BLOCKED CC';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '0005200'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'harikishore.vutukuri@honeywell.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs1 = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs1.CASE_NUMBER = Casenumber;
        cs1.SALES_ORDER_TYPE = 'ZRPR';
        cs1.SUBJECT = 'INVALID';
        cs1.DESCRIPTION = '04/20/2016';
        cs1.ACCOUNT_NAME = '0005200'; 
        cs1.SALES_ORDER_NUMBER = '50001313';
        cs1.CUSTOMER_PO = 'PO13';
        cs1.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs1.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs1.MATERIAL_NUMBER = '4144';
        cs1.CUSTOMER_EMAIL = 'harikishore.vutukuri@honeywell.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata1 = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs1);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest5(){
        String Casenumber = [select CaseNumber from Case where ContactId!=null and Recordtypeid=:label.Repair_Overhaul_RT_ID limit 1].CaseNumber;
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = Casenumber;
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'INVALID';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '0005200'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'harikishore.vutukuri@honeywell.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest6(){
        List<Case> Cas = [select CaseNumber from Case where ContactId=:label.UFR_Cont_Id and Recordtypeid=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = Cas[0].CaseNumber;
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'INVALID';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '0005200'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'support@salesforce.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs1 = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs1.CASE_NUMBER = Cas[1].CaseNumber;
        cs1.SALES_ORDER_TYPE = 'ZRPR';
        cs1.SUBJECT = 'MISSING SPI';
        cs1.DESCRIPTION = '04/20/2016';
        cs1.ACCOUNT_NAME = '0005200'; 
        cs1.SALES_ORDER_NUMBER = '50001313';
        cs1.CUSTOMER_PO = 'PO13';
        cs1.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs1.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs1.MATERIAL_NUMBER = '4144';
        cs1.CUSTOMER_EMAIL = 'support@salesforce.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata1 = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs1);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest7(){
        List<Case> Cas = [select CaseNumber from Case where ContactId=:label.UFR_Cont_Id and Recordtypeid=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = Cas[0].CaseNumber;
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'MULTIPLE';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '0005200'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'support@salesforce.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs1 = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs1.CASE_NUMBER = Cas[1].CaseNumber;
        cs1.SALES_ORDER_TYPE = 'ZRPR';
        cs1.SUBJECT = 'MISSING CC';
        cs1.DESCRIPTION = '04/20/2016';
        cs1.ACCOUNT_NAME = '0005200'; 
        cs1.SALES_ORDER_NUMBER = '50001313';
        cs1.CUSTOMER_PO = 'PO13';
        cs1.SOLD_TO_CUSTOMER_NUMBER = '123';
        cs1.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs1.MATERIAL_NUMBER = '4144';
        cs1.CUSTOMER_EMAIL = 'support@salesforce.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata1 = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs1);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest8(){
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = '123466';
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'testing';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '300075'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '300075';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '0001';
        cs.CUSTOMER_EMAIL = '';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        Test.stopTest();
    }
    testMethod static void CarrierAccountValidation_CaseFromSAPTest9(){
        List<Case> Cas = [select CaseNumber from Case where ContactId=null and AccountId=null and Recordtypeid=:label.Repair_Overhaul_RT_ID limit 2];
        Test.startTest();
        CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC cs = new CarrierAccountValidation_CaseFromSAP.SAPDataToSFDC();
        cs.CASE_NUMBER = Cas[0].CaseNumber;
        cs.SALES_ORDER_TYPE = 'ZRPR';
        cs.SUBJECT = 'MULTIPLE';
        cs.DESCRIPTION = '04/20/2016';
        cs.ACCOUNT_NAME = '0005200'; 
        cs.SALES_ORDER_NUMBER = '50001313';
        cs.CUSTOMER_PO = 'PO13';
        cs.SOLD_TO_CUSTOMER_NUMBER = '0012300';
        cs.SOLD_TO_CUSTOMER_NAME = 'Test';
        cs.MATERIAL_NUMBER = '4144';
        cs.CUSTOMER_EMAIL = 'support@salesforce.com';
        CarrierAccountValidation_CaseFromSAP.ResponseToSAP sfdcdata = CarrierAccountValidation_CaseFromSAP.createorupdateCase(cs);
        Test.stopTest();
    }
}