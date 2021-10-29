/**********************************************************************************
Name         : ROI_ShippingProcess_InterfaceTest
Created By   : Harikishore V
Company Name : NTTData
Project      : <R&O Integration>
Created Date : 16-Aug-2016
Usages       : Test Class for ROI_ShippingProcess_SourceInspection & ROI_ShippingProcess_ReportRequest classes           
***********************************************************************************/
@isTest(SeeAllData=true)
global class ROI_ShippingProcess_InterfaceTest{ 
    testMethod static void ROI_ShippingProcess_InterfaceTest(){
        List<Case> c = [SELECT id,CaseNumber from Case where RecordtypeId=:Label.Repair_Overhaul_RT_ID and CreatedById=:Label.DeniedPartyScreening_APIUser_ID and Status = 'Open' and Classification__c = 'R&O Issue' limit 2];
        Test.startTest();
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs.CASE_NUMBER = c[0].CaseNumber;  
        cs.DELIVERY_NUMBER = '8000005163';   
        cs.CUSTOMER_EMAIL_ID = 'test@test.com';
        cs.DELIVERY_CREATEDBY = 'H139990';
        cs.DELIVERY_CREATED_ON = '7/28/2016';   
        cs.DELIVERY_PERSON_EMAIL_ID = 'ROItest@test.com'; 
        cs.CUSTOMER_NUMBER = '0000300038';
        cs.DISTRIBUTION_CHANNEL = '01';
        cs.SALES_ORDER_NUMBER = '0000046235';
        cs.CONTRACTOR = 'Phoenix - Sky Harbor';
        cs.REQUESTED_BY = 'H139990';
        cs.CAGE_CODE = '071H8';
        cs.PURCHASE_ORDER_NUMBER = 'UJ72816';
        cs.PART_NUMBER = '500000000000222148';
        cs.REQUESTED_BY_TELEPHONE = 'Honeywell Aerospace ERP Develo,';
        cs.PART_DESCRIPTION = 'Gasturbine 131-9A';
        cs.ADDRESS_LOCATION_BLDG_NUMBER = '1944 E Sky Harbor Circle,PHOENIX,85034';
        cs.DELIVERY_CREATION_TIME = '000000';
        cs.CONTRACTOR_PROCEDURE_PERFORM_GSI = 'OUTBOUND SHIPPING';
        cs.NUMBER_PRESENTED = '1';
        ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata = ROI_ShippingProcess_SourceInspection.updateCase(cs);
        
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs2 = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs2.CASE_NUMBER = 'CASE-'; 
        cs2.DELIVERY_CREATED_ON = '7/28/2016';
        cs2.NUMBER_PRESENTED = '1';
        ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata2 = ROI_ShippingProcess_SourceInspection.updateCase(cs2);
                
        ROI_ShippingProcess_ReportRequest.SAPDataToSFDC rr = new ROI_ShippingProcess_ReportRequest.SAPDataToSFDC();
        rr.WORK_STREAM = 'Shipping Process';
        rr.EMAIL_TYPE = 'Source Inspection';
        rr.START_DATE = '2016-07-27';
        rr.END_DATE = '2016-07-28';
        ROI_ShippingProcess_ReportRequest.ResponseToSAP sfdcdatarr = ROI_ShippingProcess_ReportRequest.sendROIOrders(rr);
        
        ROI_ShippingProcess_ReportRequest.SAPDataToSFDC rr1 = new ROI_ShippingProcess_ReportRequest.SAPDataToSFDC();
        rr1.WORK_STREAM = 'Shipping Process';
        rr1.EMAIL_TYPE = 'Source';
        rr1.START_DATE = '2016-07-27';
        rr1.END_DATE = '2016-07-28';
        ROI_ShippingProcess_ReportRequest.ResponseToSAP sfdcdatarr1 = ROI_ShippingProcess_ReportRequest.sendROIOrders(rr1);
        
        ROI_ShippingProcess_ReportRequest.SAPDataToSFDC rr2 = new ROI_ShippingProcess_ReportRequest.SAPDataToSFDC();
        rr2.WORK_STREAM = null;
        rr2.EMAIL_TYPE = 'Source';
        rr2.START_DATE = '2016-07-27';
        rr2.END_DATE = '2016-07-28';
        ROI_ShippingProcess_ReportRequest.ResponseToSAP sfdcdatarr2 = ROI_ShippingProcess_ReportRequest.sendROIOrders(rr2);
        Test.stopTest();        
    }
    testMethod static void ROI_ShippingProcess_InterfaceTest1(){
        List<Case> c = [SELECT id,CaseNumber from Case where RecordtypeId=:Label.Repair_Overhaul_RT_ID and CreatedById=:Label.DeniedPartyScreening_APIUser_ID and Status = 'Open' and Classification__c = 'R&O Issue' ORDER BY CaseNumber DESC limit 3];
        Test.startTest();
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs3 = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs3.CASE_NUMBER = c[0].CaseNumber;  
        cs3.DELIVERY_NUMBER = '8000005163';   
        cs3.CUSTOMER_EMAIL_ID = 'ROItest@test.com';
        cs3.DELIVERY_CREATEDBY = 'H139990';
        cs3.DELIVERY_CREATED_ON = '7/28/2016';   
        cs3.DELIVERY_PERSON_EMAIL_ID = null; 
        cs3.TYPE_OF_SOURCE_INSPECTION = '';
        cs3.CUSTOMER_NUMBER = null;
        cs3.CUSTOMER_NAME = '';
        cs3.DISTRIBUTION_CHANNEL = '02';
        cs3.SALES_ORDER_NUMBER = '0000046235';
        cs3.CONTRACTOR = 'Phoenix - Sky Harbor';
        cs3.REQUESTED_BY = 'H139990';
        cs3.CAGE_CODE = '071H8';
        cs3.CONTRACT_NUMBER = '';
        cs3.PURCHASE_ORDER_NUMBER = 'UJ72816';
        cs3.PART_NUMBER = '500000000000222148';
        cs3.SHIPMENT_NUMBER = '';
        cs3.SERIAL_NUMBER = '';
        cs3.CLIN = '';
        cs3.PLANT_CODE = '1014';
        cs3.REQUESTED_BY_TELEPHONE = 'Honeywell Aerospace ERP Develo,';
        cs3.PART_DESCRIPTION = 'Gasturbine 131-9A';
        cs3.ADDRESS_LOCATION_BLDG_NUMBER = '1944 E Sky Harbor Circle,PHOENIX,85034';
        cs3.DELIVERY_CREATION_TIME = '000000';
        cs3.CONTRACTOR_PROCEDURE_PERFORM_GSI = 'OUTBOUND SHIPPING';
        cs3.DATETIME_PRODUCT_AVAILABLE = '';
        cs3.EXAMINATION_TYPE_REQUESTED = '';
        cs3.NUMBER_PRESENTED = '1';
        cs3.HEADER_INFO = '';
        ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata3 = ROI_ShippingProcess_SourceInspection.updateCase(cs3);
        
        Z_Task__c z = new Z_Task__c();
        z.Type__c = 'Z107 Order Information Required';
        z.RelatedTo__c = c[1].id;
        z.Long_Text__c = 'test';
        insert z;
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs4 = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs4.CASE_NUMBER = c[1].CaseNumber; 
        cs4.DELIVERY_CREATED_ON = '7/28/2016';
        cs4.NUMBER_PRESENTED = '1';
        cs4.DELIVERY_PERSON_EMAIL_ID = '';
        cs4.CUSTOMER_EMAIL_ID = '';     
        ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata4 = ROI_ShippingProcess_SourceInspection.updateCase(cs4);  
        Test.stopTest();        
    }
    testMethod static void ROI_ShippingProcess_InterfaceTest2(){
        List<Case> c = [SELECT id,CaseNumber from Case where RecordtypeId=:Label.Repair_Overhaul_RT_ID and CreatedById=:Label.DeniedPartyScreening_APIUser_ID and Status = 'Open' and Classification__c = 'R&O Issue' limit 3];
        Test.startTest();
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs1 = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs1.CASE_NUMBER = c[1].CaseNumber;  
        cs1.DELIVERY_NUMBER = '8000005163';   
        cs1.CUSTOMER_EMAIL_ID = null;
        cs1.DELIVERY_CREATEDBY = 'H139990';
        cs1.DELIVERY_CREATED_ON = '7/28/2016';   
        cs1.DELIVERY_PERSON_EMAIL_ID = 'ROItest@test.com'; 
        cs1.DISTRIBUTION_CHANNEL = '02';
        cs1.SALES_ORDER_NUMBER = '0000046235';
        cs1.CONTRACTOR = 'Phoenix - Sky Harbor';
        cs1.REQUESTED_BY = 'H139990';
        cs1.CAGE_CODE = '071H8';
        cs1.CONTRACT_NUMBER = '';
        cs1.PURCHASE_ORDER_NUMBER = 'UJ72816';
        cs1.PART_NUMBER = '500000000000222148';
        cs1.SHIPMENT_NUMBER = '55';
        cs1.SERIAL_NUMBER = '23';
        cs1.CLIN = '123';
        cs1.REQUESTED_BY_TELEPHONE = 'Honeywell Aerospace ERP Develo,';
        cs1.PART_DESCRIPTION = 'Gasturbine 131-9A';
        cs1.ADDRESS_LOCATION_BLDG_NUMBER = '1944 E Sky Harbor Circle,PHOENIX,85034';
        cs1.DELIVERY_CREATION_TIME = '000000';
        cs1.CONTRACTOR_PROCEDURE_PERFORM_GSI = 'OUTBOUND SHIPPING';
        cs1.NUMBER_PRESENTED = '2';
        ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata1 = ROI_ShippingProcess_SourceInspection.updateCase(cs1);
        
        Z_Task__c zt = new Z_Task__c();
        zt.Type__c = 'Z107 Order Information Required';
        zt.RelatedTo__c = c[2].id;
        zt.Long_Text__c = null;
        zt.New_Long_Text__c = '';
        zt.Event_Type__c = 'TASK CREATION';
        zt.Status__c = 'Open';
        insert zt;
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs4 = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs4.CASE_NUMBER = c[2].CaseNumber; 
        cs4.DELIVERY_CREATED_ON = '7/28/2016';
        cs4.NUMBER_PRESENTED = '1';
        cs4.DELIVERY_PERSON_EMAIL_ID = null;
        cs4.CUSTOMER_EMAIL_ID = null;     
        ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata4 = ROI_ShippingProcess_SourceInspection.updateCase(cs4);      
        
        ROI_ShippingProcess_SourceInspection.SAPDataToSFDC cs5 = new ROI_ShippingProcess_SourceInspection.SAPDataToSFDC();
        cs5.CASE_NUMBER = c[0].CaseNumber; 
        cs5.DELIVERY_CREATED_ON = '7/29/2016';
        cs5.NUMBER_PRESENTED = '2';
        cs5.DELIVERY_PERSON_EMAIL_ID = '';
        cs5.CUSTOMER_EMAIL_ID = '';     
        //ROI_ShippingProcess_SourceInspection.ResponseToSAP sfdcdata5 = ROI_ShippingProcess_SourceInspection.updateCase(cs5);      
        Test.stopTest();        
    }
}